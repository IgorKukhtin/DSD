DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_AmountManual(Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_AmountManual(
    IN inMovementId          Integer   , -- документ
    IN inMovementItemId      Integer   , -- строка документа
    IN inAmountManual        TFloat    , -- Кол-во ручное
    IN inReasonDifferences   Integer   , -- Причина разногласия
   OUT outAmountDiff         TFloat   , -- Причина разногласия
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

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

    outAmountDiff := COALESCE(inAmountManual,0) - coalesce((Select Amount from MovementItem Where Id = inMovementItemId),0);

    IF outAmountDiff = 0
    THEN
        inReasonDifferences := 0;
    END IF;

    -- Сохранили <причину разногласия>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), inMovementItemId, inReasonDifferences);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 17.11.15                                                                       *
*/
