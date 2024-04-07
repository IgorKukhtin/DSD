-- Function: gpSelect_Movement_IncomeCost()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeCost (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeCost(
    IN inStartDate         TDateTime , -- Дата нач. периода
    IN inEndDate           TDateTime , -- Дата оконч. периода
    IN inIsErased          Boolean   , -- показывать удаленные Да/Нет
    IN inJuridicalBasisId  Integer   , -- главное юр.лицо
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MasterMovementId integer, InvNumber Integer, MasterInvNumber Integer
             , OperDate TDateTime, MasterOperDate TDateTime
             , StatusCode Integer, StatusName TVarChar, MasterStatusCode Integer, MasterStatusName TVarChar
             , DescId Integer, ItemName TVarChar
             , Comment TVarChar
             , MasterComment TVarChar
             , MovementId_Income Integer
             , InvNumber_Income Integer
             , OperDate_Income TDateTime
             , DescId_Income Integer,ItemName_Income TVarChar
             , StatusCode_Income Integer
             , AmountCost TFloat, AmountCost_Master TFloat
             , JuridicalCode Integer, JuridicalName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
      , tmpMovement AS (SELECT Movement.Id                                   AS Id
                             , Movement_Master.Id                            AS MasterMovementId
                             , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                             , zfConvert_StringToNumber (Movement_Master.InvNumber) AS MasterInvNumber
                             , Movement.OperDate                             AS OperDate
                             , Movement_Master.OperDate                      AS MasterOperDate
                             , Object_Status.ObjectCode                      AS StatusCode
                             , Object_Status.ValueData                       AS StatusName
                             , Object_StatusMaster.ObjectCode                AS MasterStatusCode
                             , Object_StatusMaster.ValueData                 AS MasterStatusName

                             , MovementDescMaster.Id                         AS DescId
                             , MovementDescMaster.ItemName                   AS ItemName
                             , MovementString_Comment.ValueData              AS Comment
                             , MovementString_CommentMaster.ValueData        AS MasterComment

                             , Movement_Income.Id                                   AS MovementId_Income
                             , zfConvert_StringToNumber (Movement_Income.InvNumber) AS InvNumber_Income
                             , Movement_Income.OperDate                             AS OperDate_Income
                             , MovementDescIncome.Id                                AS DescId_Income
                             , MovementDescIncome.ItemName                          AS ItemName_Income
                             , Object_StatusIncome.ObjectCode                       AS StatusCode_Income

                             , MovementFloat_AmountCost.ValueData            AS AmountCost
                             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MovementFloat_AmountCost_Master.ValueData, 0) + COALESCE (MovementFloat_AmountMemberCost_Master.ValueData, 0) ELSE 0 END :: TFloat AS AmountCost_Master

                             , Movement_Master.Id AS MovementId_master

                        FROM Movement
                             INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                             LEFT JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId = Movement.Id
                                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
                             LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                                     ON MovementFloat_AmountCost.MovementId = Movement.Id
                                                    AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
                             LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                                     ON MovementFloat_MovementId.MovementId = Movement.Id
                                                    AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
 
                             LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementFloat_MovementId.ValueData :: Integer
 
                             LEFT JOIN MovementFloat AS MovementFloat_AmountCost_Master
                                                     ON MovementFloat_AmountCost_Master.MovementId = Movement_Master.Id
                                                    AND MovementFloat_AmountCost_Master.DescId     = zc_MovementFloat_AmountCost()
                             LEFT JOIN MovementFloat AS MovementFloat_AmountMemberCost_Master
                                                     ON MovementFloat_AmountMemberCost_Master.MovementId = Movement_Master.Id
                                                    AND MovementFloat_AmountMemberCost_Master.DescId     = zc_MovementFloat_AmountMemberCost()
 
                             LEFT JOIN MovementDesc AS MovementDescMaster ON MovementDescMaster.Id = Movement_Master.DescId
 
                             LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_Master.StatusId
 
                             LEFT JOIN MovementString AS MovementString_CommentMaster
                                                      ON MovementString_CommentMaster.MovementId = Movement_Master.Id
                                                     AND MovementString_CommentMaster.DescId = zc_MovementString_Comment()
 
                             LEFT JOIN Movement     AS Movement_Income     ON Movement_Income.Id     = Movement.ParentId
                             LEFT JOIN MovementDesc AS MovementDescIncome  ON MovementDescIncome.Id  = Movement_Income.DescId
                             LEFT JOIN Object       AS Object_StatusIncome ON Object_StatusIncome.Id = Movement_Income.StatusId

                        WHERE Movement.DescId = zc_Movement_IncomeCost()
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          -- Movement.ParentId = inParentId
                       )
     , tmpMI_master AS (SELECT tmpMovement.MovementId_master
                             , 0                                            AS JuridicalCode
                             , STRING_AGG (Object_Juridical.ValueData, ';') AS JuridicalName

                             , 0 AS InfoMoneyCode
                             , STRING_AGG (Object_InfoMoney_View.InfoMoneyName, ';') AS InfoMoneyName
                             , STRING_AGG (Object_InfoMoney_View.InfoMoneyName_all, ';') AS InfoMoneyName_all
                        FROM tmpMovement
                             LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_master
                                                   AND MovementItem.DescId     = zc_MI_Master()
                             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

                        GROUP BY tmpMovement.MovementId_master
                       )
         -- Результат
         SELECT  tmpMovement.Id
               , tmpMovement.MasterMovementId
               , tmpMovement.InvNumber
               , tmpMovement.MasterInvNumber
               , tmpMovement.OperDate
               , tmpMovement.MasterOperDate
               , tmpMovement.StatusCode
               , tmpMovement.StatusName
               , tmpMovement.MasterStatusCode
               , tmpMovement.MasterStatusName

               , tmpMovement.DescId
               , tmpMovement.ItemName
               , tmpMovement.Comment
               , tmpMovement.MasterComment

               , tmpMovement.MovementId_Income
               , tmpMovement.InvNumber_Income
               , tmpMovement.OperDate_Income
               , tmpMovement.DescId_Income
               , tmpMovement.ItemName_Income
               , tmpMovement.StatusCode_Income

               , tmpMovement.AmountCost
               , tmpMovement.AmountCost_Master

               , tmpMI_master.JuridicalCode :: Integer
               , tmpMI_master.JuridicalName :: TVarChar

               , tmpMI_master.InfoMoneyCode :: Integer
               , tmpMI_master.InfoMoneyName :: TVarChar
               , tmpMI_master.InfoMoneyName_all :: TVarChar
         FROM tmpMovement
              LEFT JOIN tmpMI_master ON tmpMI_master.MovementId_master = tmpMovement.MovementId_master
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.01.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeCost (inStartDate:= '01.01.2018', inEndDate:= '01.01.2018', inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
