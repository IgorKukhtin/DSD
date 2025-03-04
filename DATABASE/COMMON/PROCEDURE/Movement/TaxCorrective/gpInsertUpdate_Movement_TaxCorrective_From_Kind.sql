-- Function: gpInsertUpdate_Movement_TaxCorrective_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (
    IN inMovementId             Integer  , -- ключ Документа
    IN inDocumentTaxKindId      Integer  , -- Тип формирования налогового документа
    IN inDocumentTaxKindId_inf  Integer  , -- Тип формирования налогового документа в журнале
    IN inStartDateTax           TDateTime, --
    IN inIsTaxLink              Boolean  , -- Признак привязки к налоговым
   OUT outDocumentTaxKindId     Integer  , --
   OUT outDocumentTaxKindName   TVarChar , --
   OUT outMovementId_Corrective Integer  , --
   OUT outMessageText           Text     ,

    IN inSession                TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId           Integer;

   DECLARE vbStatusId  Integer;
   DECLARE vbInvNumber TVarChar;

   DECLARE vbMovementId_Tax   Integer;
   DECLARE vbAmount_Tax       TFloat;

   DECLARE vbStartDate        TDateTime;
   DECLARE vbEndDate          TDateTime;

   DECLARE vbMovementDescId   Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;
   DECLARE vbBranchId         Integer;
   DECLARE vbDiscountPercent     TFloat;
   DECLARE vbExtraChargesPercent TFloat;

   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyValue TFloat;
   DECLARE vbParValue TFloat;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbOperPrice   TFloat;

   DECLARE curMI_ReturnIn refcursor;
   DECLARE curMI_Tax refcursor;

   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- это значит пользователь установил в журнале "другой" тип формирования
     IF inDocumentTaxKindId_inf <> 0 THEN inDocumentTaxKindId:= inDocumentTaxKindId_inf; END IF;

     -- это тип формирования по дефолту
     IF COALESCE (inDocumentTaxKindId, 0) = 0
     THEN inDocumentTaxKindId:= zc_Enum_DocumentTaxKind_Corrective();
     END IF;

     --
     IF inDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_Corrective(), zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical(), zc_Enum_DocumentTaxKind_ChangePercent())
     THEN
         RAISE EXCEPTION 'Ошибка.Неверно указан тип корректировки.';
     END IF;


     -- определяются параметры для <Налогового документа> из "текущего"
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.DescId AS MovementDescId
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                      THEN MovementDate_OperDatePartner.ValueData -- совпадает с датой контрагента
                 ELSE Movement.OperDate  -- совпадает с документом inMovementId
            END AS OperDate
          , DATE_TRUNC ('MONTH', Movement.OperDate) AS StartDate
          , DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate

          , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData AS VATPercent
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN ObjectLink_Partner_Juridical.ChildObjectId
                 WHEN Movement.DescId = zc_Movement_ChangePercent() THEN MovementLinkObject_To.ObjectId
                 ELSE MovementLinkObject_From.ObjectId
            END AS FromId
          , ObjectLink_Contract_JuridicalBasis.ChildObjectId AS ToId -- От кого - всегда главное юр.лицо из договора
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_From.ObjectId ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
          , COALESCE (MovementLinkObject_ContractFrom.ObjectId, MovementLinkObject_Contract.ObjectId) AS ContractId
          , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) AS BranchId
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData
                 WHEN Movement.DescId = zc_Movement_ChangePercent() THEN MovementFloat_ChangePercent.ValueData
                 ELSE 0
            END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 AND Movement.DescId <> zc_Movement_ChangePercent() THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                      THEN zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical() -- !!!не меняется!!!
                 WHEN Movement.DescId = zc_Movement_PriceCorrective()
                      THEN zc_Enum_DocumentTaxKind_CorrectivePrice() -- !!!всегда такая!!!
                 ELSE inDocumentTaxKindId -- !!!не меняется!!!
            END AS DocumentTaxKindId

           , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
           , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
           , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue

            INTO vbStatusId, vbInvNumber
               , vbMovementDescId, vbOperDate, vbStartDate, vbEndDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId, vbBranchId
               , vbDiscountPercent, vbExtraChargesPercent, inDocumentTaxKindId
               , vbCurrencyDocumentId, vbCurrencyValue, vbParValue
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                      AND MovementLinkObject_Partner.DescId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtIn()
                                                                                        THEN zc_MovementLinkObject_PartnerFrom()
                                                                                   ELSE zc_MovementLinkObject_Partner()
                                                                              END
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                       ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                      AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                               ON ObjectLink_Contract_JuridicalBasis.ObjectId = COALESCE (MovementLinkObject_ContractFrom.ObjectId, MovementLinkObject_Contract.ObjectId)
                              AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                       ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
          LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                  ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                 AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
          LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                  ON MovementFloat_ParValue.MovementId = Movement.Id
                                 AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

     WHERE Movement.Id = inMovementId
    ;
     -- !!!замена!!!
     IF inStartDateTax IS NULL THEN inStartDateTax:= DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '4 MONTH'; END IF;


     IF inIsTaxLink = FALSE AND vbMovementDescId = zc_Movement_PriceCorrective()
        AND EXISTS (SELECT 1
                    FROM MovementItem AS MI
                         INNER JOIN MovementItem AS MI_child ON MI_child.ParentId = MI.Id AND MI_child.DescId = zc_MI_Child() AND MI_child.MovementId = inMovementId AND MI_child.isErased = FALSE
                    WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Т.к. есть привзяка к возвратам, налоговый документ тоже должен формироваться с привязкой.';
     END IF;

     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete() AND (inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical() AND inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_ChangePercent()) AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Формирование <Корректировки к налоговой> на основании документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_Complete() AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical() AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Формирование <Корректировки к налоговой> на основании документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


     -- таблица - Данные
     CREATE TEMP TABLE _tmpMovement_PriceCorrective (MovementId Integer, MovementId_Corrective Integer, MovementId_Tax Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMI_Return (GoodsId Integer, GoodsKindId Integer, OperPrice TFloat, OperPrice_original TFloat, CountForPrice TFloat, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMovement_find (MovementId_Corrective Integer, MovementId_Tax Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult (MovementId_Corrective Integer, MovementId_Tax Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, OperPrice TFloat, OperPrice_original TFloat, CountForPrice TFloat) ON COMMIT DROP;
     -- данные для курсор2 - отдельно !!!для оптимизации!!!
     CREATE TEMP TABLE _tmp1_SubQuery (MovementId Integer, OperDate TDateTime, isRegistered Boolean, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2_SubQuery (MovementId_Tax Integer, Amount TFloat) ON COMMIT DROP;


     IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
     THEN
         -- выбрали ВСЕ <Корректировка цены>
         INSERT INTO _tmpMovement_PriceCorrective (MovementId, MovementId_Corrective, MovementId_Tax)
            SELECT Movement.Id AS MovementId, COALESCE (Movement_Corrective.Id, 0) AS MovementId_Corrective, COALESCE (MLM_Child.MovementChildId, 0) AS MovementId_Tax
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId = vbContractId
                 INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                              AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                              AND MovementLinkObject.ObjectId = vbFromId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_to
                                               ON MovementLinkObject_to.MovementId = Movement.Id
                                              AND MovementLinkObject_to.DescId = zc_MovementLinkObject_To()
                                              AND MovementLinkObject_to.ObjectId = vbToId
                 LEFT JOIN MovementLinkMovement AS MLM_Master
                                                ON MLM_Master.MovementChildId = Movement.Id
                                               AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                 LEFT JOIN Movement AS Movement_Corrective ON Movement_Corrective.Id = MLM_Master.MovementId
                                                          AND COALESCE (Movement_Corrective.StatusId, 0) <> zc_Enum_Status_Erased()
                 LEFT JOIN MovementLinkMovement AS MLM_Child
                                                ON MLM_Child.MovementId = MLM_Master.MovementId
                                               AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
            WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
              AND Movement.DescId = zc_Movement_PriceCorrective()
              AND Movement.StatusId = zc_Enum_Status_Complete()
              -- AND COALESCE (Movement_Corrective.StatusId, 0) <> zc_Enum_Status_Erased()
           ;

         -- проверка
         IF EXISTS (SELECT 1 FROM _tmpMovement_PriceCorrective GROUP BY _tmpMovement_PriceCorrective.MovementId HAVING COUNT(*) > 1)
         THEN
             RAISE EXCEPTION 'Ошибка.У одного документа <Корректировка цены> найдена больше чем одна <Корректировка к налоговой>.';
         END IF;


         -- выбрали ВСЕ <Корректировка цены>
         INSERT INTO _tmpMI_Return (GoodsId, GoodsKindId, OperPrice, OperPrice_original, CountForPrice, Amount)
            WITH tmpMI AS (SELECT MovementItem.*
                          FROM _tmpMovement_PriceCorrective
                               INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_PriceCorrective.MovementId
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                         )
                , tmpMIFloat AS (SELECT MovementItemFloat.*
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                )
                , tmpMILO AS (SELECT MovementItemLinkObject.*
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                AND MovementItemLinkObject.DescId        = zc_MILinkObject_GoodsKind()
                             )
            --
            SELECT MovementItem.ObjectId AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                             -- в "налоговом документе" всегда будут без НДС
                             THEN CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND 1=0 -- это корректировка...
                                       THEN       COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                / (1 + vbVATPercent / 100)
                                       ELSE CAST (COALESCE (MIFloat_Price.ValueData, 0)
                                                / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                                  END
                        ELSE CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND 1=0 -- это корректировка...
                                       THEN COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                       ELSE COALESCE (MIFloat_Price.ValueData, 0)
                             END
                                  
                   END AS OperPrice
                 , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                             -- в "налоговом документе" всегда будут без НДС
                             THEN CAST (COALESCE (MIFloat_PriceTax_calc.ValueData, 0) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                        ELSE COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                   END AS OperPrice_original
                 , MIFloat_CountForPrice.ValueData AS CountForPrice
                 , SUM (MovementItem.Amount)       AS Amount
            FROM _tmpMovement_PriceCorrective
                 INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = _tmpMovement_PriceCorrective.MovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                 LEFT JOIN tmpMIFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         -- AND MIFloat_Price.ValueData <> 0
                 LEFT JOIN tmpMIFloat AS MIFloat_PriceTax_calc
                                             ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                            AND MIFloat_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                                         -- AND MIFloat_PriceTax_calc.ValueData <> 0
                 LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                 LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            GROUP BY MovementItem.ObjectId
                   , MILinkObject_GoodsKind.ObjectId
                   , MIFloat_Price.ValueData
                   , MIFloat_PriceTax_calc.ValueData
                   , MIFloat_CountForPrice.ValueData
           ;
     ELSE
         -- выбрали <Возврат от покупателя> или <Перевод долга (приход)> или <Корректировка цены> или Акт по предоставлению скидки
         INSERT INTO _tmpMI_Return (GoodsId, GoodsKindId, OperPrice, OperPrice_original, CountForPrice, Amount)
            SELECT tmpMI.GoodsId
                 , tmpMI.GoodsKindId
                 , tmpMI.OperPrice
                 , CASE WHEN vbMovementDescId = zc_Movement_PriceCorrective() THEN tmpMI.OperPrice_original ELSE tmpMI.OperPrice END AS OperPrice_original
                 , tmpMI.CountForPrice
                 , tmpMI.Amount
            FROM (SELECT MovementItem.ObjectId AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                   -- в "налоговом документе" всегда будут без НДС
                                   THEN CAST (CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0
                                                   THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100)
                                                             * COALESCE (MIFloat_Price.ValueData, 0) 
                                                             AS NUMERIC (16, 2))
                                                   ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                              END / (1 + vbVATPercent / 100)
                                            * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                                        THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                   ELSE 1
                                              END
                                              AS NUMERIC (16, 2))

                              ELSE CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0
                                        THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100)
                                                  * COALESCE (MIFloat_Price.ValueData, 0)
                                                  * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                                              THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                         ELSE 1
                                                    END
                                                  AS NUMERIC (16, 2))
                                        ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                           * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                                       THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                  ELSE 1
                                             END
                                   END

                         END AS OperPrice
                       , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                   -- в "налоговом документе" всегда будут без НДС
                                   THEN CAST (CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0 THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100) * COALESCE (MIFloat_PriceTax_calc.ValueData, 0) AS NUMERIC (16, 2)) ELSE COALESCE (MIFloat_PriceTax_calc.ValueData, 0) END
                                            / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                              ELSE CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0 THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100) * COALESCE (MIFloat_PriceTax_calc.ValueData, 0) AS NUMERIC (16, 2)) ELSE COALESCE (MIFloat_PriceTax_calc.ValueData, 0) END
                         END AS OperPrice_original
                       , MIFloat_CountForPrice.ValueData AS CountForPrice
                       , SUM (CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                   WHEN vbMovementDescId IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective(), zc_Movement_ChangePercent()) THEN MovementItem.Amount
                                   ELSE 0
                              END) AS Amount
                  FROM MovementItem
                       INNER JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                   AND MIFloat_Price.ValueData <> 0
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                   ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                  AND MIFloat_AmountPartner.ValueData <> 0
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                  GROUP BY MovementItem.ObjectId
                         , MILinkObject_GoodsKind.ObjectId
                         , MIFloat_Price.ValueData
                         , MIFloat_PriceTax_calc.ValueData
                         , MIFloat_CountForPrice.ValueData
                 ) AS tmpMI
            WHERE tmpMI.Amount <> 0
           ;
     END IF;



     IF (zc_isReturnIn_bySale() = TRUE AND vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_ChangePercent() ))    --  
        OR (vbMovementDescId = zc_Movement_PriceCorrective()
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         INNER JOIN MovementItem AS MI_master ON MI_master.Id = MovementItem.ParentId AND MI_master.DescId = zc_MI_Master() AND MI_master.MovementId = inMovementId AND MI_master.isErased = FALSE
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Child()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0)
           )
     THEN  
          IF vbMovementDescId = zc_Movement_ChangePercent()
          THEN
          INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, OperPrice_original, CountForPrice)
           WITH
           tmpTax AS (SELECT Movement.*
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND MovementLinkObject_To.ObjectId = vbFromId

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                       AND MovementLinkObject_Contract.ObjectId = vbContractId

                      WHERE Movement.DescId = zc_Movement_Tax()
                        AND Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', vbOperDate) AND DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                        --AND (MovementLinkObject_Partner.ObjectId = vbPartnerId OR vbPartnerId = 0) 
                      )
         , tmpMI AS (SELECT tmpTax.Id                       AS MovementId_Tax
                          , MovementItem.ObjectId           AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , SUM (MovementItem.Amount) AS Amount
                            -- OperPrice
                          , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                      -- в "налоговом документе" всегда будут без НДС
                                      THEN CAST (CAST ( MIFloat_Price.ValueData * vbDiscountPercent / 100 AS NUMERIC (16, 2)) -- цена скидки
                                               / (1 + vbVATPercent / 100)
                                               AS NUMERIC (16, 2))
                                 ELSE CAST (MIFloat_Price.ValueData * vbDiscountPercent / 100 AS NUMERIC (16, 2))             -- цена скидки
 
                            END AS OperPrice

                            -- OperPrice_original
                          , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                      -- в "налоговом документе" всегда будут без НДС
                                      THEN CAST (COALESCE (MIFloat_Price.ValueData, 0)
                                               / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                                 ELSE COALESCE (MIFloat_Price.ValueData, 0)
                            END AS OperPrice_original
                            -- CountForPrice
                          , MIFloat_CountForPrice.ValueData AS CountForPrice
                     FROM tmpTax
                          INNER JOIN MovementItem ON MovementItem.MovementId = tmpTax.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE

                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     GROUP BY tmpTax.Id
                           , MovementItem.ObjectId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                             -- OperPrice
                           , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                       -- в "налоговом документе" всегда будут без НДС
                                       THEN CAST (CAST ( MIFloat_Price.ValueData * vbDiscountPercent / 100 AS NUMERIC (16, 2)) -- цена скидки
                                                / (1 + vbVATPercent / 100)
                                                AS NUMERIC (16, 2))
                                  ELSE CAST (MIFloat_Price.ValueData * vbDiscountPercent / 100 AS NUMERIC (16, 2))             -- цена скидки
  
                             END

                             -- OperPrice_original
                           , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                       -- в "налоговом документе" всегда будут без НДС
                                       THEN CAST (COALESCE (MIFloat_Price.ValueData, 0)
                                                / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                                  ELSE COALESCE (MIFloat_Price.ValueData, 0)
                             END
                             -- CountForPrice
                           , MIFloat_CountForPrice.ValueData
                     )
        
                , tmpMovement_Corrective AS (SELECT MIN (MovementLinkMovement_Corrective.MovementId) AS MovementId
                                                  , MovementLinkMovement_Tax.MovementChildId AS MovementId_Tax
                                             FROM MovementLinkMovement AS MovementLinkMovement_Corrective
                                                  INNER JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                                                  ON MovementLinkMovement_Tax.MovementId     = MovementLinkMovement_Corrective.MovementId
                                                                                 AND MovementLinkMovement_Tax.DescId         = zc_MovementLinkMovement_Child()
                                                                                 AND MovementLinkMovement_Tax.MovementChildId > 0
                                             WHERE MovementLinkMovement_Corrective.MovementChildId = inMovementId
                                               AND MovementLinkMovement_Corrective.DescId          = zc_MovementLinkMovement_Master()
                                             GROUP BY MovementLinkMovement_Tax.MovementChildId
                                            )
 
             -- РЕЗУЛЬТАТ
             SELECT COALESCE (tmpMovement_Corrective.MovementId, 0) AS MovementId_Corrective
                  , COALESCE (tmpMI.MovementId_Tax, 0) AS MovementId_Tax
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Amount
                  , CAST (tmpMI.OperPrice AS NUMERIC (16,2)) AS OperPrice
                  , tmpMI.OperPrice_original
                  , tmpMI.CountForPrice
             FROM tmpMI
                  LEFT JOIN tmpMovement_Corrective ON tmpMovement_Corrective.MovementId_Tax = tmpMI.MovementId_Tax
             WHERE tmpMI.MovementId_Tax > 0
             ;
          
          ELSE          
          -- в этом случае привязка - zc_MI_Child
          INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, OperPrice_original, CountForPrice)
             WITH tmpMovement AS (-- выбрали ВСЕ <Корректировка цены>
                                  SELECT _tmpMovement_PriceCorrective.MovementId
                                  FROM  _tmpMovement_PriceCorrective
                                  WHERE inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                 UNION
                                  SELECT inMovementId AS MovementId
                                 )
                   , tmpMI_all AS (SELECT MI.*
                                   FROM MovementItem AS MI
                                   WHERE MI.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                                   --AND MI.DescId     = zc_MI_Master()
                                   --AND MI.isErased   = FALSE
                                  )
                 /*, tmpMI_Child AS (SELECT MI.*
                                   FROM MovementItem AS MI
                                   WHERE MI.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                                     AND MI.DescId     = zc_MI_Child()
                                   --AND MI_Master.isErased   = FALSE
                                  )*/
                  , tmpMIFloat AS (SELECT MIF.*
                                   FROM MovementItemFloat AS MIF
                                   WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                                  )

                , tmpMI AS (SELECT MovementLinkMovement_Tax.MovementChildId      AS MovementId_Tax
                                 , MI_Master.ObjectId                            AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , SUM (MovementItem.Amount) AS Amount
                                   -- OperPrice
                                 , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                             -- в "налоговом документе" всегда будут без НДС
                                             THEN CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbMovementDescId = zc_Movement_ReturnIn()
                                                                  THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                             inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                           , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                           , inPrice        := MIFloat_Price.ValueData
                                                                                                             * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                                         THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                                    ELSE 1
                                                                                                               END
                                                                                           , inIsWithVAT    := vbPriceWithVAT
                                                                                            )
                                                             WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                                  THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                             inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                           , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                           , inPrice        := MIFloat_Price.ValueData
                                                                                                             * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                                         THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                                    ELSE 1
                                                                                                               END
                                                                                           , inIsWithVAT    := vbPriceWithVAT
                                                                                            )
                                                             ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                                                * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                            THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                       ELSE 1
                                                                  END
                                                        END
                                                      / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                                        ELSE CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbMovementDescId = zc_Movement_ReturnIn()
                                                       THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                  inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                , inPrice        := MIFloat_Price.ValueData
                                                                                                  * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                              THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                         ELSE 1
                                                                                                    END
                                                                                , inIsWithVAT    := vbPriceWithVAT
                                                                                 )

                                                  WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                       THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                  inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                , inPrice        := MIFloat_Price.ValueData
                                                                                                  * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                              THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                         ELSE 1
                                                                                                    END
                                                                                , inIsWithVAT    := vbPriceWithVAT
                                                                                 )
                                                  ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                                     * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                 THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                            ELSE 1
                                                       END
                                             END
                                   END AS OperPrice
                                   -- OperPrice_original
                                 , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                             -- в "налоговом документе" всегда будут без НДС
                                             THEN CAST (CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                                  THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                             inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                           , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                           , inPrice        := MIFloat_PriceTax_calc.ValueData
                                                                                           , inIsWithVAT    := vbPriceWithVAT
                                                                                            )
                                                             ELSE COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                                                        END
                                                      / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                                        ELSE CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                       THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                  inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                , inPrice        := MIFloat_PriceTax_calc.ValueData
                                                                                , inIsWithVAT    := vbPriceWithVAT
                                                                                 )
                                                  ELSE COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                                             END
                                   END AS OperPrice_original
                                   -- CountForPrice
                                 , MIFloat_CountForPrice.ValueData AS CountForPrice
                            FROM tmpMovement
                                 INNER JOIN tmpMI_all AS MI_Master
                                                         ON MI_Master.MovementId = tmpMovement.MovementId
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.isErased   = FALSE

                                 INNER JOIN tmpMI_all AS MovementItem ON MovementItem.ParentId   = MI_Master.Id
                                                        AND MovementItem.MovementId = tmpMovement.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                                        AND MovementItem.Amount <> 0
                                 INNER JOIN tmpMIFloat AS MIFloat_MovementId
                                                              ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                             AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                 INNER JOIN tmpMIFloat AS MIFloat_MovementItemId
                                                              ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                             AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                                 LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MI_Master.Id
                                                            AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                 LEFT JOIN tmpMIFloat AS MIFloat_PriceTax_calc
                                                             ON MIFloat_PriceTax_calc.MovementItemId = MI_Master.Id
                                                            AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()
                                 LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MI_Master.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                 LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                                             ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                                            AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                                 LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id       = MIFloat_MovementId.ValueData :: Integer
                                                                    AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                 LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.MovementId = Movement_Sale.Id
                                                                  AND MI_Sale.DescId     = zc_MI_Master()
                                                                  AND MI_Sale.Id         = MIFloat_MovementItemId.ValueData :: Integer
                                                                  AND MI_Sale.isErased   = FALSE

                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                                ON MovementLinkMovement_Tax.MovementId     = MI_Sale.MovementId -- MIFloat_MovementId.ValueData :: Integer
                                                               AND MovementLinkMovement_Tax.DescId         = zc_MovementLinkMovement_Master()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MI_Sale.Id         -- MIFloat_MovementItemId.ValueData :: Integer
                                                                 AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN Movement AS Movement_Tax_find ON Movement_Tax_find.Id = MovementLinkMovement_Tax.MovementChildId

                            GROUP BY MovementLinkMovement_Tax.MovementChildId
                                   , MI_Master.ObjectId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                     -- OperPrice
                                   , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                               -- в "налоговом документе" всегда будут без НДС
                                               THEN CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbMovementDescId = zc_Movement_ReturnIn()
                                                                    THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                               inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                             , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                             , inPrice        := MIFloat_Price.ValueData
                                                                                                               * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                                           THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                                      ELSE 1
                                                                                                                 END
                                                                                             , inIsWithVAT    := vbPriceWithVAT
                                                                                              )
                                                               WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                                    THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                               inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                             , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                             , inPrice        := MIFloat_Price.ValueData
                                                                                                               * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                                           THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                                      ELSE 1
                                                                                                                 END
                                                                                             , inIsWithVAT    := vbPriceWithVAT
                                                                                              )
                                                               ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                                                  * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                              THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                         ELSE 1
                                                                    END
                                                          END
                                                        / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                                          ELSE CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbMovementDescId = zc_Movement_ReturnIn()
                                                         THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                    inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                  , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                  , inPrice        := MIFloat_Price.ValueData
                                                                                                    * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                                THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                           ELSE 1
                                                                                                      END
                                                                                  , inIsWithVAT    := vbPriceWithVAT
                                                                                   )
  
                                                    WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                         THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                    inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                  , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                  , inPrice        := MIFloat_Price.ValueData
                                                                                                    * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                                                                THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                                                                           ELSE 1
                                                                                                      END
                                                                                  , inIsWithVAT    := vbPriceWithVAT
                                                                                   )
                                                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                                       * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND MI_Master.MovementId = inMovementId
                                                                   THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                                              ELSE 1
                                                         END
                                               END
                                     END
                                     -- OperPrice_original
                                   , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                               -- в "налоговом документе" всегда будут без НДС
                                               THEN CAST (CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                                    THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                               inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                             , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                             , inPrice        := MIFloat_PriceTax_calc.ValueData
                                                                                             , inIsWithVAT    := vbPriceWithVAT
                                                                                              )
                                                               ELSE COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                                                          END
                                                        / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                                          ELSE CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbMovementDescId <> zc_Movement_ReturnIn()
                                                         THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                    inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                  , inChangePercent:= vbExtraChargesPercent - vbDiscountPercent
                                                                                  , inPrice        := MIFloat_PriceTax_calc.ValueData
                                                                                  , inIsWithVAT    := vbPriceWithVAT
                                                                                   )
                                                    ELSE COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                                               END
                                     END
                                     -- CountForPrice
                                   , MIFloat_CountForPrice.ValueData
                           )
                , tmpMovement_Corrective AS (SELECT MIN (MovementLinkMovement_Corrective.MovementId) AS MovementId
                                                  , MovementLinkMovement_Tax.MovementChildId AS MovementId_Tax
                                             FROM MovementLinkMovement AS MovementLinkMovement_Corrective
                                                  INNER JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                                                  ON MovementLinkMovement_Tax.MovementId     = MovementLinkMovement_Corrective.MovementId
                                                                                 AND MovementLinkMovement_Tax.DescId         = zc_MovementLinkMovement_Child()
                                                                                 AND MovementLinkMovement_Tax.MovementChildId > 0
                                             WHERE MovementLinkMovement_Corrective.MovementChildId = inMovementId
                                               AND MovementLinkMovement_Corrective.DescId          = zc_MovementLinkMovement_Master()
                                             GROUP BY MovementLinkMovement_Tax.MovementChildId
                                            )
             -- РЕЗУЛЬТАТ
             SELECT COALESCE (tmpMovement_Corrective.MovementId, 0) AS MovementId_Corrective
                  , COALESCE (tmpMI.MovementId_Tax, 0) AS MovementId_Tax
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Amount
                  , tmpMI.OperPrice
                  , tmpMI.OperPrice_original
                  , tmpMI.CountForPrice
             FROM tmpMI
                  LEFT JOIN tmpMovement_Corrective ON tmpMovement_Corrective.MovementId_Tax = tmpMI.MovementId_Tax
             -- WHERE tmpMI.MovementId_Tax > 0
            ;
          END IF;
          
          -- Проверка
          IF EXISTS (SELECT 1 FROM _tmpResult WHERE COALESCE (_tmpResult.MovementId_Tax, 0) = 0)
          THEN
              RAISE EXCEPTION 'Ошибка. Для товара <%> <%>%кол-во = <%> цена = <%>%не определен № налоговой.'
                            , lfGet_Object_ValueData    ((SELECT _tmpResult.GoodsId     FROM _tmpResult WHERE COALESCE (_tmpResult.MovementId_Tax, 0) = 0 ORDER BY ABS (_tmpResult.Amount) DESC, _tmpResult.OperPrice, _tmpResult.GoodsId, _tmpResult.GoodsKindId LIMIT 1))
                            , lfGet_Object_ValueData_sh ((SELECT _tmpResult.GoodsKindId FROM _tmpResult WHERE COALESCE (_tmpResult.MovementId_Tax, 0) = 0 ORDER BY ABS (_tmpResult.Amount) DESC, _tmpResult.OperPrice, _tmpResult.GoodsId, _tmpResult.GoodsKindId LIMIT 1))
                            , CHR (13)
                            , (SELECT _tmpResult.Amount FROM _tmpResult WHERE COALESCE (_tmpResult.MovementId_Tax, 0) = 0 ORDER BY ABS (_tmpResult.Amount) DESC, _tmpResult.OperPrice, _tmpResult.GoodsId, _tmpResult.GoodsKindId LIMIT 1)
                            , (SELECT CASE WHEN vbMovementDescId = zc_Movement_PriceCorrective() THEN _tmpResult.OperPrice_original ELSE _tmpResult.OperPrice END FROM _tmpResult WHERE COALESCE (_tmpResult.MovementId_Tax, 0) = 0 ORDER BY ABS (_tmpResult.Amount) DESC, _tmpResult.OperPrice, _tmpResult.GoodsId, _tmpResult.GoodsKindId LIMIT 1)
                            , CHR (13)
                             ;
          END IF;

     ELSE
     IF inIsTaxLink = FALSE OR vbMovementDescId = zc_Movement_PriceCorrective()
     THEN
          -- в этом случае не будет привязки, но есть поиск !!!одного!!! <Налогового документа> что есть у текущего <Возврат от покупателя> или <Перевод долга (приход)> или <Корректировка цены>
          WITH tmpMovement_Corrective AS (SELECT MLM_Master.MovementId AS MovementId_Corrective, COALESCE (MLM_Child.MovementChildId, 0) AS MovementId_Tax
                                          FROM MovementLinkMovement AS MLM_Master
                                               INNER JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = MLM_Master.MovementId
                                                                                            AND Movement_TaxCorrective.StatusId <> zc_Enum_Status_Erased()
                                               LEFT JOIN MovementLinkMovement AS MLM_Child
                                                                              ON MLM_Child.MovementId = MLM_Master.MovementId
                                                                             AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                          WHERE MLM_Master.MovementChildId = inMovementId
                                            AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                                          GROUP BY MLM_Master.MovementId, COALESCE (MLM_Child.MovementChildId, 0)
                                         )
             , tmpMovement_Corrective_Count AS (SELECT COUNT(*) AS myCOUNT FROM tmpMovement_Corrective)
          INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
             SELECT COALESCE (tmpMovement_Corrective.MovementId_Corrective, 0)
                  , COALESCE (tmpMovement_Corrective.MovementId_Tax, 0)
                  , GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice
             FROM _tmpMI_Return
                  LEFT JOIN tmpMovement_Corrective_Count ON tmpMovement_Corrective_Count.myCOUNT = 1
                  LEFT JOIN tmpMovement_Corrective ON tmpMovement_Corrective_Count.myCOUNT IS NOT NULL
            ;
     ELSE
         -- курсор1 - возвраты
         OPEN curMI_ReturnIn FOR
              SELECT GoodsId, GoodsKindId, Amount, OperPrice FROM _tmpMI_Return;

         -- начало цикла по курсору1 - возвраты
         LOOP
              -- данные по возвратам
              FETCH curMI_ReturnIn INTO vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice;
              -- если данные закончились, тогда выход
              IF NOT FOUND THEN EXIT; END IF;


     --
     DELETE FROM _tmp1_SubQuery;
     DELETE FROM _tmp2_SubQuery;
     -- данные для курсор2 - <Налоговые> отдельно !!!для оптимизации!!!
           WITH tmp1 AS (SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                              , MIFloat_Price.ValueData   AS Price
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementLinkObject AS MLO_Partner
                              INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                              ON MovementLinkMovement_Master.MovementId = MLO_Partner.MovementId
                                                             AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                              INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Master.MovementChildId
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.OperDate BETWEEN inStartDateTax /*vbOperDate - INTERVAL '6 MONTH'*/ AND vbOperDate - INTERVAL '1 DAY'
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND (MovementLinkObject_Contract.ObjectId = vbContractId
                                                             -- OR (Movement.OperDate < '01.02.2016' AND vbBranchId = zc_Branch_Kiev())
                                                               )
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.ObjectId = vbGoodsId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount <> 0
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          -- AND MIFloat_Price.ValueData = vbOperPrice
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementBoolean AS MB_Registered
                                                        ON MB_Registered.MovementId = Movement.Id
                                                       AND MB_Registered.DescId = zc_MovementBoolean_Registered()
                         WHERE MLO_Partner.ObjectId = vbPartnerId
                           AND MLO_Partner.DescId IN (zc_MovementLinkObject_To(), zc_MovementLinkObject_Partner())
                         GROUP BY Movement.Id
                                , Movement.OperDate
                                , MB_Registered.ValueData
                                , MIFloat_Price.ValueData
                        /*UNION
                         -- !!! для Киева по юр.р. лицу !!!
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                              , MIFloat_Price.ValueData   AS Price
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementLinkObject AS MLO_To
                              INNER JOIN Movement ON Movement.Id = MLO_To.MovementId
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.OperDate BETWEEN inStartDateTax / *vbOperDate - INTERVAL '6 MONTH' * / AND vbOperDate - INTERVAL '1 DAY'
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.ObjectId = vbGoodsId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount <> 0
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          -- AND MIFloat_Price.ValueData = vbOperPrice
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementBoolean AS MB_Registered
                                                        ON MB_Registered.MovementId = Movement.Id
                                                       AND MB_Registered.DescId = zc_MovementBoolean_Registered()
                         WHERE MLO_To.ObjectId = vbFromId
                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                           AND Movement.OperDate < '01.02.2016'
                           AND vbBranchId = zc_Branch_Kiev()
                         GROUP BY Movement.Id
                                , Movement.OperDate
                                , MB_Registered.ValueData
                                , MIFloat_Price.ValueData*/)
     -- результат
     INSERT INTO _tmp1_SubQuery (MovementId, OperDate, isRegistered, Amount)
        SELECT tmp1.MovementId, tmp1.OperDate, tmp1.isRegistered, tmp1.Amount FROM tmp1 WHERE tmp1.Price = vbOperPrice;

     -- данные для курсор2 - <Корректировки> к этим <Налоговым> отдельно !!!для оптимизации!!!
              WITH tmpMovement2 AS (SELECT Movement.Id
                                        , MIFloat_Price.ValueData AS Price
                                        , SUM (MovementItem.Amount) AS Amount
                                   FROM _tmp1_SubQuery AS tmpMovement_Tax
                                        INNER JOIN MovementLinkMovement AS MLM_Child
                                                                        ON MLM_Child.MovementChildId = tmpMovement_Tax.MovementId
                                                                       AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                        INNER JOIN Movement ON Movement.Id       = MLM_Child.MovementId
                                                           AND Movement.DescId   = zc_Movement_TaxCorrective()
                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.ObjectId   = vbGoodsId
                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                                                   -- AND MIFloat_Price.ValueData      = vbOperPrice
                                   GROUP BY Movement.Id
                                          , MIFloat_Price.ValueData
                                  )
             /*WITH tmpMovement2 AS (SELECT Movement.Id
                                        , MIFloat_Price.ValueData AS Price
                                        , SUM (MovementItem.Amount) AS Amount
                                   FROM Movement
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.ObjectId = vbGoodsId
                                                               AND MovementItem.DescId = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                   -- AND MIFloat_Price.ValueData = vbOperPrice
                                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                   WHERE Movement.DescId = zc_Movement_TaxCorrective()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   GROUP BY Movement.Id
                                          , MIFloat_Price.ValueData
                                  )*/
                 , tmpMovement AS (SELECT tmpMovement2.Id
                                        , SUM (tmpMovement2.Amount) AS Amount
                                   FROM tmpMovement2
                                   WHERE tmpMovement2.Price = vbOperPrice
                                   GROUP BY tmpMovement2.Id)
     -- Результат - !!!без "текущей" корректировки!!!
     INSERT INTO _tmp2_SubQuery (MovementId_Tax, Amount)
                                   SELECT CASE WHEN MLM_Master.MovementChildId = inMovementId THEN 0 ELSE MLM_Child.MovementChildId END AS MovementId_Tax
                                        , SUM (Movement.Amount) AS Amount
                                   FROM tmpMovement AS Movement
                                        INNER JOIN MovementLinkMovement AS MLM_Child
                                                                        ON MLM_Child.MovementId = Movement.Id
                                                                       AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                        INNER JOIN MovementLinkMovement AS MLM_Master
                                                                        ON MLM_Master.MovementId = Movement.Id
                                                                       AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                                   GROUP BY CASE WHEN MLM_Master.MovementChildId = inMovementId THEN 0 ELSE MLM_Child.MovementChildId END;

              -- курсор2 - все налоговые !!!за минусом прошлых корректировок!!! по товару и цене
              OPEN curMI_Tax FOR
                   SELECT tmpMovement_Tax.MovementId
                        , tmpMovement_Tax.Amount - COALESCE (tmpMovement_Corrective.Amount, 0) AS Amount
                         -- это все налоговые по покупатель, товар и цена
                   FROM _tmp1_SubQuery AS tmpMovement_Tax
                        -- это !!!все!!! корректировки по товар и цена (для !!!всех!!! налоговых)
                        LEFT JOIN _tmp2_SubQuery AS tmpMovement_Corrective ON tmpMovement_Corrective.MovementId_Tax = tmpMovement_Tax.MovementId
                   WHERE tmpMovement_Tax.Amount > COALESCE (tmpMovement_Corrective.Amount, 0)
                     AND tmpMovement_Tax.isRegistered = FALSE
                   ORDER BY tmpMovement_Tax.OperDate DESC, 2 DESC
                  ;

              -- начало цикла по курсору2 - налоговые
              LOOP
                  -- данные по налоговым
                  FETCH curMI_Tax INTO vbMovementId_Tax, vbAmount_Tax;
                  -- если данные закончились, или все кол-во найдено тогда выход
                  IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

                  --
                  IF vbAmount_Tax > vbAmount
                  THEN
                      -- получилось в налоговой больше чем искали, !!!сохраняем в табл-результата!!!
                      INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
                         SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice, 1 AS CountForPrice;
                      -- обнуляем кол-во что бы больше не искать
                      vbAmount:= 0;
                  ELSE
                      -- получилось в налоговой меньше чем искали, !!!сохраняем в табл-результата!!!
                      INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
                         SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount_Tax, vbOperPrice, 1 AS CountForPrice;
                      -- уменьшаем на кол-во которое нашли и продолжаем поиск
                      vbAmount:= vbAmount - vbAmount_Tax;
                  END IF;

              END LOOP; -- финиш цикла по курсору2 - налоговые
              CLOSE curMI_Tax; -- закрыли курсор2 - налоговые

         END LOOP; -- финиш цикла по курсору1 - возвраты
         CLOSE curMI_ReturnIn; -- закрыли курсор1 - возвраты

     END IF; -- завершили привязку к налоговым или не привязку (т.е. все данные в табл-результат)
     END IF; -- завершили привязку к налоговым или не привязку (т.е. все данные в табл-результат)


     -- проверка
     IF NOT EXISTS (SELECT 1 FROM _tmpResult)
     THEN
         RAISE EXCEPTION 'Ошибка.Налоговый документ не найден.';
     END IF;


     -- !!!осталось сохранить данные!!!!

     -- находим те <Налоговые документы> что есть у текущего <Возврат от покупателя> или <Перевод долга (приход)> или <Корректировка цены>
     INSERT INTO _tmpMovement_find (MovementId_Corrective, MovementId_Tax)
        SELECT MLM_Master.MovementId, COALESCE (MLM_Child.MovementChildId, 0)
        FROM MovementLinkMovement AS MLM_Master
             LEFT JOIN MovementLinkMovement AS MLM_Child
                                            ON MLM_Child.MovementId = MLM_Master.MovementId
                                           AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
        WHERE MLM_Master.MovementChildId = inMovementId
          AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
       UNION
        SELECT _tmpMovement_PriceCorrective.MovementId_Corrective, _tmpMovement_PriceCorrective.MovementId_Tax FROM _tmpMovement_PriceCorrective WHERE _tmpMovement_PriceCorrective.MovementId_Corrective > 0
      ;


     -- для табл-результата обновляем те <Налоговые документы> что есть
     UPDATE _tmpResult SET MovementId_Corrective = _tmpMovement_find.MovementId_Corrective
     FROM _tmpMovement_find
     WHERE _tmpResult.MovementId_Tax = _tmpMovement_find.MovementId_Tax
       AND _tmpResult.MovementId_Corrective = 0
    ;


     -- распроводим/восстанавливаем найденные <Налоговые документы>
     PERFORM lpUnComplete_Movement (inMovementId       := tmpResult_update.MovementId_Corrective
                                  , inUserId           := vbUserId
                                   )
     FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult WHERE MovementId_Corrective <> 0) AS tmpResult_update;

     -- удаляем строчную часть что была в <Налоговых документах>
     PERFORM gpMovementItem_TaxCorrective_SetErased (inMovementItemId:= MovementItem.Id
                                                   , inSession       := inSession
                                                    )
     FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult WHERE MovementId_Corrective <> 0) AS tmpResult_update
          INNER JOIN MovementItem ON MovementItem.MovementId = tmpResult_update.MovementId_Corrective
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE;

     -- удаляем ненужные <Налоговые документы>
     PERFORM lpSetErased_Movement (inMovementId       := tmpResult_delete.MovementId_Corrective
                                 , inUserId           := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpMovement_find.MovementId_Corrective
           FROM _tmpMovement_find
                 LEFT JOIN _tmpResult ON _tmpResult.MovementId_Corrective = _tmpMovement_find.MovementId_Corrective
           WHERE _tmpResult.MovementId_Corrective IS NULL
          ) AS tmpResult_delete;



     -- меняем заголовок для существующих <Налоговых документов>
     PERFORM lpInsertUpdate_Movement_TaxCorrective (ioId               := tmpResult_update.MovementId_Corrective
                                                  , inInvNumber        := Movement.InvNumber
                                                  , inInvNumberPartner := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementString_InvNumberPartner()), '')
                                                  , inInvNumberBranch  := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementString_InvNumberBranch()), '')
                                                  , inOperDate         := vbOperDate
                                                  , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementBoolean_Checked()), FALSE)
                                                  , inDocument         := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementBoolean_Document()), FALSE)
                                                  , inPriceWithVAT     := FALSE -- в корректировках цены всегда будут без НДС -- vbPriceWithVAT
                                                  , inVATPercent       := vbVATPercent
                                                  , inFromId           := vbFromId
                                                  , inToId             := vbToId
                                                  , inPartnerId        := vbPartnerId
                                                  , inContractId       := vbContractId
                                                  , inDocumentTaxKindId:= inDocumentTaxKindId
                                                  , inUserId           := vbUserId
                                                   )
     FROM (SELECT DISTINCT MovementId_Corrective
           FROM _tmpResult
           WHERE MovementId_Corrective <> 0
          ) AS tmpResult_update
          INNER JOIN Movement ON Movement.Id = tmpResult_update.MovementId_Corrective;


     -- создаем новые <Налоговые документы>
     UPDATE _tmpResult SET MovementId_Corrective = tmpResult_insert.MovementId_Corrective
     FROM (SELECT lpInsertUpdate_Movement_TaxCorrective (ioId               :=0
                                                       , inInvNumber        := tmpResult_insert.InvNumber :: TVarChar
                                                       , inInvNumberPartner := tmpResult_insert.InvNumberPartner :: TVarChar
                                                       , inInvNumberBranch  := ''
                                                       , inOperDate         := vbOperDate
                                                       , inChecked          := FALSE
                                                       , inDocument         := FALSE
                                                       , inPriceWithVAT     := FALSE -- в корректировках цены всегда будут без НДС -- vbPriceWithVAT
                                                       , inVATPercent       := vbVATPercent
                                                       , inFromId           := vbFromId
                                                       , inToId             := vbToId
                                                       , inPartnerId        := vbPartnerId
                                                       , inContractId       := vbContractId
                                                       , inDocumentTaxKindId:= inDocumentTaxKindId
                                                       , inUserId           := vbUserId
                                                      ) AS MovementId_Corrective
                , tmpResult_insert.MovementId_Tax
           FROM (SELECT NEXTVAL ('movement_taxcorrective_seq') AS InvNumber
                      , lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective()
                                                        , vbOperDate, CASE WHEN vbOperDate >= '01.01.2016'
                                                                                THEN ''
                                                                           ELSE (SELECT ObjectString.ValueData
                                                                                 FROM (SELECT zfGet_Branch_AccessKey (lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())) AS BranchId
                                                                                      ) AS tmp
                                                                                      INNER JOIN ObjectString ON ObjectString.ObjectId = tmp.BranchId AND ObjectString.DescId = zc_objectString_Branch_InvNumber()
                                                                                )
                                                                      END
                                                         ) AS InvNumberPartner
                      , tmpResult_insert.MovementId_Tax
                 FROM (SELECT DISTINCT MovementId_Tax FROM _tmpResult WHERE MovementId_Corrective = 0) AS tmpResult_insert
                ) AS tmpResult_insert
         ) AS tmpResult_insert
     WHERE _tmpResult.MovementId_Tax = tmpResult_insert.MovementId_Tax;


