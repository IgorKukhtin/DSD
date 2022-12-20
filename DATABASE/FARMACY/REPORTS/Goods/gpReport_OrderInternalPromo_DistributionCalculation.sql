-- Function: gpReport_OrderInternalPromo_DistributionCalculation()

DROP FUNCTION IF EXISTS gpReport_OrderInternalPromo_DistributionCalculation(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalPromo_DistributionCalculation(
    IN inMovementID  Integer   ,
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStartSale TDateTime;
  DECLARE vbOperDate TDateTime;
  DECLARE vbTotalSummPrice TFloat;
  DECLARE vbTotalSummSIP TFloat;
  DECLARE vbTotalAmount TFloat;
  DECLARE vbRetailIdId Integer;
  DECLARE vbDaySale Integer;
  DECLARE vbDayCalc Integer;
  DECLARE vbQueryText Text;
  DECLARE vbisChecked Boolean;

  DECLARE vbUnitID Integer;
  DECLARE vbGoodsId Integer;
  DECLARE vbAverageSalesRate TFloat;
  DECLARE vbSettlementStart TFloat;
  DECLARE vbDistributed TFloat;
  DECLARE vbPriceCalc TFloat;

  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
  DECLARE curResult_next  refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId := inSession;

     -- Получаем данные из контракта

     SELECT MovementDate_StartSale.ValueData                               AS StartSale
          , Movement.OperDate
          , COALESCE (MovementFloat_TotalSummPrice.ValueData,0):: TFloat   AS TotalSummPrice
          , COALESCE (MovementFloat_TotalSummSIP.ValueData,0) :: TFloat    AS TotalSummSIP
          , COALESCE (MovementFloat_TotalAmount.ValueData,0) :: TFloat     AS TotalAmount
          , MovementLinkObject_Retail.ObjectId                             AS RetailId
     INTO vbStartSale, vbOperDate, vbTotalSummPrice, vbTotalSummSIP, vbTotalAmount, vbRetailIdId
     FROM Movement

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPrice
                                ON MovementFloat_TotalSummPrice.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummPrice.DescId = zc_MovementFloat_TotalSummPrice()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSIP
                                ON MovementFloat_TotalSummSIP.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummSIP.DescId = zc_MovementFloat_TotalSummSIP()

        LEFT JOIN MovementFloat AS MovementFloat_TotalAmount
                                ON MovementFloat_TotalAmount.MovementId =  Movement.Id
                               AND MovementFloat_TotalAmount.DescId = zc_MovementFloat_TotalAmount()

        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()

     WHERE Movement.Id = inMovementID;

     IF EXISTS(SELECT MovementItem.Id
               FROM MovementItem
                    LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                  ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                                 AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId = zc_MI_Master()
                 AND MovementItem.isErased = False
                 AND COALESCE (MIBoolean_Checked.ValueData, False) = True)
     THEN
       vbisChecked := True;
     ELSE
       vbisChecked := False;
     END IF;

     vbDaySale := DATE_PART('day', vbOperDate - vbStartSale)::Integer;

     IF vbDaySale <= 1
     THEN
         RAISE EXCEPTION 'Ошибка.Период продаж не задан.';
     END IF;

     IF COALESCE(vbTotalSummPrice, 0) = 0 AND COALESCE(vbTotalSummSIP, 0) = 0 AND COALESCE(vbTotalAmount, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнена Сумма по ценам прайса СИП или количество.';
     END IF;

     IF COALESCE(vbTotalSummPrice, 0) > 0 AND (COALESCE(vbTotalSummSIP, 0) <> 0 OR COALESCE(vbTotalAmount, 0) <> 0) OR
        COALESCE(vbTotalSummSIP, 0) > 0 AND (COALESCE(vbTotalSummPrice, 0) <> 0 OR COALESCE(vbTotalAmount, 0) <> 0) OR
        COALESCE(vbTotalAmount, 0) > 0 AND (COALESCE(vbTotalSummSIP, 0) <> 0 OR COALESCE(vbTotalSummPrice, 0) <> 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Должна быть заполнена только одна Сумма по ценам прайса, СИП или количество.';
     END IF;

raise notice 'Value 0: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpGoods ON COMMIT DROP AS
        SELECT OIPromo.GoodsId
             , OIPromo.GoodsCode
             , OIPromo.GoodsName
             , OIPromo.Price
             , OIPromo.PriceSIP
             , CASE WHEN COALESCE(vbTotalSummPrice, 0) <> 0 THEN OIPromo.Price
                    WHEN COALESCE(vbTotalSummSIP, 0) <> 0 THEN OIPromo.PriceSIP
                    ELSE 1 END AS PriceCalc
        FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementID, inIsErased := 'False' ,  inSession := '3') AS OIPromo
        WHERE CASE WHEN COALESCE(vbTotalSummSIP, 0) <> 0 THEN OIPromo.PriceSIP ELSE OIPromo.Price END > 0
          AND OIPromo.Price > 0
          AND (OIPromo.isChecked = True OR vbisChecked = False);
          
     CREATE INDEX idx_tmpGoods_GoodsId ON tmpGoods(GoodsId, PriceCalc);
	 
	 ANALYSE tmpGoods;

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     IF COALESCE(vbTotalSummSIP, 0) <> 0
     THEN
       vbTotalSummPrice := vbTotalSummSIP;
     ELSEIF COALESCE(vbTotalAmount, 0) <> 0
     THEN
       vbTotalSummPrice := vbTotalAmount;
     END IF;
	 
     CREATE TEMP TABLE tmpCheck ON COMMIT DROP AS 
	                    (SELECT AnalysisContainerItem.UnitID
                              , AnalysisContainerItem.GoodsId
                              , SUM(AnalysisContainerItem.AmountCheck)     AS Sales
                         FROM tmpGoods

                              INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsId = tmpGoods.GoodsId

                              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                   ON ObjectLink_Unit_Juridical.ObjectId = AnalysisContainerItem.UnitID
                                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                              INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                  AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailIdId

                           WHERE AnalysisContainerItem.OperDate >= DATE_TRUNC ('DAY', vbStartSale )
                             AND AnalysisContainerItem.OperDate < DATE_TRUNC ('DAY', vbOperDate )+interval '1 day'
                           GROUP BY AnalysisContainerItem.UnitID
                                  , AnalysisContainerItem.GoodsId
                           HAVING SUM(AnalysisContainerItem.AmountCheck) > 0
                           );
	 
	 ANALYSE tmpCheck;

--raise notice 'Value 11: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpRemains ON COMMIT DROP AS 
	                      (SELECT tmp.ObjectId         AS GoodsId
                                , tmp.WhereObjectId    AS UnitID
                                , SUM(tmp.Remains)     AS Remains

                           FROM (SELECT Container.objectid
                                      , Container.WhereObjectId
                                      , Container.Amount  - COALESCE(SUM(MIContainer.Amount), 0)   AS Remains
                                 FROM container
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = container.Id
                                                                      AND MIContainer.OperDate >= DATE_TRUNC ('DAY', vbOperDate ) + interval '1 day'
                                 WHERE Container.DescId = zc_container_count()
                                   AND Container.ObjectId IN (SELECT tmpGoods.GoodsId FROM tmpGoods)
                                 GROUP BY container.objectid,COALESCE(container.Amount,0), container.Id
                                ) AS tmp
                           GROUP BY tmp.ObjectId
                                  , tmp.WhereObjectId
                           );

     ANALYSE tmpRemains;

--raise notice 'Value 12: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpData ON COMMIT DROP AS
     SELECT T1.UnitID
          , T1.GoodsId
          , T1.AverageSalesRate
          , T1.Remains
          , T1.MCS
          , (T1.Remains - T1.MCS)::TFloat AS  SettlementStart
          , 0::TFloat                                                                               AS Distributed
     FROM (
       WITH
            tmpPrice_View AS (SELECT tmpCheck.UnitID
                                   , tmpCheck.GoodsId
                                   , ObjectLink_Price_Unit.ObjectId          AS Id
                              FROM tmpCheck

                                   INNER JOIN  ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                         AND ObjectLink_Price_Unit.ChildObjectId = tmpCheck.UnitID
                                   INNER JOIN ObjectLink AS Price_Goods
                                                         ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                        AND Price_Goods.ChildObjectId = tmpCheck.GoodsId
                              ),
            tmpMCS AS (SELECT
                               tmpPrice_View.UnitID
                             , tmpPrice_View.GoodsId
                             , COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0)               :: TFloat    AS MCSValue
                          FROM tmpPrice_View

                              -- получаем значения цены и НТЗ из истории значений на конец дня (на сл.день 00:00)
                              LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                                      ON ObjectHistory_PriceEnd.ObjectId = tmpPrice_View.Id
                                                     AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                                     AND DATE_TRUNC ('DAY', vbOperDate ) >= ObjectHistory_PriceEnd.StartDate AND DATE_TRUNC ('DAY', vbOperDate ) < ObjectHistory_PriceEnd.EndDate

                              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                                           ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                                          AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()
                          )

         SELECT tmpCheck.UnitID
              , tmpCheck.GoodsId
              , tmpCheck.Sales / vbDaySale                  AS AverageSalesRate
              , COALESCE (tmpRemains.Remains, 0)            AS Remains
              , COALESCE (tmpMCS.MCSValue, 0)               AS MCS
         FROM tmpCheck
              LEFT JOIN tmpRemains ON tmpRemains.UnitID = tmpCheck.UnitID
                                  AND tmpRemains.GoodsId = tmpCheck.GoodsId
              LEFT JOIN tmpMCS ON tmpMCS.UnitID = tmpCheck.UnitID
                              AND tmpMCS.GoodsId = tmpCheck.GoodsId

         ) AS T1;

     CREATE INDEX idx_tmpData_UnitID_GoodsId ON tmpData(UnitID, GoodsId, AverageSalesRate, Remains, MCS, SettlementStart, Distributed);
         
	 ANALYSE tmpData;

--raise notice 'Value 2: %', CLOCK_TIMESTAMP();

     vbDayCalc := 0; vbTotalSummSIP := 0;
     WHILE vbDayCalc < 500 AND vbTotalSummSIP < vbTotalSummPrice
     LOOP
         vbDayCalc := vbDayCalc + 1;

         vbQueryText := 'ALTER TABLE tmpData ADD COLUMN Value' || vbDayCalc::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
                                          ', ADD COLUMN Summa' || vbDayCalc::Text || ' TFloat NOT NULL DEFAULT 0 ';

         EXECUTE vbQueryText;

         OPEN curResult_next FOR
             SELECT tmpData.UnitID
                  , tmpData.GoodsId
                  , tmpData.AverageSalesRate
                  , tmpData.SettlementStart
                  , tmpData.Distributed
                  , tmpGoods.PriceCalc
             FROM tmpData
                  LEFT JOIN tmpGoods ON tmpGoods.GoodsID = tmpData.GoodsID
             ORDER BY tmpData.AverageSalesRate DESC;
         LOOP
             -- данные по Автозаказ
             FETCH curResult_next INTO vbUnitID
                                     , vbGoodsId
                                     , vbAverageSalesRate
                                     , vbSettlementStart
                                     , vbDistributed
                                     , vbPriceCalc;

             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND THEN EXIT; END IF;

             vbQueryText := 'UPDATE tmpData SET Distributed = '||((vbAverageSalesRate * vbDayCalc - vbSettlementStart)::TFloat)::Text||
                                             ', Value' || vbDayCalc::Text ||' = '|| ABS((vbAverageSalesRate * vbDayCalc - vbSettlementStart)::TFloat)::Text ||
                                             ', Summa' || vbDayCalc::Text ||' = '||  CASE WHEN (vbAverageSalesRate * vbDayCalc - vbSettlementStart) > 0 THEN (((vbAverageSalesRate * vbDayCalc - vbSettlementStart) * vbPriceCalc)::TFloat) ELSE 0 END::Text ||
                            ' WHERE tmpData.UnitID = '||vbUnitID::Text||
                              ' AND tmpData.GoodsId = '||vbGoodsId::Text ;
             EXECUTE vbQueryText;

         END LOOP; -- финиш цикла по курсору2
         CLOSE curResult_next; -- закрыли курсор2.

         vbTotalSummSIP := (SELECT SUM(ROUND(CASE WHEN tmpData.Distributed < 0 THEN 0 ELSE ROUND(tmpData.Distributed, 0) * tmpGoods.PriceCalc END, 2)) FROM tmpData
                            LEFT JOIN tmpGoods ON tmpGoods.GoodsID = tmpData.GoodsID);

     END LOOP;

	 ANALYSE tmpData;

--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

     -- округлили количесто и убрали минусы
     UPDATE tmpData SET Distributed = CASE WHEN Distributed < 0 THEN 0 ELSE ROUND(Distributed, 0) END;

	 ANALYSE tmpData;

--raise notice 'Value 4: %', CLOCK_TIMESTAMP();

     -- Убрали перебор
     OPEN curResult_next FOR
         SELECT tmpData.UnitID
              , tmpData.GoodsId
              , tmpData.AverageSalesRate
              , tmpData.SettlementStart
              , tmpData.Distributed
              , tmpGoods.PriceCalc
         FROM tmpData
              LEFT JOIN tmpGoods ON tmpGoods.GoodsID = tmpData.GoodsID
         ORDER BY tmpData.Distributed DESC, tmpGoods.PriceCalc;
     LOOP
         -- данные по Автозаказ
         FETCH curResult_next INTO vbUnitID
                                 , vbGoodsId
                                 , vbAverageSalesRate
                                 , vbSettlementStart
                                 , vbDistributed
                                 , vbPriceCalc;

         -- если данные закончились, или все кол-во найдено тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         vbQueryText := 'UPDATE tmpData SET Distributed = Distributed - 1'||
                        ' WHERE tmpData.UnitID = '||vbUnitID::Text||
                          ' AND tmpData.GoodsId = '||vbGoodsId::Text ;
         EXECUTE vbQueryText;

         vbTotalSummSIP := (SELECT SUM(ROUND(CASE WHEN tmpData.Distributed < 0 THEN 0 ELSE ROUND(tmpData.Distributed, 0) * tmpGoods.PriceCalc END, 2)) FROM tmpData
                            LEFT JOIN tmpGoods ON tmpGoods.GoodsID = tmpData.GoodsID);

         IF vbTotalSummSIP <= vbTotalSummPrice THEN EXIT; END IF;

     END LOOP; -- финиш цикла по курсору2
     CLOSE curResult_next; -- закрыли курсор2.

	 ANALYSE tmpData;

--raise notice 'Value 5: %', CLOCK_TIMESTAMP();

     -- Результат
     OPEN cur1 FOR SELECT T1.ID||' кол-во' AS AmountName, T1.ID||' сумма' AS SummName
                   FROM (SELECT GENERATE_SERIES (1, vbDayCalc, 1)::TVarChar AS ID) AS T1;
     RETURN NEXT cur1;

     OPEN cur2 FOR
     SELECT Object_Unit.ValueData AS UnitName
          , tmpGoods.GoodsCode
          , tmpGoods.GoodsName
          , tmpGoods.Price
          , tmpGoods.PriceSIP
          , ROUND(tmpData.Distributed * tmpGoods.PriceCalc, 2)::TFloat AS SumDistributed
          , tmpData.*
          , False                                                       AS isErased
     FROM tmpData
          LEFT JOIN tmpGoods ON tmpGoods.GoodsID = tmpData.GoodsID
          LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = tmpData.UnitID
     WHERE tmpData.Distributed > 0
     ORDER BY Object_Unit.ValueData
            , tmpGoods.GoodsName;
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_OrderInternalPromo_DistributionCalculation (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.01.19                                                       *
 11.01.19                                                       *
 09.01.19                                                       *
*/

-- тест
--  
select * from gpReport_OrderInternalPromo_DistributionCalculation(inMovementID := 30412853  , inSession := '3');