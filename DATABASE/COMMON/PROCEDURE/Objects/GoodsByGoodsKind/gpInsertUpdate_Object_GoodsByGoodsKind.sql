-- Function: gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind(
 INOUT ioId                  Integer  , -- ключ объекта <Товар>
    IN inGoodsId             Integer  , -- Товары
    IN inGoodsKindId         Integer  , -- Виды товаров
    IN inWeightPackage       TFloat   , -- вес пакета
    IN inWeightTotal         TFloat   , -- вес упаковки
    IN inisOrder             Boolean  , -- используется в заявках
    IN inUserId              Integer    -- Пользователь
)
  RETURNS Integer AS    --VOID AS
$BODY$
   DECLARE vbId Integer;
BEGIN

     -- Проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не определен.';
     END IF;

     -- если связь не нужна, зачем ее создавать
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RETURN;
     END IF;


     -- Если не нашли такую связку, то создаем новую,
     IF NOT EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = inGoodsKindId
                WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
               )
     THEN
         -- сохранили <Объект>
         ioId := lpInsertUpdate_Object (NULL, zc_Object_GoodsByGoodsKind(), 0, '');
         -- сохранили связь с <Товары>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);
         -- сохранили связь с <Виды товаров>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);
      END IF;

     -- сохранили свойство <Вес>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackage(), ioId, inWeightPackage);
     -- сохранили свойство <Вес>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightTotal(), ioId, inWeightTotal);
      -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inisOrder);
   
    
     -- сохранили протокол, хотя он пока не нужен
     -- PERFORM lpInsert_ObjectProtocol (vbId, inUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, TFloat, TFloat, Boolean, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 19.03.15         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKind (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
