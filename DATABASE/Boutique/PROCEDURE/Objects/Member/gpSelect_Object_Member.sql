-- Function: gpSelect_Object_Member()

DROP FUNCTION IF EXISTS gpSelect_Object_Member (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, INN TVarChar, Comment TVarChar, EMail TVarChar, isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());


   -- результат
   RETURN QUERY
      SELECT Object.Id                          AS Id
           , Object.ObjectCode                  AS Code
           , Object.ValueData                   AS Name
           , OS_Member_INN.ValueData            AS INN
           , OS_Member_Comment.ValueData        AS Comment
           , OS_Member_EMail.ValueData          AS EMail
           , Object.isErased                    AS isErased
       FROM Object
            LEFT JOIN ObjectString AS OS_Member_INN
                                   ON OS_Member_INN.ObjectId = Object.Id
                                  AND OS_Member_INN.DescId = zc_ObjectString_Member_INN()

            LEFT JOIN ObjectString AS OS_Member_Comment
                                   ON OS_Member_Comment.ObjectId = Object.Id
                                  AND OS_Member_Comment.DescId = zc_ObjectString_Member_Comment()

            LEFT JOIN ObjectString AS OS_Member_EMail
                                   ON OS_Member_EMail.ObjectId = Object.Id
                                  AND OS_Member_EMail.DescId = zc_ObjectString_Member_EMail()
           
       WHERE Object.DescId = zc_Object_Member()
         AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
  20.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Member (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
