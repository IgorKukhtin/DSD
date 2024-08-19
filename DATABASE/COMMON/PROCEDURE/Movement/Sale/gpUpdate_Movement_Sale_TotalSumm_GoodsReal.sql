-- Function: gpUpdate_Movement_Sale_TotalSumm_GoodsReal()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_TotalSumm_GoodsReal (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_TotalSumm_GoodsReal(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
 INOUT ioisTotalSumm_GoodsReal Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_TS_GoodsReal());

     -- определили признак
     ioisTotalSumm_GoodsReal := NOT ioisTotalSumm_GoodsReal;

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TotalSumm_GoodsReal(), inId, ioisTotalSumm_GoodsReal);
     

     -- пересчет сумм
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inId);

     -- сохранили протокол
     IF vbUserId <> 5 THEN PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE); END IF;


     IF vbUserId = 9457 THEN  RAISE EXCEPTION 'TEST.OK.'; END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 16.08.24         *
 */

-- тест
--