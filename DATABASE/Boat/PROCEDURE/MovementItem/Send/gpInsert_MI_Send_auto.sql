-- Function: gpInsert_MI_Send_auto()

DROP FUNCTION IF EXISTS gpInsert_MI_Send (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_Send_Child(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_Send_auto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send_auto(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
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



    -- Параметры из документа
    SELECT MovementLinkObject_From.ObjectId
         , MovementLinkObject_To.ObjectId
           INTO vbUnitId_From, vbUnitId_To
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
    WHERE Movement.Id       = inMovementId
      AND Movement.DescId   = zc_Movement_Send()
      AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
   ;

    -- zc_MI_Master - текущее Перемещение
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Ord Integer, MovementId_order Integer) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId, Ord, MovementId_order)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
                 -- № п/п
               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.Id ASC) AS Ord 
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
          FROM MovementItem
               -- ValueData - MovementId заказ Клиента
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
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


    -- данные резерв (заказ + приход) - их и будем перемещать
    CREATE TEMP TABLE _tmpReserve (MovementId_order Integer, ObjectId Integer, PartionId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReserve (MovementId_order, ObjectId, PartionId, Amount)
       WITH -- ВСЕ Резервы
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
                                                        -- элементы резерва, хотя они здесь и так
                                                        --AND MovementItem.ParentId > 0
                                 -- На всякий случай - zc_MI_Master не удален
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Child() -- !!!НЕ Ошибка!!!
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                                 -- ограничение - только для этого Склада
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                                  AND MILinkObject_Unit.ObjectId       = vbUnitId_From
                                 -- ValueData - MovementId заказа Поставщику
                                /* LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()*/
                            WHERE Movement.DescId   = zc_Movement_OrderClient()
                              -- все НЕ удаленные
                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                              -- Кол-во - попало в Резерв
                              AND MovementItem.Amount > 0
                            GROUP BY MovementItem.MovementId
                                   , MovementItem.ObjectId
                                   , MovementItem.PartionId

                           UNION ALL
                            -- Приходы от поставщика - zc_MI_Child - детализация по Резервам
                            SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                                 , MovementItem.ObjectId
                                 , MovementItem.PartionId
                                   -- Кол-во - попало в Резерв
                                 , MovementItem.Amount
                            FROM Movement
                                 -- ограничение - только приход на этот Склад
                                 INNER JOIN MovementLinkObject AS MLO_To
                                                               ON MLO_To.MovementId = Movement.Id
                                                              AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MLO_To.ObjectId   = vbUnitId_From
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                 -- zc_MI_Master не удален
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                                 -- ValueData - MovementId заказ Клиента
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                            WHERE Movement.DescId   = zc_Movement_Income()
                              -- Проведенные
                              AND Movement.StatusId = zc_Enum_Status_Complete()
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
     -- Итого резерв
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
    --RAISE EXCEPTION '%', (select count(*)  from _tmpReserve);


    -- сохраняем - zc_MI_Master - текущее Перемещение
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                     := COALESCE (_tmpMI_Master.Id, 0)
                                            , inMovementId             := inMovementId
                                            , inMovementId_OrderClient := COALESCE (tmp.MovementId_order, _tmpMI_Master.MovementId_order) :: Integer
                                            , inGoodsId                := COALESCE (tmp.ObjectId, _tmpMI_Master.ObjectId)
                                              -- кол-во резерв
                                            , inAmount                 := CASE WHEN _tmpMI_Master.ORD = 1 OR COALESCE (_tmpMI_Master.Id, 0) = 0 THEN COALESCE (tmp.Amount, 0) ELSE 0 END
                                            , inOperPrice              := COALESCE (tmp.OperPrice, 0)
                                            , inCountForPrice          := COALESCE (tmp.CountForPrice, 1)
                                            , inComment                :='' ::TVarChar
                                            , inUserId                 := vbUserId
                                             )
    FROM _tmpMI_Master
         -- привязываем существующие строки с новыми данными
         FULL JOIN (--группируем данные резерва
                    SELECT _tmpReserve.ObjectId
                           -- неправильная цена, в партиях другая
                         , ObjectFloat_EKPrice.ValueData AS OperPrice
                         , 1 :: TFloat AS CountForPrice
                         , SUM (COALESCE (_tmpReserve.Amount,0)) AS Amount
                         --заказ клиента 
                         , _tmpReserve.MovementId_order
                    FROM _tmpReserve
                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                               ON ObjectFloat_EKPrice.ObjectId = _tmpReserve.ObjectId
                                              AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                    GROUP BY _tmpReserve.ObjectId
                           , ObjectFloat_EKPrice.ValueData 
                           , _tmpReserve.MovementId_order
                    ) AS tmp ON tmp.ObjectId = _tmpMI_Master.objectId
                            AND tmp.MovementId_order = _tmpMI_Master.MovementId_order
    ;   

/*zc_MI_Child - будут формироваться при проведении док

    -- сохраняем - zc_MI_Child - текущее Перемещение
    PERFORM lpInsertUpdate_MI_Send_Child (ioId                     := COALESCE (_tmpMI_Child.Id, 0)
                                        , inParentId               := COALESCE (tmpMI_new.ParentId, _tmpMI_Child.ParentId)
                                        , inMovementId             := inMovementId
                                        , inMovementId_OrderClient := COALESCE (tmpMI_new.MovementId_order, _tmpMI_Child.MovementId_order) :: Integer
                                        , inObjectId               := COALESCE (tmpMI_new.ObjectId, _tmpMI_Child.ObjectId)    :: Integer
                                        , inPartionId              := COALESCE (tmpMI_new.PartionId, _tmpMI_Child.PartionId)  :: Integer
                                          -- кол-во резерв
                                        , inAmount                 := COALESCE (tmpMI_new.Amount, 0)
                                        , inUserId                 := vbUserId
                                         )
    FROM _tmpMI_Child
         -- Новые элементы
         FULL JOIN (-- новый мастер
                    WITH tmpMI_Master AS (SELECT MovementItem.Id
                                               , MovementItem.ObjectId
                                                 -- № п/п
                                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                                          FROM MovementItem
                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                         )
                    -- определили мастер
                    SELECT tmpMI_Master.Id           AS ParentId
                         , tmpMI_Master.ObjectId     AS ObjectId
                            --
                         , _tmpReserve.PartionId
                         , _tmpReserve.MovementId_order
                         , CASE WHEN tmpMI_Master.Ord = 1 THEN _tmpReserve.Amount ELSE 0 END AS Amount
                    FROM tmpMI_Master
                         LEFT JOIN _tmpReserve ON _tmpReserve.ObjectId      = tmpMI_Master.ObjectId
                    ) AS tmpMI_new ON tmpMI_new.PartionId        = _tmpMI_Child.PartionId
                                  AND tmpMI_new.ParentId         = _tmpMI_Child.ParentId
                                  AND tmpMI_new.MovementId_order = _tmpMI_Child.MovementId_order
    ;

*/


    -- удаление zc_MI_Master кол-во = 0
    PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
      AND MovementItem.Amount     = 0
   ;
    -- test!!!
/*
    PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Child()
      AND MovementItem.isErased   = FALSE
   ;
   */

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.09.21         *
*/

-- тест
-- SELECT * FROM gpInsert_MI_Send_auto (inMovementId:= 589, inSession:= '5');
