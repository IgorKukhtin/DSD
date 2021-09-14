-- Function: gpInsert_MI_Send_Child()

DROP FUNCTION IF EXISTS gpInsert_MI_Send_Child(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send_Child(
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
  /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Child())
    THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Строки документа уже заполнены' :: TVarChar
                                               , inProcedureName := 'gpInsert_MI_Send_Child'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;*/




    -- данные из мастера док Перемещение
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
          FROM MovementItem
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
    CREATE TEMP TABLE _tmpReserve (MovementId_order Integer, ObjectId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReserve (MovementId_order, ObjectId, Amount)
    WITH
     -- ВСЕ Заказы клиента - zc_MI_Child
    tmpMI_Order AS (SELECT MovementItem.MovementId
                         , MovementItem.ObjectId
                         --Сколько зарезервировано
                         , SUM(MovementItem.Amount) AS Amount
                    FROM MovementItem
                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                            AND Movement.DescId   = zc_Movement_OrderClient()
                                            -- все НЕ удаленные
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                         -- ValueData - MovementId заказа Поставщику
                        /* LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                     ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()*/
                    WHERE MovementItem.ObjectId IN (SELECT DISTINCT _tmpMI_Master.ObjectId FROM _tmpMI_Master)
                      AND MovementItem.DescId  = zc_MI_Child()
                      AND MovementItem.isErased = FALSE
                      AND COALESCE (MovementItem.Amount,0) <> 0
                      -- если заказ Поставщику был сформирован
                      --AND MIFloat_MovementId.ValueData > 0
                    GROUP BY  MovementItem.MovementId
                         , MovementItem.ObjectId
                   )
     -- Приходы, в которых есть Резервы под Заказ клиента
  , tmpMI_Income AS (SELECT -- Заказ клиента
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
                     )
     -- итого резерв
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
        
    -- создаем zc_MI_Child - Send
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
                    SELECT _tmpMI_Master.Id           AS ParentId
                         , _tmpMI_Master.ObjectId     AS ObjectId
                         , _tmpReserve.MovementId_order
                         , _tmpReserve.Amount  AS Amount
                    FROM _tmpMI_Master
                        INNER JOIN _tmpReserve ON _tmpReserve.ObjectId = _tmpMI_Master.ObjectId
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