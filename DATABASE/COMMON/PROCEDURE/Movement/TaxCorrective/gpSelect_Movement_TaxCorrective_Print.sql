-- Function: gpSelect_Movement_TaxCorrective_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inisClientCopy      Boolean  , -- копия для клиента
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE Cursor1 refcursor;
--    DECLARE Cursor2 refcursor;
    DECLARE vbUserId Integer;
    DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;


    OPEN Cursor1 FOR
     WITH tmpMovement AS
         (
           SELECT Movement.Id AS Id
           FROM Movement
           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
           UNION
           SELECT  MovementLinkMovement_Master.MovementId
           FROM MovementLinkMovement AS MovementLinkMovement_Master
           JOIN Movement ON Movement.Id = inMovementId
                        AND Movement.Id = MovementLinkMovement_Master.MovementChildId
                        AND Movement.DescId = zc_Movement_ReturnIn()
           WHERE MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
         )

       SELECT
-- MOVEMENT

             Movement.Id				                                    AS MovementId
           , Movement.InvNumber				                                AS InvNumber
           , Movement.OperDate				                                AS OperDate
           , MovementDate_DateRegistered.ValueData                          AS DateRegistered
           , MovementBoolean_PriceWithVAT.ValueData                         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData                             AS VATPercent
           , MovementFloat_TotalCount.ValueData                             AS TotalCount
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData                          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData                          AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData                              AS TotalSumm
           , MovementString_InvNumberPartner.ValueData                      AS InvNumberPartner
           , Object_From.Id                    		                        AS FromId
           , Object_From.ValueData             		                        AS FromName
           , ObjectHistory_JuridicalDetails_View.OKPO                       AS OKPO_From
           , Object_To.Id                      		                        AS ToId
           , Object_To.ValueData               		                        AS ToName
           , Object_Partner.ObjectCode                                      AS PartnerCode
           , Object_Partner.ValueData               	                    AS PartnerName
           , View_Contract_InvNumber.ContractId        		                AS ContractId
           , View_Contract_InvNumber.invnumber         		                AS ContractName
           , Object_TaxKind.Id                		                        AS TaxKindId
           , Object_TaxKind.ValueData         		                        AS TaxKindName
           , Movement_DocumentMaster.Id                                     AS DocumentMasterId
           , CAST(Movement_DocumentMaster.InvNumber as TVarChar)            AS InvNumber_Master
           , Movement_DocumentChild.Id                                      AS DocumentChildId
           , CAST(MS_DocumentChild_InvNumberPartner.ValueData as TVarChar)  AS InvNumber_Child
           , CASE WHEN inisClientCopy=TRUE
                  THEN 'X' ELSE '' END                                      AS CopyForClient
           , CASE WHEN inisClientCopy=TRUE
                  THEN '' ELSE 'X' END                                      AS CopyForUs
           , CASE WHEN ((MovementFloat_TotalSummPVAT.ValueData
                        -MovementFloat_TotalSummMVAT.ValueData)>10000)
                  THEN 'X' ELSE '' END                                      AS ERPN
-- END MOVEMENT
           , MovementItem.Id                                                AS Id
           , Object_Goods.Id                                                AS GoodsId
           , Object_Goods.ObjectCode                                        AS GoodsCode
           , Object_Goods.ValueData                                         AS GoodsName
           , MovementItem.Amount                                            AS Amount
           , MIFloat_Price.ValueData                                        AS Price
           , MIFloat_CountForPrice.ValueData                                AS CountForPrice
           , Object_GoodsKind.Id                                            AS GoodsKindId
           , Object_GoodsKind.ValueData                                     AS GoodsKindName
           , Object_Measure.Id                                              AS MeasureId
           , Object_Measure.ValueData                                       AS MeasureName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                                           AS AmountSumm


       FROM tmpMovement

           INNER JOIN MovementItem ON   MovementItem.MovementId =  tmpMovement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE

            JOIN Movement ON Movement.Id = MovementItem.MovementId
                         AND Movement.StatusId = zc_Enum_Status_Complete()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                       AND MIFloat_Price.ValueData <> 0

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

-- MOVEMENT

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentMaster
                                           ON MovementLinkMovement_DocumentMaster.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentMaster.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_DocumentMaster.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentChild
                                           ON MovementLinkMovement_DocumentChild.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentChild.DescId = zc_MovementLinkMovement_Child()

            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_DocumentChild.MovementChildId
            LEFT JOIN MovementString AS MS_DocumentChild_InvNumberPartner ON MS_DocumentChild_InvNumberPartner.MovementId = MovementLinkMovement_DocumentChild.MovementChildId
                                                                         AND MS_DocumentChild_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
           ;
-- END MOVEMENT

    RETURN NEXT Cursor1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxCorrective_Print (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.04.14                                                       *
*/

-- тест
/*
BEGIN;
 SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 114784, inisClientCopy:=FALSE ,inSession:= '2'); -- возврат № 35953
COMMIT;
*/