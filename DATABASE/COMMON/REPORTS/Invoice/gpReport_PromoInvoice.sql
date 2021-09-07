-- Function: gpReport_PromoPromoInvoice ()

DROP FUNCTION IF EXISTS gpReport_PromoInvoice (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PromoInvoice(
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
    WITH
      tmpMovement AS (SELECT Movement.Id
                           , Movement.ParentId
                           , Movement.OperDate
                           , Movement.InvNumber
                           , Object_BonusKind.Id                    AS BonusKindId
                           , Object_BonusKind.ValueData             AS BonusKindName
                           , Object_PaidKind.Id                     AS PaidKindId
                           , Object_PaidKind.ValueData              AS PaidKindName
                      FROM Movement AS Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_BonusKind
                                                        ON MovementLinkObject_BonusKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_BonusKind.DescId = zc_MovementLinkObject_BonusKind()
                           LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MovementLinkObject_BonusKind.ObjectId
                   
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
                   
                      WHERE Movement.DescId = zc_Movement_PromoInvoice()
                        AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                     )

    , tmpMovementFloat AS (SELECT *
                           FROM MovementFloat
                           WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementFloat.DescId IN (zc_MovementFloat_TotalSumm())
                          )
    , tmpMovementString AS (SELECT *
                            FROM MovementString
                            WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              AND MovementString.DescId IN (zc_MovementString_Comment(), zc_MovementString_InvNumberPartner())
                           )

    , tmpPromoInvoice AS (SELECT Movement.Id                               AS MovementId
                               , Movement.ParentId
                               , Movement.OperDate
                               , Movement.InvNumber
                               , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                               , Movement.PaidKindId
                               , Movement.PaidKindName
                               , Movement.BonusKindId
                               , Movement.BonusKindName
                               , MovementFloat_TotalSumm.ValueData         AS TotalSumm
                               , MovementString_Comment.ValueData          AS Comment
                          FROM tmpMovement AS Movement
                              LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                                         ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                        AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()   
   
                              LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                                          ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                         AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                      
                              LEFT JOIN tmpMovementString AS MovementString_Comment
                                                          ON MovementString_Comment.MovementId = Movement.Id
                                                         AND MovementString_Comment.DescId = zc_MovementString_Comment()
                            )
       -- данные из док. Акция
       , tmpPromo AS (SELECT Movement.Id AS MovementId
                           , Movement.OperDate
                           , Movement.InvNumber
                           , Object_Status.Id         AS StatusId
                           , Object_Status.ObjectCode AS StatusCode
                      FROM (SELECT DISTINCT tmpPromoInvoice.ParentId FROM tmpPromoInvoice) AS tmp
                           LEFT JOIN Movement ON Movement.Id = tmp.ParentId
                           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                     ) 
       -- данніе док Акция
       , tmpMovementDate AS (SELECT *
                             FROM MovementDate
                             WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpPromo.MovementId FROM tmpPromo)
                               AND MovementDate.DescId IN (zc_MovementDate_StartSale()
                                                         , zc_MovementDate_EndSale()
                                                         , zc_MovementDate_StartPromo()
                                                         , zc_MovementDate_EndPromo()
                                                         , zc_MovementDate_Month())
                             )
       , tmpMovementLinkObject AS (SELECT *
                                   FROM MovementLinkObject
                                   WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpPromo.MovementId FROM tmpPromo)
                                     AND MovementLinkObject.DescId IN (zc_MovementLinkObject_PromoKind()
                                                                     , zc_MovementLinkObject_PriceList()
                                                                     , zc_MovementLinkObject_Unit())
                                   )


       -- ищем док. оплат
       , tmpMLM_PromoInvoice AS (SELECT *
                                 FROM MovementLinkMovement
                                 WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpPromoInvoice.MovementId FROM tmpPromoInvoice)
                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                                )
   
       , tmpMovementList AS (SELECT *
                             FROM Movement
                             WHERE Movement.Id IN (SELECT DISTINCT tmpMLM_PromoInvoice.MovementId FROM tmpMLM_PromoInvoice)
                               AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_Service())
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.OperDate <= inEndDate
                            ) 

       , tmpMIList AS (SELECT *
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementList.MovementId FROM tmpMovementList)
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE                   
                      )

       , tmpMLM AS (SELECT tmp.MovementId_PromoInvoice
                           , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma_Before
                           , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma
                           , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma_Before
                           , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma
                    FROM (SELECT tmpPromoInvoice.MovementId AS MovementId_PromoInvoice
                               , Movement.OperDate AS MLM_OperDate
                               , CASE WHEN Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()) THEN -1 * MovementItem.Amount ELSE 0 END AS BankSumma
                               , CASE WHEN Movement.DescId = zc_Movement_Service() THEN -1 * MovementItem.Amount ELSE 0 END AS ServiceSumma 
                           FROM tmpPromoInvoice
                                INNER JOIN tmpMLM_PromoInvoice AS MLM_PromoInvoice
                                                               ON MLM_PromoInvoice.MovementChildId = tmpListPromoInvoice.MovementId
                                                              AND MLM_PromoInvoice.DescId = zc_MovementLinkMovement_PromoInvoice()
                                INNER JOIN tmpMovementList AS Movement 
                                                           ON Movement.Id = MLM_PromoInvoice.MovementId

                                INNER JOIN tmpMIList AS MovementItem
                                                     ON MovementItem.MovementId = Movement.Id
                          ) AS tmp
                     GROUP BY tmp.MovementId_PromoInvoice
                    )



  SELECT *
  FROM
 (SELECT tmpMIPromoInvoice.MovementId
       , tmpMIPromoInvoice.InvNumber
       , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
       , ('№ ' || tmpMIPromoInvoice.InvNumber || ' от ' || tmpMIPromoInvoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Full
       , tmpMIPromoInvoice.OperDate
       , tmpMIPromoInvoice.PaidKindName
       , tmpMIPromoInvoice.JuridicalId
       , tmpMIPromoInvoice.JuridicalName
       , Object_NameBefore.ValueData               AS NameBeforeName

       , COALESCE (Object_Asset.ValueData, '') :: TVarChar AS AssetName
       , COALESCE (Object_Unit.ValueData, '')  :: TVarChar AS UnitName
       , MIString_Comment.ValueData            :: TVarChar AS Comment

       , tmpMIPromoInvoice.Amount              ::TFloat
       --, tmpMIPromoInvoice.Price               ::TFloat
       , CASE WHEN tmpMIPromoInvoice.CountForPrice > 0
              THEN CAST (COALESCE (tmpMIPromoInvoice.Price, 0) / tmpMIPromoInvoice.CountForPrice AS NUMERIC (16, 2))
              ELSE CAST (COALESCE (tmpMIPromoInvoice.Price, 0) AS NUMERIC (16, 2))
         END :: TFloat AS Price
       --, tmpMIPromoInvoice.AmountSumm          ::TFloat
       , CASE WHEN tmpMIPromoInvoice.CountForPrice > 0
              THEN CAST (tmpMIPromoInvoice.Amount * COALESCE (tmpMIPromoInvoice.Price, 0) / tmpMIPromoInvoice.CountForPrice AS NUMERIC (16, 2))
              ELSE CAST (tmpMIPromoInvoice.Amount * COALESCE (tmpMIPromoInvoice.Price, 0) AS NUMERIC (16, 2))
         END :: TFloat AS AmountSumm
       , tmpMIPromoInvoice.TotalSumm           :: TFloat AS TotalSumm
       , tmpMLM.ServiceSumma              :: TFloat AS ServiceSumma
       , (tmpMIPromoInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0)) :: TFloat AS RemStart                 --ост.нач.счет
       , tmpMLM.BankSumma                 :: TFloat AS BankSumma
       , (tmpMIPromoInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0) - COALESCE (tmpMLM.BankSumma, 0))   ::TFloat  AS RemEnd
       , tmpIncomeGroup.IncomeTotalSumma  :: TFloat AS IncomeTotalSumma
       , tmpIncome.IncomeSumma            :: TFloat AS IncomeSumma
       , (-1 * (COALESCE (tmpMLM.BankSumma_Before, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma_Before, 0) - COALESCE (tmpMLM.ServiceSumma_Before, 0))) :: TFloat AS DebetStart
       , (-1 * (COALESCE (tmpMLM.BankSumma_Before, 0) + COALESCE (tmpMLM.BankSumma, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma_Before, 0) - COALESCE (tmpMLM.ServiceSumma_Before, 0) - COALESCE (tmpIncomeGroup.IncomeTotalSumma, 0) - COALESCE (tmpMLM.ServiceSumma, 0))) :: TFloat AS DebetEnd
       , tmpMIPromoInvoiceChild.AmountSumm     :: TFloat AS PaymentPlan

  FROM tmpMIPromoInvoice
       LEFT JOIN tmpMLM         ON tmpMLM.MovementId_PromoInvoice         = tmpMIPromoInvoice.MovementId
       LEFT JOIN tmpIncomeGroup ON tmpIncomeGroup.MovementId_PromoInvoice = tmpMIPromoInvoice.MovementId

       LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                  ON MovementString_InvNumberPartner.MovementId = tmpMIPromoInvoice.MovementId

       LEFT JOIN tmpIncome ON tmpIncome.MovementItemId_PromoInvoice = tmpMIPromoInvoice.MovementItemId
       LEFT JOIN tmpMIPromoInvoiceChild ON tmpMIPromoInvoiceChild.MovementId = tmpMIPromoInvoice.MovementId
       LEFT JOIN Object AS Object_find ON Object_find.Id = tmpMIPromoInvoice.GoodsId
       LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = CASE WHEN Object_find.DescId IN (zc_Object_Asset(), zc_Object_Goods()) THEN Object_find.Id ELSE COALESCE (tmpMIPromoInvoice.NameBeforeId, tmpMIPromoInvoice.GoodsId) END

       LEFT JOIN tmpMovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = tmpMIPromoInvoice.MovementItemId
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
       LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Asset
                                           ON MILinkObject_Asset.MovementItemId = tmpMIPromoInvoice.MovementItemId
                                          AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
       LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
       LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = tmpMIPromoInvoice.MovementItemId
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
       
  ORDER BY tmpMIPromoInvoice.MovementId, Object_NameBefore.ValueData
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
-- select * from gpReport_PromoInvoice(inStartDate := ('29.06.2016')::TDateTime , inEndDate := ('03.07.2016')::TDateTime , inJuridicalId := 15444 , inPaidKindId := 0 ,  inSession := '5');
