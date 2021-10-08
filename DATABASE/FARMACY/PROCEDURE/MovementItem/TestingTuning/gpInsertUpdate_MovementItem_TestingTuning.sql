-- Function: gpInsertUpdate_MovementItem_TestingTuning()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TestingTuning (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TestingTuning(
 INOUT ioId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inTopicsTestingTuningId    Integer   , -- Тема тестирования сотрудников
    IN inTestQuestions            Integer   , -- Количество вопросов из темы при тесте
    IN inTestQuestionsStorekeeper Integer   , -- Количество вопросов из темы при тесте
    IN inSession                  TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession::Integer;

     -- Разрешаем только сотрудникам с правами админа    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_TestingTuning()))
    THEN
      RAISE EXCEPTION 'Вым запрещено изменять настройки тестирования';
    END IF;

    --Проверили на корректность кол-ва
    IF (inTestQuestions <= 0)
    THEN
      RAISE EXCEPTION 'Ошибка. Количество вопросов из темы <%> не может быть меньше или равно нулю.', inTestQuestions;
    END IF;    

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inTopicsTestingTuningId, inMovementId, inTestQuestions, NULL);

    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStorekeeper(), ioId, inTestQuestionsStorekeeper);

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_TestingTuning (Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_TestingTuning(ioId := 440824034 , inMovementId := 23977600 , inTopicsTestingTuningId := 17419466 , inTestQuestions := 8 , inTestQuestionsStorekeeper := 3 ,  inSession := '3');