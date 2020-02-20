-- Function: gpUnhook_MovementItem_Loyalty_Parent()

DROP FUNCTION IF EXISTS gpUnhook_MovementItem_Loyalty_Parent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnhook_MovementItem_Loyalty_Parent(
    IN inId                  Integer   , -- Ключ объекта <Документ>
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
     RAISE EXCEPTION 'Открепить промокод от регистрации вам запрещено, обратитесь к системному администратору';
   END IF;
    
    -- сохранили
   update  MovementItem set parentID = Null where ID = inId;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/