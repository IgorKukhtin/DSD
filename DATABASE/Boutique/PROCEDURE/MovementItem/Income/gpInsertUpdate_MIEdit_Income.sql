-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_IncomeLoad (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

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
    IN inPriceJur              TFloat    , -- Цена вх.без скидки
    IN inCountForPrice         TFloat    , -- Цена за количество
    IN inOperPriceList         TFloat    , -- Цена по прайсу
    IN inIsCode                Boolean   , -- не изменять код товара
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
   DECLARE vbGoodsId_old   Integer;
   DECLARE vbGoodsId_find  Integer;
   DECLARE vbGoodsInfoId   Integer;
   DECLARE vbGoodsItemId   Integer;
   DECLARE vbLabelId       Integer;

   DECLARE vbOperDate  TDateTime;
   DECLARE vbPartnerId Integer;

   DECLARE vbId_min Integer;
   DECLARE vbId_max Integer;

   DECLARE vbOperPriceList_old TFloat;
   DECLARE vbOperPrice TFloat;
   DECLARE vbChangePercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF (inSession :: Integer) < 0
     THEN
         vbUserId := lpCheckRight ((-1 * (inSession :: Integer)) :: TVarChar, zc_Enum_Process_InsertUpdate_MI_Income());
     ELSE
         vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());
     END IF;


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
                                                                                       , inSession:= vbUserId :: TVarChar
                                                                                         ) AS tmp);
         END IF;
     END IF;

     -- Состав товара
     inCompositionName:= TRIM (inCompositionName);
     IF inCompositionName <> ''
     THEN
         -- Поиск !!!без Группы!!!
         vbCompositionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND LOWER (Object.ValueData) = LOWER (inCompositionName) ORDER BY Object.Id LIMIT 1);   -- limit 1 так как ошибка  для inCompositionName = '100%шерсть'  возвращает 2 строки
         --
         IF COALESCE (vbCompositionId, 0) = 0
         THEN
             -- Создание
             vbCompositionId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Composition (ioId                 := 0
                                                                                       , ioCode               := 0
                                                                                       , inName               := inCompositionName
                                                                                       , inCompositionGroupId := 0 -- сохраняем с пустой группой
                                                                                       , inSession            := vbUserId :: TVarChar
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
                                                                                   , inSession:= vbUserId :: TVarChar
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
                                                                           , inSession:= vbUserId :: TVarChar
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
                                                                               , inSession:= vbUserId :: TVarChar
                                                                                 ) AS tmp);
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inGoodsGroupId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Группа товаров>.';
     END IF;

     -- !!!замена!!!
     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN
         -- если надо найти существующий код
         IF TRIM (inGoodsName) <> '' AND COALESCE (ioId, 0) = 0 AND (inSession :: Integer) > 0
         THEN
             -- проверка
             IF inGoodsName <> ioGoodsCode :: TVarChar
             THEN
                 RAISE EXCEPTION 'Ошибка.Артикул товара = <%> не соответствует значению код = <%>.', inGoodsName, ioGoodsCode;
             END IF;
             -- поиск
             vbGoodsId_find:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = ioGoodsCode AND Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE);
             -- проверка
             IF COALESCE (vbGoodsId_find, 0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Не найден товара с кодом = <%>.Необходимо в артикуле указать существующий.', ioGoodsCode;
             END IF;
             -- проверка - Группа товара - не должна меняться
             IF inGoodsGroupId <> (SELECT DISTINCT Object_PartionGoods.GoodsGroupId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find)
             THEN
                 RAISE EXCEPTION 'Ошибка.Для товара с кодом = <%> Группа = <%> не может меняться на Группу = <%>.', ioGoodsCode, (SELECT DISTINCT Object_PartionGoods.GoodsGroupId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find), inGoodsGroupId;
             END IF;
             -- проверка - Название - не должно меняться
             IF vbLabelId <> (SELECT DISTINCT Object_PartionGoods.LabelId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find)
             THEN
                 RAISE EXCEPTION 'Ошибка.Для товара с кодом = <%> Название = <%> не может меняться на Название = <%>.', ioGoodsCode, (SELECT DISTINCT Object_PartionGoods.LabelId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find), vbLabelId;
             END IF;
             -- проверка - Состав - не должен меняться
             IF vbCompositionId <> (SELECT DISTINCT Object_PartionGoods.CompositionId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find)
             THEN
                 RAISE EXCEPTION 'Ошибка.Для товара с кодом = <%> Состав = <%> не может меняться на Состав = <%>.', ioGoodsCode, (SELECT DISTINCT Object_PartionGoods.CompositionId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find), vbCompositionId;
             END IF;
             -- проверка - Описание - не должно меняться
             IF vbGoodsInfoId <> (SELECT DISTINCT Object_PartionGoods.GoodsInfoId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find)
             THEN
                 RAISE EXCEPTION 'Ошибка.Для товара с кодом = <%> Описание = <%> не может меняться на Описание = <%>.', ioGoodsCode, (SELECT DISTINCT Object_PartionGoods.GoodsInfoId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find), vbGoodsInfoId;
             END IF;
             -- проверка - Линия - не должна меняться
             IF vbLineFabricaId <> (SELECT DISTINCT Object_PartionGoods.LineFabricaId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find)
             THEN
                 RAISE EXCEPTION 'Ошибка.Для товара с кодом = <%> Линия = <%> не может меняться на Линия = <%>.', ioGoodsCode, (SELECT DISTINCT Object_PartionGoods.LineFabricaId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_find), vbLineFabricaId;
             END IF;

         ELSE
             --
             inGoodsName:= ioGoodsCode :: TVarChar;
         END IF;

     END IF;

     -- проверка - свойство должно быть установлено
     inGoodsName:= COALESCE (TRIM (inGoodsName), '');
     IF inGoodsName = '' THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inOperPriceList, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена продажи>. <%> <%> <%>', inGoodsName, inPriceJur, inOperPriceList;
     END IF;


     -- Запомнили !!!ДО изменений!!!
     IF ioId > 0
     THEN -- Товар - у текущего Элемента
          vbGoodsId_old = (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId);
     END IF;

     -- Поиск
     SELECT MIN (Object.Id), MAX (Object.Id)
            INTO vbId_min, vbId_max
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
     ;

     -- проверка
     IF vbId_min <> vbId_max
     THEN
         RAISE EXCEPTION 'Ошибка.Артикул <%> уже существует в данной группе.', inGoodsName;
     END IF;
     
     -- нашли
     IF inIsCode = TRUE
     THEN
          vbGoodsId:= (SELECT Object.Id
                       FROM Object
                            -- только Группа
                            INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                  ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                                 AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                                 AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId
                       WHERE Object.DescId     = zc_Object_Goods()
                         AND Object.ObjectCode = ioGoodsCode
                      );
          -- проверка
          IF COALESCE (vbGoodsId, 0) = 0
          THEN
              RAISE EXCEPTION 'Ошибка.Код товара <%> в группе <%> не найден.', ioGoodsCode, lfGet_Object_ValueData_sh (inGoodsGroupId);
          END IF;
          -- !!!замена!!!
          IF zc_Enum_GlobalConst_isTerry() = FALSE
          THEN
              RAISE EXCEPTION 'Ошибка.Нет прав.';
          END IF;
     ELSE
         vbGoodsId:= vbId_max;
     END IF;

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
         -- сколько партий с этим товаром
         IF (SELECT COUNT (*) FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_old AND Object_PartionGoods.MovementId = inMovementId)
          = (SELECT COUNT (*) FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_old)
         THEN
             -- ОСТАВЛЯЕМ тот же самый
             vbGoodsId:= vbGoodsId_old;
             -- Меняем ему название, если надо
             UPDATE Object SET ValueData = inGoodsName WHERE Object.Id = vbGoodsId AND Object.DescId = zc_Object_Goods() AND Object.ValueData <> inGoodsName;
             -- если изменение - БЫЛО
             IF FOUND THEN
               -- сохранили протокол
               PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);
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
             -- проверка
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION 'Ошибка.Для кода товара <%> нельзя менять Группу.', ioGoodsCode;
             END IF;
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, inGoodsGroupId);
             -- пересохранили - Полное название группы
             PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), vbGoodsId, lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent()));
         END IF;

         -- если изменился - Единицы измерения
         IF inMeasureId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure()), 0)
         THEN
             -- проверка
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION 'Ошибка.Для кода товара <%> нельзя менять Единицу измерения.', ioGoodsCode;
             END IF;
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), vbGoodsId, inMeasureId);
         END IF;

         -- если изменился - Состав товара
         IF inIsCode = FALSE AND vbCompositionId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Composition()), 0)
         THEN
             -- проверка
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION 'Ошибка.Для кода товара <%> нельзя менять Состав с <%> на <%>.', ioGoodsCode
                               , lfGet_Object_ValueData_sh ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Composition()))
                               , inCompositionName
                               ;
             END IF;
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Composition(), vbGoodsId, vbCompositionId);
         END IF;

         -- если изменился - Описание товара
         IF vbGoodsInfoId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsInfo()), 0)
         THEN
             -- проверка
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION 'Ошибка.Для кода товара <%> нельзя менять Описание.', ioGoodsCode;
             END IF;
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsInfo(), vbGoodsId, vbGoodsInfoId);
         END IF;

         -- если изменился - Линия коллекции
         IF vbLineFabricaId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_LineFabrica()), 0)
         THEN
             -- проверка
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION 'Ошибка.Для кода товара <%> нельзя менять Линию.', ioGoodsCode;
             END IF;
             -- пересохранили
             PERFORM lpInsertUpdate_ObjectLink ( zc_ObjectLink_Goods_LineFabrica(), vbGoodsId, vbLineFabricaId);
         END IF;

         -- если изменился - Название для ценника
         IF vbLabelId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_Label()), 0)
         THEN
             -- проверка
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION 'Ошибка.Для кода товара <%> нельзя менять Название.', ioGoodsCode;
             END IF;
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

     -- проверка - Уникальный vbGoodsItemId
     IF vbUserId <> zc_User_Sybase()
        AND EXISTS (SELECT 1 FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId AND Object_PartionGoods.MovementItemId <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION 'Ошибка.В документе уже есть Товар <% %> р.<%>.Дублирование запрещено.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId))
                       ;
     END IF;


     -- Запомнили !!!ДО изменений!!!
     IF ioId > 0
     THEN -- Цену - у текущего Элемента
          vbOperPriceList_old:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_OperPriceList());

     ELSE
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM (SELECT DISTINCT MIF.ValueData
                                        FROM MovementItem
                                             LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.ObjectId   = vbGoodsId
                                          AND MovementItem.isErased   = FALSE
                                       ) AS tmp)
          THEN
             RAISE EXCEPTION 'Ошибка.Разница Цен продажи: <%> и <%> для <%> в Документе № <%> от <%>.'
                           , (SELECT MIN (tmp.OperPriceList)
                              FROM (SELECT DISTINCT COALESCE (MIF.ValueData, 0) AS OperPriceList
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND MovementItem.ObjectId   = vbGoodsId
                                      AND MovementItem.isErased   = FALSE
                                   ) AS tmp)
                           , (SELECT MAX (tmp.OperPriceList)
                              FROM (SELECT DISTINCT COALESCE (MIF.ValueData, 0) AS OperPriceList
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND MovementItem.ObjectId   = vbGoodsId
                                      AND MovementItem.isErased   = FALSE
                                   ) AS tmp)
                           , lfGet_Object_ValueData (vbGoodsId)
                           , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                           , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                            ;
          END IF;

          -- Цену - у любого Элемента
          vbOperPriceList_old:= (SELECT DISTINCT MIF.ValueData
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.ObjectId   = vbGoodsId
                                   AND MovementItem.isErased   = FALSE
                                );
     END IF;

     -- Заменили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;

     -- определяем % скридки / наценки из шапки документа
     vbChangePercent := COALESCE ((SELECT MovementFloat.ValueData
                                   FROM MovementFloat
                                   WHERE MovementFloat.MovementId = inMovementId
                                     AND MovementFloat.DescId = zc_MovementFloat_ChangePercent()
                                   )
                                  , 0);
     -- расчет вх. цены со скидкой
     vbOperPrice := (inPriceJur + inPriceJur / 100 * vbChangePercent) :: TFloat;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := vbGoodsId
                                              , inAmount             := inAmount
                                              , inOperPrice          := vbOperPrice
                                              , inCountForPrice      := inCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );
     
     
     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceJur(), ioId, inPriceJur);

     -- cохраняем Object_PartionGoods + Update св-ва у остальных партий этого vbGoodsId + Update Цены в истории
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId     := ioId
                                               , inMovementId         := inMovementId
                                               , inPartnerId          := vbPartnerId
                                               , inUnitId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inOperDate           := vbOperDate
                                               , inGoodsId            := COALESCE (vbGoodsId, 0)
                                               , inGoodsId_old        := COALESCE (vbGoodsId_old, 0)
                                               , inGoodsItemId        := vbGoodsItemId
                                               , inCurrencyId         := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument())
                                               , inAmount             := inAmount
                                               , inOperPrice          := vbOperPrice
                                               , inCountForPrice      := inCountForPrice
                                               , inOperPriceList      := COALESCE (inOperPriceList, 0)
                                               , inOperPriceList_old  := COALESCE (vbOperPriceList_old, 0)
                                               , inBrandId            := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Brand())
                                               , inPeriodId           := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Period())
                                               , inPeriodYear         := (SELECT ObF.ValueData FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbPartnerId AND ObF.DescId = zc_ObjectFloat_Partner_PeriodYear()) :: Integer
                                               , inFabrikaId          := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Fabrika())
                                               , inGoodsGroupId       := inGoodsGroupId
                                               , inMeasureId          := inMeasureId
                                               , inCompositionId      := vbCompositionId
                                               , inGoodsInfoId        := vbGoodsInfoId
                                               , inLineFabricaId      := vbLineFabricaId
                                               , inLabelId            := vbLabelId
                                               , inCompositionGroupId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbCompositionId AND OL.DescId = zc_ObjectLink_Composition_CompositionGroup())
                                               , inGoodsSizeId        := vbGoodsSizeId
                                               , inJuridicalId        := inJuridicalId
                                               , inUserId             := vbUserId
                                                );


     -- по товарам исправили OperPriceList - НЕ для загрузки из Sybase т.к. там ???
     IF 1=1 -- vbUserId <> zc_User_Sybase()
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), MovementItem.Id, inOperPriceList)
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.ObjectId   = vbGoodsId
           AND MovementItem.Id         <> ioId
           AND COALESCE (MIF.ValueData, 0) <> inOperPriceList
        ;
     END IF;


     -- дописали - партию = Id
     UPDATE MovementItem SET PartionId = ioId WHERE MovementItem.Id = ioId AND MovementItem.PartionId IS NULL;
     
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Полятыкин А.А.
 05.02.19         *
 11.05.17                                                        *
 10.05.17                                                        *
 24.04.17                                                        *
 10.04.17         *
