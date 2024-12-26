-- Function: gpUpdate_MI_WeighingPartner_ActDiff_Edit()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, Integer, Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_ActDiff_Edit(
    IN inId                         Integer   , -- идентификатор строки
    IN inId_check                   Integer   , -- идентификатор строки
    IN inMovementId                 Integer   , -- идентификатор документа
    IN inGoodsId                    Integer   , -- товар
    IN inGoodsKindId                Integer   , -- вид товара
    IN inInvNumberPartner           TVarChar  , -- Номер  контрагента
    IN inOperDatePartner            TDateTime , -- Дата документа  контрагента
    IN inAmountPartnerSecond        TFloat    , -- Количество Поставщика
    IN inPricePartner               TFloat    , -- цена Поставщика
    IN inSummPartner                TFloat    , -- сумма Поставщика
    IN inisPriceWithVAT             Boolean   , -- Цена/Сумма с НДС (да/нет)
    IN inIsAmountPartnerSecond      Boolean   , -- Количество Поставщика 
    IN inIsReturnOut                Boolean   , -- Возврат да/нет
    IN inComment                    TVarChar  , -- примечание
    IN inSession                    TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPricePartner TFloat;
   DECLARE vbSummPartner TFloat;

   DECLARE vbInvNumberPartner_old TVarChar;
   DECLARE vbContractId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     --сохраненніе значения
     vbPricePartner := (SELECT MIF.ValueData FROM MovementItemFloat MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_PricePartner());
     vbSummPartner := (SELECT MIF.ValueData FROM MovementItemFloat MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummPartner());

     IF COALESCE (vbPricePartner,0) = COALESCE (inPricePartner,0) OR COALESCE (inPricePartner,0) = 0
     THEN
         IF (COALESCE(inSummPartner,0) <> 0 AND COALESCE(vbSummPartner,0) <> COALESCE(inSummPartner,0)) OR COALESCE (inPricePartner,0) = 0
         THEN
             -- пересчитываем цену по сумме
             inPricePartner := CASE WHEN COALESCE (inAmountPartnerSecond,0) <> 0 THEN (inSummPartner / inAmountPartnerSecond) ELSE 0 END ::TFloat;
         END IF;
     ELSE
         inSummPartner := (inPricePartner * inAmountPartnerSecond);
     END IF;


     IF NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner() AND MS.ValueData = inInvNumberPartner)
        AND TRIM (inInvNumberPartner) <> ''
     THEN
         vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
         vbInvNumberPartner_old:= (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner());
         vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
         vbPaidKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind());
     
         -- Все документы  - сохранили свойство <Номер контрагента>
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), Movement.Id, inInvNumberPartner)
         FROM Movement
              INNER JOIN MovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                       AND MovementString_InvNumberPartner.ValueData = vbInvNumberPartner_old
                                       AND vbInvNumberPartner_old <> ''
    
              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                           AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                           AND MovementLinkObject_Contract.ObjectId   = vbContractId
              INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                           AND MovementLinkObject_PaidKind.ObjectId   = vbPaidKindId
         WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate + INTERVAL '1 DAY'
           AND Movement.DescId   IN (zc_Movement_Income(), zc_Movement_WeighingPartner())
           AND Movement.StatusId = zc_Enum_Status_Complete()
        ;

     END IF;

     -- сохранили свойство <Номер контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), inMovementId, inInvNumberPartner);
     -- сохранили связь с <Дата контрагента>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inMovementId, inOperDatePartner);
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     --IF inId > 0
     --THEN

         -- определяется признак Создание/Корректировка
         vbIsInsert:= COALESCE (inId, 0) = 0;

         IF COALESCE (inId,0) = 0
         THEN
             -- сохранили <Элемент документа>
             inId := lpInsertUpdate_MovementItem (0, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
    
             -- сохранили свойство <Дата/время создания>
             PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), inId, CURRENT_TIMESTAMP);
    
             -- сохранили связь с <Виды товаров>
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);
         END IF;

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), inId, inAmountPartnerSecond);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), inId, inPricePartner);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPartner(), inId, inSummPartner);
    
         -- сохранили свойство <Признак "без оплаты">
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inId, inIsAmountPartnerSecond);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ReturnOut(), inId, inIsReturnOut);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceWithVAT(), inId, inisPriceWithVAT);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

     --END IF;


     if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ok. %   %', inPricePartner, inSummPartner; end if;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.24         *
 17.11.24         *
*/

-- тест
--