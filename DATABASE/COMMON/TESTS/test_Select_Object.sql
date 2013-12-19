-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS test_Select_Object (TVarChar);

CREATE OR REPLACE FUNCTION test_Select_Object(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId := inSession;

     RETURN QUERY 
       SELECT Object.Id             
       FROM Object LIMIT 100;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION test_Select_Object (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.12.13                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Goods (inSession := '9818')
