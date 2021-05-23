-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , Boolean, Boolean, Boolean
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_VMC(
 INOUT ioId                    Integer  , -- ключ объекта <Товар>
    IN inGoodsId               Integer  , -- Товары
    IN inGoodsKindId           Integer  , -- Виды товаров
    IN inGoodsId_sh            Integer  , -- Товар (из категории "Штучный")
    IN inGoodsKindId_sh        Integer  , -- Вид Товара (из категории "Штучный")
    IN inBoxId                 Integer  , -- Ящик (E2/E3)
    IN inBoxId_2               Integer  , -- ящик (Гофра)
    --IN inWeightMin             TFloat  , -- Мин. вес
    --IN inWeightMax             TFloat  , -- Мах. вес
    IN inHeight                TFloat  , -- Высота
    IN inLength                TFloat  , -- Длина
    IN inWidth                 TFloat  , -- Ширина
    IN inNormInDays            TFloat  , -- Cрок годности, дн.
    IN inCountOnBox            TFloat  , -- Кол-во ед. в ящ. (E2/E3)
    IN inWeightOnBox           TFloat  , -- Кол-во кг. в ящ. (E2/E3)
    IN inCountOnBox_2          TFloat  , -- Кол-во ед. в ящ. (Гофра)
    IN inWeightOnBox_2         TFloat  , -- Кол-во кг. в ящ. (Гофра)

   OUT outWeightGross_sh       TFloat  , -- Вес брутто полного ящика (E2/E3)
   OUT outWeightGross_nom      TFloat  , -- Вес брутто полного ящика (E2/E3)
   OUT outWeightGross_ves      TFloat  , -- Вес брутто полного ящика (E2/E3)

   OUT outWeightOnBox          TFloat  , -- Кол-во кг. в ящ. (E2/E3)

   OUT outWeightAvgGross_sh    TFloat  , -- Вес брутто по среднему весу ящика (E2/E3)
   OUT outWeightAvgGross_nom   TFloat  , -- Вес брутто по среднему весу ящика (E2/E3)
   OUT outWeightAvgGross_ves   TFloat  , -- Вес брутто по среднему весу ящика (E2/E3)

   OUT outWeightAvgNet_sh      TFloat  , -- Вес нетто по среднему весу ящика (E2/E3)
   OUT outWeightAvgNet_nom     TFloat  , -- Вес нетто по среднему весу ящика (E2/E3)
   OUT outWeightAvgNet_ves     TFloat  , -- Вес нетто по среднему весу ящика (E2/E3)

   OUT outWeightGross_2        TFloat  , -- Вес брутто полного ящика (Гофра)
   OUT outWeightOnBox_2        TFloat  , -- Кол-во кг. в ящ (Гофра)
   OUT outWeightAvgGross_2     TFloat  , -- Вес брутто по среднему весу ящика (Гофра)
   OUT outWeightAvgNet_2       TFloat  , -- Вес нетто по среднему весу ящика (Гофра)

    IN inWeightAvg_Sh          TFloat ,
    IN inWeightAvg_Nom         TFloat ,
    IN inWeightAvg_Ves         TFloat ,
    IN inTax_Sh                TFloat ,
    IN inTax_Nom               TFloat ,
    IN inTax_Ves               TFloat ,

   OUT outWeightMin_Sh         TFloat,
   OUT outWeightMax_Sh         TFloat,
   OUT outWeightMin_Nom        TFloat,
   OUT outWeightMax_Nom        TFloat,
   OUT outWeightMin_Ves        TFloat,
   OUT outWeightMax_Ves        TFloat,

    IN inisGoodsTypeKind_Sh    Boolean , -- Штучный
    IN inisGoodsTypeKind_Nom   Boolean , -- Номинальный
    IN inisGoodsTypeKind_Ves   Boolean , -- Неноминальный
   OUT outisCodeCalc_Diff      Boolean , -- Повтор кода ВМС
   OUT outCodeCalc_Sh          TVarChar, -- Код ВМС шт.
   OUT outCodeCalc_Nom         TVarChar, -- Код ВМС номинал
   OUT outCodeCalc_Ves         TVarChar, -- Код ВМС неноминал
   OUT outWmsCode              Integer , -- новый Код ВМС*
   OUT outWmsCodeCalc_Sh       TVarChar, -- новый Код ВМС* шт.
   OUT outWmsCodeCalc_Nom      TVarChar, -- новый Код ВМС* номинал
   OUT outWmsCodeCalc_Ves      TVarChar, -- новый Код ВМС* неноминал

    IN inWmsCellNum                Integer  , -- № Ячейки на складе ВМС

    IN inRetail1Id                 Integer  , -- Сеть 1
    IN inRetail2Id                 Integer  , -- Сеть 2
    IN inRetail3Id                 Integer  , -- Сеть 3
    IN inRetail4Id                 Integer  , -- Сеть 4
    IN inRetail5Id                 Integer  , -- Сеть 5
    IN inRetail6Id                 Integer  , -- Сеть 6
 INOUT ioBoxId_Retail1             Integer  , -- ящик для Сети 1
 INOUT ioBoxId_Retail2             Integer  , -- ящик для Сети 2
 INOUT ioBoxId_Retail3             Integer  , -- ящик для Сети 3
 INOUT ioBoxId_Retail4             Integer  , -- ящик для Сети 4
 INOUT ioBoxId_Retail5             Integer  , -- ящик для Сети 5
 INOUT ioBoxId_Retail6             Integer  , -- ящик для Сети 6
   OUT outBoxName_Retail1          TVarChar , -- ящик Название для Сети 1
   OUT outBoxName_Retail2          TVarChar , -- ящик Название для Сети 2
   OUT outBoxName_Retail3          TVarChar , -- ящик Название для Сети 3
   OUT outBoxName_Retail4          TVarChar , -- ящик Название для Сети 4
   OUT outBoxName_Retail5          TVarChar , -- ящик Название для Сети 5
   OUT outBoxName_Retail6          TVarChar , -- ящик Название для Сети 6
 INOUT ioCountOnBox_Retail1        TFloat   , -- количество ед. в ящ. для Сети 1
 INOUT ioCountOnBox_Retail2        TFloat   , -- количество ед. в ящ. для Сети 2
 INOUT ioCountOnBox_Retail3        TFloat   , -- количество ед. в ящ. для Сети 3
 INOUT ioCountOnBox_Retail4        TFloat   , -- количество ед. в ящ. для Сети 4
 INOUT ioCountOnBox_Retail5        TFloat   , -- количество ед. в ящ. для Сети 5
 INOUT ioCountOnBox_Retail6        TFloat   , -- количество ед. в ящ. для Сети 6

 INOUT ioWeightOnBox_Retail1       TFloat   , -- количество кг. в ящ. для Сети 1
 INOUT ioWeightOnBox_Retail2       TFloat   , -- количество кг. в ящ. для Сети 2
 INOUT ioWeightOnBox_Retail3       TFloat   , -- количество кг. в ящ. для Сети 3
 INOUT ioWeightOnBox_Retail4       TFloat   , -- количество кг. в ящ. для Сети 4
 INOUT ioWeightOnBox_Retail5       TFloat   , -- количество кг. в ящ. для Сети 5
 INOUT ioWeightOnBox_Retail6       TFloat   , -- количество кг. в ящ. для Сети 6

    IN inSession               TVarChar
)

RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbGoodsPropertyBoxId    Integer;
   DECLARE vbWmsCode               Integer;
   DECLARE vbBoxId_Retail          Integer;
   DECLARE vbGoodsPropertyValueId  Integer;
   DECLARE vbGoodsByGoodsKindId_sh Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_VMC());

--RAISE EXCEPTION 'Ошибка.  <%>.', ioBoxId_Retail2;
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


   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
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
   --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMin(), ioId, inWeightMin);
   -- сохранили свойство <>
   --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMax(), ioId, inWeightMax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Height(), ioId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Length(), ioId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Width(), ioId, inWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormInDays(), ioId, inNormInDays);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum(), ioId, inWmsCellNum);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh(), ioId, inWeightAvg_Sh);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom(), ioId, inWeightAvg_Nom);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves(), ioId, inWeightAvg_Ves);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh(), ioId, inTax_Sh);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom(), ioId, inTax_Nom);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves(), ioId, inTax_Ves);


   -- сохранили связь с <Товар (из категории "Штучный")>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods_Sh(), ioId, inGoodsId_sh);
   -- сохранили связь с <Вид Товара (из категории "Штучный")>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh(), ioId, inGoodsKindId_sh);

   IF inisGoodsTypeKind_Sh = TRUE
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh(), ioId, zc_Enum_GoodsTypeKind_Sh());

       IF inGoodsId_sh > 0
       THEN
           -- проверка
           IF COALESCE (inGoodsKindId_sh, 0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Не установлен <Альтернативный Вид товара (из кат."Штучный")>.';
           END IF;

           -- нашли куда продублировать - только для Категории ШТ.
           vbGoodsByGoodsKindId_sh:= (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                      FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                      WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId                          = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                        AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   = inGoodsId_sh
                                        AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = inGoodsKindId_sh
                                     );
           --
           PERFORM gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Sh (inId                 := vbGoodsByGoodsKindId_sh
                                                                    , inGoodsId            := inGoodsId_sh
                                                                    , inGoodsKindId        := inGoodsKindId_sh
                                                                    , inIsGoodsTypeKind_Sh := TRUE
                                                                    , inSession            := inSession
                                                                     );
           -- если был Insert
           IF COALESCE (vbGoodsByGoodsKindId_sh, 0) = 0
           THEN
               -- еще раз - нашли куда продублировать - только для Категории ШТ.
               vbGoodsByGoodsKindId_sh:= (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                          FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                               LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                          WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId                          = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                            AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   = inGoodsId_sh
                                            AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = inGoodsKindId_sh
                                         );
           END IF;

           -- сохранили свойство <>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh(), vbGoodsByGoodsKindId_sh, inWeightAvg_Sh);
           -- сохранили свойство <>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh(), vbGoodsByGoodsKindId_sh, inTax_Sh);

       END IF;

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


   -- WmsCode
   IF inisGoodsTypeKind_Sh = TRUE OR inisGoodsTypeKind_Nom = TRUE OR inisGoodsTypeKind_Ves = TRUE
   THEN
       IF NOT EXISTS (SELECT ObjectFloat.ValueData
                      FROM ObjectFloat
                      WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
                        AND ObjectFloat.ObjectId = ioId
                        AND ObjectFloat.ValueData <> 0
                      )
       THEN
           -- находим макс код + 1
           vbWmsCode := (COALESCE ( (SELECT MAX (ObjectFloat.ValueData) FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()),0) + 1 ) :: Integer;
           -- записываем новый код = последнему сохр + 1
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WmsCode(), ioId, vbWmsCode);
       END IF;
   END IF;


   -- если внесли ящик 1 тогда сохраняем данные
   IF COALESCE (inBoxId,0) <> 0
   THEN
       -- проверка что в свойство ящик2 - выбран ящик2
       IF inBoxId NOT IN (zc_Box_E2(), zc_Box_E3())
       THEN
           RAISE EXCEPTION 'Ошибка.Значение  <%> не может быть записано в свойство <Ящик Е2/Е3>.', lfGet_Object_ValueData (inBoxId);
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

      /* outWeightGross := inWeightOnBox + (SELECT ObjectFloat_Weight.ValueData
                                          FROM ObjectFloat AS ObjectFloat_Weight
                                          WHERE ObjectFloat_Weight.ObjectId = inBoxId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                                          );
      */

   END IF;

   -- если внесли ящик 2 тогда сохраняем данные
   IF COALESCE (inBoxId_2,0) <> 0
   THEN
       -- проверка что в свойство ящик2 - выбран ящик2
       IF inBoxId_2 IN (zc_Box_E2(), zc_Box_E3())
       THEN
           RAISE EXCEPTION 'Ошибка.Значение <%> не может быть записано в свойство <ГофроЯщик>.', lfGet_Object_ValueData (inBoxId_2);
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

       /*outWeightGross_2 := inWeightOnBox_2 + (SELECT ObjectFloat_Weight.ValueData
                                              FROM ObjectFloat AS ObjectFloat_Weight
                                              WHERE ObjectFloat_Weight.ObjectId = inBoxId_2
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                                              );
      */
   END IF;


   --- cвойства GoodsPropertyValue ящики для сетей
   IF COALESCE (inRetail1Id,0) = 0 AND (COALESCE (ioBoxId_Retail1,0) <> 0 OR COALESCE (ioCountOnBox_Retail1,0) <> 0 OR COALESCE (ioWeightOnBox_Retail1,0) <> 0) THEN ioBoxId_Retail1:= 0; outBoxName_Retail1:= ''; ioCountOnBox_Retail1:= 0; ioWeightOnBox_Retail1:= 0; RAISE EXCEPTION 'Ошибка.Не определено значение Сети 1.'; END IF;
   IF COALESCE (inRetail2Id,0) = 0 AND (COALESCE (ioBoxId_Retail2,0) <> 0 OR COALESCE (ioCountOnBox_Retail2,0) <> 0 OR COALESCE (ioWeightOnBox_Retail2,0) <> 0) THEN ioBoxId_Retail2:= 0; outBoxName_Retail2:= ''; ioCountOnBox_Retail2:= 0; ioWeightOnBox_Retail2:= 0; RAISE EXCEPTION 'Ошибка.Не определено значение Сети 2.'; END IF;
   IF COALESCE (inRetail3Id,0) = 0 AND (COALESCE (ioBoxId_Retail3,0) <> 0 OR COALESCE (ioCountOnBox_Retail3,0) <> 0 OR COALESCE (ioWeightOnBox_Retail3,0) <> 0) THEN ioBoxId_Retail3:= 0; outBoxName_Retail3:= ''; ioCountOnBox_Retail3:= 0; ioWeightOnBox_Retail3:= 0; RAISE EXCEPTION 'Ошибка.Не определено значение Сети 3.'; END IF;
   IF COALESCE (inRetail4Id,0) = 0 AND (COALESCE (ioBoxId_Retail4,0) <> 0 OR COALESCE (ioCountOnBox_Retail4,0) <> 0 OR COALESCE (ioWeightOnBox_Retail4,0) <> 0) THEN ioBoxId_Retail4:= 0; outBoxName_Retail4:= ''; ioCountOnBox_Retail4:= 0; ioWeightOnBox_Retail4:= 0; RAISE EXCEPTION 'Ошибка.Не определено значение Сети 4.'; END IF;
   IF COALESCE (inRetail5Id,0) = 0 AND (COALESCE (ioBoxId_Retail5,0) <> 0 OR COALESCE (ioCountOnBox_Retail5,0) <> 0 OR COALESCE (ioWeightOnBox_Retail5,0) <> 0) THEN ioBoxId_Retail5:= 0; outBoxName_Retail5:= ''; ioCountOnBox_Retail5:= 0; ioWeightOnBox_Retail5:= 0; RAISE EXCEPTION 'Ошибка.Не определено значение Сети 5.'; END IF;
   IF COALESCE (inRetail6Id,0) = 0 AND (COALESCE (ioBoxId_Retail6,0) <> 0 OR COALESCE (ioCountOnBox_Retail6,0) <> 0 OR COALESCE (ioWeightOnBox_Retail6,0) <> 0) THEN ioBoxId_Retail6:= 0; outBoxName_Retail6:= ''; ioCountOnBox_Retail6:= 0; ioWeightOnBox_Retail6:= 0; RAISE EXCEPTION 'Ошибка.Не определено значение Сети 6.'; END IF;

   -- находим первый введенный ящик
   IF COALESCE (ioBoxId_Retail1,0) <> 0    --
   THEN
       vbBoxId_Retail := ioBoxId_Retail1;
   ELSE
       IF COALESCE (ioBoxId_Retail2,0) <> 0  --
       THEN
           vbBoxId_Retail := ioBoxId_Retail2;
       ELSE
           IF COALESCE (ioBoxId_Retail3,0) <> 0   --
           THEN
               vbBoxId_Retail := ioBoxId_Retail3;
           ELSE
               IF COALESCE (ioBoxId_Retail4,0) <> 0   --
               THEN
                   vbBoxId_Retail := ioBoxId_Retail4;
               ELSE
                   IF COALESCE (ioBoxId_Retail5,0) <> 0  --
                   THEN
                       vbBoxId_Retail := ioBoxId_Retail5;
                   ELSE
                       IF COALESCE (ioBoxId_Retail6,0) <> 0  --
                       THEN
                           vbBoxId_Retail := COALESCE (ioBoxId_Retail6,0);
                       END IF;
                   END IF;
               END IF;
           END IF;
       END IF;
   END IF;

   --
   IF COALESCE (inRetail1Id,0) <> 0
   THEN
       -- проверяем чтоб 1 сеть  = 1 классификатор св-в товаров
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail1Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION 'Ошибка. Сети <%> соответствует более одного классификатора', lfGet_Object_ValueData (inRetail1Id);
       END IF;

       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail1Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- сохранили связь с <Ящик>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- сохранили свойство <количество кг. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail1);
           -- сохранили свойство <количество ед. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail1);
       END IF;
       ioBoxId_Retail1 := vbBoxId_Retail;
       outBoxName_Retail1 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail1 := 0;
       outBoxName_Retail1 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail2Id,0) <> 0
   THEN
       -- проверяем чтоб 1 сеть  = 1 классификатор св-в товаров
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail2Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION 'Ошибка. Сети <%> соответствует более одного классификатора', lfGet_Object_ValueData (inRetail2Id);
       END IF;

       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail2Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- сохранили связь с <Ящик>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- сохранили свойство <количество кг. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail2);
           -- сохранили свойство <количество ед. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail2);
       END IF;
       ioBoxId_Retail2 := vbBoxId_Retail;
       outBoxName_Retail2 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail2 := 0;
       outBoxName_Retail2 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail3Id,0) <> 0
   THEN
       -- проверяем чтоб 1 сеть  = 1 классификатор св-в товаров
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail3Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION 'Ошибка. Сети <%> соответствует более одного классификатора', lfGet_Object_ValueData (inRetail3Id);
       END IF;

       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail3Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- сохранили связь с <Ящик>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- сохранили свойство <количество кг. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail3);
           -- сохранили свойство <количество ед. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail3);
       END IF;
       ioBoxId_Retail2 := vbBoxId_Retail;
       outBoxName_Retail3 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail3 := 0;
       outBoxName_Retail3 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail4Id,0) <> 0
   THEN
       -- проверяем чтоб 1 сеть  = 1 классификатор св-в товаров
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail4Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION 'Ошибка. Сети <%> соответствует более одного классификатора', lfGet_Object_ValueData (inRetail4Id);
       END IF;

       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail4Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- сохранили связь с <Ящик>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- сохранили свойство <количество кг. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail4);
           -- сохранили свойство <количество ед. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail4);
       END IF;
       ioBoxId_Retail4 := vbBoxId_Retail;
       outBoxName_Retail4 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail4 := 0;
       outBoxName_Retail4 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail5Id,0) <> 0
   THEN
       -- проверяем чтоб 1 сеть  = 1 классификатор св-в товаров
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail5Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION 'Ошибка. Сети <%> соответствует более одного классификатора', lfGet_Object_ValueData (inRetail5Id);
       END IF;

       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail5Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- сохранили связь с <Ящик>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- сохранили свойство <количество кг. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail5);
           -- сохранили свойство <количество ед. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail5);
       END IF;
       ioBoxId_Retail5 := vbBoxId_Retail;
       outBoxName_Retail5 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail5 := 0;
       outBoxName_Retail5 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail6Id,0) <> 0
   THEN
       -- проверяем чтоб 1 сеть  = 1 классификатор св-в товаров
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail6Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION 'Ошибка. Сети <%> соответствует более одного классификатора', lfGet_Object_ValueData (inRetail6Id);
       END IF;

       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail6Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- сохранили связь с <Ящик>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- сохранили свойство <количество кг. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail6);
           -- сохранили свойство <количество ед. в ящ.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail6);
       END IF;
       ioBoxId_Retail6 := vbBoxId_Retail;
       outBoxName_Retail6 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail6 := 0;
       outBoxName_Retail6 := ''::TVarChar;
   END IF;

   -- исходящие параметры все из селекта
   -- расчет кодов ВМС
   SELECT tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves, tmp.isCodeCalc_Diff
        , tmp.WmsCodeCalc_Sh, tmp.WmsCodeCalc_Nom, tmp.WmsCodeCalc_Ves, tmp.WmsCode

        , tmp.WeightOnBox
        , tmp.WeightGross_Sh, tmp.WeightGross_Nom, tmp.WeightGross_Ves
        , tmp.WeightAvgGross_Sh, tmp.WeightAvgGross_Nom, tmp.WeightAvgGross_Ves
        , tmp.WeightAvgNet_Sh, tmp.WeightAvgNet_Nom, tmp.WeightAvgNet_Ves
        , tmp.WeightOnBox_2, tmp.WeightGross_2, tmp.WeightAvgGross_2, tmp.WeightAvgNet_2

     INTO outCodeCalc_Sh, outCodeCalc_Nom, outCodeCalc_Ves, outisCodeCalc_Diff
        , outWmsCodeCalc_Sh, outWmsCodeCalc_Nom, outWmsCodeCalc_Ves, outWmsCode

        , outWeightOnBox
        , outWeightGross_sh   , outWeightGross_nom, outWeightGross_ves
        , outWeightAvgGross_sh, outWeightAvgGross_nom, outWeightAvgGross_ves
        , outWeightAvgNet_sh, outWeightAvgNet_nom, outWeightAvgNet_ves
        , outWeightOnBox_2, outWeightGross_2, outWeightAvgGross_2, outWeightAvgNet_2
   FROM (WITH
             tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.*
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Sh
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Nom
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Ves

                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0
                                                 THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN 1 ELSE 0 END)
                                                 ELSE NULL
                                            END  :: TVarChar AS CodeCalc_Sh
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0
                                                 THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN 2 ELSE 0 END)
                                                 ELSE NULL
                                            END  :: TVarChar AS CodeCalc_Nom
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0
                                                 THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN 3 ELSE 0 END)
                                                 ELSE NULL
                                            END  :: TVarChar AS CodeCalc_Ves
                                          --
                                          , ObjectFloat_WmsCode.ValueData AS WmsCode

                                          , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId <> 0
                                                 THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                                   || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                                -- || '.'
                                                   || '1'
                                                 ELSE ''
                                            END :: TVarChar AS WmsCodeCalc_Sh

                                          , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId <> 0
                                                 THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                                    || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                                --  || '.'
                                                    || '2'
                                                 ELSE ''
                                            END :: TVarChar AS WmsCodeCalc_Nom

                                          , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId  <> 0
                                                 THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                                    || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                                 -- || '.'
                                                    || '3'
                                                 ELSE ''
                                            END :: TVarChar AS WmsCodeCalc_Ves

                                     FROM Object_GoodsByGoodsKind_View
                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsMain
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsMain.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsMain.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsMain()
                                          LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBrand
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsBrand.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsBrand.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBrand()
                                          LEFT JOIN Object AS Object_GoodsBrand ON Object_GoodsBrand.Id = ObjectLink_GoodsByGoodsKind_GoodsBrand.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh()
                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves()

                                          LEFT JOIN ObjectFloat AS ObjectFloat_WmsCode
                                                                ON ObjectFloat_WmsCode.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                               AND ObjectFloat_WmsCode.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
                                     WHERE Object_GoodsByGoodsKind_View.Id = ioId   --403369 --
                                     )
           , tmpCodeCalc AS (SELECT tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves
                                  , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Sh) AS Count1
                                  , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Nom) AS Count2
                                  , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Ves) AS Count3
                             FROM tmpGoodsByGoodsKind AS tmp
                             WHERE tmp.isGoodsTypeKind_Sh  <> False
                                OR tmp.isGoodsTypeKind_Nom <> False
                                OR tmp.isGoodsTypeKind_Ves <> False
                             GROUP BY tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves
                             )

           , tmpGoodsPropertyBox AS (SELECT ObjectLink_GoodsPropertyBox_Goods.ChildObjectId     AS GoodsId
                                          , ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId AS GoodsKindId

                                          , ObjectLink_GoodsPropertyBox_Box.ChildObjectId  AS BoxId

                                          , ObjectFloat_WeightOnBox.ValueData    AS WeightOnBox
                                          , ObjectFloat_CountOnBox.ValueData     AS CountOnBox
                                          , ObjectFloat_Weight.ValueData         AS BoxWeight
                                      FROM Object AS Object_GoodsPropertyBox
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                                ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = Object_GoodsPropertyBox.Id
                                                               AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()

                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                                                ON ObjectLink_GoodsPropertyBox_Goods.ObjectId = Object_GoodsPropertyBox.Id
                                                               AND ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()

                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                                ON ObjectLink_GoodsPropertyBox_Box.ObjectId = Object_GoodsPropertyBox.Id
                                                               AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                                               AND (ObjectLink_GoodsPropertyBox_Box.ChildObjectId IN (inBoxId, inBoxId_2))   --  (1036512,1036504 ))---
                                           LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                                                 ON ObjectFloat_WeightOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                                AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()

                                           LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                                                 ON ObjectFloat_CountOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                                AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()

                                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                 ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()

                                      WHERE Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                                        AND Object_GoodsPropertyBox.isErased = FALSE
                     )

               --
               SELECT Object_GoodsByGoodsKind_View.CodeCalc_Sh  :: TVarChar           -- шт. - расчет: код на упак+вид+бренд+категория
                   , Object_GoodsByGoodsKind_View.CodeCalc_Nom  :: TVarChar          -- номинал - расчет: код на упак+вид+бренд+категория
                   , Object_GoodsByGoodsKind_View.CodeCalc_Ves  :: TVarChar          -- неноминал - расчет: код на упак+вид+бренд+категория

                     -- Повтор кода ВМС - расчет: код на упак+вид+бренд+категория
                   , CASE WHEN Object_GoodsByGoodsKind_View.isGoodsTypeKind_Sh = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Nom = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Ves = FALSE THEN FALSE
                          WHEN (COALESCE (tmpCodeCalc_1.Count1, 1) + COALESCE (tmpCodeCalc_2.Count2, 1) + COALESCE (tmpCodeCalc_3.Count3, 1)) <= 3 THEN FALSE
                          ELSE TRUE
                     END  AS isCodeCalc_Diff                                         -- Повтор кода ВМС

                   , Object_GoodsByGoodsKind_View.WmsCode          :: Integer        -- Код ВМС* для выгрузки
                   , Object_GoodsByGoodsKind_View.WmsCodeCalc_Sh   :: TVarChar       -- шт. - Код ВМС* для выгрузки
                   , Object_GoodsByGoodsKind_View.WmsCodeCalc_Nom  :: TVarChar       -- номинал - Код ВМС* для выгрузки
                   , Object_GoodsByGoodsKind_View.WmsCodeCalc_Ves  :: TVarChar       -- неноминал - Код ВМС* для выгрузки

                      -- Кол-во кг. в ящ. (E2/E3)
                    , CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                           ELSE tmpGoodsPropertyBox.WeightOnBox
                      END :: TFloat AS WeightOnBox

                      -- Вес брутто полного ящика (E2/E3)
                    /*, (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross
                      */

                      --шт
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Sh.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Sh.ValueData,0)
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross_Sh
                     -- номинал
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Nom.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Nom.ValueData,0)
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross_Nom
                    -- неноминал
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Ves.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Ves.ValueData,0)
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross_Ves

                     -- Вес брутто по среднему весу ящика (E2/E3)
                    /*, (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_Avg_Sh.ValueData > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * ObjectFloat_Avg_Sh.ValueData
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross*/
                     -- Вес брутто полного ящика "по среднему весу" (E2/E3)
                     --шт.
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Sh.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Sh.ValueData,0)
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross_Sh
                     -- номинал
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Nom.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Nom.ValueData,0)
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross_Nom
                     -- неноминал
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Ves.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Ves.ValueData,0)
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross_Ves

                      -- Вес нетто по среднему весу ящика (E2/E3) - тоже что и WeightOnBox
                    --шт
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Sh.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Sh.ValueData,0)
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_Sh
                     -- номинал
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Nom.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Nom.ValueData,0)
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_Nom
                     -- неноминал
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Ves.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Ves.ValueData,0)
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_Ves

                      -- Кол-во кг. в ящ. (Гофра)
                    , CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                           ELSE tmpGoodsPropertyBox_2.WeightOnBox
                      END :: TFloat AS WeightOnBox_2

                      -- Вес брутто полного ящика (Гофра)
                    , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE tmpGoodsPropertyBox_2.WeightOnBox
                       END
                     + tmpGoodsPropertyBox_2.BoxWeight
                      ) :: TFloat AS WeightGross_2

                     -- Вес брутто по среднему весу ящика (Гофра)
                    , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox_2.BoxWeight
                      ) :: TFloat AS WeightAvgGross_2

                      -- Вес нетто по среднему весу ящика (Гофра)
                    , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_2

               FROM tmpGoodsByGoodsKind AS Object_GoodsByGoodsKind_View
                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightMin
                                          ON ObjectFloat_WeightMin.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_WeightMin.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightMin()

                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightMax
                                          ON ObjectFloat_WeightMax.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_WeightMax.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightMax()

                    LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Sh
                                          ON ObjectFloat_Avg_Sh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_Avg_Sh.DescId = zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Nom
                                          ON ObjectFloat_Avg_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_Avg_Nom.DescId = zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Ves
                                          ON ObjectFloat_Avg_Ves.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_Avg_Ves.DescId = zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves()

                    LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Sh , tmpCodeCalc.Count1 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Sh  IS NOT NULL) AS tmpCodeCalc_1 ON tmpCodeCalc_1.CodeCalc_Sh = Object_GoodsByGoodsKind_View.CodeCalc_Sh
                    LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Nom, tmpCodeCalc.Count2 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Nom IS NOT NULL) AS tmpCodeCalc_2 ON tmpCodeCalc_2.CodeCalc_Nom = Object_GoodsByGoodsKind_View.CodeCalc_Nom
                    LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Ves, tmpCodeCalc.Count3 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Ves IS NOT NULL) AS tmpCodeCalc_3 ON tmpCodeCalc_3.CodeCalc_Ves = Object_GoodsByGoodsKind_View.CodeCalc_Ves

                    LEFT JOIN tmpGoodsPropertyBox ON tmpGoodsPropertyBox.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                                 AND tmpGoodsPropertyBox.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
                                                 AND tmpGoodsPropertyBox.BoxId IN (zc_Box_E2(), zc_Box_E3())

                    LEFT JOIN tmpGoodsPropertyBox AS tmpGoodsPropertyBox_2
                                                  ON tmpGoodsPropertyBox_2.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                                 AND tmpGoodsPropertyBox_2.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
                                                 AND tmpGoodsPropertyBox_2.BoxId NOT IN (zc_Box_E2(), zc_Box_E3())
               ) AS tmp;

