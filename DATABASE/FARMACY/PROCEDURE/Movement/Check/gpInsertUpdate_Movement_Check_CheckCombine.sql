-- Function: gpInsertUpdate_Movement_Check_CheckCombine()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_CheckCombine(Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_CheckCombine(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementAddId       Integer   , -- Ключ объекта <Документ>
    IN inisCheckCombine      Boolean   , -- Не для НТЗ
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;
  
  IF COALESCE(inisCheckCombine, FALSE) <>TRUE
  THEN
    RETURN;
  END IF;
  

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 23.01.20                                                                    *
*/

-- тест

select * from gpInsertUpdate_Movement_Check_CheckCombine(inMovementId := 24038406 , inMovementAddId := 24038407 , inisCheckCombine := 'True' ,  inSession := '3');