-- Function: gpSelect_Object_CommentSend_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpSelect_Object_CommentSend_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentSend_IsErased(
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
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND (RoleId IN (zc_Enum_Role_Admin(), 13536335 )))
   THEN
      RAISE EXCEPTION 'Ошибка.Изменение признака удаления разрешено только администратору.';
   END IF;

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CommentSend_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.08.20                                                       *
*/
