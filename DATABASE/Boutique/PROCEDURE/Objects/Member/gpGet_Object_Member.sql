-- Function: gpGet_Object_Member()

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, INN TVarChar, Comment TVarChar, EMail TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           , lfGet_ObjectCode(0, zc_Object_Member())   AS Code
           , '' :: TVarChar                            AS Name
           , '' :: TVarChar                            AS INN
           , '' :: TVarChar                            AS Comment
           , '' :: TVarChar                            AS EMail
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , OS_Member_INN.ValueData  AS INN
           , OS_Member_Comment.ValueData  AS Comment
           , OS_Member_EMail.ValueData  AS EMail
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
       
       WHERE Object.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
08.05.17                                                          *
06.03.17                                                          *
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Member (1,'2')
