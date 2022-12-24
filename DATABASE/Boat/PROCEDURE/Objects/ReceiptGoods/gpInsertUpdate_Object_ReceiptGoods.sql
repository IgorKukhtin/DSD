-- Function: gpInsertUpdate_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods(Integer, Integer, TVarChar, Integer, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods(Integer, Integer, TVarChar, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods(Integer, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods(
 INOUT ioId               Integer   ,    -- ключ объекта <Лодки>
    IN inCode             Integer   ,    -- Код объекта
    IN inName             TVarChar  ,    -- Название объекта
    IN inColorPatternId   Integer   ,
    IN inGoodsId          Integer   ,
    IN inUnitId           Integer   ,    ---
    IN inIsMain           Boolean   ,
    IN inUserCode         TVarChar  ,    -- пользовательский код
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbGoodsCode TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoods());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   --
   IF COALESCE (ioId, 0) = 0
   THEN
       -- Если код не установлен, определяем его как последний+1
       inCode:= lfGet_ObjectCode (inCode, zc_Object_ReceiptGoods());

   ELSEIF COALESCE (inCode, 0) = 0
   THEN
       -- Нашли код
       inCode:= (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   END IF;

   --
   SELECT Goods.ValueData              AS GoodsName
        , Goods.ObjectCode :: TVarChar AS Code
          INTO vbGoodsName, vbGoodsCode
   FROM Object AS Goods
   WHERE Goods.DescId = zc_Object_Goods() AND Goods.Id = inGoodsId;

   inUserCode := (CASE WHEN COALESCE (inUserCode,'') <>'' THEN inUserCode ELSE COALESCE (vbGoodsCode,'') END) :: TVarChar;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptGoods(), inCode
                               , COALESCE (vbGoodsName,'')
                              || CASE WHEN inComment <> '' THEN '-' || inComment ELSE '' END
                            --||'-' || COALESCE (inUserCode,'')
                                );

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptGoods_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptGoods_Code(), ioId, COALESCE (inUserCode, vbGoodsCode,''));

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ReceiptGoods_Main(), ioId, inIsMain);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_ColorPattern(), ioId, inColorPatternId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_Object(), ioId, inGoodsId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_Unit(), ioId, inUnitId);
   
   
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

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.22         * inUnitId
 11.12.20         * inColorPatternId
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods()
