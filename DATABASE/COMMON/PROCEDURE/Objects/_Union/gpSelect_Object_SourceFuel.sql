-- Function: gpSelect_Object_SourceFuel()

DROP FUNCTION IF EXISTS gpSelect_ObjectFrom_byIncomeFuel (TDateTime, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Object_SourceFuel (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_SourceFuel (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SourceFuel(
    IN inOperDate          TDateTime  , -- дата на которую показывается договор
    IN inToId              Integer    , -- вх.кому
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PaidKindId  Integer, PaidKindName TVarChar
             , ContractId Integer, InvNumber TVarChar
             , ChangePercent TFloat, ChangePrice TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, FuelName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar, PersonalDriverName_inf TVarChar
             , ItemName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
   DECLARE vbToName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_SourceFuel());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);


   -- !!!Временно захардкодил!!!
   IF COALESCE (inOperDate, zc_DateStart()) <= zc_DateStart()
   THEN
       inOperDate:= CURRENT_DATE;
   END IF;

   --
   IF COALESCE (inToId,0) <> 0 
      THEN vbToName := (SELECT Object.ValueData FROM Object WHERE Object.Id = inToId);
      ELSE
           vbToName := '' ::TVarChar;
   END IF;


   -- Результат
   RETURN QUERY
   WITH 
     tmpContract AS (SELECT Object_Contract_View.ContractId
                          , Object_Contract_View.InvNumber
                          , Object_Contract_View.ChangePercent
                          , Object_Contract_View.ChangePrice
                          , Object_Contract_View.JuridicalId
                          , Object_Contract_View.PaidKindId
                     FROM Object_InfoMoney_View
                          JOIN Object_Contract_View ON Object_Contract_View.InfoMoneyId = Object_InfoMoney_View.InfoMoneyId
                                                   -- AND inOperDate BETWEEN Object_Contract_View.StartDate AND Object_Contract_View.EndDate
                                                   AND inOperDate >= Object_Contract_View.StartDate
                                                   AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                   AND Object_Contract_View.isErased = FALSE
                                                   AND inOperDate BETWEEN Object_Contract_View.StartDate_condition AND Object_Contract_View.EndDate_condition
                     WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400() -- ГСМ
                    ) 

     SELECT Object_Partner.Id             AS Id
          , Object_Partner.ObjectCode     AS Code
          , Object_Partner.ValueData      AS Name

          , Object_Juridical.ObjectCode   AS JuridicalCode
          , Object_Juridical.ValueData    AS JuridicalName
          , Object_PaidKind.Id            AS PaidKindId
          , Object_PaidKind.ValueData     AS PaidKindName

          , tmpContract.ContractId
          , tmpContract.InvNumber
          , tmpContract.ChangePercent
          , tmpContract.ChangePrice

          , 0 :: Integer     AS GoodsId
          , NULL :: Integer  AS GoodsCode
          , '' :: TVarChar   AS GoodsName
          , '' :: TVarChar   AS FuelName
          , COALESCE (inToId,0) :: Integer  AS PersonalDriverId
          , ''                  :: TVarChar AS PersonalDriverName
          , vbToName            :: TVarChar AS PersonalDriverName_inf
          , ObjectDesc.ItemName

          , Object_Partner.isErased   AS isErased

     FROM tmpContract
        /*Object_InfoMoney_View
          JOIN Object_Contract_View ON Object_Contract_View.InfoMoneyId = Object_InfoMoney_View.InfoMoneyId
                                   -- AND inOperDate BETWEEN Object_Contract_View.StartDate AND Object_Contract_View.EndDate
                                   AND inOperDate >= Object_Contract_View.StartDate
                                   AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                   AND Object_Contract_View.isErased = FALSE*/
          JOIN ObjectLink AS ObjectLink_Partner_Juridical
                          ON ObjectLink_Partner_Juridical.ChildObjectId = tmpContract.JuridicalId
                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId 

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpContract.JuridicalId 
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpContract.PaidKindId 

          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
    -- WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400() -- ГСМ
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
          , CASE WHEN COALESCE (View_PersonalDriver.PersonalId, 0) <> 0 THEN View_PersonalDriver.PersonalId ELSE COALESCE (inToId,0) END ::Integer   AS PersonalDriverId
          , View_PersonalDriver.PersonalName AS PersonalDriverName
          , CASE WHEN COALESCE (View_PersonalDriver.PersonalName, '') <> '' THEN View_PersonalDriver.PersonalName ELSE vbToName END      :: TVarChar AS PersonalDriverName_inf
          , ObjectDesc.ItemName

          , Object_CardFuel.isErased   AS isErased

     FROM Object AS Object_CardFuel
          LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_CardFuel.AccessKeyId

          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical ON ObjectLink_CardFuel_Juridical.ObjectId = Object_CardFuel.Id
                                                               AND ObjectLink_CardFuel_Juridical.DescId = zc_ObjectLink_CardFuel_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CardFuel_Juridical.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PaidKind ON ObjectLink_CardFuel_PaidKind.ObjectId = Object_CardFuel.Id
                                                              AND ObjectLink_CardFuel_PaidKind.DescId = zc_ObjectLink_CardFuel_PaidKind()
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_CardFuel_PaidKind.ChildObjectId 

          LEFT JOIN tmpContract ON tmpContract.JuridicalId = Object_Juridical.Id
                               AND tmpContract.PaidKindId = Object_PaidKind.Id

          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Goods ON ObjectLink_CardFuel_Goods.ObjectId = Object_CardFuel.Id
                                                           AND ObjectLink_CardFuel_Goods.DescId = zc_ObjectLink_CardFuel_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_CardFuel_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
          LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId

          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_CardFuel.DescId

          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PersonalDriver 
                               ON ObjectLink_CardFuel_PersonalDriver.ObjectId = Object_CardFuel.Id
                              AND ObjectLink_CardFuel_PersonalDriver.DescId = zc_ObjectLink_CardFuel_PersonalDriver()
          LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = ObjectLink_CardFuel_PersonalDriver.ChildObjectId

     WHERE Object_CardFuel.DescId = zc_Object_CardFuel()
       -- AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)

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
          , COALESCE (inToId,0) :: Integer  AS PersonalDriverId
          , ''                  :: TVarChar AS PersonalDriverName
          , vbToName            :: TVarChar AS PersonalDriverName_inf

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
--ALTER FUNCTION gpSelect_Object_SourceFuel (TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.06.17         *
 02.09.14                                        * rem AccessKey...
 22.08.14                                        * add inOperDate >= ...
 13.02.14                                        * add zc_Enum_ContractStateKind_Close
 14.12.13                                        * add vbAccessKeyAll
 12.11.13                                        * rename to gpSelect_Object_SourceFuel
 20.10.13                                        * union
 14.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_SourceFuel (inOperDate := CURRENT_DATE, inToId := 149887, inSession := zfCalc_UserAdmin())
