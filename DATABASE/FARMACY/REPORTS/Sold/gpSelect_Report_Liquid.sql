-- Function: gpselect_report_liquid(tdatetime, tdatetime, integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpSELECT_report_liquid(tdatetime, tdatetime,integer, boolean, tvarchar);
DROP FUNCTION IF EXISTS gpSELECT_report_liquid(tdatetime, integer, boolean, tvarchar);

CREATE OR REPLACE FUNCTION gpselect_report_liquid(
    IN instartdate tdatetime,
    IN inenddate tdatetime,
    IN inunitid integer,
    IN inquasischedule boolean,
    IN insession tvarchar)
 RETURNS TABLE(operdate tdatetime
             , unitname tvarchar
             , startsum tfloat
             , endsum tfloat
             , PersentCheck tfloat
             , SummaJuridical tfloat
             , SummaJuridicalEnd tfloat
             , summaincome tfloat
             , SummaJuridicalIncome tfloat
             , summacheck tfloat
             , summasale tfloat
             , summasendin tfloat
             , summasendout tfloat
             , summaDocsendin tfloat
             , summaDocsendout tfloat
             , summaorderexternal tfloat
             , summaorderinternal tfloat
             , summaDocorderexternal tfloat
             , summaDocorderinternal tfloat
             , summareturnin tfloat
             , MCSPeriod tfloat
             , MCSDay tfloat
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
        PlanDate          TDateTime,  --����� �����
        DayOfWeek         Integer,    --���� � ������
        CountDay          NUMERIC(20,10)    --���-�� ����(������������� / ���������) � ������ 
        ) ON COMMIT DROP;
    
    --��������� ����� ����������
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

   tmpUnit AS (SELECT Object_Unit.Id       AS UnitId 
               FROM Object AS Object_Unit
               WHERE Object_Unit.DescId = zc_Object_Unit()
                 AND (Object_Unit.Id = inUnitId OR inUnitId = 0)
          --     LIMIT 5
               )
        
        , tmpPrice AS ( SELECT ObjectLink_Price_Unit.ChildObjectId      AS UnitId
                             , Price_Goods.ChildObjectId                AS GoodsId
                             , ObjectLink_Price_Unit.ObjectId           AS PriceId 
                        FROM tmpUnit
                           
                           LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                ON ObjectLink_Price_Unit.ChildObjectId = tmpUnit.UnitId
                                               AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()      
                                                                       
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods() 
                         WHERE COALESCE (Price_Goods.ChildObjectId,0) <> 0 and COALESCE (ObjectLink_Price_Unit.ObjectId,0) <> 0 
                      )

        ,    ContainerCount AS (SELECT
                                    Container.Id as ContainerId
                                  , Container.Amount
                                  , Container.ObjectID AS GoodsId
                                  , Container.WhereObjectId AS UnitId
                                  , COALESCE (MI_Income_find.Id, MI_Income.Id)         :: Integer AS MovementItemId
                                FROM tmpUnit
                                    LEFT JOIN Container ON Container.WhereObjectId = tmpUnit.UnitId 
                                    -- ������  -- ��� ��������� ��������� ���� �������
                                    LEFT OUTER JOIN ContainerLinkObject AS CLO_MI 
                                                                        ON CLO_MI.ContainerId = container.Id
                                                                       AND CLO_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MI.ObjectId
                                    -- ������� �������
                                    LEFT OUTER JOIN MovementItem AS MI_Income
                                                                 ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                                                 
                                    -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                    
                                WHERE Container.descid = zc_container_count()
                                  --AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                                
                              )

          , ContainerGroup as (SELECT containerCount.GoodsId 
                                    , containerCount.unitid
                                    , Sum(containerCount.Amount) as Amount
                                    , Sum(containerCount.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0)) as SummaJuridical
                               FROM containerCount 
                                    -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� NULL)
                                    LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                                ON MIFloat_JuridicalPrice.MovementItemId = ContainerCount.MovementItemId
                                                               AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()                                
                                    
                               where containerCount.Amount <> 0
                               GROUP BY containerCount.GoodsId 
                                      , containerCount.unitid
                               )

    
         , MIContainer as ( SELECT  containerCount.UnitId
                                  , containerCount.GoodsID
                                  , case when date_trunc('day', MIContainer.OperDate) between inStartDate and inEndDate then date_trunc('day', MIContainer.OperDate) else zc_DateEnd() End AS operdate 
                                  , COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_Total
                                  , COALESCE (SUM (COALESCE (MIContainer.Amount, 0) * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ) , 0)  AS SummaJuridical
                                FROM ContainerCount
                                    INNER JOIN MovementItemContainer AS MIContainer 
                                                                     ON MIContainer.ContainerId = containerCount.ContainerId
                                                                    AND MIContainer.OperDate  >= DATE_TRUNC ('DAY', inStartDate)
                                                                    
                                    -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� NULL)
                                    LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                                ON MIFloat_JuridicalPrice.MovementItemId = ContainerCount.MovementItemId
                                                               AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()                                
                                    
                               GROUP BY case when date_trunc('day', MIContainer.OperDate) between inStartDate and inEndDate then date_trunc('day', MIContainer.OperDate) else zc_DateEnd() end
                                      , ContainerCount.GoodsID
                                      , ContainerCount.UnitId
                                     HAVING SUM (MIContainer.Amount) <> 0
                           )
                
        
  , tmpGoodsMotion AS (SELECT _TIME.PlanDate AS OperDate
                            , tmpGoods.UnitId, tmpGoods.GoodsID
                            , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)  AS Price
                            , COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)  AS PriceEnd
                            , COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0) AS MCSValueEnd
                            , tmpGoods.Amount
                            , tmpGoods.SummaJuridical
                       FROM 
                      (SELECT tmpGoods.UnitId, tmpGoods.GoodsID, tmpPrice.PriceId
                            , SUM (tmpGoods.Amount) AS Amount
                            , SUM (tmpGoods.SummaJuridical) AS SummaJuridical
                       FROM (SELECT DISTINCT
                                    MIContainer.UnitId
                                  , MIContainer.GoodsID
                                  , 0 AS Amount
                                  , 0 AS SummaJuridical
                             FROM MIContainer
                            UNION ALL
                             SELECT ContainerGroup.UnitId
                                  , ContainerGroup.GoodsID
                                  , ContainerGroup.Amount
                                  , ContainerGroup.SummaJuridical
                             FROM ContainerGroup
                            ) AS tmpGoods 
                            left JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsID
                                               AND tmpPrice.UnitId = tmpGoods.UnitId 
                       GROUP BY tmpGoods.UnitId, tmpGoods.GoodsID, tmpPrice.PriceId
                      ) AS tmpGoods 
                      INNER JOIN _TIME ON 1=1
                           -- �������� �������� ���� � ��� �� ������� �������� �� ���� �� ������                                                          
                           LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                   ON ObjectHistory_Price.ObjectId = tmpGoods.PriceId
                                                  AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                  AND _TIME.PlanDate >= ObjectHistory_Price.StartDate AND _TIME.PlanDate < ObjectHistory_Price.EndDate
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                        ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()

                           -- �������� �������� ���� � ��� �� ������� �������� �� ���� �� ����� ���                                                          
                           LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                                   ON ObjectHistory_PriceEnd.ObjectId = tmpGoods.PriceId
                                                  AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                                  AND _TIME.PlanDate+interval '1 day' >= ObjectHistory_PriceEnd.StartDate AND _TIME.PlanDate + interval '1 day' < ObjectHistory_PriceEnd.EndDate
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceEnd
                                                        ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                                        AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()

                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValueEnd
                                                        ON ObjectHistoryFloat_MCSValueEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                                       AND ObjectHistoryFloat_MCSValueEnd.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                         
                      )
      
  -- ������ �������� (���)
     , tmpNTZ AS (SELECT  tmp.OperDate
                        , tmp.UnitId
                        , SUM ((tmp.Remains) * tmp.Price)  AS AmountRem
                        , SUM ((tmp.RemainsEnd) * tmp.PriceEnd)  AS AmountRemEnd
                        , SUM (CASE WHEN (tmp.RemainsEnd > tmp.MCSValueEnd) THEN ((tmp.RemainsEnd - tmp.MCSValueEnd) * tmp.PriceEnd) ELSE 0 END) AS AmountNotMCS
                        , SUM (tmp.SummaJuridical)     AS SummaJuridicalRemains
                        , SUM (tmp.SummaJuridicalEnd)  AS SummaJuridicalRemainsEnd

                  FROM  (SELECT tmpGoodsMotion.OperDate
                             , tmpGoodsMotion.UnitId
                             , tmpGoodsMotion.GoodsID
                             , tmpGoodsMotion.Price
                             , tmpGoodsMotion.PriceEnd
                             , tmpGoodsMotion.MCSValueEnd
                             , tmpGoodsMotion.Amount  - COALESCE (sum (COALESCE (MIContainer.Amount_Total, 0)))  AS Remains
                             , tmpGoodsMotion.Amount  - SUM (CASE WHEN MIContainer.OperDate > tmpGoodsMotion.OperDate THEN COALESCE (MIContainer.Amount_Total, 0) ELSE 0 END) AS RemainsEnd
                             , tmpGoodsMotion.SummaJuridical  - COALESCE (sum (COALESCE (MIContainer.SummaJuridical, 0)))  AS SummaJuridical
                             , tmpGoodsMotion.SummaJuridical  - SUM (CASE WHEN MIContainer.OperDate > tmpGoodsMotion.OperDate THEN COALESCE (MIContainer.SummaJuridical, 0) ELSE 0 END) AS SummaJuridicalEnd
                             
                        FROM tmpGoodsMotion
                             LEFT JOIN MIContainer ON MIContainer.UnitId  = tmpGoodsMotion.UnitId 
                                                  AND MIContainer.GoodsID = tmpGoodsMotion.GoodsID
                                                  AND MIContainer.OperDate >= tmpGoodsMotion.OperDate
                        GROUP BY tmpGoodsMotion.OperDate
                             , tmpGoodsMotion.UnitId
                             , tmpGoodsMotion.GoodsID
                             , tmpGoodsMotion.Price
                             , tmpGoodsMotion.PriceEnd
                             , tmpGoodsMotion.MCSValueEnd
                             , tmpGoodsMotion.Amount
                             , tmpGoodsMotion.SummaJuridical
                        ) AS tmp
                  GROUP BY tmp.OperDate
                         , tmp.UnitId
                   )

  
       ,  tmpMovementIncome AS (SELECT  date_trunc('day', MovementDate_Branch.ValueData) AS BranchDate
                                            , SUM((COALESCE (MI_Income.Amount, 0) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))   AS SummaIncome      
                                            , SUM (COALESCE (MI_Income.Amount, 0) * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS SummaJuridical
                                            , MovementLinkObject_To.ObjectId AS UnitId
                                FROM Movement AS Movement_Income
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  --AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0)
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                                     
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
                                     -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� NULL)
                                     LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                                 ON MIFloat_JuridicalPrice.MovementItemId = MI_Income.Id
                                                                AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                                          
                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete() 
                                 GROUP BY date_trunc('day', MovementDate_Branch.ValueData)
                                        , MovementLinkObject_To.ObjectId
                              )                          
 
 , tmpMovementCheck AS (SELECT  date_trunc('day', MIContainer.OperDate) AS OperDate
                              , MovementLinkObject_Unit.ObjectId                         AS UnitId
                              , SUM(COALESCE(-MIContainer.Amount,0)*MIFloat_Price.ValueData) AS SummaCheck
                         FROM Movement AS Movement_Check
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                       --AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId=0)
                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                            
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
                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_Sale() THEN (COALESCE (MovementItem.Amount, 0) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2) ELSE 0 END)   AS SummaSale      
                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_OrderInternal() THEN ((COALESCE (MovementItem.Amount, 0)+ COALESCE(MIFloat_AmountSecond.ValueData,0)) * tmpGoodsMotion.Price )::NUMERIC (16, 2) ELSE 0 END)   AS SummaOrderInternal
                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_OrderExternal() THEN (COALESCE (MovementItem.Amount, 0) * tmpGoodsMotion.Price )::NUMERIC (16, 2) ELSE 0 END)   AS SummaOrderExternal

                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_OrderInternal() THEN ((COALESCE (MovementItem.Amount, 0)+ COALESCE(MIFloat_AmountSecond.ValueData,0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2) ELSE 0 END)   AS SummaDocOrderInternal
                                      , SUM( CASE WHEN Movement.DescId = zc_Movement_OrderExternal() THEN (COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData)::NUMERIC (16, 2) ELSE 0 END)   AS SummaDocOrderExternal
                                      
                                FROM tmpDescMovement
                                     INNER JOIN Movement ON Movement.DescId = tmpDescMovement.DescMovementId
                                                       AND Movement.StatusId = zc_Enum_Status_Complete() 
                                                       AND date_trunc('day', Movement.OperDate) between inStartDate AND inEndDate
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Unit.DescId = CASE WHEN  Movement.DescId = zc_Movement_OrderExternal() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_Unit() END
                                                                  --AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId=0)
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                     INNER JOIN MovementItem AS MovementItem
                                                             ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_Price()  

                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                 ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()  
                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                    
                                     LEFT JOIN tmpGoodsMotion ON tmpGoodsMotion.GoodsId = MovementItem.ObjectId
                                                             AND tmpGoodsMotion.UnitId = MovementLinkObject_Unit.ObjectId
                                                             AND tmpGoodsMotion.OperDate = date_trunc('day', Movement.OperDate)
                                 GROUP BY date_trunc('day', Movement.OperDate)
                                        , MovementLinkObject_Unit.ObjectId 
                      )
                      
          , tmpMovementSend AS (SELECT COALESCE (MovementLinkObject_FROM.ObjectId, MovementLinkObject_To.ObjectId) AS UnitId
                                     , date_trunc('day', Movement_Send.OperDate) AS OperDate
                                     , SUM((CASE WHEN (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0)   * tmpGoodsMotionTo.Price   ELSE 0 END )::NUMERIC (16, 2))  AS SummaSendIN  
                                     , SUM((CASE WHEN (MovementLinkObject_FROM.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0) * tmpGoodsMotionFrom.Price ELSE 0 END )::NUMERIC (16, 2))  AS SummaSendOUT 
                                     , SUM((CASE WHEN (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0)   * MIFloat_Price.ValueData ELSE 0 END )::NUMERIC (16, 2))   AS SummaDocSendIN  
                                     , SUM((CASE WHEN (MovementLinkObject_FROM.ObjectId = inUnitId OR inUnitId=0) THEN COALESCE (MovementItem_Send.Amount, 0) * MIFloat_Price.ValueData ELSE 0 END )::NUMERIC (16, 2))  AS SummaDocSendOUT
                                FROM Movement AS Movement_Send
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_FROM
                                                                   ON MovementLinkObject_FROM.MovementId = Movement_Send.Id
                                                                  AND MovementLinkObject_FROM.DescId = zc_MovementLinkObject_FROM()
                                   --                               AND (MovementLinkObject_FROM.ObjectId = inUnitId OR inUnitId=0)
                                   LEFT JOIN tmpUnit AS tmpUnitFrom ON tmpUnitFrom.UnitId = MovementLinkObject_FROM.ObjectId 
                                   
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  --AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId=0)
                                   LEFT JOIN tmpUnit AS tmpUnitTo ON tmpUnitTo.UnitId = MovementLinkObject_To.ObjectId

                                   LEFT JOIN MovementItem AS MovementItem_Send
                                                             ON MovementItem_Send.MovementId = Movement_Send.Id
                                                            AND MovementItem_Send.isErased   = False

                                   LEFT OUTER JOIN MovementItemContainer AS MIContainer_Count
                                                      ON MIContainer_Count.MovementItemId = MovementItem_Send.Id 
                                                     AND MIContainer_Count.DescId = zc_Container_Count()
                                                     AND MIContainer_Count.isActive = True

                                   LEFT OUTER  JOIN ContainerLinkObject AS CLI_MI 
                                                    ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                   AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                   LEFT OUTER  JOIN OBJECT AS Object_PartionMovementItem 
                                                           ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                   LEFT OUTER  JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                                   LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                 
                                   LEFT JOIN tmpGoodsMotion AS tmpGoodsMotionFrom
                                                            ON tmpGoodsMotionFrom.GoodsId =MovementItem_Send.ObjectId
                                                           AND tmpGoodsMotionFrom.UnitId = MovementLinkObject_FROM.ObjectId
                                                           AND tmpGoodsMotionFrom.OperDate = date_trunc('day', Movement_Send.OperDate)

                                   LEFT JOIN tmpGoodsMotion AS tmpGoodsMotionTo
                                                            ON tmpGoodsMotionTo.GoodsId = MovementItem_Send.ObjectId
                                                           AND tmpGoodsMotionTo.UnitId = MovementLinkObject_To.ObjectId
                                                           AND tmpGoodsMotionTo.OperDate = date_trunc('day', Movement_Send.OperDate)            

                                 WHERE Movement_Send.DescId = zc_Movement_Send()
                                   AND Movement_Send.StatusId = zc_Enum_Status_Complete() 
                                   AND date_trunc('day', Movement_Send.OperDate) between inStartDate AND inEndDate
                                   AND (MovementItem_Send.Amount) <> 0        
                                    and ( COALESCE(MovementLinkObject_FROM.ObjectId,0)<>0 OR COALESCE(MovementLinkObject_To.ObjectId,0)<>0)      
                                 GROUP BY COALESCE (MovementLinkObject_FROM.ObjectId, MovementLinkObject_To.ObjectId)
                                        , date_trunc('day', Movement_Send.OperDate) 
                     )

 -- ���������� �������� � - ������ �������*** , � - ����� ����**    
