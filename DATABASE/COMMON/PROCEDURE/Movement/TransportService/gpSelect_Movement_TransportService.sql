-- Function: gpSelect_Movement_TransportService()

DROP FUNCTION IF EXISTS gpSelect_Movement_TrasportService (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransportService (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransportService (TDateTime, TDateTime, Boolean , TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransportService (TDateTime, TDateTime, Integer, Boolean , TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportService(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MIId Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, StartRun TDateTime
             , Amount TFloat, SummAdd TFloat, SummTotal TFloat, SummReestr TFloat
             , SummTransport TFloat, WeightTransport TFloat
             , Distance TFloat, Price TFloat, CountPoint TFloat, TrevelTime TFloat
             , ContractValue TFloat, ContractValueAdd TFloat
             , isSummReestr Boolean
             , Comment TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar
             , CarModelId Integer, CarModelName TVarChar
             , CarTrailerId Integer, CarTrailerName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
             , MemberExternalId Integer, MemberExternalName TVarChar, DriverCertificate TVarChar
             , Cost_Info TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportService());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- определяется - может ли пользовать видеть все документы
     IF zfCalc_AccessKey_TransportAll (vbUserId) = TRUE
     THEN vbAccessKeyId:= 0;
     ELSE vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportService());
     END IF;


     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               INNER JOIN Movement ON  Movement.DescId = zc_Movement_TransportService()
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.StatusId = tmpStatus.StatusId
                                                  AND (Movement.AccessKeyId = vbAccessKeyId OR vbAccessKeyId = 0)
                         )
        , tmpCost AS (SELECT tmpMovement.Id
                           , STRING_AGG (DISTINCT '№ ' ||Movement_Income.InvNumber|| ' oт '|| zfConvert_DateToString (Movement_Income.OperDate)||'('||Object_From.ValueData||')' ,';') AS Cost_Info
                      FROM tmpMovement
                           INNER JOIN MovementFloat AS MovementFloat_MovementId
                                                    ON MovementFloat_MovementId.ValueData :: Integer  = tmpMovement.Id
                                                   AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
                           INNER JOIN Movement ON Movement.Id = MovementFloat_MovementId.MovementId
                                              AND Movement.DescId = zc_Movement_IncomeCost()
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           
                           LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = Movement.ParentId
                                 
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                      GROUP BY tmpMovement.Id
                      )
        --строки документов
        , tmpMI AS (SELECT MovementItem.*
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                      AND MovementItem.DescId     = zc_MI_Master()
                    )
        , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                     AND MovementItemFloat.DescId IN ( zc_MIFloat_WeightTransport()
                                                                     , zc_MIFloat_Distance()
                                                                     , zc_MIFloat_Price()
                                                                     , zc_MIFloat_CountPoint()
                                                                     , zc_MIFloat_TrevelTime()
                                                                     , zc_MIFloat_SummAdd()
                                                                     , zc_MIFloat_ContractValue()
                                                                     , zc_MIFloat_ContractValueAdd()
                                                                     , zc_MIFloat_SummReestr()
                                                                     , zc_MIFloat_SummTransport()
                                                                     )
                                   )

        , tmpMovementItemBoolean AS (SELECT MovementItemBoolean.*
                                     FROM MovementItemBoolean
                                     WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemBoolean.DescId = zc_MIBoolean_SummReestr()
                                   )

        , tmpMovementItemString AS (SELECT MovementItemString.*
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                      AND MovementItemString.DescId = zc_MIString_Comment()
                                   )

        , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                          AND MovementItemLinkObject.DescId IN ( zc_MILinkObject_Contract()
                                                                               , zc_MILinkObject_InfoMoney()
                                                                               , zc_MILinkObject_PaidKind()
                                                                               , zc_MILinkObject_Route()
                                                                               , zc_MILinkObject_Car()
                                                                               , zc_MILinkObject_CarTrailer()
                                                                               , zc_MILinkObject_ContractConditionKind()
                                                                               , zc_MILinkObject_MemberExternal())
                                        )

        , tmpObjectString AS (SELECT *
                              FROM ObjectString
                              WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpMovementItemLinkObject.ObjectId FROM tmpMovementItemLinkObject WHERE tmpMovementItemLinkObject.DescId = zc_MILinkObject_MemberExternal())
                               AND ObjectString.DescId = zc_ObjectString_MemberExternal_DriverCertificate()
                              )
                                 
       -- результат
       SELECT
             Movement.Id
           , MovementItem.Id as MIId
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
           , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRun.ValueData)     AS TDateTime) AS StartRun

           , MovementItem.Amount
           , MIFloat_SummAdd.ValueData             AS SummAdd
           , (MovementItem.Amount + COALESCE (MIFloat_SummAdd.ValueData, 0)) :: TFloat AS AmountSummTotal
           , MIFloat_SummReestr.ValueData ::TFloat AS SummReestr
           , MIFloat_SummTransport.ValueData   ::TFloat    AS SummTransport
           , MIFloat_WeightTransport.ValueData ::TFloat    AS WeightTransport
           , MIFloat_Distance.ValueData            AS Distance
           , MIFloat_Price.ValueData               AS Price
           , MIFloat_CountPoint.ValueData          AS CountPoint
           , MIFloat_TrevelTime.ValueData          AS TrevelTime
           , MIFloat_ContractValue.ValueData       AS ContractValue
           , MIFloat_ContractValueAdd.ValueData    AS ContractValueAdd

           , COALESCE (MIBoolean_SummReestr.ValueData, TRUE) :: Boolean AS isSummReestr

           , MIString_Comment.ValueData  AS Comment

           , View_Contract_InvNumber.ContractId
           , View_Contract_InvNumber.ContractCode  AS ContractCode
           , View_Contract_InvNumber.InvNumber     AS ContractName

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
     
           , MovementItem.ObjectId       AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName

           , Object_PaidKind.Id          AS PaidKindId
           , Object_PaidKind.ValueData   AS PaidKindName
           
           , Object_Route.Id             AS RouteId
           , Object_Route.ValueData      AS RouteName

           , Object_Car.Id               AS CarId
           , Object_Car.ValueData        AS CarName
           , Object_CarModel.Id          AS CarModelId
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_CarTrailer.Id        AS CarTrailerId
           , Object_CarTrailer.ValueData AS CarTrailerName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName
           
           , Object_MemberExternal.Id          AS MemberExternalId
           , Object_MemberExternal.ValueData   AS MemberExternalName
           , tmpObjectString.ValueData  :: TVarChar AS DriverCertificate

           , tmpCost.Cost_Info ::TVarChar

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = Movement.Id
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()
            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = Movement.Id
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()

            LEFT JOIN tmpCost ON tmpCost.Id = Movement.Id

            -- строки
            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 
 
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummTransport
                                           ON MIFloat_SummTransport.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummTransport.DescId = zc_MIFloat_SummTransport()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_WeightTransport
                                           ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                          AND MIFloat_WeightTransport.DescId = zc_MIFloat_WeightTransport()
                             
            LEFT JOIN tmpMovementItemFloat AS MIFloat_Distance
                                           ON MIFloat_Distance.MovementItemId = MovementItem.Id
                                          AND MIFloat_Distance.DescId = zc_MIFloat_Distance()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
            
            LEFT JOIN tmpMovementItemFloat AS MIFloat_CountPoint
                                           ON MIFloat_CountPoint.MovementItemId = MovementItem.Id
                                          AND MIFloat_CountPoint.DescId = zc_MIFloat_CountPoint()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_TrevelTime
                                           ON MIFloat_TrevelTime.MovementItemId = MovementItem.Id
                                          AND MIFloat_TrevelTime.DescId = zc_MIFloat_TrevelTime()
                                       
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummAdd
                                           ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_ContractValue
                                           ON MIFloat_ContractValue.MovementItemId = MovementItem.Id
                                          AND MIFloat_ContractValue.DescId = zc_MIFloat_ContractValue()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_ContractValueAdd
                                           ON MIFloat_ContractValueAdd.MovementItemId = MovementItem.Id
                                          AND MIFloat_ContractValueAdd.DescId = zc_MIFloat_ContractValueAdd()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummReestr
                                           ON MIFloat_SummReestr.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummReestr.DescId = zc_MIFloat_SummReestr()

            LEFT JOIN tmpMovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id 
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_SummReestr
                                             ON MIBoolean_SummReestr.MovementItemId = MovementItem.Id 
                                            AND MIBoolean_SummReestr.DescId = zc_MIBoolean_SummReestr()            

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Contract
                                                ON MILinkObject_Contract.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_InfoMoney
                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_PaidKind
                                                ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Route
                                                ON MILinkObject_Route.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MILinkObject_Route.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Car
                                                ON MILinkObject_Car.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_CarTrailer
                                                ON MILinkObject_CarTrailer.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_CarTrailer.DescId = zc_MILinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MILinkObject_CarTrailer.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_MemberExternal
                                                ON MILinkObject_MemberExternal.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_MemberExternal.DescId = zc_MILinkObject_MemberExternal()
            LEFT JOIN Object AS Object_MemberExternal ON Object_MemberExternal.Id = MILinkObject_MemberExternal.ObjectId

            LEFT JOIN tmpObjectString ON tmpObjectString.ObjectId = MILinkObject_MemberExternal.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д. 
 05.10.21         * CarTrailerId
 10.12.20         * add SummTransport
 28.05.20         *
 07.10.16         * add inJuridicalBasisId
 03.07.16         *
 16.12.15         * add WeightTransport
 22.09.15         * add inIsErased
 25.01.14                                        * add zc_MovementLinkObject_UnitForwarding
 14.01.14                                        * add Object_Contract_InvNumber_View
 07.01.14                                        * add InfoMoneyCode
 22.12.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportService (inStartDate:= '01.01.2020', inEndDate:= '01.02.2020', inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
