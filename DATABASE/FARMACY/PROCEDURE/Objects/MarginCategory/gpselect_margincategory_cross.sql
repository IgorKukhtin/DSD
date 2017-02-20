DROP FUNCTION IF EXISTS gpselect_margincategory_cross(TVarChar);

CREATE OR REPLACE FUNCTION gpselect_margincategory_cross(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor; 
          cur2 refcursor; 
          vbIndex Integer;
          vbCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbFieldNameText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

  -- определяем список аптек для просмотра категорий
  CREATE TEMP TABLE _tmpMarginCategoryList (MarginCategoryId integer, MarginCategoryName TVarChar) ON COMMIT DROP;
     INSERT INTO _tmpMarginCategoryList (MarginCategoryId, MarginCategoryName)
                               SELECT Object_MarginCategory.Id         AS MarginCategoryId
                                    , Object_MarginCategory.ValueData  AS MarginCategoryName
                               FROM  Object AS Object_MarginCategory
                                     Left JOIN ObjectFloat AS ObjectFloat_Percent 	
                                            ON Object_MarginCategory.Id = ObjectFloat_Percent.ObjectId
                                           AND ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()
                               WHERE Object_MarginCategory.DescId = zc_Object_MarginCategory()
                                 AND Object_MarginCategory.isErased = FALSE
                                 AND COALESCE (ObjectFloat_Percent.ValueData ,0) = 0;

  
  CREATE TEMP TABLE _tmpMarginCategory (MarginCategoryId integer, MarginCategoryName TVarChar, JuridicalName TVarChar) ON COMMIT DROP; /*tmpMI */
     INSERT INTO _tmpMarginCategory (MarginCategoryId, MarginCategoryName, JuridicalName)
              SELECT Object_MarginCategoryLink_View.MarginCategoryId
                   , _tmpMarginCategoryList.MarginCategoryName
                   , MAX (Object_Juridical.ValueData)       AS JuridicalName
              FROM Object_MarginCategoryLink_View 
                   INNER JOIN (SELECT ObjectBoolean_MarginCategory.ObjectId AS UnitId
                               FROM ObjectBoolean AS ObjectBoolean_MarginCategory
                               WHERE ObjectBoolean_MarginCategory.DescId = zc_ObjectBoolean_Unit_MarginCategory()
                                 AND ObjectBoolean_MarginCategory.ValueData = TRUE
                               ) AS tmpUnit ON tmpUnit.UnitId = Object_MarginCategoryLink_View.UnitId
                   INNER JOIN _tmpMarginCategoryList ON _tmpMarginCategoryList.MarginCategoryId = Object_MarginCategoryLink_View.MarginCategoryId

                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                        ON ObjectLink_Unit_Juridical.ObjectId = tmpUnit.UnitId
                                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

              WHERE Object_MarginCategoryLink_View.MarginCategoryId Not in (1327351, 1599495)   --"ПЕРЕОЦЕНКА ПО ВСЕЙ СЕТИ", "Для Сайта по Украине"
              GROUP BY Object_MarginCategoryLink_View.MarginCategoryId
                   , _tmpMarginCategoryList.MarginCategoryName
              ORDER BY 1;
            

                              /*SELECT Object_MarginCategory.Id         AS MarginCategoryId
                                    , Object_MarginCategory.ValueData  AS MarginCategoryName
                               FROM  Object AS Object_MarginCategory
                                     Left JOIN ObjectFloat AS ObjectFloat_Percent 	
                                            ON Object_MarginCategory.Id = ObjectFloat_Percent.ObjectId
                                           AND ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()
                               WHERE Object_MarginCategory.DescId = zc_Object_MarginCategory()
                                 AND Object_MarginCategory.isErased = FALSE
                                 AND COALESCE (ObjectFloat_Percent.ValueData ,0) = 0
                               ORDER by 1*/

     -- 
  CREATE TEMP TABLE _tmpminPrice (minPrice TFloat, Num integer) ON COMMIT DROP; 
     INSERT INTO _tmpminPrice (minPrice, Num)
                SELECT tmp.minPrice
                     , ROW_NUMBER() OVER (ORDER BY tmp.MinPrice)  ::integer      AS Num
                FROM (
                     SELECT DISTINCT ObjectFloat_MinPrice.ValueData AS minPrice 
                     FROM ObjectFloat AS ObjectFloat_MinPrice
                     WHERE ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                     ) AS tmp;

     -- все данные  
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            SELECT _tmpMarginCategory.MarginCategoryId 
                 , _tmpminPrice.num AS Num
                 , _tmpMarginCategory.MarginCategoryId AS ObjectId 
                 , tmpMarginCategoryItem.Id AS Object1Id 
                 , tmpMarginCategoryItem.MarginPercent  AS ShortName 
                 ,  avg(tmpMarginCategoryItem.MarginPercent) OVER (ORDER BY  _tmpminPrice.num)  AS avgPercent 
            FROM _tmpMarginCategory 
                    LEFT JOIN  (SELECT MAX (Object_MarginCategoryItem.Id)      AS Id
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
                    LEFT JOIN _tmpminPrice ON _tmpminPrice.minPrice = tmpMarginCategoryItem.minPrice
            ORDER BY _tmpMarginCategory.MarginCategoryId, _tmpminPrice.num
           
     ;

     vbIndex := 0;
     -- кол-во категорий наценок 
     vbCount := (SELECT COUNT(*) FROM _tmpMarginCategory);


     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < vbCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]'; 
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1] :: TFloat AS Value'||vbIndex||'  '||
                          ', DAY' || vbIndex || '[2]::Integer  AS MarginCategoryId'||vbIndex||' '||
                          ', DAY' || vbIndex || '[3]::Integer  AS MarginCategoryItemId'||vbIndex||' ';
     END LOOP;

     OPEN cur1 FOR SELECT _tmpMarginCategory.MarginCategoryId, 
                          ( _tmpMarginCategory.JuridicalName|| ', '||_tmpMarginCategory.MarginCategoryName )  ::TVarChar AS ValueField
               FROM _tmpMarginCategory
               ORDER by 1
     ;  
     RETURN NEXT cur1;


     vbQueryText := '
          SELECT _tmpminPrice.Num       AS Num
               , _tmpminPrice.minPrice  AS minPrice
               , CAST (tmp.avgPercent AS NUMERIC (16,2)) AS avgPercent
               '|| vbFieldNameText ||'
          FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[COALESCE (tmpData.Num, Object_Data.Num)     
                                                ] :: Integer[]
                                         , COALESCE (tmpData.MarginCategoryId, Object_Data.MarginCategoryId) AS MarginCategoryId
                                         , ARRAY[ tmpData.ShortName :: VarChar
                                               , COALESCE (tmpData.ObjectId, 0) :: VarChar
                                               , COALESCE (tmpData.Object1Id, 0) :: VarChar
                                                ] :: TVarChar
                                    FROM (SELECT * FROM tmpMI) AS tmpData
                                        FULL JOIN  
                                         (SELECT _tmpMarginCategory.MarginCategoryId, 0, 
                                                 _tmpminPrice.Num AS Num
                                          FROM _tmpMarginCategory, _tmpminPrice
                                      ) AS Object_Data
                                           ON Object_Data.MarginCategoryId = tmpData.MarginCategoryId
                                          AND Object_Data.Num = tmpData.Num
      
                                  order by 1,2''
                                , ''SELECT _tmpMarginCategory.MarginCategoryId FROM _tmpMarginCategory order by 1
                                  ''
                                ) AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN _tmpminPrice ON _tmpminPrice.Num = D.Key[1]
         LEFT JOIN (SELECT DISTINCT tmpMI.Num AS Num, tmpMI.avgPercent FROM tmpMI ) AS tmp ON tmp.Num = _tmpminPrice.Num
        ';


     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpselect_margincategory_cross (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.01.16         * 
*/