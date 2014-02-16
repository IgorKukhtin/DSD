-- Function: gpGet_Object_ContractKind()

--DROP FUNCTION gpGet_Object_ContractKind();

CREATE OR REPLACE FUNCTION gpGet_Object_ContractKind(
    IN inId          Integer,       -- Виды договоров
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_ContractKind();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id          AS Id
           , Object.ObjectCode  AS Code
           , Object.ValueData   AS Name
           , Object.isErased    AS isErased
       FROM Object
       WHERE Object.Id = inId;
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ContractKind (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.13                                        * Cyr1251
 11.06.13          *
*/
-- тест
-- SELECT * FROM gpSelect_ContractKind('2')