--if inSession = '5'
--then
--    RAISE EXCEPTION 'Ошибка.<%>   %', (select distinct _tmpResult.OperPrice from _tmpResult)
--    , (select distinct _tmpResult.OperPrice_original from _tmpResult);
--end if;
     -- создаем строчную часть заново в <Налоговых документах>
     PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                      , inMovementId         := _tmpResult.MovementId_Corrective
                                                      , inGoodsId            := _tmpResult.GoodsId
                                                      , inAmount             := _tmpResult.Amount
                                                      , inPrice              := _tmpResult.OperPrice
                                                      , inPriceTax_calc      := _tmpResult.OperPrice_original
                                                      , ioCountForPrice      := _tmpResult.CountForPrice
                                                      , inGoodsKindId        := _tmpResult.GoodsKindId
                                                      , inUserId             := vbUserId
                                                       )
     FROM _tmpResult;


     -- сохранили связь с <Тип формирования налогового документа> у <Возврат от покупателя> или <Перевод долга (приход)> или <Корректировка цены>
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
     THEN
         -- для всех документов
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), _tmpMovement_PriceCorrective.MovementId, inDocumentTaxKindId)
         FROM _tmpMovement_PriceCorrective;
     ELSE
         -- для одного документа
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), inMovementId, inDocumentTaxKindId);
     END IF;

     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
     THEN
          -- удалили связь <Налогового документа> с <Корректировка цены>
          DELETE FROM MovementLinkMovement WHERE MovementId IN (SELECT MovementId_Corrective FROM _tmpMovement_PriceCorrective)
                                             AND MovementChildId IN (SELECT MovementId FROM _tmpMovement_PriceCorrective)
                                             AND DescId = zc_MovementLinkMovement_Master();

          -- сформировали связь <Налогового документа> с Налоговыми
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), MovementId_Corrective, MovementId_Tax)
          FROM (SELECT DISTINCT MovementId_Corrective, MovementId_Tax FROM _tmpResult ) AS tmpResult_update;

     ELSE
          -- сформировали связь <Налогового документа> с <Возврат от покупателя> или <Перевод долга (приход)> или <Корректировка цены>
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), MovementId_Corrective, inMovementId)
          FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmpResult_update;

          -- сформировали связь <Налогового документа> с Налоговыми
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), MovementId_Corrective, MovementId_Tax)
          FROM (SELECT DISTINCT MovementId_Corrective, MovementId_Tax FROM _tmpResult ) AS tmpResult_update;
     END IF;


     -- пересчитали Итоговые суммы по <Налоговым документам>
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= tmpResult_update.MovementId_Corrective)
     FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmpResult_update;


     -- ФИНИШ - Проводим все <Налоговые документы (Корректировки)>
     outMessageText:= (SELECT MAX (COALESCE (lpComplete_Movement_TaxCorrective (inMovementId := tmpResult_complete.MovementId_Corrective
                                                                              , inUserId     := vbUserId)
                                           , ''))
                       FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmpResult_complete
                      );


     -- результат
     IF (SELECT COUNT(*) FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmp) = 1
     THEN
         outMovementId_Corrective:= (SELECT MAX (MovementId_Corrective) FROM _tmpResult);
     END IF;

     -- результат
     SELECT Object_TaxKind.Id, Object_TaxKind.ValueData
            INTO outDocumentTaxKindId, outDocumentTaxKindName
     FROM Object AS Object_TaxKind
     WHERE Object_TaxKind.Id = inDocumentTaxKindId;

