--
--gpInsertUpdate_Object_GoodsByGoodsKind_Br_Load
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKind_Br_Load (Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_Br_Load(
    IN inGoodsCode          Integer,       -- Код отгружаемого товара
    IN inGoodsName          TVarChar,      -- Название отгружаемого товара
    IN inGoodsKindName      TVarChar,      -- Вид отгружаемого товара
    IN inGoodsCode_Br       Integer,       -- Код товара пересорт
    IN inGoodsName_Br       TVarChar,      -- Название товара пересорт
    IN inGoodsKindName_Br   TVarChar,      -- Вид товара пересорт
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer; 
  DECLARE vbGoodsSubId_Br Integer;
  DECLARE vbGoodsKindId Integer;
  DECLARE vbGoodsKindSubSendId_Br Integer;
  DECLARE vbGoodsByGoodsKindId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());
   
   IF COALESCE (inGoodsCode,0) = 0
   THEN
       RETURN;
   END IF;
   
   
   --Находим товары
   vbGoodsId        := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
   vbGoodsSubId_Br  := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode_Br AND Object.DescId = zc_Object_Goods());
   -- находим вид товара
   vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());
   vbGoodsKindSubSendId_Br := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName_Br) AND Object.DescId = zc_Object_GoodsKind());
               
   --находим  GoodsByGoodsKindId
   vbGoodsByGoodsKindId := (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                            FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                      ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                     AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                            WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                              AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = vbGoodsId
                              AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (vbGoodsKindId, 0)
                            );

   
   -- сохранили связь с <Товары (пересортица на филиалах - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br(), vbGoodsByGoodsKindId, vbGoodsSubId_Br);
   -- сохранили связь с <Виды товаров (перемещ.пересортица на филиалах - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br(), vbGoodsByGoodsKindId, vbGoodsKindSubSendId_Br);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.06.22         *
*/

-- тест
--