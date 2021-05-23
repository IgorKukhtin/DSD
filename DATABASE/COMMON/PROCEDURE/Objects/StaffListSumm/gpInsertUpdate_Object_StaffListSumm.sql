-- Function: gpInsertUpdate_Object_StaffListSumm(Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffListSumm(Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffListSumm(
 INOUT ioId                  Integer   , -- ключ объекта <Штатное расписание>
    IN inValue               TFloat    , -- Сумма, грн
    IN inComment             TVarChar  , -- комментарий
    IN inStaffListId         Integer   , -- Штатное расписание
    IN inStaffListMasterId   Integer   , -- Штатное расписание (сумма из "Главного" является базой для текущего)
    IN inStaffListSummKindId Integer   , -- Типы сумм для штатного расписания
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
--raise exception '%', inStaffListId;
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffListSumm());
   vbUserId:= lpGetUserBySession (inSession);

   
    -- проверка
   IF COALESCE (inStaffListId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка! Единица штатного расписания не установлена!';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StaffListSumm(), 0, '');
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffListSumm_Value(), ioId, inValue);
   -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffListSumm_Comment(), ioId, inComment);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListSumm_StaffList(), ioId, inStaffListId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListSumm_StaffListMaster(), ioId, inStaffListMasterId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListSumm_StaffListSummKind(), ioId, inStaffListSummKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_StaffListSumm (Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_StaffListSumm (0, 1000, 'StaffListSumm', 1, 5, 6, '2')
    