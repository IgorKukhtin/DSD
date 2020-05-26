-- Function: gpUpdate_Object_DriverSun_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_Object_DriverSun_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DriverSun_IsErased(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   vbUserId:= inSession;
  
    -- Разрешаем только сотрудникам с правами админа    
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Удаление а востановление вам запрещено, обратитесь к системному администратору';
   END IF;
    
   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_DriverSun_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.05.20                                                       *
*/
	