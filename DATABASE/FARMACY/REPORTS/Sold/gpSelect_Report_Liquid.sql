-- Function: gpselect_report_liquid(tdatetime, integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpselect_report_liquid(tdatetime, tdatetime,integer, boolean, tvarchar);
DROP FUNCTION IF EXISTS gpselect_report_liquid(tdatetime, integer, boolean, tvarchar);

CREATE OR REPLACE FUNCTION gpselect_report_liquid(
    --IN inmonth tdatetime,
    IN inStartDate     tdatetime,
    IN inEndDate     tdatetime,
    IN inunitid        integer,
    IN inquasischedule boolean,
    IN insession tvarchar)
  RETURNS TABLE(Operdate tdatetime, Unitname tvarchar
              --, Startamount tfloat, Endamount tfloat
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
    CREATE TEMP TABLE _PartDay(
        PlanDate          TDateTime,  --Месяц плана
        DayOfWeek         Integer,    --День в неделе
        UnitId            Integer,
        Part              NUMERIC(20,10)
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
        WITH containerCount AS (SELECT
                                    container.Id as ContainerId
                                  , container.Amount
                                  , container.ObjectID AS GoodsId
                                  , Container.WhereObjectId AS UnitId
                                FROM container
                                WHERE container.descid = zc_container_count()
                                -- AND (Container.WhereObjectId = 183292) -- ( подразделениеАптека_1 пр_Правды_6)
                                  -- AND container.ObjectID = 23968  
                                    AND (Container.WhereObjectId = inUnitId OR inUnitId = 0) 
                              )

          , containerGroup as (select containerCount.GoodsId 
                                    , containerCount.unitid
                                    , Sum(containerCount.Amount) as Amount
                               from containerCount 
                               GROUP BY containerCount.GoodsId 
                                      , containerCount.unitid
                               )

                    
         , MIContainer as ( SELECT  containerCount.UnitId
                                  , containerCount.GoodsID
                                  , case when date_trunc('day', MIContainer.OperDate) between inStartDate and inEndDate then date_trunc('day', MIContainer.OperDate) else zc_DateEnd() End AS operdate 
                                  , COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_Total
                                  
                                FROM  containerCount
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = containerCount.ContainerId
                                                                   AND MIContainer.OperDate  >= inStartDate
                               group by case when date_trunc('day', MIContainer.OperDate) between inStartDate and inEndDate then date_trunc('day', MIContainer.OperDate) else zc_DateEnd() end
                                      , containerCount.GoodsID, containerCount.UnitId
                           )
                

        , tmpRem AS (select tmp.OperDate
                          , tmp.UnitId
                          , Sum (tmp.Amount) AS AmountSum 
                          , Sum (tmp.Amount * Object_Price.Price) :: Tfloat AS SumRem 
                     FROM(
                           select _TIME.PlanDate AS OperDate
                                , containerGroup.GoodsID
                                , containerGroup.UnitId
                                , containerGroup.Amount - COALESCE((select sum (Amount_Total)
                                                                   from MIContainer 
                                                                   where MIContainer.GoodsID = containerGroup.GoodsID 
                                                                     and MIContainer.UnitId  = containerGroup.UnitId 
                                                                     and MIContainer.OperDate >= _TIME.PlanDate)  ,0)     as amount
                           from _TIME
                                left join containerGroup on 1=1
                           ) AS tmp 
                                  LEFT OUTER JOIN Object_Price_View AS Object_Price
                                                                    ON Object_Price.GoodsId = tmp.GoodsID
                                                                   AND Object_Price.UnitId  = tmp.UnitId   
                     group by tmp.OperDate
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


  , tmpMovementCheck AS (SELECT Object_Goods.Id                                           AS GoodsId
                              ,  date_trunc('day', MIContainer.OperDate) AS OperDate
                              , MovementLinkObject_Unit.ObjectId                         AS UnitId
                              , SUM(-MIContainer.Amount*MIFloat_Price.ValueData)::TFloat AS SummaCheck
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
 
                            LEFT OUTER JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Check.ObjectId
                            
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND date_trunc('day', Movement_Check.OperDate) between inStartDate AND inEndDate
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY Object_Goods.Id
                               , MIContainer.OperDate
                               , MovementLinkObject_Unit.ObjectId
                         HAVING SUM(MI_Check.Amount) <> 0 
                       )
                       
          , tmpMovementSale AS (SELECT  date_trunc('day', Movement_Sale.OperDate) AS OperDate
                                      , SUM((COALESCE (MI_Sale.Amount, 0) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))  ::TFloat AS SummaSale      
                                      , MovementLinkObject_Unit.ObjectId  AS UnitId
                                FROM Movement AS Movement_Sale
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                  AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId=0)
                                                                         
                                     INNER JOIN MovementItem AS MI_Sale 
                                                             ON MI_Sale.MovementId = Movement_Sale.Id
                                                            AND MI_Sale.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_Price()  
                                                          
                                 WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                   AND Movement_Sale.StatusId = zc_Enum_Status_Complete() 
                                   AND date_trunc('day', Movement_Sale.OperDate) between inStartDate AND inEndDate
                                 GROUP BY date_trunc('day', Movement_Sale.OperDate)
                                        , MovementLinkObject_Unit.ObjectId 
                      )
                      
          , tmpMovementSend AS (SELECT COALESCE (MovementLinkObject_From.ObjectId, MovementLinkObject_To.ObjectId) AS UnitId
                                     , date_trunc('day', Movement_Send.OperDate) AS OperDate
                                     , SUM((CASE WHEN (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0) * Object_Price_To.Price  ELSE 0 END )::NUMERIC (16, 2))  ::TFloat AS SummaSendIN  
                                     , SUM((CASE WHEN (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0) * Object_Price_From.Price ELSE 0 END )::NUMERIC (16, 2))  ::TFloat AS SummaSendOUT 
                                FROM Movement AS Movement_Send
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId=0)
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0)

                                   INNER JOIN MovementItem AS MovementItem_Send
                                                             ON MovementItem_Send.MovementId = Movement_Send.Id
                                                            AND MovementItem_Send.isErased   = False
      
                                   LEFT OUTER JOIN Object_Price_View AS Object_Price_From
                                                  ON Object_Price_From.GoodsId = MovementItem_Send.ObjectId
                                                 AND Object_Price_From.UnitId = MovementLinkObject_From.ObjectId
                                   LEFT OUTER JOIN Object_Price_View AS Object_Price_To
                                                  ON Object_Price_To.GoodsId = MovementItem_Send.ObjectId
                                                 AND Object_Price_To.UnitId = MovementLinkObject_To.ObjectId

                                 WHERE Movement_Send.DescId = zc_Movement_Send()
                                   AND Movement_Send.StatusId = zc_Enum_Status_Complete() 
                                   AND date_trunc('day', Movement_Send.OperDate) between inStartDate AND inEndDate
                                   AND (MovementItem_Send.Amount) <> 0              
                                 GROUP BY COALESCE (MovementLinkObject_From.ObjectId, MovementLinkObject_To.ObjectId)
                                        , date_trunc('day', Movement_Send.OperDate) 
                     )


 , tmpMovementOrderExternal AS (SELECT MovementLinkObject_To.ObjectId AS UnitId
                                     , date_trunc('day', Movement_OrderExternal.OperDate) AS OperDate
                                     , SUM((COALESCE (MovementItem_OrderExternal.Amount, 0) * Object_Price_To.Price )::NUMERIC (16, 2))  ::TFloat AS SummaOrderExternal  
                                     
                                FROM Movement AS Movement_OrderExternal
                                   
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_OrderExternal.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0)

                                   INNER JOIN MovementItem AS MovementItem_OrderExternal
                                                             ON MovementItem_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                            AND MovementItem_OrderExternal.isErased   = False
      
                                   LEFT OUTER JOIN Object_Price_View AS Object_Price_To
                                                  ON Object_Price_To.GoodsId = MovementItem_OrderExternal.ObjectId
                                                 AND Object_Price_To.UnitId = MovementLinkObject_To.ObjectId

                                 WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                                   AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete() 
                                   AND date_trunc('day', Movement_OrderExternal.OperDate) between inStartDate AND inEndDate
                                   AND (MovementItem_OrderExternal.Amount) <> 0              
                                 GROUP BY MovementLinkObject_To.ObjectId
                                        , date_trunc('day', Movement_OrderExternal.OperDate) 
                     )
                     
 , tmpMovementOrderInternal AS (SELECT MovementLinkObject_Unit.ObjectId                      AS UnitId
                                     , date_trunc('day', Movement_OrderInternal.OperDate)    AS OperDate
                                     , SUM((COALESCE (MovementItem_OrderInternal.Amount, 0) * Object_Price_Unit.Price )::NUMERIC (16, 2))  ::TFloat AS SummaOrderInternal
                                     
                                FROM Movement AS Movement_OrderInternal
                                   
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement_OrderInternal.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                  AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId=0)

                                   INNER JOIN MovementItem AS MovementItem_OrderInternal
                                                             ON MovementItem_OrderInternal.MovementId = Movement_OrderInternal.Id
                                                            AND MovementItem_OrderInternal.isErased   = False
      
                                   LEFT OUTER JOIN Object_Price_View AS Object_Price_Unit
                                                  ON Object_Price_Unit.GoodsId = MovementItem_OrderInternal.ObjectId
                                                 AND Object_Price_Unit.UnitId = MovementLinkObject_Unit.ObjectId

                                 WHERE Movement_OrderInternal.DescId = zc_Movement_OrderInternal()
                                   AND Movement_OrderInternal.StatusId = zc_Enum_Status_Complete() 
                                   AND date_trunc('day', Movement_OrderInternal.OperDate) between inStartDate AND inEndDate
                                   AND (MovementItem_OrderInternal.Amount) <> 0              
                                 GROUP BY MovementLinkObject_Unit.ObjectId
                                        , date_trunc('day', Movement_OrderInternal.OperDate) 
                     )
                     
           

                    SELECT _TIME.PlanDate::TDateTime AS OperDate
                         , Object_Unit.ValueData     ::TVarChar                          AS UnitName
                         , tmpRem.SumRem      ::TFloat AS StartSum
                         , tmpRem.AmountSum                 ::TFloat AS EndSum
                         , tmpMovementIncome.SummaIncome    ::TFloat AS SummaIncome
                         , tmpCheck.SummaCheck              ::TFloat AS SummaCheck
                         , tmpMovementSale.SummaSale        ::TFloat AS SummaSale
                         , tmpMovementSend.SummaSendIN      ::TFloat AS SummaSendIN
                         , tmpMovementSend.SummaSendOut     ::TFloat AS SummaSendOut
                         , tmpMovementOrderExternal.SummaOrderExternal   ::TFloat AS SummaOrderExternal
                         , tmpMovementOrderInternal.SummaOrderInternal   ::TFloat AS  SummaOrderInternal
                         , 0 ::TFloat    AS  SummaReturnIn 
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
                        LEFT JOIN tmpMovementOrderExternal ON tmpMovementOrderExternal.OperDate = _TIME.PlanDate
                                                          AND tmpMovementOrderExternal.UnitId   = Object_Unit.Id  
                        LEFT JOIN tmpMovementOrderInternal ON tmpMovementOrderInternal.OperDate = _TIME.PlanDate
                                                          AND tmpMovementOrderInternal.UnitId   = Object_Unit.Id                                                   

                        LEFT JOIN tmpRem ON tmpRem.OperDate = _TIME.PlanDate
                                        AND tmpRem.UnitId   = Object_Unit.Id  
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
