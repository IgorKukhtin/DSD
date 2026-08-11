-- Function: gpSelect_Object_ContractTagKind()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractTagKind(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractTagKind(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractTagKind()());

   RETURN QUERY 
   SELECT 
         Object_ContractTagKind.Id         AS Id 
       , Object_ContractTagKind.ObjectCode AS Code
       , Object_ContractTagKind.ValueData  AS Name
       , Object_ContractTagKind.isErased   AS isErased
   
   FROM Object AS Object_ContractTagKind
   WHERE Object_ContractTagKind.DescId = zc_Object_ContractTagKind()
    AND (Object_ContractTagKind.isErased = FALSE OR inIsErased = TRUE);
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.26         * 

*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractTagKind(false, '2')