, tmpListMCSPeriodDay AS (SELECT ObjectHistory_Price.StartDate
                              , _TIME.PlanDate as  OperDate
                              , tmpPrice.UnitId, tmpPrice.GoodsID
                              , COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)    AS MCSPeriod
                              , COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)       AS MCSDay
                          FROM tmpPrice 
                           LEFT JOIN _TIME ON 1=1       
                          -- �������� �������� ���� � ��� �� ������� �������� �� ���� �� ������                                                          
                           LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                   ON ObjectHistory_Price.ObjectId = tmpPrice.PriceId
                                                  AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                  --AND  ObjectHistory_Price.StartDate >=_TIME.PlanDate  AND  ObjectHistory_Price.StartDate < (_TIME.PlanDate +interval '1 day')
                                                  AND _TIME.PlanDate >= ObjectHistory_Price.StartDate AND _TIME.PlanDate < (ObjectHistory_Price.EndDate+interval '1 day')
                           -- �������� �������� ���������� ���� ��� ������� ��� �� ������� �������� �� ����    
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                                        ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory_Price.Id
                                                       AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                          -- �������� �������� ��������� ����� ���� ��� �� ������� �������� �� ����    
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                                       ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory_Price.Id
                                                      AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay()
                          )

 -- ���������� �������� � - ������ �������***                               
