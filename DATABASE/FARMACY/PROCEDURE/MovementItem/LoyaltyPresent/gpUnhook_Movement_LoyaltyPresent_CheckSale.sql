-- Function: gpUnhook_Movement_LoyaltyPresent_CheckSale()

DROP FUNCTION IF EXISTS gpUnhook_Movement_LoyaltyPresent_CheckSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnhook_Movement_LoyaltyPresent_CheckSale(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession;
    
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Открепить промокод от чека погашения вам запрещено, обратитесь к системному администратору';
   END IF;


   IF COALESCE(inMovementId, 0)  <> 0
   THEN
       -- сохранили
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), inMovementId, 0);
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.02.20                                                       *
*/