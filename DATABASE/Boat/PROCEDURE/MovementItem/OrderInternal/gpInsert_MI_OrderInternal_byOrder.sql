-- Function: gpInsert_MI_OrderInternal_byOrderClient()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternal_byOrder(Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternal_byOrderClient(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderInternal_byOrderClient(
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
                                               , inProcedureName := 'gpInsert_MI_OrderInternal_auto'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;*/

    -- zc_MI_Master - текущий заказ производства
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Amount TFloat, MovementId_order Integer) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId, Amount, MovementId_order)
          SELECT MovementItem.Id
               , MovementItem.ObjectId 
               , MovementItem.Amount
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
          FROM MovementItem
               -- ValueData - MovementId заказ Клиента
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 

          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

    -- zc_MI_Child - текущий заказ производства
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
    CREATE TEMP TABLE _tmpOrder_Child (MovementId_order Integer, ObjectId Integer, PartionId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpOrder_Child (MovementId_order, ObjectId, PartionId, Amount)
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
      -- результат
     SELECT tmpMI_Child.MovementId_order
          , tmpMI_Child.ObjectId
          , tmpMI_Child.PartionId
            -- сколько осталось
          , tmpMI_Child.Amount AS Amount

     FROM (SELECT tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId, SUM (tmpMI_Child.Amount) AS Amount
           FROM tmpMI_Child
           GROUP BY tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId
          ) AS tmpMI_Child
    ;
    
    CREATE TEMP TABLE _tmpOrder_Detail (MovementId_order Integer, ObjectId Integer, PartionId Integer
                                      , ReceiptLevelId Integer, ColorPatternId Integer, ProdColorPatternId Integer
                                      , ObjectId_master Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpOrder_Detail (MovementId_order, ObjectId, PartionId, ReceiptLevelId, ColorPatternId, ProdColorPatternId, ObjectId_master, Amount)
       -- Заказы клиента - zc_MI_Detail - детализация по Резервам
       SELECT MI_Detail.MovementId   AS MovementId_order
            , MI_Detail.ObjectId
            , MI_Detail.PartionId
            , MILO_ReceiptLevel.ObjectId AS ReceiptLevelId
            , MILO_ColorPattern.ObjectId AS ColorPatternId
            , MILO_ProdColorPattern.ObjectId AS ProdColorPatternId
            
            --, MovementItem.ObjectId AS ObjectId_master
            , COALESCE (MovementItem.ObjectId, MILinkObject_Goods.ObjectId) AS ObjectId_master
              -- Кол-во - попало в Резерв
            , SUM (MI_Detail.Amount) AS Amount

       FROM Movement
            INNER JOIN MovementItem AS MI_Detail
                                    ON MI_Detail.MovementId = Movement.Id
                                   AND MI_Detail.DescId     = zc_MI_Detail()
                                   AND MI_Detail.isErased   = FALSE

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MI_Detail.Id
                                            AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()

           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Child()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.Id = MI_Detail.ParentId    ---537385

            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                 ON ObjectLink_Goods.ChildObjectId = COALESCE (MovementItem.ObjectId, MILinkObject_Goods.ObjectId)
                                AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()

            LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                             ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                            AND MILO_ReceiptLevel.DescId = zc_MILinkObject_ReceiptLevel()
            LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = MILO_ReceiptLevel.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                             ON MILO_ColorPattern.MovementItemId = MovementItem.Id
                                            AND MILO_ColorPattern.DescId = zc_MILinkObject_ColorPattern()
            LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = MILO_ColorPattern.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                             ON MILO_ProdColorPattern.MovementItemId = MovementItem.Id
                                            AND MILO_ProdColorPattern.DescId = zc_MILinkObject_ProdColorPattern()
            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = MILO_ProdColorPattern.ObjectId                      
      WHERE Movement.Id = inMovementId_OrderClient 
         AND Movement.DescId   = zc_Movement_OrderClient()
         -- все НЕ удаленные
         AND Movement.StatusId <> zc_Enum_Status_Erased()
         -- Кол-во - попало в Резерв
         AND MI_Detail.Amount > 0
         AND (ObjectLink_Goods.ObjectId = inreceiptgoodsid OR inreceiptgoodsid = 0)
      GROUP BY MI_Detail.MovementId
             , MI_Detail.ObjectId
             , MI_Detail.PartionId
             --, MovementItem.ObjectId
             , COALESCE (MovementItem.ObjectId, MILinkObject_Goods.ObjectId)
             , MILO_ReceiptLevel.ObjectId
             , MILO_ColorPattern.ObjectId
             , MILO_ProdColorPattern.ObjectId
      ;
                            
    -- test
    --RAISE EXCEPTION '%', (select count(*)  from _tmpOrder);


    -- сохраняем - zc_MI_Master - 
    PERFORM lpInsertUpdate_MovementItem_OrderInternal (ioId                     := COALESCE (_tmpMI_Master.Id, 0)
                                                     , inMovementId             := inMovementId
                                                     , inMovementId_OrderClient := COALESCE (tmp.MovementId_order, _tmpMI_Master.MovementId_order) :: Integer
                                                     , inGoodsId                := COALESCE (tmp.ObjectId, _tmpMI_Master.ObjectId)
                                                     , inAmount                 := COALESCE (tmp.Amount, _tmpMI_Master.Amount)
                                                     , inComment                :='' ::TVarChar
                                                     , inUserId                 := vbUserId
                                                      )
    FROM _tmpMI_Master
         -- привязываем существующие строки с новыми данными
         FULL JOIN (--группируем данные заказа
                    SELECT _tmpOrder_Child.ObjectId
                         , SUM (COALESCE (_tmpOrder_Child.Amount,0)) AS Amount
                         --заказ клиента 
                         , _tmpOrder_Child.MovementId_order
                    FROM _tmpOrder_Child
                    GROUP BY _tmpOrder_Child.ObjectId
                           , _tmpOrder_Child.MovementId_order
                    ) AS tmp ON tmp.ObjectId = _tmpMI_Master.objectId
                            AND tmp.MovementId_order = _tmpMI_Master.MovementId_order
    ;   

    --записанные строки мастера
        CREATE TEMP TABLE _tmpMI_New (Id Integer, ObjectId Integer, Amount TFloat, MovementId_order Integer) ON COMMIT DROP;
    INSERT INTO _tmpMI_New (Id, ObjectId, Amount, MovementId_order)
          SELECT MovementItem.Id
               , MovementItem.ObjectId 
               , MovementItem.Amount
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
          FROM MovementItem
               -- ValueData - MovementId заказ Клиента
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 

          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;
    
    -- сохраняем - zc_MI_Child - 
    PERFORM lpInsertUpdate_MI_OrderInternal_Child (ioId                 := COALESCE (_tmpMI_Child.Id, 0)
                                                 , inParentId           := _tmpMI_Master.Id
                                                 , inMovementId         := inMovementId
                                                 , inObjectId           := COALESCE (_tmpOrder_Detail.ObjectId, _tmpMI_Master.ObjectId)
                                                 , inReceiptLevelId     := _tmpOrder_Detail.ReceiptLevelId
                                                 , inColorPatternId     := _tmpOrder_Detail.ColorPatternId
                                                 , inProdColorPatternId := _tmpOrder_Detail.ProdColorPatternId
                                                 , inUnitId             := 0
                                                 , inAmount             := _tmpOrder_Detail.Amount  ::TFloat
                                                 , inAmountReserv       := 0 ::TFloat
                                                 , inAmountSend         := 0 ::TFloat
                                                 , inUserId             := vbUserId
                                                  )
    FROM _tmpOrder_Detail
         -- привязываем существующие строки с новыми данными
         FULL JOIN _tmpMI_New AS _tmpMI_Master ON _tmpMI_Master.objectId = _tmpOrder_Detail.ObjectId_master 
                                 AND _tmpMI_Master.MovementId_order = _tmpOrder_Detail.MovementId_order
         LEFT JOIN _tmpMI_Child ON _tmpMI_Child.ParentId = _tmpMI_Master.Id  
    WHERE _tmpOrder_Detail.Amount > 0
    ;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.12.22         *
*/

-- тест
-- select * from gpInsert_MI_OrderInternal_byOrder(inMovementId := 663 , inMovementId_OrderClient := 662 , inReceiptGoodsId := 253170 ,  inSession := '5');

      /*   , tmpReceiptGoods AS (SELECT DISTINCT ObjectLink_Goods.ChildObjectId AS GoodsId
                               FROM Object AS Object_ReceiptGoods
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                               WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                                 AND Object_ReceiptGoods.isErased = FALSE

                        */