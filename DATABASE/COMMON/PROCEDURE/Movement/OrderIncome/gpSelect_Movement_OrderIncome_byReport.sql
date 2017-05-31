-- Function: gpSelect_Movement_OrderIncome_byReport()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderIncome_byReport (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderIncome_byReport (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderIncome_byReport(
    IN inGoodsId           Integer    , --
    IN inMovementId_List   TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_Full TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertDate TDateTime, InsertName TVarChar
             , Amount TFloat, AmountOrder TFloat, AmountIncome TFloat
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , UnitId Integer, UnitName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar, Comment_MI TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
             , DayCount TFloat
             , MovementId_Income Integer, InvNumber_Income TVarChar, OperDate_Income TDateTime, InvNumber_Income_Full TVarChar
             , FromName_Income TVarChar
             , isNotOne Boolean
             , isClosed Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIndex Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderIncome());
     vbUserId:= lpGetUserBySession (inSession);


     -- таблица Id документов заявок
     CREATE TEMP TABLE tmp_List (MovementId Integer) ON COMMIT DROP;
     -- парсим
     vbIndex := 1;
     WHILE SPLIT_PART (inMovementId_List, ';', vbIndex) <> '' LOOP
         -- добавляем то что нашли
         INSERT INTO tmp_List (MovementId) SELECT SPLIT_PART (inMovementId_List, ';', vbIndex) :: Integer;
         -- теперь следуюющий
         vbIndex := vbIndex + 1;
     END LOOP;


     -- Результат
     RETURN QUERY
     WITH tmpIncome AS (SELECT Movement.Id AS MovementId
                             , Movement_Income.*
                             , MovementLinkObject_From.ObjectId           AS FromId
                             , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                             , MovementItem.Amount
                         FROM tmp_List
                              LEFT JOIN Movement ON Movement.Id = tmp_List.MovementId
                                                AND Movement.DescId = zc_Movement_OrderIncome()
                              INNER JOIN MovementLinkMovement AS MovementLinkMovement_Income
                                                              ON MovementLinkMovement_Income.MovementChildId = Movement.Id
                                                             AND MovementLinkMovement_Income.DescId          = zc_MovementLinkMovement_Order()
                              INNER JOIN Movement AS Movement_Income ON Movement_Income.Id     = MovementLinkMovement_Income.MovementId
                                                                    AND Movement_Income.DescId = zc_Movement_Income()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Income.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = False
                                                     AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                       )
      ,  tmpMI AS (SELECT tmp_List.MovementId
                        , SUM (MovementItem.Amount) AS Amount
                        , SUM (COALESCE (MIFloat_AmountOrder.ValueData, 0))  AS AmountOrder
                        , STRING_AGG (MIString_Comment.ValueData :: TVarChar, '; ') AS Comment
                        , COALESCE (MIBoolean_Close.ValueData, FALSE) AS isClose
                   FROM tmp_List
                        INNER JOIN MovementItem ON MovementItem.MovementId = tmp_List.MovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = False
                        INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                          ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                         AND (MILinkObject_Goods.ObjectId = inGoodsId OR inGoodsId = 0)
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                                    ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                        LEFT JOIN MovementItemString AS MIString_Comment
                                                     ON MIString_Comment.MovementItemId = MovementItem.Id
                                                    AND MIString_Comment.DescId = zc_MIString_Comment()
                        LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                                      ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                                     AND MIBoolean_Close.DescId = zc_MIBoolean_Close()
                   GROUP BY tmp_List.MovementId
                          , MIBoolean_Close.ValueData
                   )

       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
           , Movement.OperDate                      AS OperDate
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName

           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName

           , COALESCE (tmpMI.Amount, 0)   :: TFloat AS Amount
             
           , CASE WHEN tmpMI.isClose = TRUE OR MovementBoolean_Closed.ValueData = TRUE
                       THEN 0
                  ELSE COALESCE (tmpMI.AmountOrder, 0) + COALESCE (tmpMI.Amount, 0) - COALESCE (Movement_Income.Amount, 0)
             END :: TFloat AS AmountOrder

           , COALESCE (Movement_Income.Amount, 0) :: TFloat AS AmountIncome

           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_CurrencyValue.ValueData  AS CurrencyValue
           , MovementFloat_ParValue.ValueData       AS ParValue

           , Object_CurrencyDocument.Id             AS CurrencyDocumentId
           , Object_CurrencyDocument.ValueData      AS CurrencyDocumentName

           , Object_Unit.Id                         AS UnitId
           , Object_Unit.ValueData                  AS UnitName

           , Object_Juridical.Id                    AS JuridicalId
           , Object_Juridical.ValueData             AS JuridicalName

           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName

           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementString_Comment.ValueData       AS Comment
           , tmpMI.Comment              ::TVarChar  AS Comment_MI

           , COALESCE (MovementDate_OperDateStart.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate)) ::TDateTime  AS OperDateStart
           , COALESCE (MovementDate_OperDateEnd.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') ::TDateTime  AS OperDateEnd
           , COALESCE (MovementFloat_DayCount.ValueData, 30)  ::TFloat  AS DayCount

           , Movement_Income.Id                       AS MovementId_Income
           , (CASE WHEN Movement_Income.StatusId = zc_Enum_Status_Erased() THEN 'Удален № ' WHEN Movement_Income.StatusId = zc_Enum_Status_UnComplete() THEN '***' ELSE '' END ||  Movement_Income.InvNumber) :: TVarChar AS InvNumber_Income
           , Movement_Income.OperDate                 AS OperDate_Income
           , (CASE WHEN Movement_Income.StatusId = zc_Enum_Status_Erased() THEN 'Удален № ' WHEN Movement_Income.StatusId = zc_Enum_Status_UnComplete() THEN '***' ELSE '' END || '№ ' || Movement_Income.InvNumber || ' от ' || Movement_Income.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Income_Full
           , CASE WHEN Object_FromIncome.DescId = zc_Object_Juridical() THEN Object_FromIncome.ValueData ELSE Object_JuridicalFromIncome.ValueData END :: TVarChar AS FromName_Income
           , CASE WHEN COALESCE (Movement_Income.Id,0) <> 0
                  THEN CASE WHEN Object_FromIncome.DescId = zc_Object_Juridical()
                            THEN CASE WHEN COALESCE (Object_FromIncome.Id, 0) <> COALESCE (Object_Juridical.Id, 0) THEN TRUE ELSE FALSE END
                            ELSE CASE WHEN COALESCE (Movement_Income.JuridicalId, 0) <> COALESCE (Object_Juridical.Id, 0) THEN TRUE ELSE FALSE END
                       END
                  ELSE FALSE
             END AS isNotOne
           , CASE WHEN tmpMI.isClose = TRUE THEN TRUE ELSE COALESCE (MovementBoolean_Closed.ValueData, FALSE) END :: Boolean AS isClosed
       FROM tmp_List AS tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                      ON MovementBoolean_Closed.MovementId = Movement.Id
                                     AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId =  Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                    ON MovementFloat_DayCount.MovementId = Movement.Id
                                   AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN tmpIncome AS Movement_Income ON Movement_Income.MovementId = Movement.Id
            LEFT JOIN Object AS Object_FromIncome          ON Object_FromIncome.Id          = Movement_Income.FromId
            LEFT JOIN Object AS Object_JuridicalFromIncome ON Object_JuridicalFromIncome.Id = Movement_Income.JuridicalId

            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement.Id
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.05.17         *
 17.05.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderIncome_byReport (inGoodsId := 2048 , inMovementId_List := '5604996' ,  inSession := '5');
