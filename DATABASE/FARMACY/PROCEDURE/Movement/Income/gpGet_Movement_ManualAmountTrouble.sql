-- Function: gpGet_Movement_ManualAmountTrouble()

DROP FUNCTION IF EXISTS gpGet_Movement_ManualAmountTrouble(Integer, boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ManualAmountTrouble(Integer, boolean, boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ManualAmountTrouble(
    IN inId                  Integer   , -- Ключ объекта <Документ
    IN inReverce             boolean   , -- в любом случае поменять на противоположное
 INOUT ioChecked             boolean   , -- Проверен
   OUT outTrouble            Boolean   , -- Ставить признак нельзя, есть товар с несоответствием
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;
    IF inReverce = TRUE
    THEN
        ioChecked := NOT (COALESCE((SELECT MovementBoolean.ValueData
                                     FROM MovementBoolean
                                     Where MovementBoolean.MovementId = inId
                                       AND MovementBoolean.DescId = zc_MovementBoolean_Checked()),FALSE));
    END IF;
    IF COALESCE((SELECT MovementBoolean.ValueData
                 FROM MovementBoolean
                 Where MovementBoolean.MovementId = inId
                   AND MovementBoolean.DescId = zc_MovementBoolean_Checked()),FALSE) <> ioChecked
    THEN
    
        IF ioChecked = FALSE THEN
            outTrouble := FALSE;
            
        ELSE
            outTrouble := EXISTS(SELECT 1 
                                 FROM MovementItem
                                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                                                       ON MIFloat_AmountManual.MovementItemId = MovementItem.ID
                                                                      AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                 WHERE
                                     MovementItem.MovementId = inId
                                     AND
                                     MovementItem.isErased = FALSE
                                     AND
                                     COALESCE(MovementItem.Amount,0)<>COALESCE(MIFloat_AmountManual.ValueData,0));
        END IF;
        IF outTrouble = FALSE THEN
        -- сохранили свойство <>
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inId, ioChecked);
        ELSE
            ioChecked := FALSE;
        END IF;
    ELSE
        outTrouble := FALSE;
    END IF;    
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 18.11.15                                                                       *

*/
