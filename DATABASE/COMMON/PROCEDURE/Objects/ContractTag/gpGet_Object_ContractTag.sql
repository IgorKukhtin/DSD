-- Function: gpGet_Object_ContractTag()

DROP FUNCTION IF EXISTS gpGet_Object_ContractTag (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractTag(
    IN inId          Integer,       -- ключ объекта <Виды бонусов>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ContractTagGroupId Integer, ContractTagGroupName TVarChar
             , ContractTagKindId Integer, ContractTagKindName TVarChar
             , PositionId Integer, PositionName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ContractTag());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractTag()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)   AS ContractTagGroupId
           , CAST ('' as TVarChar) AS ContractTagGroupName           

           , CAST (0 as Integer)   AS ContractTagKindId
           , CAST ('' as TVarChar) AS ContractTagKindName
           , CAST (0 as Integer)   AS PositionId
           , CAST ('' as TVarChar) AS PositionName
           
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractTag.Id         AS Id
           , Object_ContractTag.ObjectCode AS Code
           , Object_ContractTag.ValueData  AS NAME
          
           , Object_ContractTagGroup.Id           AS ContractTagGroupId
           , Object_ContractTagGroup.ValueData    AS ContractTagGroupName            
           , Object_ContractTagKind.Id            AS ContractTagKindId
           , Object_ContractTagKind.ValueData     AS ContractTagKindName
           , Object_Position.Id                   AS PositionId
           , Object_Position.ValueData            AS PositionName
           
           , Object_ContractTag.isErased   AS isErased
           
       FROM Object AS Object_ContractTag
          LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                               ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = Object_ContractTag.Id 
                              AND ObjectLink_ContractTag_ContractTagGroup.DescId = zc_ObjectLink_ContractTag_ContractTagGroup()
          LEFT JOIN Object AS Object_ContractTagGroup ON Object_ContractTagGroup.Id = ObjectLink_ContractTag_ContractTagGroup.ChildObjectId  

          LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagKind
                               ON ObjectLink_ContractTag_ContractTagKind.ObjectId = Object_ContractTag.Id 
                              AND ObjectLink_ContractTag_ContractTagKind.DescId = zc_ObjectLink_ContractTag_ContractTagKind()
          LEFT JOIN Object AS Object_ContractTagKind ON Object_ContractTagKind.Id = ObjectLink_ContractTag_ContractTagKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractTag_Position
                               ON ObjectLink_ContractTag_Position.ObjectId = Object_ContractTag.Id 
                              AND ObjectLink_ContractTag_Position.DescId = zc_ObjectLink_ContractTag_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_ContractTag_Position.ChildObjectId

       WHERE Object_ContractTag.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_ContractTag(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.26         *
 12.04.15         * add ContractTagGroup
 21.04.14         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ContractTag (0, '2')