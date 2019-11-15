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
     _tmpMarginCategoryList AS (SELECT Object_MarginCategory.Id         AS MarginCategoryId
                                     , Object_MarginCategory.ValueData  AS MarginCategoryName
                                FROM  Object AS Object_MarginCategory
                                      Left JOIN ObjectFloat AS ObjectFloat_Percent 	
                                             ON Object_MarginCategory.Id = ObjectFloat_Percent.ObjectId
                                            AND ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()
                                WHERE Object_MarginCategory.DescId = zc_Object_MarginCategory()
                                  AND Object_MarginCategory.isErased = FALSE
                                  AND COALESCE (ObjectFloat_Percent.ValueData ,0) = 0
                             )

   , _tmpMarginCategory AS (SELECT Object_MarginCategoryLink_View.MarginCategoryId
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
                            ORDER BY 1)

   , _tmpminPrice AS (SELECT tmp.minPrice
                           , ROW_NUMBER() OVER (ORDER BY tmp.MinPrice)  ::integer      AS Num
                      FROM (
                           SELECT DISTINCT ObjectFloat_MinPrice.ValueData AS minPrice 
                           FROM ObjectFloat AS ObjectFloat_MinPrice
                           WHERE ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                           ) AS tmp
                       )

     -- все данные  
   ,  tmpData AS (SELECT _tmpMarginCategory.MarginCategoryId 
                       , _tmpminPrice.num AS Num
                       , tmpMarginCategoryItem.Id AS MarginCategoryItemId 
                       , tmpMarginCategoryItem.MarginPercent  AS Value 
                       ,  avg(tmpMarginCategoryItem.MarginPercent) OVER (ORDER BY  _tmpminPrice.num)  AS avgPercent
                       , tmpMarginCategoryItem.minPrice
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
                 )

   , tmpParam AS (SELECT tmp.MarginCategoryId
                       , tmpMarginCategoryLink.MarginCategoryName
                       , tmpMarginCategoryLink.UnitId
                       , tmpMarginCategoryLink.UnitName
                       , Object_ProvinceCity.ValueData  AS ProvinceCityName
                       , Object_Juridical.ValueData     AS JuridicalName
                  FROM (SELECT DISTINCT tmpData.MarginCategoryId FROM tmpData) AS tmp
                        LEFT JOIN (SELECT DISTINCT Object_MarginCategoryLink_View.MarginCategoryId
                                        , Object_MarginCategoryLink_View.MarginCategoryName
                                        , Object_MarginCategoryLink_View.UnitId
                                        , Object_MarginCategoryLink_View.UnitName 
                                   FROM Object_MarginCategoryLink_View
                                   ) AS tmpMarginCategoryLink ON tmpMarginCategoryLink.MarginCategoryId = tmp.MarginCategoryId

                        LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                             ON ObjectLink_Unit_ProvinceCity.ObjectId = tmpMarginCategoryLink.UnitId
                                            AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                        LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                             ON ObjectLink_Unit_Juridical.ObjectId = tmpMarginCategoryLink.UnitId
                                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                  )
   
   
   , tmpDataAll AS (SELECT tmp.MarginCategoryId
                         , tmp.MarginCategoryName
                         , tmp.UnitId
                         , tmp.UnitName
                         , tmp.ProvinceCityName
                         , tmp.JuridicalName
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
                              , tmpParam.MarginCategoryName
                              , tmpParam.UnitId
                              , tmpParam.UnitName
                              , tmpParam.ProvinceCityName
                              , tmpParam.JuridicalName
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
                                                            
                              , CAST (avg(tmpData.Value) OVER (ORDER BY tmpParam.UnitId) AS NUMERIC (16,2)) AS avgPercent
                         FROM tmpData
                              LEFT JOIN tmpParam ON tmpParam.MarginCategoryId = tmpData.MarginCategoryId
                         ORDER BY tmpData.MarginCategoryId, tmpParam.UnitName, tmpData.num
                         ) AS tmp
                   GROUP BY tmp.MarginCategoryId
                          , tmp.MarginCategoryName
                          , tmp.UnitId
                          , tmp.UnitName
                          , tmp.ProvinceCityName
                          , tmp.JuridicalName
                   )

         --результат
         SELECT tmpDataAll.MarginCategoryId
              , tmpDataAll.MarginCategoryName
              , tmpDataAll.UnitId
              , tmpDataAll.UnitName
              , tmpDataAll.ProvinceCityName
              , tmpDataAll.JuridicalName
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
 15.11.19         * 
*/
--SELECT * FROM gpSelect_MarginCategory_All(inSession := '3':: TVarChar);