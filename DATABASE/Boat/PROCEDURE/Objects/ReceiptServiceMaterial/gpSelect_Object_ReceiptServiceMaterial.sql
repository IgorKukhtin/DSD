﻿--

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptServiceMaterial (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptServiceMaterial(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptServiceMaterial());


   -- результат
   RETURN QUERY
      SELECT Object_ReceiptServiceMaterial.Id               AS Id
           , Object_ReceiptServiceMaterial.ObjectCode       AS Code
           , Object_ReceiptServiceMaterial.ValueData        AS Name
           , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment
           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_ReceiptServiceMaterial.isErased         AS isErased
       FROM Object AS Object_ReceiptServiceMaterial
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptServiceMaterial.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptServiceMaterial_Comment()

           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = Object_ReceiptServiceMaterial.Id
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_Insert
                                ON ObjectDate_Insert.ObjectId = Object_ReceiptServiceMaterial.Id
                               AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_ReceiptServiceMaterial.DescId = zc_Object_ReceiptServiceMaterial()
         AND (Object_ReceiptServiceMaterial.isErased = FALSE OR inIsShowAll = TRUE)

     UNION
      SELECT 0    :: Integer                  AS Id
           , 0    :: Integer                  AS Code
           , 'Очистить значение' :: TVarChar  AS Name
           , ''                  :: TVarChar  AS Comment
           , ''                  :: TVarChar  AS InsertName
           , NULL                :: TDateTime AS InsertDate
           , TRUE                :: Boolean   AS isErased
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptServiceMaterial (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
