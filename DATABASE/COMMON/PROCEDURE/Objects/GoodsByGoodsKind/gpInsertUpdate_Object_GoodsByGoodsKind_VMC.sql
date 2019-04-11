-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , Boolean, Boolean, Boolean
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_VMC(
 INOUT ioId                    Integer  , -- ключ объекта <Товар>
    IN inGoodsId               Integer  , -- Товары
    IN inGoodsKindId           Integer  , -- Виды товаров
    IN inBoxId                 Integer  , -- Ящик (E2/E3)
    IN inBoxId_2               Integer  , -- ящик (Гофра)
    IN inWeightMin             TFloat  , -- Мин. вес
    IN inWeightMax             TFloat  , -- Мах. вес
    IN inHeight                TFloat  , -- Высота
    IN inLength                TFloat  , -- Длина
    IN inWidth                 TFloat  , -- Ширина
    IN inNormInDays            TFloat  , -- Cрок годности, дн.
    IN inCountOnBox            TFloat  , -- Кол-во ед. в ящ. (E2/E3)
    IN inWeightOnBox           TFloat  , -- Кол-во кг. в ящ. (E2/E3)
    IN inCountOnBox_2          TFloat  , -- Кол-во ед. в ящ. (Гофра)
    IN inWeightOnBox_2         TFloat  , -- Кол-во кг. в ящ. (Гофра)
   OUT outWeightGross          TFloat  , -- Вес брутто полного ящика (E2/E3)
   OUT outWeightGross_2        TFloat  , -- Вес брутто полного ящика (Гофра)
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
   DECLARE vbGoodsPropertyBoxId Integer;
   DECLARE vbWmsCode Integer;
   DECLARE vbBoxId_Retail Integer;
   DECLARE vbGoodsPropertyValueId Integer;
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
           vbWmsCode := ((SELECT MAX (ObjectFloat.ValueData) FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()) + 1 ) :: Integer;
           -- записываем новый код = последнему сохр + 1
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WmsCode(), ioId, vbWmsCode);
       END IF;
   END IF;
   
   -- расчет кодов ВМС
   SELECT CodeCalc_Sh, CodeCalc_Nom, CodeCalc_Ves, isCodeCalc_Diff
        , WmsCodeCalc_Sh, WmsCodeCalc_Nom, WmsCodeCalc_Ves, WmsCode
     INTO outCodeCalc_Sh, outCodeCalc_Nom, outCodeCalc_Ves, outisCodeCalc_Diff
        , outWmsCodeCalc_Sh, outWmsCodeCalc_Nom, outWmsCodeCalc_Ves, outWmsCode
   FROM gpSelect_Object_GoodsByGoodsKind_VMC (0,0,0,0,0,0,inSession) AS tmp                --- Не важно какие сети
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
       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = ObjectLink_Retail_GoodsProperty.ChildObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetail1Id
                                    AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
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
   --RAISE EXCEPTION 'Ошибка.  <%>.', vbBoxId_Retail;
       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = ObjectLink_Retail_GoodsProperty.ChildObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetail2Id
                                    AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
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
       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = ObjectLink_Retail_GoodsProperty.ChildObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetail3Id
                                    AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
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
       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = ObjectLink_Retail_GoodsProperty.ChildObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetail4Id
                                    AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
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
       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = ObjectLink_Retail_GoodsProperty.ChildObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetail5Id
                                    AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
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
       -- находим GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = ObjectLink_Retail_GoodsProperty.ChildObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetail6Id
                                    AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
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


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.19         *
 29.03.19         *
 22.03.19         * 
 13.03.19         *
 22.06.18         *
*/

-- тест
-- 