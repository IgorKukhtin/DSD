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
          , Object_BankAccount.Valuedata AS Name
          , ObjectDesc.ItemName
          , Object_BankAccount.isErased
     FROM Object AS Object_BankAccount
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_BankAccount.DescId
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
