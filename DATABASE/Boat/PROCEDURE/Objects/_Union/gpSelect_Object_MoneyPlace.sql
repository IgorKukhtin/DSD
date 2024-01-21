-- Function: gpSelect_Object_MoneyPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InvoiceKindId Integer, InvoiceKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , TaxKind_Value TFloat
             , TaxKindId Integer, TaxKindName TVarChar
             , TaxKindName_Info TVarChar, TaxKindName_Comment TVarChar
             , ItemName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId := inSession;

     RETURN QUERY
     WITH
     tmpData AS (SELECT Object_Cash.Id
                      , Object_Cash.ObjectCode
                      , Object_Cash.Valuedata AS Name
                      , 0  :: Integer  AS InfoMoneyId
                      , 0  :: Integer  AS InfoMoneyCode
                      , '' :: TVarChar AS InfoMoneyName
                      , '' :: TVarChar AS InfoMoneyName_all
                      , 0  :: TFloat   AS TaxKind_Value
                      , 0  :: Integer  AS TaxKindId
                      , '' :: TVarChar AS TaxKindName
                      , '' :: TVarChar AS TaxKindName_Info
                      , '' :: TVarChar AS TaxKindName_Comment
                      , ObjectDesc.ItemName
                      , Object_Cash.isErased
                 FROM Object AS Object_Cash
                      LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
                 WHERE Object_Cash.DescId = zc_Object_Cash()
                   AND Object_Cash.isErased = FALSE

                UNION ALL
                 SELECT Object_BankAccount.Id
                      , Object_BankAccount.ObjectCode
                      , (Object_Bank.Valuedata || ' - ' || Object_BankAccount.Valuedata) :: TVarChar AS Name
                      , 0  :: Integer  AS InfoMoneyId
                      , 0  :: Integer  AS InfoMoneyCode
                      , '' :: TVarChar AS InfoMoneyName
                      , '' :: TVarChar AS InfoMoneyName_all
                      , 0  :: TFloat   AS TaxKind_Value
                      , 0  :: Integer  AS TaxKindId
                      , '' :: TVarChar AS TaxKindName
                      , '' :: TVarChar AS TaxKindName_Info
                      , '' :: TVarChar AS TaxKindName_Comment
                      , ObjectDesc.ItemName
                      , Object_BankAccount.isErased
                 FROM Object AS Object_BankAccount
                      LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_BankAccount.DescId
                      LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                           ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                          AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                      LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                 WHERE Object_BankAccount.DescId = zc_Object_BankAccount()
                   AND Object_BankAccount.isErased = FALSE

                UNION ALL
                 SELECT Object_Client.Id
                      , Object_Client.ObjectCode
                      , Object_Client.ValueData
                      , Object_InfoMoney_View.InfoMoneyId
                      , Object_InfoMoney_View.InfoMoneyCode
                      , Object_InfoMoney_View.InfoMoneyName
                      , Object_InfoMoney_View.InfoMoneyName_all
                      , COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) :: TFloat AS TaxKind_Value
                      , Object_TaxKind.Id                      AS TaxKindId
                      , Object_TaxKind.ValueData               AS TaxKindName
                      , ObjectString_TaxKind_Info.ValueData    AS TaxKindName_Info
                      , ObjectString_TaxKind_Comment.ValueData AS TaxKindName_Comment
                      , ObjectDesc.ItemName
                      , Object_Client.isErased

                 FROM Object AS Object_Client
                      LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Client.DescId
                      LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                           ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                                          AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Client_InfoMoney()
                      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

                      LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                           ON ObjectLink_TaxKind.ObjectId = Object_Client.Id
                                          AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_Client_TaxKind()
                      LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

                      LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                            ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                           AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                      LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                                             ON ObjectString_TaxKind_Info.ObjectId = Object_TaxKind.Id
                                            AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()
                      LEFT JOIN ObjectString AS ObjectString_TaxKind_Comment
                                             ON ObjectString_TaxKind_Comment.ObjectId = Object_TaxKind.Id
                                            AND ObjectString_TaxKind_Comment.DescId = zc_ObjectString_TaxKind_Comment()

                 WHERE Object_Client.DescId = zc_Object_Client()
                  AND Object_Client.isErased = FALSE

                UNION ALL
                 SELECT Object_Partner.Id
                      , Object_Partner.ObjectCode
                      , Object_Partner.ValueData
                      , Object_InfoMoney_View.InfoMoneyId
                      , Object_InfoMoney_View.InfoMoneyCode
                      , Object_InfoMoney_View.InfoMoneyName
                      , Object_InfoMoney_View.InfoMoneyName_all
                      , COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) :: TFloat AS TaxKind_Value
                      , Object_TaxKind.Id                      AS TaxKindId
                      , Object_TaxKind.ValueData               AS TaxKindName
                      , ObjectString_TaxKind_Info.ValueData    AS TaxKindName_Info
                      , ObjectString_TaxKind_Comment.ValueData AS TaxKindName_Comment
                      , ObjectDesc.ItemName
                      , Object_Partner.isErased
                 FROM Object AS Object_Partner
                      LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
                      LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                           ON ObjectLink_InfoMoney.ObjectId = Object_Partner.Id
                                          AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Partner_InfoMoney()
                      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

                      LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                           ON ObjectLink_TaxKind.ObjectId = Object_Partner.Id
                                          AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
                      LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

                      LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                            ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                           AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                      LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                                             ON ObjectString_TaxKind_Info.ObjectId = Object_TaxKind.Id
                                            AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()
                      LEFT JOIN ObjectString AS ObjectString_TaxKind_Comment
                                             ON ObjectString_TaxKind_Comment.ObjectId = Object_TaxKind.Id
                                            AND ObjectString_TaxKind_Comment.DescId = zc_ObjectString_TaxKind_Comment()

                WHERE Object_Partner.DescId = zc_Object_Partner()
                  AND Object_Partner.isErased = FALSE
                )

     SELECT tmpData.Id
          , tmpData.ObjectCode
          , tmpData.Name
          , Object_InvoiceKind.Id        AS InvoiceKindId
          , Object_InvoiceKind.ValueData AS InvoiceKindName
          , tmpData.InfoMoneyId
          , tmpData.InfoMoneyCode
          , tmpData.InfoMoneyName
          , tmpData.InfoMoneyName AS InfoMoneyName_all
        --, tmpData.InfoMoneyName_all
          , tmpData.TaxKind_Value
          , tmpData.TaxKindId
          , tmpData.TaxKindName
          , tmpData.TaxKindName_Info
          , tmpData.TaxKindName_Comment
          , tmpData.ItemName
          , tmpData.isErased
     FROM tmpData
          -- нужен вид счета при выборе клиента
          LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = zc_Enum_InvoiceKind_Service()
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MoneyPlace (inSession:= '2')
