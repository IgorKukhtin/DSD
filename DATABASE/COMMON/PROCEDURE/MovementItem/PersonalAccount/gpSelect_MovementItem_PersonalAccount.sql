-- Function: gpSelect_MovementItem_PersonalAccount (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalAccount (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalAccount(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar, CarModelName TVarChar
             , Amount TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalAccount());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       SELECT MovementItem.Id

            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , View_Contract_InvNumber.ContractId
            , View_Contract_InvNumber.InvNumber AS ContractName

            , Object_Juridical.Id         AS JuridicalId
            , Object_Juridical.ValueData  AS JuridicalName

            , Object_Route.Id             AS RouteId
            , Object_Route.ValueData      AS RouteName

            , Object_Car.Id               AS CarId
            , Object_Car.ValueData        AS CarName
            , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

            , MovementItem.Amount         AS Amount
            , MovementItem.isErased       AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

             JOIN MovementItem ON MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = tmpIsErased.isErased

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
                 
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                              ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
             LEFT JOIN Object AS Object_Route ON Object_Route.Id = MILinkObject_Route.ObjectId
                 
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                              ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId
                                                  
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id =MovementItem.ObjectId

             LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                 AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                  ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
             LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PersonalAccount (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.01.14                                        * add Object_Contract_InvNumber_View
 07.01.14                                        * add InfoMoneyCode
 19.12.13         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PersonalAccount (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_PersonalAccount (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
