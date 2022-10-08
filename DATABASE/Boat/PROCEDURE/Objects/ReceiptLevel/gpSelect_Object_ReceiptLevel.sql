-- Страна производитель

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptLevel (Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptLevel (Boolean,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptLevel(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inObjectDesc  TVarChar ,
    IN inSession     TVarChar            -- сессия пользователя   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , ObjectDesc TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptLevel());


   -- результат
   RETURN QUERY
      SELECT Object_ReceiptLevel.Id               AS Id
           , Object_ReceiptLevel.ObjectCode       AS Code
           , Object_ReceiptLevel.ValueData        AS Name
           , COALESCE (ObjectString_ShortName.ValueData, NULL)  :: TVarChar AS ShortName
           , COALESCE (ObjectString_ObjectDesc.ValueData, NULL) :: TVarChar AS ObjectDesc
           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_ReceiptLevel.isErased         AS isErased
       FROM Object AS Object_ReceiptLevel
           LEFT JOIN ObjectString AS ObjectString_ShortName
                                  ON ObjectString_ShortName.ObjectId = Object_ReceiptLevel.Id
                                 AND ObjectString_ShortName.DescId = zc_ObjectString_ReceiptLevel_ShortName()

           LEFT JOIN ObjectString AS ObjectString_ObjectDesc
                                  ON ObjectString_ObjectDesc.ObjectId = Object_ReceiptLevel.Id
                                 AND ObjectString_ObjectDesc.DescId = zc_ObjectString_ReceiptLevel_ObjectDesc()

           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_Insert
                                ON ObjectDate_Insert.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_ReceiptLevel.DescId = zc_Object_ReceiptLevel()
         AND (Object_ReceiptLevel.isErased = FALSE OR inIsShowAll = TRUE) 
         AND (COALESCE (ObjectString_ObjectDesc.ValueData, '') = inObjectDesc OR inObjectDesc= '')
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.22         * ObjectDesc
 11.12.20         *
*/

-- тест
--SELECT * FROM gpSelect_Object_ReceiptLevel (inIsShowAll:= TRUE, inObjectDesc:=''::TVarChar, inSession:= zfCalc_UserAdmin())
