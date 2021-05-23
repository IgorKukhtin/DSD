-- Function: gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Nom ();

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Nom (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Nom(
    IN inId                    Integer  , -- ключ объекта <Товар>
    IN inGoodsId               Integer  , -- Товары
    IN inGoodsKindId           Integer  , -- Виды товаров
    IN inisGoodsTypeKind_Nom   Boolean , -- 
    IN inSession               TVarChar 
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbWmsCode Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_VMC());


   -- проверка уникальности
   IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
              WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId <> COALESCE (inId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   

   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
   END IF;


   IF COALESCE (inId, 0) = 0 
   THEN
       -- сохранили <Объект>
       inId := lpInsertUpdate_Object (inId, zc_Object_GoodsByGoodsKind(), 0, '');
       -- сохранили связь с <Товары>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), inId, inGoodsId);

       -- сохранили связь с <Виды товаров>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), inId, inGoodsKindId);

   ELSE
       -- проверка
       IF NOT EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                      FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                               AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                      WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                        AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                        AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                        AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId = inId)
       THEN 
           RAISE EXCEPTION 'Ошибка.Нет прав изменять значение <Вид упаковки>.';
       END IF;   

   END IF;
   
   IF inisGoodsTypeKind_Nom = TRUE 
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom(), inId, zc_Enum_GoodsTypeKind_Nom());

         --WmsCode
         IF NOT EXISTS (SELECT ObjectFloat.ValueData
                        FROM ObjectFloat
                        WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
                          AND ObjectFloat.ObjectId = inId
                          AND ObjectFloat.ValueData <> 0
                        )
         THEN
             -- находим макс код + 1
             vbWmsCode := ((SELECT MAX (ObjectFloat.ValueData) FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()) + 1 ) :: Integer;
             -- записываем новый код = последнему сохр + 1
             PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WmsCode(), inId, vbWmsCode);
         END IF;
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom(), inId, Null);
   END IF;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.19         *
*/

-- тест
-- 