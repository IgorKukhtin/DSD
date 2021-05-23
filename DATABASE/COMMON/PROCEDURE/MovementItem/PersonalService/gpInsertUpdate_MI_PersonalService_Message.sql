-- Function: gpInsertUpdate_MI_PersonalService_Message()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Message (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Message (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Message (Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Message(
 INOUT ioId                  Integer   , -- 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId_Top          Integer   ,
 INOUT ioUserId              Integer   ,
    IN inIsQuestion          Boolean   ,
    IN inIsAnswer            Boolean   ,
    IN inIsQuestionRead      Boolean   ,
    IN inIsAnswerRead        Boolean   ,
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbIsInsert Boolean;
  DECLARE vbAmount   TFloat;
  DECLARE vbAmountOld TFloat;
  DECLARE vbIsQuestionRead   Boolean;
  DECLARE vbIsAnswerRead     Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);

     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     vbAmount := (CASE WHEN inIsQuestion = TRUE AND inIsQuestionRead = FALSE THEN 1
                       WHEN inIsAnswer = TRUE   AND inIsAnswerRead   = FALSE THEN 2
                       WHEN inIsQuestionRead = TRUE THEN 3
                       WHEN inIsAnswerRead   = TRUE THEN 4
                       ELSE 0
                  END);
     
     vbAmountOld := COALESCE ((SELECT MovementItem.Amount
                               FROM MovementItem
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.Id = ioId
                               ), 0);

     --проверка если в amount 3 - т.е. вопрос прочитан, то естественно он был и отправлен, и показываются обе галки, тоже самое с 2 и 4
     IF (vbAmountOld = 1 AND (inIsAnswer = TRUE OR inIsAnswerRead = TRUE)) OR (vbAmountOld = 0 AND inIsAnswerRead = TRUE)
     THEN 
          RAISE EXCEPTION 'Ошибка.Вопрос отправлен - должно соответствовать - Вопрос прочитан.';
     END IF;
     IF (vbAmountOld = 2 AND (inIsQuestion = TRUE OR inIsQuestionRead = TRUE)) OR (vbAmountOld = 0 AND inIsQuestionRead = TRUE)
     THEN 
          RAISE EXCEPTION 'Ошибка.Ответ отправлен - должно соответствовать - Ответ прочитан.';
     END IF;
     
     IF vbAmountOld = 3 AND  (inIsAnswer = TRUE OR inIsAnswerRead = TRUE)
     THEN 
          RAISE EXCEPTION 'Ошибка.Вопрос отправлен - должно соответствовать - Вопрос прочитан.';
     END IF;
     IF vbAmountOld = 4 AND (inIsQuestion = TRUE OR inIsQuestionRead = TRUE)
     THEN 
          RAISE EXCEPTION 'Ошибка.Ответ отправлен - должно соответствовать - Ответ прочитан.';
     END IF;    
     
     -- проверка  - убирать галку 1 и 2 нельзя если уже есть 3 или 4
     --IF (vbAmountOld = 3 AND inIsQuestion = FALSE) OR (vbAmountOld = 4 AND inIsAnswer = TRUE)
     --THEN 
     --     RAISE EXCEPTION 'Ошибка.Нельзя снять отметку об отправлении.';
     --END IF;
     
     IF COALESCE (ioUserId, 0) = 0 
     THEN
         IF vbAmount = 2                                       -- когда пишется ответ
         THEN
             ioUserId := (SELECT COALESCE (MILO_Update.ObjectId, MILO_Insert.ObjectId) AS UserId
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                                ON MILO_Insert.MovementItemId = MovementItem.Id
                                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                               LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                                ON MILO_Update.MovementItemId = MovementItem.Id
                                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Message()
                            AND MovementItem.Amount     = 1     -- кто завадал вопрос
                            AND MovementItem.isErased   = FALSE
                          ORDER BY MovementItem.Id DESC
                          LIMIT 1);
         ELSE
             
             ioUserId := COALESCE ((SELECT ObjectLink_User_Member.ObjectId AS UserId
                                    FROM ObjectLink AS ObjectLink_User_Member
                                    WHERE ObjectLink_User_Member.ChildObjectId = inUserId_Top 
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member())
                                    , 0);
             
         END IF;
     END IF;

     -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), ioUserId, inMovementId, vbAmount, NULL);
   
     IF vbAmountOld = 0
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     END IF;
         

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     IF (vbAmountOld <> vbAmount AND vbAmount IN (3, 4))
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, CURRENT_TIMESTAMP);
     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 20.09.17         *
*/

-- тест
--select * from gpInsertUpdate_MI_PersonalService_Message(ioId := 0 , inMovementId := 5285316 , inUserId := 0 , inisQuestion := 'False' , inisAnswer := 'False' , inisQuestionRead := 'False' , inisAnswerRead := 'False' , inComment := 'зшрошгпопмго' ,  inSession := '5');
