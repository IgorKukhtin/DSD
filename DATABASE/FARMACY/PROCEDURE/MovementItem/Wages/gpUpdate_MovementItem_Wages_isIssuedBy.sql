-- Function: gpUpdate_MovementItem_Wages_isIssuedBy()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_isIssuedBy(INTEGER, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_isIssuedBy(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inisIssuedBy          Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbisWagesCheckTesting Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
    END IF;

    -- определяем <Статус>
    SELECT Movement.StatusId, Movement.OperDate
    INTO vbStatusId, vbOperDate
    FROM Movement 
    WHERE Id = (SELECT MovementItem.MovementID FROM MovementItem WHERE MovementItem.ID = inId);
    
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    SELECT COALESCE(ObjectBoolean_CashSettings_WagesCheckTesting.ValueData, FALSE)  AS isWagesCheckTesting
    INTO vbisWagesCheckTesting
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_WagesCheckTesting
                                 ON ObjectBoolean_CashSettings_WagesCheckTesting.ObjectId = Object_CashSettings.Id 
                                AND ObjectBoolean_CashSettings_WagesCheckTesting.DescId = zc_ObjectBoolean_CashSettings_WagesCheckTesting()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;

    IF vbisWagesCheckTesting = TRUE AND inisIssuedBy = FALSE AND vbOperDate >= '01.10.2019'  AND (
           EXISTS(SELECT MovementItem.ObjectId 
                  FROM MovementItem 
                       INNER JOIN ObjectLink AS ObjectLink_User_Member
                                             ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       INNER JOIN ObjectLink AS ObjectLink_Member_Position
                                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                       INNER JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                  WHERE MovementItem.ID = ioId
                    AND (Object_Position.ObjectCode = 1 OR Object_Position.ObjectCode = 2 AND vbOperDate >= '01.12.2021')) AND
       NOT EXISTS(SELECT 1
                  FROM Movement

                       LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                              AND MovementItem.DescId = zc_MI_Master()

                       LEFT JOIN MovementItemBoolean AS MIBoolean_Passed
                                                     ON MIBoolean_Passed.DescId = zc_MIBoolean_Passed()
                                                    AND MIBoolean_Passed.MovementItemId = MovementItem.Id

                  WHERE Movement.DescId = zc_Movement_TestingUser()
                    AND Movement.OperDate = (SELECT Movement.OperDate 
                                             FROM MovementItem 
                                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId 
                                             WHERE MovementItem.ID = inId)
                    AND MovementItem.ObjectId = (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.ID = inId)
                    AND COALESCE(MIBoolean_Passed.ValueData, False) = True) AND
       (COALESCE((SELECT MovementItemBoolean.ValueData FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemID = inId AND 
                 MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser()), TRUE) = FALSE))
                    
    THEN
      RAISE EXCEPTION 'Ошибка. Сотрудник не сдал экзамен. Выдача зарплаты запрещена.';            
    END IF;

     -- сохранили свойство <Выдано>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), inId, NOT inisIssuedBy);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Wages_isIssuedBy (, inSession:= '2')