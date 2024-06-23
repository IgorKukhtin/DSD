-- Function: gpInsertUpdate_Object_ViewPriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ViewPriceList (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ViewPriceList(
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
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ViewPriceList());


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
              FROM Object AS Object_ViewPriceList
                   LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_PriceList
                                        ON ObjectLink_ViewPriceList_PriceList.ObjectId = Object_ViewPriceList.Id
                                       AND ObjectLink_ViewPriceList_PriceList.DescId = zc_ObjectLink_ViewPriceList_PriceList()
        
                   LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_Member
                                        ON ObjectLink_ViewPriceList_Member.ObjectId = Object_ViewPriceList.Id
                                       AND ObjectLink_ViewPriceList_Member.DescId = zc_ObjectLink_ViewPriceList_Member()

              WHERE Object_ViewPriceList.DescId = zc_Object_ViewPriceList()
                AND ObjectLink_ViewPriceList_PriceList.ChildObjectId = inPriceListId
                AND ObjectLink_ViewPriceList_Member.ChildObjectId = inMemberId
                AND Object_ViewPriceList.Id <> ioId
              )
   THEN
       RAISE EXCEPTION 'Ошибка.Запись не уникальна';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ViewPriceList(), 0, '');
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ViewPriceList_PriceList(), ioId, inPriceListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ViewPriceList_Member(), ioId, inMemberId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ViewPriceList_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.24         *
*/

-- тест
-- 