-- Function: gpSelect_Object_MoneyPlaceCash()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlaceCash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlaceCash(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ItemName TVarChar, isErased Boolean
             , BankId Integer, BankName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , UnitId Integer, UnitName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , INN TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbIsConstraint Boolean;
  DECLARE vbObjectId_Constraint Integer;

   DECLARE vbIsConstraint_Branch Boolean;
   DECLARE vbObjectId_Constraint_Branch Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId:= lpGetUserBySession (inSession);

      -- Результат
     RETURN QUERY
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode AS Code
          , Object_Cash.Valuedata  AS Name
          , ObjectDesc.ItemName
          , Object_Cash.isErased

          , NULL::Integer AS BankId
          , NULL::TVarChar AS BankName
          , NULL::Integer  AS JuridicalId
          , NULL::TVarChar AS JuridicalName
          , Object_Unit.Id            AS UnitId
          , Object_Unit.ValueData     AS UnitName
          , Object_Currency.Id        AS CurrencyId
          , Object_Currency.ValueData AS CurrencyName
          , ''             ::TVarChar AS INN
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                               ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                              AND ObjectLink_Cash_Currency.DescId   = zc_ObjectLink_Cash_Currency()
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                               ON ObjectLink_Cash_Unit.ObjectId = Object_Cash.Id
                              AND ObjectLink_Cash_Unit.DescId = zc_ObjectLink_Cash_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Cash_Unit.ChildObjectId

     WHERE Object_Cash.DescId = zc_Object_Cash()
    UNION ALL
     SELECT Object_BankAccount.Id
          , Object_BankAccount.ObjectCode AS Code    
          , Object_BankAccount.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_BankAccount.isErased
         
          , Object_Bank.Id             AS BankId
          , Object_Bank.ValueData      AS BankName
          , Object_Juridical.Id        AS JuridicalId
          , Object_Juridical.ValueData AS JuridicalName
          , NULL:: Integer             AS UnitId
          , NULL::TVarChar             AS UnitName
          , Object_Currency.Id         AS CurrencyId
          , Object_Currency.ValueData  AS CurrencyName
          , NULL::TVarChar             AS INN
     FROM Object AS Object_BankAccount
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_BankAccount()

          LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Juridical
                               ON ObjectLink_BankAccount_Juridical.ObjectId = Object_BankAccount.Id
                              AND ObjectLink_BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_BankAccount_Juridical.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                               ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                              AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                               ON ObjectLink_BankAccount_Currency.ObjectId = Object_BankAccount.Id
                              AND ObjectLink_BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_BankAccount_Currency.ChildObjectId
     WHERE Object_BankAccount.DescId = zc_Object_BankAccount()
    UNION ALL
     SELECT Object_Member.Id
          , Object_Member.ObjectCode     
          , Object_Member.ValueData
          , ObjectDesc.ItemName
          , Object_Member.isErased
          
          , NULL::Integer             AS BankId
          , NULL::TVarChar            AS BankName
          , NULL::Integer             AS JuridicalId
          , NULL::TVarChar            AS JuridicalName
          , NULL:: Integer            AS UnitId
          , NULL::TVarChar            AS UnitName
          , NULL:: Integer            AS CurrencyId
          , NULL::TVarChar            AS CurrencyName
          , OS_Member_INN.ValueData   AS INN    
     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Member()
          LEFT JOIN ObjectString AS OS_Member_INN
                                 ON OS_Member_INN.ObjectId = Object_Member.Id
                                AND OS_Member_INN.DescId = zc_ObjectString_Member_INN()
    WHERE Object_Member.DescId = zc_Object_Member()
 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.07.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MoneyPlaceCash (inSession:= '3'::TVarChar)
