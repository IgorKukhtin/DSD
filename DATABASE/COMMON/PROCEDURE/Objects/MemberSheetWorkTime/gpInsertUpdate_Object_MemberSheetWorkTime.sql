-- Function: gpInsertUpdate_Object_MemberSheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSheetWorkTime (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberSheetWorkTime(
 INOUT ioId             Integer   ,     -- ключ объекта <>
    IN inUnitId         Integer   ,     -- Подразделение
    IN inMemberId       Integer   ,     -- Физические лица
    IN inComment        TVarChar  ,     -- Примечание
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSheetWorkTime());


   -- проверка
   IF COALESCE (inUnitId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Подразделение> не выбрано.';
   END IF;
   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Физ.лицо> не выбрано.';
   END IF;
   
   -- проверяем на уникальность Unit + Member3
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberSheetWorkTime
                   LEFT JOIN ObjectLink AS ObjectLink_MemberSheetWorkTime_Unit
                                        ON ObjectLink_MemberSheetWorkTime_Unit.ObjectId = Object_MemberSheetWorkTime.Id
                                       AND ObjectLink_MemberSheetWorkTime_Unit.DescId = zc_ObjectLink_MemberSheetWorkTime_Unit()
        
                   LEFT JOIN ObjectLink AS ObjectLink_MemberSheetWorkTime_Member
                                        ON ObjectLink_MemberSheetWorkTime_Member.ObjectId = Object_MemberSheetWorkTime.Id
                                       AND ObjectLink_MemberSheetWorkTime_Member.DescId = zc_ObjectLink_MemberSheetWorkTime_Member()

              WHERE Object_MemberSheetWorkTime.DescId = zc_Object_MemberSheetWorkTime()
                AND ObjectLink_MemberSheetWorkTime_Unit.ChildObjectId   = inUnitId
                AND ObjectLink_MemberSheetWorkTime_Member.ChildObjectId = inMemberId
                AND Object_MemberSheetWorkTime.Id <> ioId
              )
   THEN
       RAISE EXCEPTION 'Ошибка.Запись не уникальна';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberSheetWorkTime(), 0, '');
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberSheetWorkTime_Unit(), ioId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberSheetWorkTime_Member(), ioId, inMemberId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MemberSheetWorkTime_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 18.04.18         *
*/

-- тест
-- 