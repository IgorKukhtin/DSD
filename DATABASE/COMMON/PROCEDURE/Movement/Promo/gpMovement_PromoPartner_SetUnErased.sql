-- Function: gpMovement_PromoPartner_SetUnErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovement_PromoPartner_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovement_PromoPartner_SetUnErased(
    IN inMovementId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased       Boolean              , -- новое значение
    IN inSession         TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_PromoGoods());
    vbUserId := lpGetUserBySession (inSession);


    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId)
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- устанавливаем новое значение
    outIsErased := FALSE;

    -- Обязательно меняем
    UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Id = inMovementId
    RETURNING ParentId INTO vbMovementId;

    -- проверка - связанные документы Изменять нельзя
    -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= 'изменение');

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovement_PromoPartner_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.  Воробкало А.А.
 05.11.15                                                                      *
*/