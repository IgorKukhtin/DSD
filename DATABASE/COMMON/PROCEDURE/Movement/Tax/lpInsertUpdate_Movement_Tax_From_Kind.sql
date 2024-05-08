-- Function: lpInsertUpdate_Movement_Tax_From_Kind()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId                 Integer  , -- ключ Документа
    IN inDocumentTaxKindId          Integer  , -- Тип формирования налогового документа
    IN inDocumentTaxKindId_inf      Integer  , -- Тип формирования налогового документа
    IN inStartDateTax               TDateTime, --
   OUT outInvNumberPartner_Master   TVarChar , --
   OUT outDocumentTaxKindId         Integer  , --
   OUT outDocumentTaxKindName       TVarChar , --
   OUT outMessageText               Text     ,
    IN inUserId                     Integer    -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbMovementDescId           Integer;
   DECLARE vbMovementId_Sale          Integer;
   DECLARE vbMovementId_Tax           Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbStartDate        TDateTime;
   DECLARE vbEndDate          TDateTime;
   DECLARE vbInvNumber_Tax        TVarChar;
   DECLARE vbInvNumberPartner_Tax TVarChar;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;
   DECLARE vbPaidKindId       Integer;
   DECLARE vbDocumentTaxKindId_TaxCorrective Integer;

   DECLARE vbDiscountPercent TFloat;
   DECLARE vbExtraChargesPercent TFloat;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;

   DECLARE vbMovementId_Tax_find   Integer;
   DECLARE vbAmount_Tax_find       TFloat;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbOperPrice   TFloat;

   DECLARE curMI_ReturnIn refcursor;
   DECLARE curMI_Tax refcursor;
