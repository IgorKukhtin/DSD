-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, TVarChar, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, TVarChar, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,Integer,TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MIEdit_Income(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsGroupId          Integer   , --
    IN inMeasureId             Integer   , --
    IN inJuridicalId           Integer   , -- Юр.лицо(наше)
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
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbLineFabricaId Integer;
   DECLARE vbCompositionId Integer; 
   DECLARE vbGoodsSizeId   Integer;
   DECLARE vbGoodsId       Integer;   
   DECLARE vbGoodsInfoId   Integer;
   DECLARE vbGoodsItemId   Integer;
   DECLARE vblabelid       Integer;   

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
         vbLineFabricaId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_LineFabrica() AND UPPER (Object.ValueData) LIKE UPPER (inLineFabricaName) LIMIT 1);
         -- 
         IF COALESCE (vbLineFabricaId, 0) = 0
         THEN
             -- Создание
             vbLineFabricaId := gpInsertUpdate_Object_LineFabrica (ioId     := 0
                                                                 , inCode   := 0
                                                                 , inName   := inLineFabricaName
                                                                 , inSession:= inSession
                                                                  );
         END IF;
     END IF;
     
     -- Состав товара
     inCompositionName:= TRIM (inCompositionName);
     IF inCompositionName <> ''
     THEN
         -- Поиск !!!без Группы!!!
         vbCompositionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND UPPER (Object.ValueData) LIKE UPPER (inCompositionName) LIMIT 1);
         -- 
         IF COALESCE (vbCompositionId,0) = 0
         THEN
             -- Создание
             vbCompositionId := gpInsertUpdate_Object_Composition (ioId                 := 0
                                                                 , inCode               := 0
                                                                 , inName               := inCompositionName
                                                                 , inCompositionGroupId := 0 -- сохраняем с пустой группой
                                                                 , inSession            := inSession
                                                                  );
         END IF;
     END IF;
     
     -- Описание товара 
     inGoodsInfoName:= TRIM (inGoodsInfoName);
     IF COALESCE (TRIM (inGoodsInfoName), '') <> ''
     THEN
         -- Поиск !!!без Группы!!!
         vbGoodsInfoId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsInfo() AND UPPER (Object.ValueData) LIKE UPPER (inGoodsInfoName) LIMIT 1);
         -- 
         IF COALESCE (vbGoodsInfoId, 0) = 0
         THEN
             -- Создание
             vbGoodsInfoId := gpInsertUpdate_Object_GoodsInfo (ioId     := 0
                                                             , inCode   := 0
                                                             , inName   := inGoodsInfoName
                                                             , inSession:= inSession
                                                              );
         END IF;
     END IF;

     -- Название для ценника
     inLabelName:= TRIM (inLabelName);
     IF inLabelName <> ''
     THEN
         -- Поиск
         vbLabelId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND UPPER (Object.ValueData) LIKE UPPER (inLabelName) LIMIT 1);
         -- 
         IF COALESCE (vbLabelId, 0) = 0
         THEN
             -- Создание
             vbLabelId := gpInsertUpdate_Object_Label (ioId     := 0
                                                     , inCode   := 0
                                                     , inName   := inLabelName
                                                     , inSession:= inSession
                                                      );
         END IF;
     END IF;

     -- Размер товара
     inGoodsSizeName:= COALESCE (TRIM (inGoodsSizeName), '');
     -- проверка - свойство должно быть установлено
     IF inGoodsSizeName = '' THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Размер товара>.';
     END IF;
     --
     IF inGoodsSizeName <> ''
     THEN
         -- Поиск
         vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND UPPER (Object.ValueData) LIKE UPPER (inGoodsSizeName) LIMIT 1);
         -- 
         IF COALESCE (vbGoodsSizeId, 0) = 0
         THEN
             -- Создание
             vbGoodsSizeId := gpInsertUpdate_Object_GoodsSize (ioId     := 0
                                                             , inCode   := 0
                                                             , inName   := inGoodsSizeName
                                                             , inSession:= inSession
                                                              );
         END IF;
     END IF;

     -- Товары 
     inGoodsName:= COALESCE (TRIM (inGoodsName), '');
     -- проверка - свойство должно быть установлено
     IF COALESCE (inGoodsGroupId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Группа товаров>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF inGoodsName = '' THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
     -- Поиск - !!!без группы!!!
     vbGoodsId:= (SELECT Object.Id 
                  FROM Object
                       -- обязательно условие из партии
                       INNER JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                                                     AND Object_PartionGoods.PartnerId = vbPartnerId -- Марка + Год + Сезон
                       /*INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                             ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                            AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                            AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId*/
                  WHERE Object.Descid    = zc_Object_Goods()
                    AND Object.ValueData = inGoodsName
                 );


     IF COALESCE (vbGoodsId, 0) = 0
     THEN
         -- Создание
         vbGoodsId := gpInsertUpdate_Object_Goods (ioId            := vbGoodsId
                                                 , inCode          := 0
                                                 , inName          := inGoodsName
                                                 , inGoodsGroupId  := inGoodsGroupId
                                                 , inMeasureId     := inMeasureId
                                                 , inCompositionId := vbCompositionId
                                                 , inGoodsInfoId   := vbGoodsInfoId
                                                 , inLineFabricaId := vbLineFabricaId
                                                 , inLabelId       := vbLabelId
                                                 , inSession       := inSession
                                                  );
              
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

      -- cохраняем Object_PartionGoods
      PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId := ioId
                                                       , inMovementId     := inMovementId
                                                       , inSybaseId       := NULL -- !!!если что - оставим без изменения!!!
                                                       , inPartnerId      := vbPartnerId
                                                       , inUnitId         := MovementLinkObject_To.ObjectId
                                                       , inOperDate       := vbOperDate
                                                       , inGoodsId        := vbGoodsId
                                                       , inGoodsItemId    := vbGoodsItemId
                                                       , inCurrencyId     := MovementLinkObject_CurrencyDocument.ObjectId
                                                       , inAmount         := inAmount
                                                       , inOperPrice      := inOperPrice
                                                       , inPriceSale      := inOperPriceList
                                                       , inBrandId        := ObjectLink_Partner_Brand.ChildObjectId
                                                       , inPeriodId       := ObjectLink_Partner_Period.ChildObjectId
                                                       , inPeriodYear     := ObjectFloat_PeriodYear.ValueData :: Integer
                                                       , inFabrikaId      := ObjectLink_Partner_Fabrika.ChildObjectId
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
                                                        )
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
            --
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                 ON ObjectLink_Partner_Brand.ObjectId = vbPartnerId
                                AND ObjectLink_Partner_Brand.DescId   = zc_ObjectLink_Partner_Brand()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                 ON ObjectLink_Partner_Period.ObjectId = vbPartnerId
                                AND ObjectLink_Partner_Period.DescId   = zc_ObjectLink_Partner_Period()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                 ON ObjectLink_Partner_Fabrika.ObjectId = vbPartnerId
                                AND ObjectLink_Partner_Fabrika.DescId   = zc_ObjectLink_Partner_Fabrika()
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear 
                                  ON ObjectFloat_PeriodYear.ObjectId = vbPartnerId
                                 AND ObjectFloat_PeriodYear.DescId   = zc_ObjectFloat_Partner_PeriodYear()

     WHERE Movement.Id = inMovementId;
     
    -- дописали - партия = Id
    UPDATE MovementItem SET PartionId = ioId WHERE Id = ioId;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Полятыкин А.А.
 24.04.17                                                        *
 10.04.17         *
*/

-- тест
-- 