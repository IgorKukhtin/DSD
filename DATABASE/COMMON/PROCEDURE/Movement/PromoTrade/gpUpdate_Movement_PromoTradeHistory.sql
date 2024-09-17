-- Function: gpUpdate_Movement_PromoTradeHistory()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PromoTradeHistory (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_PromoTradeHistory(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
 INOUT ioisTotalSumm_GoodsReal Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd TDateTime;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());

     --
     vbOperDateStart := (SELECT MD.ValueDate FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDateStart())::TDateTime;
     vbOperDateEnd   := (SELECT MD.ValueDate FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDateEnd())::TDateTime;

     


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE); 

     IF vbUserId = 9457 THEN  RAISE EXCEPTION 'TEST.OK.'; END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 16.09.24         *
 */

-- тест
--