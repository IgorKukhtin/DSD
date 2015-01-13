-- Function: gpSelect_Object_ContractTag()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractTag (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractTag(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ContractTagGroupId Integer, ContractTagGroupName TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractTag());

   RETURN QUERY 
   SELECT 
         Object_ContractTag.Id         AS Id 
       , Object_ContractTag.ObjectCode AS Code
       , Object_ContractTag.ValueData  AS NAME
       
       , Object_ContractTagGroup.Id           AS ContractTagGroupId
       , Object_ContractTagGroup.ValueData    AS ContractTagGroupName 
       
       , Object_ContractTag.isErased   AS isErased
       
   FROM Object AS Object_ContractTag
          LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                               ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = Object_ContractTag.Id 
                              AND ObjectLink_ContractTag_ContractTagGroup.DescId = zc_ObjectLink_ContractTag_ContractTagGroup()
          LEFT JOIN Object AS Object_ContractTagGroup ON Object_ContractTagGroup.Id = ObjectLink_ContractTag_ContractTagGroup.ChildObjectId  
   WHERE Object_ContractTag.DescId = zc_Object_ContractTag();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractTag (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.15         * add ContractTagGroup
 21.04.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractTag('2')