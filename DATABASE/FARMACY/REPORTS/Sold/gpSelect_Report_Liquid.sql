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
              , Startsum tfloat, Endsum tfloat
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
        PlanDate          TDateTime,  --����� �����
        DayOfWeek         Integer,    --���� � ������
        CountDay          NUMERIC(20,10)    --���-�� ����(������������� / ���������) � ������ 
        ) ON COMMIT DROP;
    CREATE TEMP TABLE _PartDay(
        PlanDate          TDateTime,  --����� �����
        DayOfWeek         Integer,    --���� � ������
        UnitId            Integer,
        Part              NUMERIC(20,10)
        ) ON COMMIT DROP;
        
    CREATE TEMP TABLE _TMP(
        PlanDate          TDateTime,  --����� �����
        DayOfWeek         Integer,    --���� � ������
        UnitId            Integer,    --�� �������������
        UnitName          TVarChar,   --�������������
        PlanMonthAmount   NUMERIC(20,10),     --���� � �����
        PlanAmount        NUMERIC(20,10),     --���� � ����
        PlanAmountAccum   NUMERIC(20,10),     --���� � �����������
        FactAmount        NUMERIC(20,10),     --���� � ����
        FactAmountAccum   NUMERIC(20,10),     --���� � �����������
        DiffAmount        NUMERIC(20,10),     --������� (���� - ����) 
        DiffAmountAccum   NUMERIC(20,10),     --������� � ���������� (���� � ����������� - ���� � �����������)
        PercentMake       NUMERIC(20,10),     --% ���������� �����
        PercentMakeAccum  NUMERIC(20,10)      --% ��������� �� ����������
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
        WITH containerCount AS (SELECT 
                                    container.Id
                                  , container.Amount
                                  ,CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                               THEN MIFloat_Price.ValueData / (1 + ObjectFloat_NDSKind_NDS.ValueData/100)
                                               ELSE MIFloat_Price.ValueData
                                            END::TFloat AS PriceWithOutVAT
                                  , container.ObjectID 
                                  , Container.WhereObjectId AS UnitId
                                FROM 
                                    container
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = container.Id
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    LEFT OUTER JOIN MovementItem AS MI_Income
                                                                 ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                              ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                                             AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                 ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                                AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                          ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                         AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                WHERE container.descid = zc_container_count()
                                  AND (Container.WhereObjectId = inUnitId OR inUnitId = 0) 
                          )

   , tmpRem AS(SELECT --Object_Goods_View.Id                         as Id
                     DD.UnitId
                  --  , Object_Price.Price                           as PriceOut
                    , SUM (DD.OperAmount * Object_Price.Price)::TFloat as SumOut
                    , SUM (DD.OperAmountEND * Object_Price.Price)::TFloat as SumOut1
                    , SUM (DD.OperAmount2 * Object_Price.Price)::TFloat as SumOut2
               FROM (
                    SELECT SUM(DD.OperAmount)    AS OperAmount, 
                           SUM(DD.OperAmountEND) AS OperAmountEND, 
                           SUM(DD.OperAmount2)    AS OperAmount2,
                           DD.UnitId,
                           DD.ObjectId
                    FROM (SELECT SUM(DD.OperAmount) AS OperAmount, 
                                 SUM(DD.OperAmountEND) AS OperAmountEND,
                                 SUM(DD.OperAmount2) AS OperAmount2,
                                 DD.UnitId,
                                 DD.ObjectID 
                          FROM (SELECT containerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                                     , containerCount.Amount - COALESCE(SUM(CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS OperAmountEND
                                     , containerCount.Amount - COALESCE(SUM(CASE WHEN MIContainer.OperDate >= inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS OperAmount2
                                     , containerCount.UnitId
                                     , containerCount.ObjectID 
                                FROM containerCount
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = containerCount.Id
                                                                   AND MIContainer.OperDate > inStartDate
                                GROUP BY containerCount.Id, containerCount.ObjectID, containerCount.Amount, containerCount.UnitId--, containerCount.PriceWithOutVAT
                               ) AS DD
                          GROUP BY DD.UnitId,DD.ObjectID
                          ) AS DD
                    GROUP BY DD.UnitId,DD.ObjectID
                    HAVING (SUM(DD.OperAmount) <> 0)
                    ) AS DD
                   LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = DD.ObjectId

                   LEFT OUTER JOIN Object_Price_View AS Object_Price
                                                    ON DD.ObjectId = Object_Price.GoodsId
                                                   AND Object_Price.UnitId = DD.UnitId   
            GROUP BY DD.UnitId
           )

      , tmpRemains  AS (SELECT --Object_Goods_View.Id                         as Id
                               DD.UnitId
                             , DD.OperDate
                  --  , Object_Price.Price                           as PriceOut
                             , SUM (DD.OperSummAmount * Object_Price.Price)::TFloat as SumOut
                             , SUM (DD.OperAmount * Object_Price.Price)::TFloat as SumOut1
                        FROM (
                    SELECT SUM(DD.OperAmount)     AS OperAmount, 
                           SUM(DD.OperSummAmount) AS OperSummAmount, 
                           DD.UnitId,
                           DD.ObjectId,
                           DD.OperDate
                    FROM (SELECT DD.OperDate, 
                                 SUM(DD.OperAmount)                         AS OperAmount, 
                                 SUM (OperSummAmount)  AS OperSummAmount,
                                 DD.UnitId,
                                 DD.ObjectID 
                          FROM (SELECT date_trunc('day', _TIME.PlanDate) AS OperDate
                                     , containerCount.Amount - COALESCE(SUM(CASE WHEN date_trunc('day', MIContainer.OperDate) > _TIME.PlanDate THEN MIContainer.Amount ELSE 0 END), 0) AS OperAmount
                                     , COALESCE(SUM(MIContainer.Amount), 0) AS OperSummAmount
                                     , containerCount.UnitId
                                     , containerCount.ObjectID 
                                FROM containerCount
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = containerCount.Id
                                                                   AND MIContainer.OperDate > inStartDate
                                    LEFT JOIN _TIME ON _TIME.PlanDate = MIContainer.OperDate
                                    
                                GROUP BY containerCount.Id, containerCount.ObjectID, containerCount.Amount, containerCount.UnitId
                                       , date_trunc('day', MIContainer.OperDate),_TIME.PlanDate --, containerCount.PriceWithOutVAT
                               ) AS DD
                          GROUP BY DD.UnitId,DD.ObjectID, DD.OperDate
                          ) AS DD
                    GROUP BY DD.UnitId,DD.OperDate, DD.ObjectId
                    --HAVING (SUM(DD.OperAmount) <> 0
                    
                    ) AS DD
                   LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = DD.ObjectId

                   LEFT OUTER JOIN Object_Price_View AS Object_Price
                                                    ON DD.ObjectId = Object_Price.GoodsId
                                                   AND Object_Price.UnitId = DD.UnitId   
            GROUP BY DD.UnitId, DD.OperDate
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
                         , tmpRem.SumOut   ::TFloat AS StartSum--   , tmpRemains.StartSum      ::TFloat AS StartSum
                         , tmpRem.SumOut2     ::TFloat AS EndSum--  , tmpRemains.EndSum        ::TFloat AS EndSum
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
                        LEFT JOIN tmpRem ON tmpRem.UnitId = Object_Unit.Id--tmpRemains.OperDate = _TIME.PlanDate
                                           -- AND tmpRemains.UnitId = Object_Unit.Id
                        LEFT JOIN tmpRemains ON tmpRemains.UnitId = Object_Unit.Id
                                            AND tmpRemains.OperDate = _TIME.PlanDate
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
                                                                
                        --LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Coalesce(tmpRemains.UnitId,tmpMovementIncome.UnitId ) 


;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 03.02.16         * 
 

*/
