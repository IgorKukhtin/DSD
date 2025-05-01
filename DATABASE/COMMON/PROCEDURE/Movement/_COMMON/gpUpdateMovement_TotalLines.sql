-- Function: gpUpdateMovement_TotalLines()

DROP FUNCTION IF EXISTS gpUpdateMovement_TotalLines (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_TotalLines(
    IN inId                  Integer   , -- Ключ объекта <Документ>
   OUT outTotalLines         TFloat   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --не удаленные строки документа
     outTotalLines := (SELECT COUNT (*) AS TotalLines 
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                       ) ::TFloat;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLines(), inId, outTotalLines);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.05.25         * 
*/


-- тест
--