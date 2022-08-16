-- Function: gpSetErased_Movement_ServiceItemAdd (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ServiceItemAdd (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ServiceItemAdd(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- Проверка - Если Корректировка подтверждена
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION 'Ошибка.Корректировка подтверждена.Изменения невозможны.';
     END IF;

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- Восстанавливаем данные в начислениях
     PERFORM lpUpdate_Movement_Service_restore (inMovementId_sia:= inMovementId
                                              , inUserId         := vbUserId
                                               );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.22         *
*/
