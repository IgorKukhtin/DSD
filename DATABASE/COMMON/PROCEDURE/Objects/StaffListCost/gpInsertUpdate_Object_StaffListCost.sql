-- Function: gpInsertUpdate_Object_StaffListCost(Integer,  TFloat, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffListCost(Integer,  TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffListCost(
 INOUT ioId                  Integer   , -- ключ объекта <Расценки штатного расписания>
    IN inPrice               TFloat    , -- Расценка грн./кг.
    IN inComment             TVarChar  , -- комментарий
    IN inStaffListId         Integer   , -- Штатное расписание
    IN inModelServiceId      Integer   , -- Модели начисления
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffListCost());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
      AND vbUserId <> 5
   THEN
        RAISE EXCEPTION 'Ошибка.%Нет прав корректировать = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffListCost())
                       ;
   END IF;

    -- проверка
   IF COALESCE (inStaffListId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Единица штатного расписания не установлена.';
   END IF;

    -- проверка
   IF COALESCE (inModelServiceId, 0) = 0 AND COALESCE (ioId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Модели начисления не установлена.';
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StaffListCost(), 0, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffListCost_Price(), ioId, inPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffListCost_Comment(), ioId, inComment);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListCost_StaffList(), ioId, inStaffListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListCost_ModelService(), ioId, inModelServiceId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_StaffListCost (0,  198, 'flgks', 5, 6, '2')
