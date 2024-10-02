-- Function: gpInsertUpdate_Movement_InfoMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_InfoMoney (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_InfoMoney(
 INOUT ioId                     Integer    , -- Ключ объекта <партнер для документа акции>
    IN inParentId               Integer    , -- Ключ родительского объекта <Документ акции>
    IN inInfoMoneyId            Integer    , 
    IN inDescId                 Integer    , -- 
    IN inSession                TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := lpGetUserBySession (inSession);


    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inParentId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );
    --проверка вдруг уже создан док.
    ioId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_InfoMoney());
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --проверили сохранен ли документ 
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен или не находится в состоянии <Не проведен>.';
    END IF;
        
    
    -- сохранили <Документ>
    SELECT
        lpInsertUpdate_Movement (ioId, zc_Movement_InfoMoney(), Movement_Promo.InvNumber, Movement_Promo.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (inDescId, ioId, inInfoMoneyId);
    -- сохранили связь с <>
    --PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney_Market(), ioId, inInfoMoneyId_Market);
        
   
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.24         *
*/
