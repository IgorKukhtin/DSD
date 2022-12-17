-- Function: gpInsert_MI_Send_byOrder()

DROP FUNCTION IF EXISTS gpInsert_MI_Send_byOrder(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send_byOrder(
    IN inMovementId            Integer   , -- Ключ объекта <Документ> 
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inReceiptGoodsId        Integer   , -- узел
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbUnitId_From  Integer;
  DECLARE vbUnitId_To    Integer;
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
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Amount TFloat, MovementId_order Integer, PartNumber TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId, Amount, MovementId_order, PartNumber)
          SELECT MovementItem.Id
               , MovementItem.ObjectId 
               , MovementItem.Amount
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MIString_PartNumber.ValueData AS PartNumber
          FROM MovementItem
               -- ValueData - MovementId заказ Клиента
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 

               LEFT JOIN MovementItemString AS MIString_PartNumber
                                            ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                           AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

    -- zc_MI_Child - текущее Перемещение
    CREATE TEMP TABLE _tmpMI_Child (Id Integer, ParentId Integer, ObjectId Integer, PartionId Integer, MovementId_order Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Child (Id, ParentId, ObjectId, PartionId, MovementId_order, Amount)
          SELECT MovementItem.Id
               , MovementItem.ParentId
               , MovementItem.ObjectId
               , MovementItem.PartionId
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MovementItem.Amount
          FROM MovementItem
               -- zc_MI_Master не удален
               INNER JOIN _tmpMI_Master ON _tmpMI_Master.Id = MovementItem.ParentId
               -- ValueData - MovementId заказ Клиента
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE;


    -- данные из заказа (child)
    CREATE TEMP TABLE _tmpOrder (MovementId_order Integer, ObjectId Integer, PartionId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpOrder (MovementId_order, ObjectId, PartionId, Amount)
       WITH 
            tmpMI_Child AS (-- Заказы клиента - zc_MI_Child - детализация по Резервам
                            SELECT MovementItem.MovementId   AS MovementId_order
                                 , MovementItem.ObjectId
                                 , MovementItem.PartionId
                                   -- Кол-во - попало в Резерв
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                      ON ObjectLink_Goods.ChildObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()

                            WHERE Movement.Id = inMovementId_OrderClient
                              AND Movement.DescId   = zc_Movement_OrderClient()
                              -- все НЕ удаленные
                              --AND Movement.StatusId <> zc_Enum_Status_Erased()
                              -- Кол-во - попало в Резерв
                              AND MovementItem.Amount > 0
                              AND (ObjectLink_Goods.ObjectId = inReceiptGoodsId OR inReceiptGoodsId = 0)
                            GROUP BY MovementItem.MovementId
                                   , MovementItem.ObjectId
                                   , MovementItem.PartionId
                            )

             -- Перемещения - сколько уже переместили Резервов под Заказ клиента
           , tmpMI_Send AS (SELECT MovementItem.MovementId
                                 , MovementItem.ObjectId
                                 , MovementItem.PartionId
                                   -- Сколько переместили
                                 , MovementItem.Amount
                                   -- Заказ клиента
                                 , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                            FROM MovementItemFloat AS MIFloat_MovementId
                                 INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                        AND MovementItem.DescId   = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                 -- это точно Перемещение
                                 INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                    AND Movement.DescId   = zc_Movement_Send()
                                                    -- все НЕ удаленные
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                  --AND Movement.StatusId = zc_Enum_Status_Complete()
                                 -- zc_MI_Master не удален
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE

                            WHERE MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMI_Child.MovementId_order FROM tmpMI_Child)
                              AND MIFloat_MovementId.DescId   = zc_MIFloat_MovementId()
                           )
     -- сколько осталось для а=перемещения
     SELECT tmpMI_Child.MovementId_order
          , tmpMI_Child.ObjectId
          , tmpMI_Child.PartionId
            -- сколько осталось
          , tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) AS Amount

     FROM (SELECT tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId, SUM (tmpMI_Child.Amount) AS Amount
           FROM tmpMI_Child
           GROUP BY tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId
          ) AS tmpMI_Child
          -- Итого сколько переместили
          LEFT JOIN (SELECT tmpMI_Send.MovementId_order
                          , tmpMI_Send.ObjectId
                          , tmpMI_Send.PartionId
                          , SUM (tmpMI_Send.Amount) AS Amount
                     FROM tmpMI_Send
                     -- !!!БЕЗ текущего Перемещения
                     WHERE tmpMI_Send.MovementId <> inMovementId
                     GROUP BY tmpMI_Send.MovementId_order
                            , tmpMI_Send.ObjectId
                            , tmpMI_Send.PartionId
                    ) AS tmpMI_Send
                      ON tmpMI_Send.MovementId_order = tmpMI_Child.MovementId_order
                     AND tmpMI_Send.PartionId        = tmpMI_Child.PartionId
     -- !! осталось что Перемещать!!!
     WHERE tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) > 0
    ;

    -- test
    --RAISE EXCEPTION '%', (select count(*)  from _tmpOrder);


    -- сохраняем - zc_MI_Master - текущее Перемещение
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
         FULL JOIN (--группируем данные заказа
                    SELECT _tmpOrder.ObjectId
                           -- неправильная цена, в партиях другая
                         , ObjectFloat_EKPrice.ValueData AS OperPrice
                         , 1 :: TFloat AS CountForPrice
                         , SUM (COALESCE (_tmpOrder.Amount,0)) AS Amount
                         --заказ клиента 
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
 17.12.22         *
*/

-- тест
-- select * from gpInsert_MI_Send_byOrder(inMovementId := 663 , inMovementId_OrderClient := 662 , inReceiptGoodsId := 253170 ,  inSession := '5');

      /*   , tmpReceiptGoods AS (SELECT DISTINCT ObjectLink_Goods.ChildObjectId AS GoodsId
                               FROM Object AS Object_ReceiptGoods
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                               WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                                 AND Object_ReceiptGoods.isErased = FALSE

                        */