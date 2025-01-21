-- Function: gpInsertUpdate_Object_MemberPersonalServiceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberPersonalServiceList (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberPersonalServiceList(
 INOUT ioId                            Integer   ,     -- ключ объекта <>
    IN inPersonalServiceListId         Integer   ,     -- 
    IN inMemberId                      Integer   ,     -- Физические лица
 INOUT ioIsAll                         Boolean   , 
    IN inComment                       TVarChar  ,     -- Примечание
    IN inSession                       TVarChar        -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSheetWorkTime());

   IF COALESCE (ioId,0) = -1
   THEN
        RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;

   -- проверка
   IF COALESCE (inPersonalServiceListId, 0) = 0 AND COALESCE (ioIsAll, FALSE) = FALSE
   THEN
      RAISE EXCEPTION 'Ошибка.<Ведомость начисления> не выбрана.';
   END IF;
   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Физ.лицо> не выбрано.';
   END IF;
   
   --Замена, если выбрана ведомость достут всем = False
   IF COALESCE (inPersonalServiceListId, 0) <> 0
   THEN 
       ioIsAll := False;
   END IF;
   
   -- проверяем на уникальность PersonalServiceList + Member3
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberPersonalServiceList
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                        ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                       AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
        
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                        ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                       AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_All
                                           ON ObjectBoolean_All.ObjectId = Object_MemberPersonalServiceList.Id
                                          AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberPersonalServiceList_All()

              WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                AND (COALESCE (ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId, 0) = inPersonalServiceListId OR ioIsAll = TRUE)
                AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = inMemberId
                AND COALESCE (ObjectBoolean_All.ValueData, False) = ioIsAll
                AND Object_MemberPersonalServiceList.Id <> ioId
              )
   THEN
       RAISE EXCEPTION 'Ошибка.Запись не уникальна';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberPersonalServiceList(), 0, '');
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList(), ioId, inPersonalServiceListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPersonalServiceList_Member(), ioId, inMemberId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MemberPersonalServiceList_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_MemberPersonalServiceList_All(), ioId, ioIsAll);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 05.07.18         *
*/

-- тест
-- 