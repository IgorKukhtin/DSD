-- Function: gpInsertUpdate_Object_ProdOptItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, TVarChar, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptItems(
 INOUT ioId                   Integer   , -- Ключ
    IN inCode                 Integer   , -- Код
    IN inProductId            Integer   ,
    IN inProdOptionsId        Integer   ,
    IN inProdOptPatternId     Integer   ,
    IN inProdColorPatternId   Integer   ,
 INOUT ioGoodsId              Integer   ,
   OUT outGoodsName           TVarChar  ,
    IN inPriceIn              TFloat    ,
    IN inPriceOut             TFloat    ,
    IN inDiscountTax          TFloat    ,
    IN inPartNumber           TVarChar  ,
    IN inComment              TVarChar  ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);


   -- Проверка
   IF COALESCE (inProductId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.ProductId не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- Проверка/Поиск
   IF COALESCE (inProdOptPatternId, 0) = 0
   THEN
       -- найдем "свободный"
       inProdOptPatternId:= (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_ProdOptPattern() AND Object.isErased = FALSE
                             AND Object.Id NOT IN (-- если нет среди существующих
                                                   SELECT ObjectLink_ProdOptPattern.ChildObjectId
                                                   FROM Object AS Object_ProdOptItems
                                                        INNER JOIN ObjectLink AS ObjectLink_Product
                                                                             ON ObjectLink_Product.ObjectId      = Object_ProdOptItems.Id
                                                                            AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                                                                            -- для єтой лодки
                                                                            AND ObjectLink_Product.ChildObjectId = inProductId

                                                        INNER JOIN ObjectLink AS ObjectLink_ProdOptPattern
                                                                              ON ObjectLink_ProdOptPattern.ObjectId = Object_ProdOptItems.Id
                                                                             AND ObjectLink_ProdOptPattern.DescId   = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                   WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                                                     AND Object_ProdOptItems.isErased = FALSE
                                                  ));
     --RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не установлен.'
     --                                      , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
     --                                      , inUserId        := vbUserId
     --                                       );
   END IF;


   -- если эта опция из Boat Structure или есть inProdColorPatternId
   IF EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_ProdOptions() AND ObjectLink.ChildObjectId = inProdOptionsId)
      OR inProdColorPatternId > 0
   THEN
        -- Проверка inProdColorPatternId - заполнен
        IF COALESCE (inProdColorPatternId, 0) = 0
        THEN
            RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.inProdColorPatternId не установлен.'
                                                  , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                                  , inUserId        := vbUserId
                                                   );
        END IF;
        -- Проверка inProdOptionsId - из Boat Structure
        IF NOT EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_ProdOptions() AND ObjectLink.ChildObjectId = inProdOptionsId)
        THEN
            RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.inProdColorPatternId не установлен.'
                                                  , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                                  , inUserId        := vbUserId
                                                   );
        END IF;

        -- сохраняем в Items Boat Structure
        PERFORM gpInsertUpdate_Object_ProdColorItems(ioId                  := tmp.Id
                                                   , inCode                := tmp.Code
                                                   , inProductId           := inProductId
                                                   , inGoodsId             := ioGoodsId
                                                   , inProdColorPatternId  := inProdColorPatternId
                                                   , inComment             := '' :: TVarChar
                                                   , inIsEnabled           := TRUE :: Boolean
                                                   , ioIsProdOptions       := TRUE  :: Boolean
                                                   , inSession             := inSession
                                                   )
                                                   
        FROM gpSelect_Object_ProdColorItems (FALSE,FALSE,FALSE, zfCalc_UserAdmin()) as tmp
        WHERE tmp.ProductId = inProductId
          AND tmp.ProdColorPatternId = inProdColorPatternId
        ;
   
        -- !!! ВЫХОД !!!
        -- RETURN;
        
    END IF;


   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1, для каждой лодки начиная с 1
   IF COALESCE (ioId,0) = 0 AND inCode = 0
   THEN
       vbCode_calc:= COALESCE ((SELECT MAX (Object_ProdOptItems.ObjectCode) AS ObjectCode
                                FROM Object AS Object_ProdOptItems
                                     INNER JOIN ObjectLink AS ObjectLink_Product
                                                           ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                          AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
                                                          AND ObjectLink_Product.ChildObjectId = inProductId AND COALESCE (inProductId,0) <> 0
                                WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems())
                               , 0) + 1;
   ELSE
        vbCode_calc:= inCode;
   END IF;

   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdOptItems(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdOptItems(), vbCode_calc, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ProdOptItems_PartNumber(), ioId, inPartNumber);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ProdOptItems_Comment(), ioId, inComment);

   -- сохранили свойство <PriceIn> - временно убрал, может потом понадобится
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_PriceIn(), ioId, 0);
   -- сохранили свойство <PriceOut> - временно убрал, может потом понадобится
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_PriceOut(), ioId, 0);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_DiscountTax(), ioId, inDiscountTax);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_Product(), ioId, inProductId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_ProdOptions(), ioId, inProdOptionsId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_ProdOptPattern(), ioId, inProdOptPatternId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_Goods(), ioId, ioGoodsId);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   outGoodsName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioGoodsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.21         * inDiscountTax
 09.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdOptItems()
