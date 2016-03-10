-- Function: gpSELECT_report_liquid(tdatetime, integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpSELECT_report_liquid(tdatetime, tdatetime,integer, boolean, tvarchar);
DROP FUNCTION IF EXISTS gpSELECT_report_liquid(tdatetime, integer, boolean, tvarchar);

CREATE OR REPLACE FUNCTION gpSELECT_report_liquid(
    --IN inmonth tdatetime,
    IN inStartDate     tdatetime,
    IN inEndDate       tdatetime,
    IN inunitid        integer,
    IN inquasischedule boolean,
    IN insession tvarchar)
  RETURNS TABLE(Operdate tdatetime, Unitname tvarchar
              , Startsum tfloat
              , EndSum tfloat
              , Summaincome tfloat
              , SummaCheck tfloat
              , SummaSale tfloat
              , SummaSendIN tfloat
              , SummaSendOut tfloat
              , SummaOrderExternal tfloat
              , SummaOrderInternal tfloat
              , SummaReturnIn tfloat
) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbTmpDate TDateTime;
   DECLARE vbDayInMonth TFloat;
BEGIN
    vbStartDate := inStartDate;--date_trunc('month', inMonth);
    vbEndDate := inEndDate ;--date_trunc('month', inMonth) + Interval '1 MONTH';
    vbDayInMonth := (DATE_PART('day', (vbEndDate  - vbStartDate)))::TFloat;
    
    
    CREATE TEMP TABLE _TIME(
        PlanDate          TDateTime,  --Месяц плана
        DayOfWeek         Integer,    --День в неделе
        CountDay          NUMERIC(20,10)    --кол-во дней(понедельников / вторников) в месяце 
        ) ON COMMIT DROP;
    
    --Заполняем днями пусографку
    vbTmpDate := inStartDate;
    WHILE vbTmpDate <= inEndDate
    LOOP
        INSERT INTO _TIME(PlanDate,DayOfWeek)
        VALUES(vbTmpDate, date_part('dow', vbTmpDate));
        vbTmpDate := vbTmpDate + INTERVAL '1 DAY';
    END LOOP;
    
    UPDATE _TIME SET 
        CountDay = (SELECT COUNT(*) FROM _TIME AS T1 WHERE T1.DayOfWeek = _TIME.DayOfWeek);
    
       
    RETURN QUERY
        WITH 
           tmpPrice as( SELECT ObjectLink_Price_Unit.ChildObjectId                           AS UnitId
                             , Price_Goods.ChildObjectId                                     AS GoodsId
                             , ROUND(Price_Value.ValueData,2)::TFloat                        AS Price
                             --, COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) :: Tfloat AS MCSValue
                             , MCS_Value.ValueData                                           AS MCSValue
                        FROM Object AS Object_Price
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = Object_Price.Id
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                           INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                               AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()      
                                             --    AND (ObjectLink_Price_Unit.ChildObjectId =183292      OR 1 = 0)
                                               AND (ObjectLink_Price_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
                           
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = Object_Price.Id
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = Object_Price.Id
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()   
                                   
                 
                           -- получаем значения цены и НТЗ из истории значений на дату                                                           
                           /*LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                   ON ObjectHistory_Price.ObjectId = Object_Price.Id 
                                                  AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                  AND inStartDate >= ObjectHistory_Price.StartDate AND inStartDate < ObjectHistory_Price.EndDate
                           
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                                        ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory_Price.Id
                                                       AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue() */
                        WHERE  Object_Price.DescId = zc_Object_Price()
                        
                       )

        ,    ContainerCount AS (SELECT
                                    Container.Id as ContainerId
                                  , Container.Amount
                                  , Container.ObjectID AS GoodsId
                                  , Container.WhereObjectId AS UnitId
                                FROM Container
                                WHERE Container.descid = zc_container_count()
                                  AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                                
                              )

          , ContainerGroup as (SELECT containerCount.GoodsId 
                                    , containerCount.unitid
                                    , Sum(containerCount.Amount) as Amount
                               FROM containerCount 
                               where containerCount.Amount <> 0
                               GROUP BY containerCount.GoodsId 
                                      , containerCount.unitid
                               )

       , ContainerGroupSUM AS (SELECT ContainerGroup.unitid
                                    , SUM(ContainerGroup.Amount* tmpPrice.Price) as AmountSum
                               FROM ContainerGroup
                                 LEFT JOIN tmpPrice ON tmpPrice.GoodsId = ContainerGroup.GoodsID
                                                   AND tmpPrice.UnitId  = ContainerGroup.UnitId
                               GROUP BY ContainerGroup.unitid
                               )          
           
         , MIContainer as ( SELECT  containerCount.UnitId
                                  , containerCount.GoodsID
                                  , case when date_trunc('day', MIContainer.OperDate) between inStartDate and inEndDate then date_trunc('day', MIContainer.OperDate) else zc_DateEnd() End AS operdate 
                                  , COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_Total
                                  
                                FROM ContainerCount
                                    inner JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = containerCount.ContainerId
                                                                   AND MIContainer.OperDate  >= inStartDate
                            --   where  1=0
                               GROUP BY case when date_trunc('day', MIContainer.OperDate) between inStartDate and inEndDate then date_trunc('day', MIContainer.OperDate) else zc_DateEnd() end
                                      , containerCount.GoodsID, containerCount.UnitId
                                     HAVING SUM (MIContainer.Amount) <> 0
                               
                           )
                
         , MIContainerSUM as ( SELECT  MIContainer.UnitId
                                     , MIContainer.operdate 
                                     , SUM (MIContainer.Amount_Total * tmpPrice.Price) AS TotalSum
                                FROM MIContainer
                                    LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MIContainer.GoodsID
                                                      AND tmpPrice.UnitId  = MIContainer.UnitId
                               
                               GROUP BY MIContainer.UnitId, MIContainer.operdate 
                           )

        
  , tmpGoodsMotion AS (SELECT rr.UnitId, rr.GoodsID
                             , tmpPrice.Price
                             , tmpPrice.MCSValue
                       FROM 
                          (SELECT DISTINCT
                                  MIContainer.UnitId
                                , MIContainer.GoodsID
                           FROM MIContainer
                         UNION
                           SELECT DISTINCT
                                  ContainerGroup.UnitId
                                , ContainerGroup.GoodsID
                           FROM ContainerGroup
                          ) AS rr 
                           INNER JOIN tmpPrice ON tmpPrice.GoodsId = rr.GoodsID
                                              AND tmpPrice.UnitId = rr.UnitId 
                                              AND tmpPrice.MCSValue >0   
                      limit 10000)
      
  -- расчет возврата (НТЗ)
        , tmp AS (SELECT  tmp.OperDate
                        , tmp.UnitId
                        , SUM ((tmp.Remains - tmp.MCSValue) * tmp.Price)  AS AmountNotMCS
                  FROM (SELECT  _TIME.PlanDate AS OperDate
                             , tmpGoodsMotion.UnitId
                             , tmpGoodsMotion.GoodsID
                             , tmpGoodsMotion.Price
                             , tmpGoodsMotion.MCSValue
                             , COALESCE (ContainerGroup.Amount ,0) - COALESCE((SELECT sum (MIContainer.Amount_Total)
                                                                               FROM MIContainer  
                                                                               WHERE MIContainer.UnitId  = containerGroup.UnitId 
                                                                                 AND MIContainer.GoodsID = containerGroup.GoodsID
                                                                                 AND MIContainer.OperDate >= _TIME.PlanDate), 0) as Remains
                        FROM tmpGoodsMotion 
                            LEFT JOIN (select * from _TIME limit 40) as _TIME ON 1=1
                            LEFT JOIN ContainerGroup ON ContainerGroup.UnitId = tmpGoodsMotion.UnitId
                                                   AND ContainerGroup.GoodsID = tmpGoodsMotion.GoodsID
                       WHERE 1=0   
                        ) AS tmp
                  WHERE tmp.Remains > 0
                  GROUP BY  tmp.OperDate
                          , tmp.UnitId
                                                   
                    )

     /*   , tmpNTZ AS (SELECT tmpGoodsMotion.UnitId
                          , Sum ((tmpPrice.MCSValue) * tmpPrice.Price) :: Tfloat AS SumRemMCS 
                     FROM tmpPrice 
                          inner join tmpGoodsMotion ON tmpGoodsMotion.UnitId = tmpPrice.UnitId
                                                   AND tmpGoodsMotion.GoodsID = tmpPrice.GoodsID
                     GROUP BY tmpGoodsMotion.UnitId
                    )
*/
        , tmpRem AS (SELECT tmp.OperDate
                          , tmp.UnitId
                          , Sum (tmp.AmountSUM) :: Tfloat AS AmountSum 
                         -- , Sum (tmp.AmountSUM - tmpNTZ.SumRemMCS)  :: Tfloat AS SumRemMCS 
                     FROM(
                           SELECT _TIME.PlanDate AS OperDate
                                , ContainerGroupSUM.UnitId
                                , ContainerGroupSUM.AmountSum - COALESCE((SELECT sum (TotalSum)
                                                                          FROM MIContainerSUM 
                                                                          where MIContainerSUM.UnitId  = containerGroupSum.UnitId 
                                                                            and MIContainerSUM.OperDate >= _TIME.PlanDate)  ,0)   AS AmountSUM
                           FROM _TIME
                                left join ContainerGroupSUM on 1=1
                           ) AS tmp 
                               -- LEFT JOIN tmpNTZ ON tmpNTZ.UnitId = tmp.UnitId
                                
                     GROUP BY tmp.OperDate
                            , tmp.UnitId
                    )

       ,      tmpMovementIncome AS (SELECT  date_trunc('day', MovementDate_Branch.ValueData) AS BranchDate
                                            , SUM((COALESCE (MI_Income.Amount, 0) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))  ::TFloat AS SummaIncome      
                                            , MovementLinkObject_To.ObjectId AS UnitId
                                FROM Movement AS Movement_Income
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0)
                                     INNER JOIN MovementDate AS MovementDate_Branch
                                                             ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                            AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                            AND date_trunc('day', MovementDate_Branch.ValueData) between inStartDate AND inEndDate
                                      
                                     INNER JOIN MovementItem AS MI_Income 
                                                             ON MI_Income.MovementId = Movement_Income.Id
                                                            AND MI_Income.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()  
                                                          
                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete() 
                                 GROUP BY date_trunc('day', MovementDate_Branch.ValueData)
                                        , MovementLinkObject_To.ObjectId
                              )                          
 
 , tmpMovementCheck AS (SELECT  date_trunc('day', MIContainer.OperDate) AS OperDate
                              , MovementLinkObject_Unit.ObjectId                         AS UnitId
                              , SUM(COALESCE(-MIContainer.Amount,0)*MIFloat_Price.ValueData)::TFloat AS SummaCheck
                         FROM Movement AS Movement_Check
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId=0)
                            INNER JOIN MovementItem AS MI_Check
                                    ON MI_Check.MovementId = Movement_Check.Id
                                   AND MI_Check.DescId = zc_MI_Master()
                                   AND MI_Check.isErased = FALSE
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MI_Check.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.MovementItemId = MI_Check.Id
                                                 AND MIContainer.DescId = zc_MIContainer_Count() 
                            LEFT OUTER JOIN Container ON MIContainer.ContainerId = Container.Id
                                     AND Container.DescId = zc_Container_Count()
 
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND date_trunc('day', Movement_Check.OperDate) between inStartDate AND inEndDate
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MIContainer.OperDate
                                , MovementLinkObject_Unit.ObjectId
                         HAVING SUM(MI_Check.Amount) <> 0 
                       )


          , tmpDescMovement AS (SELECT zc_Movement_Sale() AS DescMovementId
                               UNION
                                SELECT zc_Movement_OrderInternal() AS DescMovementId
                               UNION
                                SELECT zc_Movement_OrderExternal() AS DescMovementId
                               )             
          , tmpMovementSale AS (SELECT  date_trunc('day', Movement.OperDate) AS OperDate
                                      , MovementLinkObject_Unit.ObjectId  AS UnitId
                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_Sale() THEN (COALESCE (MovementItem.Amount, 0) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2) ELSE 0 END)  ::TFloat AS SummaSale      
                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_OrderInternal() THEN (COALESCE (MovementItem.Amount, 0) * tmpPrice.Price )::NUMERIC (16, 2) ELSE 0 END)  ::TFloat AS SummaOrderInternal
                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_OrderExternal() THEN (COALESCE (MovementItem.Amount, 0) * tmpPrice.Price )::NUMERIC (16, 2) ELSE 0 END)  ::TFloat AS SummaOrderExternal
                                FROM tmpDescMovement
                                     INNER JOIN Movement ON Movement.DescId = tmpDescMovement.DescMovementId
                                                       AND Movement.StatusId = zc_Enum_Status_Complete() 
                                                       AND date_trunc('day', Movement.OperDate) between inStartDate AND inEndDate
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Unit.DescId = CASE WHEN  Movement.DescId = zc_Movement_OrderExternal() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_Unit() END
                                                                  AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId=0)
                                                                         
                                     INNER JOIN MovementItem AS MovementItem
                                                             ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_Price()  
                                     
                                     LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                                                       AND tmpPrice.UnitId = MovementLinkObject_Unit.ObjectId
                                                           
                                 GROUP BY date_trunc('day', Movement.OperDate)
                                        , MovementLinkObject_Unit.ObjectId 
                      )
                      
          , tmpMovementSend AS (SELECT COALESCE (MovementLinkObject_FROM.ObjectId, MovementLinkObject_To.ObjectId) AS UnitId
                                     , date_trunc('day', Movement_Send.OperDate) AS OperDate
                                     , SUM((CASE WHEN (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0) * Object_Price_To.Price  ELSE 0 END )::NUMERIC (16, 2))  ::TFloat AS SummaSendIN  
                                     , SUM((CASE WHEN (MovementLinkObject_FROM.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0) * Object_Price_FROM.Price ELSE 0 END )::NUMERIC (16, 2))  ::TFloat AS SummaSendOUT 
                                FROM Movement AS Movement_Send
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_FROM
                                                                   ON MovementLinkObject_FROM.MovementId = Movement_Send.Id
                                                                  AND MovementLinkObject_FROM.DescId = zc_MovementLinkObject_FROM()
                                                                  AND (MovementLinkObject_FROM.ObjectId = inUnitId OR inUnitId=0)
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0)

                                   INNER JOIN MovementItem AS MovementItem_Send
                                                             ON MovementItem_Send.MovementId = Movement_Send.Id
                                                            AND MovementItem_Send.isErased   = False
      
                                   LEFT OUTER JOIN Object_Price_View AS Object_Price_FROM
                                                  ON Object_Price_FROM.GoodsId = MovementItem_Send.ObjectId
                                                 AND Object_Price_FROM.UnitId = MovementLinkObject_FROM.ObjectId
                                   LEFT OUTER JOIN Object_Price_View AS Object_Price_To
                                                  ON Object_Price_To.GoodsId = MovementItem_Send.ObjectId
                                                 AND Object_Price_To.UnitId = MovementLinkObject_To.ObjectId

                                 WHERE Movement_Send.DescId = zc_Movement_Send()
                                   AND Movement_Send.StatusId = zc_Enum_Status_Complete() 
                                   AND date_trunc('day', Movement_Send.OperDate) between inStartDate AND inEndDate
                                   AND (MovementItem_Send.Amount) <> 0              
                                 GROUP BY COALESCE (MovementLinkObject_FROM.ObjectId, MovementLinkObject_To.ObjectId)
                                        , date_trunc('day', Movement_Send.OperDate) 
                     )
           

                    SELECT _TIME.PlanDate::TDateTime AS OperDate
                         , Object_Unit.ValueData     ::TVarChar                          AS UnitName
                         , tmpRem.AmountSum      ::TFloat AS StartSum                     --SumRem
                         , tmpRem.AmountSum                 ::TFloat AS EndSum
                         , tmpMovementIncome.SummaIncome    ::TFloat AS SummaIncome
                         , tmpCheck.SummaCheck              ::TFloat AS SummaCheck
                         , tmpMovementSale.SummaSale        ::TFloat AS SummaSale
                         , tmpMovementSend.SummaSendIN      ::TFloat AS SummaSendIN
                         , tmpMovementSend.SummaSendOut     ::TFloat AS SummaSendOut
                         , tmpMovementSale.SummaOrderExternal   ::TFloat AS SummaOrderExternal
                         , tmpMovementSale.SummaOrderInternal   ::TFloat AS SummaOrderInternal
                         , tmp.AmountNotMCS                     ::TFloat AS  SummaReturnIn 
                    FROM _TIME
                        LEFT JOIN Object AS Object_Unit ON 1=1
                                        AND Object_Unit.DescId = zc_Object_Unit()
                                        AND (Object_Unit.Id = inUnitId OR inUnitId=0) 
                      
                        LEFT JOIN tmpMovementIncome ON tmpMovementIncome.BranchDate = _TIME.PlanDate
                                                   AND tmpMovementIncome.UnitId     = Object_Unit.Id
                        LEFT JOIN (SELECT tmpMovementCheck.OperDate
                                         , tmpMovementCheck.UnitId
                                         , SUM (tmpMovementCheck.SummaCheck) AS SummaCheck
                                    FROM tmpMovementCheck 
                                    GROUP BY tmpMovementCheck.OperDate
                                           , tmpMovementCheck.UnitId
                                    ) AS tmpCheck ON tmpCheck.OperDate = _TIME.PlanDate
                                                AND tmpCheck.UnitId    = Object_Unit.Id
                        LEFT JOIN tmpMovementSale ON tmpMovementSale.OperDate = _TIME.PlanDate
                                                 AND tmpMovementSale.UnitId   = Object_Unit.Id   
                        LEFT JOIN tmpMovementSend ON tmpMovementSend.OperDate = _TIME.PlanDate
                                                 AND tmpMovementSend.UnitId   = Object_Unit.Id  
                       
                        LEFT JOIN tmpRem ON tmpRem.OperDate = _TIME.PlanDate
                                        AND tmpRem.UnitId   = Object_Unit.Id
                        LEFT JOIN tmp ON tmp.OperDate = _TIME.PlanDate
                                     AND tmp.UnitId   = Object_Unit.Id
                        --LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Coalesce(tmpRemains.UnitId,tmpMovementIncome.UnitId ) 


;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 03.02.16         * 
*/

--select * from gpSelect_Report_Liquid(inStartDate := ('01.12.2015')::TDateTime , inEndDate := ('03.12.2015')::TDateTime , inUnitId := 183292 , inQuasiSchedule := 'False' ,  inSession := '3');