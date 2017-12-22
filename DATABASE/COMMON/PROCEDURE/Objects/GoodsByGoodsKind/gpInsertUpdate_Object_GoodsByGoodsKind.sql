-- Function: gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind(
 INOUT ioId                  Integer  , -- ключ объекта <Товар>
    IN inGoodsId             Integer  , -- Товары
    IN inGoodsKindId         Integer  , -- Виды товаров
    IN inGoodsSubId          Integer  , -- Товары
    IN inGoodsKindSubId      Integer  , -- Виды товаров
    IN inGoodsPackId         Integer  , -- Товары для упаковки
    IN inGoodsKindPackId     Integer  , -- Виды товаров для упаковки
    IN inReceiptId           Integer  , -- Рецептуры
    IN inWeightPackage       TFloat   , -- вес пакета
    IN inWeightTotal         TFloat   , -- вес в упаковки  
    IN inChangePercentAmount TFloat   , -- % скидки для кол-ва
   -- IN inIsOrder             Boolean  , -- используется в заявках

    IN inSession             TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());

   -- проверка
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
   END IF;

   -- !!!надо создавать!!! если связь не нужна, зачем ее создавать
   -- IF COALESCE (inGoodsKindId, 0) = 0
   -- THEN
   --     RETURN;
   -- END IF;

   -- проверка уникальности
   IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
              WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsByGoodsKind(), 0, '');
   -- сохранили связь с <Товары>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);
   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили связь с <Товары  (пересортица - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub(), ioId, inGoodsSubId);
   -- сохранили связь с <Виды товаров  (пересортица - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub(), ioId, inGoodsKindSubId);

   -- сохранили связь с <Товары  (для упаковки)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsPack(), ioId, inGoodsPackId);
   -- сохранили связь с <Виды товаров  (для упаковки)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack(), ioId, inGoodsKindPackId);

   -- сохранили связь с <Рецептурой>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Receipt(), ioId, inReceiptId);


   -- сохранили свойство <вес пакета>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackage(), ioId, inWeightPackage);
   -- сохранили свойство <вес в упаковки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightTotal(), ioId, inWeightTotal); 
   -- сохранили свойство <вес в упаковки>                                                                                                                              
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount(), ioId, inChangePercentAmount);
   -- сохранили свойство <используется в заявках>
   --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inIsOrder);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 21.12.17         * 
 22.02.17         * ChangePercentAmount
 27.10.16         * Receipt
 26.07.16         *
 23.02.16         * dell inIsOrder - сохраняется в др. процке, разделение прав
 17.06.15                                        *   -- !!!надо создавать!!!
 19.03.15         *
*/

-- тест
-- 
