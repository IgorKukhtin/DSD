-- FunctiON: Report_CheckTaxCorrective_NPP ()

DROP FUNCTION IF EXISTS Report_CheckTaxCorrective_NPP (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckTaxCorrective_NPP (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckTaxCorrective_NPP (Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckTaxCorrective_NPP (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTaxCorrective_NPP (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inMovementId          Integer   , -- № налоговой
    IN inGoodsId             Integer   , -- товар
    IN inIsShowAll           Boolean   , -- показать по умолч только  ошибки - №п/п или кол-во
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ItemName             TVarChar
             , TaxKindName          TVarChar
             , BranchName           TVarChar
             , InvNumber            Integer
             , InvNumberPartner     Integer
             , InvNumberPartner_Tax Integer
             
             , OperDate TDateTime
             , OperDate_Tax TDateTime
             , JuridicalName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , LineNum         Integer
             , LineNumTax      Integer
             , LineNumTaxCorr_calc Integer
             , LineNum_calc    Integer
             , Amount          TFloat
             , Price           TFloat
             , CountForPrice   TFloat
             , AmountSumm      TFloat
             , AmountSumm_original  TFloat
             , SummTaxDiff_calc     TFloat
             , AmountTax_calc  TFloat
             , PriceTax_calc   TFloat
             , AmountTax       TFloat
             , isAmountTax     Boolean
             , isLineNum       Boolean
             , isRegistered     Boolean
             , isElectron       Boolean
             , DateRegistered   TDateTime
              )  
AS
$BODY$

   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    IF COALESCE (inMovementId) <> 0 THEN
       inIsShowAll = inIsShowAll;
    ELSE
       inIsShowAll := FALSE;
    END IF;
    --
    RETURN QUERY

      WITH
      _tmpMovementTax AS (-- Если передан inMovementId <> 0 строим отчет по 1 документу
                          SELECT inMovementId AS MovementId --inMovementId
                          WHERE COALESCE (inMovementId) <> 0
                       UNION 
                         -- Если inMovementId = 0 строим отчет за период: За период выбираются Корректировки , а к ним уже выбираются налоговые
                         SELECT MovementLinkMovement_Child.MovementChildId AS MovementId
                         FROM MovementLinkMovement AS MovementLinkMovement_Child
                         WHERE MovementLinkMovement_Child.MovementId IN (SELECT DISTINCT Movement.Id AS MovementId_Corr
                                                                         FROM Movement
                                                                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                                           AND Movement.DescId = zc_Movement_TaxCorrective()
                                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                        )
                           AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                           AND COALESCE (inMovementId) = 0
                         )

      -- № п/п строк Налоговых
    , tmpMITax AS (SELECT tmp.MovementId, tmp.Kind, tmp.GoodsId, tmp.GoodsKindId, tmp.Price, tmp.LineNum
                   FROM _tmpMovementTax
                        LEFT JOIN lpSelect_TaxFromTaxCorrective (inMovementId := _tmpMovementTax.MovementId) AS tmp ON tmp.MovementId = _tmpMovementTax.MovementId
                  )
     -- сначала выбираем все товары из Налоговых и корректировок, чтоб сделать Расчетный № п/п
     
    , tmpMI_Tax_All AS (SELECT Movement.OperDate                      AS OperDate
                             , MovementItem.MovementId                AS MovementId
                             , MovementItem.Id                        AS MovementItemId
                             , MovementLinkObject_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                             , MovementItem.ObjectId                  AS GoodsId
                             , MovementItem.Amount                    AS Amount
                             , CASE WHEN MovementString_InvNumberRegistered.ValueData <> '' THEN TRUE ELSE FALSE END  :: Boolean AS isRegistered
                             , CASE WHEN MovementString_InvNumberRegistered.ValueData <> '' THEN MovementDate_DateRegistered.ValueData ELSE NULL END :: TDateTime AS DateRegistered
                        FROM _tmpMovementTax
                              LEFT JOIN Movement ON Movement.Id = _tmpMovementTax.MovementId
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                           ON MovementLinkObject_DocumentTaxKind.MovementId = _tmpMovementTax.MovementId
                                                          AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                              LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                                       ON MovementString_InvNumberRegistered.MovementId = _tmpMovementTax.MovementId
                                                      AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
                              LEFT JOIN MovementDate AS MovementDate_DateRegistered 
                                                     ON MovementDate_DateRegistered.MovementId = _tmpMovementTax.MovementId
                                                    AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
                              LEFT JOIN MovementItem ON MovementItem.MovementId = _tmpMovementTax.MovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                       )
    -- для оптимизации выбираем свойства строк отдельными запросами
    , tmpMF AS (SELECT MovementItemFloat.*
                FROM MovementItemFloat
                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Tax_All.MovementItemId FROM tmpMI_Tax_All)
                  AND MovementItemFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_CountForPrice(), zc_MIFloat_NPP())
               )
    , tmpMILO_GoodsKind_tax AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject 
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Tax_All.MovementItemId FROM tmpMI_Tax_All)
                                  AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )
    --Данные потоварно из Налоговых
    , tmpMI_Tax AS (SELECT MovementItem.OperDate                  AS OperDate
                         , MovementItem.MovementId                AS MovementId
                         , MovementItem.MovementItemId            AS MovementItemId
                         , MovementItem.DocumentTaxKindId         AS DocumentTaxKindId
                         , MovementItem.isRegistered
                         , MovementItem.DateRegistered
                         , MIFloat_NPP.ValueData       :: Integer AS LineNum
                         , MovementItem.GoodsId                   AS GoodsId
                         , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId
                         , MovementItem.Amount                    AS Amount
                         , MIFloat_Price.ValueData                AS Price
                         , MIFloat_CountForPrice.ValueData        AS CountForPrice

                         , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                         THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                         ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                 END AS TFloat)                   AS AmountSumm
                       
                     FROM tmpMI_Tax_All AS MovementItem
                          LEFT JOIN tmpMF AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.MovementItemId
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN tmpMF AS MIFloat_CountForPrice
                                          ON MIFloat_CountForPrice.MovementItemId = MovementItem.MovementItemId
                                         AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          LEFT JOIN tmpMF AS MIFloat_NPP
                                          ON MIFloat_NPP.MovementItemId = MovementItem.MovementItemId
                                         AND MIFloat_NPP.DescId = zc_MIFloat_NPP()           
              
                          LEFT JOIN tmpMILO_GoodsKind_tax AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                    )
    -- Данных корректировок 
    , tmpMI_Corr AS (SELECT tmpMovement.OperDate
                          , tmpMovement.MovementId
                          , tmpMovement.MovementId_Tax
                          , MovementLinkObject_DocumentTaxKind.ObjectId                    AS DocumentTaxKindId
                          , MovementItem.Id                                                AS MovementItemId
                          , MovementItem.ObjectId                                          AS GoodsId
                          , MovementItem.Amount                                            AS Amount
                          , COALESCE (MovementBoolean_NPP_calc.ValueData, FALSE) ::Boolean AS isNPP_calc

                          , CASE WHEN MovementString_InvNumberRegistered.ValueData <> '' THEN TRUE ELSE FALSE END  :: Boolean AS isRegistered
                          , CASE WHEN MovementString_InvNumberRegistered.ValueData <> '' THEN MovementDate_DateRegistered.ValueData ELSE NULL END :: TDateTime AS DateRegistered
                       FROM (-- для Налоговых получаем все их корректировки
                             SELECT MLM_DocumentChild.MovementId                    --корр.
                                  , MLM_DocumentChild.MovementChildId  AS MovementId_Tax
                                  , Movement.OperDate
                             FROM MovementLinkMovement AS MLM_DocumentChild
                                  INNER JOIN Movement ON Movement.Id = MLM_DocumentChild.MovementId
                                                     AND Movement.DescId = zc_Movement_TaxCorrective()
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                             WHERE MLM_DocumentChild.MovementChildId IN (SELECT DISTINCT _tmpMovementTax.MovementId FROM _tmpMovementTax) --inMovementId -- НН
                               AND MLM_DocumentChild.DescId = zc_MovementLinkMovement_Child()
                            ) AS tmpMovement
                          LEFT JOIN MovementBoolean AS MovementBoolean_NPP_calc
                                                    ON MovementBoolean_NPP_calc.MovementId = tmpMovement.MovementId
                                                   AND MovementBoolean_NPP_calc.DescId = zc_MovementBoolean_NPP_calc()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                       ON MovementLinkObject_DocumentTaxKind.MovementId = tmpMovement.MovementId
                                                      AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                          LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                                   ON MovementString_InvNumberRegistered.MovementId = tmpMovement.MovementId
                                                  AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
                          LEFT JOIN MovementDate AS MovementDate_DateRegistered 
                                                 ON MovementDate_DateRegistered.MovementId = tmpMovement.MovementId
                                                AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
                          
                          LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    )
    -- свойства строк корректировок
    , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                               FROM MovementItemFloat
                               WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Corr.MovementItemId FROM tmpMI_Corr)
                               )
    , tmpMovementItemBoolean AS (SELECT MovementItemBoolean.*
                                 FROM MovementItemBoolean
                                 WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_Corr.MovementItemId FROM tmpMI_Corr)
                                   AND MovementItemBoolean.DescId = zc_MIBoolean_isAuto()
                                 )
    , tmpMI_LO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject 
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Corr.MovementItemId FROM tmpMI_Corr)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )
                             
    --Данные потоварно из корректировок
    , tmpMI_TaxCorrective AS (SELECT tmpMovement.OperDate
                                   , tmpMovement.MovementId
                                   , tmpMovement.MovementId_Tax
                                   , tmpMovement.MovementItemId
                                   , tmpMovement.DocumentTaxKindId
                                   , tmpMovement.isRegistered
                                   , tmpMovement.DateRegistered
                                   , tmpMovement.isNPP_calc
                                   , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTaxOld
                                   , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTax
                        
                                   , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)    :: Integer AS LineNumTaxCorr_calc
                                   , COALESCE (MIFloat_NPP_calc.ValueData, 0)       :: Integer AS LineNumTaxCorr
                                   , COALESCE (MIFloat_AmountTax_calc.ValueData, 0) :: TFloat  AS AmountTax_calc
                        
                                   , tmpMovement.GoodsId                    AS GoodsId
                                   , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId
                                   , tmpMovement.Amount                     AS Amount
                                   , MIFloat_Price.ValueData                AS Price

                                     -- "заменяем" цену если Корр. цены 
                                   , CASE WHEN MIFloat_PriceTax_calc.ValueData <> 0
                                           AND tmpMovement.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                )
                                               THEN MIFloat_PriceTax_calc.ValueData
                                          ELSE MIFloat_Price.ValueData
                                     END AS Price_Original

                                   , MIFloat_CountForPrice.ValueData        AS CountForPrice
                                   , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                   THEN CAST ( (COALESCE (tmpMovement.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                                   ELSE CAST ( (COALESCE (tmpMovement.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                           END AS TFloat)                   AS AmountSumm
                                   , COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) :: TFloat AS SummTaxDiff_calc
                                   , COALESCE (MIFloat_PriceTax_calc.ValueData, 0)    :: TFloat AS PriceTax_calc
                                             
                              FROM tmpMI_Corr AS tmpMovement 
                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                                                  ON MIFloat_Price.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_CountForPrice
                                                                  ON MIFloat_CountForPrice.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       
                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_NPP
                                                                  ON MIFloat_NPP.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
                                   LEFT JOIN tmpMovementItemBoolean AS MIBoolean_isAuto
                                                                    ON MIBoolean_isAuto.MovementItemId = tmpMovement.MovementItemId
                                                                   AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_NPPTax_calc
                                                                  ON MIFloat_NPPTax_calc.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_NPPTax_calc.DescId = zc_MIFloat_NPPTax_calc()
                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_NPP_calc
                                                                  ON MIFloat_NPP_calc.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_NPP_calc.DescId = zc_MIFloat_NPP_calc()
                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountTax_calc
                                                                  ON MIFloat_AmountTax_calc.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_AmountTax_calc.DescId = zc_MIFloat_AmountTax_calc()
                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_SummTaxDiff_calc
                                                                  ON MIFloat_SummTaxDiff_calc.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_SummTaxDiff_calc.DescId = zc_MIFloat_SummTaxDiff_calc()
                                   LEFT JOIN tmpMovementItemFloat AS MIFloat_PriceTax_calc
                                                                  ON MIFloat_PriceTax_calc.MovementItemId = tmpMovement.MovementItemId
                                                                 AND MIFloat_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                                       
                                   LEFT JOIN tmpMI_LO_GoodsKind AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = tmpMovement.MovementItemId

                                   LEFT JOIN tmpMITax AS tmpMITax1 ON tmpMITax1.Kind        = 1
                                                                  AND tmpMITax1.GoodsId     = tmpMovement.GoodsId
                                                                  AND tmpMITax1.GoodsKindId = MILinkObject_GoodsKind.ObjectId --Object_GoodsKind.Id
                                                                  AND tmpMITax1.Price       = MIFloat_Price.ValueData
                                                                  AND tmpMITax1.MovementId  = tmpMovement.MovementId_Tax
                                   LEFT JOIN tmpMITax AS tmpMITax2 ON tmpMITax2.Kind        = 2
                                                                  AND tmpMITax2.GoodsId     = tmpMovement.GoodsId
                                                                  AND tmpMITax2.Price       = MIFloat_Price.ValueData
                                                                  AND tmpMITax1.GoodsId     IS NULL
                                                                  AND tmpMITax2.MovementId  = tmpMovement.MovementId_Tax
                              )

    -- данные НН и корректировок                           
    , tmpData_All AS (SELECT tmp.OperDate
                           , tmp.MovementId
                           , zc_Movement_Tax() AS MovementDescId
                           , tmp.MovementId AS MovementId_Tax
                           , tmp.DocumentTaxKindId
                           , tmp.isRegistered
                           , tmp.DateRegistered
                           , tmp.MovementItemId
                           , tmp.LineNum
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           , tmp.Amount
                           , tmp.Price
                           , tmp.Price AS Price_Original
                           , tmp.CountForPrice
                           , tmp.AmountSumm
                           , tmp.AmountSumm AS AmountSumm_original
                           , 0   :: TFloat  AS SummTaxDiff_calc
                           , tmp.LineNum    AS LineNumTaxCorr_calc
                           , tmp.LineNum    AS LineNumTax
                           , 0   :: TFloat  AS AmountTax_calc
                           , 0   :: TFloat  AS PriceTax_calc
                           , TRUE           AS isNPP_calc
                      FROM tmpMI_Tax AS tmp
                     UNION ALL
                      SELECT tmp.OperDate
                           , tmp.MovementId
                           , zc_Movement_TaxCorrective() AS MovementDescId
                           , tmp.MovementId_Tax
                           , tmp.DocumentTaxKindId
                           , tmp.isRegistered
                           , tmp.DateRegistered
                           , tmp.MovementItemId
                           , tmp.LineNumTaxCorr AS LineNum
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           , (-1) * tmp.Amount
                           , tmp.Price
                           , tmp.Price_Original
                           , tmp.CountForPrice
                           , (-1) * (tmp.AmountSumm + tmp.SummTaxDiff_calc) AS AmountSumm
                           , (-1) * tmp.AmountSumm AS AmountSumm_original
                           , (-1) * tmp.SummTaxDiff_calc
                           , tmp.LineNumTaxCorr_calc
                           , tmp.LineNumTax
                           , tmp.AmountTax_calc
                           , tmp.PriceTax_calc
                           , tmp.isNPP_calc
                      FROM tmpMI_TaxCorrective AS tmp
                     )
    -- нумеруем группировки По налоговым потоварно с учетом и без GoodsKindId для просчета в дальнейшем AmountTax_calc
    , tmpDataAll_ord AS (SELECT tmp.MovementDescId
                              , tmp.OperDate
                              , tmp.MovementId
                              , tmp.MovementId_Tax
                              , tmp.DocumentTaxKindId
                              , tmp.isRegistered
                              , tmp.DateRegistered
                              , tmp.MovementItemId
                              , tmp.isNPP_calc
                              , tmp.LineNum
                              , tmp.GoodsId
                              , tmp.GoodsKindId
                              , tmp.Amount
                              , tmp.Price
                              , tmp.Price_Original
                              , tmp.CountForPrice
                              , tmp.AmountSumm
                              , tmp.AmountSumm_original
                              , tmp.SummTaxDiff_calc
                              , tmp.LineNumTaxCorr_calc
                              , tmp.LineNumTax
                              , tmp.AmountTax_calc
                              , tmp.PriceTax_calc
                                -- с GoodsKindId
                              , ROW_NUMBER() OVER (PARTITION BY tmp.MovementId_Tax, tmp.GoodsId, tmp.GoodsKindId, tmp.Price_Original
                                                   ORDER BY tmp.MovementId_Tax
                                                          , CASE WHEN tmp.MovementDescId = zc_Movement_Tax() THEN 1 ELSE 2 END
                                                         -- , CASE WHEN tmp.isRegistered = TRUE THEN tmp.DateRegistered ELSE tmp.OperDate END
                                                          , tmp.LineNum
                                                          , tmp.OperDate
                                                          , tmp.MovementId
                                                          , tmp.LineNumTaxCorr_calc
                                                  )  :: Integer AS Ord_calc
                                -- без GoodsKindId
                              , ROW_NUMBER() OVER (PARTITION BY tmp.MovementId_Tax, tmp.GoodsId, tmp.Price_Original
                                                   ORDER BY tmp.MovementId_Tax
                                                          , CASE WHEN tmp.MovementDescId = zc_Movement_Tax() THEN 1 ELSE 2 END
                                                          --, CASE WHEN tmp.isRegistered = TRUE THEN tmp.DateRegistered ELSE tmp.OperDate  END
                                                          , tmp.LineNum
                                                          , tmp.OperDate
                                                          , tmp.MovementId
                                                          , tmp.LineNumTaxCorr_calc
                                                  )  :: Integer AS Ord_calc_next
                         FROM tmpData_All AS tmp
                        )

    -- получаем расчетное значение AmountTax_calc
    , tmpData_Summ AS (SELECT tmp1.MovementDescId
                            , tmp1.OperDate
                            , tmp1.MovementId
                            , tmp1.MovementId_Tax
                            , tmp1.DocumentTaxKindId
                            , tmp1.isRegistered
                            , tmp1.DateRegistered
                            , tmp1.MovementItemId
                            , tmp1.isNPP_calc
                            , tmp1.LineNum
                            , tmp1.GoodsId
                            , tmp1.GoodsKindId
                            , tmp1.Amount
                            , tmp1.Price
                            , tmp1.Price_Original
                            , tmp1.CountForPrice
                            , tmp1.AmountSumm
                            , tmp1.AmountSumm_original
                            , tmp1.SummTaxDiff_calc
                            , tmp1.LineNumTaxCorr_calc
                            , tmp1.LineNumTax
                            , tmp1.AmountTax_calc
                            , tmp1.PriceTax_calc
                            , SUM (COALESCE (tmp2.Amount, tmpMI_Tax1.Amount, tmpMI_Tax2.Amount, 0)) AS AmountTax
                       FROM tmpDataAll_ord AS tmp1
                           LEFT JOIN tmpDataAll_ord AS tmp2
                                                    ON tmp2.MovementId_Tax = tmp1.MovementId_Tax
                                                   AND tmp2.GoodsId        = tmp1.GoodsId
                                                   AND (tmp2.GoodsKindId   = tmp1.GoodsKindId OR COALESCE (tmp1.GoodsKindId,0) = 0)
                                                   AND tmp2.Price = tmp1.Price_Original
                                                   AND tmp2.Ord_calc       < tmp1.Ord_calc
                                                   -- если НЕ Корр. цены 
                                                   AND tmp1.DocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                    , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                     )
                           -- поиск в Налоговой - Только для Корр. цены
                           LEFT JOIN tmpMI_Tax AS tmpMI_Tax1 ON tmpMI_Tax1.MovementId     = tmp1.MovementId_Tax
                                                            AND tmpMI_Tax1.GoodsId        = tmp1.GoodsId
                                                            AND tmpMI_Tax1.GoodsKindId    = tmp1.GoodsKindId
                                                            AND tmpMI_Tax1.Price          = tmp1.Price_Original
                                                            AND tmp1.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                         , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                          )

                           -- поиск в Налоговой БЕЗ GoodsKindId - Только для Корр. цены
                           LEFT JOIN tmpMI_Tax AS tmpMI_Tax2 ON tmpMI_Tax2.MovementId     = tmp1.MovementId_Tax
                                                            AND tmpMI_Tax2.GoodsId        = tmp1.GoodsId
                                                            AND tmpMI_Tax2.Price          = tmp1.Price_Original
                                                            AND tmp1.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                         , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                          )
                                                            -- и если НЕ нашли
                                                            AND tmpMI_Tax1.GoodsId        IS NULL
                       GROUP BY tmp1.MovementDescId
                              , tmp1.OperDate
                              , tmp1.MovementId
                              , tmp1.MovementId_Tax
                              , tmp1.DocumentTaxKindId
                              , tmp1.isRegistered
                              , tmp1.DateRegistered
                              , tmp1.MovementItemId
                              , tmp1.LineNum
                              , tmp1.GoodsId
                              , tmp1.GoodsKindId
                              , tmp1.Amount
                              , tmp1.Price
                              , tmp1.Price_Original
                              , tmp1.CountForPrice
                              , tmp1.AmountSumm
                              , tmp1.AmountSumm_original
                              , tmp1.SummTaxDiff_calc
                              , tmp1.LineNumTaxCorr_calc
                              , tmp1.LineNumTax
                              , tmp1.AmountTax_calc
                              , tmp1.PriceTax_calc
                              , tmp1.isNPP_calc
                      )

    -- получаем расчетное значение № п/п
    -- сортируем сначала налоговые потом корректировки,  дата регистрации (если нет рег. тогда дата документа), № пп НН / корр, и.т.д.
    , tmpData_Ord AS (SELECT tmp.MovementId
                           , tmp.MovementId_Tax
                           , tmp.DocumentTaxKindId
                           , tmp.isRegistered
                           , tmp.DateRegistered
                           , tmp.MovementItemId
                           , tmp.isNPP_calc
                           , tmp.LineNum
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           , tmp.Amount
                           , tmp.Price
                           , tmp.CountForPrice
                           , tmp.AmountSumm
                           , tmp.AmountSumm_original
                           , tmp.SummTaxDiff_calc
                           , tmp.LineNumTaxCorr_calc
                           , tmp.LineNumTax
                           , tmp.AmountTax_calc
                           , tmp.PriceTax_calc
                           , tmp.AmountTax
                           , ROW_NUMBER() OVER (PARTITION BY tmp.MovementId_Tax
                                                   ORDER BY CASE WHEN tmp.MovementDescId = zc_Movement_Tax() THEN 1 ELSE 2 END
                                                         -- , CASE WHEN tmp.isRegistered = TRUE THEN tmp.DateRegistered ELSE tmp.OperDate END
                                                          , tmp.LineNum
                                                          , tmp.OperDate
                                                          , tmp.MovementId
                                                          , tmp.LineNumTaxCorr_calc 
                                                 ) :: Integer AS LineNum_calc
                     FROM tmpData_Summ AS tmp
                     WHERE tmp.isNPP_calc = TRUE
                       AND ((COALESCE (tmp.AmountTax, 0) + COALESCE (tmp.Amount, 0)) > 0
                         OR tmp.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                    , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                     )
                           )
                    )
    -- к основной таб. данных привязываем расченый №пп, и проверяем на ошибки (отклонения)
    , tmpData AS (SELECT tmp.MovementId
                       , tmp.MovementId_Tax
                       , tmp.DocumentTaxKindId
                       , tmp.isRegistered
                       , tmp.DateRegistered
                       , tmp.MovementItemId
                       , tmp.isNPP_calc
                       , tmp.LineNum
                       , tmp.GoodsId
                       , tmp.GoodsKindId
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , tmp.AmountSumm_original
                       , tmp.SummTaxDiff_calc
                       , tmp.LineNumTaxCorr_calc
                       , tmp.LineNumTax
                       , tmp.AmountTax_calc
                       , tmp.PriceTax_calc
                       , tmp.AmountTax
                       , tmpData_Ord.LineNum_calc
                       , CASE WHEN tmp.isNPP_calc = TRUE AND COALESCE (tmp.AmountTax_calc, 0) <> COALESCE (tmp.AmountTax, 0) THEN TRUE ELSE FALSE END     AS isAmountTax
                       , CASE WHEN tmp.isNPP_calc = TRUE AND COALESCE (tmp.LineNum, 0) <> COALESCE (tmpData_Ord.LineNum_calc, 0) THEN TRUE ELSE FALSE END AS isLineNum
                 FROM tmpData_Summ AS tmp
                      LEFT JOIN tmpData_Ord ON tmpData_Ord.MovementItemId = tmp.MovementItemId
                                           AND tmpData_Ord.MovementId_Tax = tmp.MovementId_Tax
                                           AND tmpData_Ord.MovementId     = tmp.MovementId
                 )
                 
    -- запросы свойств документов
    , tmpMLO AS (SELECT MovementLinkObject.*
                 FROM MovementLinkObject
                 WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                   AND MovementLinkObject.DescId IN (zc_MovementLinkObject_To()
                                                   , zc_MovementLinkObject_From()
                                                   , zc_MovementLinkObject_Branch())
                 )
      
    , tmpMS_InvNumberPartner AS (SELECT MovementString.*
                                 FROM MovementString
                                 WHERE MovementString.MovementId IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                                   AND MovementString.DescId = zc_MovementString_InvNumberPartner()
                                 )
    , tmpMovement_All AS (SELECT Movement.*
                               , MovementDesc.ItemName
                          FROM Movement
                               LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                          WHERE Movement.Id IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                          )

    , tmpMovementBoolean AS (SELECT MovementBoolean.*
                             FROM MovementBoolean
                             WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                               AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
                            )

    --- результат
    SELECT Movement.ItemName                             AS ItemName
         , Object_TaxKind.ValueData         		 AS TaxKindName
         , Object_Branch.ValueData                       AS BranchName
         , Movement.InvNumber                            :: Integer AS InvNumber
         , MovementString_InvNumberPartner.ValueData     :: Integer AS InvNumberPartner
         , MovementString_InvNumberPartner_Tax.ValueData :: Integer AS InvNumberPartner_Tax
         , Movement.OperDate                             AS OperDate
         , Movement_Tax.OperDate                         AS OperDate_Tax
         , Object_To.ValueData         AS JuridicalName
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , tmpData.LineNum             :: Integer                                         -- № п/п в Корректировке - сквозная нумерация
         , tmpData.LineNumTax          :: Integer                                         -- № п/п Налоговой
         , COALESCE (tmpData.LineNumTaxCorr_calc, 0) :: Integer AS LineNumTaxCorr_calc    -- № п/п который корректируется
         , COALESCE (tmpData.LineNum_calc, 0)        :: Integer AS LineNum_calc           -- № п/п в Корректировке расчет - сквозная нумерация
         , tmpData.Amount         :: TFloat
         , tmpData.Price          :: TFloat
         , tmpData.CountForPrice  :: TFloat
         , tmpData.AmountSumm     :: TFloat
         , tmpData.AmountSumm_original  :: TFloat
         , tmpData.SummTaxDiff_calc     :: TFloat
         , tmpData.AmountTax_calc :: TFloat
         , tmpData.PriceTax_calc  :: TFloat
         , CASE WHEN tmpData.isNPP_calc = FALSE THEN 0 ELSE tmpData.AmountTax END :: TFloat  AS AmountTax
         , tmpData.isAmountTax
         , tmpData.isLineNum

         , tmpData.isRegistered
         , COALESCE (MovementBoolean_Electron.ValueData, FALSE)    :: Boolean AS isElectron
         , tmpData.DateRegistered
    FROM tmpData
         LEFT JOIN tmpMovement_All AS Movement ON Movement.Id = tmpData.MovementId
         LEFT JOIN tmpMovement_All AS Movement_Tax ON Movement_Tax.Id = tmpData.MovementId_Tax
          
         LEFT JOIN tmpMLO AS MovementLinkObject_To
                          ON MovementLinkObject_To.MovementId = Movement.Id
                         AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_Tax() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
         LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

         LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = tmpData.DocumentTaxKindId

         LEFT JOIN tmpMLO AS MovementLinkObject_Branch
                          ON MovementLinkObject_Branch.MovementId = Movement.Id
                         AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MovementLinkObject_Branch.ObjectId

         LEFT JOIN tmpMS_InvNumberPartner AS MovementString_InvNumberPartner
                                          ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                         AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

         LEFT JOIN tmpMS_InvNumberPartner AS MovementString_InvNumberPartner_Tax
                                          ON MovementString_InvNumberPartner_Tax.MovementId = tmpData.MovementId_Tax
                                         AND MovementString_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

         LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpData.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

         LEFT JOIN tmpMovementBoolean AS MovementBoolean_Electron 
                                      ON MovementBoolean_Electron.MovementId = tmpData.MovementId
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

    WHERE (tmpData.GoodsId = inGoodsId OR inGoodsId = 0)
      AND ((inIsShowAll = FALSE AND (tmpData.isAmountTax = TRUE OR tmpData.isLineNum = TRUE))
         OR inIsShowAll = TRUE)
    ORDER BY 1 DESC, tmpData.LineNum
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.18         *
 04.04.18         *
 02.04.18         *
 30.03.18         *
*/

-- тест
-- SELECT * FROM gpReport_CheckTaxCorrective_NPP (inStartDate :='01.04.2018' ::TDateTime, inEndDate:='03.04.2018' ::TDateTime, inMovementId:=0, inGoodsId:= 0, inIsShowAll := false, inSession:= zfCalc_UserAdmin());
