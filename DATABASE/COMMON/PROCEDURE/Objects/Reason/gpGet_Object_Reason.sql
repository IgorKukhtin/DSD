-- Function: gpGet_Object_Reason()

DROP FUNCTION IF EXISTS gpGet_Object_Reason (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Reason(
    IN inId          Integer,       -- ключ объекта <Виды бонусов>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ReturnKindId Integer, ReturnKindName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Reason());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Reason()) AS Code
           , CAST ('' as TVarChar)  AS Name
           
           , CAST (0 as Integer)    AS ReturnKindId
           , CAST ('' as TVarChar)  AS ReturnKindName           
           
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Reason.Id         AS Id
           , Object_Reason.ObjectCode AS Code
           , Object_Reason.ValueData  AS NAME
          
           , Object_ReturnKind.Id        AS ReturnKindId
           , Object_ReturnKind.ValueData AS ReturnKindName            
           
           , Object_Reason.isErased   AS isErased
           
       FROM Object AS Object_Reason
          LEFT JOIN ObjectLink AS ObjectLink_ReturnKind
                               ON ObjectLink_ReturnKind.ObjectId = Object_Reason.Id 
                              AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
          LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = ObjectLink_ReturnKind.ChildObjectId  

       WHERE Object_Reason.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Reason (0, '2')