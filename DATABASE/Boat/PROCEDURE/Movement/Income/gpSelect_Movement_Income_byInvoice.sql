-- Function: gpSelect_Movement_Income_byInvoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_byInvoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_byInvoice(
    IN inMovementId_Invoice       Integer , --
    IN inIsErased                 Boolean   , -- показывать удаленные Да/Нет
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MasterMovementId integer, InvNumber Integer, MasterInvNumber Integer
             , OperDate TDateTime, MasterOperDate TDateTime
             , StatusCode Integer, StatusName TVarChar, MasterStatusCode Integer, MasterStatusName TVarChar
             , DescId Integer, ItemName TVarChar 
             , MasterDescId Integer, MasterItemName TVarChar
             , Comment TVarChar
             , MasterComment TVarChar
             , MovementId_Income Integer
             , InvNumber_Income Integer
             , OperDate_Income TDateTime
             , DescId_Income Integer,ItemName_Income TVarChar
             , StatusCode_Income Integer
             , FromId Integer, FromCode Integer, FromName TVarChar  -- поставщик, док приход
             , TotalSumm TFloat
             , TotalSumm_Master TFloat
             , ObjectCode Integer, ObjectName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
       --1) приходы (zc_MovementString_InvNumberInvoice)
       --3) zc_Movement_ProductionUnion - zc_MovementLinkObject_Partner - zc_MI_Detail.Amount (zc_MovementString_InvNumberInvoice) 
      , tmpIncomeProductionUnion AS (SELECT MovementString_InvNumberInvoice.MovementId
                                     FROM  Movement 
                                          INNER JOIN MovementString AS MovementString_InvNumberInvoice
                                                                    ON MovementString_InvNumberInvoice.ValueData = Movement.InvNumber
                                                                   AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()
                                     WHERE Movement.Id = inMovementId_Invoice
                                     )
       --2)продажи (через заказ клиента) 
      , tmpSale AS (SELECT Movement.Id AS MovementId  -- продажа
                    FROM MovementLinkMovement AS MovementLinkMovement_Invoice
                        INNER JOIN Movement ON Movement.ParentId = MovementLinkMovement_Invoice.MovementId
                                           AND Movement.DescId = zc_Movement_Sale()
                    WHERE MovementLinkMovement_Invoice.MovementChildId = inMovementId_Invoice
                     AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                    )
      , tmpMIDetail AS (SELECT MovementItem.MovementId
                             , SUM (COALESCE (MovementItem.Amount,0)) AS Amount 
                        FROM MovementItem
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpIncomeProductionUnion.MovementId FROM tmpIncomeProductionUnion)
                          AND MovementItem.DescId = zc_MI_Detail()
                          AND MovementItem.isErased = FALSE
                        GROUP BY MovementItem.MovementId            
                          
                       )
      , tmpMovement AS (SELECT tmpIncomeProductionUnion.MovementId FROM tmpIncomeProductionUnion 
                       UNION
                        SELECT tmpSale.MovementId FROM tmpSale
                              ) 
                                            
      , tmpData AS (SELECT Movement.Id                                   AS Id
                         , Movement_Master.Id                            AS MasterMovementId
                         , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                         , zfConvert_StringToNumber (Movement_Master.InvNumber) AS MasterInvNumber
                         , Movement.OperDate                             AS OperDate
                         , Movement_Master.OperDate                      AS MasterOperDate
                         , Object_Status.ObjectCode                      AS StatusCode
                         , Object_Status.ValueData                       AS StatusName
                         , Object_StatusMaster.ObjectCode                AS MasterStatusCode
                         , Object_StatusMaster.ValueData                 AS MasterStatusName
                         , MovementDesc.Id                               AS DescId
                         , MovementDesc.ItemName                         AS ItemName
                         , MovementDescMaster.Id                         AS MasterDescId
                         , MovementDescMaster.ItemName                   AS MasterItemName
                         , MovementString_Comment.ValueData              AS Comment
                         , MovementString_CommentMaster.ValueData        AS MasterComment

                         , Movement_Income.Id                                   AS MovementId_Income
                         , zfConvert_StringToNumber (Movement_Income.InvNumber) AS InvNumber_Income
                         , Movement_Income.OperDate                             AS OperDate_Income
                         , MovementDescIncome.Id                                AS DescId_Income
                         , MovementDescIncome.ItemName                          AS ItemName_Income
                         , Object_StatusIncome.ObjectCode                       AS StatusCode_Income
                      
                         -- Итого сумма по документу (без НДС и с учетом всех расходов и скидок)
                         , CASE WHEN Movement.DescId <> zc_Movement_ProductionUnion() THEN MovementFloat_TotalSumm.ValueData ELSE tmpMIDetail.Amount END ::TFloat   AS TotalSumm
                         , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN CASE WHEN Movement.DescId <> zc_Movement_ProductionUnion() THEN MovementFloat_TotalSumm.ValueData ELSE tmpMIDetail.Amount END ELSE 0 END :: TFloat AS TotalSumm_Master

                         , Movement_Master.Id AS MovementId_master

                    FROM tmpMovement 
                         INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                           AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_Sale(), zc_Movement_ProductionUnion())

                         INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                         LEFT JOIN MovementDesc AS MovementDesc ON MovementDesc.Id = Movement.DescId

                         LEFT JOIN MovementString AS MovementString_Comment
                                                  ON MovementString_Comment.MovementId = Movement.Id
                                                 AND MovementString_Comment.DescId = zc_MovementString_Comment()

                         LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = inMovementId_Invoice

                         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                 ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                AND Movement.DescId IN (zc_Movement_Income() , zc_Movement_Sale())

                         LEFT JOIN  tmpMIDetail ON tmpMIDetail.MovementId = Movement.Id
                                               AND Movement.DescId = zc_Movement_ProductionUnion() 

                         LEFT JOIN MovementDesc AS MovementDescMaster ON MovementDescMaster.Id = Movement_Master.DescId

                         LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_Master.StatusId

                         LEFT JOIN MovementString AS MovementString_CommentMaster
                                                  ON MovementString_CommentMaster.MovementId = Movement_Master.Id
                                                 AND MovementString_CommentMaster.DescId = zc_MovementString_Comment()

                         LEFT JOIN Movement     AS Movement_Income     ON Movement_Income.Id     = Movement.ParentId
                         LEFT JOIN MovementDesc AS MovementDescIncome  ON MovementDescIncome.Id  = Movement_Income.DescId
                         LEFT JOIN Object       AS Object_StatusIncome ON Object_StatusIncome.Id = Movement_Income.StatusId
                   )
                       
     , tmpMI_master AS (SELECT tmpData.MasterMovementId
                             , 0                                         AS ObjectCode
                             , STRING_AGG (DISTINCT Object_Object.ValueData, ';') AS ObjectName
                        FROM tmpData

                             LEFT JOIN MovementItem ON MovementItem.MovementId = tmpData.MasterMovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()  
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                          ON MovementLinkObject_Partner.MovementId = tmpData.Id
                                                         AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner() 
                                                         AND tmpData.DescId = zc_Movement_ProductionUnion() 

                             LEFT JOIN Object AS Object_Object ON Object_Object.Id = CASE WHEN tmpData.DescId = zc_Movement_ProductionUnion() THEN MovementLinkObject_Partner.ObjectId ELSE MovementItem.ObjectId END
                        GROUP BY tmpData.MasterMovementId
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
               , tmpMovement.MasterDescId
               , tmpMovement.MasterItemName
               , tmpMovement.Comment
               , tmpMovement.MasterComment

               , tmpMovement.MovementId_Income
               , tmpMovement.InvNumber_Income
               , tmpMovement.OperDate_Income
               , tmpMovement.DescId_Income
               , tmpMovement.ItemName_Income
               , tmpMovement.StatusCode_Income

               , Object_From.Id          AS FromId
               , Object_From.ObjectCode  AS FromCode
               , Object_From.ValueData   AS FromName

               , tmpMovement.TotalSumm
               , tmpMovement.TotalSumm_Master

               , tmpMI_master.ObjectCode :: Integer
               , tmpMI_master.ObjectName :: TVarChar

               , Object_Insert.ValueData              AS InsertName
               , MovementDate_Insert.ValueData        AS InsertDate
               , Object_Update.ValueData              AS UpdateName
               , MovementDate_Update.ValueData        AS UpdateDate
         FROM tmpData AS tmpMovement
              LEFT JOIN tmpMI_master ON tmpMI_master.MasterMovementId = tmpMovement.MasterMovementId

              LEFT JOIN MovementDate AS MovementDate_Insert
                                     ON MovementDate_Insert.MovementId = tmpMovement.Id
                                    AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
              LEFT JOIN MovementLinkObject AS MLO_Insert
                                           ON MLO_Insert.MovementId = tmpMovement.Id
                                          AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

              LEFT JOIN MovementDate AS MovementDate_Update
                                     ON MovementDate_Update.MovementId = tmpMovement.Id
                                    AND MovementDate_Update.DescId = zc_MovementDate_Update()
              LEFT JOIN MovementLinkObject AS MLO_Update
                                           ON MLO_Update.MovementId = tmpMovement.Id
                                          AND MLO_Update.DescId = zc_MovementLinkObject_Update()
              LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = tmpMovement.MovementId_Income
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              LEFT JOIN Object AS Object_From   ON Object_From.Id   = MovementLinkObject_From.ObjectId

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.21         *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_Income_byInvoice (inMovementId_Invoice:= 256, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
