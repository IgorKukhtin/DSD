-- Function: gpUpdate_Object_StaffList_HoursPlan(

DROP FUNCTION IF EXISTS gpUpdate_Object_StaffList_HoursPlan (Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_StaffList_HoursPlan(
    IN inId                  Integer,       -- 
    IN inHoursPlan           TFloat    , -- Общий план часов за месяц на человека
    IN inHoursPlan_new       TFloat    , -- новое значение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffList());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
   THEN
        RAISE EXCEPTION 'Ошибка.%Нет прав корректировать = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffList())
                       ;
   END IF;

   --если по ошибке указали 0 - поругаться
   IF COALESCE (inHoursPlan_new,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.запрещено устанавливать значение = 0';
   END IF;

   --проверка соответствует ли выбранный элемент условию 
   IF (SELECT OF.ValueData FROM ObjectFloat AS OF WHERE OF.DescId = zc_ObjectFloat_StaffList_HoursPlan() AND OF.ObjectId = inId) <> inHoursPlan
   THEN
       RETURN;
   END IF;
   
   -- пересохранили свойство <Общий план часов за месяц на человека>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursPlan(), inId, inHoursPlan_new);
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.04.23         * 
*/

-- тест
--