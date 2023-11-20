-- Function: gpSelect_Object_MoneyPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId := inSession;

     RETURN QUERY
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode     
          , Object_Cash.Valuedata AS Name
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
          , ObjectDesc.ItemName
          , Object_Client.isErased
     FROM Object AS Object_Client
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Client.DescId
     WHERE Object_Client.DescId = zc_Object_Client()
      AND Object_Client.isErased = FALSE

    UNION ALL
     SELECT Object_Partner.Id       
          , Object_Partner.ObjectCode     
          , Object_Partner.ValueData
          , ObjectDesc.ItemName
          , Object_Partner.isErased
     FROM Object AS Object_Partner
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
    WHERE Object_Partner.DescId = zc_Object_Partner()
      AND Object_Partner.isErased = FALSE
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
