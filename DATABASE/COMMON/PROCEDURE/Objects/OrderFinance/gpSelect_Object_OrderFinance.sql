-- Function: gpSelect_Object_OrderFinance()

--DROP FUNCTION IF EXISTS gpSelect_Object_OrderFinance(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_OrderFinance(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderFinance(
    IN inisErased    Boolean ,      -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar, BankAccountNameAll TVarChar
             , Comment TVarChar
             , isErased Boolean
             )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderFinance());

   RETURN QUERY 
       SELECT Object_OrderFinance.Id           AS Id
            , Object_OrderFinance.ObjectCode   AS Code
            , Object_OrderFinance.ValueData    AS Name

            , Object_PaidKind.Id               AS PaidKindId
            , Object_PaidKind.ValueData        AS PaidKindName   

            , Object_BankAccount_View.Id       AS BankAccountId
            , Object_BankAccount_View.Name     AS BankAccountName
            , Object_BankAccount_View.BankId   AS BankId
            , Object_BankAccount_View.BankName AS BankName
            , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll

            , ObjectString_Comment.ValueData   AS Comment

            , Object_OrderFinance.isErased     AS isErased

       FROM Object AS Object_OrderFinance
           LEFT JOIN ObjectString AS ObjectString_Comment 
                                  ON ObjectString_Comment.ObjectId = Object_OrderFinance.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_OrderFinance_Comment()

           LEFT JOIN ObjectLink AS OrderFinance_PaidKind
                                ON OrderFinance_PaidKind.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_PaidKind.DescId = zc_ObjectLink_OrderFinance_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = OrderFinance_PaidKind.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_BankAccount
                                ON OrderFinance_BankAccount.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_BankAccount.DescId = zc_ObjectLink_OrderFinance_BankAccount()
           LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = OrderFinance_BankAccount.ChildObjectId
       WHERE Object_OrderFinance.DescId = zc_Object_OrderFinance()
         AND (Object_OrderFinance.isErased = FALSE OR inisErased = TRUE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.20         * add inisErased
 12.08.19         *
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderFinance ('2')