*/

/*
-- SELECT  lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), tmp.Id, tmp.PriceOk)
-- from (
SELECT Object_Goods.*, Object_GoodsSize.ValueData, Movement.OperDate, Movement.InvNumber
, ObjectHistoryFloat_PriceListItem_Value.ValueData, Object_PartionGoods .OperPriceList , MIFloat_OperPriceList.ValueData as PriceOk
, Object_PartionGoods .OperPrice , MIFloat_OperPrice.ValueData as PriceInOk
, ObjectHistory_PriceListItem.*
, Object_PartionGoods.*
FROM Object_PartionGoods 
     join Object AS Object_Goods on Object_Goods.Id = Object_PartionGoods.GoodsId
     join Object AS Object_GoodsSize on Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId

     join Movement ON Movement.Id = MovementId

     join MovementItemFloat AS MIFloat_OperPriceList
          ON MIFloat_OperPriceList.MovementItemId = Object_PartionGoods .MovementItemId
          AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

     join MovementItemFloat AS MIFloat_OperPrice
          ON MIFloat_OperPrice.MovementItemId = Object_PartionGoods .MovementItemId
          AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()

                   inner join ObjectLink AS ObjectLink_PriceListItem_PriceList
                      on ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                     -- AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate = zc_DateStart())
                        inner JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                             ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                            AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                            AND ObjectLink_PriceListItem_Goods.ChildObjectId = Object_PartionGoods.GoodsId
       
                        LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                               AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                               AND CURRENT_DATE >= ObjectHistory_PriceListItem.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                     ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                    AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
 
                   


WHERE Object_PartionGoods.PeriodYear = 2019
-- and Object_PartionGoods .MovementItemId = 1707494 
-- and Object_PartionGoods.OperPriceList <> MIFloat_OperPriceList.ValueData and ObjectHistory_PriceListItem.StartDate = zc_DateStart()
-- and Object_PartionGoods .OperPriceList  <> ObjectHistoryFloat_PriceListItem_Value.ValueData
 and Object_PartionGoods .OperPrice  <> MIFloat_OperPrice.ValueData
order by 3, Object_GoodsSize.ValueData
-- ) as tmp
*/
/*
-- !!!ERROR!!!
select distinct Object_PartionGoods.GoodsSizeId, CLO.ObjectId, *
from Container 
join Object_PartionGoods on Object_PartionGoods.MovementItemId = Container.PartionId
left join ContainerLinkObject as CLO on CLO.ContainerId = Container.Id and CLO.DescId = 14 -- zc_ContainerLinkObject_GoodsSize
-- inner join MovementItemContainer on MovementItemContainer.ContainerId = Container.Id
 where Container.Id = 2431697
 and coalesce (Object_PartionGoods.GoodsSizeId, 0) <> coalesce (CLO.ObjectId, 0)
-- where coalesce (Object_PartionGoods.GoodsSizeId, 0) <> coalesce (CLO.ObjectId, 0)
*/
-- тест
-- SELECT * FROMgpInsertUpdate_MIEdit_Income()
