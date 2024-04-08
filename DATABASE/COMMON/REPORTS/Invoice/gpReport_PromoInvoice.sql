-- Function: gpReport_PromoPromoInvoice ()

DROP FUNCTION IF EXISTS gpReport_PromoInvoice (TDateTime, TDateTime, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PromoInvoice(
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inStartDate2        TDateTime ,
    IN inEndDate2          TDateTime ,
    IN inPaidKindId        Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, StatusCode Integer, InvNumber TVarChar, InvNumberPartner TVarChar, InvNumber_Full TVarChar
             , OperDate TDateTime
             , PaidKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar             
             , Comment TVarChar
             , TotalSumm TFloat  -- 
             , ServiceSumma TFloat
             , RemStart TFloat
             , BankSumma TFloat
             , RemEnd TFloat
             , Amount_ProfitLossService TFloat
             , Amount_PromoInvoice TFloat
             , Amount_diff TFloat

             , MovementId_promo Integer
             , OperDate_promo TDateTime
             , InvNumber_promo  TVarChar
             , StatusCode_promo Integer
             , StartSale_promo TDateTime
             , EndSale_promo  TDateTime
             , StartPromo_promo TDateTime
             , EndPromo_promo TDateTime
             , MonthPromo_promo TDateTime
             , PromoKindName TVarChar
             , UnitName TVarChar
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
      tmpMovement AS (SELECT Movement.Id
                           , Movement.ParentId
                           , Object_Status.ObjectCode AS StatusCode
                           , Movement.OperDate
                           , Movement.InvNumber
                           , Object_BonusKind.Id                    AS BonusKindId
                           , Object_BonusKind.ValueData             AS BonusKindName
                           , Object_PaidKind.Id                     AS PaidKindId
                           , Object_PaidKind.ValueData              AS PaidKindName
                           , Object_Contract.Id                     AS ContractId
                           , Object_Contract.ObjectCode             AS ContractCode
                           , Object_Contract.ValueData              AS ContractName
                           , Object_Juridical.Id                    AS JuridicalId
                           , Object_Juridical.ValueData             AS JuridicalName
                      FROM Movement AS Movement
                           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_BonusKind
                                                        ON MovementLinkObject_BonusKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_BonusKind.DescId = zc_MovementLinkObject_BonusKind()
                           LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MovementLinkObject_BonusKind.ObjectId
                   
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                        ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                       AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
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
                               , Movement.StatusCode
                               , Movement.OperDate
                               , Movement.InvNumber
                               , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                               , Movement.PaidKindId
                               , Movement.PaidKindName
                               , Movement.BonusKindId
                               , Movement.BonusKindName
                               , Movement.ContractId
                               , Movement.ContractCode
                               , Movement.ContractName
                               , Movement.JuridicalId
                               , Movement.JuridicalName
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

       , tmpMovementPromo AS (SELECT tmpPromo.MovementId
                                   , tmpPromo.OperDate
                                   , tmpPromo.InvNumber
                                   , tmpPromo.StatusId
                                   , tmpPromo.StatusCode
                                   , MovementDate_StartSale.ValueData       AS StartSale
                                   , MovementDate_EndSale.ValueData         AS EndSale            --Дата окончания возвратов по акционной цене
                                   , MovementDate_StartPromo.ValueData      AS StartPromo         --Дата начала акции
                                   , MovementDate_EndPromo.ValueData        AS EndPromo           --Дата окончания акции
                                   , MovementDate_Month.ValueData           AS MonthPromo         -- месяц акции
                                   --, MovementDate_OperDateStart.ValueData   AS OperDateStart      --Дата начала расч. продаж до акции
                                   --, MovementDate_OperDateEnd.ValueData     AS OperDateEnd        --Дата окончания расч. продаж до акции
                                   , Object_PromoKind.ValueData             AS PromoKindName      --Вид акции
                                   , Object_Unit.ValueData                  AS UnitName           --Подразделение
                              FROM tmpPromo
                                   LEFT JOIN tmpMovementDate AS MovementDate_StartSale
                                                             ON MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                                            AND MovementDate_StartSale.MovementId = tmpPromo.MovementId
                                   LEFT JOIN tmpMovementDate AS MovementDate_EndSale
                                                            ON MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                                            AND MovementDate_EndSale.MovementId = tmpPromo.MovementId
                                   LEFT JOIN tmpMovementDate AS MovementDate_StartPromo
                                                            ON MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                            AND MovementDate_StartPromo.MovementId = tmpPromo.MovementId
                                   LEFT JOIN tmpMovementDate AS MovementDate_EndPromo
                                                            ON MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                            AND MovementDate_EndPromo.MovementId = tmpPromo.MovementId
                                   LEFT JOIN tmpMovementDate AS MovementDate_Month
                                                            ON MovementDate_Month.DescId = zc_MovementDate_Month()
                                                            AND MovementDate_Month.MovementId = tmpPromo.MovementId

                                   LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = tmpPromo.MovementId
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                                   LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PromoKind
                                                                   ON MovementLinkObject_PromoKind.MovementId = tmpPromo.MovementId
                                                                  AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
                                   LEFT JOIN Object AS Object_PromoKind ON Object_PromoKind.Id = MovementLinkObject_PromoKind.ObjectId
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
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementList.Id FROM tmpMovementList)
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE                   
                      )

       , tmpMLM AS (SELECT tmp.MovementId_PromoInvoice, tmp.ContractId
                         , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma_Before
                         , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.BankSumma ELSE 0 END) AS BankSumma
                         , SUM (CASE WHEN tmp.MLM_OperDate < inStartDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma_Before
                         , SUM (CASE WHEN tmp.MLM_OperDate BETWEEN inStartDate AND inEndDate THEN tmp.ServiceSumma ELSE 0 END) AS ServiceSumma
                    FROM (SELECT tmpPromoInvoice.MovementId AS MovementId_PromoInvoice
                               , Movement.OperDate AS MLM_OperDate
                               , MILinkObject_Contract.ObjectId AS ContractId
                               , CASE WHEN Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()) THEN -1 * MovementItem.Amount ELSE 0 END AS BankSumma
                               , CASE WHEN Movement.DescId = zc_Movement_Service() THEN -1 * MovementItem.Amount ELSE 0 END AS ServiceSumma
                           FROM tmpPromoInvoice
                                INNER JOIN tmpMLM_PromoInvoice AS MLM_PromoInvoice
                                                               ON MLM_PromoInvoice.MovementChildId = tmpPromoInvoice.MovementId
                                                              AND MLM_PromoInvoice.DescId = zc_MovementLinkMovement_Invoice()
                                INNER JOIN tmpMovementList AS Movement 
                                                           ON Movement.Id = MLM_PromoInvoice.MovementId

                                INNER JOIN tmpMIList AS MovementItem
                                                     ON MovementItem.MovementId = Movement.Id

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                          ) AS tmp
                     GROUP BY tmp.MovementId_PromoInvoice, tmp.ContractId
                    )

       -- zc_Movement_ProfitLossService 
       , tmpProfitLossService AS (SELECT MILinkObject_Contract.ObjectId AS ContractId
                                       , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                                  FROM Movement
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                       INNER JOIN (SELECT DISTINCT tmpPromoInvoice.ContractId FROM tmpPromoInvoice) AS tmpContract
                                                                                                                    ON tmpContract.ContractId = MILinkObject_Contract.ObjectId

                                  WHERE Movement.DescId = zc_Movement_ProfitLossService()
                                    AND Movement.OperDate BETWEEN inStartDate2 AND inEndDate2
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  GROUP BY MILinkObject_Contract.ObjectId
                                  )
       -- все zc_Movement_PromoInvoice (кроме текущего) к этому договору  -- что значит кроме текущего
       , tmpPromoInvoice_period AS (SELECT Movement.ContractId
                                         , SUM(COALESCE(Movement.TotalSumm,0)) AS Amount
                                    FROM Movement_PromoInvoice_View AS Movement
                                    WHERE Movement.OperDate BETWEEN inStartDate2 AND inEndDate2
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                    GROUP BY Movement.ContractId
                                    ) 



  SELECT *
  FROM
      (SELECT tmpPromoInvoice.MovementId
            , tmpPromoInvoice.StatusCode
            , tmpPromoInvoice.InvNumber
            , tmpPromoInvoice.InvNumberPartner
            , ('№ ' || tmpPromoInvoice.InvNumber || ' от ' || tmpPromoInvoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Full
            , tmpPromoInvoice.OperDate
            , tmpPromoInvoice.PaidKindName
            , tmpPromoInvoice.BonusKindId
            , tmpPromoInvoice.BonusKindName
            , tmpPromoInvoice.ContractId
            , tmpPromoInvoice.ContractCode
            , tmpPromoInvoice.ContractName
            , tmpPromoInvoice.JuridicalId
            , tmpPromoInvoice.JuridicalName
            , tmpPromoInvoice.Comment
     
            , tmpPromoInvoice.TotalSumm           :: TFloat AS TotalSumm

            , tmpMLM.ServiceSumma              :: TFloat AS ServiceSumma
            , (tmpPromoInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0)) :: TFloat AS RemStart                 --ост.нач.счет
            , tmpMLM.BankSumma                 :: TFloat AS BankSumma
            , (tmpPromoInvoice.TotalSumm - COALESCE (tmpMLM.BankSumma_Before, 0) - COALESCE (tmpMLM.BankSumma, 0))   ::TFloat  AS RemEnd
            
            , COALESCE (tmpProfitLossService.Amount,0)   :: TFloat AS Amount_ProfitLossService
            , COALESCE (tmpPromoInvoice_period.Amount,0) :: TFloat AS Amount_PromoInvoice
            , (COALESCE (tmpPromoInvoice_period.Amount,0) - COALESCE (tmpProfitLossService.Amount,0)) :: TFloat AS Amount_diff

            , tmpMovementPromo.MovementId AS MovementId_promo
            , tmpMovementPromo.OperDate   AS OperDate_promo
            , tmpMovementPromo.InvNumber :: TVarChar AS InvNumber_promo
            , tmpMovementPromo.StatusCode AS StatusCode_promo
            , tmpMovementPromo.StartSale  AS StartSale_promo
            , tmpMovementPromo.EndSale    AS EndSale_promo 
            , tmpMovementPromo.StartPromo AS StartPromo_promo
            , tmpMovementPromo.EndPromo   AS EndPromo_promo
            , tmpMovementPromo.MonthPromo AS MonthPromo_promo
            , tmpMovementPromo.PromoKindName
            , tmpMovementPromo.UnitName
    
       FROM tmpPromoInvoice
            LEFT JOIN tmpMLM ON tmpMLM.MovementId_PromoInvoice = tmpPromoInvoice.MovementId
            LEFT JOIN tmpMovementPromo ON tmpMovementPromo.MovementId = tmpPromoInvoice.ParentId
            LEFT JOIN tmpProfitLossService ON tmpProfitLossService.ContractId = tmpPromoInvoice.ContractId
            LEFT JOIN tmpPromoInvoice_period ON tmpPromoInvoice_period.ContractId = tmpPromoInvoice.ContractId

      ) AS tmpResult
      ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.09.21         *
*/

-- тест
-- select * from gpReport_PromoInvoice(inStartDate := ('29.06.2021')::TDateTime , inEndDate := ('03.07.2022')::TDateTime , inStartDate2 := ('29.06.2016')::TDateTime , inEndDate2 := ('03.07.2016')::TDateTime , inPaidKindId := 0::Integer ,  inSession := '5'::TVarChar);