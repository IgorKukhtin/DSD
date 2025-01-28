-- Function: gpUpdateObjectIsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdateObjectIsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObjectIsErased(
    IN inObjectId Integer, 
    IN Session    TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
BEGIN
   -- НЕТ проверки прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (Session);
   
   
   --
   vbDescId:= (SELECT Object.DescId FROM Object WHERE Object.Id = inObjectId);


   -- проверка
   IF COALESCE (inObjectId, 0) <= 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не найден.';
   END IF;


   IF vbUserId IN (5, 9457) AND 1=1
   THEN 
       RAISE EXCEPTION 'Ошибка.%Нет прав удалять = <%>.'
                          , CHR (13)
                          , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = vbDescId)
                           ;
   END IF;


   -- проверка прав пользователя
   IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId = zc_Object_ArticleLoss())
   THEN
       PERFORM lpCheckRight (Session, zc_Enum_Process_Update_Object_isErased_ArticleLoss());
   END IF;

----  для ModelService и StaffList проверка  прав по RoleAccessKey
   IF vbDescId IN (zc_Object_ModelService(), zc_Object_ModelServiceItemMaster(), zc_Object_ModelServiceItemChild())
   THEN
       IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_ModelService())
       THEN
            RAISE EXCEPTION 'Ошибка.%Нет прав удалять = <%>.'
                          , CHR (13)
                          , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = vbDescId)
                           ;
       END IF;
   END IF;

   IF vbDescId IN (zc_Object_StaffList(), zc_Object_StaffListCost(), zc_Object_StaffListSumm())
   THEN
       IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
       THEN
            RAISE EXCEPTION 'Ошибка.%Нет прав удалять = <%>.'
                          , CHR (13)
                          , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = vbDescId)
                           ;
       END IF;
   END IF;
----


   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdateObjectIsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.08.21         * 
 08.05.14                                        * add lpUpdate_Object_isErased
 25.02.14                                        *
*/
