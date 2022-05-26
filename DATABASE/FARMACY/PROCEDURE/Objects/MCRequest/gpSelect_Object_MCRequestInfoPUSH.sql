--Function: gpSelect_Object_MCRequestInfoPUSH(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MCRequestInfoPUSH(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MCRequestInfoPUSH(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MinPrice TVarChar
             , MarginPercentOld TFloat
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
        tmpMCRequesItem AS (SELECT ObjectFloat_MinPrice.ValueData           AS MinPrice
                                 , ObjectFloat_MarginPercent.ValueData      AS MarginPercent
                                 , ObjectFloat_MarginPercentOld.ValueData   AS MarginPercentOld
                                 , ObjectDate_DateUpdate.ValueData          AS DataUpdate
                                 , ObjectDate_DateDone.ValueData            AS DateDone
                                 , ROW_NUMBER()OVER(ORDER BY ObjectFloat_MinPrice.ValueData) as ORD
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
                                 LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercentOld
                                                       ON ObjectFloat_MarginPercentOld.ObjectId = ObjectLink_MCRequest.ObjectId
                                                      AND ObjectFloat_MarginPercentOld.DescId = zc_ObjectFloat_MCRequestItem_MarginPercentOld()

                            WHERE Object_MCReques.DescId = zc_Object_MCRequest()
                              AND Object_MCReques.ObjectCode = 1
                            )
                               
   SELECT (zfConvert_FloatToString(tmpMCRequesItem.MinPrice)||'-'||
          COALESCE(zfConvert_FloatToString(tmpMCRequesItemNext.MinPrice), '.....'))::TVarChar         AS MinPrice 
        , tmpMCRequesItem.MarginPercentOld      AS MarginPercentOld
        , tmpMCRequesItem.MarginPercent         AS MarginPercent
        , (tmpMCRequesItem.MarginPercent - tmpMCRequesItem.MarginPercentOld)::TFloat   AS DMarginPercent
        , ('ВНИМАНИЕ !!!'||Chr(13)||zfConvert_DateTimeToString(tmpMCRequesItem.DataUpdate)||
          ' Маркетинг проанализировал цены конкурентов и поменял общую наценку по сети.'||Chr(13)||
          zfConvert_DateTimeToString(tmpMCRequesItem.DateDone)||
          ' Пелина Любовь наценку по всей сети изиенила . Вам самостоятельно ничего менять не нужно.')::TBlob
        , tmpMCRequesItem.DateDone
   FROM tmpMCRequesItem
   
        LEFT JOIN tmpMCRequesItem AS tmpMCRequesItemNext
                                  ON tmpMCRequesItemNext.Ord = tmpMCRequesItem.Ord + 1
                                  
   WHERE COALESCE (tmpMCRequesItem.MarginPercentOld, 0) <> 0
   ORDER BY tmpMCRequesItem.MinPrice
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

select * from gpSelect_Object_MCRequestInfoPUSH(inSession := '3');