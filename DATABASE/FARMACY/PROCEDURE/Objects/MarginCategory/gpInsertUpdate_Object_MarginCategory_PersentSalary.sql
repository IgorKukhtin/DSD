-- Function: gpInsertUpdate_Object_MarginCategory_PersentSalary ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory_PersentSalary (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategory_PersentSalary(
    IN inRetailId           Integer,    -- торговя сеть
    IN inOperDate           TDateTime,  -- Дата действия %
    IN inPersentSalary       TFloat,     -- % фонда зп
    IN inSession            TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
    DECLARE vbId            Integer;
    DECLARE vbPersentSalary TFloat;
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
      INNER JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PersentSalary_Value
                                    ON ObjectHistoryFloat_PersentSalary_Value.ObjectHistoryId = ObjectHistory.Id
                                   AND ObjectHistoryFloat_PersentSalary_Value.DescId = zc_ObjectHistoryFloat_PersentSalary_Value()
                                   AND ObjectHistoryFloat_PersentSalary_Value.ValueData = inPersentSalary
      WHERE ObjectHistory.ObjectId = inRetailId
        AND ObjectHistory.DescId = zc_ObjectHistory_PersentSalary()
        AND ObjectHistory.StartDate  = inOperDate
      ;

     -- определяем предыдущее значение % ФЗП
     SELECT ObjectHistoryFloat_PersentSalary_Value.ValueData
    INtO vbPersentSalary
      FROM ObjectHistory
      INNER JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PersentSalary_Value
                                    ON ObjectHistoryFloat_PersentSalary_Value.ObjectHistoryId = ObjectHistory.Id
                                   AND ObjectHistoryFloat_PersentSalary_Value.DescId = zc_ObjectHistoryFloat_PersentSalary_Value()
      WHERE ObjectHistory.ObjectId = inRetailId
        AND ObjectHistory.DescId = zc_ObjectHistory_PersentSalary()
        AND ObjectHistory.StartDate <= inOperDate
        AND ObjectHistory.EndDate   >= inOperDate
      ;
      
    -- повторно не сохраняем, только если значение новое
    IF COALESCE(vbId,0) = 0
    THEN
        -- сохранили значение в историю
        PERFORM gpInsertUpdate_ObjectHistory_PersentSalary (ioId            := 0                :: Integer
                                                          , inRetailId      := inRetailId       :: Integer
                                                          , inOperDate      := inOperDate       :: TDateTime
                                                          , inPersentSalary := inPersentSalary  :: TFloat
                                                          , inSession       := inSession        :: TVarChar
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
                                  , tmpMarginCategoryLink.UnitId
                            FROM gpSelect_Object_MarginCategoryLink (inShowAll := FALSE, inSession := inSession) AS tmpMarginCategoryLink
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
                        ON tmpMarginCategoryItem.MarginCategoryId = tmpMarginCategory.MarginCategoryId
     -- для проверки для 1 категории 1 подразделения 
    -- WHERE tmpMarginCategory.UnitId = 183292             -- Аптека Правда 6
    --   AND tmpMarginCategory.MarginCategoryId = 10542059 --"Аптека Правда 6 ВЕНТА - 0,75%"
     ;

    
    -- добавляем к % наценки Процент фонда зп   (предыдущий отнимаем, чтоб не получилось что накапливается)
    PERFORM gpInsertUpdate_Object_MarginCategoryItem(inId               := _tmpMarginCategoryItem.MarginCategoryItemId       :: Integer
                                                   , inMinPrice         := _tmpMarginCategoryItem.minPrice                   :: TFloat 
                                                   , inMarginPercent    := (COALESCE (_tmpMarginCategoryItem.Value,0) - COALESCE (vbPersentSalary,0) + COALESCE (inPersentSalary,0)) ::TFloat 
                                                   , inMarginCategoryId := _tmpMarginCategoryItem.MarginCategoryId           :: Integer
                                                   , inSession          := inSession                                         ::TVarChar
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
