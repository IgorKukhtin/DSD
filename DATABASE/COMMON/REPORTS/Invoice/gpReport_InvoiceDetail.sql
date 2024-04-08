-- Function: gpReport_InvoiceDetail ()

DROP FUNCTION IF EXISTS gpReport_InvoiceDetail (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_InvoiceDetail(
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inMovementId        Integer , -- Id док. счет
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime
             , ItemName TVarChar
             , FromName TVarChar
             , ToName TVarChar
             , MovementComment TVarChar
             , ServiceSumma TFloat
             , BankSumma TFloat
             , IncomeSumma TFloat
             ) 
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
    WITH
      tmpMIInvoice AS (SELECT Movement_Invoice.Id             AS MovementId
                            , MovementItem.Id                 AS MovementItemId
                       FROM Movement AS Movement_Invoice
                       
                            -- строки
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Invoice.Id
                       WHERE Movement_Invoice.Id = inMovementId
                       )

       , tmpListInvoice AS (SELECT DISTINCT
                                   tmpMIInvoice.MovementId
                            FROM tmpMIInvoice
                           ) 
        -- находим док-ты оплат
       , tmpMLM_Invoice AS (SELECT *
                            FROM MovementLinkMovement
                            WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpListInvoice.MovementId FROM tmpListInvoice)
                              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                           )
   
       , tmpMovementList AS (SELECT *
                             FROM Movement
                             WHERE Movement.Id IN (SELECT DISTINCT tmpMLM_Invoice.MovementId FROM tmpMLM_Invoice)
                               AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_Service())
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            ) 

       , tmpMIList AS (SELECT *
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementList.Id FROM tmpMovementList)
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE                   
                      )
       -- деньги
       , tmpMoney AS (SELECT tmp.MovementId
                           , tmp.DescId
                           , tmp.InvNumber
                           , tmp.OperDate
                           , SUM (tmp.BankSumma)    AS BankSumma
                           , SUM (tmp.ServiceSumma) AS ServiceSumma
                      FROM (SELECT Movement.DescId
                                 , Movement.OperDate
                                 , Movement.InvNumber
                                 , Movement.Id       AS MovementId
                                 , CASE WHEN Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()) THEN -1 * MovementItem.Amount ELSE 0 END AS BankSumma
                                 , CASE WHEN Movement.DescId = zc_Movement_Service() THEN -1 * MovementItem.Amount ELSE 0 END AS ServiceSumma 
                             FROM tmpListInvoice
                                  INNER JOIN tmpMLM_Invoice AS MLM_Invoice
                                                            ON MLM_Invoice.MovementChildId = tmpListInvoice.MovementId
                                                           AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                                  INNER JOIN tmpMovementList AS Movement 
                                                             ON Movement.Id = MLM_Invoice.MovementId
                                  INNER JOIN tmpMIList AS MovementItem
                                                       ON MovementItem.MovementId = Movement.Id
                            ) AS tmp
                       GROUP BY tmp.MovementId
                              , tmp.InvNumber
                              , tmp.OperDate
                              , tmp.DescId
                      )

       -- приходы
       , tmpMIFloat_Income AS( SELECT MIFloat_Income.*
                               FROM MovementItemFloat AS MIFloat_Income
                               WHERE MIFloat_Income.ValueData IN (SELECT tmpMIInvoice.MovementItemId FROM tmpMIInvoice)
                                 AND MIFloat_Income.DescId = zc_MIFloat_MovementItemId() 
                              )

       , tmpMI_income AS (SELECT *
                          FROM MovementItem
                          WHERE MovementItem.Id IN (SELECT DISTINCT tmpMIFloat_Income.MovementItemId FROM tmpMIFloat_Income)
                         )

       , tmpIncome AS (SELECT Movement.Id        AS MovementId
                            , Movement.DescId    AS DescId
                            , Movement.OperDate  AS OperDate
                            , Movement.InvNumber AS InvNumber
                            , SUM (-1 * MIContainer.Amount) AS IncomeSumma
                       FROM tmpMIFloat_Income AS MIFloat_Income
                           INNER JOIN tmpMI_income AS MovementItem ON MovementItem.Id = MIFloat_Income.MovementItemId 
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementItemId = MovementItem.Id
                                                           AND MIContainer.MovementId     = MovementItem.MovementId
                                                           AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                           AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                           AND MIContainer.isActive       = FALSE
                                                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                           LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                       GROUP BY Movement.Id
                              , Movement.OperDate
                              , Movement.InvNumber
                       HAVING SUM (-1 * MIContainer.Amount) <> 0
                       )

       , tmpData AS (SELECT tmpIncome.MovementId
                          , tmpIncome.DescId
                          , tmpIncome.InvNumber
                          , tmpIncome.OperDate
                          , tmpIncome.IncomeSumma
                          , 0 AS BankSumma
                          , 0 AS ServiceSumma
                     FROM tmpIncome 
                    UNION
                     SELECT tmpMoney.MovementId
                          , tmpMoney.DescId
                          , tmpMoney.InvNumber
                          , tmpMoney.OperDate
                          , 0 AS IncomeSumma
                          , tmpMoney.BankSumma
                          , tmpMoney.ServiceSumma
                     FROM tmpMoney
                     )

       , tmpMovementString AS (SELECT *
                               FROM MovementString
                               WHERE MovementString.MovementId IN (SELECT tmpData.MovementId FROM tmpData)
                                 AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                             , zc_MovementString_Comment())
                               )

       , tmpMovementLinkObject AS (SELECT *
                                   FROM MovementLinkObject
                                   WHERE MovementLinkObject.MovementId IN (SELECT tmpData.MovementId FROM tmpData)
                                     AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                                     , zc_MovementLinkObject_To())
                                   )

  -- результат
  SELECT tmpData.MovementId                           AS MovementId
       , tmpData.InvNumber                            AS InvNumber
       , MovementString_InvNumberPartner.ValueData    AS InvNumberPartner
       , tmpData.OperDate                             AS OperDate
       , MovementDesc.ItemName                        AS ItemName
       , COALESCE (Object_From.ValueData, CASE WHEN MovementItem.Amount > 0 THEN Object_MoneyPlace.ValueData ELSE NULL END) ::TVarChar AS FromName
       , COALESCE (Object_To.ValueData, CASE WHEN MovementItem.Amount < 0 THEN Object_MoneyPlace.ValueData ELSE NULL END)   ::TVarChar AS ToName
       , COALESCE (MovementString_Comment.ValueData, MIS_Comment.ValueData) :: TVarChar AS MovementComment
       , tmpData.ServiceSumma             :: TFloat   AS ServiceSumma
       , tmpData.BankSumma                :: TFloat   AS BankSumma
       , tmpData.IncomeSumma              :: TFloat   AS IncomeSumma

  FROM tmpData
       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.DescId

       LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId = tmpData.MovementId
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

       LEFT JOIN tmpMovementString AS MovementString_Comment
                                   ON MovementString_Comment.MovementId = tmpData.MovementId
                                  AND MovementString_Comment.DescId = zc_MovementString_Comment()

       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = tmpData.MovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = tmpData.MovementId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
       LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
       
       LEFT JOIN MovementItem ON MovementItem.MovementId = tmpData.MovementId
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.IsErased = FALSE

       LEFT JOIN MovementItemString AS MIS_Comment
                                    ON MIS_Comment.MovementItemId = MovementItem.Id
                                   AND MIS_Comment.DescId         = zc_MIString_Comment()
       LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                        ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                       AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                            ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
       LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = COALESCE (MILinkObject_MoneyPlace.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)
      ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.20         *
*/

-- тест
-- select * from gpReport_InvoiceDetail(inStartDate := ('25.11.2019')::TDateTime , inEndDate := ('25.01.2020')::TDateTime , inMovementId := 14801394 ,  inSession := '5');
