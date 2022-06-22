-- Function: gpInsertUpdate_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions(Integer, Integer, TVarChar, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions(Integer, Integer, TVarChar, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions(Integer, Integer, TVarChar, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptions(
 INOUT ioId           Integer   ,    -- ключ объекта <Названия опций>
    IN inCode         Integer   ,    -- Код объекта 
    IN inName         TVarChar  ,    -- Название объекта 
    IN inSalePrice    TFloat    ,
    IN inComment      TVarChar  ,
    IN inGoodsId      Integer   ,
    IN inModelId      Integer   ,
    IN inTaxKindId    Integer   ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdOptions());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProdOptions()); 

   -- проверка уникальности для свойства <Название >
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdOptions(), inName, vbUserId);

   -- проверка - у таких опций здесь нельзя установить значение <Комплектующие>
   IF inGoodsId > 0
      AND EXISTS (SELECT 1 FROM ObjectLink AS ObjectLink_ProdColorPattern_ProdOptions
                  WHERE ObjectLink_ProdColorPattern_ProdOptions.ChildObjectId = ioId
                    AND ObjectLink_ProdColorPattern_ProdOptions.DescId        = zc_ObjectLink_ProdColorPattern_ProdOptions()
                 )
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Для выбранной Опции нельзя установить значение <Комплектующие>.Т.к. значение определено в <Boat Structure>.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptions'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdOptions(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdOptions_Comment(), ioId, inComment);

   -- у таких опций здесь цена = 0
   IF inGoodsId > 0
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptions_SalePrice(), ioId, 0);
   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptions_SalePrice(), ioId, inSalePrice);
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_TaxKind(), ioId, inTaxKindId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_Model(), ioId, inModelId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_Goods(), ioId, inGoodsId);


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.12.20         *
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdOptions()
