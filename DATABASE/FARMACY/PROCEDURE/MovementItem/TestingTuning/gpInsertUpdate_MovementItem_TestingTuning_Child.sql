-- Function: gpInsertUpdate_MovementItem_TestingTuning()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TestingTuning_Child (Integer, Integer, Integer, TBLOB, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Child(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ объекта <Документ>
    IN inQuestion              TBLOB     , -- Вопрос
    IN inSession               TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession::Integer;

     -- Разрешаем только сотрудникам с правами админа    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_TestingTuning()))
    THEN
      RAISE EXCEPTION 'Вым запрещено изменять настройки тестирования';
    END IF;

    --Проверили на корректность кол-ва
    IF COALESCE(inQuestion, '') = ''
    THEN
      RAISE EXCEPTION 'Ошибка. Не заполнен вопрос.';
    END IF;    

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), Null, inMovementId, 0, inParentId);

    -- сохранили свойство <Вопрос>
    PERFORM lpInsertUpdate_MovementItemBLOB (zc_MIBLOB_Question(), ioId, inQuestion);

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Child (Integer, Integer, Integer, TBLOB, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_TestingTuning_Child(ioId := 0 , inMovementId := 23977600 , inParentId := 440823953 , inQuestion := 'Для  чего предназначен  раздел №2 в книге РРО?' ,  inSession := '3');