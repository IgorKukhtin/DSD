-- Function: gpUpdate_MI_OrderInternalPromo_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_Amount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_Amount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbisSIP     Boolean;
   DECLARE vbRetailId  Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbDays      TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

     SELECT CASE WHEN COALESCE (MovementFloat_TotalSummPrice.ValueData,0) <> 0
                 THEN COALESCE (MovementFloat_TotalSummPrice.ValueData,0)
                 ELSE COALESCE (MovementFloat_TotalSummSIP.ValueData,0)
            END :: TFloat    AS TotalSumm
          , CASE WHEN COALESCE (MovementFloat_TotalSummPrice.ValueData,0) <> 0 THEN FALSE
                 ELSE TRUE
            END     AS vbisSIP

          , (MovementDate_StartSale.ValueData - INTERVAL '1 DAY')
          , (Movement.OperDate + INTERVAL '1 DAY')
          , MovementLinkObject_Retail.ObjectId AS RetailId
          , DATE_PART ( 'day', ((Movement.OperDate - MovementDate_StartSale.ValueData)+ INTERVAL '1 DAY'))
    INTO vbTotalSumm, vbisSIP, vbStartDate, vbEndDate, vbRetailId, vbDays
     FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPrice
                                ON MovementFloat_TotalSummPrice.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPrice.DescId = zc_MovementFloat_TotalSummPrice()
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSIP
                                ON MovementFloat_TotalSummSIP.MovementId = Movement.Id
                               AND MovementFloat_TotalSummSIP.DescId = zc_MovementFloat_TotalSummSIP()
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
     WHERE Movement.Id = inMovementId;

    IF COALESCE (vbTotalSumm,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Один из реквизитов Сумма по ценам райса или Сумма по ценам СИП должен быть оличен от Нуля.';
    END IF;
    
    CREATE TEMP TABLE tmpData (Id Integer, GoodsId Integer, AmountCalc TFloat) ON COMMIT DROP;
          INSERT INTO tmpData (Id, GoodsId, AmountCalc)
          WITH 
               -- строки мастера с кол-вом для распределения
               tmpMI_Price AS (SELECT MovementItem.Id
                                    , MovementItem.ObjectId             AS GoodsId
                                    , MIFloat_PromoMovementId.ValueData :: Integer AS PromoMovementId
                                    , MIFloat_Price.ValueData  ::TFloat AS Price
                                    , SUM (MIFloat_Price.ValueData) OVER (PARTITION BY MovementItem.MovementId) AS Price_SUM
                               FROM MovementItem
                                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_PromoMovementId.DescId = zc_MIFloat_PromoMovementId()
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE
                               )
                                
                                
             , tmpMI_PriceSIP AS (SELECT tmpMI_Price.Id
                                       , tmpMI_Price.GoodsId
                                       , MIFloat_Price.ValueData     ::TFloat AS Price
                                       , SUM (MIFloat_Price.ValueData) OVER (ORDER BY tmpMI_Price.Id) AS Price_SUM
                                  FROM tmpMI_Price
                                     LEFT JOIN MovementItem AS MI_Promo 
                                                            ON MI_Promo.MovementId = tmpMI_Price.PromoMovementId
                                                           AND MI_Promo.DescId   = zc_MI_Master()
                                                           AND MI_Promo.ObjectId = tmpMI_Price.GoodsId
                                                           AND MI_Promo.isErased = FALSE
                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MI_Promo.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 )
             -- строки мастера с нужными ценами
             , tmpMI_Master AS (SELECT tmp.Id
                                     , tmp.GoodsId
                                     , tmp.Price
                                     , tmp.Price_SUM
                                FROM tmpMI_Price AS tmp
                                WHERE vbisSIP = FALSE
                               UNION
                                SELECT tmp.Id
                                     , tmp.GoodsId
                                     , tmp.Price
                                     , tmp.Price_SUM
                                FROM tmpMI_PriceSIP AS tmp
                                WHERE vbisSIP = TRUE
                               )
             -- подразделения сети
             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- продажи
             , tmpContainer AS (SELECT MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) )              AS SummaSale
                                     , SUM ( SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0))) OVER() AS TotalSummSale -- итого сумма продажи за период
                                     FROM MovementItemContainer AS MIContainer
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                          INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = MIContainer.ObjectId_analyzer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_Check()
                                       AND MIContainer.OperDate > vbStartDate AND MIContainer.OperDate < vbEndDate
                                       --AND MIContainer.OperDate > '30.04.2019' AND MIContainer.OperDate < '20.05.2019'
                                     GROUP BY MIContainer.ObjectId_analyzer 
                                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                     )

             , tmpPrice_Unit AS (SELECT ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                                      , Price_Goods.ChildObjectId               AS GoodsId
                                      , ROUND (Price_Value.ValueData , 2) ::TFloat AS Price
                                 FROM tmpUnit
                                      LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                           ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                          AND ObjectLink_Price_Unit.ChildObjectId = tmpUnit.UnitId
                                      INNER JOIN ObjectLink AS Price_Goods
                                                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                      INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Price_Goods.ChildObjectId

                                      LEFT JOIN ObjectFloat AS Price_Value
                                                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                 )

              -- остатки
             , tmpRemains AS (SELECT tmp.GoodsId
                                   , SUM (tmp.Amount * tmp.Price) AS SummRemains
                                   , SUM ( SUM(tmp.Amount * tmp.Price)) OVER () AS TotalSumm_rem
                              FROM  (SELECT Container.ObjectId      AS GoodsId
                                          , tmpPrice_Unit.Price     AS Price
                                          , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) AS Amount
                                     FROM Container
                                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                         INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Container.ObjectId
                                         LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                              AND MovementItemContainer.Operdate >= vbEndDate
                                         LEFT JOIN tmpPrice_Unit ON tmpPrice_Unit.GoodsId = Container.ObjectId
                                                                AND tmpPrice_Unit.UnitId  = Container.WhereObjectId
                                     WHERE Container.DescId = zc_Container_Count()
                                     GROUP BY Container.ObjectId
                                            , Container.Amount 
                                            , tmpPrice_Unit.Price
                                            , Container.Id
                                     HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                     ) AS tmp
                              GROUP BY tmp.GoodsId
                              )
             --
             , tmpData_D AS (SELECT tmpMI_Master.Id
                                  , tmpMI_Master.GoodsId
                                  , tmpMI_Master.Price
                                  , COALESCE (tmpRemains.SummRemains,0)                                                     AS SummRemains       -- итого сумма остаток
                                  , CASE WHEN COALESCE (vbDays, 0) <> 0 THEN tmpContainer.SummaSale / vbDays ELSE 0 END     AS SummSale_avg      -- средняя сумма продажи за день
                                  , CASE WHEN COALESCE (vbDays, 0) <> 0 THEN tmpContainer.TotalSummSale / vbDays ELSE 0 END AS TotalSummSale_avg -- итого средняя сумма продажи за день
                                  , CASE WHEN COALESCE (tmpContainer.TotalSummSale, 0) <> 0 AND COALESCE (vbDays, 0) <> 0
                                         THEN tmpRemains.TotalSumm_rem / (tmpContainer.TotalSummSale / vbDays)
                                         ELSE 0
                                    END AS RemainsDay
                             FROM tmpMI_Master
                                  LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                  LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                             )

            -- расчет коэфф.
             , tmpMI_Child_Calc AS (SELECT tmpData_D.*
                                         , ((tmpData_D.SummSale_avg * tmpData_D.RemainsDay - COALESCE (tmpData_D.SummRemains,0)) / tmpData_D.RemainsDay) :: TFloat AS Koeff
                                    FROM tmpData_D
                                   )

             , tmpData AS (SELECT tmpData_all.Id
                                , tmpData_all.GoodsId
                                , tmpData_all.Price
                                , (((tmpData_all.TotalSummSale_avg) * tmpData_all.RemainsDay - COALESCE (tmpData_all.SummRemains,0))/tmpData_all.RemainsDay) AS AmountOut

                                , SUM (((tmpData_all.TotalSummSale_avg) * tmpData_all.RemainsDay - COALESCE (tmpData_all.SummRemains,0))/tmpData_all.RemainsDay) OVER () AS AmountOutSUM
                           FROM tmpMI_Child_Calc AS tmpData_all
                           WHERE COALESCE (tmpData_all.Koeff,0) > 0
                             AND (((tmpData_all.TotalSummSale_avg) * tmpData_all.RemainsDay - COALESCE (tmpData_all.SummRemains,0))/tmpData_all.RemainsDay)>0
                           )

            , tmpData1 AS (SELECT tmpData.Id
                                 , tmpData.AmountOut
                                 , tmpData.Price
                                 , tmpData.GoodsId
                                 , CASE WHEN tmpData.AmountOutSUM <> 0
                                        THEN ROUND (( vbTotalSumm / tmpData.AmountOutSUM * tmpData.AmountOut) / tmpData.Price ,0) * tmpData.Price
                                        ELSE 0
                                   END   AS Amount_Calc
                            FROM tmpData
                            )

              -- вспомогательные расчеты для распределения заказа
             , tmpData111 AS (SELECT tmpData1.Id
                                   , tmpData1.GoodsId
                                   , tmpData1.Price
                                   , tmpData1.Amount_Calc
                                   , tmpData1.AmountOut
                                   , SUM (tmpData1.Amount_Calc) OVER (ORDER BY tmpData1.AmountOut, tmpData1.Id) AS Amount_CalcSUM
                                   , ROW_NUMBER() OVER (ORDER BY tmpData1.AmountOut DESC) AS DOrd
                              FROM tmpData1
                              )
             -- непосредственно распределение 
             SELECT DD.Id
                  , DD.GoodsId
                  , CASE WHEN vbTotalSumm - DD.Amount_CalcSUM > 0 AND DD.DOrd <> 1
                              THEN ROUND (DD.Amount_Calc /DD.Price )
                         ELSE ROUND (( vbTotalSumm - DD.Amount_CalcSUM + DD.Amount_Calc)/DD.Price)
                    END AS AmountCalc
             FROM tmpData111 AS DD
             WHERE vbTotalSumm - (DD.Amount_CalcSUM - DD.Amount_Calc) > 0
          ;
           
    --- сохраняем данные мастера      
    PERFORM lpInsertUpdate_MovementItem (tmpData.Id, zc_MI_Master(), tmpData.GoodsId, inMovementId, tmpData.AmountCalc, NULL)
    FROM tmpData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.19         *

