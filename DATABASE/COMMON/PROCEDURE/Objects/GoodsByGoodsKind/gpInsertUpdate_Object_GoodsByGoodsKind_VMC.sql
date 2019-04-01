-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_VMC(
 INOUT ioId                    Integer  , -- ключ объекта <Товар>
    IN inGoodsId               Integer  , -- Товары
    IN inGoodsKindId           Integer  , -- Виды товаров
    IN inBoxId                 Integer  , -- ящик
    IN inBoxId_2               Integer  , -- ящик
    IN inWeightMin             TFloat  , -- 
    IN inWeightMax             TFloat  , -- 
    IN inHeight                TFloat  , -- 
    IN inLength                TFloat  , -- 
    IN inWidth                 TFloat  , -- 
    IN inNormInDays            TFloat  , -- 
    IN inCountOnBox            TFloat  , -- 
    IN inWeightOnBox           TFloat  , -- 
    IN inCountOnBox_2          TFloat  , -- 
    IN inWeightOnBox_2         TFloat  , -- 
   OUT outWeightGross          TFloat  , -- 
   OUT outWeightGross_2        TFloat  , -- 
    IN inisGoodsTypeKind_Sh    Boolean , -- 
    IN inisGoodsTypeKind_Nom   Boolean , -- 
    IN inisGoodsTypeKind_Ves   Boolean , -- 
   OUT outisCodeCalc_Diff      Boolean ,
   OUT outCodeCalc_Sh          TVarChar,
   OUT outCodeCalc_Nom         TVarChar,
   OUT outCodeCalc_Ves         TVarChar,
    IN inSession               TVarChar 
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsPropertyBoxId Integer;
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
                AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   
   
   IF COALESCE (ioId, 0) = 0 
   THEN
       -- сохранили <Объект>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsByGoodsKind(), 0, '');
       -- сохранили связь с <Товары>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);

       -- сохранили связь с <Виды товаров>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);

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
                        AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId = ioId)
       THEN 
           RAISE EXCEPTION 'Ошибка.Нет прав изменять значение <Вид упаковки>.';
       END IF;   

   END IF;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMin(), ioId, inWeightMin);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMax(), ioId, inWeightMax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Height(), ioId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Length(), ioId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Width(), ioId, inWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormInDays(), ioId, inNormInDays);


   IF inisGoodsTypeKind_Sh = TRUE 
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh(), ioId, zc_Enum_GoodsTypeKind_Sh());
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh(), ioId, Null);
   END IF;
   IF inisGoodsTypeKind_Nom = TRUE 
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom(), ioId, zc_Enum_GoodsTypeKind_Nom());
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom(), ioId, Null);
   END IF;
   IF inisGoodsTypeKind_Ves = TRUE 
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves(), ioId, zc_Enum_GoodsTypeKind_Ves());
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves(), ioId, Null);
   END IF;

   -- расчет кодов ВМС
   SELECT CodeCalc_Sh, CodeCalc_Nom, CodeCalc_Ves, isCodeCalc_Diff
     INTO outCodeCalc_Sh, outCodeCalc_Nom, outCodeCalc_Ves, outisCodeCalc_Diff
   FROM gpSelect_Object_GoodsByGoodsKind (inSession) AS tmp
   WHERE tmp.Id = ioId;
   
   -- если внесли ящик 1 тогда сохраняем данные
   IF COALESCE (inBoxId,0) <> 0
   THEN
       -- проверка что в свойство ящик2 - выбран ящик2
       IF inBoxId NOT IN (zc_Box_E2(), zc_Box_E3())
       THEN
           RAISE EXCEPTION 'Ошибка.Значение  <%> не может быть записано в свойство <ГофроЯщик>.', lfGet_Object_ValueData (inBoxId);
       END IF;
       -- находим если есть GoodsPropertyBox.Id
       vbGoodsPropertyBoxId := (SELECT ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                FROM ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                           ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId = inGoodsKindId
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                           ON ObjectLink_GoodsPropertyBox_Box.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                                          AND ObjectLink_GoodsPropertyBox_Box.ChildObjectId IN (zc_Box_E2(), zc_Box_E3())
                                     INNER JOIN Object AS Object_GoodsPropertyBox
                                                       ON Object_GoodsPropertyBox.Id = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                      AND Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                                                      --AND Object_GoodsPropertyBox.isErased = FALSE
                                WHERE ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
                                  AND ObjectLink_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                                LIMIT 1
                                );

       --если есть GoodsPropertyBox.Id и он помечен на удал. тогда его восстанавливаем
       IF COALESCE (vbGoodsPropertyBoxId,0) <> 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbGoodsPropertyBoxId AND Object.isErased = TRUE)
       THEN
           --
           PERFORM lpUpdate_Object_isErased (inObjectId:= vbGoodsPropertyBoxId, inUserId:= vbUserId);
       END IF;

       -- сохраняем Значения свойств товаров для ящиков
       PERFORM gpInsertUpdate_Object_GoodsPropertyBox (ioId                   := COALESCE (vbGoodsPropertyBoxId,0) , -- ключ объекта <>
                                                       inBoxId                := inBoxId        , -- Ящик
                                                       inGoodsId              := inGoodsId      , -- Товары
                                                       inGoodsKindId          := inGoodsKindId  , -- Виды товаров
                                                       inCountOnBox           := inCountOnBox   , -- количество ед. в ящ.
                                                       inWeightOnBox          := inWeightOnBox  , -- количество кг. в ящ.
                                                       inSession              := inSession);
                                                       
       outWeightGross := inWeightOnBox + (SELECT ObjectFloat_Weight.ValueData
                                          FROM ObjectFloat AS ObjectFloat_Weight
                                          WHERE ObjectFloat_Weight.ObjectId = inBoxId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                                          );
   END IF;

   -- если внесли ящик 2 тогда сохраняем данные
   IF COALESCE (inBoxId_2,0) <> 0
   THEN
       -- проверка что в свойство ящик2 - выбран ящик2
       IF inBoxId_2 IN (zc_Box_E2(), zc_Box_E3())
       THEN
           RAISE EXCEPTION 'Ошибка.Значение  <%> не может быть записано в свойство <Пластиковый Ящик>.', lfGet_Object_ValueData (inBoxId_2);
       END IF;
       
       -- находим если есть GoodsPropertyBox.Id
       vbGoodsPropertyBoxId := (SELECT ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                FROM ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                           ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId = inGoodsKindId
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                           ON ObjectLink_GoodsPropertyBox_Box.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                                          AND ObjectLink_GoodsPropertyBox_Box.ChildObjectId NOT IN (zc_Box_E2(), zc_Box_E3())
                                     INNER JOIN Object AS Object_GoodsPropertyBox
                                                       ON Object_GoodsPropertyBox.Id = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                      AND Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                                                      --AND Object_GoodsPropertyBox.isErased = FALSE
                                WHERE ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
                                  AND ObjectLink_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                                LIMIT 1
                                );

       --если есть GoodsPropertyBox.Id и он помечен на удал. тогда его восстанавливаем
       IF COALESCE (vbGoodsPropertyBoxId,0) <> 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbGoodsPropertyBoxId AND Object.isErased = TRUE)
       THEN
           --
           PERFORM lpUpdate_Object_isErased (inObjectId:= vbGoodsPropertyBoxId, inUserId:= vbUserId);
       END IF;

       -- сохраняем Значения свойств товаров для ящиков
       PERFORM gpInsertUpdate_Object_GoodsPropertyBox (ioId                   := COALESCE (vbGoodsPropertyBoxId,0) , -- ключ объекта <>
                                                       inBoxId                := inBoxId_2        , -- Ящик
                                                       inGoodsId              := inGoodsId        , -- Товары
                                                       inGoodsKindId          := inGoodsKindId    , -- Виды товаров
                                                       inCountOnBox           := inCountOnBox_2   , -- количество ед. в ящ.
                                                       inWeightOnBox          := inWeightOnBox_2  , -- количество кг. в ящ.
                                                       inSession              := inSession);

       outWeightGross_2 := inWeightOnBox_2 + (SELECT ObjectFloat_Weight.ValueData
                                              FROM ObjectFloat AS ObjectFloat_Weight
                                              WHERE ObjectFloat_Weight.ObjectId = inBoxId_2
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                                              );
   END IF;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.03.19         *
 22.03.19         * 
 13.03.19         *
 22.06.18         *
*/

-- тест
-- 