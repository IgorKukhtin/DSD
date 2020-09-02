-- Function: gpSelect_Movement_ProfitLossService_Detail51201()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService_Detail51201 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitLossService_Detail51201(
    IN inMovementId         Integer   , -- Главное юр.лицо
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar, DescName TVarChar
             , TotalSumm TFloat, Summ_51201 TFloat, Summ TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProfitLossService());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH 
       tmpMIContainer AS (SELECT ObjectFloat_Partion.ValueData  :: integer AS MovementId
                               , MIContainer.ContainerId
                               , SUM (COALESCE (MIContainer.Amount,0)) AS Summ_51201
                          FROM MovementItemContainer AS MIContainer
                               LEFT JOIN ContainerLinkObject AS CLO_PartionMovement
                                                             ON CLO_PartionMovement.ContainerId = MIContainer.ContainerId
                                                            AND CLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Partion
                                                     ON ObjectFloat_Partion.ObjectId = CLO_PartionMovement.ObjectId
                                                    AND ObjectFloat_Partion.DescId = zc_ObjectFloat_PartionMovement_MovementId()
                          WHERE MIContainer.MovementId = inMovementId
                            AND MIContainer.AccountId = zc_Enum_Account_51201()
                          GROUP BY ObjectFloat_Partion.ValueData
                                 , MIContainer.ContainerId
                          )
     , tmpMovement AS (SELECT tmpMIContainer.MovementId
                            , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProfitLossService() THEN MIContainer.Amount ELSE 0 END)   AS Summ_51201
                            , SUM (CASE WHEN MIContainer.MovementDescId <> zc_Movement_ProfitLossService() THEN MIContainer.Amount ELSE 0 END)  AS Summ
                       FROM tmpMIContainer
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpMIContainer.ContainerId
                       GROUP BY tmpMIContainer.MovementId
                       )

       SELECT
             Movement.Id                                  AS Id
           , Movement.InvNumber                           AS InvNumber
           , Movement.OperDate                            AS OperDate
           , MovementDate_OperDatePartner.ValueData       AS OperDatePartner
           , Object_Status.ObjectCode                     AS StatusCode
           , Object_Status.ValueData                      AS StatusName
           , MovementDesc.ItemName                        AS DescName

           , MovementFloat_TotalSumm.ValueData   ::TFloat  AS TotalSumm
           , COALESCE (tmpMovement.Summ_51201, 0) ::TFloat AS Summ_51201    -- сумма для распределения
           , COALESCE (tmpMovement.Summ, 0)      ::TFloat  AS Summ          -- сумма распределено

           , Object_From.Id                               AS FromId
           , Object_From.ValueData                        AS FromName
           , Object_To.Id                                 AS ToId
           , Object_To.ValueData                          AS ToName
           , Object_PaidKind.Id                           AS PaidKindId
           , Object_PaidKind.ValueData                    AS PaidKindName
           
       FROM tmpMovement
            LEFT JOIN  Movement ON Movement.Id = tmpMovement.MovementId
            LEFT JOIN  MovementDesc ON MovementDesc.Id = Movement.DescId
            
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProfitLossService_Detail51201 (inMovementId:= 17586409 , inSession:= zfCalc_UserAdmin()::TVarChar)
