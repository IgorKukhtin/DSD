-- Торговая марка

DROP FUNCTION IF EXISTS gpSelect_Object_Client (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Client(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DiscountTax TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_Client.Id                AS Id
           , Object_Client.ObjectCode        AS Code
           , Object_Client.ValueData         AS Name
           
           , COALESCE (ObjectFloat_DiscountTax.ValueData,0) ::TFloat AS DiscountTax
           , ObjectString_Comment.ValueData  AS Comment

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_Client.isErased          AS isErased
       FROM Object AS Object_Client
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Client.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_Client.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()  

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_Client.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_Client.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_Client.DescId = zc_Object_Client()
         AND (Object_Client.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
04.01.21          *
22.10.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Client (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())