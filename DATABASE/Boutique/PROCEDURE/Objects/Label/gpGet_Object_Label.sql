-- Название для ценника

DROP FUNCTION IF EXISTS gpGet_Object_Label (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Label(
    IN inId          Integer,       -- <Название для ценника>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             0 :: Integer                              AS Id
           , NEXTVAL ('Object_Label_seq') :: Integer   AS Code
           , '' :: TVarChar                            AS Name
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
       FROM Object
       WHERE Object.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
03.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Label (1,'2')
