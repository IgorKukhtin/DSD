-- Function: gpGet_Object_Reason()

DROP FUNCTION IF EXISTS gpGet_Object_Reason (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Reason(
    IN inId          Integer,       -- ключ объекта <Виды бонусов>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Short TVarChar
             , ReturnKindId Integer, ReturnKindName TVarChar
             , ReturnDescKindId Integer, ReturnDescKindName TVarChar
             , PeriodDays TFloat, PeriodTax TFloat
             , Comment TVarChar
             , isReturnIn Boolean
             , isSendOnPrice Boolean
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
           , CASt ('' AS TVarChar)  AS Short
           
           , CAST (0 as Integer)    AS ReturnKindId
           , CAST ('' as TVarChar)  AS ReturnKindName           
           , CAST (0 as Integer)    AS ReturnDescKindId
           , CAST ('' as TVarChar)  AS ReturnDescKindName 

           , 0  ::TFloat AS PeriodDays
           , 0  ::TFloat AS PeriodTax

           , ''       ::TVarChar    AS Comment
           , FALSE    ::Boolean     AS isReturnIn
           , FALSE    ::Boolean     AS isSendOnPrice

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Reason.Id         AS Id
           , Object_Reason.ObjectCode AS Code
           , Object_Reason.ValueData  AS NAME 
           , ObjectString_Short.ValueData ::TVarChar AS Short
          
           , Object_ReturnKind.Id        AS ReturnKindId
           , Object_ReturnKind.ValueData AS ReturnKindName            

           , Object_ReturnDescKind.Id           AS ReturnDescKindId
           , Object_ReturnDescKind.ValueData    AS ReturnDescKindName 

           , ObjectFloat_PeriodDays.ValueData ::TFloat AS PeriodDays
           , ObjectFloat_PeriodTax.ValueData  ::TFloat AS PeriodTax

           , ObjectString_Comment.ValueData AS Comment
           , COALESCE (ObjectBoolean_ReturnIn.ValueData, FALSE)    ::Boolean AS isReturnIn
           , COALESCE (ObjectBoolean_SendOnPrice.ValueData, FALSE) ::Boolean AS isSendOnPrice

           , Object_Reason.isErased   AS isErased
           
       FROM Object AS Object_Reason
          LEFT JOIN ObjectLink AS ObjectLink_ReturnKind
                               ON ObjectLink_ReturnKind.ObjectId = Object_Reason.Id 
                              AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
          LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = ObjectLink_ReturnKind.ChildObjectId  

          LEFT JOIN ObjectLink AS ObjectLink_ReturnDescKind
                               ON ObjectLink_ReturnDescKind.ObjectId = Object_Reason.Id 
                              AND ObjectLink_ReturnDescKind.DescId = zc_ObjectLink_Reason_ReturnDescKind()
          LEFT JOIN Object AS Object_ReturnDescKind ON Object_ReturnDescKind.Id = ObjectLink_ReturnDescKind.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_ReturnIn
                                  ON ObjectBoolean_ReturnIn.ObjectId = Object_Reason.Id
                                 AND ObjectBoolean_ReturnIn.DescId = zc_ObjectBoolean_Reason_ReturnIn()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_SendOnPrice
                                  ON ObjectBoolean_SendOnPrice.ObjectId = Object_Reason.Id
                                 AND ObjectBoolean_SendOnPrice.DescId = zc_ObjectBoolean_Reason_SendOnPrice()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Reason.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_Reason_Comment()

          LEFT JOIN ObjectString AS ObjectString_Short
                                 ON ObjectString_Short.ObjectId = Object_Reason.Id 
                                AND ObjectString_Short.DescId = zc_ObjectString_Reason_Short()

          LEFT JOIN ObjectFloat AS ObjectFloat_PeriodDays
                                ON ObjectFloat_PeriodDays.ObjectId = Object_Reason.Id
                               AND ObjectFloat_PeriodDays.DescId = zc_ObjectFloat_Reason_PeriodDays()
          LEFT JOIN ObjectFloat AS ObjectFloat_PeriodTax
                                ON ObjectFloat_PeriodTax.ObjectId = Object_Reason.Id
                               AND ObjectFloat_PeriodTax.DescId = zc_ObjectFloat_Reason_PeriodTax()
       WHERE Object_Reason.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.23         *
 17.06.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Reason (0, '2')