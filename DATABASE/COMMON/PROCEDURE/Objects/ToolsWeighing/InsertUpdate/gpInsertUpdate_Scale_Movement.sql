-- Function: gpInsertUpdate_Scale_Movement()

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
*/
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, Boolean, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar, Boolean, Boolean, Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Scale_Movement(
    IN inId                     Integer   , -- Ключ объекта <Документ>
    IN inOperDate               TDateTime , -- Дата документа
    IN inOperDatePartner        TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner       TVarChar  , -- Номер  контрагента
    IN inMovementDescId         Integer   , -- Вид документа
    IN inMovementDescNumber     Integer   , -- Вид документа
    IN inFromId                 Integer   , -- От кого (в документе)
    IN inToId                   Integer   , -- Кому (в документе)
    IN inContractId             Integer   , -- Договора
    IN inPaidKindId             Integer   , -- Форма оплаты
    IN inPriceListId            Integer   , --
    IN inSubjectDocId           Integer   , --
    IN inMovementId_Order       Integer   , -- ключ Документа заявка
    IN inMovementId_Transport   Integer   , -- ключ Документа ИЛИ - криво - через этот прараметр передаем - Через кого поступил возврат
    IN inChangePercent          TFloat    , -- (-)% Скидки (+)% Наценки
  --IN inChangePercentAmount    TFloat    , -- % скидки для кол-ва поставщика
    IN inBranchCode             Integer   , --
    IN inComment                TVarChar  , --
    IN inIsListInventory        Boolean   , -- Инвентаризация только для выбранных товаров
  --IN inIsReason1              Boolean   , -- Причина скидки в кол-ве температура
  --IN inIsReason2              Boolean   , -- Причина скидки в кол-ве качество
    IN inMovementId_reReturnIn  Integer   , -- ключ Документа заявка
    IN inIP                     TVarChar,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id        Integer
             , InvNumber TVarChar
             , OperDate  TDateTime
             , TotalSumm TFloat
             , TotalSummPartner TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbTotalSumm TFloat;

   DECLARE vbPriceListId_Dnepr Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_Order AND Movement.DescId = zc_Movement_SendOnPrice())
     AND (SELECT COALESCE (MLO.ObjectId, 0) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId               AND MLO.DescId = zc_MovementLinkObject_From())
      <> (SELECT COALESCE (MLO.ObjectId, 0) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Order AND MLO.DescId = zc_MovementLinkObject_From())
     THEN
         RAISE EXCEPTION 'Ошибка.Разные подразделения <От Кого>, во взвешивании = <%>,%в документе основание = <%>.%Должны быть одинаковыми.'
                       , lfGet_Object_ValueData_sh ((SELECT COALESCE (MLO.ObjectId, 0) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId               AND MLO.DescId = zc_MovementLinkObject_From()))
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT COALESCE (MLO.ObjectId, 0) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Order AND MLO.DescId = zc_MovementLinkObject_From()))
                       , CHR (13)
                       ;
     END IF;


     -- определили !!!только для Днепра!!!
     IF inMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
        AND (inBranchCode = 1 OR inBranchCode BETWEEN 201 AND 210) -- Dnepr + Dnepr-OBV
     THEN
         -- !!!замена!!!
         vbPriceListId_Dnepr:=
        (SELECT tmp.PriceListId
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                   , inPartnerId      := CASE WHEN inMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                                                   THEN inToId
                                                                              ELSE inFromId
                                                                         END
                                                   , inMovementDescId := inMovementDescId
                                                   , inOperDate_order := CASE WHEN inMovementId_Order <> 0
                                                                                   THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Order)
                                                                              ELSE NULL
                                                                         END
                                                   , inOperDatePartner:= CASE WHEN inMovementId_Order <> 0
                                                                                   THEN NULL
                                                                              ELSE inOperDate
                                                                         END
                                                   , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                                   , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                   , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId_Order AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                    ) AS tmp);
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- сохранили
     inId:= gpInsertUpdate_Movement_WeighingPartner (ioId                  := inId
                                                   , inOperDate            := inOperDate
                                                   , inInvNumberOrder      := CASE WHEN inMovementId_Order <> 0 THEN (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Order) ELSE '' END
                                                   , inInvNumberPartner    := inInvNumberPartner
                                                   , inMovementDescId      := inMovementDescId
                                                   , inMovementDescNumber  := inMovementDescNumber
                                                   , inWeighingNumber      := CASE WHEN inId <> 0
                                                                                        THEN (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_WeighingNumber())
                                                                                   WHEN inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_Inventory(), zc_Movement_SendOnPrice())
                                                                                        THEN 1
                                                                                   ELSE 1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat_WeighingNumber.ValueData, 0))
                                                                                                       FROM Movement
                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                                                                                         AND MovementLinkObject_From.ObjectId = inFromId
                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                                                                                         AND MovementLinkObject_To.ObjectId = inToId
                                                                                                            LEFT JOIN MovementLinkMovement AS MLM_Order
                                                                                                                                           ON MLM_Order.MovementId = Movement.Id
                                                                                                                                          AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                                                                            INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                                                                                                     ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                                                                                                    AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                                                                                                                    AND MovementFloat_MovementDesc.ValueData = inMovementDescId
                                                                                                            INNER JOIN MovementFloat AS MovementFloat_WeighingNumber
                                                                                                                                     ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                                                                                                                    AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
                                                                                                       WHERE Movement.DescId = zc_Movement_WeighingPartner()
                                                                                                         AND Movement.OperDate BETWEEN inOperDate - INTERVAL '2 DAY' AND inOperDate
                                                                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                         AND COALESCE (MLM_Order.MovementChildId, 0) = COALESCE (inMovementId_Order, 0)
                                                                                                      ), 0)
                                                                              END :: Integer
                                                   , inFromId              := inFromId
                                                   , inToId                := inToId
                                                   , inContractId          := CASE WHEN inContractId > 0 THEN inContractId ELSE 0 END
                                                   , inPaidKindId          := inPaidKindId
                                                   , inPriceListId         := CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbPriceListId_Dnepr ELSE inPriceListId END
                                                   , inSubjectDocId        := inSubjectDocId
                                                   , inMovementId_Order    := inMovementId_Order
                                                   , inMovementId_Transport:= CASE WHEN inMovementDescId = zc_Movement_ReturnIn() THEN 0 ELSE inMovementId_Transport END
                                                   , inBranchCode          := inBranchCode
                                                   , inPartionGoods        := '' :: TVarChar
                                                   , inChangePercent       := inChangePercent
                                                 --, inChangePercentAmount := inChangePercentAmount
                                                   , inComment             := inComment
                                                   , inIsProtocol          := FALSE
                                                 --, inIsReason1           := inIsReason1
                                                 --, inIsReason2           := inIsReason2
                                                   , inSession             := inSession
                                                    );


     -- дописали св-во - Через кого поступил возврат
     IF inMovementId_Transport <> 0 AND inMovementDescId = zc_Movement_ReturnIn() AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMovementId_Transport)
     THEN
          -- сохранили связь с <Физические лица(Водитель/экспедитор)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), inId, (SELECT Object_Personal_View.MemberId FROM Object_Personal_View WHERE Object_Personal_View.PersonalId = inMovementId_Transport));
     END IF;

     -- дописали св-во - Инвентаризация только для выбранных товаров
     IF inMovementId_reReturnIn > 0
     THEN
          -- сохранили
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ReturnIn(), inId, inMovementId_reReturnIn);
     END IF;

     -- дописали св-во - Инвентаризация только для выбранных товаров
     IF inMovementDescId = zc_Movement_Inventory() AND inIsListInventory = TRUE
     THEN
          -- сохранили
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), inId, inIsListInventory);
     END IF;

     -- сохранили свойство <IP>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_IP(), inId, inIP);


     IF inMovementDescId IN (zc_Movement_Income()) AND inBranchCode BETWEEN 301 AND 310
     THEN
         -- сохранили свойство <Дата накладной у контрагента>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inId, inOperDatePartner);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, vbIsInsert);


-- !!! ВРЕМЕННО !!!

if vbUserId = 6044123 AND 1=0-- Авто-Загрузка WMS
then
    RAISE EXCEPTION 'Admin - Test = OK - %', inToId;
    -- 'Повторите действие через 3 мин.'
end if;
if vbUserId= 5 AND 1=0
then
    RAISE EXCEPTION 'Admin - Test = OK - %', inToId;
    -- 'Повторите действие через 3 мин.'
end if;


     -- Результат
     RETURN QUERY
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , MovementFloat_TotalSumm.ValueData AS TotalSumm
            , 0                       :: TFloat AS TotalSummPartner
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
       WHERE Movement.Id = inId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.01.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Scale_Movement (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
