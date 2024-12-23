-- Function: gpUpdate_MI_WeighingPartner_ActDiff_Edit()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_ActDiff_Edit(
    IN inId                         Integer   , -- идентификатор строки
    IN inMovementId                 Integer   , -- идентификатор документа 
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

     -- сохранили свойство <Номер контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), inMovementId, inInvNumberPartner);
     -- сохранили связь с <Дата контрагента>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inMovementId, inOperDatePartner);
     
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

     if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ok. %   %', inPricePartner, inSummPartner; end if;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.24         *
*/

-- тест
--