--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service_Load (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service_Load(
    IN inCommentInfoMoneyCode Integer,       -- код
    IN inInfoMoneyCode        Integer,
    IN inUnitCode             Integer,
    IN inUserId               Integer,       -- Id пользователя
    IN inSumma                TFloat,        --
    IN inInvNumber            TVarChar,      --  
    IN inisAuto               TVarChar,      -- 
    IN inOperDate             TDateTime,     -- 
    IN inServiceDate          TDateTime,     -- 
    IN inProtocolDate         TDateTime,     -- дата протокола
    IN inSession              TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentInfoMoneyId Integer;
  DECLARE vbInfoMoneyId      Integer;
  DECLARE vbUnitId           Integer;
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
   IF 1 < (SELECT COUNT(*) FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       RAISE EXCEPTION 'Ошибка.Найдено несколько inInvNumber = <%>', inInvNumber;
   END IF;

   -- Поиск
   vbMovementId:= (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId <> zc_Enum_Status_Erased());
   -- Поиск
   vbMovementItemId := (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = vbMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE);

   -- Если Проведен
   IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = vbMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
   THEN
       -- Распровели
       PERFORM lpUnComplete_Movement (vbMovementId, vbUserId);
   END IF;
   
   -- Сохранение
   IF COALESCE (inInvNumber,'') <> '' --AND NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       
       IF COALESCE (inCommentInfoMoneyCode,0) <> 0
       THEN
           -- поиск в спр. 
           vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentInfoMoney() AND Object.ObjectCode = inCommentInfoMoneyCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbCommentInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Примечание Приход/расход с кодом <%>   .', inCommentInfoMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inInfoMoneyCode,0) <> 0
       THEN
           -- поиск в спр.
           vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inInfoMoneyCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Статьи Приход/расход с кодом <%>   .', inInfoMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inUnitCode,0) <> 0
       THEN
           -- поиск в спр.
           vbUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = inUnitCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbUnitId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Отделы с кодом <%>   .', inUnitCode;
           END IF;
       END IF;
          -- сохранили <Документ>
          vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_Service(), inInvNumber, inOperDate, Null, vbUserProtocolId);
     
          ---
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, CASE WHEN inisAuto = 'Да' THEN TRUE ELSE FALSE END);

          -- сохранили <Элемент документа>
          vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbUnitId, vbMovementId, inSumma, NULL);
     
          -- сохранили связь с <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, vbInfoMoneyId);
          -- сохранили связь с <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, vbCommentInfoMoneyId);
     
          -- сохранили свойство <Дата начисления>
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);
     
          -- сохранили свойство <Дата создания>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId, inProtocolDate ::TDateTime);
          -- сохранили свойство <Пользователь (создание)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), vbMovementId, vbUserProtocolId);

          -- Проводки
          PERFORM lpComplete_Movement_Service (vbMovementId  -- ключ Документа
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
 03.02.21          *
*/

-- тест
--