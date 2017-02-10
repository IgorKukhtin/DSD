-- Function: gpSelect_Object_GroupMemberSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GroupMemberSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GroupMemberSP(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GroupMemberSP());

   RETURN QUERY 
     SELECT Object_GroupMemberSP.Id                 AS Id
          , Object_GroupMemberSP.ObjectCode         AS Code
          , Object_GroupMemberSP.ValueData          AS Name
          , Object_GroupMemberSP.isErased           AS isErased
     FROM Object AS Object_GroupMemberSP
     WHERE Object_GroupMemberSP.DescId = zc_Object_GroupMemberSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GroupMemberSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.17         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_GroupMemberSP('2')