-- Function: gpGet_Object_InfoMoneyDetail()

DROP FUNCTION IF EXISTS gpGet_Object_InfoMoneyDetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoneyDetail(
    IN inId          Integer,       --  
    IN inSession     TVarChar       -- сессия пользователя 
    )
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InfoMoneyDetail());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , CAST (0 as Integer)     AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST (FALSE AS Boolean) AS isErased
           , CAST (0 as Integer)     AS InfoMoneyKindId
           , CAST ('' as TVarChar)   AS InfoMoneyKindName
           ;
   ELSE
       RETURN QUERY 
       SELECT Object.Id          AS Id
            , Object.ObjectCode  AS Code
            , Object.ValueData   AS Name
            , Object.isErased    AS isErased
            , Object_InfoMoneyKind.Id         AS InfoMoneyKindId
            , Object_InfoMoneyKind.ValueData  AS InfoMoneyKindName
       FROM Object
            LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyKind
                                 ON ObjectLink_InfoMoneyKind.ObjectId = Object.Id
                                AND ObjectLink_InfoMoneyKind.DescId = zc_ObjectLink_InfoMoneyDetail_InfoMoneyKind()
            LEFT JOIN Object AS Object_InfoMoneyKind ON Object_InfoMoneyKind.Id = ObjectLink_InfoMoneyKind.ChildObjectId
       WHERE Object.DescId = zc_Object_InfoMoneyDetail()
         AND Object.Id = inId;
   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.22          *        
*/

-- тест
-- SELECT * FROM gpGet_Object_InfoMoneyDetail(2,'2')