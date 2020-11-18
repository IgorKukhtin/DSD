-- Function: gpSelect_Object_ContractTradeMark_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractTradeMark_Choice (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractTradeMark_Choice (Integer ,Integer ,Integer ,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractTradeMark_Choice(
    IN inContractId    Integer ,
    IN inJuridicalId   Integer ,
    IN inRetailId      Integer ,
    IN inisErased      Boolean ,      --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , isErased boolean
             , ContractTagId Integer, ContractTagName TVarChar
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , PriceListGoodsId Integer, PriceListGoodsName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractTradeMark());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpContract AS (SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
                     FROM (SELECT ObjectLink_Juridical_Retail.ObjectId AS JuridicalId
                           FROM ObjectLink AS ObjectLink_Juridical_Retail
                           WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                             AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                             AND inJuridicalId = 0
                         UNION
                           SELECT inJuridicalId AS JuridicalId
                           WHERE inJuridicalId <> 0
                          ) AS tmp
                            INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                  ON ObjectLink_Contract_Juridical.ChildObjectId = tmp.JuridicalId 
                                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                 AND (ObjectLink_Contract_Juridical.ObjectId = inContractId OR inContractId = 0)
                    UNION
                     SELECT inContractId AS ContractId WHERE inContractId <> 0
                     )
       SELECT 
             Object_ContractTradeMark.Id          AS Id
           , Object_ContractTradeMark.ObjectCode  AS Code

           , Object_Contract_View.ContractId      AS ContractId
           , Object_Contract_View.ContractCode    AS ContractCode
           , Object_Contract_View.InvNumber       AS ContractName

           , Object_TradeMark.Id                  AS TradeMarkId
           , Object_TradeMark.ValueData           AS TradeMarkName

           , Object_ContractTradeMark.isErased    AS isErased

           , Object_Contract_View.ContractTagId
           , Object_Contract_View.ContractTagName
           , Object_ContractKind.Id          AS ContractKindId
           , Object_ContractKind.ValueData   AS ContractKindName
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ObjectCode     AS JuridicalCode
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_JuridicalGroup.ValueData AS JuridicalGroupName

           , Object_PriceListGoods.Id        AS PriceListGoodsId
           , Object_PriceListGoods.ValueData AS PriceListGoodsName

           , Object_PaidKind.Id            AS PaidKindId
           , Object_PaidKind.ValueData     AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyGroupCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationCode
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
    FROM Object AS Object_ContractTradeMark
            LEFT JOIN ObjectLink AS ContractTradeMark_Contract
                                 ON ContractTradeMark_Contract.ObjectId = Object_ContractTradeMark.Id
                                AND ContractTradeMark_Contract.DescId = zc_ObjectLink_ContractTradeMark_Contract()
            INNER JOIN tmpContract ON tmpContract.ContractId = ContractTradeMark_Contract.ChildObjectId
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ContractTradeMark_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractTradeMark_TradeMark
                                 ON ObjectLink_ContractTradeMark_TradeMark.ObjectId = Object_ContractTradeMark.Id
                                AND ObjectLink_ContractTradeMark_TradeMark.DescId = zc_ObjectLink_ContractTradeMark_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_ContractTradeMark_TradeMark.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId
            
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Contract_View.JuridicalId
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceListGoods
                                 ON ObjectLink_Contract_PriceListGoods.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_PriceListGoods.DescId = zc_ObjectLink_Contract_PriceListGoods()
            LEFT JOIN Object AS Object_PriceListGoods ON Object_PriceListGoods.Id = ObjectLink_Contract_PriceListGoods.ChildObjectId

     WHERE Object_ContractTradeMark.DescId = zc_Object_ContractTradeMark()
      AND (Object_ContractTradeMark.isErased = FALSE OR inisErased = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractTradeMark_Choice (0,0,0,false, zfCalc_UserAdmin())