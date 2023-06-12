-- Function: lpInsertUpdate_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- Количество
    IN inCount	               TFloat    , -- Количество батонов
    IN inCuterWeight	       TFloat    , -- Фактический вес(куттера)
    IN inPartionGoodsDate      TDateTime , -- Партия товара
    IN inPartionGoods          TVarChar  , -- Партия товара
    IN inPartNumber            TVarChar  , -- № по тех паспорту
    IN inModel                 TVarChar  , -- модель
    IN inGoodsKindId           Integer   , -- Виды товаров
    IN inGoodsKindId_Complete  Integer   , -- Виды товаров ГП 
    IN inStorageId             Integer   , -- Место хранения
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean;
  DECLARE vbDocumentKindId Integer;
  DECLARE vbFromId    Integer;
  DECLARE vbToId      Integer;
BEGIN
     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN 
         RAISE EXCEPTION 'Ошибка.Не определено значение параметра <Товар>.';
     END IF;

     -- определили <Тип документа>
     vbDocumentKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentKind());


     ---Проверка zc_ObjectBoolean_GoodsByGoodsKind_Order для подразделений из Object_Unit_check_isOrder_View
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO 
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_To()
                  AND MLO.ObjectId IN (SELECT tt.UnitId FROM Object_Unit_check_isOrder_View AS tt)
                )
     THEN   
         --если товара и вида товара  нет в zc_ObjectBoolean_GoodsByGoodsKind_Order  - тогда ошиибка
         IF NOT EXISTS (SELECT 1
                        FROM ObjectBoolean AS ObjectBoolean_Order
                             INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                        WHERE ObjectBoolean_Order.ValueData = TRUE
                          AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                          AND Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
                          AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0)
                        )
         THEN
             RAISE EXCEPTION 'Ошибка.У товара <%> <%> не установлено свойство Используется в заявках.% % № % от % % %'
                            , lfGet_Object_ValueData (inGoodsId)
                            , lfGet_Object_ValueData_sh (inGoodsKindId)
                            , CHR (13)
                            , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ProductionUnion()) 
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                            , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                            , CHR (13)
                            , (SELECT Object.ValueData 
                               FROM MovementLinkObject AS MLO
                                  LEFT JOIN Object ON Object.Id = MLO.ObjectId
                               WHERE MLO.MovementId = inMovementId
                                 AND MLO.DescId = zc_MovementLinkObject_To())
                            ;
         END IF;
     END IF;

   -- меняем параметр
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;


   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId
                                      , CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()) THEN 0 ELSE inAmount END
                                      , NULL, inUserId
                                       );


   -- Схема для лакирования
   IF vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom())
   THEN
       -- Вес для лакирования
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountReal(), ioId, inAmount);
       -- !!!криво передали партию !!!
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inStorageId);
       --  Рецептуры 
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, (SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = inStorageId AND MILO.DescId = zc_MILinkObject_Receipt()));
       
       inGoodsKindId:=          (SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = inStorageId AND MILO.DescId = zc_MILinkObject_GoodsKind());
       inGoodsKindId_Complete:= (SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = inStorageId AND MILO.DescId = zc_MILinkObject_GoodsKindComplete());
       
       vbFromId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
       vbToId  := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());


       PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := tmp.MovementItemId
                                                      , inMovementId          := inMovementId
                                                      , inGoodsId             := tmp.GoodsId
                                                      , inAmount              := tmp.Amount
                                                      , inParentId            := ioId
                                                      , inPartionGoodsDate    := NULL
                                                      , inPartionGoods        := NULL
                                                      , inGoodsKindId         := tmp.GoodsKindId
                                                      , inGoodsKindCompleteId := NULL
                                                      , inCount_onCount       := 0
                                                      , inUserId              := inUserId
                                                       )
       FROM (WITH tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            FROM MovementItem
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Child()
                              AND MovementItem.isErased = FALSE
                              AND MovementItem.ParentId = ioId
                           )
             , tmpReceipt AS (SELECT COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)     AS GoodsId
                                   , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                   , COALESCE (inAmount / ObjectFloat_Value_master.ValueData * ObjectFloat_Value.ValueData, 0) AS Amount
       
                              FROM MovementItemLinkObject AS MILO
                              
                                   INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                          ON ObjectFloat_Value_master.ObjectId = MILO.ObjectId
                                                         AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                         AND ObjectFloat_Value_master.ValueData <> 0
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                        ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO.ObjectId
                                                       AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                   LEFT JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                          AND Object_ReceiptChild.isErased = FALSE
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                        ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                       AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                        ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                       AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                   -- этап Пр-ва
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_ReceiptLevel
                                                        ON ObjectLink_ReceiptChild_ReceiptLevel.ObjectId = Object_ReceiptChild.Id
                                                       AND ObjectLink_ReceiptChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptChild_ReceiptLevel()
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_From
                                                        ON ObjectLink_ReceiptLevel_From.ObjectId = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                       AND ObjectLink_ReceiptLevel_From.DescId   = zc_ObjectLink_ReceiptLevel_From()
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_To
                                                        ON ObjectLink_ReceiptLevel_To.ObjectId = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                       AND ObjectLink_ReceiptLevel_To.DescId   = zc_ObjectLink_ReceiptLevel_To()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptLevel_MovementDesc
                                                         ON ObjectFloat_ReceiptLevel_MovementDesc.ObjectId  = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                        AND ObjectFloat_ReceiptLevel_MovementDesc.DescId    = zc_ObjectFloat_ReceiptLevel_MovementDesc()
                                   --  Тип документов
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_DocumentKind
                                                        ON ObjectLink_ReceiptLevel_DocumentKind.ObjectId = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                       AND ObjectLink_ReceiptLevel_DocumentKind.DescId   = zc_ObjectLink_ReceiptLevel_DocumentKind()
                              -- выбранная партия
                              WHERE MILO.MovementItemId = inStorageId
                                AND MILO.DescId         = zc_MILinkObject_Receipt()
                                -- этап Пр-ва  тот что нужен
                                AND ObjectLink_ReceiptLevel_From.ChildObjectId      = vbFromId
                                AND ObjectLink_ReceiptLevel_To.ChildObjectId        = vbToId
                                AND ObjectFloat_ReceiptLevel_MovementDesc.ValueData = zc_Movement_ProductionUnion()
                                -- Тип документов
                                AND ObjectLink_ReceiptLevel_DocumentKind.ChildObjectId = vbDocumentKindId
                             )
              SELECT tmpMI.MovementItemId
                   , COALESCE (tmpMI.GoodsId, tmpReceipt.GoodsId)         AS GoodsId
                   , COALESCE (tmpMI.GoodsKindId, tmpReceipt.GoodsKindId) AS GoodsKindId
                   , COALESCE (tmpReceipt.Amount, 0)                      AS Amount
              FROM tmpMI
                   FULL JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI.GoodsId
                                       AND tmpReceipt.GoodsKindId = tmpMI.GoodsKindId
            ) AS tmp;

       -- !!!обнулили !!!
       inStorageId:= 0;


   END IF;


   -- сохранили связь с <Виды товаров>
   IF inGoodsKindId > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKind())
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   END IF;

   -- сохранили связь с <Виды товаров ГП>
   IF inGoodsKindId_Complete > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKindComplete())
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindId_Complete);
   END IF;

   -- сохранили связь с <Место хранения> - для партии прихода на МО
   IF inStorageId > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
   END IF;
     
   -- сохранили свойство <Количество батонов>
   IF inCount <> 0 OR EXISTS (SELECT 1 FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_Count())
   THEN
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
   END IF;

   -- сохранили свойство <Фактический вес(куттера)>
   IF inCuterWeight <> 0 OR EXISTS (SELECT 1 FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_CuterWeight())
   THEN
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterWeight(), ioId, inCuterWeight);
   END IF;
   
   
   -- сохранили свойство <Партия товара> у Child
   IF vbIsInsert = FALSE
   THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), MovementItem.Id, inPartionGoodsDate)
       FROM MovementItemDate
            INNER JOIN MovementItem ON MovementItem.ParentId = ioId
            INNER JOIN MovementItemDate AS MovementItemDate_find ON MovementItemDate_find.MovementItemId = MovementItem.Id
                                                                AND MovementItemDate_find.DescId = zc_MIDate_PartionGoods()
                                                                AND MovementItemDate_find.ValueData = MovementItemDate.ValueData
       WHERE MovementItemDate.MovementItemId = ioId
         AND MovementItemDate.DescId = zc_MIDate_PartionGoods();
   END IF;

   -- Открыли партию
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), ioId, FALSE);

   -- сохранили свойство <Партия товара>
   IF inPartionGoodsDate NOT IN (zc_DateStart(), zc_DateEnd()) OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = ioId AND MID.DescId = zc_MIDate_PartionGoods())
   THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   END IF;

   -- сохранили свойство <Партия товара/Инвентарный номер>
   IF inPartionGoods <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartionGoods())
   THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
   END IF;

   -- сохранили свойство <№ по тех паспорту>
   IF inPartNumber <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartNumber())
   THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
   END IF;

   -- сохранили свойство <Модель (Партия учета)>
   IF inModel <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_Model())
   THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Model(), ioId, inModel);
   END IF;


   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.05.23         * Model
 26.10.20         * add inGoodsKindId_Complete
 29.06.16         * add inCuterWeight
 21.03.15                                        * all
 19.12.14                                                       * add zc_MILinkObject_???GoodsKindComplete
 11.12.14         * из gp
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
