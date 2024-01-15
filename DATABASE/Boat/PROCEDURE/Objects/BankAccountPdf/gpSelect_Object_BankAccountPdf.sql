-- Function: gpSelect_Object_BankAccountPdf(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccountPdf(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccountPdf(
    IN inMovmentItemId      Integer, 
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName TVarChar
             , DocTagId Integer, DocTagName TVarChar
             , Comment TVarChar) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MovmentItemCondition());

   RETURN QUERY 
     SELECT 
            Object_BankAccountPdf.Id        AS Id
          , Object_BankAccountPdf.ValueData AS FileName
          , Object_DocTag.Id                AS DocTagId
          , Object_DocTag.ValueData         AS DocTagName
          , ObjectString_Comment.ValueData  AS Comment
     FROM Object AS Object_BankAccountPdf
          JOIN ObjectFloat AS ObjectFloat_BankAccountPdf_MovmentItemId
                           ON ObjectFloat_BankAccountPdf_MovmentItemId.ObjectId = Object_BankAccountPdf.Id
                          AND ObjectFloat_BankAccountPdf_MovmentItemId.DescId = zc_ObjectFloat_BankAccountPdf_MovmentItemId()
                          AND ObjectFloat_BankAccountPdf_MovmentItemId.ValueData = inMovmentItemId   
          LEFT JOIN ObjectLink AS ObjectLink_BankAccountPdf_DocTag
                               ON ObjectLink_BankAccountPdf_DocTag.ObjectId = Object_BankAccountPdf.Id
                              AND ObjectLink_BankAccountPdf_DocTag.DescId = zc_ObjectLink_BankAccountPdf_DocTag()
          LEFT JOIN Object AS Object_DocTag ON Object_DocTag.Id = ObjectLink_BankAccountPdf_DocTag.ChildObjectId 
                   
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_BankAccountPdf.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_BankAccountPdf_Comment()
                                
     WHERE Object_BankAccountPdf.DescId = zc_Object_BankAccountPdf(); 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_BankAccountPdf (0,'2')