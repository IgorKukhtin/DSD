-- Function: gpInsert_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternalPromoChild (Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderInternalPromoChild(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitCodeList        TBlob     , -- Перечень аптек для дораспределения
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbMiddleDate TDateTime;
   DECLARE vbDays TFloat;
   DECLARE vbIndex Integer;
   DECLARE vbAmountDist Integer;
   DECLARE vbUnitId Integer;
   DECLARE curDistribution refcursor;
   DECLARE vbId Integer;
   DECLARE vbAmount Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

     SELECT (MovementDate_StartSale.ValueData - INTERVAL '1 DAY')
          , (Movement.OperDate + INTERVAL '1 DAY')
          , MovementLinkObject_Retail.ObjectId AS RetailId
          , DATE_PART ( 'day', ((Movement.OperDate - MovementDate_StartSale.ValueData)+ INTERVAL '1 DAY'))
    INTO vbStartDate, vbEndDate, vbRetailId, vbDays
     FROM Movement
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
     WHERE Movement.Id = inMovementId;
     
     vbMiddleDate := vbStartDate + (DATE_PART ( 'day', ((vbEndDate - vbStartDate) / 2))||' DAY')::Interval;

    -- Cуществующие чайлд
     CREATE TEMP TABLE tmpMI_Child (Id Integer, ParentId Integer, UnitId Integer, AmountManual TFloat) ON COMMIT DROP;
       INSERT INTO tmpMI_Child (Id, ParentId, UnitId, AmountManual)
       SELECT MovementItem.Id
            , MovementItem.ParentId
            , MovementItem.ObjectId AS UnitId
            , COALESCE (MIFloat_AmountManual.ValueData,0) AS AmountManual
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Child();
          
     ANALYSE tmpMI_Child;

     -- снимаем удаление со строк чайлд
     UPDATE MovementItem
     SET isErased = FALSE, Amount = 0
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child();

    CREATE TEMP TABLE tmpData (Id Integer, ParentId Integer, UnitId Integer, AmountOut TFloat, Remains TFloat, AmountIn TFloat, AmountManual TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpDataAddToM (Id Integer, ParentId Integer, UnitId Integer, GoodsId Integer, Amount TFloat, Remains TFloat) ON COMMIT DROP;

          -- Дополнение по аптекам согласно M
          INSERT INTO tmpDataAddToM (Id, ParentId, UnitId, GoodsId, Amount, Remains)
          WITH
               -- строки мастера с кол-вом для распределения
               tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId    AS GoodsId
                                     , MIFloat_AddToM.ValueData AS Amount
                                FROM MovementItem
                                     LEFT JOIN MovementItemBoolean AS MIBoolean_Complement
                                                                   ON MIBoolean_Complement.MovementItemId = MovementItem.Id
                                                                  AND MIBoolean_Complement.DescId = zc_MIBoolean_Complement()
                                     LEFT JOIN MovementItemFloat AS MIFloat_AddToM
                                                                 ON MIFloat_AddToM.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AddToM.DescId = zc_MIFloat_AmountAdd()
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND COALESCE ( MIFloat_AddToM.ValueData,0) > 0
                                  AND MovementItem.isErased = FALSE
                                  AND COALESCE (MIBoolean_Complement.ValueData, False) = False
                                )

             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                                INNER JOIN ObjectBoolean AS ObjectBoolean_OrderPromo
                                                         ON ObjectBoolean_OrderPromo.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                                        AND ObjectBoolean_OrderPromo.DescId = zc_ObjectBoolean_Unit_OrderPromo()
                                                        AND COALESCE (ObjectBoolean_OrderPromo.ValueData, FALSE) = TRUE
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- продажи
             , tmpContainer AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                                     , MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount * CASE WHEN MIContainer.OperDate > vbMiddleDate THEN 0.5 ELSE 1.0 END, 0)) AS Amount
                                     FROM MovementItemContainer AS MIContainer
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                          INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = MIContainer.ObjectId_analyzer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_Check()
                                       AND MIContainer.OperDate > vbStartDate AND MIContainer.OperDate < vbEndDate
                                     GROUP BY MIContainer.ObjectId_analyzer
                                            , MIContainer.WhereObjectId_analyzer
                                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                     )
              -- остатки
             , tmpRemains AS (SELECT tmp.UnitId
                                   , tmp.GoodsId
                                   , SUM (tmp.Amount) AS Amount
                              FROM  (SELECT Container.WhereObjectId AS UnitId
                                          , Container.ObjectId      AS GoodsId
                                          , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) AS Amount
                                     FROM Container
                                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                         INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Container.ObjectId
                                         LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                              AND MovementItemContainer.Operdate >= vbEndDate
                                     WHERE Container.DescId = zc_Container_Count()
                                     GROUP BY Container.WhereObjectId
                                            , Container.ObjectId
                                            , Container.Amount
                                     HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                     ) AS tmp
                              GROUP BY tmp.UnitId
                                     , tmp.GoodsId
                              )

         -- результат
         SELECT tmpMI_Child.Id                                              AS Id
              , tmpMI_Master.Id                                             AS ParentId
              , tmpUnit.UnitId                                              AS UnitId
              , tmpMI_Master.GoodsId                                        AS GoodsId
              , CEIL(tmpMI_Master.Amount - COALESCE (tmpRemains.Amount, 0)) AS AmountIn
              , COALESCE (tmpRemains.Amount, 0)                             AS Remains
         FROM tmpMI_Master
              LEFT JOIN tmpUnit ON 1=1
              LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                  AND tmpRemains.UnitId = tmpUnit.UnitId
              LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                    AND tmpContainer.UnitId = tmpUnit.UnitId
              LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                                   AND tmpMI_Child.UnitId = tmpUnit.UnitId
         WHERE COALESCE (tmpMI_Child.AmountManual, 0) = 0
           AND CEIL(tmpMI_Master.Amount - COALESCE (tmpRemains.Amount, 0)) > 0
         ;
         
         ANALYSE tmpDataAddToM;


          -- Распределение по аптекам
          INSERT INTO tmpData (Id, ParentId, UnitId, AmountOut, Remains, AmountIn, AmountManual)
          WITH
               -- строки мастера с кол-вом для распределения
               tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId AS GoodsId
                                     , (MovementItem.Amount - COALESCE (tmpChild.AmountManual, 0) - COALESCE (tmpDataIn.AmountIn, 0)) AS Amount
                                FROM MovementItem
                                     LEFT JOIN (SELECT tmpMI_Child.ParentId
                                                     , SUM (tmpMI_Child.AmountManual) AS AmountManual
                                               FROM tmpMI_Child
                                               WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
                                               GROUP BY tmpMI_Child.ParentId
                                               ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                                     LEFT JOIN (SELECT tmpDataAddToM.ParentId
                                                     , SUM (tmpDataAddToM.Amount) AS AmountIn
                                               FROM tmpDataAddToM
                                               WHERE COALESCE (tmpDataAddToM.Amount, 0) <> 0
                                               GROUP BY tmpDataAddToM.ParentId
                                               ) AS tmpDataIn ON tmpDataIn.ParentId = MovementItem.Id
                                     LEFT JOIN MovementItemBoolean AS MIBoolean_Complement
                                                                   ON MIBoolean_Complement.MovementItemId = MovementItem.Id
                                                                  AND MIBoolean_Complement.DescId = zc_MIBoolean_Complement()
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND COALESCE (MovementItem.Amount,0) <> 0
                                  AND MovementItem.isErased = FALSE
                                  AND COALESCE (MIBoolean_Complement.ValueData, False) = False
                                )

             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                                INNER JOIN ObjectBoolean AS ObjectBoolean_OrderPromo
                                                         ON ObjectBoolean_OrderPromo.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                                        AND ObjectBoolean_OrderPromo.DescId = zc_ObjectBoolean_Unit_OrderPromo()
                                                        AND COALESCE (ObjectBoolean_OrderPromo.ValueData, FALSE) = TRUE
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- продажи
             , tmpContainer AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                                     , MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount * CASE WHEN MIContainer.OperDate > vbMiddleDate THEN 0.5 ELSE 1.0 END, 0)) AS Amount
                                     FROM MovementItemContainer AS MIContainer
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                          INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = MIContainer.ObjectId_analyzer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_Check()
                                       AND MIContainer.OperDate > vbStartDate AND MIContainer.OperDate < vbEndDate
                                     GROUP BY MIContainer.ObjectId_analyzer
                                            , MIContainer.WhereObjectId_analyzer
                                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                     )
              -- остатки
             , tmpRemains AS (SELECT tmp.UnitId
                                   , tmp.GoodsId
                                   , SUM (tmp.Amount) AS Amount
                              FROM  (SELECT Container.WhereObjectId AS UnitId
                                          , Container.ObjectId      AS GoodsId
                                          , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) AS Amount
                                     FROM Container
                                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                         INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Container.ObjectId
                                         LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                              AND MovementItemContainer.Operdate >= vbEndDate
                                     WHERE Container.DescId = zc_Container_Count()
                                     GROUP BY Container.WhereObjectId
                                            , Container.ObjectId
                                            , Container.Amount
                                     HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                     UNION ALL
                                     SELECT tmpDataAddToM.UnitId
                                          , tmpDataAddToM.GoodsId
                                          , tmpDataAddToM.Amount
                                     FROM tmpDataAddToM
                                     ) AS tmp
                              GROUP BY tmp.UnitId
                                     , tmp.GoodsId
                              )

             , tmpData_D AS
                              (SELECT COALESCE (tmpMI_Child.Id,0) AS Id
                                    , tmpMI_Master.Id             AS ParentId
                                    , tmpUnit.UnitId              AS UnitId
                                    , tmpContainer.Amount         AS AmountOut_real
                                    , COALESCE (tmpRemains.Amount,0) AS Remains
                                    , tmpMI_Master.Amount         AS Amount_Master
                                    , COALESCE (tmpMI_Child.AmountManual, 0) AS AmountManual
                               FROM tmpMI_Master
                                    LEFT JOIN tmpUnit ON 1=1
                                    LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                                        AND tmpRemains.UnitId = tmpUnit.UnitId
                                    LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                                          AND tmpContainer.UnitId = tmpUnit.UnitId
                                    LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                                                         AND tmpMI_Child.UnitId = tmpUnit.UnitId
                               WHERE COALESCE (tmpContainer.Amount,0) > 0
                               )
             , tmpData_all AS
                              (SELECT tmpData_D.Id
                                    , tmpData_D.ParentId
                                    , tmpData_D.UnitId
                                    , tmpData_D.AmountOut_real
                                    , tmpData_D.Remains
                                    , tmpData_D.Amount_Master
                                    , COALESCE (tmpData_D.AmountManual, 0) AS AmountManual
                               FROM tmpData_D
                               WHERE COALESCE (tmpData_D.AmountManual, 0) = 0
                               )

             -- расчет кол-ва дней остатка
             , tmpRemainsDay AS (SELECT tmpMI_Master.Id
                                      , CASE WHEN COALESCE (tmpChild.AmountOut_real,0) <> 0 AND COALESCE (vbDays,0) <> 0
                                             THEN (COALESCE (tmpChild.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpChild.AmountOut_real,0) / vbDays)
                                             ELSE 0
                                        END AS RemainsDay
                                 FROM tmpMI_Master
                                      LEFT JOIN (SELECT tmpData_all.ParentId
                                                      , SUM (COALESCE (tmpData_all.Remains,0))        AS Remains
                                                      , SUM (COALESCE (tmpData_all.AmountOut_real,0)) AS AmountOut_real
                                                 FROM tmpData_D AS tmpData_all
                                                 GROUP BY tmpData_all.ParentId
                                                 ) AS tmpChild ON tmpChild.ParentId = tmpMI_Master.Id
                                )

            -- расчет коэфф.
             , tmpMI_Child_Calc AS (SELECT tmpMI_Child.*
                                         , (((tmpMI_Child.AmountOut_real / vbDays) * tmpRemainsDay.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpRemainsDay.RemainsDay) :: TFloat AS Koeff
                                    FROM tmpData_all AS tmpMI_Child
                                         LEFT JOIN tmpRemainsDay ON tmpRemainsDay.Id = tmpMI_Child.ParentId
                                   )
             -- Пересчитывает кол-во дней остатка без аптек с отриц. коэфф.
             , tmpRemainsDay2 AS (SELECT tmpMI_Master.Id
                                      , CASE WHEN (COALESCE (tmpChild.AmountOut_real,0) / vbDays) <> 0
                                             THEN (COALESCE (tmpChild.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpChild.AmountOut_real,0) / vbDays)
                                             ELSE 0
                                        END AS RemainsDay
                                  FROM tmpMI_Master
                                      LEFT JOIN (SELECT MovementItem.ParentId
                                                      , SUM (COALESCE (MovementItem.Remains,0))        AS Remains
                                                      , SUM (COALESCE (MovementItem.AmountOut_real,0)) AS AmountOut_real
                                                 FROM tmpMI_Child_Calc AS MovementItem
                                                 WHERE COALESCE (MovementItem.Koeff,0) > 0
                                                 GROUP BY MovementItem.ParentId
                                                 ) AS tmpChild ON tmpChild.ParentId = tmpMI_Master.Id
                                 )
-----------------------------------------------------------------------------------------------------------------------

             , tmpData AS (SELECT COALESCE (tmpData_all.Id,0) AS Id
                                , tmpData_all.ParentId
                                , tmpData_all.UnitId
                                , tmpData_all.AmountOut_real
                                , (((tmpData_all.AmountOut_real /vbDays )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) AS AmountOut
                                , tmpData_all.Remains
                                , tmpData_all.Amount_Master
                                , SUM (((tmpData_all.AmountOut_real /vbDays )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) OVER (PARTITION BY tmpData_all.ParentId) AS AmountOutSUM
                                , COALESCE (tmpData_all.AmountManual,0) AS AmountManual
                           FROM tmpMI_Child_Calc AS tmpData_all
                                LEFT JOIN tmpRemainsDay2 ON tmpRemainsDay2.Id = tmpData_all.ParentId
                           WHERE COALESCE (tmpData_all.Koeff,0) > 0
                             AND (((tmpData_all.AmountOut_real /vbDays )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) > 0
                           )


             , tmpData1 AS (SELECT tmpData.Id
                                  , tmpData.ParentId
                                  , tmpData.UnitId
                                  , tmpData.AmountManual
                                  , tmpData.AmountOut
                                  , tmpData.AmountOut_real
                                  , tmpData.Remains
                                  , CASE WHEN tmpData.AmountOutSUM <> 0
                                         THEN ROUND ( tmpData.Amount_Master / tmpData.AmountOutSUM * tmpData.AmountOut, 0)
                                         ELSE 0
                                    END   AS Amount_Calc
                            FROM tmpData
                            )

              -- вспомогательные расчеты для распределения заказа
             , tmpData111 AS (SELECT tmpMI_Master.GoodsId
                                   , tmpData1.UnitId
                                   , tmpData1.Id
                                   , tmpMI_Master.Amount          AS Amount_Master
                                   , tmpMI_Master.Id              AS ParentId
                                   , tmpData1.AmountManual
                                   , tmpData1.Amount_Calc
                                   , tmpData1.AmountOut
                                   , tmpData1.AmountOut_real
                                   , tmpData1.Remains
                                   , SUM (tmpData1.Amount_Calc) OVER (PARTITION BY tmpData1.ParentId ORDER BY tmpData1.AmountOut, tmpMI_Master.Id) AS Amount_CalcSUM
                                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.GoodsId/*, tmpMI_Master.Id*/ ORDER BY tmpData1.AmountOut DESC) AS DOrd
                              FROM tmpMI_Master
                                   INNER JOIN tmpData1 AS tmpData1 ON tmpData1.ParentId = tmpMI_Master.Id
                              )
             -- непосредственно распределение
             , tmpCalc AS (SELECT DD.Id
                                , DD.ParentId
                                , DD.UnitId
                                , DD.AmountOut_real AS AmountOut
                                , DD.Remains
                                , CASE WHEN DD.Amount_Master - DD.Amount_CalcSUM > 0 AND DD.DOrd <> 1
                                            THEN ceil (DD.Amount_Calc)                                           ---ceil
                                       ELSE ceil ( DD.Amount_Master - DD.Amount_CalcSUM + DD.Amount_Calc)
                                  END AS AmountIn
                                , 0 :: TFloat AS AmountManual
                           FROM tmpData111 AS DD
                           WHERE DD.Amount_Master - (DD.Amount_CalcSUM - DD.Amount_Calc) > 0
                          )

             , tmpDD AS (SELECT COALESCE (DD.Id, tmpDataAddToM.Id)                                  AS Id
                              , COALESCE (DD.ParentId, tmpDataAddToM.ParentId)                      AS ParentId
                              , COALESCE (DD.UnitId, tmpDataAddToM.UnitId)                          AS UnitId
                              , DD.AmountOut_real                                                   AS AmountOut
                              , COALESCE (tmpDataAddToM.Remains, DD.Remains)                        AS Remains
                              , COALESCE (tmpCalc.AmountIn, 0) + COALESCE (tmpDataAddToM.Amount, 0) AS AmountIn
                              , DD.AmountManual :: TFloat
                         FROM tmpData_all AS DD
                              FULL JOIN tmpDataAddToM ON COALESCE(tmpDataAddToM.Id, 0) = COALESCE(DD.Id, 0)
                                                     AND tmpDataAddToM.ParentId = DD.ParentId
                                                     AND tmpDataAddToM.UnitId = DD.UnitId
                              LEFT JOIN tmpCalc ON COALESCE(tmpCalc.Id, 0) = COALESCE (DD.Id, tmpDataAddToM.Id, 0)
                                               AND tmpCalc.ParentId = COALESCE (DD.ParentId, tmpDataAddToM.ParentId)
                                               AND tmpCalc.UnitId = COALESCE (DD.UnitId, tmpDataAddToM.UnitId)

                          )

         -- результат
         SELECT DD.Id
              , DD.ParentId
              , DD.UnitId
              , DD.AmountOUT
              , DD.Remains
              , DD.AmountIn
              , DD.AmountManual :: TFloat
         FROM (SELECT DD.Id
                    , DD.ParentId
                    , DD.UnitId
                    , DD.AmountOut
                    , DD.Remains
                    , DD.AmountIn
                    , DD.AmountManual
               FROM tmpDD AS DD
               UNION ALL
               SELECT tmpMI_Child.Id
                    , tmpMI_Child.ParentId
                    , tmpMI_Child.UnitId
                    , tmpContainer.Amount         --AS AmountOut_real
                    , tmpRemains.Amount           AS Remains
                    , 0 AS AmountIn
                    , COALESCE (tmpMI_Child.AmountManual, 0) AS AmountManual
               FROM tmpMI_Child
                    LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId

                    LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                        AND tmpRemains.UnitId = tmpMI_Child.UnitId

                    LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                          AND tmpContainer.UnitId = tmpMI_Child.UnitId
                                          
                    LEFT JOIN tmpDD ON COALESCE(tmpDD.Id, 0) = tmpMI_Child.Id
                                   AND tmpDD.ParentId = tmpMI_Child.ParentId
                                   AND tmpDD.UnitId = tmpMI_Child.UnitId

               WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
                 AND COALESCE (tmpDD.ParentId, 0) = 0
               ) AS DD;
               
         ANALYSE tmpData;

          -- Дополнение по аптекам согласно N
          INSERT INTO tmpData (Id, ParentId, UnitId, AmountOut, Remains, AmountIn, AmountManual)
          WITH
               -- строки мастера с кол-вом для распределения
               tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId AS GoodsId
                                     , MovementItem.Amount
                                FROM MovementItem

                                     LEFT JOIN MovementItemBoolean AS MIBoolean_Complement
                                                                   ON MIBoolean_Complement.MovementItemId = MovementItem.Id
                                                                  AND MIBoolean_Complement.DescId = zc_MIBoolean_Complement()
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND COALESCE (MovementItem.Amount,0) <> 0
                                  AND MovementItem.isErased = FALSE
                                  AND COALESCE (MIBoolean_Complement.ValueData, False) = True
                                )

             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                                INNER JOIN ObjectBoolean AS ObjectBoolean_OrderPromo
                                                         ON ObjectBoolean_OrderPromo.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                                        AND ObjectBoolean_OrderPromo.DescId = zc_ObjectBoolean_Unit_OrderPromo()
                                                        AND COALESCE (ObjectBoolean_OrderPromo.ValueData, FALSE) = TRUE
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- продажи
             , tmpContainer AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                                     , MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount * CASE WHEN MIContainer.OperDate > vbMiddleDate THEN 0.5 ELSE 1.0 END, 0)) AS Amount
                                     FROM MovementItemContainer AS MIContainer
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                          INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = MIContainer.ObjectId_analyzer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_Check()
                                       AND MIContainer.OperDate > vbStartDate AND MIContainer.OperDate < vbEndDate
                                     GROUP BY MIContainer.ObjectId_analyzer
                                            , MIContainer.WhereObjectId_analyzer
                                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                     )
              -- остатки
             , tmpRemains AS (SELECT tmp.UnitId
                                   , tmp.GoodsId
                                   , SUM (tmp.Amount) AS Amount
                              FROM  (SELECT Container.WhereObjectId AS UnitId
                                          , Container.ObjectId      AS GoodsId
                                          , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) AS Amount
                                     FROM Container
                                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                         INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Container.ObjectId
                                         LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                              AND MovementItemContainer.Operdate >= vbEndDate
                                     WHERE Container.DescId = zc_Container_Count()
                                     GROUP BY Container.WhereObjectId
                                            , Container.ObjectId
                                            , Container.Amount
                                     HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                     ) AS tmp
                              GROUP BY tmp.UnitId
                                     , tmp.GoodsId
                              )

         -- результат
         SELECT tmpMI_Child.Id                                           AS Id
              , tmpMI_Master.Id                                          AS ParentId
              , tmpUnit.UnitId                                           AS UnitId
              , tmpContainer.Amount                                      AS AmountOut
              , tmpRemains.Amount                                        AS Remains
              , CASE WHEN COALESCE (tmpMI_Child.AmountManual, 0) > 0
                THEN 0 ELSE CEIL(tmpMI_Master.Amount - COALESCE (tmpRemains.Amount, 0)) END  AS AmountIn
              , COALESCE (tmpMI_Child.AmountManual, 0)                   AS AmountManual
         FROM tmpMI_Master
              LEFT JOIN tmpUnit ON 1=1
              LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                  AND tmpRemains.UnitId = tmpUnit.UnitId
              LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                    AND tmpContainer.UnitId = tmpUnit.UnitId
              LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                                   AND tmpMI_Child.UnitId = tmpUnit.UnitId
         WHERE CASE WHEN COALESCE (tmpMI_Child.AmountManual, 0) > 0
                THEN COALESCE (tmpMI_Child.AmountManual, 0)
                ELSE CEIL (tmpMI_Master.Amount - COALESCE (tmpRemains.Amount, 0)) END  > 0
         ;
         
    ANALYSE tmpData;
         
         
    -- Дораспределение нерасспределенного
    IF COALESCE (inUnitCodeList, '') <> '' AND
       EXISTS(SELECT MovementItem.Id
                   , MovementItem.ObjectId AS GoodsId
                   , (MovementItem.Amount - COALESCE (tmpChild.AmountIn, 0)) AS Amount
              FROM MovementItem
                   LEFT JOIN (SELECT tmpData.ParentId
                                   , SUM (tmpData.AmountIn) AS AmountIn
                              FROM tmpData
                              GROUP BY tmpData.ParentId
                              ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND (MovementItem.Amount - COALESCE (tmpChild.AmountIn, 0)) > 0
                AND MovementItem.isErased = FALSE)
    THEN
    
       -- строки мастера с кол-вом для распределения
       WITH 
         tmpMI_Master AS (SELECT MovementItem.Id
                               , MovementItem.ObjectId AS GoodsId
                               , (MovementItem.Amount - COALESCE (tmpChild.AmountIn, 0)) AS Amount
                          FROM MovementItem
                               LEFT JOIN (SELECT tmpData.ParentId
                                               , SUM (tmpData.AmountIn) AS AmountIn
                                          FROM tmpData
                                          GROUP BY tmpData.ParentId
                                          ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId = zc_MI_Master()
                            AND (MovementItem.Amount - COALESCE (tmpChild.AmountIn, 0)) > 0
                            AND MovementItem.isErased = FALSE
                          )
                                
                                
       SELECT SUM(tmpMI_Master.Amount)::Integer
       INTO vbAmountDist
       FROM tmpMI_Master;

       -- таблица
       IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpUnit_List')
       THEN
           CREATE TEMP TABLE tmpUnit_List (Id Integer, UnitId Integer) ON COMMIT DROP;
       ELSE
           DELETE FROM tmpUnit_List;
       END IF;

       -- парсим подразделения для перекрытия всего нераспределенного остатка
       vbUnitId := 1;
       WHILE vbUnitId < vbAmountDist LOOP
         vbIndex := 1;
         WHILE SPLIT_PART (inUnitCodeList, ',', vbIndex) <> '' LOOP
            -- добавляем то что нашли
            INSERT INTO tmpUnit_List (Id, UnitId)
             SELECT vbUnitId
                  , Object_Unit.Id
             FROM Object AS Object_Unit 
             WHERE Object_Unit.DescID = zc_Object_Unit()
               AND Object_Unit.ObjectCode = SPLIT_PART (inUnitCodeList, ',', vbIndex) :: Integer;

            -- теперь следуюющий
            vbIndex := vbIndex + 1;
            vbUnitId := vbUnitId + 1;
         END LOOP;      
       END LOOP;      

       -- распределяем все нераспределенное
       OPEN curDistribution FOR (SELECT MovementItem.Id
                                      , (MovementItem.Amount - COALESCE (tmpChild.AmountIn, 0)) AS Amount
                                 FROM MovementItem
                                      LEFT JOIN (SELECT tmpData.ParentId
                                                      , SUM (tmpData.AmountIn) AS AmountIn
                                                 FROM tmpData
                                                 GROUP BY tmpData.ParentId
                                                 ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.Amount - COALESCE (tmpChild.AmountIn, 0)) > 0
                                   AND MovementItem.isErased = FALSE
                                 );

       vbIndex := 1;
       -- начало цикла по курсору1
       LOOP
           -- данные по курсору1
           FETCH curDistribution INTO vbId, vbAmount;
           -- если данные закончились, тогда выход
           IF NOT FOUND THEN EXIT; END IF;
           
           WHILE vbAmount > 0 LOOP
           
             SELECT tmpUnit_List.UnitId
             INTO vbUnitId
             FROM tmpUnit_List
             WHERE tmpUnit_List.ID = vbIndex;
             
             -- Добавим
             IF EXISTS (SELECT 1 FROM tmpData
                        WHERE tmpData.ParentId = vbId AND UnitId = vbUnitId)
             THEN
               UPDATE tmpData SET AmountIn = AmountIn + CASE WHEN vbAmount >= 1 THEN 1 ELSE vbAmount END
               WHERE tmpData.ParentId = vbId AND UnitId = vbUnitId;
             ELSE
               INSERT INTO tmpData (Id, ParentId, UnitId, AmountOut, Remains, AmountIn, AmountManual)
               VALUES (NULL, vbId, vbUnitId, NULL, NULL, CASE WHEN vbAmount >= 1 THEN 1 ELSE vbAmount END, NULL);
             END IF;
             
             vbAmount := vbAmount - 1;
             vbIndex := vbIndex + 1;

           END LOOP;      

       END LOOP; -- финиш цикла по курсору1
       CLOSE curDistribution; -- закрыли курсор1 
    END IF;
    

    --- сохраняем данные чайлд
    PERFORM lpInsertUpdate_MI_OrderInternalPromoChild (ioId           := COALESCE (tmpData.Id, tmpMI_Child.Id, 0)
                                                     , inParentId     := tmpData.ParentId
                                                     , inMovementId   := inMovementId
                                                     , inUnitId       := tmpData.UnitId
                                                     , inAmount       := COALESCE (tmpData.AmountIn,0)   :: TFloat
                                                     , inAmountManual := COALESCE (tmpData.AmountManual,0)   :: TFloat
                                                     , inAmountOut    := COALESCE (tmpData.AmountOut,0)  :: TFloat
                                                     , inRemains      := COALESCE (tmpData.Remains,0)    :: TFloat
                                                     , inUserId       := vbUserId
                                                     )
    FROM tmpData
         LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpData.ParentId
                              AND tmpMI_Child.UnitId = tmpData.UnitId;
    
     -- удаляем строки чайлд, которые нам не нужны
     UPDATE MovementItem
     SET isErased = TRUE
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child()
       AND MovementItem.Id IN (SELECT tmpMI_Child.Id
                               FROM tmpMI_Child
                                    LEFT JOIN tmpData ON tmpData.Id = tmpMI_Child.Id
                                                     AND COALESCE (tmpData.Id,0) <> 0
                               WHERE tmpData.Id IS NULL);
                               
    -- !!!ВРЕМЕННО для ТЕСТА!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%>', inSession, inSession, inSession;
    END IF;*/
                               

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.19         *
 16.04.19         *
*/

-- select * from gpInsert_MI_OrderInternalPromoChild(inMovementId := 25768416 , inUnitCodeList := '13,14,15,74,11,29,34,57,104,20,22,30,56,101,75,18,17,82,103,91,93,96,95,100,10,25,33,66,92,47,51,44,60,59,61,69,2,4,5,83,87,88,102' ,  inSession := '3');

--select * from gpInsert_MI_OrderInternalPromoChild(inMovementId := 28909930 , inUnitCodeList := '13,14,15,74,11,29,34,57,104,20,22,30,56,101,75,18,17,82,103,91,93,96,95,100,10,25,33,66,92,47,51,44,60,59,61,69,2,4,5,83,87,88,102' ,  inSession := '3');

--select * from gpInsert_MI_OrderInternalPromoChild(inMovementId := 30534071 , inUnitCodeList := '13,14,15,74,11,29,34,57,104,20,22,30,56,101,75,18,17,82,103,91,93,96,95,100,10,25,33,66,92,47,51,44,60,59,61,69,2,4,5,83,87,88,102' ,  inSession := '3');