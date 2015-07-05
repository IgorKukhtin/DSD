-- Function: gpInsert_Scale_Movement_all()

DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_Movement_all(
    IN inBranchCode          Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (MovementId_begin    Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbBranchId         Integer;
   DECLARE vbIsUnitCheck      Boolean;
   DECLARE vbIsSendOnPriceIn  Boolean;
   DECLARE vbIsProductionIn   Boolean;

   DECLARE vbMovementId_find  Integer;
   DECLARE vbMovementId_begin Integer;
   DECLARE vbMovementDescId   Integer;
   DECLARE vbIsTax            Boolean;

   DECLARE vbMovementDescId_old  Integer;

   DECLARE vbOperDate_scale TDateTime;
   DECLARE vbId_tmp Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


    vbMovementDescId_old:= vbMovementDescId;

     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет данных для документа.';
     END IF;

     -- определили 
     vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                       ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                  END;
     -- определили <Тип документа>
     vbMovementDescId:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_MovementDesc()) :: Integer;

     -- !!!заменили параметр!!! : Продажа -> Перемещение по цене
     IF vbMovementDescId = zc_Movement_Sale() AND EXISTS (SELECT MLM_Order.MovementChildId
                                                          FROM MovementLinkMovement AS MLM_Order
                                                               INNER JOIN MovementLinkObject AS MLO ON MLO.MovementId = MLM_Order.MovementChildId AND MLO.DescId = zc_MovementLinkObject_From()
                                                               INNER JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                                                          WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                         )
     THEN
         vbMovementDescId:= zc_Movement_SendOnPrice();
     END IF;

     -- !!!заменили параметр!!! : Перемещение -> производство ПЕРЕРАБОТКА
     IF vbMovementDescId = zc_Movement_Send() AND (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To())
                                                  IN (8447, 8448) -- ЦЕХ колбасный + ЦЕХ деликатесов
                                              AND (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                  IN (SELECT 8451 -- Цех Упаковки
                                                     UNION
                                                      SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8453) -- Склады
                                                     )
     THEN
         vbMovementDescId:= zc_Movement_ProductionUnion();
         vbIsProductionIn:= FALSE;
     ELSE
         vbIsProductionIn:= NULL;
     END IF;

     -- !!!запомнили!!
     vbOperDate_scale:= inOperDate;
     -- !!!если по заявке, тогда дата берется из неё, вообще - надо только для филиалов!!!
     inOperDate:= CASE WHEN vbBranchId = zc_Branch_Basis()
                            THEN inOperDate
                       ELSE COALESCE ((SELECT ValueData FROM MovementDate WHERE MovementId = (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()) AND DescId = zc_MovementDate_OperDatePartner())
                                    , inOperDate)
                 END;

     -- таблица - "некоторые филиалы"
     CREATE TEMP TABLE _tmpUnit_check (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_check (UnitId)
        SELECT 301309 -- 22121	Склад ГП ф.Запорожье
       UNION
        SELECT 301309 -- 22121	Склад ГП ф.Запорожье
       UNION
        SELECT 309599 -- 22122	Склад возвратов ф.Запорожье
       UNION
        SELECT 346093 -- 22081	Склад ГП ф.Одесса
       UNION
        SELECT 346094 -- 22082	Склад возвратов ф.Одесса
    ;


     -- определяется признак "создавать Налоговую - да/нет"
     IF vbMovementDescId = zc_Movement_Sale()
     THEN           -- если в дефолтах
          vbIsTax:= LOWER ((SELECT gpGet_ToolsWeighing_Value ('Scale_'||inBranchCode, 'Default', '', 'isTax', 'FALSE', inSession))) = LOWER ('TRUE')
                    -- если у контрагента нет признака "Сводная"
                AND NOT EXISTS (SELECT ObjectBoolean_isTaxSummary.ValueData
                                FROM MovementLinkObject AS MovementLinkObject_To
                                     INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_isTaxSummary
                                                              ON ObjectBoolean_isTaxSummary.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                             AND ObjectBoolean_isTaxSummary.DescId = zc_ObjectBoolean_Juridical_isTaxSummary()
                                                             AND ObjectBoolean_isTaxSummary.ValueData = TRUE
                                WHERE MovementLinkObject_To.MovementId = inMovementId
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               )
                    -- если БН
                AND EXISTS (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PaidKind() AND ObjectId = zc_Enum_PaidKind_FirstForm())
               ;
     ELSE vbIsTax:= FALSE;
     END IF;


     IF vbMovementDescId = zc_Movement_Sale()
     THEN
          -- поиск существующего документа <Продажа покупателю> по Заявке
          vbMovementId_find:= (SELECT Movement.Id
                                FROM MovementLinkMovement
                                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                     ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                        AND Movement.DescId = zc_Movement_Sale()
                                                        AND Movement.OperDate = inOperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order());
     END IF;
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN
          -- поиск существующего документа <Инвентаризация> по ВСЕМ параметрам
          vbMovementId_find:= (SELECT Movement.Id
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                WHERE Movement.DescId = zc_Movement_Inventory()
                                  AND Movement.OperDate = inOperDate - INTERVAL '1 DAY'
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()));
     END IF;
     IF vbMovementDescId_old = zc_Movement_SendOnPrice()
     THEN
         -- поиск существующего документа <Перемещение по цене> !!!сразу получаем ключ!!!
          vbMovementId_find:= (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order());
          -- это "некоторые филиалы", иначе приход = расход !!!временно, т.к. должны быть все!!!
          vbIsUnitCheck:= EXISTS (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To()));
          -- это "приход" на "некоторые филиалы"
          vbIsSendOnPriceIn:= CASE WHEN vbIsUnitCheck = FALSE
                                        THEN FALSE -- т.е. не важно
                                   WHEN vbBranchId = zc_Branch_Basis() AND EXISTS (SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_From.ObjectId WHERE MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From())
                                        THEN TRUE -- для главного - приход на него
                                   WHEN vbBranchId = zc_Branch_Basis() AND EXISTS (SELECT MLO_To.ObjectId   FROM MovementLinkObject AS MLO_To   JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_To.ObjectId   WHERE MLO_To.MovementId = inMovementId   AND MLO_To.DescId   = zc_MovementLinkObject_To())
                                        THEN FALSE -- для главного - расход с него
                                   WHEN EXISTS (SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To     JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_To.ObjectId   WHERE MLO_To.MovementId   = inMovementId AND MLO_To.DescId   = zc_MovementLinkObject_To())
                                        THEN TRUE -- для филиала - приход на него
                                   WHEN EXISTS (SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_From.ObjectId WHERE MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From())
                                        THEN FALSE -- для филиала - расход с него
                              END;

          -- проверка vbMovementId_find
          IF  (COALESCE (vbMovementId_find, 0) <> 0 AND vbIsUnitCheck     = FALSE) -- т.е. vbMovementId_find не должно быть
           OR (COALESCE (vbMovementId_find, 0) = 0  AND vbIsSendOnPriceIn = TRUE)  -- т.е. вводят приход, а vbMovementId_find нет
           OR (COALESCE (vbMovementId_find, 0) <> 0 AND vbIsSendOnPriceIn = FALSE) -- т.е. вводят расход, а vbMovementId_find есть
          THEN
               RAISE EXCEPTION 'vbMovementId_find <%>', vbMovementId_find;
          END IF;

     END IF;


     -- перенесли
     vbMovementId_begin:= vbMovementId_find;


    -- сохранили <Документ>
    IF COALESCE (vbMovementId_begin, 0) = 0
    THEN
        -- сохранили
        vbMovementId_begin:= (SELECT CASE WHEN vbMovementDescId = zc_Movement_Income()
                                                    -- <Приход от поставщика>
                                               THEN lpInsertUpdate_Movement_Income_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Income_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := inOperDate
                                                  , inInvNumberPartner      := ''
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inPersonalPackerId      := NULL
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ReturnOut()
                                                    -- <Возврат поставщику>
                                               THEN lpInsertUpdate_Movement_ReturnOut_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ReturnOut_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := inOperDate
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Sale()
                                                    -- <Продажа покупателю>
                                               THEN lpInsertUpdate_Movement_Sale_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Sale_seq') AS TVarChar)
                                                  , inInvNumberPartner      := ''
                                                  , inInvNumberOrder        := InvNumberOrder
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := (inOperDate + (COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime
                                                  , inChecked               := NULL
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inRouteSortingId        := NULL
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inMovementId_Order      := MovementId_Order
                                                  , ioPriceListId           := NULL
                                                  , ioCurrencyPartnerValue  := NULL
                                                  , ioParPartnerValue       := NULL
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                                    -- <Возврат от покупателя>
                                               THEN lpInsertUpdate_Movement_ReturnIn
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ReturnIn_seq') AS TVarChar)
                                                  , inInvNumberPartner      := ''
                                                  , inInvNumberMark         := ''
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := inOperDate
                                                  , inChecked               := NULL
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inCurrencyValue         := NULL
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_SendOnPrice()
                                                    -- <Перемещение по цене>
                                               THEN lpInsertUpdate_Movement_SendOnPrice_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_SendOnPrice_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate -- дата приход = дата расходно только при создании
                                                  , inOperDatePartner       := inOperDate -- дата приход = дата расход
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inRouteSortingId        := NULL
                                                  , ioPriceListId           := NULL
                                                  , inProcessId             := zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Loss()
                                                    -- <Списание>
                                               THEN lpInsertUpdate_Movement_Loss_scale
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Loss_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inPriceWithVAT          := FALSE
                                                  , inVATPercent            := 20
                                                  , inFromId                := FromId
                                                  , inToId                  := NULL
                                                  , inArticleLossId         := ToId -- !!!не ошибка!!!
                                                  , inPaidKindId            := zc_Enum_PaidKind_SecondForm()
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Send()
                                                    -- <Перемещение>
                                               THEN lpInsertUpdate_Movement_Send
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Send_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ProductionUnion()
                                                    -- <Приход с производства>
                                               THEN lpInsertUpdate_Movement_ProductionUnion
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inIsPeresort            := FALSE
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Inventory()
                                                    -- <Инвентаризация>
                                               THEN lpInsertUpdate_Movement_Inventory
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Inventory_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate - INTERVAL '1 DAY'
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inUserId                := vbUserId
                                                   )

                                          END AS MovementId_begin

                                    FROM gpGet_Movement_WeighingPartner (inMovementId:= inMovementId, inSession:= inSession) AS tmp
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Partner_DocumentDayCount
                                                               ON ObjectFloat_Partner_DocumentDayCount.ObjectId = tmp.ToId
                                                              AND ObjectFloat_Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
                                 );
         -- Проверка
         IF COALESCE (vbMovementId_begin, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нельзя сохранить данный тип документа.';
         END IF;

        -- дописали св-во <Дата/время создания>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId_begin, CURRENT_TIMESTAMP);


        -- !!!Налоговая!!!
        IF vbIsTax = TRUE
        THEN
             -- сохранили
             PERFORM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := vbMovementId_begin
                                                          , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Tax()
                                                          , inDocumentTaxKindId_inf := NULL
                                                          , inUserId                := vbUserId
                                                           );
        END IF;

    ELSE
        -- Распроводим Документ !!!существующий!!!
        PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_begin
                                     , inUserId     := vbUserId);

        -- для !!!существующий!!! zc_Movement_SendOnPrice меняется <Дата прихода> + <Кому (в документе)> (если это первый раз)
        IF vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = TRUE
        THEN
            IF vbIsSendOnPriceIn = TRUE
            THEN
                -- сохранили свойство <Дата прихода>
                PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), vbMovementId_begin, inOperDate);

                -- !!!только в первый раз!!! для проведенных
                IF NOT EXISTS (SELECT Movement.ParentId FROM Movement WHERE Movement.ParentId = vbMovementId_begin AND Movement.DescId = zc_Movement_WeighingPartner() AND Movement.StatusId = zc_Enum_Status_Complete())
                THEN
                    -- исправили связь с <Кому (в документе)>
                    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), vbMovementId_begin, (SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To WHERE MLO_To.MovementId = inMovementId AND MLO_To.DescId = zc_MovementLinkObject_To()));
                END IF;

            ELSE
                -- по идее такого быть не может
                RAISE EXCEPTION 'Ошибка.<Дата расхода> не может измениться.';
                -- сохранили свойство <Дата расхода>
                PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, inOperDate, Movement.ParentId, Movement.AccessKeyId)
                FROM Movement
                WHERE Movement.Id = vbMovementId_begin;
            END IF;
        END IF;

    END IF;


    -- сформировали связь у расходной накл. с EDI (такую же как и у заявки)
    IF vbMovementDescId = zc_Movement_Sale()
    THEN PERFORM lpUpdate_Movement_Sale_Edi_byOrder (vbMovementId_begin, (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = vbMovementId_begin AND DescId = zc_MovementLinkMovement_Order() AND MovementChildId <> 0), vbUserId);
    END IF;


    -- сохранили <строчная часть>
     SELECT MAX (tmpId) INTO vbId_tmp
     FROM (SELECT CASE WHEN vbMovementDescId = zc_Movement_Income()
                                 -- <Приход от поставщика>
                            THEN lpInsertUpdate_MovementItem_Income
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inAmountPacker        := tmp.AmountPacker
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inLiveWeight          := tmp.LiveWeight
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inPartionGoods        := ''
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ReturnOut()
                                 -- <Возврат поставщику>
                            THEN lpInsertUpdate_MovementItem_ReturnOut
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Sale()
                                 -- <Продажа покупателю>
                            THEN lpInsertUpdate_MovementItem_Sale_Value
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inAmountChangePercent := tmp.AmountChangePercent
                                                        , inChangePercentAmount := tmp.ChangePercentAmount
                                                        , inPrice               := tmp.Price
                                                        , ioCountForPrice       := tmp.CountForPrice
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inBoxCount            := tmp.BoxCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inBoxId               := tmp.BoxId
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                 -- <Возврат от покупателя>
                            THEN lpInsertUpdate_MovementItem_ReturnIn_Value
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.Amount
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inHeadCount           := 0
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_SendOnPrice()
                                 -- <Перемещение по цене>
                            THEN lpInsertUpdate_MovementItem_SendOnPrice_scale
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountChangePercent := tmp.AmountChangePercent
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inChangePercentAmount := tmp.ChangePercentAmount
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inPartionGoods        := '' -- !!!не ошибка, здесь не формируется!!!
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUnitId              := CASE WHEN vbIsUnitCheck = FALSE OR vbIsSendOnPriceIn = FALSE THEN 0 ELSE tmp.UnitId_to END -- !!!формируется только когда приход + на "некоторые филиалы"!!!
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Loss()
                                 -- <Списание>
                            THEN lpInsertUpdate_MovementItem_Loss_scale
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Send()
                                 -- <Перемещение>
                            THEN lpInsertUpdate_MovementItem_Send_Value
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inCount               := tmp.CountPack
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUnitId              := NULL -- !!!не ошибка, здесь не формируется!!!
                                                        , inStorageId           := NULL
                                                        , inPartionGoodsId      := NULL
                                                        , inUserId              := vbUserId
                                                         )

                       WHEN vbMovementDescId = zc_Movement_ProductionUnion()
                                 -- <Приход с производства>
                            THEN lpInsertUpdate_MI_ProductionUnion_Master
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inCount               := tmp.Count
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUserId              := vbUserId
                                                         )

                       WHEN vbMovementDescId = zc_Movement_Inventory()
                                 -- <Инвентаризация>
                            THEN lpInsertUpdate_MovementItem_Inventory
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPrice               := 0 -- !!!не ошибка, здесь не формируется!!!
                                                        , inSumm                := 0 -- !!!не ошибка, здесь не формируется!!!
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inCount               := tmp.Count
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUnitId              := NULL
                                                        , inStorageId           := NULL
                                                        , inUserId              := vbUserId
                                                         )

                  END AS tmpId
          FROM (SELECT MAX (tmp.MovementItemId)      AS MovementItemId_find
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.BoxId
                     , tmp.PartionGoodsDate
                     , tmp.PartionGoods
                     , SUM (tmp.Amount)              AS Amount
                     , SUM (tmp.AmountChangePercent) AS AmountChangePercent
                     , SUM (tmp.AmountPartner)       AS AmountPartner
                     , tmp.ChangePercentAmount
                     , tmp.Price
                     , tmp.CountForPrice
                     , SUM (tmp.BoxCount)     AS BoxCount
                     , SUM (tmp.Count)        AS Count
                     , SUM (tmp.CountPack)    AS CountPack
                     , SUM (tmp.HeadCount)    AS HeadCount
                     , SUM (tmp.LiveWeight)   AS LiveWeight
                     , SUM (tmp.AmountPacker) AS AmountPacker
                     , tmp.UnitId_to
                FROM (SELECT 0                                                   AS MovementItemId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN zc_Goods_ReWork() ELSE MovementItem.ObjectId             END AS GoodsId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  END AS GoodsKindId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MILinkObject_Box.ObjectId, 0)        END AS BoxId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE MIDate_PartionGoods.ValueData                  END AS PartionGoodsDate
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIString_PartionGoods.ValueData, '') END AS PartionGoods

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = FALSE
                                       THEN MovementItem.Amount -- приход = расход = вес без скидки
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN MovementItem.Amount -- формируется только расход = вес без скидки
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN 0 -- не заполняется, т.к. сейчас приход
                                  ELSE MovementItem.Amount -- обычное значение
                             END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount -- !!!* вес только для пересортицы в переработку!!

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = FALSE
                                       THEN MovementItem.Amount -- приход = расход = вес без скидки
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN MovementItem.Amount -- формируется только расход = вес без скидки
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN 0 -- не заполняется, т.к. сейчас приход
                                  ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- обычное значение = вес со скидкой
                             END AS AmountChangePercent

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = FALSE
                                       THEN MovementItem.Amount -- приход = расход = вес без скидки
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN 0 -- не заполняется, т.к. сейчас расход
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN MovementItem.Amount -- формируется только приход = вес без скидки
                                  ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- обычное значение = вес со скидкой
                             END AS AmountPartner

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) END AS ChangePercentAmount

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIFloat_Price.ValueData, 0)               END AS Price
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIFloat_CountForPrice.ValueData, 0)       END AS CountForPrice

                           , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , 0                                                   AS AmountPacker
                           , 0                                                   AS LiveWeight

                           , MovementItem.Amount                                 AS Amount_mi
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MLO_To.ObjectId, 0) END AS UnitId_to
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       THEN 0 -- надо суммировать
                                  WHEN vbMovementDescId IN (zc_Movement_Send()) AND inBranchCode = 201 -- если Обвалка
                                       THEN MovementItem.Id -- пока не надо суммировать
                                  ELSE 0 -- можно суммировать, даже для Обвалки
                             END AS myId
                      FROM MovementItem
                           LEFT JOIN MovementLinkObject AS MLO_To
                                                        ON MLO_To.MovementId = MovementItem.MovementId
                                                       AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                       AND vbMovementDescId = zc_Movement_SendOnPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                                       ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                           LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                       ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                            ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                                                           AND vbMovementDescId = zc_Movement_Sale()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                               AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn= FALSE -- !!!важно!!!
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                                AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn= FALSE -- !!!важно!!!

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     UNION ALL
                      SELECT MovementItem.Id                                     AS MovementItemId
                           , MovementItem.ObjectId                               AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                           , COALESCE (MILinkObject_Box.ObjectId, 0)             AS BoxId
                           , MIDate_PartionGoods.ValueData                       AS PartionGoodsDate
                           , COALESCE (MIString_PartionGoods.ValueData, '')      AS PartionGoods

                           , MovementItem.Amount                                 AS Amount
                           , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS AmountChangePercent
                           , COALESCE (MIFloat_AmountPartner.ValueData, 0)       AS AmountPartner
                           , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount

                           , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                           , COALESCE (MIFloat_CountForPrice.ValueData, 0)       AS CountForPrice

                           , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , COALESCE (MIFloat_AmountPacker.ValueData, 0)        AS AmountPacker
                           , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                           , 0                                                   AS Amount_mi
                           , COALESCE (MILinkObject_To.ObjectId, COALESCE (MLO_To.ObjectId, 0)) AS UnitId_to
                           , 0                                                   AS myId
                      FROM MovementItem
                           LEFT JOIN MovementLinkObject AS MLO_To
                                                        ON MLO_To.MovementId = MovementItem.MovementId
                                                       AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                       AND vbMovementDescId = zc_Movement_SendOnPrice()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_To
                                                            ON MILinkObject_To.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_To.DescId = zc_MILinkObject_Unit()
                                                           AND vbMovementDescId = zc_Movement_SendOnPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                       ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                                       ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                           LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                       ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                       ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                            ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                      WHERE MovementItem.MovementId = vbMovementId_find
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_Inventory(), zc_Movement_SendOnPrice())
                     ) AS tmp
                GROUP BY tmp.GoodsId
                       , tmp.GoodsKindId
                       , tmp.BoxId
                       , tmp.PartionGoodsDate
                       , tmp.PartionGoods
                       , tmp.ChangePercentAmount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.UnitId_to
                       , tmp.myId -- если нет суммирования - каждое взвешивание в отдельной строчке
                HAVING SUM (tmp.Amount_mi) <> 0
               ) AS tmp
          ) AS tmp;


     -- добавили расход на переработку
     IF vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
     THEN 
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := 0
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inParentId            := vbId_tmp
                                                        , inPartionGoodsDate    := NULL
                                                        , inPartionGoods        := NULL
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUserId              := vbUserId
                                                         )
          FROM (SELECT tmp.GoodsId
                     , tmp.GoodsKindId
                     , SUM (tmp.Amount) AS Amount
                FROM (SELECT MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     ) AS tmp
                GROUP BY tmp.GoodsId
                       , tmp.GoodsKindId
               ) AS tmp
          ;
     END IF;



     -- !!!!!!!!!!!!!!
     -- !!!Проводки!!!
     -- !!!!!!!!!!!!!!

     -- <Продажа покупателю>
     IF vbMovementDescId = zc_Movement_Sale()
     THEN
         -- создаются временные таблицы - для формирование данных для проводок - <Продажа покупателю>
         PERFORM lpComplete_Movement_Sale_CreateTemp();
         -- Проводим Документ
         PERFORM lpComplete_Movement_Sale (inMovementId     := vbMovementId_begin
                                         , inUserId         := vbUserId
                                         , inIsLastComplete := NULL);

     ELSE -- <Возврат от покупателя>
          IF vbMovementDescId = zc_Movement_ReturnIn()
          THEN
              -- создаются временные таблицы - для формирование данных для проводок - <Возврат от покупателя>
              PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
              -- Проводим Документ 
              PERFORM lpComplete_Movement_ReturnIn (inMovementId     := vbMovementId_begin
                                                  , inUserId         := vbUserId
                                                  , inIsLastComplete := NULL);

          ELSE -- <Перемещение по цене>
               IF vbMovementDescId = zc_Movement_SendOnPrice()
               THEN
                   -- создаются временные таблицы - для формирование данных для проводок - <Перемещение по цене>
                   PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
                   -- Проводим Документ
                   PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := vbMovementId_begin
                                                          , inUserId         := vbUserId);

               ELSE
               -- <Приход от поставщика>
               IF vbMovementDescId = zc_Movement_Income()
               THEN
                   -- создаются временные таблицы - для формирование данных для проводок - <Перемещение по цене>
                   PERFORM lpComplete_Movement_Income_CreateTemp();
                   -- Проводим Документ
                   PERFORM lpComplete_Movement_Income (inMovementId     := vbMovementId_begin
                                                     , inUserId         := vbUserId
                                                     , inIsLastComplete := NULL);
               ELSE
               -- <Возврат поставщику>
               IF vbMovementDescId = zc_Movement_ReturnOut()
               THEN
                   -- создаются временные таблицы - для формирование данных для проводок - <Перемещение по цене>
                   PERFORM lpComplete_Movement_ReturnOut_CreateTemp();
                   -- Проводим Документ
                   PERFORM lpComplete_Movement_ReturnOut (inMovementId     := vbMovementId_begin
                                                        , inUserId         := vbUserId
                                                        , inIsLastComplete := NULL);

               ELSE
               -- <Списание>
               IF vbMovementDescId = zc_Movement_Loss()
               THEN
                   -- создаются временные таблицы - для формирование данных для проводок - <Перемещение по цене>
                   PERFORM lpComplete_Movement_Loss_CreateTemp();
                   -- Проводим Документ
                   PERFORM lpComplete_Movement_Loss (inMovementId     := vbMovementId_begin
                                                   , inUserId         := vbUserId);
               ELSE
               -- <Перемещение>
               IF vbMovementDescId = zc_Movement_Send()
               THEN
                   -- Проводим Документ
                   PERFORM gpComplete_Movement_Send (inMovementId     := vbMovementId_begin
                                                   , inIsLastComplete := NULL
                                                   , inSession        := inSession);
               ELSE
               -- <Приход с производства>
               IF vbMovementDescId = zc_Movement_ProductionUnion()
               THEN
                   -- создаются временные таблицы - для формирование данных для проводок - <Перемещение по цене>
                   PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
                   -- Проводим Документ
                   PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_begin
                                                              , inIsHistoryCost  := FALSE
                                                              , inUserId         := vbUserId);
               ELSE
               -- <Инвентаризация>
               IF vbMovementDescId = zc_Movement_Inventory()
               THEN
                   -- Проводим Документ
                   PERFORM gpComplete_Movement_Inventory (inMovementId     := vbMovementId_begin
                                                        , inIsLastComplete := NULL
                                                        , inSession        := inSession);
               END IF;
               END IF;
               END IF;
               END IF;
               END IF;
               END IF;
               END IF;
               END IF;
     END IF;


     -- финиш - сохранили <Документ> - <Взвешивание (контрагент)> - только дату + ParentId + AccessKeyId
     PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, vbOperDate_scale, vbMovementId_begin, Movement_begin.AccessKeyId)
     FROM Movement
          LEFT JOIN Movement AS Movement_begin ON Movement_begin.Id = vbMovementId_begin
     WHERE Movement.Id = inMovementId ;

     -- сохранили свойство <Протокол взвешивания>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inMovementId, CURRENT_TIMESTAMP);

     -- финиш - Обязательно меняем статус документа + сохранили протокол - <Взвешивание (контрагент)>
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingPartner()
                                , inUserId     := vbUserId
                                 );

     -- Результат
     RETURN QUERY
       SELECT vbMovementId_begin AS MovementId_begin;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.05.15                                        * add vbIsTax
 03.02.15                                        *
