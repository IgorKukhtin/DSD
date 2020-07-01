-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoAdvertising (
    Integer    , -- Ключ объекта <Рекламная поддержка>
    Integer    , -- Ключ родительского объекта <Документ акции>
    Integer    , -- Рекламная поддержка
    TVarChar   , -- Примечание
    TVarChar     -- сессия пользователя
);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoAdvertising(
 INOUT ioId                    Integer    , -- Ключ объекта <партнер для документа акции>
    IN inParentId              Integer    , -- Ключ родительского объекта <Документ акции>
    IN inAdvertisingId         Integer    , -- Ключ объекта <Рекламная поддержка>
    IN inComment               TVarChar   , -- Примечание
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer AS
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
        lpInsertUpdate_Movement (ioId, zc_Movement_PromoAdvertising(), Movement_Promo.InvNumber, Movement_Promo.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    -- сохранили связь с <Рекламная поддержка>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Advertising(), ioId, inAdvertisingId);
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 17.11.15                                                                    *inContractId
 31.10.15                                                                    *
*/