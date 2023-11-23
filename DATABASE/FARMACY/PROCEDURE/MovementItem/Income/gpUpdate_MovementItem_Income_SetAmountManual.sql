DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SetAmountManual(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SetAmountManual(
    IN inMovementId          Integer   , -- документ
    IN inMovementItemId      Integer   , -- документ строка
    IN inAmountManual        TFloat    , -- Факт. кол-во
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

    IF vbUserId NOT IN (3, 59591, 183242, 4183126)
    THEN
      RETURN;     
    END IF;     
    
    IF COALESCE(inAmountManual, 0) = COALESCE((SELECT MIFloat_AmountManual.ValueData
                                               FROM MovementItemFloat AS MIFloat_AmountManual
                                               WHERE MIFloat_AmountManual.MovementItemId = inMovementItemId
                                                 AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()), 0)
    THEN
      RETURN;     
    END IF;     

    -- определяется
    SELECT 
        StatusId
      , InvNumber 
    INTO 
        vbStatusId
      , vbInvNumber   
    FROM 
        Movement 
    WHERE
        Id = inMovementId;
     
    --
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    -- Сохранили <кол-во ручное>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), inMovementItemId, inAmountManual);

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.11.23                                                       *
*/