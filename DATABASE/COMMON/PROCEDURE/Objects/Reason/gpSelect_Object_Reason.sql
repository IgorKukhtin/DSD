-- Function: gpSelect_Object_Reason()

DROP FUNCTION IF EXISTS gpSelect_Object_Reason (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Reason(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ReturnKindId Integer, ReturnKindName TVarChar
             , Comment TVarChar
             , isReturnIn Boolean
             , isSendOnPrice Boolean
             , isErased boolean) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Reason());

   RETURN QUERY 
   SELECT 
         Object_Reason.Id         AS Id 
       , Object_Reason.ObjectCode AS Code
       , Object_Reason.ValueData  AS NAME
       
       , Object_ReturnKind.Id           AS ReturnKindId
       , Object_ReturnKind.ValueData    AS ReturnKindName 

       , ObjectString_Comment.ValueData AS Comment
       , COALESCE (ObjectBoolean_ReturnIn.ValueData, FALSE)    ::Boolean AS isReturnIn
       , COALESCE (ObjectBoolean_SendOnPrice.ValueData, FALSE) ::Boolean AS isSendOnPrice

       , Object_Reason.isErased   AS isErased
       
   FROM Object AS Object_Reason
          LEFT JOIN ObjectLink AS ObjectLink_ReturnKind
                               ON ObjectLink_ReturnKind.ObjectId = Object_Reason.Id 
                              AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
          LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = ObjectLink_ReturnKind.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_ReturnIn
                                  ON ObjectBoolean_ReturnIn.ObjectId = Object_Reason.Id
                                 AND ObjectBoolean_ReturnIn.DescId = zc_ObjectBoolean_Reason_ReturnIn()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_SendOnPrice
                                  ON ObjectBoolean_SendOnPrice.ObjectId = Object_Reason.Id
                                 AND ObjectBoolean_SendOnPrice.DescId = zc_ObjectBoolean_Reason_SendOnPrice()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Reason.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_Reason_Comment()
   WHERE Object_Reason.DescId = zc_Object_Reason();
  
END;
$BODY$
LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Reason('2')