-- Function: gpUpdate_MovementItem_TestingTuning_Storekeeper()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_TestingTuning_Storekeeper (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_TestingTuning_Storekeeper(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ объекта <Документ> 
    IN inisStorekeeper         Boolean   , -- Вопрос и кладовщику
    IN inSession               TVarChar    -- сессия пользователя
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
 
    -- сохранили свойство <Вопрос и кладовщику>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Storekeeper(), inId, not inisStorekeeper);
        
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_TestingTuning_Storekeeper (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- select * from gpUpdate_MovementItem_TestingTuning_Storekeeper(inId := 440869114 , inMovementId := 23977600 , inParentId := 440823953 , inisStorekeeper := 'False' ,  inSession := '3');
