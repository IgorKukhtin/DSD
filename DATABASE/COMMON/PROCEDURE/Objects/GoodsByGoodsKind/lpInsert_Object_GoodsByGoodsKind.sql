-- Function: lpInsert_Object_GoodsByGoodsKind (Integer, Integer, Integer)

-- DROP FUNCTION lpInsert_Object_GoodsByGoodsKind (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Object_GoodsByGoodsKind(
    IN inGoodsId      Integer  , -- Товары
    IN inGoodsKindId  Integer  , -- Виды товаров
    IN inUserId       Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId Integer;
BEGIN

     -- Проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не определен.';
     END IF;
     -- Проверка
     IF inGoodsId = inGoodsKindId
     THEN
         RAISE EXCEPTION 'Ошибка.Параметры Товар и Вид товара = <%> <%>.', inGoodsId, inGoodsKindId;
     END IF;


     -- если связь не нужна, зачем ее создавать
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RETURN;
     END IF;

     -- Если нашли такую связку, ничего не делаем
     IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = inGoodsKindId
                WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
               )
     THEN
         RETURN;
     END IF;

     -- сохранили <Объект>
     vbId := lpInsertUpdate_Object (NULL, zc_Object_GoodsByGoodsKind(), 0, '');
      -- сохранили связь с <Товары>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), vbId, inGoodsId);
      -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), vbId, inGoodsKindId);

     -- сохранили протокол, хотя он пока не нужен
     -- PERFORM lpInsert_ObjectProtocol (vbId, inUserId);


END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsert_Object_GoodsByGoodsKind (Integer, Integer, Integer)  OWNER TO postgres;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.13                                        *
*/

-- тест
-- SELECT * FROM lpInsert_Object_GoodsByGoodsKind (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
