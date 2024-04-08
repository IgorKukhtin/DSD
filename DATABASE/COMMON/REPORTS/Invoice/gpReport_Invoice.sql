-- Function: gpReport_Invoice ()

DROP FUNCTION IF EXISTS gpReport_Invoice (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Invoice(
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inJuridicalId       Integer ,
    IN inPaidKindId        Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, InvNumberPartner TVarChar, InvNumber_Full TVarChar
             , OperDate TDateTime
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
             , PersonalSumma TFloat
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

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
    WITH
      tmpMovement AS (SELECT Movement_Invoice.Id
                           , Movement_Invoice.OperDate
                           , Movement_Invoice.InvNumber
                           , Object_PaidKind.ValueData              AS PaidKindName
                           , Object_Juridical.Id                    AS JuridicalId
                           , Object_Juridical.ValueData             AS JuridicalName

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

                       WHERE Movement_Invoice.DescId = zc_Movement_Invoice()
                         AND Movement_Invoice.StatusId = zc_Enum_Status_Complete()
                         AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                     )

    , tmpMovementFloat AS (SELECT *
                           FROM MovementFloat
                           WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementFloat.DescId IN (zc_MovementFloat_TotalSumm()
                                                        , zc_MovementFloat_ChangePercent()
                                                        , zc_MovementFloat_VATPercent()
                                                        )
                          )

    , tmpMovementBoolean AS (SELECT *
                             FROM MovementBoolean
                             WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                               AND MovementBoolean.DescId = zc_MovementBoolean_PriceWithVAT()
                          )

    , tmpMI AS (SELECT *
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                  AND MovementItem.DescId   = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                )

    , tmpMIFloat AS (SELECT *
                     FROM MovementItemFloat
                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                       AND MovementItemFloat.DescId IN (zc_MIFloat_CountForPrice()
                                                      , zc_MIFloat_Price()
                                                      )
                    )

    , tmpMILO AS (SELECT *
                  FROM MovementItemLinkObject
                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                    AND MovementItemLinkObject.DescId IN (zc_MILinkObject_NameBefore()
                                                        , zc_MILinkObject_Goods()
                                                        )
                 )

    , tmpMIInvoice AS (SELECT Movement_Invoice.Id             AS MovementId
                            , Movement_Invoice.OperDate
                            , Movement_Invoice.InvNumber
                            , Movement_Invoice.PaidKindName
                            , Movement_Invoice.JuridicalId
                            , Movement_Invoice.JuridicalName

                            , MovementFloat_TotalSumm.ValueData               AS TotalSumm
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

                       FROM tmpMovement AS Movement_Invoice

                            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                                       ON MovementFloat_TotalSumm.MovementId =  Movement_Invoice.Id
                                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()   

                            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                                         ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Invoice.Id
                                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                                       ON MovementFloat_VATPercent.MovementId =  Movement_Invoice.Id
                                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId =  Movement_Invoice.Id
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                            -- строки
                            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement_Invoice.Id

                            LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 
                            LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()   
                            LEFT JOIN tmpMILO AS MILinkObject_NameBefore
                                                             ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore() 
                            LEFT JOIN tmpMILO AS MILinkObject_Goods
                                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

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

       , tmpMLM_Invoice AS (SELECT *
                            FROM MovementLinkMovement
                            WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpListInvoice.MovementId FROM tmpListInvoice)
                              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                           )
   
       , tmpMovementList AS (SELECT *
                             FROM Movement
                             WHERE Movement.Id IN (SELECT DISTINCT tmpMLM_Invoice.MovementId FROM tmpMLM_Invoice)
                               AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_Service(), zc_Movement_PersonalReport())
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.OperDate <= inEndDate
                            ) 

       , tmpMIList AS (SELECT *
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementList.Id FROM tmpMovementList)
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE                   
                      )

       , tmpMLM AS (SELECT tmp.MovementId_Invoice
                           , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma_Before
                           , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma
                           , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma_Before
                           , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma
                           , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.PersonalSumma ELSE 0 END) AS PersonalSumma_Before
                           , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.PersonalSumma ELSE 0 END) AS PersonalSumma
                    FROM (SELECT tmpListInvoice.MovementId AS MovementId_Invoice
                               , Movement.OperDate AS MLM_OperDate
                               , CASE WHEN Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()) THEN -1 * MovementItem.Amount ELSE 0 END AS BankSumma
                               , CASE WHEN Movement.DescId IN (zc_Movement_Service()) THEN -1 * MovementItem.Amount ELSE 0 END AS ServiceSumma 
                               , CASE WHEN Movement.DescId IN (zc_Movement_PersonalReport()) THEN -1 * MovementItem.Amount ELSE 0 END AS PersonalSumma 
                           FROM tmpListInvoice
                                INNER JOIN tmpMLM_Invoice AS MLM_Invoice
                                                          ON MLM_Invoice.MovementChildId = tmpListInvoice.MovementId
                                                         AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                                INNER JOIN tmpMovementList AS Movement 
                                                           ON Movement.Id = MLM_Invoice.MovementId

                                INNER JOIN tmpMIList AS MovementItem
                                                     ON MovementItem.MovementId = Movement.Id
                          ) AS tmp
                     GROUP BY tmp.MovementId_Invoice
                    )

       , tmpMIFloat_Income AS( SELECT MIFloat_Income.*
                               FROM MovementItemFloat AS MIFloat_Income
                               WHERE MIFloat_Income.ValueData IN (SELECT tmpMIInvoice.MovementItemId FROM tmpMIInvoice)
                                 AND MIFloat_Income.DescId = zc_MIFloat_MovementItemId() 
                              )

       , tmpMI_income AS (SELECT *
                          FROM MovementItem
                          WHERE MovementItem.Id IN (SELECT DISTINCT tmpMIFloat_Income.MovementItemId FROM tmpMIFloat_Income)
                         )

       , tmpIncome AS (SELECT MIFloat_Income.ValueData :: Integer AS MovementItemId_Invoice
                           -- , MIContainer.OperDate AS OperDate
                           , SUM (CASE WHEN MIContainer.OperDate < inStartDate                     THEN -1 * MIContainer.Amount ELSE 0 END) AS IncomeSumma_Before
                           , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END) AS IncomeSumma
                       FROM tmpMIFloat_Income AS MIFloat_Income
                           INNER JOIN tmpMI_income AS MovementItem ON MovementItem.Id = MIFloat_Income.MovementItemId 
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementItemId = MovementItem.Id
                                                           AND MIContainer.MovementId     = MovementItem.MovementId
                                                           AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                           AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                           AND MIContainer.isActive       = FALSE
                       GROUP BY MIFloat_Income.ValueData
                             -- , MIContainer.OperDate
                     UNION
                       SELECT MIFloat_Income.ValueData :: Integer AS MovementItemId_Invoice
                           -- , MIContainer.OperDate AS OperDate
                           , SUM (CASE WHEN MIContainer.OperDate < inStartDate                     THEN -1 * MIContainer.Amount ELSE 0 END) AS IncomeSumma_Before
                           , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END) AS IncomeSumma
                       FROM tmpMIFloat_Income AS MIFloat_Income
                           INNER JOIN tmpMI_income AS MovementItem ON MovementItem.Id = MIFloat_Income.MovementItemId 
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementItemId = MovementItem.Id
                                                           AND MIContainer.MovementId     = MovementItem.MovementId
                                                           AND MIContainer.DescId         = zc_MIContainer_SummAsset()
                                                           AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                           AND MIContainer.isActive       = FALSE
                       GROUP BY MIFloat_Income.ValueData
                       )
          
  , tmpIncomeGroup AS (SELECT tmpMIInvoice.MovementId            AS MovementId_Invoice
                            , SUM (tmpIncome.IncomeSumma_Before) AS IncomeTotalSumma_Before
                            , SUM (tmpIncome.IncomeSumma)        AS IncomeTotalSumma
                       FROM tmpIncome
                            LEFT JOIN tmpMIInvoice ON tmpMIInvoice.MovementItemId = tmpIncome.MovementItemId_Invoice
                       GROUP BY tmpMIInvoice.MovementId
                       )

  , tmpMovementString AS (SELECT *
                          FROM MovementString
                          WHERE MovementString.MovementId IN (SELECT tmpMIInvoice.MovementId FROM tmpMIInvoice)
                            AND MovementString.DescId = zc_MovementString_InvNumberPartner()
                          )

  , tmpMovementItemString AS (SELECT *
                          FROM MovementItemString
                          WHERE MovementItemString.MovementItemId IN (SELECT tmpMIInvoice.MovementItemId FROM tmpMIInvoice)
                            AND MovementItemString.DescId = zc_MIString_Comment()
                          )

  , tmpMovementItemLinkObject AS (SELECT *
                          FROM MovementItemLinkObject
                          WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMIInvoice.MovementItemId FROM tmpMIInvoice)
                            AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Asset()
                                                                , zc_MILinkObject_Unit())
                          )

  SELECT *
  FROM
 (SELECT tmpMIInvoice.MovementId
       , tmpMIInvoice.InvNumber
       , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
       , ('№ ' || tmpMIInvoice.InvNumber || ' от ' || tmpMIInvoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Full
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
       , tmpMIInvoice.TotalSumm           :: TFloat AS TotalSumm
       , tmpMLM.ServiceSumma              :: TFloat AS ServiceSumma
       , tmpMLM.PersonalSumma             :: TFloat AS PersonalSumma
       , (tmpMIInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0)) :: TFloat AS RemStart                 --ост.нач.счет
       , tmpMLM.BankSumma                 :: TFloat AS BankSumma
       , (tmpMIInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0) - COALESCE (tmpMLM.BankSumma, 0))   ::TFloat  AS RemEnd
       , tmpIncomeGroup.IncomeTotalSumma  :: TFloat AS IncomeTotalSumma
       , tmpIncome.IncomeSumma            :: TFloat AS IncomeSumma
       , (-1 * (COALESCE (tmpMLM.BankSumma_Before, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma_Before, 0) - COALESCE (tmpMLM.ServiceSumma_Before, 0) - COALESCE (tmpMLM.PersonalSumma_Before, 0) )) :: TFloat AS DebetStart
       , (-1 * (COALESCE (tmpMLM.BankSumma_Before, 0) + COALESCE (tmpMLM.BankSumma, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma_Before, 0) - COALESCE (tmpMLM.ServiceSumma_Before, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma, 0) - COALESCE (tmpMLM.ServiceSumma, 0) - COALESCE (tmpMLM.PersonalSumma_Before, 0) )) :: TFloat AS DebetEnd
       , tmpMIInvoiceChild.AmountSumm     :: TFloat AS PaymentPlan

  FROM tmpMIInvoice
       LEFT JOIN tmpMLM         ON tmpMLM.MovementId_Invoice         = tmpMIInvoice.MovementId
       LEFT JOIN tmpIncomeGroup ON tmpIncomeGroup.MovementId_Invoice = tmpMIInvoice.MovementId

       LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                  ON MovementString_InvNumberPartner.MovementId = tmpMIInvoice.MovementId

       LEFT JOIN tmpIncome ON tmpIncome.MovementItemId_Invoice = tmpMIInvoice.MovementItemId
       LEFT JOIN tmpMIInvoiceChild ON tmpMIInvoiceChild.MovementId = tmpMIInvoice.MovementId
       LEFT JOIN Object AS Object_find ON Object_find.Id = tmpMIInvoice.GoodsId
       LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = CASE WHEN Object_find.DescId IN (zc_Object_Asset(), zc_Object_Goods()) THEN Object_find.Id ELSE COALESCE (tmpMIInvoice.NameBeforeId, tmpMIInvoice.GoodsId) END

       LEFT JOIN tmpMovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = tmpMIInvoice.MovementItemId
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
       LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Asset
                                           ON MILinkObject_Asset.MovementItemId = tmpMIInvoice.MovementItemId
                                          AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
       LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
       LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Unit
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
 02.03.22         * PersonalSumma
 03.08.16         *
 24.07.16         * 
*/

-- тест
-- select * from gpReport_Invoice(inStartDate := ('29.06.2016')::TDateTime , inEndDate := ('03.07.2016')::TDateTime , inJuridicalId := 15444 , inPaidKindId := 0 ,  inSession := '5');
