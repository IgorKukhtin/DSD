-- Function: gpUpdate_Movement_Send_UnCompleteView

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_UnCompleteView (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_UnCompleteView(
    IN inId               Integer,   -- Перемещение
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbComent TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Разрешено только администратору.';
   END IF;

   IF COALESCE ((SELECT Movement_Send.StatusId
                 FROM Movement AS Movement_Send
                 WHERE Movement_Send.Id = inID
                   AND Movement_Send.DescId = zc_Movement_Send()), 0) = zc_Enum_Status_Erased()
   THEN
     PERFORM gpUnComplete_Movement_Send (inMovementId := inID, inSession := inSession);
   END IF;
    
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.01.20                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Send_UnCompleteView (inMovementId:= 1, inSession := '3');
