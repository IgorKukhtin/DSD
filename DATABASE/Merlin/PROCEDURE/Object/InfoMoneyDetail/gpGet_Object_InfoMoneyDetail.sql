-- Function: gpGet_Object_InfoMoneyDetail()

DROP FUNCTION IF EXISTS gpGet_Object_InfoMoneyDetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoneyDetail(
    IN inId          Integer,       --  
    IN inSession     TVarChar       -- сессия пользователя 
    )
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isUserAll Boolean
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
           , CAST (FALSE AS Boolean) AS isUserAll
           , CAST (FALSE AS Boolean) AS isErased
           , CAST (0 as Integer)     AS InfoMoneyKindId
           , CAST ('' as TVarChar)   AS InfoMoneyKindName
           ;
   ELSE
       RETURN QUERY 
       SELECT Object_InfoMoneyDetail.Id          AS Id
            , Object_InfoMoneyDetail.ObjectCode  AS Code
            , Object_InfoMoneyDetail.ValueData   AS Name
            , COALESCE (ObjectBoolean_UserAll.ValueData, FALSE) ::Boolean AS isUserAll
            , Object_InfoMoneyDetail.isErased    AS isErased
            , Object_InfoMoneyKind.Id         AS InfoMoneyKindId
            , Object_InfoMoneyKind.ValueData  AS InfoMoneyKindName
       FROM Object AS Object_InfoMoneyDetail
            LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyKind
                                 ON ObjectLink_InfoMoneyKind.ObjectId = Object_InfoMoneyDetail.Id
                                AND ObjectLink_InfoMoneyKind.DescId = zc_ObjectLink_InfoMoneyDetail_InfoMoneyKind()
            LEFT JOIN Object AS Object_InfoMoneyKind ON Object_InfoMoneyKind.Id = ObjectLink_InfoMoneyKind.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                    ON ObjectBoolean_UserAll.ObjectId = Object_InfoMoneyDetail.Id
                                   AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoneyDetail_UserAll()
       WHERE Object_InfoMoneyDetail.DescId = zc_Object_InfoMoneyDetail()
         AND Object_InfoMoneyDetail.Id = inId;
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
-- SELECT * FROM gpGet_Object_InfoMoneyDetail(0,'2')