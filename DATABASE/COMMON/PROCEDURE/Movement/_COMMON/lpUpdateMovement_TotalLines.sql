-- Function: gpUpdateMovement_TotalLines()

DROP FUNCTION IF EXISTS lpUpdateMovement_TotalLines (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdateMovement_TotalLines(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS VOID 
AS
$BODY$
    DECLARE vbTotalLines TFloat;
BEGIN

     -- строки документа
     vbTotalLines := (SELECT COUNT (*) AS TotalLines 
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      ) ::TFloat;

     IF COALESCE (vbTotalLines,0) > 0
     THEN
          -- сохранили свойство
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLines(), inId, vbTotalLines);
     END IF;
     
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.25         * 
*/


-- тест
--