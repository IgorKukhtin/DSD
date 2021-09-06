-- Function: gpGet_MainForm_isTop()

DROP FUNCTION IF EXISTS gpGet_MainForm_isTop (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send(
   OUT isMainFormTop         Boolean  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
     vbUserId := inSession;
    
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
     THEN
       isMainFormTop := True;
     ELSE
       isMainFormTop := False;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.09.21                                                       *  
*/

-- тест
-- 
SELECT * FROM gpInsertUpdate_Movement_Send (inSession:= '17489481')
