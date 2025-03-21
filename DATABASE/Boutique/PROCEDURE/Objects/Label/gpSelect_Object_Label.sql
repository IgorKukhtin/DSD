﻿-- Название для ценника

DROP FUNCTION IF EXISTS gpSelect_Object_Label (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Label(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Name_UKR TVarChar
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());

   -- результат
   RETURN QUERY
      SELECT Object.Id                          AS Id
           , Object.ObjectCode                  AS Code
           , Object.ValueData                   AS Name
           , COALESCE (ObjectString_UKR.ValueData, NULL) :: TVarChar AS Name_UKR
           , Object.isErased                    AS isErased
       FROM Object
           LEFT JOIN ObjectString AS ObjectString_UKR
                                  ON ObjectString_UKR.ObjectId = Object.Id
                                 AND ObjectString_UKR.DescId = zc_ObjectString_Label_UKR()
       WHERE Object.DescId = zc_Object_Label()
         AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.06.20          *
03.03.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Label (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
