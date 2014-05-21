-- Function: lpInsertUpdate_Movement_Tax_From_Kind()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId                 Integer  , -- ключ Документа
    IN inDocumentTaxKindId          Integer  , -- Тип формирования налогового документа
    IN inDocumentTaxKindId_inf      Integer  , -- Тип формирования налогового документа
   OUT outInvNumberPartner_Master   TVarChar , --
   OUT outDocumentTaxKindId         Integer  , --
   OUT outDocumentTaxKindName       TVarChar , --
    IN inUserId                     Integer    -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbMovementDescId           Integer;
   DECLARE vbMovementId_Tax           Integer;
   DECLARE vbMovementId_TaxCorrective Integer;
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
   DECLARE vbDocumentTaxKindId_TaxCorrective Integer;

   DECLARE vbDiscountPercent TFloat;
   DECLARE vbExtraChargesPercent TFloat;
BEGIN
      -- это значит пользователь установил в журнале "другой" тип формирования
      IF inDocumentTaxKindId_inf <> 0 THEN inDocumentTaxKindId:= inDocumentTaxKindId_inf; END IF;

      -- это тип формирования по дефолту
      IF COALESCE (inDocumentTaxKindId, 0) = 0
      THEN inDocumentTaxKindId:= zc_Enum_DocumentTaxKind_Tax();
      END IF;


      -- определется тип формирования для корректировки
      vbDocumentTaxKindId_TaxCorrective:= CASE WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                               WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                               WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                               WHEN inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                    THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                          END;

      -- определяются параметры для <Налогового документа>
      SELECT CASE WHEN Movement.DescId = zc_Movement_Tax() THEN inMovementId ELSE MovementLinkMovement.MovementChildId END AS MovementId_Tax
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
           , DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) AS StartDate
           , DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData AS VATPercent
           , ObjectLink_Contract_JuridicalBasis.ChildObjectId AS FromId -- От кого - всегда главное юр.лицо из договора
           , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE MovementLinkObject_To.ObjectId END AS ToId
           , CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_Partner.ObjectId WHEN Movement.DescId = zc_Movement_Tax() THEN MovementLinkObject_Partner.ObjectId ELSE MovementLinkObject_To.ObjectId END AS PartnerId
           , COALESCE (MovementLinkObject_ContractTo.ObjectId, MovementLinkObject_Contract.ObjectId) AS ContractId
           , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
           , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
             INTO vbMovementId_Tax, vbMovementDescId, vbInvNumber_Tax, vbInvNumberPartner_Tax, vbOperDate, vbStartDate, vbEndDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId
                , vbDiscountPercent, vbExtraChargesPercent
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
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                   ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                  AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
           LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                     ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                    AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                ON ObjectLink_Contract_JuridicalBasis.ObjectId = COALESCE (MovementLinkObject_ContractTo.ObjectId, MovementLinkObject_Contract.ObjectId)
                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
           LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                         AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
           LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementLinkMovement.MovementChildId
           LEFT JOIN MovementString AS MS_InvNumberPartner_Master
                                    ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement.MovementChildId
                                   AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
      WHERE Movement.Id = inMovementId;


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
                                 AND Movement.StatusId <> zc_Enum_Status_Erased());
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
           -- поиск по Юр.лицу + Договор + период
           vbMovementId_TaxCorrective:= (SELECT (Movement.Id)
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
                                         WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                           AND Movement.DescId = zc_Movement_TaxCorrective()
                                           AND Movement.StatusId <> zc_Enum_Status_Erased());

      ELSE
      IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
      THEN 
           -- поиск по Контрагенту + Договор + период
           vbMovementId_TaxCorrective:= (SELECT (Movement.Id)
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
                                         WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                           AND Movement.DescId = zc_Movement_TaxCorrective()
                                           AND Movement.StatusId <> zc_Enum_Status_Erased());
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


      -- временная таблица "база" документов
      CREATE TEMP TABLE _tmpMovement (MovementId Integer, DescId Integer, DocumentTaxKindId Integer) ON COMMIT DROP;
      -- временная таблица "база" строчной части
      CREATE TEMP TABLE _tmpMI (GoodsId Integer, GoodsKindId Integer, Price TFloat, CountForPrice TFloat, Amount_Tax TFloat, Amount_TaxCorrective TFloat) ON COMMIT DROP;

      -- формируются данные "база" документов
      IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
      THEN
           -- данные из одной накладной <Продажа покупателю> или <Перевод долга (расход)>
           INSERT INTO _tmpMovement (MovementId, DescId, DocumentTaxKindId)
              SELECT Movement.Id, Movement.DescId, inDocumentTaxKindId FROM Movement WHERE Movement.Id = inMovementId;

      ELSE
      IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
      THEN
           -- данные по Юр.лицу + Договор из всех накладных
           INSERT INTO _tmpMovement (MovementId, DescId, DocumentTaxKindId)
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
                                                AND MovementLinkObject_Contract.ObjectId = vbContractId
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
              -- данные <Перевод долга (расход)>
              SELECT Movement.Id
                   , Movement.DescId
                   , inDocumentTaxKindId AS DocumentTaxKindId
              FROM Movement
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                AND MovementLinkObject_Contract.ObjectId = vbContractId
                   INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                                AND MovementLinkObject.ObjectId = vbToId
              WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_TransferDebtOut()
                AND Movement.StatusId = zc_Enum_Status_Complete();

      ELSE
      IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
      THEN
           -- данные по Контрагенту + Договор из всех накладных
           INSERT INTO _tmpMovement (MovementId, DescId, DocumentTaxKindId)
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
                                                AND MovementLinkObject_Contract.ObjectId = vbContractId
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
      WITH _tmpMovement2 
          AS (SELECT Movement.Id AS MovementId, Movement.DescId, inDocumentTaxKindId AS DocumentTaxKindId FROM Movement WHERE Movement.Id = inMovementId AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
             UNION ALL
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
                                                AND MovementLinkObject_Contract.ObjectId = vbContractId
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
                AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
             UNION ALL
              -- данные <Перевод долга (расход)>
              SELECT Movement.Id
                   , Movement.DescId
                   , inDocumentTaxKindId AS DocumentTaxKindId
              FROM Movement
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                AND MovementLinkObject_Contract.ObjectId = vbContractId
                   INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                                AND MovementLinkObject.ObjectId = vbToId
              WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_TransferDebtOut()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())

             UNION ALL
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
                                                AND MovementLinkObject_Contract.ObjectId = vbContractId
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
                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                AND inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
            )
      INSERT INTO _tmpMI (GoodsId, GoodsKindId, Price, CountForPrice, Amount_Tax, Amount_TaxCorrective)
         SELECT tmpMI.GoodsId
              , tmpMI.GoodsKindId
              , tmpMI.Price
              , tmpMI.CountForPrice
              , CASE WHEN tmpMI.Amount_Sale > 0 THEN tmpMI.Amount_Sale ELSE 0 END AS Amount_Tax
              , tmpMI.Amount_ReturnIn + CASE WHEN tmpMI.Amount_Sale < 0 THEN -1 * tmpMI.Amount_Sale ELSE 0 END AS Amount_TaxCorrective
         FROM (SELECT tmpMI_all.GoodsId
                    , tmpMI_all.GoodsKindId
                    , tmpMI_all.Price
                    , tmpMI_all.CountForPrice
                    , CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN tmpMI_all.Amount_Sale - tmpMI_all.Amount_ReturnIn ELSE tmpMI_all.Amount_Sale END AS Amount_Sale
                    , CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN 0 ELSE tmpMI_all.Amount_ReturnIn END AS Amount_ReturnIn
               FROM (SELECT MovementItem.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0 THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) ELSE COALESCE (MIFloat_Price.ValueData, 0) END AS Price
                          , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE COALESCE (MIFloat_CountForPrice.ValueData, 0) END AS CountForPrice
                          , SUM (CASE WHEN _tmpMovement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) WHEN _tmpMovement.DescId = zc_Movement_TransferDebtOut() THEN MovementItem.Amount ELSE 0 END) AS Amount_Sale
                          , SUM (CASE WHEN _tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Amount_ReturnIn
                     FROM _tmpMovement2 AS _tmpMovement
                          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement.MovementId
                                                 AND MovementItem.isErased = FALSE
                          INNER JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                      AND MIFloat_Price.ValueData <> 0  
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                            , MIFloat_Price.ValueData 
                            , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE COALESCE (MIFloat_CountForPrice.ValueData, 0) END
                    ) AS tmpMI_all
               WHERE tmpMI_all.Amount_Sale <> 0 OR tmpMI_all.Amount_ReturnIn <> 0
              ) AS tmpMI
         WHERE tmpMI.Amount_Sale <> 0 OR tmpMI.Amount_ReturnIn <> 0
        ;


      -- удаляем все "лишние" налоговые у "базы"
      PERFORM lpSetErased_Movement (inMovementId:= MovementLinkMovement.MovementChildId
                                  , inUserId    := inUserId)
      FROM _tmpMovement
           INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = _tmpMovement.MovementId
                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                                          AND MovementLinkMovement.MovementChildId <> COALESCE (vbMovementId_Tax, 0)
      WHERE _tmpMovement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut());

      -- удаляем все "лишние" корректировки у "базы"
      PERFORM lpSetErased_Movement_TaxCorrective (inMovementId:= MovementLinkMovement.MovementId
                                                , inUserId    := inUserId)
      FROM _tmpMovement
           INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId = _tmpMovement.MovementId
                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                                          AND MovementLinkMovement.MovementId <> COALESCE (vbMovementId_TaxCorrective, 0)
      WHERE _tmpMovement.DescId = zc_Movement_ReturnIn();

      -- удаляем для НЕ "база" связь с Налоговым документом
      PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), MovementLinkMovement.MovementId, 0)
      FROM MovementLinkMovement
           LEFT JOIN _tmpMovement ON _tmpMovement.MovementId = MovementLinkMovement.MovementId
      WHERE MovementLinkMovement.MovementChildId = vbMovementId_Tax
        AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
        AND _tmpMovement.MovementId IS NULL;


      -- распроводим налоговую и корректировку
      PERFORM lpUnComplete_Movement (inMovementId:= tmp.MovementId
                                   , inUserId    := inUserId)
      FROM (SELECT vbMovementId_Tax AS MovementId WHERE vbMovementId_Tax <> 0
           UNION ALL
            SELECT vbMovementId_TaxCorrective AS MovementId WHERE vbMovementId_TaxCorrective <> 0 
           ) AS tmp;


      -- сохранили Налоговую (всегда, даже если inMovementId - это она)
      SELECT tmp.ioId INTO vbMovementId_Tax
      FROM lpInsertUpdate_Movement_Tax (ioId               := vbMovementId_Tax
                                      , ioInvNumber        := vbInvNumber_Tax
                                      , ioInvNumberPartner := vbInvNumberPartner_Tax
                                      , inInvNumberBranch  := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberBranch()), '')
                                      , inOperDate         := vbOperDate
                                      , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementBoolean_Checked()), FALSE)
                                      , inDocument         := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementBoolean_Document()), FALSE)
                                      , inPriceWithVAT     := vbPriceWithVAT
                                      , inVATPercent       := vbVATPercent
                                      , inFromId           := vbFromId
                                      , inToId             := vbToId
                                      , inPartnerId        := CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN vbPartnerId ELSE NULL END
                                      , inContractId       := vbContractId
                                      , inDocumentTaxKindId:= inDocumentTaxKindId
                                      , inUserId           := inUserId
                                       ) AS tmp;

      -- сохранили корректировку (почти всегда)
      IF EXISTS (SELECT Amount_TaxCorrective FROM _tmpMI WHERE Amount_TaxCorrective <> 0)
      THEN
           SELECT tmp.ioId INTO vbMovementId_TaxCorrective
           FROM lpInsertUpdate_Movement_TaxCorrective (ioId               := vbMovementId_TaxCorrective
                                                     , inInvNumber        := COALESCE ((SELECT InvNumber FROM Movement WHERE Id = vbMovementId_TaxCorrective), '')
                                                     , inInvNumberPartner := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), '')
                                                     , inInvNumberBranch  := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberBranch()), '')
                                                     , inOperDate         := vbOperDate
                                                     , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementBoolean_Checked()), FALSE)
                                                     , inDocument         := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementBoolean_Document()), FALSE)
                                                     , inPriceWithVAT     := vbPriceWithVAT
                                                     , inVATPercent       := vbVATPercent
                                                     , inFromId           := vbToId
                                                     , inToId             := vbFromId
                                                     , inPartnerId        := CASE WHEN inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) THEN vbPartnerId ELSE NULL END
                                                     , inContractId       := vbContractId
                                                     , inDocumentTaxKindId:= vbDocumentTaxKindId_TaxCorrective
                                                     , inUserId           := inUserId
                                                      ) AS tmp;
      END IF;


      -- сохранили для "база" связь с Налоговым документом
      PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), _tmpMovement.MovementId, vbMovementId_Tax)
      FROM _tmpMovement
      WHERE _tmpMovement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut());
           
      -- сохранили для "база" связь с <Тип формирования налогового документа> !!!только для корректировок!!!
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), _tmpMovement.MovementId, _tmpMovement.DocumentTaxKindId)
      FROM _tmpMovement
      WHERE _tmpMovement.DescId = zc_Movement_ReturnIn();


      -- удаляем !!!все!!! строки из Налоговой
      PERFORM gpMovementItem_Tax_SetErased (inMovementItemId := tmpMI_Tax.MovementItemId
                                          , inSession := inUserId :: TVarChar)
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
              AND MovementItem.isErased = FALSE
           ) AS tmpMI_Tax 
           /*LEFT JOIN _tmpMI ON _tmpMI.GoodsId     = tmpMI_Tax.GoodsId
                           AND _tmpMI.GoodsKindId = tmpMI_Tax.GoodsKindId
                           AND _tmpMI.Price       = tmpMI_Tax.Price 
                           AND _tmpMI.Amount_Tax  <> 0
     WHERE _tmpMI.GoodsId IS NULL */;

      -- удаляем !!!все!!! строки из Корректировки
      PERFORM gpMovementItem_TaxCorrective_SetErased (inMovementItemId := tmpMI_TaxCorrective.MovementItemId
                                                    , inSession := inUserId :: TVarChar)
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
            WHERE MovementItem.MovementId = vbMovementId_TaxCorrective
              AND MovementItem.isErased = FALSE
           ) AS tmpMI_TaxCorrective
           /*LEFT JOIN _tmpMI ON _tmpMI.GoodsId     = tmpMI_TaxCorrective.GoodsId
                           AND _tmpMI.GoodsKindId = tmpMI_TaxCorrective.GoodsKindId
                           AND _tmpMI.Price       = tmpMI_TaxCorrective.Price 
                           AND _tmpMI.Amount_TaxCorrective  <> 0
     WHERE _tmpMI.GoodsId IS NULL */;


      -- сохранили строчную часть заново у Налоговой
      PERFORM lpInsertUpdate_MovementItem_Tax (ioId           := 0 -- tmpMI_Tax.MovementItemId
                                             , inMovementId   := vbMovementId_Tax
                                             , inGoodsId      := _tmpMI.GoodsId
                                             , inAmount       := _tmpMI.Amount_Tax
                                             , inPrice        := _tmpMI.Price
                                             , ioCountForPrice:= _tmpMI.CountForPrice
                                             , inGoodsKindId  := _tmpMI.GoodsKindId
                                             , inUserId       := inUserId)
      FROM _tmpMI
           /*LEFT JOIN (SELECT MAX (MovementItem.Id)   AS MovementItemId
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
                        AND MovementItem.isErased = FALSE 
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_GoodsKind.ObjectId
                             , MIFloat_Price.ValueData
                     ) AS tmpMI_Tax ON tmpMI_Tax.GoodsId     = _tmpMI.GoodsId
                                   AND tmpMI_Tax.GoodsKindId = _tmpMI.GoodsKindId
                                   AND tmpMI_Tax.Price       = _tmpMI.Price*/
      WHERE _tmpMI.Amount_Tax <> 0;

      -- сохранили строчную часть заново у Корректировки
      PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId           := 0 -- tmpMI_TaxCorrective.MovementItemId
                                                       , inMovementId   := vbMovementId_TaxCorrective
                                                       , inGoodsId      := _tmpMI.GoodsId
                                                       , inAmount       := _tmpMI.Amount_TaxCorrective
                                                       , inPrice        := _tmpMI.Price
                                                       , ioCountForPrice:= _tmpMI.CountForPrice
                                                       , inGoodsKindId  := _tmpMI.GoodsKindId
                                                       , inUserId       := inUserId)
      FROM _tmpMI
           /*LEFT JOIN (SELECT MAX (MovementItem.Id)   AS MovementItemId
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
                      WHERE MovementItem.MovementId = vbMovementId_TaxCorrective
                        AND MovementItem.isErased = FALSE 
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_GoodsKind.ObjectId
                             , MIFloat_Price.ValueData
                     ) AS tmpMI_TaxCorrective ON tmpMI_TaxCorrective.GoodsId     = _tmpMI.GoodsId
                                             AND tmpMI_TaxCorrective.GoodsKindId = _tmpMI.GoodsKindId
                                             AND tmpMI_TaxCorrective.Price       = _tmpMI.Price*/
      WHERE _tmpMI.Amount_TaxCorrective <> 0;


     -- ФИНИШ - Проводим Налоговую
     PERFORM lpComplete_Movement_Tax (inMovementId := vbMovementId_Tax
                                    , inUserId     := inUserId);
     -- ФИНИШ - Проводим Корректировку
     IF vbMovementId_TaxCorrective <> 0
     THEN
         PERFORM lpComplete_Movement_TaxCorrective (inMovementId := vbMovementId_TaxCorrective
                                                  , inUserId     := inUserId);
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

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
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
-- SELECT * FROM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId:= 21838, inDocumentTaxKindId:= 80770, inUserId:=  zfCalc_UserAdmin() :: TVarChar);
