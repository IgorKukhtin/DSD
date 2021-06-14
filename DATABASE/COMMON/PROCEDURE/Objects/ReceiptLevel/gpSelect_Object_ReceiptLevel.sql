-- Function: gpSelect_Object_ReceiptLevel()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptLevel(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptLevel(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , MovementDesc TFloat , MovementDescName TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptLevel());

     RETURN QUERY 
     SELECT 
           Object_ReceiptLevel.Id         AS Id 
         , Object_ReceiptLevel.ObjectCode AS Code
         , Object_ReceiptLevel.ValueData  AS Name
         
         , ReceiptLevel_From.Id         AS FromId
         , ReceiptLevel_From.ObjectCode AS FromCode
         , ReceiptLevel_From.ValueData  AS FromName
         
         , Object_To.Id                 AS ToId
         , Object_To.ObjectCode         AS ToCode
         , Object_To.ValueData          AS ToName

         , ObjectFloat_MovementDesc.ValueData :: TFloat AS MovementDesc
         , MovementDesc.ItemName          AS MovementDescName
         , ObjectString_Comment.ValueData AS Comment

         , Object_ReceiptLevel.isErased   AS isErased
         
     FROM Object AS Object_ReceiptLevel
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_From
                               ON ObjectLink_ReceiptLevel_From.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_From.DescId = zc_ObjectLink_ReceiptLevel_From()
          LEFT JOIN Object AS ReceiptLevel_From ON ReceiptLevel_From.Id = ObjectLink_ReceiptLevel_From.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_To
                               ON ObjectLink_ReceiptLevel_To.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_To.DescId = zc_ObjectLink_ReceiptLevel_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_ReceiptLevel_To.ChildObjectId          

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptLevel.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptLevel_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_MovementDesc
                                ON ObjectFloat_MovementDesc.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectFloat_MovementDesc.DescId = zc_ObjectFloat_ReceiptLevel_MovementDesc()
          LEFT JOIN MovementDesc ON MovementDesc.Id = ObjectFloat_MovementDesc.ValueData ::Integer

     WHERE Object_ReceiptLevel.DescId = zc_Object_ReceiptLevel()
     ; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptLevel (zfCalc_UserAdmin())
