--Function: gpSelect_Object_MarginCategory_Total(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategory_Total(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginCategory_Total(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE Cursor1 refcursor;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginCategory());

     OPEN Cursor1 FOR
     WITH
         tmpMarginCategory AS (SELECT Object_MarginCategory.ValueData , Object_MarginCategory.Id AS MarginCategoryId
                               FROM  Object AS Object_MarginCategory
                                     Left JOIN ObjectFloat AS ObjectFloat_Percent 	
                                            ON Object_MarginCategory.Id = ObjectFloat_Percent.ObjectId
                                           AND ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()
                               WHERE Object_MarginCategory.DescId = zc_Object_MarginCategory()
                                 AND Object_MarginCategory.isErased = FALSE
                                 AND COALESCE (ObjectFloat_Percent.ValueData ,0) = 0
                               )

       , tmpminPrice  AS (SELECT DISTINCT ObjectFloat_MinPrice.ValueData AS minPrice 
                    FROM ObjectFloat AS ObjectFloat_MinPrice
                    WHERE ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()  
                    )
       , tmpMarginCategoryItem AS (SELECT MAX (Object_MarginCategoryItem.Id)      AS Id
                                  , Object_MarginCategoryItem.MarginCategoryId
                                  , Object_MarginCategoryItem.MarginPercent
                                  , Object_MarginCategoryItem.minPrice
                             FROM Object_MarginCategoryItem_View AS Object_MarginCategoryItem
                                  INNER JOIN Object ON Object.Id = Object_MarginCategoryItem.Id
                                                   AND Object.isErased = FALSE
                             GROUP BY Object_MarginCategoryItem.MarginCategoryId
                                  , Object_MarginCategoryItem.MarginPercent
                                  , Object_MarginCategoryItem.minPrice
                              )

       SELECT tmp.minPrice 
            , SUM (tmp.MarginPercent1) :: TFloat AS MarginPercent1
            , SUM (tmp.MarginPercent2) :: TFloat AS MarginPercent2
            , SUM (tmp.MarginPercent3) :: TFloat AS MarginPercent3
            , SUM (tmp.MarginPercent4) :: TFloat AS MarginPercent4
            , SUM (tmp.MarginPercent5) :: TFloat AS MarginPercent5
            , SUM (tmp.MarginPercent6) :: TFloat AS MarginPercent6
            , SUM (tmp.MarginPercent7) :: TFloat AS MarginPercent7
            , SUM (tmp.MarginPercent8) :: TFloat AS MarginPercent8
            , SUM (tmp.MarginPercent9) :: TFloat AS MarginPercent9
            , SUM (tmp.MarginPercent10) :: TFloat AS MarginPercent10
            , SUM (tmp.MarginPercent11) :: TFloat AS MarginPercent11
            , SUM (tmp.MarginPercent12) :: TFloat AS MarginPercent12
            , SUM (tmp.MarginPercent13) :: TFloat AS MarginPercent13
            , SUM (tmp.MarginPercent14) :: TFloat AS MarginPercent14

            , SUM (tmp.MarginPercent15) :: TFloat AS MarginPercent15
            , SUM (tmp.MarginPercent16) :: TFloat AS MarginPercent16
            , SUM (tmp.MarginPercent17) :: TFloat AS MarginPercent17
            , SUM (tmp.MarginPercent18) :: TFloat AS MarginPercent18
            , SUM (tmp.MarginPercent19) :: TFloat AS MarginPercent19
            , SUM (tmp.MarginPercent20) :: TFloat AS MarginPercent20
            , SUM (tmp.MarginPercent21) :: TFloat AS MarginPercent21
            , SUM (tmp.MarginPercent22) :: TFloat AS MarginPercent22
            , SUM (tmp.MarginPercent23) :: TFloat AS MarginPercent23
            , SUM (tmp.MarginPercent24) :: TFloat AS MarginPercent24
            , SUM (tmp.MarginPercent25) :: TFloat AS MarginPercent25
            , SUM (tmp.MarginPercent26) :: TFloat AS MarginPercent26
            , SUM (tmp.MarginPercent27) :: TFloat AS MarginPercent27
            , Cast( SUM (tmp.MarginPercent28)/ count(*) AS NUMERIC (16, 1)) :: TFloat AS MarginPercent28
              
       FROM (
       SELECT tmpMarginCategoryItem.Id     
            , tmpMarginCategoryItem.minPrice 
            , tmpMarginCategoryItem.MarginCategoryId
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435801 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent1
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435807 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent2
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435813 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent3
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435816 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent4
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437163 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent5
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437499 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent6
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437505 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent7
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 472150 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent8
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 1599495 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent9
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 2076284 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent10
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 2196424 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent11
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 2775827 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent12
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 3202886 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent13
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 3384533 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent14
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 1864611 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent15
           
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435804 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent16
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437517 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent17
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437511 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent18
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435798 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent19
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 1327351 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent20
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437160 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent21
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437502 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent22
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435891 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent23
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437167 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent24
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437508 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent25
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 437514 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent26
            , CASE WHEN tmpMarginCategory.MarginCategoryId = 435810 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent27
            , tmpMarginCategoryItem.MarginPercent AS MarginPercent28
                       
       FROM tmpMarginCategory 
            LEFT JOIN tmpMarginCategoryItem ON tmpMarginCategoryItem.MarginCategoryId = tmpMarginCategory.MarginCategoryId
       ) AS tmp
       GROUP BY tmp.minPrice 
            
            ; 

   RETURN NEXT Cursor1;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginCategory_Total ('2')

/*
SELECT tmpMarginCategoryItem.Id            AS Id 
            , tmpMarginCategoryItem.minPrice 
            , tmpMarginCategoryItem.MarginCategoryId
            , CASE WHEN tmpUnit.UnitId = 183288 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent1
            , CASE WHEN tmpUnit.UnitId = 183289 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent2
            , CASE WHEN tmpUnit.UnitId = 183290 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent3
            , CASE WHEN tmpUnit.UnitId = 183291 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent4
            , CASE WHEN tmpUnit.UnitId = 183292 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent5
            , CASE WHEN tmpUnit.UnitId = 183293 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent6
            , CASE WHEN tmpUnit.UnitId = 183294 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent7
            , CASE WHEN tmpUnit.UnitId = 375626 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent8
            , CASE WHEN tmpUnit.UnitId = 375627 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent9
            , CASE WHEN tmpUnit.UnitId = 377574 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent10
            , CASE WHEN tmpUnit.UnitId = 377594 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent11
            , CASE WHEN tmpUnit.UnitId = 377595 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent12
            , CASE WHEN tmpUnit.UnitId = 377605 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent13
            , CASE WHEN tmpUnit.UnitId = 377606 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent14
            , CASE WHEN tmpUnit.UnitId = 377610 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent15
            , CASE WHEN tmpUnit.UnitId = 377613 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent16
            , CASE WHEN tmpUnit.UnitId = 377615 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent17
            , CASE WHEN tmpUnit.UnitId = 389328 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent18
            , CASE WHEN tmpUnit.UnitId = 394426 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent19
            , CASE WHEN tmpUnit.UnitId = 427324 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent20
            , CASE WHEN tmpUnit.UnitId = 472116 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent21
            , CASE WHEN tmpUnit.UnitId = 494882 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent22
            , CASE WHEN tmpUnit.UnitId = 1529734 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent23
            , CASE WHEN tmpUnit.UnitId = 1781716 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent24
            , CASE WHEN tmpUnit.UnitId = 2144918 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent25
            , CASE WHEN tmpUnit.UnitId = 2886778 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent26
            , CASE WHEN tmpUnit.UnitId = 3031072 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent27
            , CASE WHEN tmpUnit.UnitId = 3457116 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent28
            , CASE WHEN tmpUnit.UnitId = 3457773 THEN tmpMarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent29
       FROM tmpLink 
            LEFT JOIN tmpUnit ON tmpUnit.UnitId =  tmpLink.UnitId 
            LEFT JOIN tmpMarginCategoryItem ON tmpMarginCategoryItem.MarginCategoryId = tmpLink.MarginCategoryId
       ) AS tmp
*/