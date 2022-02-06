-- Function: gpUpdate_ReasonDifferences_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_ReasonDifferences_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ReasonDifferences_IsErased(
    IN inObjectId Integer, 
    IN Session    TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- НЕТ проверки прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (Session);

   -- проверка - проведенные/удаленные документы Изменять нельзя
   IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
      RAISE EXCEPTION 'Ошибка.Удалять <Причины разногласия> вам запрещено.';
   END IF;

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_ReasonDifferences_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.08.20                                                       *
*/
