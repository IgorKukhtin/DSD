-- Function: gpInsertUpdate_Object_GoodsByGoodsKindQuality()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKindQuality (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar, TFloat, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKindQuality (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKindQuality(
 INOUT ioId	          Integer   ,    -- ключ объекта <>
    IN inCode             Integer   ,    -- код объекта <>
    IN inGoodsQualityName TVarChar  ,    -- Название объекта <Значение ГОСТ, ДСТУ,ТУ, колонка 17>
    IN inValue1           TVarChar  ,    --
    IN inValue2           TVarChar  ,    --
    IN inValue3           TVarChar  ,    --
    IN inValue4           TVarChar  ,    --
    IN inValue5           TVarChar  ,    --
    IN inValue6           TVarChar  ,    --
    IN inValue7           TVarChar  ,    --
    IN inValue8           TVarChar  ,    --
    IN inValue9           TVarChar  ,    --
    IN inValue10          TVarChar  ,    --
    IN inValue1_gk        TVarChar  ,    --
    IN inValue11_gk       TVarChar  ,    --
    IN inNormInDays_gk    TFloat    ,    --
    IN inGoodsId          Integer   ,    -- товар
    IN inGoodsKindId      Integer   ,    --
    IN inQualityId        Integer   ,    -- Качественное удостоверение
    IN inisKlipsa         Boolean   ,    -- клипсованный товар
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsByGoodsKindId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsQuality());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка
     IF COALESCE (inQualityId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Качественное удостоверение>.';
     END IF;

     -- проверка уникальности товара
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Товар>.';
     ELSE
         IF EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_GoodsQuality_Goods() AND ChildObjectId = inGoodsId AND COALESCE (ObjectId,0) <> COALESCE (ioId,0))
         THEN
             RAISE EXCEPTION 'Ошибка. Значение <%> уже есть в справочнике.', lfGet_Object_ValueData (vbGoodsId);
         END IF;
     END IF;

     -- проверка
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Вид Товара>.';
     END IF;
     --
     vbGoodsByGoodsKindId:= (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS GoodsByGoodsKindId
                             FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = inGoodsKindId
                                --INNER JOIN ObjectBoolean AS ObjectBoolean_Order
                                --                         ON ObjectBoolean_Order.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                --                        AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                --                        AND ObjectBoolean_Order.ValueData = TRUE
                             WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                               AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                            );
    -- проверка
     IF COALESCE (vbGoodsByGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Такого значения Товар + Вид не найдено : <%> + <%>.', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId);
     END IF;


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_GoodsQuality());

   -- проверка прав уникальности для свойства <Наименование >
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsQuality(), inGoodsQualityName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsQuality(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsQuality(), inCode, inGoodsQualityName);
                                --, inAccessKeyId:= (SELECT Object_Branch.AccessKeyId FROM Object AS Object_Branch WHERE Object_Branch.Id = inBranchId));

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value1(), ioId, inValue1);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value2(), ioId, inValue2);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value3(), ioId, inValue3);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value4(), ioId, inValue4);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value5(), ioId, inValue5);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value6(), ioId, inValue6);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value7(), ioId, inValue7);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value8(), ioId, inValue8);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value9(), ioId, inValue9);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value10(), ioId, inValue10);
   --
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsQuality_Goods(), ioId, inGoodsId);
   --
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsQuality_Quality(), ioId, inQualityId);

   -- сохранили св-во <клипсованный товар>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsQuality_Klipsa(), ioId, inisKlipsa);

   -- сохранили св-во для GoodsByGoodsKind <Вид оболонки, №4>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsByGoodsKind_Quality1(), vbGoodsByGoodsKindId, inValue1_gk);
   -- сохранили св-во для GoodsByGoodsKind <Вид пакування/стан продукції >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsByGoodsKind_Quality11(), vbGoodsByGoodsKindId, inValue11_gk);
   -- сохранили св-во для GoodsByGoodsKind <срок годности в днях>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormInDays(), vbGoodsByGoodsKindId, inNormInDays_gk);
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbGoodsByGoodsKindId, vbUserId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.20         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKindQuality()
