-- Function: gpSetErased_Movement_Income (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Income(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Income());

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

     -- обнулили - КОЛ-ВО
     UPDATE Object_PartionGoods SET Amount = 0, isErased = TRUE, isArc = TRUE
     WHERE Object_PartionGoods.MovementId = inMovementId
    ;

    IF EXISTS (SELECT 1 FROM  Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND (Object_PartionGoods.isErased <> TRUE OR Object_PartionGoods.Amount <> 0 OR Object_PartionGoods.isArc <> TRUE))
    THEN
        RAISE EXCEPTION 'Ошибка.Не удалены <%> элеиентов.', (SELECT COUNT(*) FROM  Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND (Object_PartionGoods.isErased <> TRUE OR Object_PartionGoods.Amount <> 0 OR Object_PartionGoods.isArc <> TRUE));
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 25.04.17         *
*/