BEGIN
      -- это значит пользователь установил в журнале "другой" тип формирования
      IF inDocumentTaxKindId_inf <> 0 THEN inDocumentTaxKindId:= inDocumentTaxKindId_inf; END IF;

      -- это тип формирования по дефолту
      IF COALESCE (inDocumentTaxKindId, 0) = 0
      THEN inDocumentTaxKindId:= zc_Enum_DocumentTaxKind_Tax();
      END IF;

      -- это тип формирования по дефолту
      IF inUserId <> 5 AND 1=0
     AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR() -- сводная налоговая по юр.л.(реализация-возвраты)
                               , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR() -- сводная налоговая по т.т.(реализация-возвраты)
                               , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS() -- сводная налоговая по юр.л.(реализация)
                               , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS() -- сводная налоговая по т.т.(реализация)
                                )
      THEN
          RAISE EXCEPTION 'Ошибка. Формирование сводного документа не работает. Все сформированные документы за май необходимо будет переформировать.';
      END IF;


      -- Создание или ...
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpmovement')
      THEN
          -- временная таблица "база" документов
          DELETE FROM _tmpMovement;
          -- временная таблица "база" строчной части
          DELETE FROM _tmpMI;
          -- временная таблица - существующие документы "Корректировки" - !!!только сводные!!!
          DELETE FROM _tmpMovementCorrective;
          -- временная таблица - привязка "Корректировки" к "Налоговой" - !!!только сводные!!!
          DELETE FROM _tmpMovementCorrective_new;
          -- временная таблица - новая строчная часть "Корректировки"
          DELETE FROM _tmpMICorrective;
          -- временная таблица - для оптимизации
          DELETE FROM _tmp1_SubQuery;
          DELETE FROM _tmp2_SubQuery;
          -- временная таблица -
          DELETE FROM _tmpRes;
      ELSE
          -- временная таблица "база" документов
          CREATE TEMP TABLE _tmpMovement (MovementId Integer, DescId Integer, DocumentTaxKindId Integer) ON COMMIT DROP;
          -- временная таблица "база" строчной части
          CREATE TEMP TABLE _tmpMI (GoodsId Integer, GoodsKindId Integer, Price TFloat, CountForPrice TFloat, Amount_Tax TFloat, Amount_TaxCorrective TFloat, MovementId_Tax Integer, MovementItemId_err Integer) ON COMMIT DROP;
          -- временная таблица - существующие документы "Корректировки" - !!!только сводные!!!
          CREATE TEMP TABLE _tmpMovementCorrective (MovementId Integer, MovementId_Tax Integer) ON COMMIT DROP;
          -- временная таблица - привязка "Корректировки" к "Налоговой" - !!!только сводные!!!
          CREATE TEMP TABLE _tmpMovementCorrective_new (MovementId Integer, MovementId_Tax Integer) ON COMMIT DROP;
          -- временная таблица - новая строчная часть "Корректировки"
          CREATE TEMP TABLE _tmpMICorrective (GoodsId Integer, GoodsKindId Integer, Price TFloat, CountForPrice TFloat, Amount TFloat, MovementId_Corrective Integer, MovementId_Tax Integer) ON COMMIT DROP;
          -- временная таблица - для оптимизации
          CREATE TEMP TABLE _tmp1_SubQuery (MovementId Integer, OperDate TDateTime, isRegistered Boolean, Amount TFloat) ON COMMIT DROP;
          CREATE TEMP TABLE _tmp2_SubQuery (MovementId_Tax Integer, Amount TFloat) ON COMMIT DROP;
          -- временная таблица -
          CREATE TEMP TABLE _tmpRes (MessageText Text) ON COMMIT DROP;
      END IF;


      -- определется тип формирования для корректировки
      vbDocumentTaxKindId_TaxCorrective:= CASE WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR() -- сводная налоговая по юр.л.(реализация-возвраты)
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR() -- сводная корректировка по юр.л.(реализация-возвраты)

                                               WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR() -- сводная налоговая по т.т.(реализация-возвраты)
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR() -- сводная корректировка по т.т.(реализация-возвраты)

                                               WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS() -- сводная налоговая по юр.л.(реализация)
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR() -- сводная корректировка по юр.л.(возвраты)

                                               WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerS() -- сводная налоговая по т.т.(реализация)
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR() -- сводная корректировка по т.т.(возвраты)
                                          END;

      -- определяются параметры для <Налогового документа>
      SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN inMovementId ELSE 0 END AS MovementId_Sale
           , CASE WHEN Movement.DescId = zc_Movement_Tax() THEN inMovementId ELSE Movement_Master.Id END AS MovementId_Tax
           , Movement.DescId AS MovementDescId
           , CASE WHEN Movement.DescId = zc_Movement_Tax()
                       THEN Movement.InvNumber -- остается тот что был
                  WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
                       THEN Movement.InvNumber  -- совпадает с номером документа inMovementId
                  ELSE Movement_Master.InvNumber -- если номер документа пустой, будет создан в lpInsertUpdate_Movement_Tax
             END AS InvNumber_Tax
           , CASE WHEN Movement.DescId = zc_Movement_Tax()
                       THEN MS_InvNumberPartner.ValueData -- остается тот что был
                  ELSE MS_InvNumberPartner_Master.ValueData -- если номер налоговой пустой, будет создан в lpInsertUpdate_Movement_Tax
             END AS InvNumberPartner_Tax
           , CASE WHEN Movement.DescId = zc_Movement_Tax()
                       THEN Movement.OperDate  -- остается та что была
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut()
                       THEN Movement.OperDate  -- совпадает с документом inMovementId
                  WHEN inDocumentTaxKindId= zc_Enum_DocumentTaxKind_Tax()
                       THEN MovementDate_OperDatePartner.ValueData -- совпадает с датой контрагента
                  ELSE DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' -- будет последним днем месяца
             END AS OperDate

           , CASE -- будет с 1-ого числа месяца
                  WHEN COALESCE (ObjectFloat_Contract_DayTaxSummary.ValueData, COALESCE (ObjectFloat_Juridical_DayTaxSummary.ValueData, 0)) = 0
                    OR DATE_TRUNC ('MONTH', Movement.OperDate) = DATE_TRUNC ('MONTH', Movement.OperDate + INTERVAL '1 DAY')
                       THEN DATE_TRUNC ('MONTH', CASE WHEN Movement.DescId = zc_Movement_Tax() THEN Movement.OperDate ELSE COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) END)
                  -- будет с 1-ого + 15дней
                  WHEN COALESCE (ObjectFloat_Contract_DayTaxSummary.ValueData, COALESCE (ObjectFloat_Juridical_DayTaxSummary.ValueData, 0)) > 0
                       THEN DATE_TRUNC ('MONTH', Movement.OperDate) + ((COALESCE (ObjectFloat_Contract_DayTaxSummary.ValueData, ObjectFloat_Juridical_DayTaxSummary.ValueData) + 0) :: TVarChar || ' DAY') :: INTERVAL
             END AS StartDate
           , CASE -- будет до последнего числа месяца
                  WHEN COALESCE (ObjectFloat_Contract_DayTaxSummary.ValueData, COALESCE (ObjectFloat_Juridical_DayTaxSummary.ValueData, 0)) = 0
                       THEN DATE_TRUNC ('MONTH', CASE WHEN Movement.DescId = zc_Movement_Tax() THEN Movement.OperDate ELSE COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) END) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                  -- будет до числа в документе (это или 15-ое или 31 число, т.е. важно что б документ был последним днем)
                  WHEN COALESCE (ObjectFloat_Contract_DayTaxSummary.ValueData, COALESCE (ObjectFloat_Juridical_DayTaxSummary.ValueData, 0)) > 0
                       THEN Movement.OperDate
             END AS EndDate

           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , ObjectLink_Contract_JuridicalBasis.ChildObjectId AS FromId -- От кого - всегда главное юр.лицо из договора
           , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE MovementLinkObject_To.ObjectId END AS ToId
           , CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_Partner.ObjectId WHEN Movement.DescId = zc_Movement_Tax() THEN MovementLinkObject_Partner.ObjectId ELSE MovementLinkObject_To.ObjectId END AS PartnerId
           , COALESCE (MovementLinkObject_ContractTo.ObjectId, MovementLinkObject_Contract.ObjectId)                                          AS ContractId
           , COALESCE (MovementLinkObject_PaidKindTo.ObjectId, COALESCE (MovementLinkObject_PaidKind.ObjectId, zc_Enum_PaidKind_FirstForm())) AS PaidKindId
           , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
           , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

           , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
           , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
           , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue

             INTO vbMovementId_Sale, vbMovementId_Tax, vbMovementDescId, vbInvNumber_Tax, vbInvNumberPartner_Tax, vbOperDate, vbStartDate, vbEndDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId, vbPaidKindId
                , vbDiscountPercent, vbExtraChargesPercent
                , vbCurrencyDocumentId, vbCurrencyValue, vbParValue
      FROM Movement
           LEFT JOIN MovementString AS MS_InvNumberPartner
                                    ON MS_InvNumberPartner.MovementId = Movement.Id
                                   AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                        ON MovementLinkObject_Partner.MovementId = Movement.Id
                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                        ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                       AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                        ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                   ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                  AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                        ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                       AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
           LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                   ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                  AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
           LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                   ON MovementFloat_ParValue.MovementId = Movement.Id
                                  AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

           LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                     ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                    AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_DayTaxSummary
                                 ON ObjectFloat_Juridical_DayTaxSummary.ObjectId = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE MovementLinkObject_To.ObjectId END
                                AND ObjectFloat_Juridical_DayTaxSummary.DescId = zc_ObjectFloat_Juridical_DayTaxSummary()
           LEFT JOIN ObjectFloat AS ObjectFloat_Contract_DayTaxSummary
                                 ON ObjectFloat_Contract_DayTaxSummary.ObjectId  = COALESCE (MovementLinkObject_ContractTo.ObjectId, MovementLinkObject_Contract.ObjectId)
                                AND ObjectFloat_Contract_DayTaxSummary.DescId    = zc_ObjectFloat_Contract_DayTaxSummary()
                                AND ObjectFloat_Contract_DayTaxSummary.ValueData <> 0

           LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                ON ObjectLink_Contract_JuridicalBasis.ObjectId = COALESCE (MovementLinkObject_ContractTo.ObjectId, MovementLinkObject_Contract.ObjectId)
                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
           LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                         AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
           LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementLinkMovement.MovementChildId
                                                AND Movement_Master.StatusId <> zc_Enum_Status_Erased()
           LEFT JOIN MovementString AS MS_InvNumberPartner_Master
                                    ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement.MovementChildId
                                   AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
      WHERE Movement.Id = inMovementId;

      -- !!!замена!!!
      IF inStartDateTax IS NULL THEN inStartDateTax:= DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '4 MONTH'; END IF;


      -- если надо, находим существующий <Налоговый документ>
      IF COALESCE (vbMovementId_Tax, 0) = 0 AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
      THEN
           -- поиск по Юр.лицу + Договор + период
           vbMovementId_Tax:= (SELECT (Movement.Id)
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = vbContractId
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                                  ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                 AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                                    INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                                 AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject.ObjectId = vbToId
                               WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                 AND Movement.DescId = zc_Movement_Tax()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
      ELSE
      IF COALESCE (vbMovementId_Tax, 0) = 0 AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
      THEN
           -- поиск по Контрагенту + Договор + период
           vbMovementId_Tax:= (SELECT (Movement.Id)
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = vbContractId
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                                  ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                 AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                    INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                                 AND MovementLinkObject.DescId = zc_MovementLinkObject_Partner()
                                                                 AND MovementLinkObject.ObjectId = vbPartnerId
                               WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                 AND Movement.DescId = zc_Movement_Tax()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased());
      END IF;
      END IF;

      -- если надо, находим существующий <Налоговый документ-корректировку>
      IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
      THEN
           -- ВСЕ по Юр.лицу + Договор + период
           INSERT INTO _tmpMovementCorrective (MovementId, MovementId_Tax)
                                         SELECT (Movement.Id) AS MovementId
                                              , COALESCE (MovementLinkMovement.MovementChildId, 0) AS MovementId_Tax
                                         FROM Movement
                                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                           AND MovementLinkObject_Contract.ObjectId = vbContractId
                                              INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                                            ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                                           AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                           AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR())
                                              INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                                           AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                                                           AND MovementLinkObject.ObjectId = vbToId
                                              LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                                            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Child()
                                         WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                           AND Movement.DescId = zc_Movement_TaxCorrective()
                                           AND Movement.StatusId <> zc_Enum_Status_Erased();

      ELSE
      IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
      THEN
           -- ВСЕ по Контрагенту + Договор + период
           INSERT INTO _tmpMovementCorrective (MovementId, MovementId_Tax)
                                         SELECT (Movement.Id) AS MovementId
                                              , COALESCE (MovementLinkMovement.MovementChildId, 0) AS MovementId_Tax
                                         FROM Movement
                                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                           AND MovementLinkObject_Contract.ObjectId = vbContractId
                                              INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                                            ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                                           AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                           AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                              INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                                           AND MovementLinkObject.DescId = zc_MovementLinkObject_Partner()
                                                                           AND MovementLinkObject.ObjectId = vbPartnerId
                                              LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                                            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Child()
                                         WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                           AND Movement.DescId = zc_Movement_TaxCorrective()
                                           AND Movement.StatusId <> zc_Enum_Status_Erased();
      END IF;
      END IF;


      --
      IF COALESCE (inMovementId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
      END IF;
      --
      IF COALESCE (vbFromId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Не установлено значение <От кого>.';
      END IF;
      --
      IF COALESCE (vbToId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Не установлено значение <Кому>.';
      END IF;
      IF COALESCE (vbContractId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
      END IF;
      --
      IF COALESCE (vbPartnerId, 0) = 0 AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_Tax()) AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
      THEN
          RAISE EXCEPTION 'Ошибка.Не установлено значение <Контрагент>.';
      END IF;
      -- очень важная проверка
      IF vbMovementDescId IN (zc_Movement_Tax()) AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_Tax())
      THEN
          RAISE EXCEPTION 'Ошибка.Тип налогового документа <%> формируется только из накладной <Продажа покупателю>.', lfGet_Object_ValueData (inDocumentTaxKindId);
      END IF;
      -- очень важная проверка
      IF inDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
      THEN
          RAISE EXCEPTION 'Ошибка.Тип налогового документа <%> не допустим.', lfGet_Object_ValueData (inDocumentTaxKindId);
      END IF;

      IF vbPaidKindId = zc_Enum_PaidKind_SecondForm()
      THEN
          RAISE EXCEPTION 'Ошибка.Невозможно создать налоговый документ для формы оплаты <%>.', lfGet_Object_ValueData (vbPaidKindId);
      END IF;


      -- формируются данные "база" документов
      IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
      THEN
           -- данные из одной накладной <Продажа покупателю> или <Перевод долга (расход)>
           INSERT INTO _tmpMovement (MovementId, DescId, DocumentTaxKindId)
              SELECT Movement.Id, Movement.DescId, inDocumentTaxKindId FROM Movement WHERE Movement.Id = inMovementId;

      ELSE
      IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
      THEN
           -- данные по Юр.лицу + Договор из всех накладных - Juridical
           INSERT INTO _tmpMovement (MovementId, DescId, DocumentTaxKindId)
              WITH tmpContract_list AS (SELECT vbContractId AS ContractId
                                       UNION
                                        SELECT MovementItem.ObjectId AS ContractId
                                        FROM MovementItem 
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId     = zc_MI_Detail()
                                          AND MovementItem.isErased   = FALSE
                                       )
              -- данные <Продажа покупателю> и <Возврат от покупателя>
              SELECT Movement.Id
                   , Movement.DescId
                   , CASE WHEN Movement.DescId <> zc_Movement_ReturnIn()
                               THEN inDocumentTaxKindId
                          ELSE vbDocumentTaxKindId_TaxCorrective
                     END AS DocumentTaxKindId
              FROM MovementDate AS MovementDate_OperDatePartner
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              --AND MovementLinkObject_Contract.ObjectId = vbContractId
                   INNER JOIN tmpContract_list ON tmpContract_list.ContractId = MovementLinkObject_Contract.ObjectId
                   INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                 ON MovementLinkObject_PaidKind.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                AND MovementLinkObject_PaidKind.ObjectId = vbPaidKindId
                   INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                   INNER JOIN (SELECT zc_Movement_Sale() AS MovementDescId, zc_MovementLinkObject_To() AS MLODescId
                              UNION ALL
                               SELECT zc_Movement_ReturnIn() AS MovementDescId, zc_MovementLinkObject_From() AS MLODescId
                              ) AS tmpDesc ON tmpDesc.MovementDescId = Movement.DescId
                   INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject.DescId = tmpDesc.MLODescId
                   INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                        AND ObjectLink_Partner_Juridical.ChildObjectId = vbToId
              WHERE MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
             UNION ALL
              -- данные <Перевод долга (расход)> и <Перевод долга (приход)> - Juridical
              SELECT Movement.Id
                   , Movement.DescId
                   , CASE WHEN Movement.DescId <> zc_Movement_TransferDebtIn()
                               THEN inDocumentTaxKindId
                          ELSE vbDocumentTaxKindId_TaxCorrective
                     END AS DocumentTaxKindId
              FROM (SELECT zc_Movement_TransferDebtOut() AS MovementDescId, zc_MovementLinkObject_To() AS MLODescId, zc_MovementLinkObject_ContractTo() AS ContractDescId, zc_MovementLinkObject_PaidKindTo() AS PaidKindDescId
                   UNION ALL
                    SELECT zc_Movement_TransferDebtIn() AS MovementDescId, zc_MovementLinkObject_From() AS MLODescId, zc_MovementLinkObject_ContractFrom() AS ContractDescId, zc_MovementLinkObject_PaidKindFrom() AS PaidKindDescId
                   ) AS tmpDesc
                   INNER JOIN Movement ON Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                      AND Movement.DescId = tmpDesc.MovementDescId
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                AND MovementLinkObject_Contract.DescId = tmpDesc.ContractDescId
                                              --AND MovementLinkObject_Contract.ObjectId = vbContractId
                   INNER JOIN tmpContract_list ON tmpContract_list.ContractId = MovementLinkObject_Contract.ObjectId
                   INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                AND MovementLinkObject.DescId = tmpDesc.MLODescId
                                                AND MovementLinkObject.ObjectId = vbToId
                   INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                 ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                AND MovementLinkObject_PaidKind.DescId = tmpDesc.PaidKindDescId
                                                AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
              ;

          -- RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from _tmpMovement);

      ELSE
      IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
      THEN
           -- данные по Контрагенту + Договор из всех накладных - Partner
           INSERT INTO _tmpMovement (MovementId, DescId, DocumentTaxKindId)
              WITH tmpContract_list AS (SELECT vbContractId AS ContractId
                                       UNION
                                        SELECT MovementItem.ObjectId AS ContractId
                                        FROM MovementItem 
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId     = zc_MI_Detail()
                                          AND MovementItem.isErased   = FALSE
                                       )
              -- данные <Продажа покупателю> и <Возврат от покупателя>
              SELECT Movement.Id
                   , Movement.DescId
                   , CASE WHEN Movement.DescId <> zc_Movement_ReturnIn()
                               THEN inDocumentTaxKindId
                          ELSE vbDocumentTaxKindId_TaxCorrective
                     END AS DocumentTaxKindId
              FROM MovementDate AS MovementDate_OperDatePartner
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              --AND MovementLinkObject_Contract.ObjectId = vbContractId
                   INNER JOIN tmpContract_list ON tmpContract_list.ContractId = MovementLinkObject_Contract.ObjectId
                   INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                 ON MovementLinkObject_PaidKind.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                AND MovementLinkObject_PaidKind.ObjectId = vbPaidKindId
                   INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                   INNER JOIN (SELECT zc_Movement_Sale() AS MovementDescId, zc_MovementLinkObject_To() AS MLODescId
                              UNION ALL
                               SELECT zc_Movement_ReturnIn() AS MovementDescId, zc_MovementLinkObject_From() AS MLODescId
                              ) AS tmpDesc ON tmpDesc.MovementDescId = Movement.DescId
                   INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject.DescId = tmpDesc.MLODescId
                                                AND MovementLinkObject.ObjectId = vbPartnerId
              WHERE MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner();
      END IF;
      END IF;
      END IF;


      -- формируются данные для "база" строчной части
      WITH _tmpDesc_SaleReturn AS (SELECT zc_Movement_Sale() AS MovementDescId, zc_MovementLinkObject_To() AS MLODescId
                                  UNION ALL
                                   SELECT zc_Movement_ReturnIn() AS MovementDescId, zc_MovementLinkObject_From() AS MLODescId
                                  )
       , _tmpDesc_TransferDebt AS (SELECT zc_Movement_TransferDebtOut() AS MovementDescId, zc_MovementLinkObject_To() AS MLODescId, zc_MovementLinkObject_ContractTo() AS ContractDescId, zc_MovementLinkObject_PaidKindTo() AS PaidKindDescId
                                  UNION ALL
                                   SELECT zc_Movement_TransferDebtIn() AS MovementDescId, zc_MovementLinkObject_From() AS MLODescId, zc_MovementLinkObject_ContractFrom() AS ContractDescId, zc_MovementLinkObject_PaidKindFrom() AS PaidKindDescId
                                  )
       , tmpContract_list AS (SELECT vbContractId AS ContractId
                             UNION
                              SELECT MovementItem.ObjectId AS ContractId
                              FROM MovementItem 
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Detail()
                                AND MovementItem.isErased   = FALSE
                             )
        , _tmpMovement2 AS (SELECT Movement.Id AS MovementId, Movement.DescId, inDocumentTaxKindId AS DocumentTaxKindId
                                 , CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN Movement.Id END AS MovementId_Return
                            FROM Movement WHERE Movement.Id = inMovementId AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
                           UNION ALL
                            -- данные <Продажа покупателю> и <Возврат от покупателя> - Juridical
                            SELECT Movement.Id AS MovementId
                                 , Movement.DescId
                                 , CASE WHEN Movement.DescId <> zc_Movement_ReturnIn()
                                             THEN inDocumentTaxKindId
                                        ELSE vbDocumentTaxKindId_TaxCorrective
                                   END AS DocumentTaxKindId
                                , CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN Movement.Id END AS MovementId_Return
                            FROM MovementDate AS MovementDate_OperDatePartner
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = MovementDate_OperDatePartner.MovementId
                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                            --AND MovementLinkObject_Contract.ObjectId = vbContractId
                                 INNER JOIN tmpContract_list ON tmpContract_list.ContractId = MovementLinkObject_Contract.ObjectId

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                               ON MovementLinkObject_PaidKind.MovementId = MovementDate_OperDatePartner.MovementId
                                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                              AND MovementLinkObject_PaidKind.ObjectId = vbPaidKindId
                                 INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                 INNER JOIN _tmpDesc_SaleReturn AS tmpDesc ON tmpDesc.MovementDescId = Movement.DescId
                                 INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate_OperDatePartner.MovementId
                                                              AND MovementLinkObject.DescId = tmpDesc.MLODescId
                                 INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                      AND ObjectLink_Partner_Juridical.ChildObjectId = vbToId
                            WHERE MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                              AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                              AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                           UNION ALL
                            -- данные <Перевод долга (расход)> и <Перевод долга (приход)> - Juridical
                            SELECT Movement.Id
                                 , Movement.DescId
                                 , CASE WHEN Movement.DescId <> zc_Movement_TransferDebtIn()
                                             THEN inDocumentTaxKindId
                                        ELSE vbDocumentTaxKindId_TaxCorrective
                                   END AS DocumentTaxKindId
                                , CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN Movement.Id END AS MovementId_Return
                            FROM _tmpDesc_TransferDebt AS tmpDesc
                                 INNER JOIN Movement ON Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                                    AND Movement.DescId = tmpDesc.MovementDescId
                                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                                    AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                              AND MovementLinkObject_Contract.DescId = tmpDesc.ContractDescId
                                                            --AND MovementLinkObject_Contract.ObjectId = vbContractId
                                 INNER JOIN tmpContract_list ON tmpContract_list.ContractId = MovementLinkObject_Contract.ObjectId

                                 INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                              AND MovementLinkObject.DescId = tmpDesc.MLODescId
                                                              AND MovementLinkObject.ObjectId = vbToId
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                               ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                              AND MovementLinkObject_PaidKind.DescId = tmpDesc.PaidKindDescId
                                                              AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                           UNION ALL
                            -- данные <Продажа покупателю> и <Возврат от покупателя> - Partner
                            SELECT Movement.Id
                                 , Movement.DescId
                                 , CASE WHEN Movement.DescId <> zc_Movement_ReturnIn()
                                             THEN inDocumentTaxKindId
                                        ELSE vbDocumentTaxKindId_TaxCorrective
                                   END AS DocumentTaxKindId
                                , CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN Movement.Id END AS MovementId_Return
                            FROM MovementDate AS MovementDate_OperDatePartner
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = MovementDate_OperDatePartner.MovementId
                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                            --AND MovementLinkObject_Contract.ObjectId = vbContractId
                                 INNER JOIN tmpContract_list ON tmpContract_list.ContractId = MovementLinkObject_Contract.ObjectId

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                               ON MovementLinkObject_PaidKind.MovementId = MovementDate_OperDatePartner.MovementId
                                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                              AND MovementLinkObject_PaidKind.ObjectId = vbPaidKindId
                                 INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                 INNER JOIN _tmpDesc_SaleReturn AS tmpDesc ON tmpDesc.MovementDescId = Movement.DescId
                                 INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate_OperDatePartner.MovementId
                                                              AND MovementLinkObject.DescId = tmpDesc.MLODescId
                                                              AND MovementLinkObject.ObjectId = vbPartnerId
                            WHERE MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                              AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                              AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                          )
              /*         , _tmpMI_ReturnIn
                        AS (SELECT _tmpMovement.MovementId, _tmpMovement.DescId, _tmpMovement.DocumentTaxKindId
                            FROM _tmpMovement
                                        INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement.MovementId
                                                               AND MovementItem.DescId   = zc_MI_Child()
                                                               AND MovementItem.Amount   <> 0
                                                               AND MovementItem.isErased = FALSE
                                        INNER JOIN MovementItemFloat AS MIFloat_Price
                                                                     ON MIFloat_Price.MovementItemId = MovementItem.ParentId
                                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                    AND MIFloat_Price.ValueData <> 0
                                        LEFT JOIN MovementItem AS MovementItem_Master ON MovementItem_Master.Id = MovementItem.ParentId
                                                                                     AND MovementItem_Master.isErased = FALSE
                                        LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                    ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                        LEFT JOIN _tmpMovement2 AS _tmpMovement_find ON _tmpMovement_find.MovementId = MIFloat_MovementId.ValueData :: Integer
                                        LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = MIFloat_MovementId.ValueData :: Integer
                                                                      AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Master()
                                                                      AND _tmpMovement_find.MovementId IS NULL
                            WHERE _tmpMovement.DescId = zc_Movement_ReturnIn()
                           )*/
      -- Результат - строчная часть
      INSERT INTO _tmpMI (GoodsId, GoodsKindId, Price, CountForPrice, Amount_Tax, Amount_TaxCorrective, MovementId_Tax, MovementItemId_err)
         SELECT tmpMI.GoodsId
              , tmpMI.GoodsKindId
              , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                          -- так переводится в валюту zc_Enum_Currency_Basis
                          -- THEN CAST (tmpMI.Price * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                          -- перестали округлять
                          THEN tmpMI.Price * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                     ELSE tmpMI.Price
                END AS Price
              , tmpMI.CountForPrice
              , CASE WHEN tmpMI.Amount_Sale > 0 THEN tmpMI.Amount_Sale ELSE 0 END AS Amount_Tax
              , tmpMI.Amount_ReturnIn + CASE WHEN tmpMI.Amount_Sale < 0 THEN -1 * tmpMI.Amount_Sale ELSE 0 END AS Amount_TaxCorrective
              , tmpMI.MovementId_Tax
              , tmpMI.MovementItemId_err
         FROM (SELECT tmpMI_all.GoodsId
                    , tmpMI_all.GoodsKindId
                    , tmpMI_all.Price
                    , tmpMI_all.CountForPrice
                    , CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN tmpMI_all.Amount_Sale - tmpMI_all.Amount_ReturnIn ELSE tmpMI_all.Amount_Sale END AS Amount_Sale
                    , CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN 0 ELSE tmpMI_all.Amount_ReturnIn END AS Amount_ReturnIn
                    , tmpMI_all.MovementId_Tax
                    , tmpMI_all.MovementItemId_err
               FROM (SELECT CASE WHEN _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
                                      THEN CASE WHEN _tmpMovement_find.MovementId > 0
                                                     THEN vbMovementId_Tax
                                                ELSE COALESCE (MovementLinkMovement.MovementChildId, 0)
                                           END
                                 ELSE vbMovementId_Tax
                            END AS MovementId_Tax
                          , MAX (CASE WHEN _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
                                           THEN CASE WHEN COALESCE (_tmpMovement_find.MovementId, 0) = 0 AND COALESCE (MovementLinkMovement.MovementChildId, 0) = 0
                                                          THEN MovementItem.Id
                                                     ELSE 0
                                                END
                                      ELSE 0
                                 END) AS MovementItemId_err
                          , MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                      -- в налоговых цены всегда будут без НДС
                                      THEN CAST (CASE WHEN MIFloat_ChangePercent.ValueData       <> 0 AND _tmpMovement.DescId     IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                           THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                      inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                    , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                                     )
                                                      WHEN MovementFloat_ChangePercent.ValueData <> 0 AND _tmpMovement.DescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                           THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                      inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                    , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                                     )
                                                      ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                                 END
                                         / (1 + vbVATPercent / 100) AS NUMERIC (16, 4))
                                 ELSE CASE WHEN MIFloat_ChangePercent.ValueData       <> 0 AND _tmpMovement.DescId     IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                           inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                         , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                         , inPrice        := MIFloat_Price.ValueData
                                                                         , inIsWithVAT    := vbPriceWithVAT
                                                                          )
                                           WHEN MovementFloat_ChangePercent.ValueData <> 0 AND _tmpMovement.DescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                           inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                         , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                                         , inPrice        := MIFloat_Price.ValueData
                                                                         , inIsWithVAT    := vbPriceWithVAT
                                                                          )
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END
                            END AS Price
                          , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE COALESCE (MIFloat_CountForPrice.ValueData, 0) END AS CountForPrice
                          , SUM (CASE WHEN _tmpMovement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) WHEN _tmpMovement.DescId = zc_Movement_TransferDebtOut() THEN MovementItem.Amount ELSE 0 END) AS Amount_Sale
                          , SUM (CASE WHEN _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn()) THEN COALESCE (MovementItem_Child.Amount, 0) /*COALESCE (MIFloat_AmountPartner.ValueData, 0)*/ WHEN _tmpMovement.DescId = zc_Movement_TransferDebtIn() THEN MovementItem.Amount ELSE 0 END) AS Amount_ReturnIn
                     FROM _tmpMovement2 AS _tmpMovement
                          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement.MovementId
                                                 AND MovementItem.DescId   = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE
                          INNER JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                      AND MIFloat_Price.ValueData <> 0
                          LEFT JOIN MovementItem AS MovementItem_Child ON MovementItem_Child.MovementId = _tmpMovement.MovementId_return
                                                                      AND MovementItem_Child.isErased = FALSE
                                                                      AND MovementItem_Child.DescId   = CASE WHEN _tmpMovement.MovementId_return > 0 THEN zc_MI_Child()  END
                                                                      AND MovementItem_Child.ParentId = CASE WHEN _tmpMovement.MovementId_return > 0 THEN MovementItem.Id END
                                                                      AND MovementItem_Child.Amount   <> 0
                                                                      -- AND _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
                          LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = MovementItem_Child.Id
                                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                          LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                      ON MIFloat_MovementItemId.MovementItemId = MovementItem_Child.Id
                                                     AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                          LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id       = MIFloat_MovementId.ValueData :: Integer
                                                             AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                          LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.MovementId = Movement_Sale.Id
                                                           AND MI_Sale.DescId     = zc_MI_Master()
                                                           AND MI_Sale.Id         = MIFloat_MovementItemId.ValueData :: Integer
                                                           AND MI_Sale.isErased   = FALSE
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner_Sale
                                                      ON MIFloat_AmountPartner_Sale.MovementItemId = MI_Sale.Id
                                                     AND MIFloat_AmountPartner_Sale.DescId         = zc_MIFloat_AmountPartner()

                          LEFT JOIN _tmpMovement2 AS _tmpMovement_find ON _tmpMovement_find.MovementId = -- MIFloat_MovementId.ValueData :: Integer
                                                                                                         CASE WHEN Movement_Sale.DescId = zc_Movement_Sale()
                                                                                                               AND COALESCE (MIFloat_AmountPartner_Sale.ValueData, 0) < COALESCE (MovementItem_Child.Amount, 0)
                                                                                                                   -- !!!будет error!!!
                                                                                                                   THEN NULL
                                                                                                              WHEN COALESCE (MIFloat_AmountPartner_Sale.ValueData, MI_Sale.Amount) < COALESCE (MovementItem_Child.Amount, 0)
                                                                                                                   -- !!!тоже будет error!!!
                                                                                                                   THEN NULL
                                                                                                              ELSE MI_Sale.MovementId
                                                                                                         END
                          LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = -- MIFloat_MovementId.ValueData :: Integer
                                                                                              CASE WHEN Movement_Sale.DescId = zc_Movement_Sale()
                                                                                                    AND COALESCE (MIFloat_AmountPartner_Sale.ValueData, 0) < COALESCE (MovementItem_Child.Amount, 0)
                                                                                                        -- !!!будет error!!!
                                                                                                        THEN NULL
                                                                                                   WHEN COALESCE (MIFloat_AmountPartner_Sale.ValueData, MI_Sale.Amount) < COALESCE (MovementItem_Child.Amount, 0)
                                                                                                        -- !!!тоже будет error!!!
                                                                                                        THEN NULL
                                                                                                   ELSE MI_Sale.MovementId
                                                                                              END
                                                        AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Master()
                                                        AND _tmpMovement_find.MovementId IS NULL

                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                  ON MovementFloat_ChangePercent.MovementId = _tmpMovement.MovementId
                                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                                 AND _tmpMovement.DescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                                     AND _tmpMovement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())

                          LEFT JOIN Movement AS Movement_Tax_find ON Movement_Tax_find.Id
                            = CASE WHEN _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
                                        THEN CASE WHEN _tmpMovement_find.MovementId > 0
                                                       THEN NULL -- vbMovementId_Tax
                                                  ELSE COALESCE (MovementLinkMovement.MovementChildId, 0)
                                             END
                                   ELSE NULL -- vbMovementId_Tax
                              END

                     GROUP BY CASE WHEN _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
                                        THEN CASE WHEN _tmpMovement_find.MovementId > 0
                                                       THEN vbMovementId_Tax
                                                  ELSE COALESCE (MovementLinkMovement.MovementChildId, 0)
                                             END
                                   ELSE vbMovementId_Tax
                              END
                            , MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                            , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                                   THEN
                                        -- в налоговых цены всегда будут без НДС
                                        CAST (CASE WHEN MIFloat_ChangePercent.ValueData       <> 0 AND _tmpMovement.DescId     IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                           THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                      inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                    , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                                     )
                                                      WHEN MovementFloat_ChangePercent.ValueData <> 0 AND _tmpMovement.DescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                           THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                                      inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                                    , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                                     )
                                                      ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                              END
                                         / (1 + vbVATPercent / 100) AS NUMERIC (16, 4))
                                 ELSE CASE WHEN MIFloat_ChangePercent.ValueData       <> 0 AND _tmpMovement.DescId     IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                           inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                         , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                         , inPrice        := MIFloat_Price.ValueData
                                                                         , inIsWithVAT    := vbPriceWithVAT
                                                                          )
                                           WHEN MovementFloat_ChangePercent.ValueData <> 0 AND _tmpMovement.DescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                THEN zfCalc_PriceTruncate (-- !!!дата налоговой!!!
                                                                           inOperDate     := COALESCE (Movement_Tax_find.OperDate, vbOperDate)
                                                                         , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                                         , inPrice        := MIFloat_Price.ValueData
                                                                         , inIsWithVAT    := vbPriceWithVAT
                                                                          )
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END
                              END
                            , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE COALESCE (MIFloat_CountForPrice.ValueData, 0) END
                    ) AS tmpMI_all
               WHERE tmpMI_all.Amount_Sale <> 0 OR tmpMI_all.Amount_ReturnIn <> 0
              ) AS tmpMI
         WHERE tmpMI.Amount_Sale <> 0 OR tmpMI.Amount_ReturnIn <> 0
        ;


