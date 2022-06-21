-- Function: lpInsertUpdate_MovementItem_TestingUser()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, TFloat, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, TFloat, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Boolean, TFloat, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TestingUser(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inUserId              Integer   , -- Сотрудник
    IN inPassed              Boolean   , -- Результат теста
    IN inResult              TFloat    , -- Результат теста
    IN inDateTest            TDateTime , -- Дата теста
    IN inLastMonth           Boolean   , -- Сдача за предыдущий месяц
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbAttempts Integer = 0;
  DECLARE vbResult TFloat = 0;
  DECLARE vbMovement Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbDateTest TDateTime;
  DECLARE vbPositionCode Integer;
  DECLARE vbPassed Boolean;
  DECLARE text_var1 Text;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId := inSession;

  -- приводим дату к первому числу месяца
  vbOperDate := date_trunc('month', inDateTest);
  
  SELECT COALESCE(Object_Position.ObjectCode, 1)
  INTO vbPositionCode
  FROM Object AS Object_User

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

       LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                            ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                           AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                                             
  WHERE Object_User.Id = inUserId
    AND Object_User.DescId = zc_Object_User();
    
  IF NOT EXISTS(SELECT Id FROM Movement WHERE DescId = zc_Movement_TestingUser() AND OperDate = vbOperDate)
  THEN
    vbMovement := lpInsertUpdate_Movement_TestingUser(ioId          := 0,
                                                      inOperDate    := vbOperDate, -- Дата документа
                                                      inVersion     := 0,          -- Версия опроса
                                                      inQuestion    := 0,          -- Количество вопросов
                                                      inMaxAttempts := 0,          -- Количество попыток
                                                      inSession     := inSession); -- сессия пользователя
  ELSE 
     SELECT Id
     INTO vbMovement
     FROM Movement
     WHERE DescId = zc_Movement_TestingUser()
       AND OperDate = vbOperDate;
  END IF;

  IF COALESCE (vbMovement, 0) = 0
  THEN
    RAISE EXCEPTION 'Ошибка. Не создан документ за месяц';
  END IF;
  
  IF inUserId = 3
  THEN
    vbPositionCode := 2;
  END IF;

  inPassed := CASE WHEN vbPositionCode = 1 THEN inResult >= 85 ELSE inResult >= 80 END;
  

   -- Проверяем если уже есть по такому сотруднику
  IF COALESCE (ioId, 0) = 0 AND EXISTS(SELECT Id FROM MovementItem WHERE MovementId = vbMovement AND ObjectId = inUserId)
  THEN
    SELECT Id, Amount, COALESCE(MovementItemBoolean.ValueData, False), COALESCE(MovementItemFloat.ValueData, 0), COALESCE(MovementItemDate.ValueData, vbOperDate)
    INTO ioId, vbResult, vbPassed, vbAttempts, vbDateTest
    FROM MovementItem

         LEFT JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Passed()
                                      AND MovementItemBoolean.MovementItemId = MovementItem.Id

         LEFT JOIN MovementItemFloat ON MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
                                    AND MovementItemFloat.MovementItemId = MovementItem.Id

         LEFT JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                    AND MovementItemDate.DescId = zc_MIDate_TestingUser()

    WHERE MovementItem.MovementId = vbMovement
      AND MovementItem.ObjectId = inUserId;
  ELSE
    IF COALESCE (ioId, 0) <> 0
    THEN
      SELECT Amount, COALESCE(MovementItemBoolean.ValueData, False), COALESCE(MovementItemFloat.ValueData, 0), COALESCE(MovementItemDate.ValueData, vbOperDate)
      INTO vbResult, vbPassed, vbAttempts, vbDateTest
      FROM MovementItem

           LEFT JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Passed()
                                        AND MovementItemBoolean.MovementItemId = MovementItem.Id

           LEFT JOIN MovementItemFloat ON MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
                                      AND MovementItemFloat.MovementItemId = MovementItem.Id

           LEFT JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                     AND MovementItemDate.DescId = zc_MIDate_TestingUser()

      WHERE MovementItem.Id = ioId;
    ELSE
      vbResult := 0;
      vbPassed := False;
      vbAttempts := 0;
      vbDateTest := vbOperDate;
    END IF;
  END IF;

  if COALESCE (ioId, 0) = 0 OR (inPassed = True OR vbPassed = False) AND (vbDateTest < inDateTest OR COALESCE(inLastMonth, FALSE) = TRUE)
  THEN

     -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserId, vbMovement, CASE WHEN inResult > vbResult THEN inResult ELSE vbResult END, NULL);

     -- сохранили свойство <Тест сдан>
    IF inPassed = True AND vbPassed = False
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Passed(), ioId, inPassed);
    END IF;

     -- сохранили свойство <Дата теста>
    IF vbDateTest < inDateTest
    THEN
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TestingUser(), ioId, inDateTest);
    END IF;

     -- сохранили свойство <Количество попыток>
    IF vbAttempts = 0 OR vbPassed = False
    THEN 
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TestingUser_Attempts(), ioId, vbAttempts + 1);
    END IF;
    
     -- Начисляем 500 грн штрафа
/*    IF vbPositionCode = 1 AND vbPassed = False AND inPassed = False  AND COALESCE(inLastMonth, FALSE) = FALSE AND inDateTest >= '01.11.2021' AND vbAttempts = 10
    THEN
      BEGIN
        PERFORM gpUpdate_MovementItem_Wages_PenaltyExam (inOperDate := inDateTest, inUserID := inUserId, inSession := zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('lpInsertUpdate_MovementItem_TestingUser', True, text_var1::TVarChar, vbUserId);
      END;    
    END IF;*/
      
  END IF;

   -- сохранили протокол
  -- PERFORM lpInsert_MovementItemProtocol (ioId, inUserId);

  IF inUserId = 3
  THEN
    RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%> <%>', inUserId, inResult, inDateTest, inPassed, vbPassed;
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 26.01.21        *
 25.06.19        *
 15.10.18        *
 11.09.18        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_TestingUser (ioId:= 0, inUserId:= 3, inPassed := TRUE, inResult:= 80.0, inDateTest:= '20211001', inLastMonth := False, inSession:= '3')