-- Function: gpInsert_MI_Send_byOrderInternal()

DROP FUNCTION IF EXISTS gpInsert_MI_Send_byOrderInternal (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send_byOrderInternal(
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Order         Integer   , -- Заказ производства
    IN inGoodsId                  Integer   , -- узел
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId       Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderPartner());
     vbUserId:= lpGetUserBySession (inSession);


    --проверка, если  есть строки в док то ошибка
  /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Child())
    THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Строки документа уже заполнены' :: TVarChar
                                               , inProcedureName := 'gpInsert_MI_Send_auto'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;*/

    -- zc_MI_Master - текущее Перемещение
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Amount TFloat, MovementId_order Integer, PartNumber TVarChar, Comment TVarChar, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId, Amount, MovementId_order, PartNumber, Comment, OperPrice, CountForPrice)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
               , MovementItem.Amount
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MIString_PartNumber.ValueData           AS PartNumber
               , MIString_Comment.ValueData              AS Comment
               , MIFloat_OperPrice.ValueData             AS OperPrice
               , MIFloat_CountForPrice.ValueData         AS CountForPrice
          FROM MovementItem
               -- MovementId заказ Клиента
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
               --
               LEFT JOIN MovementItemString AS MIString_PartNumber
                                            ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                           AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
               --
               LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                           ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice() 
               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice() 
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

    -- данные из OrderInternal - Новое Перемещение - Комплектующие для сборки Узлов
    CREATE TEMP TABLE _tmpOrder (MovementId_order Integer, ObjectId Integer, Amount NUMERIC(16, 8)) ON COMMIT DROP;
    INSERT INTO _tmpOrder (MovementId_order, ObjectId, Amount)
       WITH
            tmpMI_Child AS (-- Заказ - zc_MI_Detail - Комплектующие
                            SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                                 , MI_Child.ObjectId
                                 , SUM (zfCalc_Value_ForCount (MI_Child.Amount, MIFloat_ForCount.ValueData)) AS Amount
                            FROM Movement
                                 -- какой узел собирается
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                                        -- для какого узла перемещаем
                                                        AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                                 -- MovementId заказ Клиента
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                 -- Комплектующие
                                 INNER JOIN MovementItem AS MI_Child
                                                         ON MI_Child.MovementId = Movement.Id
                                                        AND MI_Child.DescId     = zc_MI_Child()
                                                        AND MI_Child.ParentId   = MovementItem.Id
                                                        AND MI_Child.isErased   = FALSE
                                 LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                             ON MIFloat_ForCount.MovementItemId = MI_Child.Id
                                                            AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()

                            WHERE Movement.Id     = inMovementId_Order
                              AND Movement.DescId = zc_Movement_OrderInternal()

                            GROUP BY MIFloat_MovementId.ValueData :: Integer
                                   , MI_Child.ObjectId
                            )

     -- сколько осталось для перемещения
     SELECT tmpMI_Child.MovementId_order
          , tmpMI_Child.ObjectId
            -- сколько осталось
          , tmpMI_Child.Amount
     FROM tmpMI_Child
          -- !!!не ПФ!!!
          INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpMI_Child.ObjectId
                                           AND Object_Goods.ValueData NOT ILIKE 'ПФ%'
     WHERE tmpMI_Child.Amount >= 0
       -- !!!только целые кол-во!!!
       AND tmpMI_Child.Amount :: Integer = tmpMI_Child.Amount
       -- !!!не "виртуальные" узлы!!!
       AND tmpMI_Child.ObjectId NOT IN (SELECT OL.ChildObjectId
                                        FROM ObjectLink AS OL
                                             -- Не удален
                                             INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = OL.ObjectId
                                                                                          AND Object_ReceiptGoodsChild.isErased = FALSE

                                             INNER JOIN ObjectLink AS OL_ReceiptGoodsChild_ReceiptGoods
                                                                   ON OL_ReceiptGoodsChild_ReceiptGoods.ObjectId = OL.ObjectId
                                                                  AND OL_ReceiptGoodsChild_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                             -- Не удален
                                             INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = OL_ReceiptGoodsChild_ReceiptGoods.ChildObjectId
                                                                                     AND Object_ReceiptGoods.isErased = FALSE
                                        WHERE OL.DescId        = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                          AND OL.ChildObjectId > 0
                                       )
    ;

    -- test
    --RAISE EXCEPTION '%', (select count(*)  from _tmpOrder);


    -- сохраняем - zc_MI_Master - Новое Перемещение
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                     := COALESCE (_tmpMI_Master.Id, 0)
                                            , inMovementId             := inMovementId
                                            , inMovementId_OrderClient := COALESCE (tmp.MovementId_order, _tmpMI_Master.MovementId_order) :: Integer
                                            , inGoodsId                := COALESCE (tmp.ObjectId, _tmpMI_Master.ObjectId)
                                            , inAmount                 := COALESCE (tmp.Amount, _tmpMI_Master.Amount)
                                            , inOperPrice              := COALESCE (tmp.OperPrice, 0)
                                            , inCountForPrice          := COALESCE (tmp.CountForPrice, 1)
                                            , inPartNumber             := COALESCE (_tmpMI_Master.PartNumber,'') ::TVarChar
                                            , inComment                :='' ::TVarChar
                                            , inUserId                 := vbUserId
                                             )
    FROM _tmpMI_Master
         -- привязываем существующие строки с новыми данными
         FULL JOIN (-- группируем данные заказа
                    SELECT _tmpOrder.ObjectId
                           -- неправильная цена, в партиях другая
                         , ObjectFloat_EKPrice.ValueData AS OperPrice
                         , 1 :: TFloat AS CountForPrice
                         , SUM (_tmpOrder.Amount) AS Amount
                          -- заказ
                         , _tmpOrder.MovementId_order
                    FROM _tmpOrder
                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                               ON ObjectFloat_EKPrice.ObjectId = _tmpOrder.ObjectId
                                              AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                    GROUP BY _tmpOrder.ObjectId
                           , ObjectFloat_EKPrice.ValueData
                           , _tmpOrder.MovementId_order
                    ) AS tmp ON tmp.ObjectId = _tmpMI_Master.objectId
                            AND tmp.MovementId_order = _tmpMI_Master.MovementId_order
    ;

/*
    -- удаление zc_MI_Master кол-во = 0
    PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
      AND MovementItem.Amount     = 0
   ;
*/

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.12.22         *
*/

-- тест
-- SELECT * FROM gpInsert_MI_Send_byOrder(inMovementId := 663 , inMovementId_Order := 662 , inGoodsId := 253170 ,  inSession := '5');