/*
if inUserId = 5
then
    RAISE EXCEPTION '<%>  %  %   %  %  %', (select count(*) from _tmpMI), (select count(*) from _tmpMI where coalesce (MovementId_Tax, 0) = 0 )
, (select count(*) from _tmpMI where Amount_TaxCorrective < 0 )
, (select count(*) from _tmpMI where Amount_TaxCorrective > 0 and MovementId_Tax <> 0)
, (select min (MovementId_Tax) from _tmpMI where Amount_TaxCorrective > 0 and MovementId_Tax <> 0)
, (select max (MovementId_Tax) from _tmpMI where Amount_TaxCorrective > 0 and MovementId_Tax <> 0)
;

    -- 'Повторите действие через 3 мин.'
end if;
*/

      -- 3. удаляем все "лишние" налоговые у "базы"
      PERFORM lpSetErased_Movement (inMovementId:= MovementLinkMovement.MovementChildId
                                  , inUserId    := inUserId)
      FROM _tmpMovement
           INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = _tmpMovement.MovementId
                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                                          AND MovementLinkMovement.MovementChildId <> COALESCE (vbMovementId_Tax, 0)
           INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                              AND Movement.StatusId <> zc_Enum_Status_Erased()
      WHERE _tmpMovement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut());


      -- удаляем для НЕ "база" связь с Налоговым документом
      PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), MovementLinkMovement.MovementId, 0)
      FROM MovementLinkMovement
           LEFT JOIN _tmpMovement ON _tmpMovement.MovementId = MovementLinkMovement.MovementId
      WHERE MovementLinkMovement.MovementChildId = vbMovementId_Tax
        AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
        AND _tmpMovement.MovementId IS NULL;


      -- 4. распроводим налоговую
      PERFORM lpUnComplete_Movement (inMovementId:= tmp.MovementId
                                   , inUserId    := inUserId)
      FROM (-- Одна налоговая
            SELECT vbMovementId_Tax AS MovementId WHERE vbMovementId_Tax <> 0
           ) AS tmp;


      -- 5. сохранили Налоговую (всегда, даже если inMovementId - это она)
      SELECT tmp.ioId INTO vbMovementId_Tax
      FROM lpInsertUpdate_Movement_Tax (ioId               := vbMovementId_Tax
                                      , ioInvNumber        := vbInvNumber_Tax
                                      , ioInvNumberPartner := vbInvNumberPartner_Tax
                                      , inInvNumberBranch  := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberBranch()), '')
                                      , inOperDate         := vbOperDate
                                      , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementBoolean_Checked()), FALSE)
                                      , inDocument         := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementBoolean_Document()), FALSE)
                                      , inPriceWithVAT     := FALSE -- в налоговых цены всегда будут без НДС -- vbPriceWithVAT
                                      , inVATPercent       := vbVATPercent
                                      , inFromId           := vbFromId
                                      , inToId             := vbToId
                                      , inPartnerId        := CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN vbPartnerId ELSE NULL END
                                      , inContractId       := vbContractId
                                      , inDocumentTaxKindId:= inDocumentTaxKindId
                                      , inUserId           := inUserId
                                       ) AS tmp;


      -- 6. сохранили для "база" связь с Налоговым документом
      PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), _tmpMovement.MovementId, vbMovementId_Tax)
      FROM _tmpMovement
      WHERE _tmpMovement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut());

      -- если есть
      IF inDocumentTaxKindId= zc_Enum_DocumentTaxKind_Tax() AND vbMovementId_Sale <> 0 AND EXISTS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = vbMovementId_Sale AND DescId = zc_MovementLinkMovement_Sale() AND MovementChildId <> 0)
      THEN
          -- сформировали связь у налоговой накл. с EDI (такую же как и у расходной накл.)
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Tax(), vbMovementId_Tax, (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = vbMovementId_Sale AND DescId = zc_MovementLinkMovement_Sale()));
      END IF;

      -- 7. удаляем !!!все!!! строки из Налоговой
      PERFORM gpMovementItem_Tax_SetErased (inMovementItemId := tmpMI_Tax.MovementItemId
                                          , inSession := lfGet_User_Session (inUserId))
      FROM
           (SELECT MovementItem.Id         AS MovementItemId
                 , MovementItem.ObjectId   AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , COALESCE (MIFloat_Price.ValueData, 0) AS Price
            FROM MovementItem
                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            WHERE MovementItem.MovementId = vbMovementId_Tax
              AND MovementItem.DescId     <> zc_MI_Detail()
              AND MovementItem.isErased = FALSE
           ) AS tmpMI_Tax
          ;


      -- 8. сохранили строчную часть заново у Налоговой
      PERFORM lpInsertUpdate_MovementItem_Tax (ioId           := 0 -- tmpMI_Tax.MovementItemId
                                             , inMovementId   := vbMovementId_Tax
                                             , inGoodsId      := _tmpMI.GoodsId
                                             , inAmount       := _tmpMI.Amount_Tax
                                             , inPrice        := _tmpMI.Price
                                             , ioCountForPrice:= _tmpMI.CountForPrice
                                             , inGoodsKindId  := _tmpMI.GoodsKindId
                                             , inUserId       := inUserId)
      FROM _tmpMI
      WHERE _tmpMI.Amount_Tax <> 0;

     -- 9. ФИНИШ - 1 - Проводим Налоговую
     PERFORM lpComplete_Movement_Tax (inMovementId := vbMovementId_Tax
                                    , inUserId     := inUserId);


      -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


      -- !!!ТОЛЬКО для сводных корректировок - НЕ сложнейший алгоритм!!!
      IF 1 = 1 AND vbDocumentTaxKindId_TaxCorrective <> 0
      THEN
          -- !!! получилось !!!
          INSERT INTO _tmpMICorrective (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, Price, CountForPrice)
             SELECT 0, _tmpMI.MovementId_Tax, _tmpMI.GoodsId, _tmpMI.GoodsKindId, _tmpMI.Amount_TaxCorrective, _tmpMI.Price, _tmpMI.CountForPrice
             FROM _tmpMI
             WHERE _tmpMI.Amount_TaxCorrective <> 0;
      ELSE
      -- !!!ТОЛЬКО для сводных корректировок - сложнейший алгоритм!!!
      IF 1 = 0 AND vbDocumentTaxKindId_TaxCorrective <> 0
      THEN
          -- курсор1 - возвраты
          OPEN curMI_ReturnIn FOR
               SELECT GoodsId, GoodsKindId, Amount_TaxCorrective AS Amount, Price AS OperPrice FROM _tmpMI WHERE Amount_TaxCorrective <> 0;
          -- начало цикла по курсору1 - возвраты
          LOOP
              -- данные по возвратам
              FETCH curMI_ReturnIn INTO vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice;
              -- если данные закончились, тогда выход
              IF NOT FOUND THEN EXIT; END IF;


           --
           DELETE FROM _tmp1_SubQuery;
           DELETE FROM _tmp2_SubQuery;

          IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
          THEN
              -- по Юр Лицу
              -- данные для курсор2 - <Налоговые> отдельно !!!для оптимизации!!!
              INSERT INTO _tmp1_SubQuery (MovementId, OperDate, isRegistered, Amount)
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementLinkObject AS MLO_To
                              INNER JOIN Movement ON Movement.Id = MLO_To.MovementId
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.OperDate BETWEEN inStartDateTax /*vbOperDate - INTERVAL '4 MONTH'*/ AND vbOperDate - INTERVAL '0 DAY' -- !!!обязательно 0 DAY, что б попала текущая сводная <Налоговая>!!!
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND MovementLinkObject_Contract.ObjectId = vbContractId
                              -- т.е. ТОЛЬКО "сводные..." ... ?или надо все?
                              /*INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                            ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                           AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())*/
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.ObjectId = vbGoodsId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount <> 0
                              INNER JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.ValueData = vbOperPrice
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementBoolean AS MB_Registered
                                                        ON MB_Registered.MovementId = Movement.Id
                                                       AND MB_Registered.DescId = zc_MovementBoolean_Registered()
                         WHERE MLO_To.ObjectId = vbToId
                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                         GROUP BY Movement.Id
                                , Movement.OperDate
                                , MB_Registered.ValueData;
          ELSE
              -- по Контрагенту
              -- данные для курсор2 - <Налоговые> отдельно !!!для оптимизации!!!
              INSERT INTO _tmp1_SubQuery (MovementId, OperDate, isRegistered, Amount)
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementLinkObject AS MLO_To
                              INNER JOIN Movement ON Movement.Id = MLO_To.MovementId
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.OperDate BETWEEN inStartDateTax /*vbOperDate - INTERVAL '4 MONTH'*/ AND vbOperDate - INTERVAL '0 DAY' -- !!!обязательно 0 DAY, что б попала текущая сводная <Налоговая>!!!
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND MovementLinkObject_Contract.ObjectId = vbContractId
                              -- т.е. ТОЛЬКО "сводные..." ... ?или надо все?
                              /*INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                            ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                           AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())*/
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.ObjectId = vbGoodsId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount <> 0
                              INNER JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.ValueData = vbOperPrice
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementBoolean AS MB_Registered
                                                        ON MB_Registered.MovementId = Movement.Id
                                                       AND MB_Registered.DescId = zc_MovementBoolean_Registered()
                         WHERE MLO_To.ObjectId = vbPartnerId
                           AND MLO_To.DescId = zc_MovementLinkObject_Partner()
                         GROUP BY Movement.Id
                                , Movement.OperDate
                                , MB_Registered.ValueData;
          END IF;

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
                 , tmpMovement AS (SELECT tmpMovement2.Id
                                        , SUM (tmpMovement2.Amount) AS Amount
                                   FROM tmpMovement2
                                   WHERE tmpMovement2.Price = vbOperPrice
                                   GROUP BY tmpMovement2.Id)
              -- Результат - !!!без "текущих" корректировок!!!
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
                  FETCH curMI_Tax INTO vbMovementId_Tax_find, vbAmount_Tax_find;
                  -- если данные закончились, или все кол-во найдено тогда выход
                  IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

                  --
                  IF vbAmount_Tax_find > vbAmount
                  THEN
                      -- получилось в налоговой больше чем искали, !!!сохраняем в табл-результата!!!
                      INSERT INTO _tmpMICorrective (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, Price, CountForPrice)
                         SELECT 0, vbMovementId_Tax_find, vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice, 1 AS CountForPrice;
                      -- обнуляем кол-во что бы больше не искать
                      vbAmount:= 0;
                  ELSE
                      -- получилось в налоговой меньше чем искали, !!!сохраняем в табл-результата!!!
                      INSERT INTO _tmpMICorrective (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, Price, CountForPrice)
                         SELECT 0, vbMovementId_Tax_find, vbGoodsId, vbGoodsKindId, vbAmount_Tax_find, vbOperPrice, 1 AS CountForPrice;
                      -- уменьшаем на кол-во которое нашли и продолжаем поиск
                      vbAmount:= vbAmount - vbAmount_Tax_find;
                  END IF;

              END LOOP; -- финиш цикла по курсору2 - налоговые
              CLOSE curMI_Tax; -- закрыли курсор2 - налоговые

              -- если что-то осталось - в "пустую" <Налоговую>
              IF vbAmount > 0
              THEN
                  INSERT INTO _tmpMICorrective (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, Price, CountForPrice)
                     SELECT 0, 0, vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice, 1 AS CountForPrice;
              END IF;

         END LOOP; -- финиш цикла по курсору1 - возвраты
         CLOSE curMI_ReturnIn; -- закрыли курсор1 - возвраты

         -- осталось для привязки - найти существующие корректировки !!!"по налоговой"!!!
         UPDATE _tmpMICorrective SET MovementId_Corrective = _tmpMovementCorrective.MovementId
         FROM _tmpMovementCorrective
         WHERE _tmpMICorrective.MovementId_Tax = _tmpMovementCorrective.MovementId_Tax;

         -- проверка - "итоги" для корректировки из _tmpMI = сумме в привязках из _tmpMICorrective
         IF EXISTS (SELECT 1
                    FROM (SELECT _tmpMI.GoodsId, _tmpMI.GoodsKindId, _tmpMI.Price, SUM (_tmpMI.Amount_TaxCorrective) AS Amount FROM _tmpMI GROUP BY _tmpMI.GoodsId, _tmpMI.GoodsKindId, _tmpMI.Price
                          ) AS tmpFrom
                         FULL JOIN (SELECT _tmpMICorrective.GoodsId, _tmpMICorrective.GoodsKindId, _tmpMICorrective.Price, SUM (_tmpMICorrective.Amount) AS Amount FROM _tmpMICorrective GROUP BY _tmpMICorrective.GoodsId, _tmpMICorrective.GoodsKindId, _tmpMICorrective.Price
                                   ) AS tmpTo ON tmpFrom.GoodsId     = tmpTo.GoodsId
                                             AND tmpFrom.GoodsKindId = tmpTo.GoodsKindId
                                             AND tmpFrom.Price       = tmpTo.Price
                    WHERE COALESCE (tmpFrom.Amount, 0) <> COALESCE (tmpTo.Amount, 0)
                   )
         THEN
             RAISE EXCEPTION 'Ошибка."итоги" для корректировки из _tmpMI <> сумме в привязках из _tmpMICorrective.';
         END IF;

         -- проверка - у одной <Корректировки> - ОДНА <Налоговая> + НАОБОРОТ
         IF EXISTS (SELECT 1
                    FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                         ) AS tmp
                    WHERE tmp.MovementId_Corrective <> 0
                    GROUP BY tmp.MovementId_Corrective
                    HAVING COUNT(*) > 1
                   )
         OR EXISTS (SELECT 2
                    FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                         ) AS tmp
                    GROUP BY tmp.MovementId_Tax
                    HAVING COUNT(*) > 1
                   )
         THEN
             RAISE EXCEPTION 'Ошибка.у одной <Корректировки> НЕ ОДНА <Налоговая>. <%> + <%> + <%>   -   <%> + <%> + <%>'
                                                                                  , (-- 1.1.
                                                                                     SELECT tmp.MovementId_Corrective
                                                                                     FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                                                                                          ) AS tmp
                                                                                     WHERE tmp.MovementId_Corrective <> 0
                                                                                     GROUP BY tmp.MovementId_Corrective
                                                                                     HAVING COUNT(*) > 1
                                                                                     ORDER BY tmp.MovementId_Corrective
                                                                                     LIMIT 1
                                                                                    )
                                                                                  , (-- 1.2.
                                                                                     SELECT MIN (tmp.MovementId_Tax)
                                                                                     FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                                                                                          ) AS tmp
                                                                                     WHERE tmp.MovementId_Corrective <> 0
                                                                                     GROUP BY tmp.MovementId_Corrective
                                                                                     HAVING COUNT(*) > 1
                                                                                     ORDER BY tmp.MovementId_Corrective
                                                                                     LIMIT 1
                                                                                    )
                                                                                  , (-- 1.3.
                                                                                     SELECT MAX (tmp.MovementId_Tax)
                                                                                     FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                                                                                          ) AS tmp
                                                                                     WHERE tmp.MovementId_Corrective <> 0
                                                                                     GROUP BY tmp.MovementId_Corrective
                                                                                     HAVING COUNT(*) > 1
                                                                                     ORDER BY tmp.MovementId_Corrective
                                                                                     LIMIT 1
                                                                                    )

                                                                                  , (-- 2.1.
                                                                                     SELECT tmp.MovementId_Tax
                                                                                     FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                                                                                          ) AS tmp
                                                                                     GROUP BY tmp.MovementId_Tax
                                                                                     HAVING COUNT(*) > 1
                                                                                     ORDER BY tmp.MovementId_Tax
                                                                                     LIMIT 1
                                                                                    )
                                                                                  , (-- 2.2.
                                                                                     SELECT MIN (tmp.MovementId_Corrective)
                                                                                     FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                                                                                          ) AS tmp
                                                                                     GROUP BY tmp.MovementId_Tax
                                                                                     HAVING COUNT(*) > 1
                                                                                     ORDER BY tmp.MovementId_Tax
                                                                                     LIMIT 1
                                                                                    )
                                                                                  , (-- 2.3.
                                                                                     SELECT MAX (tmp.MovementId_Corrective)
                                                                                     FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
                                                                                          ) AS tmp
                                                                                     GROUP BY tmp.MovementId_Tax
                                                                                     HAVING COUNT(*) > 1
                                                                                     ORDER BY tmp.MovementId_Tax
                                                                                     LIMIT 1
                                                                                    )
            ;
         END IF;

         RAISE EXCEPTION '!!!ТОЛЬКО для сводных корректировок - сложнейший алгоритм!!!';

      END IF; -- !!!ТОЛЬКО для сводных корректировок - сложнейший алгоритм!!! - завершили привязку к налоговым или не привязку (т.е. все данные в табл-результат)
      END IF; -- !!!ТОЛЬКО для сводных корректировок - НЕ сложнейший алгоритм!!!


      -- 3. удаляем все "лишние" корректировки у "базы" + "сводные"
      PERFORM lpSetErased_Movement_TaxCorrective (inMovementId:= tmp.MovementId
                                                , inUserId    := inUserId)
      FROM (-- по идее здесь только zc_Enum_DocumentTaxKind_Corrective
            SELECT MovementLinkMovement.MovementId
            FROM _tmpMovement
                 INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId = _tmpMovement.MovementId
                                                AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                                                -- AND MovementLinkMovement.MovementId <> COALESCE (vbMovementId_TaxCorrective, 0)
                 INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId
                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                 LEFT JOIN _tmpMICorrective ON _tmpMICorrective.MovementId_Corrective = MovementLinkMovement.MovementId
            WHERE _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
              AND _tmpMICorrective.MovementId_Corrective IS NULL
           UNION
            -- по идее здесь только "сводные"
            SELECT _tmpMovementCorrective.MovementId
            FROM _tmpMovementCorrective
                 LEFT JOIN _tmpMICorrective ON _tmpMICorrective.MovementId_Corrective = _tmpMovementCorrective.MovementId
            WHERE _tmpMICorrective.MovementId_Corrective IS NULL
           ) AS tmp;

      -- 4. распроводим корректировку
      PERFORM lpUnComplete_Movement (inMovementId:= tmp.MovementId
                                   , inUserId    := inUserId)
      FROM (-- Много корректировок
            SELECT DISTINCT _tmpMICorrective.MovementId_Corrective AS MovementId FROM _tmpMICorrective WHERE _tmpMICorrective.MovementId_Corrective <> 0
           ) AS tmp;

      -- 5. сохранили корректировку (почти всегда)
      IF EXISTS (SELECT Amount_TaxCorrective FROM _tmpMI WHERE Amount_TaxCorrective <> 0)
      THEN
         -- сохранили/изменили документы
         INSERT INTO _tmpMovementCorrective_new (MovementId, MovementId_Tax)
         SELECT lpInsertUpdate_Movement_TaxCorrective (ioId               := tmp.MovementId_Corrective
                                                     , inInvNumber        := COALESCE ((SELECT InvNumber FROM Movement WHERE Id = tmp.MovementId_Corrective), '')
                                                     , inInvNumberPartner := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmp.MovementId_Corrective AND DescId = zc_MovementString_InvNumberPartner()), '')
                                                     , inInvNumberBranch  := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmp.MovementId_Corrective AND DescId = zc_MovementString_InvNumberBranch()), '')
                                                     , inOperDate         := vbOperDate
                                                     , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmp.MovementId_Corrective AND DescId = zc_MovementBoolean_Checked()), FALSE)
                                                     , inDocument         := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmp.MovementId_Corrective AND DescId = zc_MovementBoolean_Document()), FALSE)
                                                     , inPriceWithVAT     := FALSE -- в корректировках цены всегда будут без НДС -- vbPriceWithVAT
                                                     , inVATPercent       := vbVATPercent
                                                     , inFromId           := vbToId
                                                     , inToId             := vbFromId
                                                     , inPartnerId        := CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN vbPartnerId ELSE NULL END
                                                     , inContractId       := vbContractId
                                                     , inDocumentTaxKindId:= vbDocumentTaxKindId_TaxCorrective
                                                     , inUserId           := inUserId
                                                      ) AS MovementId
              , tmp.MovementId_Tax
         FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective
              ) AS tmp;

         -- перенесли в строчную часть
         UPDATE _tmpMICorrective SET MovementId_Corrective = _tmpMovementCorrective_new.MovementId
         FROM _tmpMovementCorrective_new
         WHERE _tmpMICorrective.MovementId_Tax        = _tmpMovementCorrective_new.MovementId_Tax
           AND _tmpMICorrective.MovementId_Corrective = 0;

         -- сохранили привязку - !!!ради чего все это делалось!!!
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), tmp.MovementId_Corrective, tmp.MovementId_Tax)
         FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective, _tmpMICorrective.MovementId_Tax FROM _tmpMICorrective) AS tmp;

      END IF;

      -- 6. сохранили для "база" связь с <Тип формирования налогового документа> !!!только для корректировок!!!
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), _tmpMovement.MovementId, _tmpMovement.DocumentTaxKindId)
      FROM _tmpMovement
      WHERE _tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn());

      -- 7. удаляем !!!все!!! строки из Корректировки
      PERFORM gpMovementItem_TaxCorrective_SetErased (inMovementItemId:= tmp.MovementItemId
                                                    , inSession       := lfGet_User_Session (inUserId))
      FROM (SELECT MovementItem.Id         AS MovementItemId
            FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective AS MovementId FROM _tmpMICorrective) AS tmp
                 INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                        AND MovementItem.isErased = FALSE
           ) AS tmp
     ;

      -- 8. сохранили строчную часть заново у Корректировки
      PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId           := 0 -- tmpMI_TaxCorrective.MovementItemId
                                                       , inMovementId   := _tmpMI.MovementId_Corrective
                                                       , inGoodsId      := _tmpMI.GoodsId
                                                       , inAmount       := _tmpMI.Amount
                                                       , inPrice        := _tmpMI.Price
                                                       , inPriceTax_calc:= 0
                                                       , ioCountForPrice:= _tmpMI.CountForPrice
                                                       , inGoodsKindId  := _tmpMI.GoodsKindId
                                                       , inUserId       := inUserId)
      FROM _tmpMICorrective AS _tmpMI
     ;

     -- 9. ФИНИШ - 2 - Проводим Корректировку
     IF vbDocumentTaxKindId_TaxCorrective <> 0
     THEN
         --
         INSERT INTO _tmpRes (MessageText)
            SELECT lpComplete_Movement_TaxCorrective (inMovementId := tmp.MovementId
                                                    , inUserId     := inUserId)
            FROM (SELECT DISTINCT _tmpMICorrective.MovementId_Corrective AS MovementId FROM _tmpMICorrective) AS tmp;
         --
         outMessageText:= COALESCE ((SELECT _tmpRes.MessageText FROM _tmpRes WHERE _tmpRes.MessageText <> '' LIMIT 1), '')
                       || CASE WHEN EXISTS (SELECT 1 FROM _tmpMI WHERE _tmpMI.Amount_TaxCorrective <> 0 AND _tmpMI.MovementItemId_err <> 0)
                                    THEN CHR (13) || 'Возврат № <' || COALESCE ((SELECT Movement.InvNumber FROM _tmpMI INNER JOIN MovementItem AS MI ON MI.Id = _tmpMI.MovementItemId_err INNER JOIN Movement ON Movement.Id = MI.MovementId WHERE _tmpMI.Amount_TaxCorrective <> 0 AND _tmpMI.MovementItemId_err <> 0 ORDER BY _tmpMI.MovementItemId_err LIMIT 1), '') || '>'
                                                  || ' от <' || COALESCE ((SELECT DATE (Movement.OperDate) :: TVarChar FROM _tmpMI INNER JOIN MovementItem AS MI ON MI.Id = _tmpMI.MovementItemId_err INNER JOIN Movement ON Movement.Id = MI.MovementId WHERE _tmpMI.Amount_TaxCorrective <> 0 AND _tmpMI.MovementItemId_err <> 0 ORDER BY _tmpMI.MovementItemId_err LIMIT 1), '') || '>'
                                                  || ' для товара <' || lfGet_Object_ValueData ((SELECT _tmpMI.GoodsId FROM _tmpMI WHERE _tmpMI.Amount_TaxCorrective <> 0 AND _tmpMI.MovementItemId_err <> 0 ORDER BY _tmpMI.MovementItemId_err LIMIT 1)) || '>'
                                                  || ' + <' || lfGet_Object_ValueData ((SELECT _tmpMI.GoodsKindId FROM _tmpMI WHERE _tmpMI.Amount_TaxCorrective <> 0 AND _tmpMI.MovementItemId_err <> 0 ORDER BY _tmpMI.MovementItemId_err LIMIT 1)) || '>'
                                                  || ' не привязан к налоговой .'
                               ELSE ''
                          END;
