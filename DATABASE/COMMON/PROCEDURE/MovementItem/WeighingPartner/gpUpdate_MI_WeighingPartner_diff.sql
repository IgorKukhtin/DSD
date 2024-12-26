-- Function: gpUpdate_MI_WeighingPartner_diff()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_diff(
    IN inId                         Integer   , -- 1.Взвешивание - док поставщика
    IN inId_check                   Integer   , -- идентификатор строки
    IN inMovementId_WeighingPartner Integer   , -- 2.Взвешивание - док склад
    IN inGoodsId                    Integer   , -- товар
    IN inGoodsKindId                Integer   , -- вид товара
    IN inChangePercentAmount        TFloat    , -- для 2. - % скидки кол-во
    IN inIsReason_1                 Boolean   , -- для 2. - Причина скидки в кол-ве температура
    IN inIsReason_2                 Boolean   , -- для 2. - Причина скидки в кол-ве качество

    IN inIsAmountPartnerSecond      Boolean   , -- для 1. - Признак "без оплаты"
    IN inIsReturnOut                Boolean   , -- для 1. - 
    IN inComment                    TVarChar  , -- для 1. - 
    IN inSession                    TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     IF inMovementId_WeighingPartner <> 0
     THEN
         -- сохранили свойство <% скидки для кол-ва>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentAmount(), inMovementId_WeighingPartner, inChangePercentAmount);
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason1(), inMovementId_WeighingPartner, inIsReason_1);
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason2(), inMovementId_WeighingPartner, inIsReason_2);

         PERFORM lpInsert_MovementProtocol (inMovementId_WeighingPartner, vbUserId, FALSE);

     ELSE
         IF inChangePercentAmount <> 0 OR inIsReason_1 = TRUE OR inIsReason_2 = TRUE
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав изменять значение.';
         END IF;
     END IF;

     IF inId <> 0
     THEN
         -- сохранили свойство <Признак "без оплаты">
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inId, inIsAmountPartnerSecond);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ReturnOut(), inId, inIsReturnOut);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);
    
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

     ELSE
         IF inId_check > 0
         THEN
              RAISE EXCEPTION 'Ошибка.Перейдите в режим "Показать весь список".';
         END IF;

         IF inIsAmountPartnerSecond = TRUE
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав изменять Признак "без оплаты".';
         END IF;

         IF inIsReturnOut = TRUE
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав изменять Признак "Возврат".';
         END IF;

         IF inComment <>''
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав изменять <Примечание>.';
         END IF;

     END IF;

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