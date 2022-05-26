--Function: gpSelect_Object_MCRequestShowPUSH(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MCRequestShowPUSH(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MCRequestShowPUSH(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MinPrice TVarChar
             , MarginPercentCurr TFloat
             , MarginPercent TFloat
             , DMarginPercent TFloat
             , Text TBlob
             , DateDone TDateTime
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginCategory());

   RETURN QUERY 
   WITH 
        tmpMarginCategoryItem AS (SELECT DISTINCT
                                         Object_MarginCategoryItem_View.MarginPercent,
                                         Object_MarginCategoryItem_View.MinPrice,
                                         Object_MarginCategoryItem_View.MarginCategoryId,
                                         ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
                                  FROM Object_MarginCategoryItem_View
                                       INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                                     AND Object_MarginCategoryItem.isErased = FALSE
                                  WHERE Object_MarginCategoryItem_View.MarginCategoryId = 4194130 
                                  ),
        tmpMCRequesItem AS (SELECT ObjectFloat_MinPrice.ValueData        AS MinPrice
                                 , ObjectFloat_MarginPercent.ValueData   AS MarginPercent
                                 , ObjectDate_DateUpdate.ValueData       AS DataUpdate
                                 , ObjectDate_DateDone.ValueData         AS DateDone
                            FROM Object AS Object_MCReques

                                 LEFT JOIN ObjectDate AS ObjectDate_DateUpdate
                                                      ON ObjectDate_DateUpdate.ObjectId = Object_MCReques.Id
                                                     AND ObjectDate_DateUpdate.DescId = zc_ObjectDate_MCRequest_DateUpdate()
                                 LEFT JOIN ObjectDate AS ObjectDate_DateDone
                                                      ON ObjectDate_DateDone.ObjectId = Object_MCReques.Id
                                                     AND ObjectDate_DateDone.DescId = zc_ObjectDate_MCRequest_DateDone()
                                       
                                 LEFT JOIN ObjectLink AS ObjectLink_MCRequest
                                                      ON ObjectLink_MCRequest.ChildObjectId = Object_MCReques.Id
                                                     AND ObjectLink_MCRequest.DescId = zc_ObjectLink_MCRequestItem_MCRequest()
                                                                                     
                                 LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                       ON ObjectFloat_MinPrice.ObjectId = ObjectLink_MCRequest.ObjectId
                                                      AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MCRequestItem_MinPrice()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                                       ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MCRequest.ObjectId
                                                      AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MCRequestItem_MarginPercent()

                            WHERE Object_MCReques.DescId = zc_Object_MCRequest()
                              AND Object_MCReques.ObjectCode = 1
                              AND ObjectDate_DateDone.ValueData IS NULL
                            )
                               
   SELECT (zfConvert_FloatToString(tmpMarginCategoryItem.MinPrice)||'-'||
          COALESCE(zfConvert_FloatToString(tmpMarginCategoryItemNext.MinPrice), '.....'))::TVarChar         AS MinPrice 
        , tmpMarginCategoryItem.MarginPercent    AS MarginPercentCurr
        , COALESCE(tmpMCRequesItem.MarginPercent, tmpMarginCategoryItem.MarginPercent) AS MarginPercent
        , (COALESCE(tmpMCRequesItem.MarginPercent, tmpMarginCategoryItem.MarginPercent) - tmpMarginCategoryItem.MarginPercent)::TFloat AS DMarginPercent
        , ('ВНИМАНИЕ !!!'||Chr(13)||zfConvert_DateTimeToString(tmpMCRequesItem.DataUpdate)||
          ' Маркетинг проанализировал цены конкурентов и решил поменять общую наценку по сети:'||Chr(13)||
          'Просьба внести новые данные в таблицу "Категории наценок (Новый)"' )::TBlob
        , tmpMCRequesItem.DateDone
   FROM tmpMarginCategoryItem
   
        INNER JOIN tmpMCRequesItem ON tmpMCRequesItem.MinPrice = tmpMarginCategoryItem.MinPrice
        
        LEFT JOIN tmpMarginCategoryItem AS tmpMarginCategoryItemNext
                                        ON tmpMarginCategoryItemNext.Ord = tmpMarginCategoryItem.Ord + 1
   
   ORDER BY tmpMarginCategoryItem.MinPrice
   ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.05.22                                                       *
*/

-- тест
--

select * from gpSelect_Object_MCRequestShowPUSH(inSession := '3');