-- Function: gpGet_Object_ReceiptLevel()

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptLevel(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptLevel(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , MovementDesc TFloat, MovementDescName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ReceiptLevel());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptLevel()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS FromId
           , CAST (0 as Integer)    AS FromCode
           , CAST ('' as TVarChar)  AS FromName
           
           , CAST (0 as Integer)    AS ToId
           , CAST (0 as Integer)    AS ToCode
           , CAST ('' as TVarChar)  AS ToName

           , 0 :: TFloat            AS MovementDesc
           , CAST ('' as TVarChar)  AS MovementDescName
           , CAST (0 as Integer)    AS DocumentKindId
           , CAST ('' as TVarChar)  AS DocumentKindName
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased
        ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_ReceiptLevel.Id         AS Id 
         , Object_ReceiptLevel.ObjectCode AS Code
         , Object_ReceiptLevel.ValueData  AS Name
         
         , ReceiptLevel_From.Id           AS FromId
         , ReceiptLevel_From.ObjectCode   AS FromCode
         , ReceiptLevel_From.ValueData    AS FromName

         , Object_To.Id                   AS ToId
         , Object_To.ObjectCode           AS ToCode
         , Object_To.ValueData            AS ToName

         , ObjectFloat_MovementDesc.ValueData ::TFloat AS MovementDesc
         , MovementDesc.ItemName          AS MovementDescName 
         , Object_DocumentKind.Id         AS DocumentKindId
         , Object_DocumentKind.ValueData  AS DocumentKindName
         , ObjectString_Comment.ValueData AS Comment
       
         , Object_ReceiptLevel.isErased   AS isErased
         
     FROM OBJECT AS Object_ReceiptLevel
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_From
                               ON ObjectLink_ReceiptLevel_From.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_From.DescId = zc_ObjectLink_ReceiptLevel_From()
          LEFT JOIN Object AS ReceiptLevel_From ON ReceiptLevel_From.Id = ObjectLink_ReceiptLevel_From.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_To
                               ON ObjectLink_ReceiptLevel_To.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_To.DescId = zc_ObjectLink_ReceiptLevel_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_ReceiptLevel_To.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_DocumentKind
                               ON ObjectLink_ReceiptLevel_DocumentKind.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_DocumentKind.DescId = zc_ObjectLink_ReceiptLevel_DocumentKind()
          LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = ObjectLink_ReceiptLevel_DocumentKind.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptLevel.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptLevel_Comment()   

          LEFT JOIN ObjectFloat AS ObjectFloat_MovementDesc
                                ON ObjectFloat_MovementDesc.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectFloat_MovementDesc.DescId = zc_ObjectFloat_ReceiptLevel_MovementDesc()
          LEFT JOIN MovementDesc ON MovementDesc.Id = ObjectFloat_MovementDesc.ValueData ::Integer
       WHERE Object_ReceiptLevel.Id = inId
         AND Object_ReceiptLevel.DescId = zc_Object_ReceiptLevel();
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptLevel(0, '2')