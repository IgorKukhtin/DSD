-- Function: lpInsertUpdate_Object_PartionGoods

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionGoods(
    IN inMovementItemId         Integer,       -- Ключ партии
    IN inMovementId             Integer,       -- Ключ Документа
    IN inPartnerId              Integer,       -- Поcтавщик
    IN inUnitId                 Integer,       -- Подразделение(прихода)
    IN inOperDate               TDateTime,     -- Дата прихода
    IN inGoodsId                Integer,       -- Товар
    IN inGoodsId_old            Integer,       -- Товар, ДО изменения строки
    IN inGoodsItemId            Integer,       -- Товар с размером
    IN inCurrencyId             Integer,       -- Валюта для цены прихода
    IN inAmount                 TFloat,        -- Кол-во приход
    IN inOperPrice              TFloat,        -- Цена прихода
    IN inCountForPrice          TFloat,        -- Цена за количество
    IN inOperPriceList          TFloat,        -- Цена продажи, !!!грн!!!
    IN inOperPriceList_old      TFloat,        -- Цена продажи, ДО изменения строки
    IN inBrandId                Integer,       -- Торговая марка
    IN inPeriodId               Integer,       -- Сезон
    IN inPeriodYear             Integer,       -- Год
    IN inFabrikaId              Integer,       -- Фабрика производитель
    IN inGoodsGroupId           Integer,       -- Группа товара
    IN inMeasureId              Integer,       -- Единица измерения
    IN inCompositionId          Integer,       -- Состав
    IN inGoodsInfoId            Integer,       -- Описание
    IN inLineFabricaId          Integer,       -- Линия
    IN inLabelId                Integer,       -- Название в ценнике
    IN inCompositionGroupId     Integer,       -- Группа состава
    IN inGoodsSizeId            Integer,       -- Размер
    IN inJuridicalId            Integer,       -- Юр.лицо
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
   DECLARE vbPriceList_change Boolean;
   DECLARE vbRePrice_exists   Boolean;
   DECLARE vbId_income_ch     Integer;
   DECLARE vbId_sale_ch       Integer;
   DECLARE vbId_sale_part     Integer;
BEGIN
     -- заменили
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice:= 1; END IF;


     -- 1.0. ДЛЯ ВСЕХ ПАРТИЙ - inGoodsId
     /*IF -- inUserId <> zc_User_Sybase() AND  -- !!!Кроме Sybase!!!
        inMovementItemId > 0 AND (inOperPrice     <> (SELECT COALESCE (Object_PartionGoods.OperPrice, 0)     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inCountForPrice <> (SELECT COALESCE (Object_PartionGoods.CountForPrice, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                                 )
     THEN
        -- есть ли ПРОВЕДЕННЫЕ документы - все
        vbId_sale_part:= (SELECT MovementItem.Id
                          FROM Object_PartionGoods
                               INNER JOIN MovementItem ON MovementItem.PartionId = Object_PartionGoods.MovementItemId
                                                      AND MovementItem.isErased  = FALSE -- !!!только НЕ удаленные!!!
                                                      -- AND MovementItem.DescId = ...   -- !!!любой Desc!!!
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                                                  AND Movement.DescId   <> zc_Movement_Income()     -- !!!только НЕ Приход от постав.!!!
                          WHERE Object_PartionGoods.MovementId = inMovementId
                            AND Object_PartionGoods.GoodsId    = inGoodsId
                          ORDER BY Movement.OperDate DESC
                          LIMIT 1
                         );
        -- Проверка сразу - ДЛЯ ВСЕХ ПАРТИЙ - inGoodsId
        IF vbId_sale_part > 0
        THEN
            RAISE EXCEPTION 'Ошибка.Найдено движение <%> № <%> от <%>.Нельзя корректировать <Цена вх.>.(<%><%>)(<%>)'
                          , (SELECT MovementDesc.ItemName
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                  INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , (SELECT Movement.InvNumber
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , (SELECT zfConvert_DateToString (Movement.OperDate)
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , inOperPrice, (SELECT COALESCE (Object_PartionGoods.OperPrice, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                          , inMovementItemId
                           ;
        END IF;
     -- 1.0. ДЛЯ 1-ой ПАРТИИ
     ELSE*/ IF inUserId <> zc_User_Sybase() AND  -- !!!Кроме Sybase!!!
        inMovementItemId > 0 AND (-- и еще раз проверим Цену - т.к. в партии inMovementItemId все еще может быть другой GoodsId
                                  inOperPrice     <> (SELECT COALESCE (Object_PartionGoods.OperPrice, 0)     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inCountForPrice <> (SELECT COALESCE (Object_PartionGoods.CountForPrice, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inGoodsSizeId   <> (SELECT COALESCE (Object_PartionGoods.GoodsSizeId, 0)   FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inGoodsId       <> inGoodsId_old
                                 )
     THEN
        -- есть ли ПРОВЕДЕННЫЕ документы - все
        vbId_sale_part:= (SELECT MovementItem.Id
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                                                  AND Movement.DescId   <> zc_Movement_Income()     -- !!!только НЕ Приход от постав.!!!
                          WHERE MovementItem.PartionId = inMovementItemId
                            AND MovementItem.isErased  = FALSE -- !!!только НЕ удаленные!!!
                            -- AND MovementItem.DescId = ...   -- !!!любой Desc!!!
                          ORDER BY Movement.OperDate DESC
                          LIMIT 1
                         );
         -- Проверка сразу - ДЛЯ 1-ой ПАРТИИ
        IF vbId_sale_part > 0
        THEN
            RAISE EXCEPTION 'Ошибка.Найдено движение <%> № <%> от <%>.Нельзя корректировать <Цена вх.> или <Артикул> или <Размер>.(<%><%>)(<%><%>)(<%><%>)(<%><%>)(<%>)'
                          , (SELECT MovementDesc.ItemName
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                  INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , (SELECT Movement.InvNumber
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , (SELECT zfConvert_DateToString (Movement.OperDate)
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , inOperPrice,     (SELECT COALESCE (Object_PartionGoods.OperPrice, 0)     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                          , inCountForPrice, (SELECT COALESCE (Object_PartionGoods.CountForPrice, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                          , inGoodsSizeId,   (SELECT COALESCE (Object_PartionGoods.GoodsSizeId, 0)   FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                          , inGoodsId,       inGoodsId_old
                          , inMovementItemId
                           ;
        END IF;
     END IF;


     -- 1.1. есть ли ПЕРЕОЦЕНКА
     vbRePrice_exists:= EXISTS (SELECT 1
                                FROM ObjectLink AS ObjectLink_Goods
                                     INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                           ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                                          AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                                          AND ObjectLink_PriceList.ChildObjectId = zc_PriceList_Basis()  -- !!!Базовый Прайс!!!
                                     INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                              ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                             AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                             AND ObjectHistory_PriceListItem.EndDate  < zc_DateEnd() -- !!!есть история > 1!!!
                                WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                  AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                               );

     IF 1=1 THEN
        -- есть ли ПАРТИИ в ДРУГИХ ПРОВЕДЕННЫХ документах - все
        vbId_income_ch:= (SELECT MovementItem.Id
                          FROM Object_PartionGoods
                               INNER JOIN MovementItem ON MovementItem.PartionId = Object_PartionGoods.MovementItemId
                                                     AND MovementItem.isErased  = FALSE
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                                                  AND Movement.DescId   = zc_Movement_Income()      -- !!!только Приход от постав.!!!
                          WHERE Object_PartionGoods.GoodsId    = inGoodsId
                            AND Object_PartionGoods.MovementId <> inMovementId
                          ORDER BY Movement.OperDate DESC
                          LIMIT 1
                         );
     END IF;

     IF 1=1 THEN
        -- есть ли ПРОВЕДЕННЫЕ документы - все
        vbId_sale_ch:= (SELECT MovementItem.Id
                        FROM MovementItem
                             INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                                                AND Movement.DescId   <> zc_Movement_Income()     -- !!!только НЕ Приход от постав.!!!
                        WHERE MovementItem.ObjectId = inGoodsId
                          AND MovementItem.isErased = FALSE -- !!!только НЕ удаленные!!!
                          -- AND MovementItem.DescId= ...   -- !!!любой Desc!!!
                          -- AND  inUserId <> 8
                        ORDER BY Movement.OperDate DESC
                        LIMIT 1
                       );
     END IF;


     -- 1.2.1. НАЧАЛО: Определили - можно ли менять цену
     IF inUserId = zc_User_Sybase()
     THEN
          vbPriceList_change:= TRUE;

     -- 1.2.2. если она НЕ менялась + Товар НЕ менялся ИЛИ Insert
     ELSEIF inOperPriceList = inOperPriceList_old AND (inGoodsId = inGoodsId_old OR inGoodsId_old = 0)
     THEN
         vbPriceList_change:= FALSE;

     -- 1.2.3. если Insert и в Документе он первый ИЛИ она НЕ менялась + Цена соответсвует Значению в Истории - !!!Базовый Прайс!!!
     ELSEIF /*(inOperPriceList_old = 0 OR inOperPriceList = inOperPriceList_old) AND*/
           inOperPriceList = (SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (inOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp)
     THEN
         vbPriceList_change:= FALSE;

     -- 1.3.1. если была Переоценка
     ELSEIF vbRePrice_exists = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка.По товару <%> была переоценка.Можно ввести приход с ценой продажи = <% %>.'
                       , lfGet_Object_ValueData (inGoodsId)
                       , zfConvert_FloatToString (((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (inOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp)))
                       , (SELECT lfGet_Object_ValueData_sh (COALESCE (OL.ChildObjectId, zc_Currency_GRN())) FROM Object LEFT JOIN ObjectLink AS OL ON OL.ObjectId = Object.Id AND OL.DescId = zc_ObjectLink_PriceList_Currency() WHERE Object.Id = zc_PriceList_Basis())
                        ;

     -- 1.3.2. если ПАРТИИ в ДРУГИХ ПРОВЕДЕННЫХ документах
     ELSEIF vbId_income_ch > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Уже есть приход № <%> от <%> с ценой продажи = <% %>.Для формирования прихода с другой ценой необходимо сначала провести Переоценку.'
                       , (SELECT Movement.InvNumber
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_income_ch
                         )
                       , (SELECT zfConvert_DateToString (Movement.OperDate)
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_income_ch
                         )
                       , (SELECT zfConvert_FloatToString (MIF.ValueData) FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId_income_ch AND MIF.DescId = zc_MIFloat_OperPriceList())
                       , (SELECT lfGet_Object_ValueData_sh (COALESCE (OL.ChildObjectId, zc_Currency_GRN())) FROM Object LEFT JOIN ObjectLink AS OL ON OL.ObjectId = Object.Id AND OL.DescId = zc_ObjectLink_PriceList_Currency() WHERE Object.Id = zc_PriceList_Basis())
                        ;

     -- 1.3.3. есть ли ПРОВЕДЕННЫЕ документы - все
     ELSEIF vbId_sale_ch > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Найдено движение <%> № <%> от <%> с ценой продажи = <% %>.Для формирования прихода с другой ценой необходимо сначала провести Переоценку.'
                       , (SELECT MovementDesc.ItemName
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                               INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                          WHERE MovementItem.Id = vbId_sale_ch
                         )
                       , (SELECT Movement.InvNumber
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_sale_ch
                         )
                       , (SELECT zfConvert_DateToString (Movement.OperDate)
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_sale_ch
                         )
                       , (SELECT zfConvert_FloatToString (MIF.ValueData) FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId_sale_ch AND MIF.DescId = zc_MIFloat_OperPriceList())
                       , (SELECT lfGet_Object_ValueData_sh (COALESCE (OL.ChildObjectId, zc_Currency_GRN())) FROM Object LEFT JOIN ObjectLink AS OL ON OL.ObjectId = Object.Id AND OL.DescId = zc_ObjectLink_PriceList_Currency() WHERE Object.Id = zc_PriceList_Basis())
                        ;


     -- 1.3.4. !!!Все ОТЛИЧНО - будем менять цену!!!
     ELSE vbPriceList_change:= TRUE;


     END IF;
     -- 1. ЗАВЕРШЕНО: Определили - можно ли менять цену


     -- 2.1. НАЧАЛО: Определили - можно ли изменять св-ва - !!!Кроме Sybase!!!
     IF inUserId <> zc_User_Sybase()
        AND (vbId_income_ch <> 0 OR vbId_sale_ch <> 0)
        AND inMovementItemId > 0
        AND (-- inCompositionId <> (SELECT COALESCE (Object_PartionGoods.CompositionId, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
          -- OR inGoodsInfoId   <> (SELECT COALESCE (Object_PartionGoods.GoodsInfoId, 0)   FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
          -- OR inLineFabricaId <> (SELECT COALESCE (Object_PartionGoods.LineFabricaId, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
             inLabelId       <> (SELECT COALESCE (Object_PartionGoods.LabelId, 0)       FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
            )
     THEN
        -- 2.1.1. есть ли ПРОВЕДЕННЫЕ документы - все
         IF vbId_income_ch > 0
         THEN
             -- RAISE EXCEPTION 'Ошибка.Уже есть приход № <%> от <%>.Нельзя корректировать <Цена вх.> или <Состав> или <Описание> или <Линия> или <Название>.'
             RAISE EXCEPTION 'Ошибка.Уже есть приход № <%> от <%>.Нельзя корректировать <Цена вх.> или <Название>.'
                           , (SELECT Movement.InvNumber
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_income_ch
                             )
                           , (SELECT zfConvert_DateToString (Movement.OperDate)
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_income_ch
                             )
                            ;

         -- 2.1.2. есть ли ПРОВЕДЕННЫЕ документы - все
         ELSE
             -- RAISE EXCEPTION 'Ошибка.Найдено движение <%> № <%> от <%>.Нельзя корректировать <Состав> или <Описание> или <Линия> или <Название>.'
             RAISE EXCEPTION 'Ошибка.Найдено движение <%> № <%> от <%>.Нельзя корректировать <Название>.'
                           , (SELECT MovementDesc.ItemName
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                   INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                              WHERE MovementItem.Id = vbId_sale_ch
                             )
                           , (SELECT Movement.InvNumber
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_sale_ch
                             )
                           , (SELECT zfConvert_DateToString (Movement.OperDate)
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_sale_ch
                             )
                            ;
         END IF;
     END IF;
     -- 2. ЗАВЕРШЕНО: Определили - можно ли изменять св-ва - !!!Кроме Sybase!!!


     -- изменили элемент - по значению <Ключ партии>
     UPDATE Object_PartionGoods
            SET MovementId           = inMovementId
              , PartnerId            = inPartnerId
              , UnitId               = inUnitId
              , OperDate             = inOperDate
              , GoodsId              = inGoodsId
              , GoodsItemId          = inGoodsItemId -- ***
              , CurrencyId           = inCurrencyId
              --, Amount               = inAmount
              , OperPrice            = inOperPrice
              , CountForPrice        = inCountForPrice
              , OperPriceList        = CASE WHEN vbRePrice_exists = TRUE
                                                 THEN (SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (zc_DateEnd() - INTERVAL '1 DAY', zc_PriceList_Basis(), inGoodsId) AS tmp)
                                            WHEN vbPriceList_change = TRUE
                                                 THEN inOperPriceList
                                            ELSE 
                                                 Object_PartionGoods.OperPriceList
                                       END
              , BrandId              = inBrandId
              , PeriodId             = inPeriodId
              , PeriodYear           = inPeriodYear
              , FabrikaId            = zfConvert_IntToNull (inFabrikaId)
              , GoodsGroupId         = inGoodsGroupId
              , MeasureId            = inMeasureId
              , CompositionId        = zfConvert_IntToNull (inCompositionId)
              , GoodsInfoId          = zfConvert_IntToNull (inGoodsInfoId)
              , LineFabricaId        = zfConvert_IntToNull (inLineFabricaId)
              , LabelId              = inLabelId
              , CompositionGroupId   = zfConvert_IntToNull (inCompositionGroupId)
              , GoodsSizeId          = inGoodsSizeId
              , JuridicalId          = zfConvert_IntToNull (inJuridicalId)
     WHERE Object_PartionGoods.MovementItemId = inMovementItemId;


     -- если такой элемент не был найден
     IF NOT FOUND THEN
        -- добавили новый элемент
        INSERT INTO Object_PartionGoods (MovementItemId, MovementId, PartnerId, UnitId, OperDate, GoodsId, GoodsItemId
                                       , CurrencyId, Amount, OperPrice, CountForPrice, OperPriceList, BrandId, PeriodId, PeriodYear
                                       , FabrikaId, GoodsGroupId, MeasureId
                                       , CompositionId, GoodsInfoId, LineFabricaId
                                       , LabelId, CompositionGroupId, GoodsSizeId, JuridicalId
                                       , CurrencyId_pl
                                       , isErased, isArc)
                                 VALUES (inMovementItemId, inMovementId, inPartnerId, inUnitId, inOperDate, inGoodsId, inGoodsItemId
                                       , inCurrencyId, 0 /*inAmount*/, inOperPrice, inCountForPrice
                                         -- "сложно" получили цену
                                       , CASE WHEN vbRePrice_exists = TRUE
                                                 THEN (SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (zc_DateEnd() - INTERVAL '1 DAY', zc_PriceList_Basis(), inGoodsId) AS tmp)
                                              ELSE inOperPriceList
                                         END
                                       , inBrandId, inPeriodId, inPeriodYear
                                       , zfConvert_IntToNull (inFabrikaId), inGoodsGroupId, inMeasureId
                                       , zfConvert_IntToNull (inCompositionId), zfConvert_IntToNull (inGoodsInfoId), zfConvert_IntToNull (inLineFabricaId)
                                       , inLabelId, zfConvert_IntToNull (inCompositionGroupId), inGoodsSizeId, zfConvert_IntToNull (inJuridicalId)
                                       , CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN zc_Currency_Basis() ELSE zc_Currency_EUR() END
                                       , TRUE, TRUE
                                        );
     ELSE
         -- !!!не забыли - проверили что НЕТ движения, тогда инфу в партии можно менять!!!
         -- PERFORM lpCheck ...

     END IF; -- if NOT FOUND


     -- !!!меняем у остальных партий - все св-ва!!!
     UPDATE Object_PartionGoods SET FabrikaId              = zfConvert_IntToNull (inFabrikaId)
                                  , GoodsGroupId           = inGoodsGroupId
                                  , MeasureId              = inMeasureId
                                  , CompositionId          = zfConvert_IntToNull (inCompositionId)
                                  , GoodsInfoId            = zfConvert_IntToNull (inGoodsInfoId)
                                  , LineFabricaId          = zfConvert_IntToNull (inLineFabricaId)
                                  , LabelId                = inLabelId
                                  , CompositionGroupId     = zfConvert_IntToNull (inCompositionGroupId)
                                    -- только для документа inMovementId
                                  , JuridicalId            = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN zfConvert_IntToNull (inJuridicalId) ELSE Object_PartionGoods.JuridicalId   END
                                    -- только для документа inMovementId - еще и Цену вх.
                                  -- , OperPrice              = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inOperPrice                         ELSE Object_PartionGoods.OperPrice     END
                                    -- только для документа inMovementId - еще и Цену вх.
                                  -- , CountForPrice          = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inCountForPrice                     ELSE Object_PartionGoods.CountForPrice END
                                    -- еще и Цену Прайса - если она ПОСЛЕДЕНЯЯ
                                  , OperPriceList          = CASE WHEN vbPriceList_change = TRUE THEN inOperPriceList ELSE Object_PartionGoods.OperPriceList END
     WHERE Object_PartionGoods.MovementItemId <> inMovementItemId
       AND Object_PartionGoods.GoodsId        = inGoodsId;


     -- cохранили Цену в истории - !!!Кроме Sybase!!!
     IF vbPriceList_change = TRUE AND inUserId <> zc_User_Sybase()
     THEN
         -- Здесь еще Update - Object_PartionGoods.OperPriceList
         PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := NULL                  -- сам найдет нужный Id
                                                               , inPriceListId:= zc_PriceList_Basis()  -- !!!Базовый Прайс!!!
                                                               , inGoodsId    := inGoodsId
                                                               , inOperDate   := zc_DateStart()
                                                               , inValue      := inOperPriceList
                                                               , inIsLast     := TRUE
                                                               , inIsDiscountDelete:= FALSE
                                                               , inIsDiscount      := FALSE
                                                               , inSession         := inUserId :: TVarChar
                                                                );
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*------------------------------     -------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.04.17                                         * all
11.04.17          * lp
15.03.17                                                          *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_PartionGoods()
