-- Function: gpUpdate_MovementItem_TestingTuning_CorrectAnswer()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_TestingTuning_CorrectAnswer (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_TestingTuning_CorrectAnswer(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ объекта <Документ> 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_lTestingTuning);
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession::Integer;

     -- Разрешаем только сотрудникам с правами админа    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_TestingTuning()))
    THEN
      RAISE EXCEPTION 'Вым запрещено изменять настройки тестирования';
    END IF;

    --Проверили на корректность кол-ва
    IF COALESCE(inMovementId, 0) = 0 or COALESCE(inParentId, 0) = 0 or COALESCE(inId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Не сохранен документ.';
    END IF;    
 
    
    IF EXISTS(SELECT 1
              FROM MovementItem 
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.ParentId = inParentId
                AND MovementItem.DescId = zc_MI_Second()
                AND MovementItem.Amount <> 0
                AND MovementItem.Id <> COALESCE(inId, 0))
    THEN
      UPDATE MovementItem SET Amount = 0
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.ParentId = inParentId
        AND MovementItem.DescId = zc_MI_Second()
        AND MovementItem.Amount <> 0
        AND MovementItem.Id <> COALESCE(inId, 0);
    END IF;

    IF EXISTS(SELECT 1
              FROM MovementItem 
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.ParentId = inParentId
                AND MovementItem.DescId = zc_MI_Second()
                AND MovementItem.Amount <> 1
                AND MovementItem.Id = COALESCE(inId, 0))
    THEN
      UPDATE MovementItem SET Amount = 1
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.ParentId = inParentId
        AND MovementItem.DescId = zc_MI_Second()
        AND MovementItem.Amount <> 1
        AND MovementItem.Id = COALESCE(inId, 0);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Second (Integer, Integer, Integer, Boolean, TBLOB, Boolean, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_TestingTuning_Second(ioId := 0 , inMovementId := 23977600 , inParentId := 440869114 , inisCorrectAnswer := 'True' , inPossibleAnswer := ' Для записи Z- отчетов.' ,  inSession := '3');