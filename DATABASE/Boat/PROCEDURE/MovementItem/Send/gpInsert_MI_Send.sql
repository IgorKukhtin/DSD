-- Function: gpInsert_MI_Send_Child()

DROP FUNCTION IF EXISTS gpInsert_MI_Send_Child(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_Send_(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderPartner());
     vbUserId:= lpGetUserBySession (inSession);


    --проверка, если  есть строки в док то ошибка
  /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Master())
    THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Строки документа уже заполнены' :: TVarChar
                                               , inProcedureName := 'gpInsert_MI_Send'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;*/


    -- данные из мастера док Перемещение
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Amount TFloat, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId,Amount, OperPrice, CountForPrice)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
               , MovementItem.Amount
               , MIFloat_OperPrice.ValueData     AS OperPrice
               , COALESCE (MIFloat_CountForPrice.ValueData, 1) AS CountForPrice
          FROM MovementItem
               LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                           ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;
    -- данные из чайлд док Перемещение
    CREATE TEMP TABLE _tmpMI_Child (Id Integer, ParentId Integer, ObjectId Integer, MovementId_order Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Child (Id, ParentId, ObjectId, MovementId_order, Amount)
          SELECT MovementItem.Id
               , MovementItem.ParentId
               , MovementItem.ObjectId
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MovementItem.Amount
          FROM MovementItem
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE;


    -- данные резерв (заказ + приход)
    CREATE TEMP TABLE _tmpReserveAll (MovementId_order Integer, ObjectId Integer, Amount TFloat) ON COMMIT DROP;   -- все данные по резервам
    CREATE TEMP TABLE _tmpReserve (MovementId_order Integer, ObjectId Integer, Amount TFloat) ON COMMIT DROP;   -- данные которые не включены в другие перемещения
    CREATE TEMP TABLE tmpMI_Order (MovementId Integer, ObjectId Integer, ParentId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMI_Income (MovementId_order Integer, ObjectId Integer, Amount TFloat) ON COMMIT DROP;
    
    
    INSERT INTO tmpMI_Order (MovementId, ObjectId, ParentId, Amount)
     -- ВСЕ Заказы клиента - zc_MI_Child   -- 
       (SELECT MovementItem.MovementId
             , MovementItem.ObjectId
             , COALESCE (MovementItem.ParentId, 0) AS ParentId           --где ParentId  <> 0 это комплектующие
             --Сколько зарезервировано
             , SUM(MovementItem.Amount) AS Amount
        FROM MovementItem
             INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                AND Movement.DescId   = zc_Movement_OrderClient()
                                -- все НЕ удаленные
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
        WHERE MovementItem.DescId  = zc_MI_Child()
          AND MovementItem.isErased = FALSE
          AND COALESCE (MovementItem.Amount,0) <> 0
          AND COALESCE (MovementItem.ParentId, 0) <> 0 -- не услуги
        GROUP BY MovementItem.MovementId
               , MovementItem.ObjectId
               , COALESCE (MovementItem.ParentId, 0)
       );

   INSERT INTO tmpMI_Income (MovementId_order, ObjectId, Amount)
     -- Приходы, в которых есть Резервы под Заказ клиента
       (SELECT -- Заказ клиента
               MIFloat_MovementId.ValueData :: Integer AS MovementId_order
             , MovementItem.ObjectId
               -- Сколько зарезервировано
             , SUM (MovementItem.Amount) AS Amount
        FROM MovementItem
             -- это точно Приход от Поставщика
             INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                AND Movement.DescId   = zc_Movement_Income()
                                -- все НЕ удаленные
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
             -- заказ клиента
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id   --MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMI_Order.MovementId FROM tmpMI_Order)
                                        AND MIFloat_MovementId.DescId   = zc_MIFloat_MovementId()
        WHERE MovementItem.DescId  = zc_MI_Child()
          AND MovementItem.isErased = FALSE
          AND MovementItem.ObjectId IN (SELECT DISTINCT _tmpMI_Master.ObjectId FROM _tmpMI_Master)
       GROUP BY MIFloat_MovementId.ValueData
              , MovementItem.ObjectId
       );

     INSERT INTO _tmpReserveAll (MovementId_order, ObjectId, Amount)
     -- итого резерв Мастер
     SELECT tmpMI.MovementId AS MovementId_order
          , tmpMI.ObjectId
          , tmpMI.Amount
     FROM tmpMI_Order AS tmpMI
    UNION 
     SELECT tmpMI.MovementId_order
          , tmpMI.ObjectId
          , tmpMI.Amount
     FROM tmpMI_Income AS tmpMI
     ;

    --нужно получить перемещения , которые были  уже по этим товарам
    CREATE TEMP TABLE _tmpMI_Send (ObjectId Integer, MovementId_order Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Send (ObjectId, MovementId_order, Amount)
          SELECT MovementItem.ObjectId
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , SUM (MovementItem.Amount) AS Amount
          FROM MovementItem
               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                  AND Movement.DescId = zc_Movement_Send()
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
               INNER JOIN MovementItem AS MI_Master
                                      ON MI_Master.Id = MovementItem.ParentId
                                     AND MI_Master.isErased   = FALSE
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
          WHERE MovementItem.ObjectId IN (SELECT DISTINCT _tmpReserveAll.ObjectId FROM _tmpReserveAll)
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE
          GROUP BY MovementItem.ObjectId
                 , MIFloat_MovementId.ValueData
          ;

     --те что нужно без уже участвующих в перемещениях
     INSERT INTO _tmpReserve (MovementId_order, ObjectId, Amount)
     SELECT _tmpReserveAll.MovementId_order
          , _tmpReserveAll.ObjectId
          , (COALESCE (_tmpReserveAll.Amount,0) - COALESCE(_tmpMI_Send.Amount,0)) AS Amount
     FROM _tmpReserveAll
         LEFT JOIN _tmpMI_Send ON _tmpMI_Send.ObjectId = _tmpReserveAll.ObjectId
                              AND _tmpMI_Send.MovementId_order = _tmpReserveAll.MovementId_order
     WHERE (COALESCE (_tmpReserveAll.Amount,0) - COALESCE(_tmpMI_Send.Amount,0)) > 0
     ;
    
    
    CREATE TEMP TABLE tmpObject_PartionGoods (ObjectId Integer, EKPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
    INSERT INTO tmpObject_PartionGoods (ObjectId, EKPrice, CountForPrice)
       -- данные из партии, тк.к нам нужна цена
      (SELECT Object_PartionGoods.ObjectId
            , Object_PartionGoods.EKPrice
            , Object_PartionGoods.CountForPrice
       FROM Object_PartionGoods
       --WHERE Object_PartionGoods.ObjectId IN (SELECT DISTINCT _tmpReserve.ObjectId FROM _tmpReserve)
       );

     -- записываем  zc_MI_Master - Send
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                     := COALESCE (_tmpMI_Master.Id, 0)
                                            , inMovementId             := inMovementId
                                            , inGoodsId                := COALESCE (tmp.ObjectId, _tmpMI_Master.ObjectId)
                                              -- кол-во резерв
                                            , inAmount                 := COALESCE (tmp.Amount, _tmpMI_Master.Amount) ::TFloat
                                            , inOperPrice              := COALESCE (_tmpMI_Master.OperPrice, tmp.OperPrice) ::TFloat
                                            , inCountForPrice          := COALESCE (_tmpMI_Master.CountForPrice, tmp.CountForPrice) ::TFloat
                                            , inComment                :='' ::TVarChar
                                            , inUserId                 := vbUserId
                                             )
    FROM _tmpMI_Master
         -- привязываем существующие строки с новыми данными
         FULL JOIN (--группируем данные резерва
                    SELECT _tmpReserve.ObjectId
                         , ObjectFloat_EKPrice.ValueData AS OperPrice
                         , 1 :: TFloat AS CountForPrice
                         , SUM (COALESCE (_tmpReserve.Amount,0)) AS Amount
                    FROM _tmpReserve
                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                               ON ObjectFloat_EKPrice.ObjectId = _tmpReserve.ObjectId
                                              AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                    GROUP BY _tmpReserve.ObjectId
                           , ObjectFloat_EKPrice.ValueData
                    ) AS tmp ON tmp.ObjectId = _tmpMI_Master.objectId
    ;   

    -- обновляем данные из мастера док Перемещение
    CREATE TEMP TABLE _tmpMI_Master_New (Id Integer, ObjectId Integer) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master_New (Id, ObjectId)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
          FROM MovementItem
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

    -- записываем zc_MI_Child - Send
    PERFORM lpInsertUpdate_MI_Send_Child (ioId                     := COALESCE (_tmpMI_Child.Id, 0)
                                        , inParentId               := COALESCE (tmp.ParentId, _tmpMI_Child.ParentId)
                                        , inMovementId             := inMovementId
                                        , inMovementId_OrderClient := COALESCE (tmp.MovementId_order, _tmpMI_Child.MovementId_order)
                                        , inObjectId               := COALESCE (tmp.ObjectId, _tmpMI_Child.ObjectId)
                                          -- кол-во резерв
                                        , inAmount                 := COALESCE (tmp.Amount, _tmpMI_Child.Amount)
                                        , inUserId                 := vbUserId
                                         )
    FROM _tmpMI_Child
         -- привязываем существующие чайлды с новыми данными
         FULL JOIN (--связваем данные резерва с мастером
                    SELECT _tmpMI_Master_New.Id           AS ParentId
                         , _tmpMI_Master_New.ObjectId     AS ObjectId
                         , _tmpReserve.MovementId_order
                         , _tmpReserve.Amount  AS Amount
                    FROM _tmpMI_Master_New
                        INNER JOIN _tmpReserve ON _tmpReserve.ObjectId = _tmpMI_Master_New.ObjectId
                    ) AS tmp ON tmp.ObjectId = _tmpMI_Child.objectId
                            AND tmp.ParentId = _tmpMI_Child.ParentId
                            AND tmp.MovementId_order = _tmpMI_Child.MovementId_order
    ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.09.21         *
*/

-- тест
--