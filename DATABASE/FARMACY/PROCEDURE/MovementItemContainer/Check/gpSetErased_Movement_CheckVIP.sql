DROP FUNCTION IF EXISTS gpSetErased_Movement_CheckVIP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_CheckVIP(
    IN inMovementId        Integer               , -- ключ Документа
    IN inCancelReasonId    Integer               , -- Причина отказа для сайта
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId          Integer;
  DECLARE vbCheckSourceKind Integer;
  DECLARE vbInvNumberOrder  TVarChar;
BEGIN
    --Если документ уже проведен то проверим права
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    vbCheckSourceKind := (SELECT MovementLinkObject.ObjectId  FROM MovementLinkObject
                          WHERE MovementLinkObject.DescId = zc_MovementLinkObject_CheckSourceKind()
                            AND MovementLinkObject.MovementID = inMovementId);
                            
    vbInvNumberOrder := COALESCE((SELECT MovementString_InvNumberOrder.ValueData 
                                  FROM MovementString AS MovementString_InvNumberOrder
                                  WHERE MovementString_InvNumberOrder.MovementId = inMovementId
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()), '');

    IF COALESCE (vbCheckSourceKind, 0) = zc_Enum_CheckSourceKind_Tabletki() OR vbInvNumberOrder <> ''
    THEN
       IF COALESCE (inCancelReasonId, 0) = 0
       THEN
        RAISE EXCEPTION 'Ошибка. При удалении VIP чека загруженного с <%> надо указать причину отказа. Для удаления используйте соседнюю кнопку.  ',
          COALESCE((SELECT Object.ValueData FROM Object WHERE Object.ID = vbCheckSourceKind), 'Не болей');
       END IF;
       PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CancelReason(), inMovementId, inCancelReasonId);
    ELSE
       IF COALESCE (inCancelReasonId, 0) <> 0
       THEN
        RAISE EXCEPTION 'Ошибка. При удалении VIP чеков не надо указать причину отказа. Для удаления используйте соседнюю кнопку.';
       END IF;
    END IF;
   
    -- Удаляем Документ
    PERFORM gpSetErased_Movement_Check (inMovementId := inMovementId
                                      , inSession     := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.09.20                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_CheckVIP (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())