-- Function: gpGet_Object_OrderFinance()

DROP FUNCTION IF EXISTS gpGet_Object_OrderFinance(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_OrderFinance(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar
             , Comment TVarChar
             , isErased Boolean
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_OrderFinance());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_OrderFinance()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , 0                      AS PaidKindId
           , CAST ('' as TVarChar)  AS PaidKindName 

           , 0                      AS BankAccountId
           , CAST ('' as TVarChar)  AS BankAccountName

           , 0                      AS BankId
           , CAST ('' as TVarChar)  AS BankName

           , CAST ('' as TVarChar)  AS Comment     
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT Object_OrderFinance.Id           AS Id
            , Object_OrderFinance.ObjectCode   AS Code
            , Object_OrderFinance.ValueData    AS Name

            , Object_PaidKind.Id               AS PaidKindId
            , Object_PaidKind.ValueData        AS PaidKindName   

            , Object_BankAccount.Id            AS BankAccountId
            , Object_BankAccount.ValueData     AS BankAccountName

            , Object_Bank.Id                   AS BankId
            , Object_Bank.ValueData            AS BankName

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
           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = OrderFinance_BankAccount.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                ON ObjectLink_BankAccount_Bank.ObjectId = OrderFinance_BankAccount.ChildObjectId
                               AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

       WHERE Object_OrderFinance.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.20         * add BankName
 12.08.19         *
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_OrderFinance(0,'2')