--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CashChild_Load (Integer, Integer, Integer, Integer, Integer, Integer
                                                         , TFloat, TVarChar
                                                         , TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CashChild_Load(
    IN inKassaCode            Integer,       -- код
    IN inInfoMoneyCode        Integer,
    IN inInfoMoneyAddCode     Integer,
    IN inUnitCode             Integer,
    IN inCommentInfoMoneyCode Integer,
    IN inUserId               Integer,       -- Id пользователя
    IN inSumma                TFloat,        --
    IN inInvNumber            TVarChar,      --  
    IN inOperDate             TDateTime,     -- 
    IN inProtocolDate         TDateTime,     -- дата протокола
    IN inDateAdditional       TDateTime,     -- 
    IN inSession              TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentInfoMoneyId Integer;
  DECLARE vbCashId            Integer;
  DECLARE vbInfoMoneyId        Integer;
  DECLARE vbInfoMoneyDetailId  Integer;
  DECLARE vbUnitId             Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbMovementItemId_sign   Integer;
  DECLARE vbisSign Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1 THEN 5
                            WHEN inUserId = 6 THEN 139  -- zfCalc_UserMain_1()
                            WHEN inUserId = 7 THEN 2020 -- zfCalc_UserMain_2()
                            WHEN inUserId = 10 THEN 40561
                            WHEN inUserId = 11 THEN 40562
                       END;


   IF COALESCE (inInvNumber,'') <> '' -- AND EXISTS (SELECT 1 FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Cash() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
        
       IF COALESCE (inCommentInfoMoneyCode,0) <> 0
       THEN
           -- поиск в спр. 
           vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentInfoMoney() AND Object.ObjectCode = inCommentInfoMoneyCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbCommentInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Примечание Приход / Расход <%>   .', inCommentInfoMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inKassaCode,0) <> 0
       THEN
           -- поиск в спр.
           vbCashId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inKassaCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbCashId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Касса с кодом <%>   .', inKassaCode;
           END IF;
       END IF;
    
       IF COALESCE (inInfoMoneyCode,0) <> 0
       THEN
           -- поиск в спр.
           vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inInfoMoneyCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Статья с кодом <%>   .', inInfoMoneyCode;
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

       IF COALESCE (inInfoMoneyAddCode,0) <> 0
       THEN
           -- поиск в спр.
           vbInfoMoneyDetailId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyDetail() AND Object.ObjectCode = inInfoMoneyAddCode);
    
           -- Eсли не нашли ошибка
           IF COALESCE (vbInfoMoneyDetailId,0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден элемент справочника Детально Приход/расход с кодом <%>   .', inInfoMoneyAddCode;
           END IF;
       END IF; 
   
    
          -- Поиск
          vbMovementId    := (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Cash() AND Movement.StatusId <> zc_Enum_Status_Erased());
          -- Поиск
          vbMovementItemId:= (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = vbMovementId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE);

          -- сохранили <Элемент документа>
          vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Child(), vbCashId, vbMovementId, inSumma, NULL);
     
          -- сохранили связь с <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, vbUnitId);
          -- сохранили связь с <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, vbInfoMoneyId);
          -- сохранили связь с <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoneyDetail(), vbMovementItemId, vbInfoMoneyDetailId);
          -- сохранили связь с <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, vbCommentInfoMoneyId);
     
          -- сохранили свойство <Дата начисления>
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, DATE_TRUNC ('MONTH', inDateAdditional));
     
          -- 
          IF EXISTS (SELECT 1 FROM MovementBoolean WHERE MovementBoolean.MovementId = vbMovementId AND MovementBoolean.DescId = zc_MovementBoolean_Sign() AND MovementBoolean.ValueData = TRUE)
          THEN
              PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Master(), vbMovementItemId, TRUE);
          ELSE
              PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Master(), vbMovementItemId, FALSE);
          END IF;
      
           -- сохранили свойство <Дата корректировки>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), vbMovementId, inProtocolDate);
          -- сохранили свойство <Пользователь (корректировка)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), vbMovementId, vbUserProtocolId);


   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.21          *
*/

-- тест
--