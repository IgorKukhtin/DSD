-- Function: gpInsert_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternalPromoChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderInternalPromoChild(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbDays TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
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

    -- C����������� �����
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

     -- ������� �������� �� ����� �����
     UPDATE MovementItem
     SET isErased = FALSE, Amount = 0
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child();

    CREATE TEMP TABLE tmpData (Id Integer, ParentId Integer, UnitId Integer, AmountOut TFloat, Remains TFloat, AmountIn TFloat, AmountManual TFloat) ON COMMIT DROP;
          INSERT INTO tmpData (Id, ParentId, UnitId, AmountOut, Remains, AmountIn, AmountManual)
          WITH 
               -- ������ ������� � ���-��� ��� �������������
               tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId AS GoodsId
                                     , (MovementItem.Amount - COALESCE (tmpChild.AmountManual, 0)) AS Amount
                                FROM MovementItem
                                     LEFT JOIN (SELECT tmpMI_Child.ParentId
                                                     , SUM (tmpMI_Child.AmountManual) AS AmountManual
                                               FROM tmpMI_Child
                                               WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
                                               GROUP BY tmpMI_Child.ParentId
                                               ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND COALESCE (MovementItem.Amount,0) > 0
                                  AND MovementItem.isErased = FALSE
                                )

             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- �������
             , tmpContainer AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                                     , MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
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
              -- �������
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

             -- ������ ���-�� ���� �������
             , tmpRemainsDay AS (SELECT tmpMI_Master.Id
                                      , CASE WHEN COALESCE (tmpChild.AmountOut_real,0) <> 0 AND COALESCE (3,0) <> 0 
                                             THEN (COALESCE (tmpChild.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpChild.AmountOut_real,0) / 3)
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

            -- ������ �����.
             , tmpMI_Child_Calc AS (SELECT tmpMI_Child.*
                                         , (((tmpMI_Child.AmountOut_real / 3) * tmpRemainsDay.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpRemainsDay.RemainsDay) :: TFloat AS Koeff
                                    FROM tmpData_all AS tmpMI_Child
                                         LEFT JOIN tmpRemainsDay ON tmpRemainsDay.Id = tmpMI_Child.ParentId
                                   )
             -- ������������� ���-�� ���� ������� ��� ����� � �����. �����.
             , tmpRemainsDay2 AS (SELECT tmpMI_Master.Id
                                      , CASE WHEN (COALESCE (tmpChild.AmountOut_real,0) / 3) <> 0 
                                             THEN (COALESCE (tmpChild.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpChild.AmountOut_real,0) / 3)
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
                                , (((tmpData_all.AmountOut_real /3 )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) AS AmountOut
                                , tmpData_all.Remains
                                , tmpData_all.Amount_Master
                                , SUM (((tmpData_all.AmountOut_real /3 )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) OVER (PARTITION BY tmpData_all.ParentId) AS AmountOutSUM
                                , COALESCE (tmpData_all.AmountManual,0) AS AmountManual
                           FROM tmpMI_Child_Calc AS tmpData_all
                                LEFT JOIN tmpRemainsDay2 ON tmpRemainsDay2.Id = tmpData_all.ParentId
                           WHERE COALESCE (tmpData_all.Koeff,0) > 0
                             AND (((tmpData_all.AmountOut_real /3 )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) > 0
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

              -- ��������������� ������� ��� ������������� ������
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
             -- ��������������� ������������� 
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

             , tmpDD AS (SELECT DD.Id
                              , DD.ParentId
                              , DD.UnitId
                              , DD.AmountOut_real AS AmountOut
                              , DD.Remains
                              , COALESCE (tmpCalc.AmountIn) AS AmountIn
                              , 0 :: TFloat AS AmountManual
                         FROM tmpData_all AS DD
                              LEFT JOIN tmpCalc ON tmpCalc.Id = DD.Id
                                               AND tmpCalc.ParentId = DD.ParentId
                                               AND tmpCalc.UnitId = DD.UnitId
                          )

         -- ���������
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
             UNION
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
                                          
               WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
               ) AS DD;
           
    --- ��������� ������ �����      
    PERFORM lpInsertUpdate_MI_OrderInternalPromoChild (ioId           := COALESCE (tmpData.Id,0)
                                                     , inParentId     := tmpData.ParentId
                                                     , inMovementId   := inMovementId
                                                     , inUnitId       := tmpData.UnitId
                                                     , inAmount       := COALESCE (tmpData.AmountIn,0)   :: TFloat
                                                     , inAmountManual := COALESCE (tmpData.AmountManual,0)   :: TFloat
                                                     , inAmountOut    := COALESCE (tmpData.AmountOut,0)  :: TFloat
                                                     , inRemains      := COALESCE (tmpData.Remains,0)    :: TFloat
                                                     , inUserId       := vbUserId
                                                     )
    FROM tmpData;
    
     -- ������� ������ �����, ������� ��� �� �����
     UPDATE MovementItem 
     SET isErased = TRUE
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child()
       AND MovementItem.Id IN (SELECT tmpMI_Child.Id
                               FROM tmpMI_Child
                                    LEFT JOIN tmpData ON tmpData.Id = tmpMI_Child.Id
                                                     AND COALESCE (tmpData.Id,0) <> 0
                               WHERE tmpData.Id IS NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.19         *
 16.04.19         *
*/

/*
WITH 
tmpMI_Child AS (
       SELECT MovementItem.Id
            , MovementItem.ParentId
            , MovementItem.ObjectId AS UnitId
            , COALESCE (MIFloat_AmountManual.ValueData,0) AS AmountManual
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
        WHERE MovementItem.MovementId = 13840564 
          AND MovementItem.DescId = zc_MI_Child()
             )
               -- ������ ������� � ���-��� ��� �������������
             , tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId AS GoodsId
                                     , (MovementItem.Amount - COALESCE (tmpChild.AmountManual, 0)) AS Amount
                                FROM MovementItem
                                     LEFT JOIN (SELECT tmpMI_Child.ParentId
                                                     , SUM (tmpMI_Child.AmountManual) AS AmountManual
                                               FROM tmpMI_Child
                                               WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
                                               GROUP BY tmpMI_Child.ParentId
                                               ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                                WHERE MovementItem.MovementId = 13840564 
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND COALESCE (MovementItem.Amount,0) > 0
                                  AND MovementItem.isErased = FALSE
                                )


             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = 4--vbRetailId
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- �������
             , tmpContainer AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                                     , MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                                     FROM MovementItemContainer AS MIContainer
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                          INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = MIContainer.ObjectId_analyzer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_Check()
                                       AND MIContainer.OperDate > '28.04.2019' AND MIContainer.OperDate < '02.05.2019'
                                     GROUP BY MIContainer.ObjectId_analyzer 
                                            , MIContainer.WhereObjectId_analyzer
                                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                     )
              -- �������
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
                                                                              AND MovementItemContainer.Operdate >= '02.05.2019'
                                     WHERE Container.DescId = zc_Container_Count()
                                     GROUP BY Container.WhereObjectId
                                            , Container.ObjectId
                                            , Container.Amount 
                                     HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
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

             -- ������ ���-�� ���� �������
             , tmpRemainsDay AS (SELECT tmpMI_Master.Id
                                      , CASE WHEN COALESCE (tmpChild.AmountOut_real,0) <> 0 AND COALESCE (3,0) <> 0 
                                             THEN (COALESCE (tmpChild.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpChild.AmountOut_real,0) / 3)
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

            -- ������ �����.
             , tmpMI_Child_Calc AS (SELECT tmpMI_Child.*
                                         , (((tmpMI_Child.AmountOut_real / 3) * tmpRemainsDay.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpRemainsDay.RemainsDay) :: TFloat AS Koeff
                                    FROM tmpData_all AS tmpMI_Child
                                         LEFT JOIN tmpRemainsDay ON tmpRemainsDay.Id = tmpMI_Child.ParentId
                                   )
             -- ������������� ���-�� ���� ������� ��� ����� � �����. �����.
             , tmpRemainsDay2 AS (SELECT tmpMI_Master.Id
                                      , CASE WHEN (COALESCE (tmpChild.AmountOut_real,0) / 3) <> 0 
                                             THEN (COALESCE (tmpChild.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpChild.AmountOut_real,0) / 3)
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


           /*  , tmpMI_Child_Calc2 AS (SELECT tmpMI_Child.*
                                          , (((tmpMI_Child.AmountOut_real / 3) * tmpRemainsDay2.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpRemainsDay2.RemainsDay) :: TFloat AS Koeff2
                                          , SUM (((tmpMI_Child.AmountOut_real / 3) * tmpRemainsDay2.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpRemainsDay2.RemainsDay) OVER (PARTITION BY tmpMI_Child.ParentId) AS KoeffSUM2
                                     FROM tmpMI_Child_Calc AS tmpMI_Child
                                          LEFT JOIN tmpRemainsDay2 ON tmpRemainsDay2.Id = tmpMI_Child.ParentId
                                     WHERE COALESCE (tmpMI_Child.Koeff,0) > 0
                                    )
*/
-----------------------------------------------------------------------------------------------------------------------

             , tmpData AS
 (SELECT COALESCE (tmpData_all.Id,0) AS Id
                                , tmpData_all.ParentId
                                , tmpData_all.UnitId
                                , tmpData_all.AmountOut_real
                                , (((tmpData_all.AmountOut_real /3 )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) AS AmountOut
                                , tmpData_all.Remains
                                , tmpData_all.Amount_Master
                                , SUM (((tmpData_all.AmountOut_real /3 )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) OVER (PARTITION BY tmpData_all.ParentId) AS AmountOutSUM
                                , COALESCE (tmpData_all.AmountManual,0) AS AmountManual
                           FROM tmpMI_Child_Calc AS tmpData_all
                                LEFT JOIN tmpRemainsDay2 ON tmpRemainsDay2.Id = tmpData_all.ParentId
                           WHERE COALESCE (tmpData_all.Koeff,0) > 0
 and (((tmpData_all.AmountOut_real /3 )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) > 0
                           )


             , tmpData1 AS 
(SELECT tmpData.Id
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

              -- ��������������� ������� ��� ������������� ������
             , tmpData111 AS
 (SELECT tmpMI_Master.GoodsId
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
             -- ��������������� ������������� 
             , tmpCalc AS 
(SELECT DD.Id
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

             , tmpDD AS (SELECT DD.Id
                              , DD.ParentId
                              , DD.UnitId
                              , DD.AmountOut_real AS AmountOut
                              , DD.Remains
                              , COALESCE (tmpCalc.AmountIn) AS AmountIn
                              , 0 :: TFloat AS AmountManual
                         FROM tmpData_all AS DD
                              LEFT JOIN tmpCalc ON tmpCalc.Id = DD.Id
                                               AND tmpCalc.ParentId = DD.ParentId
                                               AND tmpCalc.UnitId = DD.UnitId
                         )
         -- ���������
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
             UNION
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
                                          
               WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
               ) AS DD;
           
*/