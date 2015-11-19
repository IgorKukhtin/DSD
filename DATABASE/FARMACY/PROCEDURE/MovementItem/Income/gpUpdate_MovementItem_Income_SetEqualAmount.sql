DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SetEqualAmount(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SetEqualAmount(
    IN inMovementId          Integer   , -- документ
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     
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

    vbUserId := inSession::Integer;
    
    
    --Сохранили <кол-во ручное>
    PERFORM 
        lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), MovementItem.Id, MovementItem.Amount),
        lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), MovementItem.Id, 0)
    FROM
        MovementItem
    WHERE
        MovementItem.MovementId = inMovementId;

    -- сохранили протокол
    -- PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 17.11.15                                                                       *
*/

        
