-- Function: gpReport_Invoice ()

DROP FUNCTION IF EXISTS gpReport_Invoice (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Invoice(
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inJuridicalId       Integer ,
    IN inPaidKindId        Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime
             , PaidKindName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , NameBeforeName TVarChar
             , AssetName TVarChar
             , UnitName TVarChar
             , Comment TVarChar
                         
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
             , PaymentPlan TFloat
             ) 
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH tmpMIInvoice AS (SELECT Movement_Invoice.Id             AS MovementId
                               , Movement_Invoice.OperDate
                               , Movement_Invoice.InvNumber
                               , Object_PaidKind.ValueData              AS PaidKindName
                               , MovementFloat_TotalSumm.ValueData      AS TotalSumm
                               , Object_Juridical.Id                    AS JuridicalId
                               , Object_Juridical.ValueData             AS JuridicalName
                               , MovementItem.Id                                 AS MovementItemId
                               , COALESCE (MILinkObject_NameBefore.ObjectId, 0)  AS NameBeforeId
                               , COALESCE (MovementItem.ObjectId, 0)             AS MeasureId
                               , MovementItem.Amount                             AS Amount
                               , CASE WHEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, True) = True 
                                      THEN CASE WHEN COALESCE(MovementFloat_ChangePercent.ValueData,0) <> 0 THEN CAST ( (1 + COALESCE(MovementFloat_ChangePercent.ValueData,0) / 100) * (COALESCE (MIFloat_Price.ValueData, 0)) AS NUMERIC (16, 2))
                                                ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                           END
                                      ELSE CASE WHEN COALESCE(MovementFloat_ChangePercent.ValueData,0) <> 0 THEN CAST ( (1 + COALESCE(MovementFloat_ChangePercent.ValueData,0) / 100) * (CAST ( (1 + COALESCE(MovementFloat_VATPercent.ValueData,0) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                                ELSE CAST ( (1 + COALESCE(MovementFloat_VATPercent.ValueData,0) / 100) * (COALESCE (MIFloat_Price.ValueData, 0)) AS NUMERIC (16, 2))
                                           END
                                 END   AS Price
                               , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                               , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice

                           FROM Movement AS Movement_Invoice
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                       ON MovementLinkObject_Juridical.MovementId = Movement_Invoice.Id
                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                      AND (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                            ON MovementLinkObject_PaidKind.MovementId = Movement_Invoice.Id
                                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                               LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                      ON MovementFloat_TotalSumm.MovementId =  Movement_Invoice.Id
                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()   

                               LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                         ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Invoice.Id
                                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                               LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                        ON MovementFloat_VATPercent.MovementId =  Movement_Invoice.Id
                                                       AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                               LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                        ON MovementFloat_ChangePercent.MovementId =  Movement_Invoice.Id
                                                       AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                               

                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Invoice.Id
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
                           WHERE Movement_Invoice.DescId = zc_Movement_Invoice()
                             AND Movement_Invoice.StatusId = zc_Enum_Status_Complete()
                             AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                            )
       , tmpListInvoice AS (SELECT DISTINCT
                                   tmpMIInvoice.MovementId
                                 , tmpMIInvoice.OperDate
                                 , tmpMIInvoice.InvNumber
                                 , tmpMIInvoice.TotalSumm
                                 , tmpMIInvoice.JuridicalId
                                 , tmpMIInvoice.JuridicalName
                            FROM tmpMIInvoice
                           ) 
       , tmpMIInvoiceChild AS (SELECT tmpListInvoice.MovementId
                                    , SUM (MovementItem.Amount) AS AmountSumm
                               FROM tmpListInvoice
                                 INNER JOIN MovementItem 
                                         ON MovementItem.MovementId = tmpListInvoice.MovementId
                                        AND MovementItem.DescId   = zc_MI_Child()
                                        AND MovementItem.isErased = FALSE
                                 INNER JOIN MovementItemDate AS MIDate_OperDate
                                        ON MIDate_OperDate.MovementItemId =  MovementItem.Id
                                       AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                                       AND MIDate_OperDate.ValueData BETWEEN inStartDate AND inENDDate
                               GROUP BY tmpListInvoice.MovementId
                               )
         , tmpMLM AS (SELECT tmp.MovementId_Invoice
                           , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma_Before
                           , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma
                           , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma_Before
                           , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma
                      FROM (SELECT tmpListInvoice.MovementId AS MovementId_Invoice
                                 , Movement.OperDate AS MLM_OperDate
                                 , CASE WHEN Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()) THEN -1 * MovementItem.Amount ELSE 0 END AS BankSumma
                                 , CASE WHEN Movement.DescId = zc_Movement_Service() THEN -1 * MovementItem.Amount ELSE 0 END AS ServiceSumma 
                             FROM tmpListInvoice
                                  INNER JOIN MovementLinkMovement AS MLM_Invoice
                                                                  ON MLM_Invoice.MovementChildId = tmpListInvoice.MovementId
                                                                 AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                                  INNER JOIN Movement ON Movement.Id = MLM_Invoice.MovementId
                                                     AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_Service())
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                                     AND Movement.OperDate <= inEndDate
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                            ) AS tmp
                       GROUP BY tmp.MovementId_Invoice
                      )
                     
      , tmpIncome AS (SELECT MIFloat_Income.ValueData :: Integer AS MovementItemId_Invoice
                           , MIContainer.OperDate AS OperDate
                           , CASE WHEN MIContainer.OperDate < inStartDate THEN -1 * MIContainer.Amount ELSE 0  END AS IncomeSumma_Before
                           , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END AS IncomeSumma
                      FROM MovementItemFloat AS MIFloat_Income
                           INNER JOIN MovementItem ON MovementItem.Id = MIFloat_Income.MovementItemId 
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementItemId = MovementItem.Id
                                                           AND MIContainer.MovementId     = MovementItem.MovementId
                                                           AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                           AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                           AND MIContainer.isActive       = FALSE
                      WHERE MIFloat_Income.ValueData IN (SELECT tmpMIInvoice.MovementItemId FROM tmpMIInvoice)
                        AND MIFloat_Income.DescId = zc_MIFloat_MovementItemId()
                     )
          
  , tmpIncomeGroup AS (SELECT tmpMIInvoice.MovementId            AS MovementId_Invoice
                            , SUM (tmpIncome.IncomeSumma_Before) AS IncomeTotalSumma_Before
                            , SUM (tmpIncome.IncomeSumma)        AS IncomeTotalSumma
                       FROM tmpIncome
                            LEFT JOIN tmpMIInvoice ON tmpMIInvoice.MovementItemId = tmpIncome.MovementItemId_Invoice
                       GROUP BY tmpMIInvoice.MovementId
                       )

  SELECT *
  FROM
 (SELECT tmpMIInvoice.MovementId
       , tmpMIInvoice.InvNumber
       , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
       , tmpMIInvoice.OperDate
       , tmpMIInvoice.PaidKindName
       , tmpMIInvoice.JuridicalId
       , tmpMIInvoice.JuridicalName
       , Object_NameBefore.ValueData               AS NameBeforeName

       , COALESCE (Object_Asset.ValueData, '') :: TVarChar AS AssetName
       , COALESCE (Object_Unit.ValueData, '')  :: TVarChar AS UnitName
       , MIString_Comment.ValueData            :: TVarChar AS Comment

       , tmpMIInvoice.Amount              ::TFloat
       --, tmpMIInvoice.Price               ::TFloat
       , CASE WHEN tmpMIInvoice.CountForPrice > 0
              THEN CAST (COALESCE (tmpMIInvoice.Price, 0) / tmpMIInvoice.CountForPrice AS NUMERIC (16, 2))
              ELSE CAST (COALESCE (tmpMIInvoice.Price, 0) AS NUMERIC (16, 2))
         END :: TFloat AS Price
       --, tmpMIInvoice.AmountSumm          ::TFloat
       , CASE WHEN tmpMIInvoice.CountForPrice > 0
              THEN CAST (tmpMIInvoice.Amount * COALESCE (tmpMIInvoice.Price, 0) / tmpMIInvoice.CountForPrice AS NUMERIC (16, 2))
              ELSE CAST (tmpMIInvoice.Amount * COALESCE (tmpMIInvoice.Price, 0) AS NUMERIC (16, 2))
         END :: TFloat AS AmountSumm
       , tmpMIInvoice.TotalSumm           ::TFloat AS TotalSumm
       , tmpMLM.ServiceSumma              ::TFloat AS ServiceSumma
       , (tmpMIInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0))  ::TFloat  AS RemStart                 --ост.нач.счет
       , tmpMLM.BankSumma                 ::TFloat AS BankSumma
       , (tmpMIInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0) - COALESCE (tmpMLM.BankSumma, 0))   ::TFloat  AS RemEnd
       , tmpIncomeGroup.IncomeTotalSumma  ::TFloat AS IncomeTotalSumma
       , tmpIncome.IncomeSumma            ::TFloat AS IncomeSumma
       , (COALESCE (tmpMLM.BankSumma_Before, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma_Before, 0) - COALESCE (tmpMLM.ServiceSumma_Before, 0))  ::TFloat AS DebetStart
       , (COALESCE (tmpMLM.BankSumma_Before, 0) + COALESCE (tmpMLM.BankSumma, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma_Before, 0) - COALESCE (tmpMLM.ServiceSumma_Before, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma, 0) - COALESCE (tmpMLM.ServiceSumma, 0))  ::TFloat AS DebetEnd
       , tmpMIInvoiceChild.AmountSumm     ::TFloat AS PaymentPlan

  FROM tmpMIInvoice
       LEFT JOIN tmpMLM         ON tmpMLM.MovementId_Invoice         = tmpMIInvoice.MovementId
       LEFT JOIN tmpIncomeGroup ON tmpIncomeGroup.MovementId_Invoice = tmpMIInvoice.MovementId

       LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                ON MovementString_InvNumberPartner.MovementId = tmpMIInvoice.MovementId
                               AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

       LEFT JOIN tmpIncome ON tmpIncome.MovementItemId_Invoice = tmpMIInvoice.MovementItemId
       LEFT JOIN tmpMIInvoiceChild ON tmpMIInvoiceChild.MovementId = tmpMIInvoice.MovementId
       LEFT JOIN Object AS Object_find ON Object_find.Id = tmpMIInvoice.GoodsId
       LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = CASE WHEN Object_find.DescId IN (zc_Object_Asset(), zc_Object_Goods()) THEN Object_find.Id ELSE COALESCE (tmpMIInvoice.NameBeforeId, tmpMIInvoice.GoodsId) END

       LEFT JOIN MovementItemString AS MIString_Comment
                                    ON MIString_Comment.MovementItemId = tmpMIInvoice.MovementItemId
                                   AND MIString_Comment.DescId = zc_MIString_Comment()
       LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                        ON MILinkObject_Asset.MovementItemId = tmpMIInvoice.MovementItemId
                                       AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
       LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = tmpMIInvoice.MovementItemId
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
       
  ORDER BY tmpMIInvoice.MovementId, Object_NameBefore.ValueData
 ) AS tmpResult
 WHERE tmpResult.RemStart <> 0
    OR tmpResult.PaymentPlan <> 0
    OR tmpResult.BankSumma <> 0
    OR tmpResult.RemEnd <> 0

    OR tmpResult.DebetStart <> 0
    OR tmpResult.IncomeTotalSumma <> 0
    OR tmpResult.ServiceSumma <> 0
    OR tmpResult.DebetEnd <> 0
      ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.16         *
 24.07.16         * 
*/

-- тест
-- select * from gpReport_Invoice(inStartDate := ('29.06.2016')::TDateTime , inEndDate := ('03.07.2016')::TDateTime , inJuridicalId := 15444 , inPaidKindId := 0 ,  inSession := '5');
