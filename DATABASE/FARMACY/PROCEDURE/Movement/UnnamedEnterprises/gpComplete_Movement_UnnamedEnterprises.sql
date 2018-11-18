-- Function: gpComplete_Movement_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpComplete_Movement_UnnamedEnterprises  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_UnnamedEnterprises (
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
  vbUserId:= inSession;

  IF not EXISTS(SELECT 1 FROM MovementLinkMovement
            WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
              AND MovementLinkMovement.MovementId = inMovementId)
  THEN
    RAISE EXCEPTION 'Ошибка. По безналу предприятия  не создана продежа...';
  END IF;

  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly (inMovementId);
  
  -- изменили статус
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

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
 