*/
--select * from gpUpdate_MI_OrderInternalPromo_Amount(inMovementId := 14257740 ,  inSession := '3');
/*
          WITH 
               -- строки мастера с кол-вом для распределения
               tmpMI_Price AS (SELECT MovementItem.Id
                                    , MovementItem.ObjectId             AS GoodsId
                                    , MIFloat_PromoMovementId.ValueData :: Integer AS PromoMovementId
                                    , MIFloat_Price.ValueData  ::TFloat AS Price
                                    , SUM (MIFloat_Price.ValueData) OVER (PARTITION BY MovementItem.MovementId) AS Price_SUM
                               FROM MovementItem
                                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_PromoMovementId.DescId = zc_MIFloat_PromoMovementId()
                               WHERE MovementItem.MovementId = 14257704  --inMovementId
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE
                               )
                                
             , tmpMI_PriceSIP AS (SELECT tmpMI_Price.Id
                                       , tmpMI_Price.GoodsId
                                       , MIFloat_Price.ValueData     ::TFloat AS Price
                                       , SUM (MIFloat_Price.ValueData) OVER (ORDER BY tmpMI_Price.Id) AS Price_SUM
                                  FROM tmpMI_Price
                                     LEFT JOIN MovementItem AS MI_Promo 
                                                            ON MI_Promo.MovementId = tmpMI_Price.PromoMovementId
                                                           AND MI_Promo.DescId   = zc_MI_Master()
                                                           AND MI_Promo.ObjectId = tmpMI_Price.GoodsId
                                                           AND MI_Promo.isErased = FALSE
                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MI_Promo.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 )
             -- строки мастера с нужными ценами
             , tmpMI_Master AS (SELECT tmp.Id
                                     , tmp.GoodsId
                                     , tmp.Price
                                     , tmp.Price_SUM
                                FROM tmpMI_Price AS tmp
                             /*   WHERE vbisSIP = FALSE
                               UNION
                                SELECT tmp.Id
                                     , tmp.GoodsId
                                     , tmp.Price
                                     , tmp.Price_SUM
                                FROM tmpMI_PriceSIP AS tmp
                                WHERE vbisSIP = TRUE
                               */)
             -- подразделения сети
             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = 4--vbRetailId
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- продажи
             , tmpContainer AS (SELECT MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM ( COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) )        AS SummaSale
                                     , SUM ( SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) ) OVER() AS TotalSummSale -- итого сумма продажи за период
                                     FROM MovementItemContainer AS MIContainer
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                          INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = MIContainer.ObjectId_analyzer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_Check()
                                       AND MIContainer.OperDate > vbStartDate AND MIContainer.OperDate < vbEndDate
                                       --AND MIContainer.OperDate > '30.04.2019' AND MIContainer.OperDate < '20.05.2019'
                                     GROUP BY MIContainer.ObjectId_analyzer 
                                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                     )

             , tmpPrice_Unit AS (SELECT ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                                      , Price_Goods.ChildObjectId               AS GoodsId
                                      , ROUND (Price_Value.ValueData , 2) ::TFloat AS Price
                                 FROM tmpUnit
                                      LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                           ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                          AND ObjectLink_Price_Unit.ChildObjectId = tmpUnit.UnitId
                                      INNER JOIN ObjectLink AS Price_Goods
                                                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                      INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Price_Goods.ChildObjectId

                                      LEFT JOIN ObjectFloat AS Price_Value
                                                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                 )

              -- остатки
             , tmpRemains AS (SELECT tmp.GoodsId
                                   , SUM (tmp.Amount * tmp.Price) AS SummRemains
                                   , SUM ( SUM(tmp.Amount * tmp.Price)) OVER () AS TotalSumm_rem
                              FROM  (SELECT Container.ObjectId      AS GoodsId
                                          , tmpPrice_Unit.Price     AS Price
                                          , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) AS Amount
                                     FROM Container
                                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                         INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Container.ObjectId
                                         LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                              AND MovementItemContainer.Operdate >= '20.05.2019'
                                         LEFT JOIN tmpPrice_Unit ON tmpPrice_Unit.GoodsId = Container.ObjectId
                                                                AND tmpPrice_Unit.UnitId  = Container.WhereObjectId
                                     WHERE Container.DescId = zc_Container_Count()
                                     GROUP BY Container.ObjectId
                                            , Container.Amount 
                                            , tmpPrice_Unit.Price
                                     HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                     ) AS tmp
                              GROUP BY tmp.GoodsId
                              )
             --
             , tmpData_D AS (SELECT tmpMI_Master.Id
                                  , tmpMI_Master.GoodsId
                                  , tmpMI_Master.Price
                                  , COALESCE (tmpRemains.SummRemains,0)                   AS SummRemains          -- итого сумма остаток
                                  , CASE WHEN COALESCE (21, 0) <> 0 THEN tmpContainer.SummaSale / 21 ELSE 0 END AS SummSale_avg --средняя сумма продажи за день
                                  , CASE WHEN COALESCE (21, 0) <> 0 THEN tmpContainer.TotalSummSale / 21 ELSE 0 END AS TotalSummSale_avg --итого средняя сумма продажи за день
                                  , CASE WHEN COALESCE (tmpContainer.TotalSummSale, 0) <> 0 AND COALESCE (21, 0) <> 0
                                         THEN tmpRemains.TotalSumm_rem / (tmpContainer.TotalSummSale / 21)
                                         ELSE 0
                                    END AS RemainsDay                                  
                             FROM tmpMI_Master
                                  LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                  LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                             )

            -- расчет коэфф.
             , tmpMI_Child_Calc AS (SELECT tmpData_D.*
                                         , ((tmpData_D.SummSale_avg * tmpData_D.RemainsDay - COALESCE (tmpData_D.SummRemains,0)) / tmpData_D.RemainsDay) :: TFloat AS Koeff
                                    FROM tmpData_D
                                   )

             , tmpData AS (SELECT tmpData_all.Id
                                , tmpData_all.GoodsId
                                , tmpData_all.Price
                                , (((tmpData_all.TotalSummSale_avg) * tmpData_all.RemainsDay - COALESCE (tmpData_all.SummRemains,0))/tmpData_all.RemainsDay) AS AmountOut

                                , SUM (((tmpData_all.TotalSummSale_avg) * tmpData_all.RemainsDay - COALESCE (tmpData_all.SummRemains,0))/tmpData_all.RemainsDay) OVER () AS AmountOutSUM
                           FROM tmpMI_Child_Calc AS tmpData_all

                           )

            , tmpData1 AS (SELECT tmpData.Id
                                 , tmpData.AmountOut
                                 , tmpData.Price
                                 , tmpData.GoodsId
                                 , CASE WHEN tmpData.AmountOutSUM <> 0
                                        THEN ROUND (( vbTotalSumm / tmpData.AmountOutSUM * tmpData.AmountOut) / tmpData.Price ,0) * tmpData.Price
                                        ELSE 0
                                   END   AS Amount_Calc
                            FROM tmpData
                            )

              -- вспомогательные расчеты для распределения заказа
             , tmpData111 AS (SELECT tmpData1.Id
                                   , tmpData1.GoodsId
                                   , tmpData1.Price
                                   , tmpData1.Amount_Calc
                                   , tmpData1.AmountOut
                                   , SUM (tmpData1.Amount_Calc) OVER (ORDER BY tmpData1.AmountOut, tmpData1.Id) AS Amount_CalcSUM
                                   , ROW_NUMBER() OVER (ORDER BY tmpData1.AmountOut DESC) AS DOrd
                              FROM tmpData1
                              )
             -- непосредственно распределение 
             SELECT DD.Id
                  , DD.GoodsId
                  , CASE WHEN vbTotalSumm - DD.Amount_CalcSUM > 0 AND DD.DOrd <> 1
                              THEN ROUND (DD.Amount_Calc /DD.Price )
                         ELSE ROUND (( vbTotalSumm - DD.Amount_CalcSUM + DD.Amount_Calc)/DD.Price)
                    END AS AmountIn
             FROM tmpData111 AS DD
             WHERE vbTotalSumm - (DD.Amount_CalcSUM - DD.Amount_Calc) > 0

*/