, tmpMCSPeriod AS (SELECT *
                   FROM (SELECT tmp.UnitId, tmp.OperDate, tmp.MCSPeriod
                            ,  ROW_NUMBER()OVER(PARTITION BY tmp.UnitId, tmp.OperDate Order By count(*) desc) AS Ord
                         FROM (SELECT *, ROW_NUMBER()OVER(PARTITION BY tmp.UnitId, tmp.GoodsId, tmp.OperDate Order By tmp.UnitId, tmp.GoodsId, tmp.OperDate) AS Ord
                               FROM tmpListMCSPeriodDay AS tmp
                               WHERE tmp.MCSPeriod <> 0
                              ) as tmp
                         WHERE tmp.Ord = 1  
                         GROUP BY tmp.UnitId, tmp.OperDate, tmp.MCSPeriod
                         ) as tmp
                   WHERE tmp.Ord = 1  
                   )
-- ���������� �������� � - ����� ����**
   , tmpMCSDay AS (SELECT *
                   FROM (SELECT tmp.UnitId, tmp.OperDate, tmp.MCSDay
                            ,  ROW_NUMBER()OVER(PARTITION BY tmp.UnitId, tmp.OperDate Order By count(*) desc) AS Ord
                         FROM (SELECT *, ROW_NUMBER()OVER(PARTITION BY tmp.UnitId, tmp.GoodsId, tmp.OperDate Order By tmp.UnitId, tmp.GoodsId, tmp.OperDate) AS Ord
                               FROM tmpListMCSPeriodDay AS tmp
                               WHERE tmp.MCSDay <> 0
                              ) as tmp
                         WHERE tmp.Ord = 1  
                         GROUP BY tmp.UnitId, tmp.OperDate, tmp.MCSDay
                         ) as tmp
                   WHERE tmp.Ord = 1  
                   )
 , tmpMCSPeriodDay AS (SELECT tmpMCSPeriod.UnitId
                            , tmpMCSPeriod.OperDate
                            , tmpMCSPeriod.MCSPeriod
                            , tmpMCSDay.MCSDay
                       FROM tmpMCSPeriod
                         LEFT JOIN tmpMCSDay ON tmpMCSDay.UnitId = tmpMCSPeriod.UnitId
                                            AND tmpMCSDay.OperDate = tmpMCSPeriod.OperDate
                       )


                    SELECT _TIME.PlanDate::TDateTime AS OperDate
                         , Object_Unit.ValueData     ::TVarChar                          AS UnitName
                         , tmpNTZ.AmountRem      ::TFloat AS StartSum                     --SumRem
                         , tmpNTZ.AmountRemEnd              ::TFloat AS EndSum
                         
                         , CAST (CASE WHEN tmpNTZ.AmountRemEnd <> 0 THEN tmpCheck.SummaCheck*100/tmpNTZ.AmountRemEnd ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PersentCheck
                         
                         , tmpNTZ.SummaJuridicalRemains     ::TFloat AS SummaJuridical
                         , tmpNTZ.SummaJuridicalRemainsEnd  ::TFloat AS SummaJuridicalEnd
                         , tmpMovementIncome.SummaIncome    ::TFloat AS SummaIncome
                         , tmpMovementIncome.SummaJuridical ::TFloat AS SummaJuridicalIncome
                         , tmpCheck.SummaCheck              ::TFloat AS SummaCheck
                         , tmpMovementSale.SummaSale        ::TFloat AS SummaSale
                         , tmpMovementSend.SummaSendIN      ::TFloat AS SummaSendIN
                         , tmpMovementSend.SummaSendOut     ::TFloat AS SummaSendOut
                         , tmpMovementSend.SummaDocSendIN      ::TFloat AS SummaDocSendIN
                         , tmpMovementSend.SummaDocSendOut     ::TFloat AS SummaDocSendOut
                         , tmpMovementSale.SummaOrderExternal   ::TFloat AS SummaOrderExternal
                         , tmpMovementSale.SummaOrderInternal   ::TFloat AS SummaOrderInternal
                         , tmpMovementSale.SummaDocOrderExternal   ::TFloat AS SummaDocOrderExternal
                         , tmpMovementSale.SummaDocOrderInternal   ::TFloat AS SummaDocOrderInternal
                         , tmpNTZ.AmountNotMCS                     ::TFloat AS SummaReturnIn 
                         , tmpMCSPeriodDay.MCSPeriod   ::TFloat
                         , tmpMCSPeriodDay.MCSDay      ::TFloat
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
                       
                        LEFT JOIN tmpNTZ ON tmpNTZ.OperDate = _TIME.PlanDate
                                        AND tmpNTZ.UnitId   = Object_Unit.Id

                        LEFT JOIN tmpMCSPeriodDay ON tmpMCSPeriodDay.OperDate = _TIME.PlanDate
                                                 AND tmpMCSPeriodDay.UnitId   = Object_Unit.Id

                    WHERE  (COALESCE(tmpNTZ.SummaJuridicalRemains,0) + COALESCE(tmpNTZ.SummaJuridicalRemainsEnd,)) <> 0
                        
                        
;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 03.02.16         * 
*/

--select * from gpSelect_Report_Liquid(inStartDate := ('01.12.2015')::TDateTime , inEndDate := ('31.12.2015')::TDateTime , inUnitId := 183292 , inQuasiSchedule := 'False' ,  inSession := '3');
--select * from gpSelect_Report_Liquid(inStartDate := ('01.02.2016')::TDateTime , inEndDate := ('01.02.2016')::TDateTime , inUnitId := 0 , inQuasiSchedule := 'False' ,  inSession := '3');
--select * from gpSelect_Report_Liquid(inStartDate := ('08.02.2016')::TDateTime , inEndDate := ('08.02.2016')::TDateTime , inUnitId := 0 , inQuasiSchedule := 'False' ,  inSession := '3');