/*
if inUserId = 5
then
    RAISE EXCEPTION '<%>', outMessageText;
    -- 'Повторите действие через 3 мин.'
end if;
*/
     END IF;


     -- результат
     SELECT MS_InvNumberPartner_Master.ValueData
          , MovementLinkObject_DocumentTaxKind.ObjectId
          , Object_TaxKind.ValueData
            INTO outInvNumberPartner_Master, outDocumentTaxKindId, outDocumentTaxKindName
     FROM MovementLinkMovement AS MovementLinkMovement_Master
          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                       ON MovementLinkObject_DocumentTaxKind.MovementId = MovementLinkMovement_Master.MovementChildId
                                      AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN MovementString AS MS_InvNumberPartner_Master
                                   ON MS_InvNumberPartner_Master.MovementId = MovementLinkObject_DocumentTaxKind.MovementId
                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId
     WHERE MovementLinkMovement_Master.MovementChildId = vbMovementId_Tax
       AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master();

-- RAISE EXCEPTION 'ok.';


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION lpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.05.16         * add
 09.07.14                                        * add zc_Movement_TransferDebtIn
 03.06.14                                        * add в налоговых цены всегда будут без НДС + в корректировках цены всегда будут без НДС
 16.05.14                                        * set lp
 10.05.14                                        * add lpComplete_Movement_Tax and lpComplete_Movement_TaxCorrective
 10.05.14                                        * add удаляем !!!все!!! + сохранили строчную часть заново
 10.05.14                                        * add CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE COALESCE (MIFloat_CountForPrice.ValueData, 0) END
 08.05.14                                        * add zc_MovementFloat_ChangePercent
 03.05.14                                        * all
 10.04.14                                        * all
 29.03.14         *
 23.03.14                                        * all
 13.02.14                                                        *
*/

-- тест
-- select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 328405 , inDocumentTaxKindId := 80788 , inDocumentTaxKindId_inf := 80788 ,  inStartDateTax:= '01.01.2024', inSession := '5');
