-- Function: gpInsertUpdate_MovementItem_TestingTuning_Second()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TestingTuning_Second (Integer, Integer, Integer, Boolean, TBLOB, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Second(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ объекта <Документ>
    IN inisCorrectAnswer       Boolean   , -- Правельный ответ
    IN inPossibleAnswer        TBLOB     , -- Вариант ответа
    IN inSession               TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_lTestingTuning);
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession::Integer;

     -- Разрешаем только сотрудникам с правами админа    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Вым запрещено изменять настройки тестирования';
    END IF;

    --Проверили на корректность кол-ва
    IF COALESCE(inPossibleAnswer, '') = ''
    THEN
      RAISE EXCEPTION 'Ошибка. Не заполнен вопрос.';
    END IF;    

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Second(), Null, inMovementId, CASE WHEN inisCorrectAnswer = TRUE THEN 1 ELSE 0 END , inParentId);

    -- сохранили свойство <Вариант ответа>
    PERFORM lpInsertUpdate_MovementItemBLOB (zc_MIBLOB_PossibleAnswer(), ioId, inPossibleAnswer);

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Second (Integer, Integer, Integer, Boolean, TBLOB, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_TestingTuning_Second(ioId := 0 , inMovementId := 23977600 , inParentId := 440869114 , inisCorrectAnswer := 'True' , inPossibleAnswer := ' Для записи Z- отчетов.' ,  inSession := '3');

