-- Function: gpInsertUpdate_MovementItem_TestingTuning_Second()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TestingTuning_Second (Integer, Integer, Integer, Boolean, TBLOB, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Second(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ объекта <Документ>
    IN inisCorrectAnswer       Boolean   , -- Правельный ответ
    IN inPossibleAnswer        TBLOB     , -- Вариант ответа
    IN inisPhoto               Boolean   , -- Фльл ответ
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
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_TestingTuning()))
    THEN
      RAISE EXCEPTION 'Вым запрещено изменять настройки тестирования';
    END IF;

    --Проверили на корректность кол-ва
    IF COALESCE(inMovementId, 0) = 0 or COALESCE(inParentId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Не сохранен документ.';
    END IF;    


    --Проверили на корректность кол-ва
    IF COALESCE(inPossibleAnswer, '') = ''
    THEN
      RAISE EXCEPTION 'Ошибка. Не заполнен вопрос.';
    END IF;    

    --Проверили на корректность кол-ва
    IF (SELECT count(*)
        FROM MovementItem 
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ParentId = inParentId
          AND MovementItem.DescId = zc_MI_Second()) >= 4
       AND COALESCE(ioId, 0) = 0 
    THEN
      RAISE EXCEPTION 'Ошибка. Выриантов ответов должно быть не более 4.';
    END IF;    
    
    IF inisCorrectAnswer = TRUE 
       AND EXISTS(SELECT 1
                  FROM MovementItem 
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.ParentId = inParentId
                    AND MovementItem.DescId = zc_MI_Second()
                    AND MovementItem.Amount <> 0
                    AND MovementItem.Id <> COALESCE(ioId, 0))
    THEN
      UPDATE MovementItem SET Amount = 0
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.ParentId = inParentId
        AND MovementItem.DescId = zc_MI_Second()
        AND MovementItem.Amount <> 0
        AND MovementItem.Id <> COALESCE(ioId, 0);
    END IF;

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Second(), Null, inMovementId, CASE WHEN inisCorrectAnswer = TRUE THEN 1 ELSE 0 END , inParentId);

    -- сохранили свойство <Вариант ответа>
    PERFORM lpInsertUpdate_MovementItemBLOB (zc_MIBLOB_PossibleAnswer(), ioId, inPossibleAnswer);

    -- сохранили свойство <Фото ответ>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Photo(), ioId, inisPhoto);

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

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