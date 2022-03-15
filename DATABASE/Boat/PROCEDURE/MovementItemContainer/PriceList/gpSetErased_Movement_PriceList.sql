-- Function: gpSetErased_Movement_PriceList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PriceList(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PriceList());
    vbUserId:= lpGetUserBySession (inSession);

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.22         *
*/
