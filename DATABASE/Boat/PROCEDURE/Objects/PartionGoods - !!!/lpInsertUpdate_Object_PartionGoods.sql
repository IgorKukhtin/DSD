-- Function: lpInsertUpdate_Object_PartionGoods

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , TFloat, Integer
                                                           );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionGoods(
    IN inMovementItemId         Integer,       -- Ключ партии
    IN inMovementId             Integer,       -- Ключ Документа
    IN inFromId                 Integer,       -- Поставщик или Подразделение (место сборки)
    IN inUnitId                 Integer,       -- Подразделение(прихода)
    IN inOperDate               TDateTime,     -- Дата прихода
    IN inObjectId               Integer,       -- Комплектующие или Лодка
    IN inAmount                 TFloat,        -- Кол-во приход
    IN inEKPrice                TFloat,        -- Цена вх. без НДС
    IN inCountForPrice          TFloat,        -- Цена за количество
    IN inEmpfPrice              TFloat,        -- Цена рекоменд. без НДС
    IN inOperPriceList          TFloat,        -- Цена продажи, !!!грн!!!
    IN inOperPriceList_old      TFloat,        -- Цена продажи, ДО изменения строки
    IN inGoodsGroupId           Integer,       -- Группа товара
    IN inGoodsTagId             Integer,       -- Категория
    IN inGoodsTypeId            Integer,       -- Тип детали 
    IN inGoodsSizeId            Integer,       -- Размер
    IN inProdColorId            Integer,       -- Цвет
    IN inMeasureId              Integer,       -- Единица измерения
    IN inTaxKindId              Integer,       -- Тип НДС (!информативно!)
    IN inTaxKindValue           TFloat,        -- Значение НДС (!информативно!)
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
   DECLARE vbMovementDescId   Integer;
BEGIN
     -- заменили
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice:= 1; END IF;

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

     IF inMovementItemId > 0 AND (-- и еще раз проверим Цену
                                  inEKPrice       <> (SELECT COALESCE (Object_PartionGoods.EKPrice, 0)       FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inCountForPrice <> (SELECT COALESCE (Object_PartionGoods.CountForPrice, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                                 )
     THEN
         -- Проверка сразу - ДЛЯ 1-ой ПАРТИИ
        IF vbId_sale_part > 0
        THEN
            RAISE EXCEPTION 'Ошибка.Найден расход <%> № <%> от <%>.Нельзя корректировать <Цена вх.>.'
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
                           ;
        END IF;
     END IF;


     -- 1.1. есть ли ПЕРЕОЦЕНКА


     -- 1.2.
     IF 1=0 THEN
        -- есть ли ПАРТИИ в ДРУГИХ ПРОВЕДЕННЫХ документах - все
        vbId_income_ch:= (SELECT MovementItem.Id
                          FROM Object_PartionGoods
                               INNER JOIN MovementItem ON MovementItem.PartionId = Object_PartionGoods.MovementItemId
                                                     AND MovementItem.isErased  = FALSE
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                                                  AND Movement.DescId   = zc_Movement_Income()      -- !!!только Приход от постав.!!!
                          WHERE Object_PartionGoods.ObjectId   = inObjectId
                            AND Object_PartionGoods.MovementId <> inMovementId
                          ORDER BY Movement.OperDate DESC
                          LIMIT 1
                         );
     END IF;

     IF 1=0 THEN
        -- есть ли ПРОВЕДЕННЫЕ документы - все
        vbId_sale_ch:= (SELECT MovementItem.Id
                        FROM MovementItem
                             INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                                                AND Movement.DescId   <> zc_Movement_Income()     -- !!!только НЕ Приход от постав.!!!
                        WHERE MovementItem.ObjectId = inObjectId
                          AND MovementItem.isErased = FALSE -- !!!только НЕ удаленные!!!
                          -- AND MovementItem.DescId= ...   -- !!!любой Desc!!!
                        ORDER BY Movement.OperDate DESC
                        LIMIT 1
                       );
     END IF;


     -- 1.2.1. НАЧАЛО: Определили - можно ли менять цену
     IF 1=1
     THEN
          vbPriceList_change:= TRUE;

     -- 1.2.2. если она НЕ менялась + Товар НЕ менялся ИЛИ Insert
     ELSEIF 1=0 -- inOperPriceList = inOperPriceList_old AND (inObjectId = inObjectId_old OR inObjectId_old = 0)
     THEN
         vbPriceList_change:= FALSE;

     -- 1.2.3. если Insert и в Документе он первый ИЛИ она НЕ менялась + Цена соответсвует Значению в Истории - !!!Базовый Прайс!!!
     ELSEIF /*(inOperPriceList_old = 0 OR inOperPriceList = inOperPriceList_old) AND*/
           1=0 -- inOperPriceList = (SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (inOperDate, zc_PriceList_Basis(), inObjectId) AS tmp)
     THEN
         vbPriceList_change:= FALSE;

     -- 1.3.1. если была Переоценка
     ELSEIF vbRePrice_exists = TRUE AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.По товару <%> была переоценка.Можно ввести приход с ценой продажи = <% %>.'
                       , lfGet_Object_ValueData (inObjectId)
                       , zfConvert_FloatToString (((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (inOperDate, zc_PriceList_Basis(), inObjectId) AS tmp)))
                       , (SELECT lfGet_Object_ValueData_sh (COALESCE (OL.ChildObjectId, zc_Currency_GRN())) FROM Object LEFT JOIN ObjectLink AS OL ON OL.ObjectId = Object.Id AND OL.DescId = zc_ObjectLink_PriceList_Currency() WHERE Object.Id = zc_PriceList_Basis())
                        ;

     -- 1.3.2. если ПАРТИИ в ДРУГИХ ПРОВЕДЕННЫХ документах
     ELSEIF vbId_income_ch > 0 AND 1=0
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
     ELSEIF vbId_sale_ch > 0 AND 1=0
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


     -- 2.1. НАЧАЛО: Определили - можно ли изменять св-ва
     /*IF AND (vbId_income_ch <> 0 OR vbId_sale_ch <> 0)
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
     END IF;*/
     -- 2. ЗАВЕРШЕНО: Определили - можно ли изменять св-ва

     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);
     -- изменили элемент - по значению <Ключ партии>
     UPDATE Object_PartionGoods
            SET MovementId           = inMovementId
              , MovementDescId       = vbMovementDescId --inMovementDescId
              , FromId               = inFromId
              , UnitId               = inUnitId
              , OperDate             = inOperDate
              , ObjectId             = inObjectId
            --, Amount               = inAmount
              , EKPrice              = inEKPrice
              , CountForPrice        = inCountForPrice
              , EmpfPrice            = inEmpfPrice
              , OperPriceList        = inOperPriceList ::TFloat
                                          /*CASE WHEN vbRePrice_exists = TRUE AND 1=0
                                                 THEN --(SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (zc_DateEnd() - INTERVAL '1 DAY', zc_PriceList_Basis(), inObjectId) AS tmp)
                                            WHEN vbPriceList_change = TRUE
                                                 THEN inOperPriceList
                                            ELSE 
                                                 Object_PartionGoods.OperPriceList
                                       END*/
              , GoodsGroupId         = inGoodsGroupId
              , GoodsTagId           = zfConvert_IntToNull (inGoodsTagId)
              , GoodsTypeId          = zfConvert_IntToNull (inGoodsTypeId)
              , GoodsSizeId          = zfConvert_IntToNull (inGoodsSizeId)
              , ProdColorId          = zfConvert_IntToNull (inProdColorId)
              , MeasureId            = inMeasureId
              , TaxKindId            = inTaxKindId
              , TaxValue             = inTaxKindValue
     WHERE Object_PartionGoods.MovementItemId = inMovementItemId;

     UPDATE MovementItem SET PartionId = inMovementItemId WHERE MovementItem.Id = inMovementItemId;
     -- если такой элемент не был найден
     IF NOT FOUND THEN
        -- добавили новый элемент
        INSERT INTO Object_PartionGoods (MovementItemId, MovementId, MovementDescId, FromId, UnitId, OperDate, ObjectId
                                       , Amount, EKPrice, CountForPrice, EmpfPrice, OperPriceList
                                       , GoodsGroupId, GoodsTagId, GoodsTypeId, GoodsSizeId, ProdColorId, MeasureId, TaxKindId, TaxValue
                                       , isErased, isArc)
                                 VALUES (inMovementItemId, inMovementId, vbMovementDescId, inFromId, inUnitId, inOperDate, inObjectId
                                       , 0 /*inAmount*/, inEKPrice, inCountForPrice, inEmpfPrice
                                         -- "сложно" получили цену
                                       , inOperPriceList /*CASE WHEN vbRePrice_exists = TRUE
                                                 THEN (SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (zc_DateEnd() - INTERVAL '1 DAY', zc_PriceList_Basis(), inObjectId) AS tmp)
                                              ELSE inOperPriceList
                                         END*/
                                       , inGoodsGroupId, zfConvert_IntToNull (inGoodsTagId), zfConvert_IntToNull (inGoodsTypeId)
                                       , zfConvert_IntToNull (inGoodsSizeId), zfConvert_IntToNull (inProdColorId), inMeasureId
                                       , inTaxKindId, inTaxKindValue
                                       , TRUE, TRUE
                                        );
        -- сохранили партию
        UPDATE MovementItem SET PartionId = inMovementItemId WHERE MovementItem.Id = inMovementItemId;

   --ELSE
         -- !!!не забыли - проверили что НЕТ движения, тогда инфу в партии можно менять!!!
         -- PERFORM lpCheck ...

     END IF; -- if NOT FOUND


     -- !!!меняем у остальных партий - все св-ва!!!
    /*UPDATE Object_PartionGoods SET FabrikaId              = zfConvert_IntToNull (inFabrikaId)
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
                                  -- , EKPrice              = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inEKPrice                         ELSE Object_PartionGoods.EKPrice     END
                                    -- только для документа inMovementId - еще и Цену вх.
                                  -- , CountForPrice          = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inCountForPrice                     ELSE Object_PartionGoods.CountForPrice END
                                    -- еще и Цену Прайса - если она ПОСЛЕДЕНЯЯ
                                  , OperPriceList          = CASE WHEN vbPriceList_change = TRUE THEN inOperPriceList ELSE Object_PartionGoods.OperPriceList END
     WHERE Object_PartionGoods.MovementItemId <> inMovementItemId
       AND Object_PartionGoods.ObjectId        = inObjectId;*/


     -- cохранили Цену в истории - !!!Кроме Sybase!!!
     IF 1=1 -- vbPriceList_change = TRUE
     THEN
         -- Здесь еще Update - Object_PartionGoods.OperPriceList
         PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := NULL                  -- сам найдет нужный Id
                                                               , inPriceListId:= zc_PriceList_Basis()  -- !!!Базовый Прайс!!!
                                                               , inGoodsId    := inObjectId
                                                               , inOperDate   := zc_DateStart()
                                                               , ioPriceNoVAT := inOperPriceList
                                                               , ioPriceWVAT  := 0
                                                               , inIsLast     := TRUE
                                                               , inSession    := inUserId :: TVarChar
                                                                );
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*------------------------------     -------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
01.03.21                                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_PartionGoods()
