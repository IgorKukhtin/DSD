-- Function: gpInsertUpdate_Object_MemberPriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberPriceList (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberPriceList(
 INOUT ioId             Integer   ,     -- ключ объекта <>
    IN inPriceListId    Integer   ,     -- Прпйс
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
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberPriceList());


   -- проверка
   IF COALESCE (inPriceListId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Прайс лист> не выбран.';
   END IF;
   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Физ.лицо> не выбрано.';
   END IF;
   
   -- проверяем на уникальность PriceList + Member3
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberPriceList
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_PriceList
                                        ON ObjectLink_MemberPriceList_PriceList.ObjectId = Object_MemberPriceList.Id
                                       AND ObjectLink_MemberPriceList_PriceList.DescId = zc_ObjectLink_MemberPriceList_PriceList()
        
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_Member
                                        ON ObjectLink_MemberPriceList_Member.ObjectId = Object_MemberPriceList.Id
                                       AND ObjectLink_MemberPriceList_Member.DescId = zc_ObjectLink_MemberPriceList_Member()

              WHERE Object_MemberPriceList.DescId = zc_Object_MemberPriceList()
                AND ObjectLink_MemberPriceList_PriceList.ChildObjectId   = inPriceListId
                AND ObjectLink_MemberPriceList_Member.ChildObjectId = inMemberId
                AND Object_MemberPriceList.Id <> ioId
              )
   THEN
       RAISE EXCEPTION 'Ошибка.Запись не уникальна';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberPriceList(), 0, '');
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPriceList_PriceList(), ioId, inPriceListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPriceList_Member(), ioId, inMemberId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MemberPriceList_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.21         *
*/

-- тест
-- 