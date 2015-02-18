-- Function: gptUpdateMI_Cash_Personal_AmountParam()

DROP FUNCTION IF EXISTS gptUpdateMI_Cash_Personal_AmountParam (Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS gptUpdateMI_Cash_Personal_AmountParam (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gptUpdateMI_Cash_Personal_AmountParam (
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- Сотрудники
 INOUT ioAmount              TFloat    , -- Сумма к выплате
 INOUT ioSummRemains         TFloat    , -- Остаток к выплате 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record AS --Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- рассчет к выплате
     ioAmount := COALESCE(ioAmount,0) + COALESCE (ioSummRemains,0);
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inPersonalId, inMovementId, ioAmount, NULL);
 
     -- рассчет осталось к выплате
     ioSummRemains := 0 :: TFLOAT;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.09.14         *
*/

-- тест
-- SELECT * FROM gptUpdateMI_Cash_Personal_AmountParam(ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')

--select * from gptUpdateMI_Cash_Personal_AmountParam(ioId := 11967866 , inMovementId := 1015917 , inPersonalId := 280263 , ioAmount := 8 , ioSummRemains := 450 ,  inSession := '5');