-- Function: gpUpdate_MovementItem_ReturnIn_AmountPartner()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_ReturnIn_AmountPartner (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_ReturnIn_AmountPartner(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
     
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());


     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
            INTO vbStatusId, vbInvNumber, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;


     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
    
     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementId = inMovementId;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.11.15         *  

*/
