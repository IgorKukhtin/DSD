-- Function: gpInsertUpdate_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorItems(
 INOUT ioId                  Integer   ,    -- ключ объекта <Лодки>
    IN inCode                Integer   ,    -- Код объекта 
    IN inProductId           Integer   ,
    IN inGoodsId             Integer   ,
    IN inProdColorPatternId  Integer   ,
    IN inComment             TVarChar  ,
    IN inIsEnabled           Boolean   , 
 INOUT ioIsProdOptions       Boolean   ,    -- добавить как опцию
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdColorItems());
   vbUserId:= lpGetUserBySession (inSession);


   -- Проверка
   IF COALESCE (inProductId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.ProductId не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdColorItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- Проверка
   IF COALESCE (inProdColorPatternId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdColorItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;


   IF inIsEnabled = FALSE
   THEN
       -- Проверка
       IF COALESCE (ioId, 0) = 0
       THEN
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не может быть удален.'
                                                 , inProcedureName := 'gpInsertUpdate_Object_ProdColorItems'
                                                 , inUserId        := vbUserId);
       END IF;

       -- удалили
       PERFORM lpUpdate_Object_isErased (inObjectId:= ioId, inIsErased:= TRUE, inUserId:= vbUserId);

   ELSE
       -- определяем признак Создание/Корректировка
       vbIsInsert:= COALESCE (ioId, 0) = 0;
    
        -- Если код не установлен, определяем его как последний+1, для каждой лодки начиная с 1
       IF COALESCE (ioId,0) = 0 AND inCode = 0
       THEN
           vbCode_calc:= COALESCE ((SELECT MAX (Object_ProdColorItems.ObjectCode) AS ObjectCode
                                    FROM Object AS Object_ProdColorItems
                                         INNER JOIN ObjectLink AS ObjectLink_Product
                                                               ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                              AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()
                                                              AND ObjectLink_Product.ChildObjectId = inProductId AND COALESCE (inProductId,0) <> 0
                                    WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems())
                                   , 0) + 1; 
       ELSE 
            vbCode_calc:= inCode;
       END IF;
       
       -- проверка прав уникальности для свойства <Наименование >
       --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdColorItems(), inName, vbUserId);
    
       -- сохранили <Объект>
       ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdColorItems(), vbCode_calc, '');
    
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColorItems_Comment(), ioId, inComment);

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ProdColorItems_ProdOptions(), ioId, ioIsProdOptions);

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_Product(), ioId, inProductId);
    
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_Goods(), ioId, inGoodsId);
    
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_ProdColorPattern(), ioId, inProdColorPatternId);

   END IF;


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (корр)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);

   END IF;


   IF inIsEnabled = TRUE
   THEN
       -- сохранили протокол
       PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.20         *
 09.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdColorItems()
