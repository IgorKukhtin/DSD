--
DROP FUNCTION IF EXISTS gpSelect_MarginCategory_All(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MarginCategory_All(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Cursor1 refcursor; 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     OPEN Cursor1 FOR

 WITH
      _tmpMarginCategory AS (SELECT DISTINCT 
                                    tmpMarginCategoryLink.MarginCategoryId
                                  , tmpMarginCategoryLink.MarginCategoryName
                                  , tmpMarginCategoryLink.JuridicalName_our AS JuridicalName
                                  , tmpMarginCategoryLink.UnitId
                                  , tmpMarginCategoryLink.UnitName
                                  , tmpMarginCategoryLink.RetailId
                                  , tmpMarginCategoryLink.RetailName
                                  , Object_ProvinceCity.ValueData  AS ProvinceCityName
                            FROM gpSelect_Object_MarginCategoryLink (inShowAll := FALSE, inSession := '3') AS tmpMarginCategoryLink
                                                      
                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                             ON ObjectLink_Unit_ProvinceCity.ObjectId = tmpMarginCategoryLink.UnitId
                                            AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                                 LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
                            
                            WHERE tmpMarginCategoryLink.MarginCategoryId Not in (1327351, 1599495)   --"ПЕРЕОЦЕНКА ПО ВСЕЙ СЕТИ", "Для Сайта по Украине"
                   )

   , _tmpminPrice AS (SELECT tmp.minPrice
                           , ROW_NUMBER() OVER (ORDER BY tmp.MinPrice)  ::integer      AS Num
                      FROM (
                           SELECT DISTINCT ObjectFloat_MinPrice.ValueData AS minPrice 
                           FROM ObjectFloat AS ObjectFloat_MinPrice
                                INNER join Object ON Object.Id = ObjectFloat_MinPrice.ObjectId
                                                 AND Object.IsErased = FALSE
                           WHERE ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                             AND ObjectFloat_MinPrice.ValueData IN (0, 100, 250, 350, 500, 1000, 2000)
                           ) AS tmp
                       )

     -- все данные  
   ,  tmpData AS (SELECT _tmpMarginCategory.MarginCategoryId
                       , _tmpMarginCategory.MarginCategoryName
                       , _tmpMarginCategory.JuridicalName
                       , _tmpMarginCategory.UnitId
                       , _tmpMarginCategory.UnitName
                       , _tmpMarginCategory.ProvinceCityName
                       , _tmpMarginCategory.RetailId
                       , _tmpMarginCategory.RetailName
                       , _tmpminPrice.num AS Num
                       , tmpMarginCategoryItem.Id AS MarginCategoryItemId 
                       , tmpMarginCategoryItem.MarginPercent  AS Value 
                       ,  avg(tmpMarginCategoryItem.MarginPercent) OVER (ORDER BY  _tmpminPrice.num)  AS avgPercent
                       , tmpMarginCategoryItem.minPrice
                  FROM _tmpMarginCategory 
                          LEFT JOIN  (SELECT MAX (Object_MarginCategoryItem.Id)  AS Id
                                           , Object_MarginCategoryItem.MarginCategoryId
                                           , CAST (Object_MarginCategoryItem.MarginPercent AS NUMERIC (16,2)) AS MarginPercent
                                           , Object_MarginCategoryItem.minPrice
                                     FROM Object_MarginCategoryItem_View AS Object_MarginCategoryItem
                                          INNER JOIN Object ON Object.Id = Object_MarginCategoryItem.Id
                                                           AND Object.isErased = FALSE
                                     WHERE Object_MarginCategoryItem.minPrice <> 300
                                     GROUP BY Object_MarginCategoryItem.MarginCategoryId
                                            , Object_MarginCategoryItem.MarginPercent
                                            , Object_MarginCategoryItem.minPrice
                                      ) AS tmpMarginCategoryItem
                                        ON tmpMarginCategoryItem.MarginCategoryId = _tmpMarginCategory.MarginCategoryId
                          LEFT JOIN _tmpminPrice ON _tmpminPrice.minPrice = tmpMarginCategoryItem.minPrice
                  ORDER BY _tmpMarginCategory.MarginCategoryId, _tmpminPrice.num
                 )


   , tmpDataAll AS (SELECT tmp.MarginCategoryId
                         , tmp.MarginCategoryName
                         , tmp.UnitId
                         , tmp.UnitName
                         , tmp.ProvinceCityName
                         , tmp.JuridicalName
                         , tmp.RetailId
                         , tmp.RetailName
                         , MAX (tmp.Id_1) AS Id_1
                         , MAX (tmp.Id_2) AS Id_2
                         , MAX (tmp.Id_3) AS Id_3
                         , MAX (tmp.Id_4) AS Id_4
                         , MAX (tmp.Id_5) AS Id_5
                         , MAX (tmp.Id_6) AS Id_6
                         , MAX (tmp.Id_7) AS Id_7

                         , MAX (tmp.Value_1) AS Value_1
                         , MAX (tmp.Value_2) AS Value_2
                         , MAX (tmp.Value_3) AS Value_3
                         , MAX (tmp.Value_4) AS Value_4
                         , MAX (tmp.Value_5) AS Value_5
                         , MAX (tmp.Value_6) AS Value_6
                         , MAX (tmp.Value_7) AS Value_7

                         , MAX (tmp.minPrice_1) AS minPrice_1
                         , MAX (tmp.minPrice_2) AS minPrice_2
                         , MAX (tmp.minPrice_3) AS minPrice_3
                         , MAX (tmp.minPrice_4) AS minPrice_4
                         , MAX (tmp.minPrice_5) AS minPrice_5
                         , MAX (tmp.minPrice_6) AS minPrice_6
                         , MAX (tmp.minPrice_7) AS minPrice_7
                         
                         , MAX (tmp.avgPercent) AS avgPercent
                   FROM (SELECT tmpData.MarginCategoryId
                              , tmpData.MarginCategoryName
                              , tmpData.UnitId
                              , tmpData.UnitName
                              , tmpData.ProvinceCityName
                              , tmpData.JuridicalName
                              , tmpData.RetailId
                              , tmpData.RetailName
                              , CASE WHEN tmpData.Num = 1 THEN tmpData.MarginCategoryItemId ELSE 0 END AS Id_1
                              , CASE WHEN tmpData.Num = 2 THEN tmpData.MarginCategoryItemId ELSE 0 END AS Id_2
                              , CASE WHEN tmpData.Num = 3 THEN tmpData.MarginCategoryItemId ELSE 0 END AS Id_3
                              , CASE WHEN tmpData.Num = 4 THEN tmpData.MarginCategoryItemId ELSE 0 END AS Id_4
                              , CASE WHEN tmpData.Num = 5 THEN tmpData.MarginCategoryItemId ELSE 0 END AS Id_5
                              , CASE WHEN tmpData.Num = 6 THEN tmpData.MarginCategoryItemId ELSE 0 END AS Id_6
                              , CASE WHEN tmpData.Num = 7 THEN tmpData.MarginCategoryItemId ELSE 0 END AS Id_7

                              , CASE WHEN tmpData.Num = 1 THEN tmpData.Value ELSE 0 END AS Value_1
                              , CASE WHEN tmpData.Num = 2 THEN tmpData.Value ELSE 0 END AS Value_2
                              , CASE WHEN tmpData.Num = 3 THEN tmpData.Value ELSE 0 END AS Value_3
                              , CASE WHEN tmpData.Num = 4 THEN tmpData.Value ELSE 0 END AS Value_4
                              , CASE WHEN tmpData.Num = 5 THEN tmpData.Value ELSE 0 END AS Value_5
                              , CASE WHEN tmpData.Num = 6 THEN tmpData.Value ELSE 0 END AS Value_6
                              , CASE WHEN tmpData.Num = 7 THEN tmpData.Value ELSE 0 END AS Value_7

                              , CASE WHEN tmpData.Num = 1 THEN tmpData.minPrice ELSE 0 END AS minPrice_1
                              , CASE WHEN tmpData.Num = 2 THEN tmpData.minPrice ELSE 0 END AS minPrice_2
                              , CASE WHEN tmpData.Num = 3 THEN tmpData.minPrice ELSE 0 END AS minPrice_3
                              , CASE WHEN tmpData.Num = 4 THEN tmpData.minPrice ELSE 0 END AS minPrice_4
                              , CASE WHEN tmpData.Num = 5 THEN tmpData.minPrice ELSE 0 END AS minPrice_5
                              , CASE WHEN tmpData.Num = 6 THEN tmpData.minPrice ELSE 0 END AS minPrice_6
                              , CASE WHEN tmpData.Num = 7 THEN tmpData.minPrice ELSE 0 END AS minPrice_7

                              , CAST (avg(tmpData.Value) OVER (PARTITION BY tmpData.MarginCategoryId) AS NUMERIC (16,2)) AS avgPercent
                         FROM tmpData
                         ORDER BY tmpData.MarginCategoryId, tmpData.UnitName, tmpData.num
                         ) AS tmp
                   GROUP BY tmp.MarginCategoryId
                          , tmp.MarginCategoryName
                          , tmp.UnitId
                          , tmp.UnitName
                          , tmp.ProvinceCityName
                          , tmp.JuridicalName
                          , tmp.RetailName
                          , tmp.RetailId
                   )

         --результат
         SELECT tmpDataAll.MarginCategoryId
              , tmpDataAll.MarginCategoryName
              , tmpDataAll.UnitId
              , tmpDataAll.UnitName
              , tmpDataAll.ProvinceCityName
              , tmpDataAll.JuridicalName
              , tmpDataAll.RetailId
              , tmpDataAll.RetailName
              , tmpDataAll.Id_1
              , tmpDataAll.Id_2
              , tmpDataAll.Id_3
              , tmpDataAll.Id_4
              , tmpDataAll.Id_5
              , tmpDataAll.Id_6
              , tmpDataAll.Id_7
              , tmpDataAll.Value_1
              , tmpDataAll.Value_2
              , tmpDataAll.Value_3
              , tmpDataAll.Value_4
              , tmpDataAll.Value_5
              , tmpDataAll.Value_6
              , tmpDataAll.Value_7
              , tmpDataAll.minPrice_1
              , tmpDataAll.minPrice_2
              , tmpDataAll.minPrice_3
              , tmpDataAll.minPrice_4
              , tmpDataAll.minPrice_5
              , tmpDataAll.minPrice_6
              , tmpDataAll.minPrice_7
              , tmpDataAll.avgPercent
     FROM tmpDataAll
     ORDER BY tmpDataAll.MarginCategoryName, tmpDataAll.ProvinceCityName , tmpDataAll.UnitName;
   
   
     RETURN NEXT Cursor1;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MarginCategory_AllUnit (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.11.19         * переписала
 15.11.19         * 
*/
--
--SELECT * FROM gpSelect_MarginCategory_All(inSession := '3':: TVarChar);
--FETCH ALL "<unnamed portal 2>";