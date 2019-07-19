DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Price               TFloat
             , MCS                 TFloat
             , Amount_calc_real    TFloat
             , Amount_calc         TFloat
             , AmountResult_summ   TFloat
             , AmountResult        TFloat
             , AmountRemains       TFloat
             , AmountIncome        TFloat
             , AmountSend          TFloat
             , AmountOrderExternal TFloat
             , AmountReserve       TFloat
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbDate_6   TDateTime;
   DECLARE vbDate_1   TDateTime;
   DECLARE vbDate_0   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;

     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- все Подразделения для схемы SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_SUN (UnitId)
        SELECT ObjectBoolean_SUN.ObjectId FROM ObjectBoolean AS ObjectBoolean_SUN WHERE ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN();


     -- все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     --
     WITH -- приход - UnComplete - за последние +/-7 дней для Date_Branch
          tmpMI_Income AS (SELECT MovementLinkObject_To.ObjectId AS UnitId
                                , MovementItem.ObjectId          AS GoodsId
                                , SUM (MovementItem.Amount)      AS Amount
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_Branch
                                                        ON MovementDate_Branch.MovementId = Movement.Id
                                                       AND MovementDate_Branch.DescId     = zc_MovementDate_Branch()
                                                       -- AND MovementDate_Branch.ValueData >= CURRENT_DATE
                                                       AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '7 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                -- !!!только для таких Аптек!!!
                                INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                           WHERE Movement.DescId   = zc_Movement_Income()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementLinkObject_To.ObjectId, MovementItem.ObjectId
                           HAVING SUM (MovementItem.Amount) <> 0
                          )
          -- перемещения - UnComplete - за последние +/-30 дней
        , tmpMI_Send AS (SELECT MovementLinkObject_To.ObjectId AS UnitId
                              , MovementItem.ObjectId          AS GoodsId
                              , SUM (MovementItem.Amount)      AS Amount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                 -- !!!только для таких Аптек!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                 -- закомментил - пусть будут все перемещения, не только Авто
                                 /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                            ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                           AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                           AND MovementBoolean_isAuto.ValueData  = TRUE*/
                                 /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                                 INNER JOIN MovementItem AS MovementItem
                                                         ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                            WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                           -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                            GROUP BY MovementLinkObject_To.ObjectId, MovementItem.ObjectId
                            HAVING SUM (MovementItem.Amount) <> 0
                           )
          -- заказы - UnComplete - !ВСЕ! Deferred
        , tmpMI_OrderExternal AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                                       , MovementItem.ObjectId            AS GoodsId
                                       , SUM (MovementItem.Amount)        AS Amount
                                  FROM Movement
                                       INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                 AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()
                                                                 AND MovementBoolean_Deferred.ValueData  = TRUE
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_To()
                                       -- !!!только для таких Аптек!!!
                                       INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId     = zc_MI_Master()
                                                              AND MovementItem.isErased   = FALSE
     
                                  WHERE Movement.DescId   = zc_Movement_OrderExternal()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  GROUP BY MovementLinkObject_Unit.ObjectId, MovementItem.ObjectId
                                  HAVING SUM (MovementItem.Amount) <> 0
                                 )
          -- отложенные Чеки + не проведенные с CommentError
        , tmpMovementCheck AS (SELECT Movement.Id AS MovementId, MovementLinkObject_Unit.ObjectId AS UnitId
                               FROM MovementBoolean AS MovementBoolean_Deferred
                                    INNER JOIN Movement ON Movement.Id       = MovementBoolean_Deferred.MovementId
                                                       AND Movement.DescId   = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    -- !!!только для таких Аптек!!!
                                    INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                               WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                 AND MovementBoolean_Deferred.ValueData = TRUE
                              UNION
                               SELECT Movement.Id AS MovementId, MovementLinkObject_Unit.ObjectId AS UnitId
                               FROM MovementString AS MovementString_CommentError
                                    INNER JOIN Movement ON Movement.Id       = MovementString_CommentError.MovementId
                                                       AND Movement.DescId   = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    -- !!!только для таких Аптек!!!
                                    INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                               WHERE MovementString_CommentError.DescId    = zc_MovementString_CommentError()
                                 AND MovementString_CommentError.ValueData <> ''
                              )
          -- отложенные Чеки + не проведенные с CommentError
        , tmpMI_Reserve AS (SELECT tmpMovementCheck.UnitId
                                 , MovementItem.ObjectId     AS GoodsId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM tmpMovementCheck
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementCheck.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                            GROUP BY tmpMovementCheck.UnitId, MovementItem.ObjectId
                           )
          -- остатки
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!только для таких Аптек!!!
                              INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = Container.WhereObjectId
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- цены
        , tmpPrice AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price 
                            , MCS_Value.ValueData               AS MCSValue
                            , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                   THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END 
                                   ELSE 0
                              END AS MCSValue_min
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!только для таких Аптек!!!
                            INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId
                            LEFT JOIN ObjectBoolean AS MCS_isClose
                                                    ON MCS_isClose.ObjectId = OL_Price_Unit.ObjectId
                                                   AND MCS_isClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN Object AS Object_Goods
                                              ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                             AND Object_Goods.isErased = FALSE
                            LEFT JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                                  ON Price_MCSValueMin.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
                      )
          -- данные из ассорт. матрицы
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!только для таких Аптек!!!
                                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                          ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                   -- выходим на товар сети
                                   INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                         ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                        AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                   INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                         ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                        AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                         ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                        AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                        AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                               WHERE Object_GoodsCategory.DescId   = zc_Object_GoodsCategory()
                                 AND Object_GoodsCategory.isErased = FALSE
                               )
          -- подменяем НТЗ на значение из ассорт. матрицы, если в ассотр. матрице значение больше
        , tmpObject_Price AS (SELECT COALESCE (tmpPrice.UnitId,  tmpGoodsCategory.UnitId)  AS UnitId
                                   , COALESCE (tmpPrice.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                                   , COALESCE (tmpPrice.Price, 0)                :: TFloat AS Price
                                   , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0) <= COALESCE (tmpPrice.MCSValue, 0) 
                                          THEN COALESCE (tmpPrice.MCSValue,0) 
                                          ELSE tmpGoodsCategory.Value
                                     END                                         :: TFloat AS MCSValue
                                   , COALESCE (tmpPrice.MCSValue_min, 0)         :: TFloat AS MCSValue_min
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                             )
 
     -- 1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend, AmountOrderExternal, AmountReserve)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , CASE -- если НТЗ_МИН = 0 ИЛИ ост <= НТЗ_МИН
                    WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                         THEN CASE -- для такого НТЗ
                                   WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                   -- и 1 >= НТЗ - остаток - "отложено" - "перемещ" - "приход" - "заявка"
                                    AND 1 >= ROUND (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                        THEN -- округляем ВВЕРХ
                                             CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                   -- для такого НТЗ
                                   WHEN tmpObject_Price.MCSValue >= 10
                                   -- и 1 >= НТЗ - остаток - "отложено" - "перемещ" - "приход" - "заявка"
                                    AND 1 >= CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                        THEN -- округляем
                                             ROUND  (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                   ELSE -- округляем ВВНИЗ
                                        FLOOR (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                              END 
                    ELSE 0
               END AS AmountResult
             , COALESCE (tmpRemains.Amount, 0)          AS AmountRemains
             , COALESCE (tmpMI_Income.Amount, 0)        AS AmountIncome
             , COALESCE (tmpMI_Send.Amount, 0)          AS AmountSend
             , COALESCE (tmpMI_OrderExternal.Amount,0)  AS AmountOrderExternal
             , COALESCE (tmpMI_Reserve.Amount, 0)       AS AmountReserve
        FROM tmpObject_Price
             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = tmpObject_Price.UnitId
                                 AND tmpRemains.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Income ON tmpMI_Income.UnitId  = tmpObject_Price.UnitId
                                   AND tmpMI_Income.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Send ON tmpMI_Send.UnitId  = tmpObject_Price.UnitId
                                 AND tmpMI_Send.GoodsId = tmpObject_Price.GoodsId
             LEFT OUTER JOIN tmpMI_OrderExternal ON tmpMI_OrderExternal.UnitId  = tmpObject_Price.UnitId
                                                AND tmpMI_OrderExternal.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Reserve ON tmpMI_Reserve.UnitId  = tmpObject_Price.UnitId
                                    AND tmpMI_Reserve.GoodsId = tmpObject_Price.GoodsId
             -- отбросили !!закрытые!!
             INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = tmpObject_Price.GoodsId
                                         AND Object_Goods_View.IsClose = FALSE
        WHERE CASE -- если НТЗ_МИН = 0 ИЛИ ост <= НТЗ_МИН
                   WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                        THEN CASE -- для такого НТЗ
                                  WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                  -- и 1 >= НТЗ - остаток - "отложено" - "перемещ" - "приход" - "заявка"
                                   AND 1 >= ROUND (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- округляем ВВЕРХ
                                            CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  -- для такого НТЗ
                                  WHEN tmpObject_Price.MCSValue >= 10
                                  -- и 1 >= НТЗ - остаток - "отложено" - "перемещ" - "приход" - "заявка"
                                   AND 1 >= CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- округляем
                                            ROUND  (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  ELSE -- округляем ВВНИЗ
                                       FLOOR (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                             END 
                   ELSE 0
              END > 0
       ;


    -- дата + 6 месяцев
    vbDate_6:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- дата + 1 месяц
    vbDate_1:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- дата + 0 месяцев
    vbDate_0:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


     -- 2. все остатки, СРОК
     CREATE TEMP TABLE _tmpRemains_Partion (UnitId Integer, GoodsId Integer, Amount TFloat, Amount_real TFloat) ON COMMIT DROP;
     --
     WITH tmpRemains AS (SELECT CLO_Unit.ObjectId                                          AS UnitId
                              , Container.ParentId                                         AS ContainerId_Parent
                              , Container.ObjectId                                         AS GoodsId
                              , SUM (Container.Amount)                                     AS Amount
                              , CASE WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_0
                                          THEN zc_Enum_PartionDateKind_0()
                                     WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_0 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_1
                                          THEN zc_Enum_PartionDateKind_1()
                                     WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_1 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_6
                                          THEN zc_Enum_PartionDateKind_6()
                                     ELSE 0
                                END                                                        AS PartionDateKindId
                              , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())   AS ExpirationDate
                         FROM Container
                              INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                             ON CLO_Unit.ContainerId = Container.Id
                                                            AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                              -- !!!только для таких Аптек!!!
                              INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = CLO_Unit.ObjectId
                              
                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods 
                                                            ON CLO_PartionGoods.ContainerId = Container.Id
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                              LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                   ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                  AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

                         WHERE Container.DescId = zc_Container_CountPartionDate()
                           AND Container.Amount > 0
                           AND ObjectDate_PartionGoods_Value.ValueData > vbDate_1
                         GROUP BY CLO_Unit.ObjectId
                                , Container.ParentId
                                , Container.ObjectId
                                , CASE WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_0
                                            THEN zc_Enum_PartionDateKind_0()
                                       WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_0 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_1
                                            THEN zc_Enum_PartionDateKind_1()
                                       WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_1 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_6
                                            THEN zc_Enum_PartionDateKind_6()
                                       ELSE 0
                                  END
                                , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())
                        )
          , tmpRemains_gr AS (SELECT DISTINCT tmpRemains.UnitId, tmpRemains.GoodsId, tmpRemains.ContainerId_Parent FROM tmpRemains
                             )
          , tmpRemains_real AS (SELECT tmpRemains_gr.UnitId, tmpRemains_gr.GoodsId, SUM (Container.Amount) AS Amount
                                FROM tmpRemains_gr
                                     JOIN Container ON Container.Id = tmpRemains_gr.ContainerId_Parent
                                GROUP BY tmpRemains_gr.UnitId, tmpRemains_gr.GoodsId
                               )
       -- Результат: все остатки, СРОК
       INSERT INTO _tmpRemains_Partion (UnitId, GoodsId, Amount, Amount_real)
          SELECT tmp.UnitId
               , tmp.GoodsId
               , tmp.Amount
               , tmpRemains_real.Amount AS Amount_real
          FROM (SELECT tmpRemains.UnitId, tmpRemains.GoodsId, SUM (tmpRemains.Amount) AS Amount FROM tmpRemains GROUP BY tmpRemains.UnitId, tmpRemains.GoodsId
               ) AS tmp
               LEFT JOIN tmpRemains_real ON tmpRemains_real.UnitId  = tmp.UnitId
                                        AND tmpRemains_real.GoodsId = tmp.GoodsId
          WHERE tmp.Amount >= 1
            -- AND tmp.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_6())
          ;


     -- Результат
     RETURN QUERY
       SELECT Object_Unit.Id          AS UnitId
            , Object_Unit.ValueData   AS UnitName
            , Object_Goods.Id         AS GoodsId
            , Object_Goods.ObjectCode AS GoodsCode
            , Object_Goods.ValueData  AS GoodsName
            , _tmpRemains.Price
            , _tmpRemains.MCS
              -- итого сроковых по реальным остаткам, должно сходиться с Amount_calc
            , tmpRemains_Partion_all.Amount_real :: TFloat AS Amount_calc_real
              -- итого сроковых которые будем распределять
            , tmpRemains_Partion_all.Amount      :: TFloat AS Amount_calc
            , tmpRemains_all.AmountResult        :: TFloat AS AmountResult_summ
            , _tmpRemains.AmountResult
            , _tmpRemains.AmountRemains
            , _tmpRemains.AmountIncome
            , _tmpRemains.AmountSend
            , _tmpRemains.AmountOrderExternal
            , _tmpRemains.AmountReserve
       FROM _tmpRemains
            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains.UnitId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains.GoodsId
            INNER JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount) AS Amount, SUM (_tmpRemains_Partion.Amount_real) AS Amount_real
                        FROM _tmpRemains_Partion GROUP BY _tmpRemains_Partion.GoodsId
                        ) AS tmpRemains_Partion_all ON tmpRemains_Partion_all.GoodsId = _tmpRemains.GoodsId
            LEFT JOIN (SELECT _tmpRemains.GoodsId, SUM (_tmpRemains.AmountResult) AS AmountResult
                       FROM _tmpRemains GROUP BY _tmpRemains.GoodsId
                       ) AS tmpRemains_all ON tmpRemains_all.GoodsId = _tmpRemains.GoodsId

       -- ORDER BY Object_Goods.ObjectCode, Object_Unit.ValueData
       ORDER BY Object_Goods.ValueData, Object_Unit.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ObjectCode
      ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.19                                        *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE - INTERVAL '0 DAY', inSession:= '3') -- WHERE Amount_calc < AmountResult_summ