if (vbUserId = 5 OR vbUserId = 9457) AND 1=1
then
    RAISE EXCEPTION 'Admin - Errr _end - <%>  <%>'
                  , (SELECT COUNT(*) FROM _tmpResult)
                  , outMessageText
                   ;
    -- 'Повторите действие через 3 мин.'
end if;



     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
               -- ProtocolData
             , inMovementId :: TVarChar
    || ', ' || inDocumentTaxKindId :: TVarChar
    || ', ' || inDocumentTaxKindId_inf :: TVarChar
    || ', ' || CHR (39) || zfConvert_DateToString (inStartDateTax) || CHR (39)
    || ', ' || CASE WHEN inIsTaxLink = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || inSession
              ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.03.23         * add zc_Movement_ChangePercent 
 10.05.16         * add inStartDateTax
 31.07.14                                        * add outMovementId_Corrective
 06.06.14                                        * add проверка - проведенные/удаленные документы Изменять нельзя
 03.06.14                                        * add в налоговых цены всегда будут без НДС + в корректировках цены всегда будут без НДС
 03.06.14                                        * add zc_Movement_PriceCorrective
 29.05.14                                        * add zc_MovementLinkObject_Partner
 20.05.14                                        * add zc_Movement_TransferDebtIn
 10.05.14                                        * add lpComplete_Movement_TaxCorrective
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 10.04.14                                        * ALL
 13.02.14                                                        *
