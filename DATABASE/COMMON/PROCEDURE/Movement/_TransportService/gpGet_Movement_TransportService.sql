-- Function: gpGet_Movement_TransportService()

DROP FUNCTION IF EXISTS gpGet_Movement_TrasportService (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_TransportService (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TransportService(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, MIId Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat, Distance TFloat, Price TFloat, CountPoint TFloat, TrevelTime TFloat
             , Comment TVarChar
             , ContractId Integer, ContractName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , UnitId Integer, UnitName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TransportService());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , 0 AS MIId  
           , CAST (NEXTVAL ('Movement_PersonalAccount_seq') as Integer) AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime) AS OperDate
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName
           
           , 0::TFloat                        AS Amount
           , 0::TFloat                        AS Distance
           , 0::TFloat                        AS Price
           , 0::TFloat                        AS CountPoint
           , 0::TFloat                        AS TrevelTime

           , ''::TVarChar                     AS Comment
           
           , 0                                AS ContractId
           , ''::TVarChar                     AS ContractName

           , 0                                AS InfoMoneyId
           , CAST ('' as TVarChar)            AS InfoMoneyName
           
           , 0                                AS JuridicalId
           , CAST ('' as TVarChar)            AS JuridicalName
           
           , 0                                AS PaidKindId
           , CAST ('' as TVarChar)            AS PaidKindName
  
           , 0                                AS RouteId
           , CAST ('' as TVarChar)            AS RouteName
           
           , 0                                AS CarId
           , CAST ('' as TVarChar)            AS CarName

           , 0                                AS ContractConditionKindId
           , CAST ('' as TVarChar)            AS ContractConditionKindName

           , View_Unit.Id   AS UnitId
           , View_Unit.Name AS UnitName

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Object_Unit_View AS View_Unit ON View_Unit.BranchId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.AccessKeyId = lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_TransportService()))
                                                   AND View_Unit.Id IN (SELECT lfObject_Unit_byProfitLossDirection.UnitId FROM lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection WHERE lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40100())
       ;

     ELSE

     RETURN QUERY 
       SELECT
             Movement.Id
           , MovementItem.Id AS MIId  
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , MovementItem.Amount            AS Amount
           , MIFloat_Distance.ValueData     AS Distance
           , MIFloat_Price.ValueData        AS Price
           , MIFloat_CountPoint.ValueData   AS CountPoint
           , MIFloat_TrevelTime.ValueData   AS TrevelTime

           , MIString_Comment.ValueData  AS Comment

           , Object_Contract.Id          AS ContractId
           , Object_Contract.ValueData   AS ContractName

           , Object_InfoMoney.Id         AS InfoMoneyId
           , Object_InfoMoney.ValueData  AS InfoMoneyName
     
           , MovementItem.ObjectId       AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName

           , Object_PaidKind.Id          AS PaidKindId
           , Object_PaidKind.ValueData   AS PaidKindName
           
           , Object_Route.Id             AS RouteId
           , Object_Route.ValueData      AS RouteName

           , Object_Car.Id               AS CarId
           , Object_Car.ValueData        AS CarName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName
   
       FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
            
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 
                              
            LEFT JOIN MovementItemFloat AS MIFloat_Distance
                                        ON MIFloat_Distance.MovementItemId = MovementItem.Id
                                       AND MIFloat_Distance.DescId = zc_MIFloat_Distance()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            
            LEFT JOIN MovementItemFloat AS MIFloat_CountPoint
                                        ON MIFloat_CountPoint.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountPoint.DescId = zc_MIFloat_CountPoint()

            LEFT JOIN MovementItemFloat AS MIFloat_TrevelTime
                                        ON MIFloat_TrevelTime.MovementItemId = MovementItem.Id
                                       AND MIFloat_TrevelTime.DescId = zc_MIFloat_TrevelTime()
                                       
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id 
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                             ON MILinkObject_Route.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MILinkObject_Route.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TransportService();

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TransportService (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.01.14                                        * add inOperDate
 23.12.13         *
 */

-- тест
-- SELECT * FROM gpGet_Movement_TransportService (inMovementId:= 1, inSession:= '2')