*/
/*
select lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), tmp.Id, tmp.EndWeighing)
from (
select Movement_Parent.Id, max (MovementDate_EndWeighing.ValueData) as EndWeighing
FROM Movement 
     INNER JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
     INNER JOIN MovementDate AS MovementDate_EndWeighing
                             ON MovementDate_EndWeighing.MovementId =  Movement.Id
                            AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
where Movement.DescId in (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
  and Movement.StatuId <> zc_Enum_Status_Erased()
group by Movement_Parent.Id
) as tmp
*/

-- тест
-- SELECT * FROM gpInsert_Scale_Movement_all (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
/*
select 
  case when Id <> 0                then Id /*lpSetErased_Movement (Id, 5)*/ end as isId
, case when MovementId_parent <> 0 then MovementId_parent /*lpSetErased_Movement (MovementId_parent,  5)*/ end as isMovementId_parent
, case when MovementId_tax <> 0    then MovementId_tax /*lpSetErased_Movement (MovementId_tax,  5)*/ end as isMovementId_tax
, a.* 
from gpSelect_Scale_Movement(inStartDate := ('01.06.2015')::TDateTime , inEndDate := ('26.06.2015')::TDateTime , inIsComlete := 'True' ,  inSession := '5') as a
where FromName <> 'Склад ГП ф.Запорожье' and FromName <> 'Склад ГП ф.Одесса'
  and ToName <>  'Склад ГП ф.Запорожье' and ToName <>  'Склад ГП ф.Одесса'

select 
  case when Id <> 0                then Id /*lpSetErased_Movement (Id, 5)*/ end as isId
, a.* 
from gpSelect_Scale_MovementCeh(inStartDate := ('01.06.2015')::TDateTime , inEndDate := ('26.06.2015')::TDateTime , inIsComlete := 'True' ,  inSession := '5') as a
and StatusCode <> 1
*/