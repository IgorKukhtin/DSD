-- Function: gpInsertUpdate_Object_GoodsByGoodsKindPeresort (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKindPeresort (Integer , Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKindPeresort(
 INOUT ioId                    Integer  , -- ключ объекта <Товар>
    IN inGoodsId_in            Integer  , -- Товар (пересортица - приход)
    IN inGoodsKindId_in        Integer  , -- Вид товара (пересортица - приход)
    IN inGoodsId_out           Integer  , -- Товар (пересортица - расход)
    IN inGoodsKindId_out       Integer  , -- Вид товара (пересортица - расход)
    IN inSession               TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKindPeresort());


   -- проверка
   IF COALESCE (inGoodsId_in, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар (пересортица - приход)>.';
   END IF;
   -- проверка
   IF COALESCE (inGoodsId_out, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар (пересортица - расход)>.';
   END IF;

   -- проверка уникальности
   IF EXISTS (SELECT ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_Goods_in
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in
                                        ON ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                       AND ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in()

                   INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_Goods_out
                                         ON ObjectLink_GoodsByGoodsKindPeresort_Goods_out.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                        AND ObjectLink_GoodsByGoodsKindPeresort_Goods_out.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out()
                                        AND ObjectLink_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId = inGoodsId_out
                   
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out
                                        ON ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                       AND ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out()
                   LEFT JOIN Object AS Object_GoodsKind_out ON Object_GoodsKind_out.Id = ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ChildObjectId          
              WHERE ObjectLink_GoodsByGoodsKindPeresort_Goods_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in()
                AND ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ChildObjectId = inGoodsId_in
                AND COALESCE (ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.ChildObjectId, 0) = COALESCE (inGoodsKindId_in, 0)
                AND COALESCE (ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ChildObjectId,0) = COALESCE (inGoodsKindId_out,0)
                AND ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.Соответствие <%> + <%> и <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsId_in), lfGet_Object_ValueData (inGoodsKindId_in), lfGet_Object_ValueData (inGoodsId_out), lfGet_Object_ValueData (inGoodsKindId_out);
   END IF;   



   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5 AND 1=1
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsByGoodsKindPeresort(), 0, '');
   -- сохранили связь с <Товары >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in(), ioId, inGoodsId_in);
   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in(), ioId, inGoodsKindId_in);

   -- сохранили связь с <Товары  (пересортица - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out(), ioId, inGoodsId_out);
   -- сохранили связь с <Виды товаров  (пересортица - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out(), ioId, inGoodsKindId_out);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 23.05.25         * 
*/

-- тест
-- 
