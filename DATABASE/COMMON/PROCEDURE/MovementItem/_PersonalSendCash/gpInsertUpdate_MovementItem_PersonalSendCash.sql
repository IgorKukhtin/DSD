-- Function: gpInsertUpdate_MovementItem_PersonalSendCash()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalSendCash (Integer, Integer, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalSendCash (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalSendCash(
 INOUT ioMIId_20401          Integer   , -- ключ стоки - Статья назначения ГСМ
 INOUT ioMIId_21201          Integer   , -- ключ стоки - Статья назначения Коммандировочные
    IN inMovementId          Integer   , -- ключ Документа
    IN inPersonalId          Integer   , -- Сотрудник
    IN inAmount_20401        TFloat    , -- Сумма - Статья назначения ГСМ
    IN inAmount_21201        TFloat    , -- Сумма - Статья назначения Коммандировочные
    IN inRouteId             Integer   , -- Маршрут
    IN inCarId               Integer   , -- Автомобиль
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PersonalSendCash());
     vbUserId := inSession;

     -- сохранили Элемент для Статья назначения ГСМ
     ioMIId_20401 := lpInsertUpdate_MovementItem_PersonalSendCash (ioId          := ioMIId_20401
                                                                 , inMovementId  := inMovementId
                                                                 , inPersonalId  := inPersonalId
                                                                 , inAmount      := inAmount_20401
                                                                 , inRouteId     := inRouteId
                                                                 , inCarId       := inCarId
                                                                 , inInfoMoneyId := zc_Enum_InfoMoney_20401()
                                                                 , inUserId      := vbUserId
                                                                );
   
     -- сохранили Элемент для Статья назначения Коммандировочные
     ioMIId_21201 := lpInsertUpdate_MovementItem_PersonalSendCash (ioId          := ioMIId_21201
                                                                 , inMovementId  := inMovementId
                                                                 , inPersonalId  := inPersonalId
                                                                 , inAmount      := inAmount_21201
                                                                 , inRouteId     := inRouteId
                                                                 , inCarId       := inCarId
                                                                 , inInfoMoneyId := zc_Enum_InfoMoney_21201()
                                                                 , inUserId      := vbUserId
                                                                  );
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.13                                        * add ioMIId_20401 and ioMIId_21201
 06.10.13                                        * add inUserId
 03.10.13                                        * err
 30.09.13                                        * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalSendCash (ioPersonalId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