/*   SELECT CodeCalc_Sh, CodeCalc_Nom, CodeCalc_Ves, isCodeCalc_Diff
        , WmsCodeCalc_Sh, WmsCodeCalc_Nom, WmsCodeCalc_Ves, WmsCode

        , tmp.WeightOnBox, tmp.WeightGross, tmp.WeightAvgGross, tmp.WeightAvgNet
        , tmp.WeightOnBox_2, tmp.WeightGross_2, tmp.WeightAvgGross_2, tmp.WeightAvgNet_2

     INTO outCodeCalc_Sh, outCodeCalc_Nom, outCodeCalc_Ves, outisCodeCalc_Diff
        , outWmsCodeCalc_Sh, outWmsCodeCalc_Nom, outWmsCodeCalc_Ves, outWmsCode

        , outWeightOnBox, outWeightGross, outWeightAvgGross, outWeightAvgNet
        , outWeightOnBox_2, outWeightGross_2, outWeightAvgGross_2, outWeightAvgNet_2
   FROM gpSelect_Object_GoodsByGoodsKind_VMC (0,0,0,0,0,0,inSession) AS tmp                --- Не важно какие сети
   WHERE tmp.Id = ioId;
   */


   outWeightMin_Sh  := (inWeightAvg_Sh  * (1-inTax_Sh/100))  :: TFloat;
   outWeightMax_Sh  := (inWeightAvg_Sh  * (1+inTax_Sh/100))  :: TFloat;
   outWeightMin_Nom := (inWeightAvg_Nom * (1-inTax_Nom/100)) :: TFloat;
   outWeightMax_Nom := (inWeightAvg_Nom * (1+inTax_Nom/100)) :: TFloat;
   outWeightMin_Ves := (inWeightAvg_Ves * (1-inTax_Ves/100)) :: TFloat;
   outWeightMax_Ves := (inWeightAvg_Ves * (1+inTax_Ves/100)) :: TFloat;


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.20         *
 10.04.19         *
 29.03.19         *
 22.03.19         *
 13.03.19         *
 22.06.18         *
*/

-- тест
--