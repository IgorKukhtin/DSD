-- Function: gpReport_Invoice ()

DROP FUNCTION IF EXISTS gpReport_Invoice (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Invoice(
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , JuridicalId Integer, JuridicalName TVarChar
             , NameBeforeName TVarChar
             
             , Amount TFloat  -- 
             , Price TFloat  -- 
             , AmountSumm TFloat  
             , TotalSumm TFloat  -- 
             , ServiceSumma TFloat
             , RemStart TFloat
             , BankSumma TFloat
             , RemEnd TFloat
             , IncomeTotalSumma TFloat
             , IncomeSumma TFloat
             , DebetStart TFloat
             , DebetEnd TFloat
             ) 
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
      WITH 

      tmpListInvoice AS (SELECT Movement_Invoice.Id                    AS MovementId
                              , Movement_Invoice.OperDate
                              , Movement_Invoice.InvNumber
                              , MovementFloat_TotalSumm.ValueData      AS TotalSumm
                              , Object_Juridical.Id                    AS JuridicalId
                              , Object_Juridical.ValueData             AS JuridicalName
                           FROM Movement AS Movement_Invoice
                               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                       ON MovementFloat_TotalSumm.MovementId =  Movement_Invoice.Id
                                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()   
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                      ON MovementLinkObject_Juridical.MovementId = Movement_Invoice.Id
                                     AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
                           WHERE Movement_Invoice.DescId = zc_Movement_Invoice()
                             AND Movement_Invoice.StatusId <> zc_Enum_Status_Erased()
                             AND Movement_Invoice.Operdate BETWEEN inStartDate AND inEndDate
                           
                         ) 

              , tmpMIInvoice AS (SELECT tmpListInvoice.MovementId
                               , tmpListInvoice.OperDate
                               , tmpListInvoice.InvNumber
                               , tmpListInvoice.JuridicalId
                               , tmpListInvoice.JuridicalName
                               , tmpListInvoice.TotalSumm
                               , MovementItem.Id                                 AS MovementItemId
                               , COALESCE (MILinkObject_NameBefore.ObjectId, 0)  AS NameBeforeId
                               , COALESCE (MovementItem.ObjectId, 0)             AS MeasureId
                               , MovementItem.Amount                             AS Amount
                               , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                               , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                               , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 1) > 0
                                      THEN CAST (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0) / COALESCE (MIFloat_CountForPrice.ValueData, 1) AS NUMERIC (16, 2))
                                      ELSE CAST (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                 END :: TFloat AS AmountSumm
                           FROM tmpListInvoice
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpListInvoice.MovementId 
                                                         AND MovementItem.DescId   = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()   
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                                                   ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore() 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                            )

         , tmpMLM AS (SELECT tmp.MovementId
                           , SUM(CASE WHEN tmp.MLM_OperDate < inStartDate THEN (tmp.BankSumma) ELSE 0 END) AS BankSumma_Before
                           , SUM(CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN (tmp.BankSumma) ELSE 0 END) AS BankSumma
                           , SUM(CASE WHEN tmp.MLM_OperDate < inStartDate THEN (tmp.ServiceSumma) ELSE 0 END) AS ServiceSumma_Before
                           , SUM(CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN (tmp.ServiceSumma) ELSE 0 END) AS ServiceSumma
                      FROM (SELECT tmpListInvoice.MovementId
                                 , Movement.OperDate AS MLM_OperDate
                                 , CASE WHEN Movement.DescId in (zc_Movement_BankStatementItem(), zc_Movement_BankAccount()) AND COALESCE(MovementFloat_Amount.ValueData,0) >0 THEN COALESCE(MovementFloat_Amount.ValueData,0) ELSE 0 END AS BankSumma 
                                 , CASE WHEN Movement.DescId = zc_Movement_Service()THEN COALESCE(MovementItem.Amount,0) ELSE 0 END AS ServiceSumma 
                             FROM tmpListInvoice
                                  INNER JOIN MovementLinkMovement AS MLM_Invoice
                                                                 ON MLM_Invoice.MovementChildId = tmpListInvoice.MovementId
                                                                AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                                  LEFT JOIN Movement ON Movement.Id = MLM_Invoice.MovementId 
                           
                                  LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                          ON MovementFloat_Amount.MovementId = Movement.Id
                                                         AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                         AND COALESCE(MovementFloat_Amount.ValueData,0) >0
                                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                            ) AS tmp
                       GROUP BY tmp.MovementId, tmp.MLM_OperDate
                      )
                     
      , tmpIncome AS (SELECT tmpMIInvoice.MovementItemId
                           , tmpMIInvoice.MovementId
                           , Movement.OperDate AS Income_OperDate
                           , CASE WHEN Movement.OperDate < inStartDate
                                  THEN (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                             THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                             ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                        END)
                                  ELSE 0 
                             END AS IncomeSumma_Before
                           , CASE WHEN Movement.OperDate Between inStartDate AND inEndDate 
                                  THEN (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                             THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                             ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) + COALESCE (MIFloat_AmountPacker.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                        END)
                                  ELSE 0 
                             END AS IncomeSumma
                      FROM tmpMIInvoice
                      
                           INNER JOIN MovementItemFloat AS MIFloat_Income
                                                        ON CAST(MIFloat_Income.ValueData AS integer) = tmpMIInvoice.MovementItemId   
                                                       AND MIFloat_Income.DescId = zc_MIFloat_MovementItemId()
                           LEFT JOIN MovementItem ON MovementItem.Id = MIFloat_Income.MovementItemId 
                                                 AND MovementItem.isErased = FALSE
                           INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                              AND Movement.DescId = zc_Movement_Income()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                       ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       )
          
  , tmpIncomeGroup AS (SELECT tmpIncome.MovementId
                            , SUM(tmpIncome.IncomeSumma_Before) AS IncomeTotalSumma_Before
                            , SUM(tmpIncome.IncomeSumma)        AS IncomeTotalSumma
                       FROM tmpIncome 
                       GROUP BY tmpIncome.MovementId
                       )

  SELECT tmpMIInvoice.MovementId
       , tmpMIInvoice.InvNumber
       , tmpMIInvoice.OperDate
       , tmpMIInvoice.JuridicalId
       , tmpMIInvoice.JuridicalName
       , Object_NameBefore.ValueData  AS NameBeforeName
       , tmpMIInvoice.Amount              ::TFloat
       , tmpMIInvoice.Price               ::TFloat
       , tmpMIInvoice.AmountSumm          ::TFloat
       , tmpMIInvoice.TotalSumm           ::TFloat
       , tmpMLM.ServiceSumma              ::TFloat
       , (tmpMIInvoice.TotalSumm - tmpMLM.BankSumma_Before)  ::TFloat  AS RemStart                 --ост.нач.счет
       , tmpMLM.BankSumma                 ::TFloat
       , (tmpMIInvoice.TotalSumm - tmpMLM.BankSumma_Before - tmpMLM.BankSumma)   ::TFloat  AS RemEnd
       , tmpIncomeGroup.IncomeTotalSumma  ::TFloat
       , tmpIncome.IncomeSumma            ::TFloat
       , (tmpMIInvoice.TotalSumm - tmpIncomeGroup.IncomeTotalSumma_Before - tmpMLM.ServiceSumma_Before)  ::TFloat AS DebetStart
       , (tmpMIInvoice.TotalSumm - tmpIncomeGroup.IncomeTotalSumma_Before - tmpMLM.ServiceSumma_Before - tmpIncomeGroup.IncomeTotalSumma - tmpMLM.ServiceSumma)  ::TFloat AS DebetEnd
  FROM tmpMIInvoice 
       LEFT JOIN tmpMLM ON tmpMLM.MovementId = tmpMIInvoice.MovementId
       LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = COALESCE(tmpMIInvoice.NameBeforeId, tmpMIInvoice.GoodsId)
       LEFT JOIN tmpIncomeGroup ON tmpIncomeGroup.MovementId = tmpMIInvoice.MovementId
       LEFT JOIN tmpIncome ON tmpIncome.MovementItemId = tmpMIInvoice.MovementItemId
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.07.16         * 
*/

-- тест
--