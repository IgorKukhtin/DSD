-- Function: gpInsert_MovementTransferSend_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpInsert_MovementTransferSend_SendPartionDateChange (Integer, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementTransferSend_SendPartionDateChange(
    IN inContainerID    Integer   , -- ID контейнера для изменения срока
    IN inExpirationDate TDateTime , -- Новый срок
    IN inAmount         TFloat    , -- Количество
    IN inMISendId       TVarChar  , -- Перечень перемещений
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMISendId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIndex Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

  vbMovementItemId := gpInsert_MovementTransfer_SendPartionDateChange(inContainerID    := inContainerID
                                                                    , inExpirationDate := inExpirationDate
                                                                    , inAmount         := inAmount
                                                                    , inSession        := inSession);


 -- парсим перемещения
  vbIndex := 1;
  WHILE SPLIT_PART (inMISendId, ';', vbIndex) <> '' LOOP
      -- добавляем то что нашли
      vbMISendId := SPLIT_PART (inMISendId, ';', vbIndex) :: Integer;
      -- сохранили свойство <Количество мест>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MISendPDChangeId(), vbMISendId, vbMovementItemId);
      -- теперь следуюющий
      vbIndex := vbIndex + 1;
  END LOOP;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.08.20                                                       *
*/

-- тест
-- select * from gpInsert_MovementTransferSend_SendPartionDateChange(inContainerID := 22598207 , inExpirationDate := ('01.01.2021')::TDateTime , inAmount := 2 , inMISendId := '369433676' ,  inSession := '3');