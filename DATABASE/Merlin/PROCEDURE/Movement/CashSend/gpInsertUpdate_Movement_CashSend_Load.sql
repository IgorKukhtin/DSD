--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CashSend_Load (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CashSend_Load(
    IN inFromKassaCode        Integer,       -- код
    IN inToKassaCode          Integer,
    IN inCommentMoveMoneyCode Integer,
    IN inUserId               Integer,       -- Id пользователя
    IN inSummaFrom            TFloat,        --
    IN inSummaTo              TFloat,        --
    IN inKurs                 TFloat,        --
    IN inNominalKurs          TFloat,        --
    IN inInvNumber            TVarChar,      --  
    IN inOperDate             TDateTime,     -- 
    IN inProtocolDate         TDateTime,     -- дата протокола
    IN inSession              TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentMoveMoneyId Integer;
  DECLARE vbFromKassaId      Integer;
  DECLARE vbToKassaId        Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1 THEN 5
                            WHEN inUserId = 6 THEN 139  -- zfCalc_UserMain_1()
                            WHEN inUserId = 7 THEN 2020 -- zfCalc_UserMain_2()
                            WHEN inUserId = 10 THEN 40561
                            WHEN inUserId = 11 THEN 40562
                       END;


   -- Проверка
   IF 1 < (SELECT COUNT(*) FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_CashSend() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       RAISE EXCEPTION 'Ошибка.Найдено несколько inInvNumber = <%>', inInvNumber;
   END IF;

   -- Поиск
   vbMovementId:= (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_CashSend() AND Movement.StatusId <> zc_Enum_Status_Erased());
   -- Поиск
   vbMovementItemId := (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = vbMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE);

   -- Если Проведен
   IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = vbMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
   THEN
       -- Распровели
       PERFORM lpUnComplete_Movement (vbMovementId, vbUserId);
   END IF;
   
   -- Сохранение
   IF COALESCE (inInvNumber,'') <> '' -- AND NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_CashSend() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       
       IF COALESCE (inCommentMoveMoneyCode,0) <> 0
       THEN
           -- поиск в спр. 
           vbCommentMoveMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentMoveMoney() AND Object.ObjectCode = inCommentMoveMoneyCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbCommentMoveMoneyId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Примечание Движение денег с кодом <%>   .', inCommentMoveMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inFromKassaCode,0) <> 0
       THEN
           -- поиск в спр.
           vbFromKassaId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inFromKassaCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbFromKassaId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Касса с кодом <%>   .', inFromKassaCode;
           END IF;
       END IF;
    
       IF COALESCE (inToKassaCode,0) <> 0
       THEN
           -- поиск в спр.
           vbToKassaId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inToKassaCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbToKassaId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Касса с кодом <%>   .', inToKassaCode;
           END IF;
       END IF; 
       
           -- сохранили <Документ>
         vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_CashSend(), inInvNumber, inOperDate, Null, vbUserProtocolId);
    
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), vbMovementId, inKurs);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), vbMovementId, inNominalKurs);
    
         -- сохранили <Элемент документа>
         vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbFromKassaId, vbMovementId, inSummaFrom, NULL);
    
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Cash(), vbMovementItemId, vbToKassaId);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentMoveMoney(), vbMovementItemId, vbCommentMoveMoneyId);
          
          -- сохранили свойство <Дата создания>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId, inProtocolDate ::TDateTime);
          -- сохранили свойство <Пользователь (создание)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), vbMovementId, vbUserProtocolId);

          -- Проводки
          PERFORM lpComplete_Movement_CashSend (vbMovementId  -- ключ Документа
                                              , vbUserId      -- Пользователь
                                               );

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.21          *
*/

-- тест
--