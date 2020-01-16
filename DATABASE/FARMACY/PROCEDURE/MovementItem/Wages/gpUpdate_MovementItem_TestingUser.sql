-- Function: gpUpdate_MovementItem_TestingUser()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_TestingUser(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_TestingUser(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inTestingUser         Integer   , -- Действие
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbUserWagesId Integer;
   DECLARE vbPosition Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Не определено ID выдачи зарплаты.';
    END IF;

    IF NOT EXISTS(SELECT 1 FROM MovementItem
                  WHERE MovementItem.ID = inId
                    AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение результатов экзамена разрешено только фармацевтам..';
    END IF;

    -- Получаем vbMovementId
    SELECT MovementItem.MovementId, MovementItem.ObjectID, COALESCE (ObjectLink_Member_Position.ChildObjectId, 0)
    INTO vbMovementId, vbUserWagesId, vbPosition
    FROM MovementItem
         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                              ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                             AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
    WHERE MovementItem.ID = inId
      AND MovementItem.DescId = zc_MI_Master();

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF vbPosition <> 1672498
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение результатов экзамена разрешено только фармацевтам.';
    END IF;

    IF inTestingUser = 0
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isTestingUser(), inId, False);
    ELSEIF  inTestingUser = 1
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isTestingUser(), inId, True);
    ELSEIF  inTestingUser = 2
    THEN
      IF EXISTS(SELECT * FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemID = inId AND MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser())
      THEN
        DELETE FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemID = inId AND MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser();
      END IF;
    ELSE
      RAISE EXCEPTION 'Ошибка. Неизвестный тип действия.';
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.01.20                                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_TestingUser (, inSession:= '2')
