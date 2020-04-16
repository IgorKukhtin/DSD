-- Function: gpInsertUpdate_Object_MarginCategory_PesentSalary ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory_PesentSalary (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategory_PesentSalary(
    IN inRetailId           Integer,    -- торговя сеть
    IN inOperDate           TDateTime,  -- Дата действия %
    IN inPesentSalary       TFloat,     -- % фонда зп
    IN inSession            TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
    DECLARE vbId            Integer;
    DECLARE vbPesentSalary   TFloat;
    DECLARE vbDateChange    TDateTime;
BEGIN

    -- проверка
    IF COALESCE (inRetailId, 0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбрана торг.сеть';
    END IF;

    -- Если такая запись есть - достаем её ключу торг.сеть - дата - значение  
    SELECT ObjectHistory.Id
    INtO vbId 
      FROM ObjectHistory
      INNER JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PesentSalary_Value
                                    ON ObjectHistoryFloat_PesentSalary_Value.ObjectHistoryId = ObjectHistory_PesentSalary.Id
                                   AND ObjectHistoryFloat_PesentSalary_Value.DescId = zc_ObjectHistoryFloat_PesentSalary_Value()
                                   AND ObjectHistoryFloat_PesentSalary_Value.ValueData = inPesentSalary
      WHERE ObjectHistory.ObjectId = inRetailId
        AND ObjectHistory.DescId = zc_ObjectHistory_PesentSalary()
        AND ObjectHistory.StartDate  = inOperDate
      ;

    -- повторно не сохраняем, только если значение новое
    IF COALESCE(vbId,0) = 0
    THEN
        -- сохранили значение в историю
        PERFORM gpInsertUpdate_ObjectHistory_PesentSalary (ioId           := 0                :: Integer
                                                         , inRetailId     := inRetailId       :: Integer
                                                         , inOperDate     := inOperDate       :: TDateTime
                                                         , inPesentSalary := inPesentSalary   :: TFloat
                                                         , inSession      := inSession        :: TVarChar
                                                          );
    END IF;
    
    -- далее на введенный % фонда ЗП изменяем % наценки
    -- ко все кат. по торг. сети + процент зп
    -- выбираем все кат. наценок и их значения
    CREATE TEMP TABLE _tmpMarginCategoryItem (MarginCategoryId Integer, MarginCategoryItemId Integer, Value TFloat, minPrice TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMarginCategoryItem (MarginCategoryId, MarginCategoryItemId, Value, minPrice)
      WITH
      tmpMarginCategory AS (SELECT DISTINCT 
                                    tmpMarginCategoryLink.MarginCategoryId
                                  , tmpMarginCategoryLink.MarginCategoryName
                                  , tmpMarginCategoryLink.JuridicalName_our AS JuridicalName
                                  , tmpMarginCategoryLink.UnitId
                                  , tmpMarginCategoryLink.UnitName
                                  , tmpMarginCategoryLink.RetailName
                                  , Object_ProvinceCity.ValueData  AS ProvinceCityName
                            FROM gpSelect_Object_MarginCategoryLink (inShowAll := FALSE, inSession := '3') AS tmpMarginCategoryLink
                                                      
                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                             ON ObjectLink_Unit_ProvinceCity.ObjectId = tmpMarginCategoryLink.UnitId
                                            AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                                 LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
                            
                            WHERE tmpMarginCategoryLink.MarginCategoryId Not in (1327351, 1599495)   --"ПЕРЕОЦЕНКА ПО ВСЕЙ СЕТИ", "Для Сайта по Украине"
                               AND tmpMarginCategoryLink.RetailId = inRetailId
                   )

     -- все данные  
     SELECT tmpMarginCategory.MarginCategoryId   AS MarginCategoryId
          , tmpMarginCategoryItem.Id             AS MarginCategoryItemId 
          , tmpMarginCategoryItem.MarginPercent  AS Value 
          , tmpMarginCategoryItem.minPrice       AS minPrice
     FROM tmpMarginCategory 
          LEFT JOIN  (SELECT MAX (Object_MarginCategoryItem.Id)  AS Id
                           , Object_MarginCategoryItem.MarginCategoryId
                           , CAST (Object_MarginCategoryItem.MarginPercent AS NUMERIC (16,2)) AS MarginPercent
                           , Object_MarginCategoryItem.minPrice
                      FROM Object_MarginCategoryItem_View AS Object_MarginCategoryItem
                          INNER JOIN Object ON Object.Id = Object_MarginCategoryItem.Id
                                           AND Object.isErased = FALSE
                      GROUP BY Object_MarginCategoryItem.MarginCategoryId
                             , Object_MarginCategoryItem.MarginPercent
                             , Object_MarginCategoryItem.minPrice
                      ) AS tmpMarginCategoryItem
                        ON tmpMarginCategoryItem.MarginCategoryId = _tmpMarginCategory.MarginCategoryId
     -- для проверки для 1 категории 1 подразделения 
     WHERE tmpMarginCategory.UnitId = 183292             -- Аптека Правда 6
       AND tmpMarginCategory.MarginCategoryId = 10542059 --"Аптека Правда 6 ВЕНТА - 0,75%"
     ;
    
    -- добавляем к % наценки Процент фонда зп
    PERFORM gpInsertUpdate_Object_MarginCategoryItem(inId               := _tmpMarginCategoryItem.MarginCategoryItemId
                                                   , inMinPrice         := _tmpMarginCategoryItem.minPrice                   ::TFloat 
                                                   , inMarginPercent    := (COALESCE (_tmpMarginCategoryItem.Value,0) + COALESCE (inPesentSalary,0)) ::TFloat 
                                                   , inMarginCategoryId := _tmpMarginCategoryItem.MarginCategoryId
                                                   , inSession          := inSession    ::TVarChar
                                                   )
    FROM _tmpMarginCategoryItem;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 16.04.20         *
*/
