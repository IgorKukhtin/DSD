-- Function: gpInsertUpdate_Object_Product()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Product(
 INOUT ioId                    Integer   ,    -- ключ объекта <Лодки>
    IN inCode                  Integer   ,    -- Код объекта
    IN inName                  TVarChar  ,    -- Название объекта
    IN inBrandId               Integer   ,
    IN inModelId               Integer   ,
    IN inEngineId              Integer   ,
    IN inIsBasicConf           Boolean   ,    -- включать базовую Комплектацию
    IN inIsProdColorPattern    Boolean   ,    -- автоматически добавить все Items Boat Structure
    IN inHours                 TFloat    ,
    IN inDateStart             TDateTime ,
    IN inDateBegin             TDateTime ,
    IN inDateSale              TDateTime ,
    IN inArticle               TVarChar  ,
    IN inCIN                   TVarChar  ,
    IN inEngineNum             TVarChar  ,
    IN inComment               TVarChar  ,
    IN inSession               TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
 --DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   -- vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Product());

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- !!! временно !!!
   IF CEIL (inCode / 2) * 2 = inCode THEN inDateSale:= NULL; END IF;


   -- проверка - должен быть Код
   IF COALESCE (inCode, 0) = 0 THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть определен <Interne Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                            );
   END IF;
   -- проверка - должен быть Артикул
   IF COALESCE (inArticle, '') = '' THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть определен <Artikel Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                            );
   END IF;
   -- Проверка
   IF COALESCE (inModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должна быть определена <Model>' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), inCode, vbUserId);

   -- расчет
   inName:= SUBSTRING (COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBrandId), ''), 1, 2)
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inModelId), '')
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inEngineId), '')
             || ' ' || inCIN
             ;

   -- проверка прав уникальности для свойства <Наименование >
 --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Product(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Product(), inCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Product_BasicConf(), ioId, inIsBasicConf);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Product_Hours(), ioId, inHours);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateStart(), ioId, inDateStart);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), ioId, inDateBegin);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateSale(), ioId, inDateSale);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_CIN(), ioId, inCIN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), ioId, inEngineNum);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Product_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Brand(), ioId, inBrandId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Model(), ioId, inModelId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Engine(), ioId, inEngineId);


   -- только при создании
   IF inIsProdColorPattern = TRUE AND (vbIsInsert = TRUE OR NOT EXISTS (SELECT 1
                                                                        FROM ObjectLink AS ObjectLink_Product
                                                                             INNER JOIN Object AS Object_ProdColorItems
                                                                                               ON Object_ProdColorItems.Id       = ObjectLink_Product.ObjectId
                                                                                              AND Object_ProdColorItems.isErased = FALSE
                                                                        WHERE ObjectLink_Product.ChildObjectId = ioId
                                                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                                                       ))
   THEN
       -- добавить все Items Boat Structure
       PERFORM gpInsertUpdate_Object_ProdColorItems (ioId                  := 0
                                                   , inCode                := 0
                                                   , inProductId           := ioId
                                                   , inGoodsId             := tmp.GoodsId
                                                   , inProdColorPatternId  := tmp.ProdColorPatternId
                                                   , inComment             := ''
                                                   , inIsEnabled           := TRUE
                                                   , ioIsProdOptions       := FALSE
                                                   , inSession             := inSession
                                                    )
       FROM gpSelect_Object_ProdColorItems (inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
       WHERE tmp.ProductId = ioId;

   END IF;



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
 09.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Product()
