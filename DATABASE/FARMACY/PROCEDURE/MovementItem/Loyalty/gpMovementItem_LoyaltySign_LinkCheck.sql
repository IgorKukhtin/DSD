-- Function: gpMovementItem_LoyaltySign_LinkCheck()

DROP FUNCTION IF EXISTS gpMovementItem_LoyaltySign_LinkCheck (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_LoyaltySign_LinkCheck(  
    IN inId                  Integer   , -- ID промокода
    IN inCheckID             Integer   , -- ID чека
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
   vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Связать промокод с чеком вам запрещено, обратитесь к системному администратору';
   END IF;

   UPDATE movementitem SET parentid = inCheckID where ID = inId;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.11.19                                                       *
 */

-- zfCalc_FromHex

-- SELECT * FROM gpMovementItem_LoyaltySign_LinkCheck (0, 16406918, '3');