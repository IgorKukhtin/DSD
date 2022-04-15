-- Function: gpInsertUpdate_Object_Retail()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Retail(
 INOUT ioId                    Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inCode                  Integer   ,     -- Код объекта  
    IN inName                  TVarChar  ,     -- Название объекта 
    IN inOperDateOrder         Boolean   ,     --
    IN inGLNCode               TVarChar  ,     -- Код GLN - Получатель
    IN inGLNCodeCorporate      TVarChar  ,     -- Код GLN - Поставщик 
    IN inOKPO                  TVarChar  ,     -- ОКПО для налог. документов
    IN inGoodsPropertyId       Integer   ,     -- Классификаторы свойств товаров
    IN inPersonalMarketingId   Integer   ,     -- Сотрудник (Ответственный представитель маркетингового отдела)
    IN inPersonalTradeId       Integer   ,     -- Сотрудник (Ответственный представитель коммерческого отдела)
    IN inClientKindId          Integer   ,     -- Категории покупателей     
    IN inRoundWeight           TFloat    ,     -- Кол-во знаков для округления веса
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Retail());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Retail());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Retail(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Retail(), vbCode_calc);
  
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Retail(), vbCode_calc, inName);
   
   -- сохранили св-во <Код GLN - Получатель>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
   -- сохранили св-во <Код GLN - Поставщик>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCodeCorporate(), ioId, inGLNCodeCorporate);
   
   IF inOKPO = ''
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, NULL);
   ELSE
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, inOKPO);
   END IF;

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Retail_OperDateOrder(), ioId, inOperDateOrder);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Retail_RoundWeight(), ioId, inRoundWeight);
   
   -- сохранили связь с <Классификаторы свойств товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_GoodsProperty(), ioId, inGoodsPropertyId);   
   -- сохранили связь с <Сотрудник (Ответственный представитель маркетингового отдела)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalMarketing(), ioId, inPersonalMarketingId);  
   -- сохранили связь с <Сотрудник (Ответственный представитель коммерческого отдела)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalTrade(), ioId, inPersonalTradeId);  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_ClientKind(), ioId, inClientKindId);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.22         * inRoundWeight
 14.05.19         * inClientKindId
 29.01.19         * add OKPO
 24.11.15         * add inPersonalMarketingId
 02.04.15         * add inOperDateOrder
 19.02.15         * add inGoodsPropertyId
 10.11.14         * add GLNCode
 23.05.14         *
*/

-- тест
-- 