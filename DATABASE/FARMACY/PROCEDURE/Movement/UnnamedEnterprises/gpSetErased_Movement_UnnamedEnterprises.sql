-- Function: gpSetErased_Movement_UnnamedEnterprises (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_UnnamedEnterprises (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_UnnamedEnterprises(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    vbUserId := inSession;

    IF EXISTS(SELECT 1 FROM MovementLinkMovement
              WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
                AND MovementLinkMovement.MovementId = inMovementId)
    THEN
      RAISE EXCEPTION 'Ошибка. По безналу предприятия создана продежа <%> от <%>...',
        (SELECT Movement.InvNumber
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
           AND MovementLinkMovement.MovementId = inMovementId),
        (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
           AND MovementLinkMovement.MovementId = inMovementId);
    END IF;

  -- изменили статус
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());

  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Шаблий О.В.
 18.11.18                                                                        *
 */
