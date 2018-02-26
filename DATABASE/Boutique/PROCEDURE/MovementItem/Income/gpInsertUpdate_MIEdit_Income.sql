-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MIEdit_Income(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsGroupId          Integer   , --
    IN inMeasureId             Integer   , --
    IN inJuridicalId           Integer   , -- Юр.лицо(наше)
 INOUT ioGoodsCode             Integer   , -- код товара
    IN inGoodsName             TVarChar  , -- Товары
    IN inGoodsInfoName         TVarChar  , --
    IN inGoodsSizeName         TVarChar  , --
    IN inCompositionName       TVarChar  , --
    IN inLineFabricaName       TVarChar  , --
    IN inLabelName             TVarChar  , --
    IN inAmount                TFloat    , -- Количество
    IN inOperPrice             TFloat    , -- Цена
    IN inCountForPrice         TFloat    , -- Цена за количество
    IN inOperPriceList         TFloat    , -- Цена по прайсу
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbLineFabricaId Integer;
   DECLARE vbCompositionId Integer;
   DECLARE vbGoodsSizeId   Integer;
   DECLARE vbGoodsId       Integer;
   DECLARE vbGoodsId_find  Integer;
   DECLARE vbGoodsInfoId   Integer;
   DECLARE vbGoodsItemId   Integer;
   DECLARE vbLabelId       Integer;

   DECLARE vbOperDate  TDateTime;
   DECLARE vbPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;

     -- Параметры из документа
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbPartnerId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

     -- проверка - свойство должно быть установлено
     IF COALESCE (vbPartnerId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Поcтавщик>.';
     END IF;


     -- Линия коллекции
     inLineFabricaName:= TRIM (inLineFabricaName);
     IF inLineFabricaName <> ''
     THEN
         -- Поиск
         vbLineFabricaId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_LineFabrica() AND LOWER (Object.ValueData) = LOWER (inLineFabricaName));
         --
         IF COALESCE (vbLineFabricaId, 0) = 0
         THEN
             -- Создание
             vbLineFabricaId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_LineFabrica (ioId     := 0
                                                                                       , ioCode   := 0
                                                                                       , inName   := inLineFabricaName
                                                                                       , inSession:= inSession
                                                                                         ) AS tmp);
         END IF;
     END IF;

     -- Состав товара
     inCompositionName:= TRIM (inCompositionName);
     IF inCompositionName <> ''
     THEN
         -- Поиск !!!без Группы!!!
         vbCompositionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND LOWER (Object.ValueData) = LOWER (inCompositionName));   -- limit 1 так как ошибка  для inCompositionName = '100%шерсть'  возвращает 2 строки
         --
         IF COALESCE (vbCompositionId,0) = 0
         THEN
             -- Создание
             vbCompositionId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Composition (ioId                 := 0
                                                                                       , ioCode               := 0
                                                                                       , inName               := inCompositionName
                                                                                       , inCompositionGroupId := 0 -- сохраняем с пустой группой
                                                                                       , inSession            := inSession
                                                                                         ) AS tmp);
         END IF;
     END IF;

     -- Описание товара
     inGoodsInfoName:= TRIM (inGoodsInfoName);
     IF COALESCE (TRIM (inGoodsInfoName), '') <> ''
     THEN
         -- Поиск !!!без Группы!!!
         vbGoodsInfoId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsInfo() AND LOWER (Object.ValueData) = LOWER (inGoodsInfoName));   --  '\%'  так как ошибка для  inGoodsInfoName = '\текст  '   так как обратный слеше не экранирован в параметре постгреса 
         --
         IF COALESCE (vbGoodsInfoId, 0) = 0
         THEN
             -- Создание
             vbGoodsInfoId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsInfo (ioId     := 0
                                                                                   , ioCode   := 0
                                                                                   , inName   := inGoodsInfoName
                                                                                   , inSession:= inSession
                                                                                     ) AS tmp);
         END IF;
     END IF;

     -- Название для ценника
     inLabelName:= TRIM (inLabelName);
     IF inLabelName <> ''
     THEN
         -- Поиск
         vbLabelId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND LOWER (Object.ValueData) = LOWER (inLabelName));
         --
         IF COALESCE (vbLabelId, 0) = 0
         THEN
             -- Создание
             vbLabelId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Label (ioId     := 0
                                                                           , ioCode   := 0
                                                                           , inName   := inLabelName
                                                                           , inSession:= inSession
                                                                             ) AS tmp);
         END IF;
     END IF;

     -- Размер товара
     inGoodsSizeName:= COALESCE (TRIM (inGoodsSizeName), '');
     -- проверка - свойство должно быть установлено
     -- IF inGoodsSizeName = '' THEN
     --    RAISE EXCEPTION 'Ошибка.Не установлено значение <Размер товара>.';
     -- END IF;
     --
     -- Поиск - ВСЕГДА
     vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND LOWER (Object.ValueData) = LOWER (inGoodsSizeName));
     --
     IF COALESCE (vbGoodsSizeId, 0) = 0
     THEN
         -- Создание
         vbGoodsSizeId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsSize (ioId     := 0
                                                                               , ioCode   := 0
                                                                               , inName   := inGoodsSizeName
                                                                               , inSession:= inSession
                                                                                 ) AS tmp);
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inGoodsGroupId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Группа товаров>.';
     END IF;

     -- проверка - свойство должно быть установлено
     inGoodsName:= COALESCE (TRIM (inGoodsName), '');
     IF inGoodsName = '' THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
     
     -- для загрузки из Sybase т.к. там код НЕ = 0 
     IF vbUserId = zc_User_Sybase()
     THEN
         -- Поиск - !!!без группы!!! + inGoodsName + ioGoodsCode
         vbGoodsId:= (SELECT DISTINCT Object.Id
                      FROM Object
                           -- обязательно условие из партии
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                                                         AND Object_PartionGoods.PartnerId = vbPartnerId -- Марка + Год + Сезон
                      WHERE Object.DescId     = zc_Object_Goods()
                        AND Object.ValueData  = inGoodsName
                        AND Object.ObjectCode = -1 * ioGoodsCode
                     );
     ELSE
         -- Поиск
         vbGoodsId:= (SELECT DISTINCT Object.Id
                      FROM Object
                           -- обязательно условие из партии
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                                                         AND Object_PartionGoods.PartnerId = vbPartnerId -- Марка + Год + Сезон
                           INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                 ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                                AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                                AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId
                      WHERE Object.DescId    = zc_Object_Goods()
                        AND Object.ValueData = inGoodsName
                     );

         -- Если НЕ нашли - продолжаем Поиск "свободных"
         IF COALESCE (vbGoodsId, 0) = 0
         THEN
             vbGoodsId:= (SELECT Object.Id
                          FROM Object
                               INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                     ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                                    AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                                    AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId
                               -- партии
                               LEFT JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                          WHERE Object.DescId    = zc_Object_Goods()
                            AND Object.ValueData = inGoodsName
                            AND Object_PartionGoods.GoodsId IS NULL
                         );
         END IF;

         -- Если НЕ нашли И Корректировка + ОН ОДИН - ОСТАВЛЯЕМ тот же самый
         IF COALESCE (vbGoodsId, 0) = 0 AND ioId <> 0
         THEN
             -- взяли из партии
             vbGoodsId_find = (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId);
                         
             -- сколько партий с этим товаром
             IF 1 = (SELECT COUNT (*) FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find)
             THEN
                 -- ОСТАВЛЯЕМ тот же самый
                 vbGoodsId:= vbGoodsId_find;
             END IF;
             
         END IF;

     END IF;


     IF COALESCE (vbGoodsId, 0) = 0
     THEN
         -- Создание
         SELECT tmp.ioId, tmp.ioCode 
                INTO vbGoodsId, ioGoodsCode
         FROM gpInsertUpdate_Object_Goods (ioId            := vbGoodsId
                                         , ioCode          := ioGoodsCode
                                         , inName          := inGoodsName
                                         , inGoodsGroupId  := inGoodsGroupId
                                         , inMeasureId     := inMeasureId
                                         , inCompositionId := vbCompositionId
                                         , inGoodsInfoId   := vbGoodsInfoId
                                         , inLineFabricaId := vbLineFabricaId
                                         , inLabelId       := vbLabelId
                                         , inSession       := inSession
                                         ) AS tmp;

     ELSE
         -- если изменился - Группы товаров
         IF inGoodsGroupId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsGroup()), 0)
         THEN
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, inGoodsGroupId);
             -- пересохранили - Полное название группы
             PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), vbGoodsId, lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent()));
         END IF;

         -- если изменился - Единицы измерения
         IF inMeasureId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure()), 0)
         THEN
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), vbGoodsId, inMeasureId);
         END IF;

         -- если изменился - Состав товара
         IF vbCompositionId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Composition()), 0)
         THEN
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Composition(), vbGoodsId, vbCompositionId);
         END IF;

         -- если изменился - Описание товара
         IF vbGoodsInfoId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsInfo()), 0)
         THEN
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsInfo(), vbGoodsId, vbGoodsInfoId);
         END IF;

         -- если изменился - Линия коллекции
         IF vbLineFabricaId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_LineFabrica()), 0)
         THEN
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink ( zc_ObjectLink_Goods_LineFabrica(), vbGoodsId, vbLineFabricaId);
         END IF;

         -- если изменился - Название для ценника
         IF vbLabelId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_Label()), 0)
         THEN
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink ( zc_ObjectLink_Goods_Label(), vbGoodsId, vbLabelId);
         END IF;

     END IF;


     -- Товары с размерами - Найдем или Добавим
     vbGoodsItemId:= lpInsertFind_Object_GoodsItem (inGoodsId      := vbGoodsId
                                                  , inGoodsSizeId  := vbGoodsSizeId
                                                  , inPartionId    := ioId
                                                  , inUserId       := vbUserId
                                                   );



     -- Заменили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := vbGoodsId
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := inCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );

     -- cохраняем Object_PartionGoods + Update св-ва у остальных партий этого vbGoodsId
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId := ioId
                                               , inMovementId     := inMovementId
                                               , inPartnerId      := vbPartnerId
                                               , inUnitId         := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inOperDate       := vbOperDate
                                               , inGoodsId        := vbGoodsId
                                               , inGoodsItemId    := vbGoodsItemId
                                               , inCurrencyId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument())
                                               , inAmount         := inAmount
                                               , inOperPrice      := inOperPrice
                                               , inCountForPrice  := inCountForPrice
                                               , inPriceSale      := inOperPriceList -- !!!если не было переоценки!!!
                                               , inBrandId        := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Brand())
                                               , inPeriodId       := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Period())
                                               , inPeriodYear     := (SELECT ObF.ValueData FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbPartnerId AND ObF.DescId = zc_ObjectFloat_Partner_PeriodYear()) :: Integer
                                               , inFabrikaId      := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Fabrika())
                                               , inGoodsGroupId   := inGoodsGroupId
                                               , inMeasureId      := inMeasureId
                                               , inCompositionId  := vbCompositionId
                                               , inGoodsInfoId    := vbGoodsInfoId
                                               , inLineFabricaId  := vbLineFabricaId
                                               , inLabelId        := vbLabelId
                                               , inCompositionGroupId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbCompositionId AND OL.DescId = zc_ObjectLink_Composition_CompositionGroup())
                                               , inGoodsSizeId    := vbGoodsSizeId
                                               , inJuridicalId    := inJuridicalId
                                               , inUserId         := vbUserId
                                                );

     -- !!!Кроме Sybase!!! - !!!не забыли - проверили что НЕТ движения и Переоценки, тогда Цену в истории можно менять!!!
     -- PERFORM lpCheck ...
     -- !!!Кроме Sybase!!! - !!!не забыли - cохранили Цену в истории!!!
     -- PERFORM lpUpdate_ObjectHistory ...

     -- дописали - партию = Id
     UPDATE MovementItem SET PartionId = ioId WHERE MovementItem.Id = ioId AND MovementItem.PartionId IS NULL;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Полятыкин А.А.
 11.05.17                                                        *
 10.05.17                                                        *
 24.04.17                                                        *
 10.04.17         *
*/

-- тест
-- SELECT * FROMgpInsertUpdate_MIEdit_Income()
