-- Function: gpInsert_MI_OrderInternal_byOrderClientAll()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternal_byOrderClientAll(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderInternal_byOrderClientAll(
    IN inMovementId             Integer   , -- Ключ объекта <Документ> 
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inGoodsId                Integer   , -- узел
    IN inSession                TVarChar    -- сессия пользователя
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

    -- zc_MI_Master - текущий заказ поставщика
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Amount TFloat, MovementId_order Integer, Comment TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId, Amount, MovementId_order, Comment)
          SELECT MovementItem.Id
               , MovementItem.ObjectId 
               , MovementItem.Amount
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MIString_Comment.ValueData              AS Comment
          FROM MovementItem
               -- MovementId заказ Клиента
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;


    -- данные из заказа - Новый заказ поставщику - Узлы
    CREATE TEMP TABLE _tmpOrder (MovementId_order Integer, ObjectId Integer, Amount NUMERIC(16, 8)) ON COMMIT DROP;
    INSERT INTO _tmpOrder (MovementId_order, ObjectId, Amount)
       WITH 
           tmpMI_Detail AS (-- Заказ клиента - zc_MI_Detail : "виртуальные" Узлы + Узлы
                            SELECT DISTINCT
                                   Movement.Id                      AS MovementId_order
                                   -- Узел                          
                                 , MILinkObject_Goods.ObjectId      AS GoodsId
                                   -- "виртуальный" Узел
                                 , MILinkObject_GoodsBasis.ObjectId AS GoodsId_basis
                            FROM Movement
                                 INNER JOIN MovementItem AS MI_Detail
                                                         ON MI_Detail.MovementId = Movement.Id
                                                        AND MI_Detail.DescId     = zc_MI_Detail()
                                                        AND MI_Detail.isErased   = FALSE
                                 -- какой узел собирается
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                  ON MILinkObject_Goods.MovementItemId = MI_Detail.Id
                                                                 AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                 -- "виртуальный" Узел
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                  ON MILinkObject_GoodsBasis.MovementItemId = MI_Detail.Id
                                                                 AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                            WHERE Movement.Id     = inMovementId_OrderClient
                              AND Movement.DescId = zc_Movement_OrderClient()
                           )
          , tmpMI_Child AS (-- Заказ клиента - zc_MI_Child - Узлы
                            SELECT MovementItem.MovementId   AS MovementId_order
                                 , MovementItem.ObjectId
                                   -- Количество шаблон сборки
                                 , zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData) AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                 LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                             ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                                 -- 
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                                  ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                            WHERE Movement.Id     = inMovementId_OrderClient
                              AND Movement.DescId = zc_Movement_OrderClient()
                              -- какой узел перемещаем
                              AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                              -- если есть сборка, тогда это узел
                              AND MovementItem.ObjectId IN (SELECT DISTINCT tmpMI_Detail.GoodsId FROM tmpMI_Detail)
                              -- !!!без опций!!!
                              AND MILinkObject_ProdOptions.ObjectId IS NULL
                              
                           UNION ALL
                            -- Заказ клиента - zc_MI_Detail - "виртуальные" Узлы
                            SELECT DISTINCT
                                   tmpMI_Detail.MovementId_order
                                 , tmpMI_Detail.GoodsId_basis AS ObjectId
                                   --  Количество - ОДИН Узел
                                 , 1 AS Amount
                            FROM tmpMI_Detail
                            WHERE -- есть "виртуальный" Узел
                                  tmpMI_Detail.GoodsId_basis > 0
                              -- какой "виртуальный" Узел перемещаем
                              AND (tmpMI_Detail.GoodsId_basis = inGoodsId OR inGoodsId = 0)
                           )

     -- сколько осталось для перемещения
     SELECT tmpMI_Child.MovementId_order
          , tmpMI_Child.ObjectId
            -- сколько осталось
          , tmpMI_Child.Amount 

     FROM (SELECT tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, SUM (tmpMI_Child.Amount) AS Amount
           FROM tmpMI_Child
           GROUP BY tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId
          ) AS tmpMI_Child
     -- !! осталось что Перемещать!!!
     WHERE tmpMI_Child.Amount >= 0
       -- !!!только целые кол-во!!!
       AND tmpMI_Child.Amount :: Integer = tmpMI_Child.Amount
    ;                            

    -- test
    --RAISE EXCEPTION '%', (select count(*)  from _tmpOrder);

    -- сохраняем - zc_MI_Master - Новый 
    PERFORM lpInsertUpdate_MovementItem_OrderInternal (ioId                    := COALESCE (_tmpMI_Master.Id, 0)
                                                     , inMovementId            := inMovementId
                                                     , inMovementId_OrderClient:= COALESCE (_tmpOrder.MovementId_order, _tmpMI_Master.MovementId_order) :: Integer
                                                     , inGoodsId               := COALESCE (_tmpOrder.ObjectId, _tmpMI_Master.ObjectId)
                                                     , inAmount                := COALESCE (_tmpOrder.Amount, _tmpMI_Master.Amount)
                                                     , inComment               := COALESCE (_tmpMI_Master.Comment,'') ::TVarChar
                                                     , inUserId                := vbUserId
                                                     )
                                                       
    FROM _tmpMI_Master
         -- привязываем существующие строки с новыми данными
         FULL JOIN (-- группируем данные заказа
                    SELECT _tmpOrder.ObjectId
                         , SUM (COALESCE (_tmpOrder.Amount,0)) AS Amount
                           -- заказ клиента 
                         , _tmpOrder.MovementId_order
                    FROM _tmpOrder
                    GROUP BY _tmpOrder.ObjectId
                           , _tmpOrder.MovementId_order
                    ) AS _tmpOrder
                      ON _tmpOrder.ObjectId         = _tmpMI_Master.objectId
                     AND _tmpOrder.MovementId_order = _tmpMI_Master.MovementId_order
    ;   

    -- удаление zc_MI_Master кол-во = 0
    /*/PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
      AND MovementItem.Amount     = 0
   ;*/


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.23         *
*/

-- тест
--