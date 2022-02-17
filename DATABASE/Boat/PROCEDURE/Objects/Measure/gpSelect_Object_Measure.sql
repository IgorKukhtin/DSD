-- Function: gpSelect_Object_Measure()

DROP FUNCTION IF EXISTS gpSelect_Object_Measure (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Measure (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Measure(
    IN inLanguageId  Integer,
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_translate TVarChar
             , MeasureCodeId Integer, MeasureCodeName TVarChar, MeasureCodeName_translate TVarChar
             , InternalCode TVarChar, InternalName TVarChar, isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());


   -- результат
   RETURN QUERY
       WITH
       tmpTranslate AS (SELECT Object.Id                        AS ObjectId
                             , Object_TranslateObject.ValueData AS Value
                        FROM Object AS Object_TranslateObject
                             INNER JOIN ObjectLink AS ObjectLink_Language
                                                   ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                  AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                  AND ObjectLink_Language.ChildObjectId = inLanguageId

                             LEFT JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                 AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                             INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                              AND Object.DescId IN (zc_Object_Measure(), zc_Object_MeasureCode())
                        WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                          AND Object_TranslateObject.isErased = FALSE
                        )

      SELECT Object_Measure.Id                  AS Id
           , Object_Measure.ObjectCode          AS Code
           , Object_Measure.ValueData           AS Name
           , tmpTranslate.Value                 AS Name_translate
           
           , Object_MeasureCode.Id              AS MeasureCodeId
           , Object_MeasureCode.ValueData       AS MeasureCodeName
           , tmpTranslate_code.Value            AS MeasureCodeName_translate
           
           , OS_Measure_InternalCode.ValueData  AS InternalCode
           , OS_Measure_InternalName.ValueData  AS InternalName
           , Object_Measure.isErased            AS isErased
       FROM Object AS Object_Measure
            LEFT JOIN ObjectString AS OS_Measure_InternalName
                                   ON OS_Measure_InternalName.ObjectId = Object_Measure.Id
                                  AND OS_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()
            LEFT JOIN ObjectString AS OS_Measure_InternalCode
                                   ON OS_Measure_InternalCode.ObjectId = Object_Measure.Id
                                  AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()

            LEFT JOIN ObjectLink AS ObjectLink_MeasureCode
                                 ON ObjectLink_MeasureCode.ObjectId = Object_Measure.Id
                                AND ObjectLink_MeasureCode.DescId = zc_ObjectLink_Measure_MeasureCode()
            LEFT JOIN Object AS Object_MeasureCode ON Object_MeasureCode.Id = ObjectLink_MeasureCode.ChildObjectId

            --первый раз перевод Measure
            LEFT JOIN tmpTranslate ON tmpTranslate.ObjectId = Object_Measure.Id
            --второй раз перевод MeasureCode
            LEFT JOIN tmpTranslate AS tmpTranslate_code ON tmpTranslate_code.ObjectId = Object_MeasureCode.Id

       WHERE Object_Measure.DescId = zc_Object_Measure()
         AND (Object_Measure.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 17.02.22         *
 16.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Measure (inLanguageId:=1778 , inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())


