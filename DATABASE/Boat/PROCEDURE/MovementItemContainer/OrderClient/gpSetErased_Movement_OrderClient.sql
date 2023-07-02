-- Function: gpSetErased_Movement_OrderClient (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderClient (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderClient(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderClient());

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- Удаляем Лодку
    PERFORM lpUpdate_Object_isErased (inObjectId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product())
                                    , inIsErased:= TRUE
                                    , inUserId  := vbUserId
                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/
