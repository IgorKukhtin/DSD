-- Function: lpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionGoodsDate    TDateTime , -- Дата партии/Дата перемещения
    IN inPrice               TFloat    , -- Цена
    IN inSumm                TFloat    , -- Сумма
    IN inHeadCount           TFloat    , -- Количество голов
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inPartionGoods        TVarChar  , -- Партия товара/Инвентарный номер 
    IN inPartNumber          TVarChar  , -- № по тех паспорту 
    IN inPartionGoodsId      Integer   , -- партия
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUnitId              Integer   , -- Подразделение (для МО)
    IN inStorageId           Integer   , -- Место хранения 
    IN inPartionModelId      Integer   , -- Модель
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- !!!Проверка - Инвентаризация - запрет на изменения (разрешено только проведение)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11109744)
        AND inUserId > 0
     THEN
          RAISE EXCEPTION 'Ошибка.Нет прав.';
     END IF;

     -- !!!замена после Проверки!!!
     IF inUserId < 0 THEN inUserId:= -1 * inUserId; END IF;


      -- !!!Проверка inPartionGoodsDate!!!
     IF inPartionGoodsDate IS NOT NULL
     -- Склад Реализации + Склад База ГП
     AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (8458)) --, zc_Unit_RK()
     -- Кладовщик Днепр
     AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382))
     -- !!!tmp
     -- AND inUserId <> 5
      THEN
          RAISE EXCEPTION 'Ошибка.В документе <Инвентаризация> № <%> за <%> партия даты должна быть пустой <%>.% <%> <%>'
                         , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                         , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         , zfConvert_DateToString (inPartionGoodsDate)
                         , CHR (13)
                         , lfGet_Object_ValueData_sh (inGoodsId)
                         , lfGet_Object_ValueData_sh (inGoodsKindId)
                          ;
      END IF;

     -- !!!НЕТ - Проверка что элемент один!!!
     IF 1=0
     AND inAmount <> 0 -- AND inGoodsKindId <> 0
     -- Склад Реализации + Склад База ГП
     AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK(), 8458))
     -- Кладовщик Днепр
     AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382))
     -- Проверка
     AND EXISTS (SELECT 1
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                       ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                      LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                 ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                      LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                   ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                  AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()*/
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = inGoodsId
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0)            = COALESCE (inGoodsKindId, 0)
                   -- AND COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)    = COALESCE (inGoodsKindCompleteId, 0)
                   -- AND COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) = COALESCE (inPartionGoodsDate, zc_DateStart())
                   -- AND COALESCE (MIString_PartionGoods.ValueData, '')           = COALESCE (inPartionGoods, '')
                   AND MovementItem.isErased = FALSE
                   AND MovementItem.Amount <> 0
                   AND MovementItem.Id <> COALESCE (ioId, 0)
                )
      THEN
          -- RAISE EXCEPTION 'Ошибка.В документе <Инвентаризация> № <%> за <%> уже введена партия <% % % % %> другим пользователем.Обновите данные и повторите действие через 25 сек.'
          RAISE EXCEPTION 'Ошибка.В документе <Инвентаризация> № <%> за <%> уже введена партия <% %> другим пользователем.Обновите данные и повторите действие через 5 сек.'
                         , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                         , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         , lfGet_Object_ValueData (inGoodsId)
                         , lfGet_Object_ValueData_sh (inGoodsKindId)
                         -- , lfGet_Object_ValueData (inGoodsKindCompleteId)
                         -- , (SELECT CASE WHEN inPartionGoodsDate > zc_DateStart() THEN zfConvert_DateToString (inPartionGoodsDate) ELSE '' END)
                         -- , (SELECT CASE WHEN inPartionGoods <> '' THEN inPartionGoods ELSE '' END)
                          ;
      END IF;


     -- Для Ячейки может быть сохранена только ОДНА партия
     IF 1=1 AND inAssetId < 0 
     -- Розподільчий комплекс
     AND zc_Unit_RK() = (SELECT MLO.ObjectId AS MLO FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
     -- Проверка
     AND EXISTS (SELECT 1
                 FROM MovementItem
                      INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                   ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                  AND MIFloat_PartionCell.ValueData      = -1 * inAssetId :: TFloat
                      LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                       ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                 ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                   AND MovementItem.Id         <> COALESCE (ioId, 0)
                   -- если другая партия или товар в этой ячейке
                   AND (MovementItem.ObjectId <> inGoodsId
                     OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                     OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                       )
                )
      THEN
          RAISE EXCEPTION 'Ошибка.В документе <Инвентаризация> № <%> от <%> %для Ячейки <%> %может быть сохранена только партия% <%> %с датой <%>.'
                         , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                         , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , CHR (13)
                        , lfGet_Object_ValueData (-1 * inAssetId)
                        , CHR (13)
                        , CHR (13)
                        , (SELECT DISTINCT lfGet_Object_ValueData (MovementItem.ObjectId) || '> <' || lfGet_Object_ValueData_sh (MILO_GoodsKind.ObjectId)
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                             ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                            AND MIFloat_PartionCell.ValueData      = -1 * inAssetId :: TFloat
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          
                                LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                           ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                          AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                             AND MovementItem.Id         <> COALESCE (ioId, 0)
                             -- если другая партия или товар в этой ячейке
                             AND (MovementItem.ObjectId <> inGoodsId
                               OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                               OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                                 )
                          )
                        , CHR (13)
                        , (SELECT DISTINCT zfConvert_DateToString (MID_PartionGoodsDate.ValueData)
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                             ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                            AND MIFloat_PartionCell.ValueData      = -1 * inAssetId :: TFloat
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          
                                LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                           ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                          AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                             AND MovementItem.Id         <> COALESCE (ioId, 0)
                             -- если другая партия или товар в этой ячейке
                             AND (MovementItem.ObjectId <> inGoodsId
                               OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                               OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                                 )
                          )
                         ;
      END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- сохранили свойство <Количество батонов или упаковок>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);

     -- сохранили свойство <ContainerId>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, 0);

     -- сохранили свойство <ContainerId>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, TRUE);

     -- сохранили связь с <партия товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), ioId, inPartionGoodsId);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Виды товаров ГП>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);


     -- если это Ячейка хранения - ТОЛЬКО для Розподільчий комплекс
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK()))
        -- так передается из Scale
        AND inAssetId < 0
     THEN
         -- сохранили связь с <Ячейка хранения>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell(), ioId, -1 * inAssetId :: TFloat);
     ELSE
         -- сохранили связь с <Основные средства (для которых закупается ТМЦ)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);
     END IF;


     IF COALESCE (inPartionGoodsId, 0) = 0
     THEN
         -- сохранили свойство <Цена>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
         -- сохранили свойство <Сумма>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
         -- сохранили свойство <Дата партии/Дата перемещения>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
         -- сохранили свойство <Партия товара/Инвентарный номер>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
         
         -- сохранили связь с <Место хранения> - для партии прихода на МО 
         IF COALESCE (inStorageId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
         THEN
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
         END IF;

         -- сохранили свойство <Модель> 
         IF COALESCE (inPartionModelId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_PartionModel())
         THEN
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionModel(), ioId, inPartionModelId);
         END IF;
         
         -- сохранили связь с <Подразделение (для МО)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

         -- сохранили свойство <№ по тех паспорту>
         IF inPartNumber <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartNumber())
         THEN
             PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
         END IF;
     END IF;



     -- создали объект <Связи Товары и Виды товаров>
     PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.12.18         * inPartionGoodsId
 26.07.14                                        * add inPrice and inUnitId and inStorageId
 21.08.13                                        * add inGoodsKindId
 18.07.13         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inPartionGoodsId:=0, inGoodsKindId:= 0, inSession:= '2')
