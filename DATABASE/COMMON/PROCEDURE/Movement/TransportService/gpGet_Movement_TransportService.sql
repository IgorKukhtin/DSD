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
             , StartRunPlan TDateTime, StartRun TDateTime
             , Amount TFloat, SummAdd TFloat
             , SummTransport TFloat, WeightTransport TFloat
             , Distance TFloat, Price TFloat, CountPoint TFloat, TrevelTime TFloat
             , ContractConditionValue TFloat
             , Comment TVarChar
             , ContractId Integer, ContractName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar
             , CarTrailerId Integer, CarTrailerName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
             , MemberExternalId Integer, MemberExternalName TVarChar, DriverCertificate TVarChar
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
           
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS StartRunPlan 
           , CAST (DATE_TRUNC ('MINUTE', CURRENT_TIMESTAMP) AS TDateTime) AS StartRun 

           , 0::TFloat                        AS Amount
           , 0::TFloat                        AS SummAdd
           , 0::TFloat                        AS SummTransport
           , 0::TFloat                        AS WeightTransport
           , 0::TFloat                        AS Distance
           , 0::TFloat                        AS Price
           , 0::TFloat                        AS CountPoint
           , 0::TFloat                        AS TrevelTime
           , 0::TFloat                        AS ContractConditionValue  

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
           , 0                                AS CarTrailerId
           , CAST ('' as TVarChar)            AS CarTrailerName

           , 0                                AS ContractConditionKindId
           , CAST ('' as TVarChar)            AS ContractConditionKindName

           , View_Unit.Id                     AS UnitForwardingId
           , View_Unit.Name                   AS UnitForwardingName

           , 0                                AS MemberExternalId
           , CAST ('' as TVarChar)            AS MemberExternalName
           , CAST ('' as TVarChar)            AS DriverCertificate

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Object_Unit_View AS View_Unit
                                       ON View_Unit.BranchId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.AccessKeyId = lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_TransportService()))
                                      AND View_Unit.Id IN (SELECT lfSelect.UnitId
                                                           FROM lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect
                                                           WHERE lfSelect.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40100()
                                                              OR (lfSelect.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40200()
                                                              AND lfSelect.UnitName ILIKE '%Транспорт%')
                                                          )
       ORDER BY View_Unit.Id
       LIMIT 1
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
           
           , COALESCE (CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime), CAST (DATE_TRUNC ('MINUTE', Movement.OperDate) AS TDateTime))  AS StartRunPlan
           , COALESCE (CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRun.ValueData)     AS TDateTime), CAST (DATE_TRUNC ('MINUTE', Movement.OperDate) AS TDateTime)) AS StartRun

           , MovementItem.Amount             AS Amount
           , MIFloat_SummAdd.ValueData       AS SummAdd
           , COALESCE (MIFloat_SummTransport.ValueData, 0)   :: TFloat  AS SummTransport
           , COALESCE (MIFloat_WeightTransport.ValueData, 0) :: TFloat  AS WeightTransport
           , MIFloat_Distance.ValueData      AS Distance
           , MIFloat_Price.ValueData         AS Price
           , MIFloat_CountPoint.ValueData    AS CountPoint
           , MIFloat_TrevelTime.ValueData    AS TrevelTime
           , (COALESCE (MIFloat_ContractValue.ValueData, 0) + COALESCE (MIFloat_ContractValueAdd.ValueData, 0)) :: TFloat AS ContractConditionValue   

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

           , Object_CarTrailer.Id        AS CarTrailerId
           , Object_CarTrailer.ValueData AS CarTrailerName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName
           
           , Object_MemberExternal.Id         AS MemberExternalId
           , Object_MemberExternal.ValueData  AS MemberExternalName
           , ObjectString_DriverCertificate.ValueData :: TVarChar AS DriverCertificate
   
       FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
            
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 

            LEFT JOIN MovementItemFloat AS MIFloat_SummTransport
                                        ON MIFloat_SummTransport.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummTransport.DescId = zc_MIFloat_SummTransport()

            LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                        ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTransport.DescId = zc_MIFloat_WeightTransport()
                              
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

            LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
            LEFT JOIN MovementItemFloat AS MIFloat_ContractValue
                                        ON MIFloat_ContractValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContractValue.DescId = zc_MIFloat_ContractValue()
            LEFT JOIN MovementItemFloat AS MIFloat_ContractValueAdd
                                        ON MIFloat_ContractValueAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContractValueAdd.DescId = zc_MIFloat_ContractValueAdd()
                                       
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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CarTrailer
                                             ON MILinkObject_CarTrailer.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_CarTrailer.DescId = zc_MILinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MILinkObject_CarTrailer.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MemberExternal
                                             ON MILinkObject_MemberExternal.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_MemberExternal.DescId = zc_MILinkObject_MemberExternal()
            LEFT JOIN Object AS Object_MemberExternal ON Object_MemberExternal.Id = MILinkObject_MemberExternal.ObjectId

            LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                   ON ObjectString_DriverCertificate.ObjectId = MILinkObject_MemberExternal.ObjectId
                                  AND ObjectString_DriverCertificate.DescId = zc_ObjectString_MemberExternal_DriverCertificate()

            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = Movement.Id
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()
            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = Movement.Id
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_TransportService();

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.12.20         * add MIFloat_SummTransport
 03.07.16         *
 16.12.15         * add WeightTransport
 26.01.14                                        * add zc_MovementLinkObject_UnitForwarding
 25.01.14                                        * add inOperDate
 23.12.13         *
 */

-- тест
-- SELECT * FROM gpGet_Movement_TransportService (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= '2')
