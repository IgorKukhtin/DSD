-- Function: gpInsertUpdate_Object_Partner_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_Sybase (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner_Sybase(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inName                TVarChar  ,    -- <Контрагент> 
    IN inAddress             TVarChar  ,    -- Адрес точки доставки
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inPrepareDayCount     TFloat    ,    -- За сколько дней принимается заказ
    IN inDocumentDayCount    TFloat    ,    -- Через сколько дней оформляется документально
    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inRouteId             Integer   ,    -- Маршрут
    IN inRouteSortingId      Integer   ,    -- Сортировка маршрутов
    IN inPersonalTakeId      Integer   ,    -- Сотрудник (экспедитор)  
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);


   -- Проверка установки значений
   IF COALESCE (inJuridicalId, 0) = 0  THEN
      RAISE EXCEPTION 'Не установлено юридическое лицо!';
   END IF;
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName);
   -- проверка уникальности <Код>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), inCode); END IF;


   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, inName);
   IF vbIsInsert = TRUE
   THEN
       -- сохранили свойство <Код GLN>
       PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);
   END IF;
   -- сохранили свойство <Адрес точки доставки>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Address(), ioId, inAddress);
   -- сохранили свойство <За сколько дней принимается заказ>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_PrepareDayCount(), ioId, CASE WHEN vbIsInsert = TRUE AND COALESCE (inPrepareDayCount, 0) = 0 THEN 1 ELSE inPrepareDayCount END);
   -- сохранили свойство <Через сколько дней оформляется документально>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);
   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Маршруты>
   -- PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
   -- сохранили связь с <Сортировки маршрутов>
   -- PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- сохранили связь с <Сотрудник (экспедитор)>
   -- PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inPersonalTakeId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.01.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner_Sybase()
