-- Function: gpSelect_ObjectFrom_byIncomeFuel()

DROP FUNCTION IF EXISTS gpSelect_ObjectFrom_byIncomeFuel (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectFrom_byIncomeFuel(
    IN inOperDate          TDateTime  , -- дата на которую показывается договор
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PaidKindId  Integer, PaidKindName TVarChar
             , ContractId Integer, InvNumber TVarChar
             , ChangePercent TFloat, ChangePrice TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, FuelName TVarChar, ItemName TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());

   RETURN QUERY
     SELECT Object_Partner.Id             AS Id
          , Object_Partner.ObjectCode     AS Code
          , Object_Partner.ValueData      AS Name

          , Object_Juridical.ObjectCode   AS JuridicalCode
          , Object_Juridical.ValueData    AS JuridicalName
          , Object_PaidKind.Id            AS PaidKindId
          , Object_PaidKind.ValueData     AS PaidKindName

          , Object_Contract_View.ContractId
          , Object_Contract_View.InvNumber
          , Object_Contract_View.ChangePercent
          , Object_Contract_View.ChangePrice

          , 0 :: Integer     AS GoodsId
          , NULL :: Integer  AS GoodsCode
          , '' :: TVarChar   AS GoodsName
          , '' :: TVarChar   AS FuelName

          , ObjectDesc.ItemName

          , Object_Partner.isErased   AS isErased

     FROM Object_InfoMoney_View
          JOIN Object_Contract_View ON Object_Contract_View.InfoMoneyId = Object_InfoMoney_View.InfoMoneyId
                                   -- AND inOperDate BETWEEN Object_Contract_View.StartDate AND Object_Contract_View.EndDate
          JOIN ObjectLink AS ObjectLink_Partner_Juridical
                          ON ObjectLink_Partner_Juridical.ChildObjectId = Object_Contract_View.JuridicalId
                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId

          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId

     WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400() -- ГСМ
    UNION ALL
     SELECT Object_CardFuel.Id             AS Id
          , Object_CardFuel.ObjectCode     AS Code
          , Object_CardFuel.ValueData      AS Name

          , Object_Juridical.ObjectCode   AS JuridicalCode
          , Object_Juridical.ValueData    AS JuridicalName
          , Object_PaidKind.Id            AS PaidKindId
          , Object_PaidKind.ValueData     AS PaidKindName

          , tmpContract.ContractId
          , tmpContract.InvNumber
          , tmpContract.ChangePercent
          , tmpContract.ChangePrice

          , Object_Goods.Id           AS GoodsId
          , Object_Goods.ObjectCode   AS GoodsCode
          , Object_Goods.ValueData    AS GoodsName
          , Object_Fuel.ValueData     AS FuelName

          , ObjectDesc.ItemName

          , Object_CardFuel.isErased   AS isErased

     FROM Object AS Object_CardFuel
          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical ON ObjectLink_CardFuel_Juridical.ObjectId = Object_CardFuel.Id
                                                               AND ObjectLink_CardFuel_Juridical.DescId = zc_ObjectLink_CardFuel_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CardFuel_Juridical.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PaidKind ON ObjectLink_CardFuel_PaidKind.ObjectId = Object_CardFuel.Id
                                                              AND ObjectLink_CardFuel_PaidKind.DescId = zc_ObjectLink_CardFuel_PaidKind()
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_CardFuel_PaidKind.ChildObjectId

          LEFT JOIN (SELECT Object_Contract_View.ContractId
                          , Object_Contract_View.InvNumber
                          , Object_Contract_View.ChangePercent
                          , Object_Contract_View.ChangePrice
                          , Object_Contract_View.JuridicalId
                          , Object_Contract_View.PaidKindId
                     FROM Object_InfoMoney_View
                          JOIN Object_Contract_View ON Object_Contract_View.InfoMoneyId = Object_InfoMoney_View.InfoMoneyId
                                                   -- AND inOperDate BETWEEN Object_Contract_View.StartDate AND Object_Contract_View.EndDate
                     WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400() -- ГСМ
                     ) AS tmpContract ON tmpContract.JuridicalId = Object_Juridical.Id
                                     AND tmpContract.PaidKindId = Object_PaidKind.Id


          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Goods ON ObjectLink_CardFuel_Goods.ObjectId = Object_CardFuel.Id
                                                           AND ObjectLink_CardFuel_Goods.DescId = zc_ObjectLink_CardFuel_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_CardFuel_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
          LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId    

          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_CardFuel.DescId

     WHERE Object_CardFuel.DescId = zc_Object_CardFuel()

    UNION ALL
     SELECT Object_TicketFuel.Id           AS Id
          , Object_TicketFuel.ObjectCode   AS Code
          , Object_TicketFuel.ValueData    AS Name

          , Object_Juridical.ObjectCode   AS JuridicalCode
          , Object_Juridical.ValueData    AS JuridicalName

          , 0 :: Integer   AS PaidKindId
          , '' :: TVarChar AS PaidKindName

          , 0 :: Integer   AS ContractId
          , '' :: TVarChar AS InvNumber
          , 0 :: TFloat    AS ChangePercent
          , 0 :: TFloat    AS ChangePrice

          , Object_Goods.Id           AS GoodsId
          , Object_Goods.ObjectCode   AS GoodsCode
          , Object_Goods.ValueData    AS GoodsName
          , Object_Fuel.ValueData     AS FuelName

          , ObjectDesc.ItemName

          , Object_TicketFuel.isErased   AS isErased

     FROM Object AS Object_TicketFuel
          LEFT JOIN ObjectLink AS ObjectLink_TicketFuel_Goods ON ObjectLink_TicketFuel_Goods.ObjectId = Object_TicketFuel.Id
                                                             AND ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_TicketFuel_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
          LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId    

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = zc_Juridical_Basis()
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_TicketFuel.DescId

     WHERE Object_TicketFuel.DescId = zc_Object_TicketFuel()
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ObjectFrom_byIncomeFuel (TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.13                                        * union
 14.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectFrom_byIncomeFuel (inOperDate := CURRENT_DATE, inSession := zfCalc_UserAdmin())