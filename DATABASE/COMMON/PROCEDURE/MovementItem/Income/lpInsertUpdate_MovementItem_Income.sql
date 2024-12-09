-- Function: lpInsertUpdate_MovementItem_Income()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income (
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inAmountPacker        TFloat    , -- Количество у заготовителя
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов
    IN inPartionGoods        TVarChar  , -- Партия товара 
    IN inPartNumber          TVarChar  , -- № по тех паспорту 
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ) 
    IN inStorageId           Integer   , -- Место хранения
    IN inUserId              Integer     -- пользователь
   )
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');


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
                            , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Income()) 
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


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Количество у заготовителя>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPacker(), ioId, inAmountPacker);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- сохранили свойство <Живой вес>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LiveWeight(), ioId, inLiveWeight);
     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     IF vbIsInsert = FALSE AND EXISTS (SELECT MovementItemString.MovementItemId FROM MovementItemString WHERE MovementItemString.ValueData = inPartionGoods AND MovementItemString.MovementItemId = ioId AND MovementItemString.DescId = zc_MIString_PartionGoodsCalc())
     THEN
         -- сохранили свойство <Партия товара>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, '');
     ELSE
         -- сохранили свойство <Партия товара>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
     END IF;


     -- сохранили свойство <№ по тех паспорту>
     IF inPartNumber <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartNumber())
     THEN
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
     END IF;
   
     -- сохранили связь с <Место хранения> - для партии прихода на МО 
     IF COALESCE (inStorageId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     END IF;

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Основные средства (для которых закупается ТМЦ)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.06.23         *
 29.05.15                                        * set lp
 11.05.14                                        * add lpInsert_MovementItemProtocol
 06.10.13                                        * add lfCheck_Movement_Parent
 29.09.13                                        * add recalc inCountForPrice
 12.07.13          * lpInsertUpdate_MovementFloat_TotalSumm было lpInsertUpdate_MovementFloat_Income_TotalSumm    
 07.07.13                                        * add lpInsertUpdate_MovementFloat_Income_TotalSumm
 07.07.13                                        * add lpInsert_Object_GoodsByGoodsKind
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')




/*
 --сохранение  zc_MovementFloat_TotalHeadCount и zc_MovementFloat_TotalLiveWeight - за период 
WITH tmpMovement AS (SELECT Movement.Id
                          , Movement.InvNumber
                                FROM Movement
                                WHERE Movement.OperDate BETWEEN '01.01.2024' AND '31.12.2024'
                                  AND Movement.DescId     = zc_Movement_Income() 
                               
                               )
          , tmpMI AS  ( SELECT  *
                        FROM MovementItem
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)   
                           AND MovementItem.isErased = FALSE 
                                                      AND MovementItem.DescId = zc_MI_Master()
                      )   
         , tmpMIFloat AS (
                          SELECT *
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN  (SELECT DISTINCT tmpMI.Id FROM tmpMI) 
                           AND  MovementItemFloat.DescId IN (zc_MIFloat_HeadCount(), zc_MIFloat_LiveWeight()) 
                          )
, tmp AS (SELECT Movement.Id AS MovementId
               , Movement.InvNumber  
               , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))  AS HeadCount
               , SUM (COALESCE (MIFloat_LiveWeight.ValueData, 0)) AS LiveWeight

          FROM tmpMovement AS Movement
               INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                                    

               LEFT JOIN tmpMIFloat AS MIFloat_HeadCount
                                           ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                          AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                          AND COALESCE (MIFloat_HeadCount.ValueData, 0) <> 0
               LEFT JOIN tmpMIFloat AS MIFloat_LiveWeight
                                           ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                          AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                                          AND COALESCE (MIFloat_LiveWeight.ValueData, 0) <> 0
         --- WHERE Movement.Id = inMovementId
          GROUP BY Movement.Id 
         , Movement.InvNumber 
         HAVING SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) <> 0
             OR SUM (COALESCE (MIFloat_LiveWeight.ValueData, 0)) <> 0
         )

SELECT * --- lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalHeadCount(), tmp.MovementId, tmp.HeadCount)
                -- Сохранили свойство <Итого живой вес>
         --, lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLiveWeight(), tmp.MovementId, tmp.LiveWeight)
FROM tmp

*/