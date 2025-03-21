-- Function: gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind(
 INOUT ioId                    Integer  , -- ключ объекта <Товар>
    IN inGoodsId               Integer  , -- Товары
    IN inGoodsKindId           Integer  , -- Виды товаров
    IN inGoodsSubId            Integer  , -- Товары
    IN inGoodsKindSubId        Integer  , -- Виды товаров
    IN inGoodsSubSendId        Integer  , -- Товары
    IN inGoodsKindSubSendId    Integer  , -- Виды товаров 
    IN inGoodsPackId           Integer  , -- Главный Товар в планировании прихода с упаковки
    IN inGoodsKindPackId       Integer  , -- Главный Вид в планировании прихода с упаковки 
    IN inGoodsSubId_Br         Integer  , -- Товары (пересортица на филиалах - расход)>
    IN inGoodsKindSubSendId_Br Integer , -- Виды товаров (перемещ.пересортица на филиалах - расход) 
    IN inGoodsRealId           Integer  , -- Товары
    IN inGoodsKindRealId       Integer  , -- Виды товаров
    IN inGoodsKindNewId        Integer  , -- Виды товаров Новые
    IN inGoodsIncomeId         Integer  , -- Товары факт приход
    IN inGoodsKindIncomeId     Integer  , -- Виды товаров факт приход
    IN inReceiptId             Integer  , -- Рецептуры
    IN inReceiptGPId           Integer  , -- Рецептура (схема с тушенкой)
    IN inWeightPackageKorob    TFloat   , -- вес 1-ого пакета для КОРОБКИ
    IN inWeightPackage         TFloat   , -- вес пакета
    IN inWeightPackageSticker  TFloat   , -- вес 1-ого пакета
    IN inWeightTotal           TFloat   , -- вес в упаковки  
    IN inChangePercentAmount   TFloat   , -- % скидки для кол-ва
    IN inDaysQ                 TFloat   , -- Изменение Даты произв в качественном 
    IN inGoodsSubDate          TDateTime, --
    IN inisNotDate             Boolean  , -- если FALSE записать в inGoodsSubDate - NULL 
    IN inIsNotPack             Boolean  , -- не упаковывать
    IN inSession               TVarChar 
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


   -- проверка
   IF COALESCE (inGoodsSubId, 0) <> COALESCE (inGoodsPackId, 0) AND inGoodsPackId > 0 AND inGoodsSubId > 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение Товар (пересорт. - расход) = <%>  и значение Товар (упак., главный) = <%> должны совпадать.', lfGet_Object_ValueData (inGoodsSubId), lfGet_Object_ValueData (inGoodsPackId);
   END IF;   

   -- проверка
   IF COALESCE (inGoodsKindSubId, 0) <> COALESCE (inGoodsKindPackId, 0) AND inGoodsPackId > 0 AND inGoodsKindSubId > 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение Вид (пересорт. - расход) = <%>  и Вид (упак., главный) = <%> должны совпадать.', lfGet_Object_ValueData (inGoodsKindSubId), lfGet_Object_ValueData (inGoodsKindPackId);
   END IF;   

   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5 AND 1=1
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
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
   
   IF COALESCE (inisNotDate, TRUE) = FALSE
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsByGoodsKind_GoodsSub(), ioId, NULL);
   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsByGoodsKind_GoodsSub(), ioId, inGoodsSubDate);
   END IF;

   -- сохранили связь с <Товары  (перемещ.пересортица - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend(), ioId, inGoodsSubSendId);
   -- сохранили связь с <Виды товаров  (перемещ.пересортица - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend(), ioId, inGoodsKindSubSendId);

   -- сохранили связь с <Товары (пересортица на филиалах - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br(), ioId, inGoodsSubId_Br);
   -- сохранили связь с <Виды товаров (перемещ.пересортица на филиалах - расход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br(), ioId, inGoodsKindSubSendId_Br);

   -- сохранили связь с <Товары  (для упаковки)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsPack(), ioId, inGoodsPackId);
   -- сохранили связь с <Виды товаров  (для упаковки)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack(), ioId, inGoodsKindPackId);

   -- сохранили связь с <Товары  (факт отгрузка)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsReal(), ioId, inGoodsRealId);
   -- сохранили связь с <Виды товаров  (факт отгрузка)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal(), ioId, inGoodsKindRealId);

   -- сохранили связь с <Виды товаров  (новые)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew(), ioId, inGoodsKindNewId);

   -- сохранили связь с <Товары  (факт приход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsIncome(), ioId, inGoodsIncomeId);
   -- сохранили связь с <Виды товаров  (факт приход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome(), ioId, inGoodsKindIncomeId);

   -- сохранили связь с <Рецептурой>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Receipt(), ioId, inReceiptId);
   -- сохранили связь с <Рецептурой>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_ReceiptGP(), ioId, inReceiptGPId);

   -- сохранили свойство <вес пакета для коробки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob(), ioId, inWeightPackageKorob);
   -- сохранили свойство <вес пакета>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackage(), ioId, inWeightPackage);
   -- сохранили свойство <вес 1-ого пакета>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker(), ioId, inWeightPackageSticker);
   -- сохранили свойство <вес в упаковки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightTotal(), ioId, inWeightTotal); 
   -- сохранили свойство <вес в упаковки>                                                                                                                              
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount(), ioId, inChangePercentAmount);
   -- сохранили свойство <используется в заявках>
   --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inIsOrder);
   -- сохранили свойство <Изменение Даты произв в качественном>                                                                                                                              
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_DaysQ(), ioId, inDaysQ);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_NotPack(), ioId, inIsNotPack);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 21.03.25         * WeightPackageKorob
 04.11.24         * inGoodsIncomeId, inGoodsKindIncomeId
 21.12.22         * inGoodsKindNewId
 29.09.22         * inGoodsReal
 19.02.21         * add inDaysQ
 04.11.20         * add inReceiptGPId
 10.04.20         *
 20.02.18         * inWeightPackageSticker 
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