*/

-- тест
-- SELECT * FROM ResourseProtocol where OperDate > CURRENT_DATE and ProcName ilike '%gpInsertUpdate_Movement_TaxCorrective_From_Kind%' ORDER BY Id DESC LIMIT 100
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind (inMovementId:= 3409416, inDocumentTaxKindId:= 0, inDocumentTaxKindId_inf:= 0, inIsTaxLink:= TRUE, inSession := '5');
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind (inMovementId:= 3449385, inDocumentTaxKindId:= 0, inDocumentTaxKindId_inf:= 0, inIsTaxLink:= TRUE, inSession := '5');
-- select * from gpInsertUpdate_Movement_TaxCorrective_From_Kind(inMovementId := 16691011 , inDocumentTaxKindId := 566452 , inDocumentTaxKindId_inf := 566452 , inStartDateTax := NULL , inIsTaxLink := 'True' ,  inSession := '5');
-- select * from gpInsertUpdate_Movement_TaxCorrective_From_Kind(inMovementId := 22528897 , inDocumentTaxKindId := 0 , inDocumentTaxKindId_inf := 0 , inStartDateTax := ('01.12.2021')::TDateTime , inIsTaxLink := 'True' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
--select * from gpInsertUpdate_Movement_TaxCorrective_From_Kind(inMovementId := 24743082 , inDocumentTaxKindId := 9178892 , inDocumentTaxKindId_inf := 9178892 , inStartDateTax := ('01.01.1900')::TDateTime , inIsTaxLink := 'True' ,  inSession := '9457');

