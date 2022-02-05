-- Function: gpInsertUpdate_Object_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
 INOUT ioId	          Integer   ,    -- ключ объекта <Касса> 
    IN inCode             Integer   ,    -- код объекта <Касса> 
    IN inCashName         TVarChar  ,    -- Название объекта <Касса> 
    IN inShortName        TVarChar  ,    -- Сокращенное Название
    IN inNPP              TFloat    ,    -- № пп
    IN inCurrencyId       Integer   ,    -- Валюта данной кассы 
    IN inPaidKindId       Integer   ,    -- Форма оплаты
    IN inParentId         Integer   ,    -- ключ объекта <Група> 
    IN inSession          TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGroupNameFull TVarChar;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Cash());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_Cash());
    
   -- проверка прав уникальности для свойства <Наименование Касса>  
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Cash(), inCashName);
   -- проверка прав уникальности для свойства <Код Кассы>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Cash(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Cash(), inCode, inCashName);

   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inParentId, zc_ObjectLink_Unit_Parent());

   -- сохранили группа
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Cash_GroupNameFull(), ioId, vbGroupNameFull);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Cash_ShortName(), ioId, inShortName);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Cash_NPP(), ioId, inNPP);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Currency(), ioId, inCurrencyId);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Parent(), ioId, inParentId);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_PaidKind(), ioId, inPaidKindId);


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь корр>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);   
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.22         *
*/

-- тест
--