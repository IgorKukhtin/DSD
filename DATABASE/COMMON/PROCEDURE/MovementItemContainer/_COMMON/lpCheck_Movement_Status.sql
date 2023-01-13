-- Function: lpCheck_Movement_Status (Integer)

DROP FUNCTION IF EXISTS lpCheck_Movement_Status (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_Status(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inUserId            Integer    -- Пользователь
)                              
  RETURNS VOID
AS
$BODY$
   DECLARE vbDescId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCloseDate TDateTime;
   DECLARE vbRoleName TVarChar;

   DECLARE vbDocumentTaxKindId Integer;
   DECLARE vbStatusId_Tax Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbDescName TVarChar;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbStartDate  TDateTime;
   DECLARE vbEndDate  TDateTime;

   DECLARE vbAccessKeyId Integer;
BEGIN

  IF inUserId IN (5, 6604558) -- Голота К.О.
  THEN
      RETURN;
  END IF;


  -- 1.1. проверка <Зарегестрирован>
  IF  EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Registered() AND ValueData = TRUE)
   OR EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Electron() AND ValueData = TRUE)
  THEN
      RAISE EXCEPTION 'Ошибка.Установлен признак <Электронный документ> в <%> № <%> от <%>.<Распроведение> невозможно.', (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                                                                                                    , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                                                                                                    , DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                                                                                                     ;
  END IF;
  -- END 1.1. проверка <Зарегестрирован>
  -- 1.2. проверка <Медок>
  /*IF  EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Medoc() AND ValueData = TRUE)
  THEN
      RAISE EXCEPTION 'Ошибка.Документ выгружен в Медок.<Распроведение> невозможно.';
  END IF;*/
  -- END 1.2. проверка <Медок>


  IF inUserId <> zc_Enum_Process_Auto_PrimeCost() -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     AND inUserId <> 343013 -- Нагорная Я.Г.
  THEN

     -- 2.1.1. проверка для налоговых
     -- 2.1.
     -- определяется тип налог.
     SELECT MovementLinkObject_DocumentTaxKind_Master.ObjectId AS DocumentTaxKindId
          , Movement_DocumentMaster.StatusId
          , COALESCE (MS_InvNumberPartner.ValueData, Movement_DocumentMaster.InvNumber) AS vbInvNumber
          , Movement_DocumentMaster.OperDate
          , MovementDesc.ItemName
            INTO vbDocumentTaxKindId, vbStatusId_Tax, vbInvNumber, vbOperDate, vbDescName
     FROM MovementLinkMovement AS MovementLinkMovement_Master
          INNER JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                        AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
                                                        AND Movement_DocumentMaster.DescId IN (zc_Movement_Sale(), /*zc_Movement_ReturnIn(), */ zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_PriceCorrective())
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_DocumentMaster.DescId
          LEFT JOIN MovementString AS MS_InvNumberPartner
                                   ON MS_InvNumberPartner.MovementId = Movement_DocumentMaster.Id
                                  AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                       ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id
                                      AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
     WHERE MovementLinkMovement_Master.MovementId = inMovementId
       AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master();
     -- проверка - если входит в сводную, то она должна быть распроведена
     IF vbDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Tax() AND vbStatusId_Tax <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменения невозможны. Найден документ <%> № <%> от <%> в статусе <%>.', vbDescName, vbInvNumber, DATE (vbOperDate), lfGet_Object_ValueData (vbStatusId_Tax);
     END IF;
     -- END 2.1.
     -- 2.2.
     -- определяется данные корректировки
     SELECT Movement_Document.StatusId
          , COALESCE (MS_InvNumberPartner.ValueData, Movement_Document.InvNumber) AS vbInvNumber
          , Movement_Document.OperDate
          , MovementDesc.ItemName
            INTO vbStatusId_Tax, vbInvNumber, vbOperDate, vbDescName
     FROM MovementLinkMovement AS MovementLinkMovement_Child
          INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Child.MovementChildId
                             AND Movement.StatusId = zc_Enum_Status_Complete()
          INNER JOIN Movement AS Movement_Document ON Movement_Document.Id = MovementLinkMovement_Child.MovementId
                                                  AND Movement_Document.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement_Document.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_PriceCorrective())
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Document.DescId
          LEFT JOIN MovementString AS MS_InvNumberPartner
                                   ON MS_InvNumberPartner.MovementId = Movement_Document.Id
                                  AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
     WHERE MovementLinkMovement_Child.MovementChildId = inMovementId
       AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
       AND MovementLinkMovement_Child.MovementId <> inMovementId -- !!!убрать после исправления ошибки когда сама в себя!!!!
    ; 
     -- проверка - если входит в сводную, то она должна быть распроведена
     IF vbStatusId_Tax = zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменения невозможны. Найден документ <%> № <%> от <%> в статусе <%>.', vbDescName, vbInvNumber, DATE (vbOperDate), lfGet_Object_ValueData (vbStatusId_Tax);
     END IF;
     -- END 2.2. проверка для налоговых



     -- 2.2. проверка для корректировок
     -- проверка - если входит в сводную, то она должна быть распроведена
     IF EXISTS (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_DocumentTaxKind() AND ObjectId <> zc_Enum_DocumentTaxKind_Corrective())
     THEN
         -- 2.2.1. определяются параметры
         SELECT MovementLinkObject_DocumentTaxKind.ObjectId AS DocumentTaxKindId
              , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_From.ObjectId ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
              , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE MovementLinkObject_From.ObjectId END AS JuridicalId
              , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_Contract.ObjectId ELSE MovementLinkObject_ContractFrom.ObjectId END AS ContractId
              , DATE_TRUNC ('MONTH', CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementDate_OperDatePartner.ValueData ELSE Movement.OperDate END) AS StartDate
              , DATE_TRUNC ('MONTH', CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementDate_OperDatePartner.ValueData ELSE Movement.OperDate END) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
                INTO vbDocumentTaxKindId, vbPartnerId, vbJuridicalId, vbContractId, vbStartDate, vbEndDate
         FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
              LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                     ON MovementDate_OperDatePartner.MovementId =  MovementLinkObject_DocumentTaxKind.MovementId
                                    AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                           ON MovementLinkObject_Partner.MovementId = MovementLinkObject_DocumentTaxKind.MovementId
                                          AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = MovementLinkObject_DocumentTaxKind.MovementId
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = MovementLinkObject_DocumentTaxKind.MovementId
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                           ON MovementLinkObject_ContractFrom.MovementId = MovementLinkObject_DocumentTaxKind.MovementId
                                          AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
              LEFT JOIN Movement ON Movement.Id = MovementLinkObject_DocumentTaxKind.MovementId
         WHERE MovementLinkObject_DocumentTaxKind.MovementId = inMovementId
           AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind();

         -- 2.2.2. так проверка сводной по юр.лицу
         IF vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR())
         THEN
            vbInvNumber:= NULL; vbOperDate:= NULL;
            SELECT tmp.InvNumber, tmp.OperDate, MovementDesc.ItemName
                   INTO vbInvNumber, vbOperDate, vbDescName
            FROM
           (SELECT COALESCE (MS_InvNumberPartner.ValueData, Movement.InvNumber) AS InvNumber, Movement.OperDate, Movement.DescId
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId = vbContractId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                              AND MovementLinkObject_To.ObjectId = vbJuridicalId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                               ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                              AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                              AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS())
                 LEFT JOIN MovementString AS MS_InvNumberPartner
                                          ON MS_InvNumberPartner.MovementId = Movement.Id
                                         AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
              AND Movement.DescId = zc_Movement_Tax()
              AND Movement.StatusId = zc_Enum_Status_Complete()
              AND vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
           UNION
            SELECT COALESCE (MS_InvNumberPartner.ValueData, Movement.InvNumber) AS InvNumber, Movement.OperDate, Movement.DescId
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId = vbContractId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                              AND MovementLinkObject_From.ObjectId = vbJuridicalId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                               ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                              AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                              AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR())
                 LEFT JOIN MovementString AS MS_InvNumberPartner
                                          ON MS_InvNumberPartner.MovementId = Movement.Id
                                         AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
              AND Movement.DescId = zc_Movement_TaxCorrective()
              AND Movement.StatusId = zc_Enum_Status_Complete()
           ) AS tmp
           LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.DescId;

           IF vbInvNumber IS NOT NULL OR vbOperDate IS NOT NULL
           THEN
               RAISE EXCEPTION 'Ошибка.Изменения невозможны. Найден документ <%> № <%> от <%> в статусе <%>.', vbDescName, vbInvNumber, DATE (vbOperDate), lfGet_Object_ValueData (zc_Enum_Status_Complete());
           END IF;
         END IF;


         -- 2.2.3. так проверка сводной по контрагенту
         IF vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR())
         THEN
            vbInvNumber:= NULL; vbOperDate:= NULL;
            SELECT tmp.InvNumber, tmp.OperDate, MovementDesc.ItemName
                   INTO vbInvNumber, vbOperDate, vbDescName
            FROM
           (SELECT COALESCE (MS_InvNumberPartner.ValueData, Movement.InvNumber) AS InvNumber, Movement.OperDate, Movement.DescId
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId = vbContractId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                               ON MovementLinkObject_Partner.MovementId = Movement.Id
                                              AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                              AND MovementLinkObject_Partner.ObjectId = vbPartnerId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                               ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                              AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                              AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS())
                 LEFT JOIN MovementString AS MS_InvNumberPartner
                                          ON MS_InvNumberPartner.MovementId = Movement.Id
                                         AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
              AND Movement.DescId = zc_Movement_Tax()
              AND Movement.StatusId = zc_Enum_Status_Complete()
              AND vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
           UNION
            SELECT COALESCE (MS_InvNumberPartner.ValueData, Movement.InvNumber) AS InvNumber, Movement.OperDate, Movement.DescId
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId = vbContractId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                               ON MovementLinkObject_Partner.MovementId = Movement.Id
                                              AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                              AND MovementLinkObject_Partner.ObjectId = vbPartnerId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                               ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                              AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                              AND MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR())
                 LEFT JOIN MovementString AS MS_InvNumberPartner
                                          ON MS_InvNumberPartner.MovementId = Movement.Id
                                         AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
              AND Movement.DescId = zc_Movement_TaxCorrective()
              AND Movement.StatusId = zc_Enum_Status_Complete()
           ) AS tmp
           LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.DescId;

           IF vbInvNumber IS NOT NULL OR vbOperDate IS NOT NULL
           THEN
               RAISE EXCEPTION 'Ошибка.Изменения невозможны. Найден документ <%> № <%> от <%> в статусе <%>.', vbDescName, vbInvNumber, DATE (vbOperDate), lfGet_Object_ValueData (zc_Enum_Status_Complete());
           END IF;
         END IF;

     END IF;
     -- END 2.2. проверка для корректировок

  ELSE
     -- !!!для Админа!!!
     -- определяется данные корректировки
     SELECT Movement_Document.StatusId
          , COALESCE (MS_InvNumberPartner.ValueData, Movement_Document.InvNumber) AS vbInvNumber
          , Movement_Document.OperDate
          , MovementDesc.ItemName
            INTO vbStatusId_Tax, vbInvNumber, vbOperDate, vbDescName
     FROM MovementLinkMovement AS MovementLinkMovement_Child
          INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Child.MovementChildId
                             AND Movement.StatusId = zc_Enum_Status_Erased()
          INNER JOIN Movement AS Movement_Document ON Movement_Document.Id = MovementLinkMovement_Child.MovementId
                                                  AND Movement_Document.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement_Document.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_PriceCorrective())
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Document.DescId
          LEFT JOIN MovementString AS MS_InvNumberPartner
                                   ON MS_InvNumberPartner.MovementId = Movement_Document.Id
                                  AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
     WHERE MovementLinkMovement_Child.MovementChildId = inMovementId
       AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child();

     -- проверка - если входит в сводную, то она должна быть распроведена
     IF vbStatusId_Tax = zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменения невозможны. Найден документ <%> № <%> от <%> в статусе <%>.', vbDescName, vbInvNumber, DATE (vbOperDate), lfGet_Object_ValueData (vbStatusId_Tax);
     END IF;

  END IF;


  -- есть !!!НОВАЯ СХЕМА ПРОВЕРКИ - Закрытый период!!!, поэтому все что дальше - не надо
  /*
  -- !!!временно!!!
  IF inUserId IN (-1 -- 128491 -- Хохлова Е.Ю. !!!временно!!!
                -- , 5
                -- , zc_Enum_Process_Auto_Pack()
                 )
  THEN RETURN;
  END IF;


  -- 3.0.1. определяется дата
  SELECT OperDate, DescId, AccessKeyId
         INTO vbOperDate, vbDescId, vbAccessKeyId
  FROM Movement WHERE Id = inMovementId;


  -- по этим док-там !!!нет закрытия периода!!!
  IF vbDescId NOT IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
  THEN

  -- !!!временно если БН начисления маркетинг!!!
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = 82392) -- Начисления(п.б.)-ввод документов
     AND vbDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                            AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 7 -- БН начисления маркетинг
           ) AS tmp;
      -- 3.2. проверка <Закрытие периода>
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе № <%> от <%> не возможны. Для роли <%> период закрыт до <%>. (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbRoleName, DATE (vbCloseDate), inMovementId;
      END IF;

  ELSE
  -- !!!временно если ФИЛИАЛ НАЛ + БН!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
     AND inUserId <> 12120 -- Нагорнова Т.С. !!!временно!!!
     AND (EXISTS (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0)
       OR vbAccessKeyId <> zc_Enum_Process_AccessKey_DocumentDnepr()
         )
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 5 -- Закрытие периода Филиал НАЛ + БН
           ) AS tmp;

      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
      END IF;

  ELSE
  -- !!!временно если НАЛОГОВЫЕ!!!
  IF vbDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 3 -- Налоговые + корректировки
           ) AS tmp;

      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
      END IF;

  ELSE
  -- !!!временно если ВСЕ НАЛ!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
     AND (EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom(), zc_MovementLinkObject_PaidKindTo()) AND ObjectId = zc_Enum_PaidKind_SecondForm())
       OR vbDescId IN (zc_Movement_Cash(), zc_Movement_FounderService(), zc_Movement_PersonalAccount(), zc_Movement_PersonalReport(), zc_Movement_PersonalSendCash(), zc_Movement_PersonalService()
                     , zc_Movement_Inventory(), zc_Movement_Loss(), zc_Movement_ProductionSeparate(), zc_Movement_ProductionUnion(), zc_Movement_Send(), zc_Movement_SendOnPrice()
                     , zc_Movement_Transport(), zc_Movement_TransportService())
       OR EXISTS (SELECT MovementItem.MovementId
                  FROM MovementItem
                       JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                  AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                                                  AND MovementItemLinkObject.ObjectId = zc_Enum_PaidKind_SecondForm()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.isErased = FALSE
                 )
         )
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 4 -- Закрытие периода ВСЕМ НАЛ
           ) AS tmp;

      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
      END IF;

  ELSE
  -- !!!временно если не НАЛ!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
     AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PaidKind() AND ObjectId = zc_Enum_PaidKind_SecondForm())
     AND EXISTS (SELECT 1 FROM PeriodClose JOIN ObjectLink_UserRole_View AS View_UserRole ON View_UserRole.RoleId = PeriodClose.RoleId AND View_UserRole.UserId = inUserId
                 -- WHERE PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = vbDescId)
                )
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT (CASE WHEN PeriodClose.Period  = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate)                ELSE zc_DateStart() END) AS CloseDate
                 , (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , (PeriodClose.Name) AS RoleName
            FROM PeriodClose
                 INNER JOIN ObjectLink_UserRole_View AS View_UserRole
                                                     ON View_UserRole.RoleId = PeriodClose.RoleId
                                                    AND View_UserRole.UserId = inUserId
                                                   -- AND vbDescId NOT IN (zc_Movement_PersonalService(), zc_Movement_Service(), zc_Movement_SendDebt())
            -- WHERE PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = vbDescId)
            WHERE PeriodClose.Id <= 7
            ORDER BY 1 DESC, 2 DESC
            LIMIT 1
           ) AS tmp;
      -- 3.2. проверка прав для <Закрытие периода>
      IF vbOperDate < vbCloseDate
      THEN 
          -- RAISE EXCEPTION 'Ошибка.Изменения в документе № <%> от <%> не возможны.Для роли <%> период закрыт до <%>.(%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), TO_CHAR (vbOperDate, 'DD.MM.YYYY'), vbRoleName, TO_CHAR (vbCloseDate, 'DD.MM.YYYY'), inMovementId;
          RAISE EXCEPTION 'Ошибка.Изменения в документе № <%> от <%> не возможны. Для роли <%> период закрыт до <%>. (%)(%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbRoleName, DATE (vbCloseDate), inMovementId, vbDescId;
      END IF;

  ELSE
         IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
         THEN
             -- !!!временно если ВСЕ НЕ НАЛ!!!
             -- 3.1. определяется дата для <Закрытие периода>
             SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
                  , tmp.RoleName                                                                          AS RoleName
                    INTO vbCloseDate, vbRoleName
             FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                        , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                        , MAX (PeriodClose.Name) AS RoleName
                   FROM PeriodClose
                   WHERE PeriodClose.Id = 6 -- Закрытие периода ВСЕМ БН
                  ) AS tmp;
             -- 3.2. проверка прав для <Закрытие периода>
             IF vbOperDate < vbCloseDate
             THEN 
                 RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
             END IF;
         END IF;

  END IF; -- !!!временно если ФИЛИАЛ НАЛ + БН!!!
  END IF; -- !!!временно если НАЛОГОВЫЕ!!!
  END IF; -- !!!временно если ВСЕ НАЛ!!!
  END IF; -- !!!временно если БН начисления маркетинг!!!
  END IF; -- !!!временно если не НАЛ!!! ELSE !!!временно если ВСЕ НЕ НАЛ!!!

  END IF; -- по этим док-там !!!нет закрытия периода!!!

*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheck_Movement_Status (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.14                                        * add !!!временно если не НАЛ!!!
 04.10.14                                        * add zc_Enum_Role_Admin
 23.09.14                                        * add Object_Role_MovementDesc_View
 05.09.14                                        * add проверка - если входит в сводную, то она должна быть распроведена
*/

-- тест
-- SELECT * FROM lpCheck_Movement_Status (inMovementId:= 55, inUserId:= 2)
