-- Function: gpInsertUpdate_Object_ProdColorPattern()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorPattern(Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorPattern(Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorPattern(Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorPattern(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorPattern(
 INOUT ioId               Integer   ,    -- ключ объекта <Лодки>
    IN inCode             Integer   ,    -- Код объекта 
    IN inName             TVarChar  ,    -- Название объекта
    IN inColorPatternId   Integer   ,
    IN inProdColorGroupId Integer   ,
    IN inGoodsId          Integer   ,
 INOUT ioComment          TVarChar  ,
 INOUT ioProdColorName    TVarChar  ,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbProdColorName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка inColorPatternId должно быть внесено
   IF COALESCE (inColorPatternId,0) = 0
   THEN
        RAISE EXCEPTION 'Ошибка.Значение <Шаблон Boat Structure> должено быть заполнено.';
   END IF;
   
   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- проверка - если заполнен товар - выдавать сообщ об ошибке, иначе сохранять в св-во Comment
   -- получаем цвет из Goods
   vbProdColorName := (SELECT Object_ProdColor.ValueData
                       FROM ObjectLink AS ObjectLink_Goods_ProdColor
                            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                       WHERE ObjectLink_Goods_ProdColor.ObjectId = inGoodsId
                         AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                       );
   IF COALESCE (ioProdColorName,'') <> '' AND COALESCE (ioProdColorName,'') <> COALESCE (vbProdColorName,'')
   THEN
       IF COALESCE (inGoodsId,0) <> 0
       THEN
            ioProdColorName := vbProdColorName;
            RAISE EXCEPTION 'Ошибка.Цвет определен в <%>.', lfGet_Object_ValueData (inGoodsId);
       ELSE
            ioComment := ioProdColorName;
       END IF;
   END IF;


    -- Если код не установлен, определяем его как последний+1, для каждой лодки начиная с 1
   IF COALESCE (ioId,0) = 0 AND inCode = 0
   THEN
       vbCode_calc:= COALESCE ((SELECT MAX (Object_ProdColorPattern.ObjectCode) AS ObjectCode
                                FROM Object AS Object_ProdColorPattern
                                     INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                           ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                                          AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                                          AND ObjectLink_ProdColorGroup.ChildObjectId = inProdColorGroupId AND COALESCE (inProdColorGroupId,0) <> 0
                                WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern())
                               , 0) + 1; 
   ELSE 
        vbCode_calc:= inCode;
   END IF;
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdColorPattern(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdColorPattern(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColorPattern_Comment(), ioId, ioComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorPattern_ProdColorGroup(), ioId, inProdColorGroupId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorPattern_ColorPattern(), ioId, inColorPatternId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorPattern_Goods(), ioId, inGoodsId);

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
 11.12.20         * inColorPatternId
 01.12.20         * add inGoodsId
 15.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdColorPattern()
