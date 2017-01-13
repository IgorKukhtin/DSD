-- Function:  gpReport_Movement_Check_UnLiquid()

DROP FUNCTION IF EXISTS gpReport_Movement_Check_UnLiquid (Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Movement_Check_UnLiquid(
    IN inUnitId           Integer  ,  -- �������������
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
               GoodsId             Integer, 
               GoodsCode           Integer, 
               GoodsName           TVarChar,
               GoodsGroupName      TVarChar, 
               NDSKindName         TVarChar, 
               MinExpirationDate   TDateTime,
               OperDate_LastIncome TDateTime,
               Amount_LastIncome   TFloat,
               Price_Remains       TFloat,
               Price_RemainsEnd    TFloat,
               RemainsStart        TFloat,
               RemainsEnd          TFloat,
               Price_Sale          Tfloat,  
               Summa_Remains       TFloat,
               Summa_RemainsEnd    TFloat,
               Amount_Sale         TFloat,
               Summa_Sale          TFloat,
               Amount_Sale1        TFloat,
               Summa_Sale1         TFloat,
               Amount_Sale3        Tfloat,     
               Summa_Sale3         Tfloat,
               Amount_Sale6        TFloat,
               Summa_Sale6         TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- ����������� �� �������� ��������� �����������
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    -- ��������� �����
    inStartDate:= DATE_TRUNC ('DAY', inStartDate);
    inEndDate  := DATE_TRUNC ('DAY', inEndDate);


    -- ���������
    RETURN QUERY
      WITH 
                  -- ������� ��������
                  tmpContainer AS (  SELECT Container.ObjectId   AS GoodsId
                                          , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS RemainsStart
                                          , Container.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS RemainsEnd
                                          , Container.Id         AS ContainerId
                                    FROM Container
                                          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                                ON ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId
                                                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                               AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                                          LEFT JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.ContainerId = Container.Id
                                                                         AND MIContainer.OperDate >= inStartDate
                                     WHERE Container.DescId = zc_Container_Count()
                                       AND Container.WhereObjectId = inUnitId
                                     GROUP BY Container.Id, Container.ObjectId, Container.Amount
                                     HAVING Container.Amount  -COALESCE (SUM (MIContainer.Amount), 0) <> 0
                            
                                     )

                -- ��������� � ��������
                ,  tmpRemains_1 AS ( SELECT tmpContainer.GoodsId
                                          , Sum(tmpContainer.RemainsStart) as RemainsStart
                                          , Sum(tmpContainer.RemainsEnd)   as RemainsEnd
                          
                                          , tmpContainer.ContainerId

                                          , ROW_NUMBER() OVER (PARTITION BY tmpContainer.GoodsId ORDER BY COALESCE (Movement_Income.OperDate, NULL) DESC) AS Ord
                                          , COALESCE (Movement_Income.OperDate, NULL)                  AS OperDate_Income
                                          , COALESCE (MI_Income_find.Amount ,MI_Income.Amount)         AS Amount_Income
                                          , COALESCE (MIDate_ExpirationDate.ValueData,zc_DateEnd())    AS MinExpirationDate -- ���� ��������
                                     FROM tmpContainer
                                          -- ������� ������
                                          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                 ON ContainerLinkObject_MovementItem.Containerid = tmpContainer.ContainerId
                                                AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                          -- ������� �������
                                          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                          -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                          -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                     
                                          LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                 ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                                AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                                          LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId) 
                                    
                                     GROUP BY tmpContainer.ContainerId, tmpContainer.GoodsId
                                            , COALESCE (Movement_Income.OperDate, NULL)
                                            , COALESCE (MI_Income_find.Amount ,MI_Income.Amount)
                                            , COALESCE (MIDate_ExpirationDate.ValueData,zc_DateEnd()) 
                             )
              -- ������� ��������
           ,   tmpRemains AS ( SELECT tmp.GoodsId
                                   , SUM(tmp.RemainsStart)       AS RemainsStart
                                   , SUM(tmp.RemainsEnd)         AS RemainsEnd
                                   , MIN(tmp.MinExpirationDate)  AS MinExpirationDate -- ���� ��������
                                   , MAX(tmp.OperDate_Income)    AS MaxOperDateIncome
                                   , SUM(CASE WHEN Ord = 1 THEN tmp.Amount_Income ELSE 0 END)          AS Amount_Income
                              FROM tmpRemains_1 AS tmp
                              GROUP BY tmp.GoodsId
                             )

     -- ����, ����������� ������� ������� 
     , tmpCheck_ALL AS ( SELECT MI_Check.ObjectId AS GoodsId
                              -- , MIContainer.ContainerId

                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale
                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale

                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '1 Month' AND Movement_Check.OperDate < inStartDate THEN COALESCE (MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale1
                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '1 Month' AND Movement_Check.OperDate < inStartDate THEN COALESCE (MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale1

                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '3 Month' AND Movement_Check.OperDate < inStartDate THEN COALESCE (MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale3
                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '3 Month' AND Movement_Check.OperDate < inStartDate THEN COALESCE (MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale3

                              , SUM (CASE WHEN Movement_Check.OperDate < inStartDate THEN COALESCE (MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale6
                              , SUM (CASE WHEN Movement_Check.OperDate < inStartDate THEN COALESCE (MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale6

                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE

                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate - INTERVAL '6 Month' AND Movement_Check.OperDate < inEndDate + INTERVAL '1 Day'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MI_Check.ObjectId
                        )
         -- ���������� ���. ������
         , tmpCheck AS ( SELECT tmp.* 
                         FROM (SELECT tmpCheck_ALL.GoodsId
                                    , SUM (tmpCheck_ALL.Amount_Sale) AS Amount_Sale
                                    , SUM (tmpCheck_ALL.Summa_Sale) AS Summa_Sale
      
                                    , SUM (tmpCheck_ALL.Amount_Sale1) AS Amount_Sale1
                                    , SUM (tmpCheck_ALL.Summa_Sale1) AS Summa_Sale1
      
                                    , SUM (tmpCheck_ALL.Amount_Sale3) AS Amount_Sale3
                                    , SUM (tmpCheck_ALL.Summa_Sale3) AS Summa_Sale3

                                    , SUM (tmpCheck_ALL.Amount_Sale6) AS Amount_Sale6
                                    , SUM (tmpCheck_ALL.Summa_Sale6) AS Summa_Sale6

                               FROM tmpCheck_ALL
                               GROUP BY tmpCheck_ALL.GoodsId
                               ) AS tmp
                         )

-- ��� ������� �������� �������� ����
, tmpPriceRemains AS ( SELECT tmpRemains.GoodsId
                            , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)       Price_Remains
                            , COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)    Price_RemainsEnd
                       FROM tmpRemains
                          LEFT OUTER JOIN Object_Price_View ON object_price_view.GoodsId = tmpRemains.GoodsId
                                                           AND Object_Price_View.unitid = inUnitId
                          -- �������� �������� ���� �� ������� �������� �� ������ ���                                                          
                          LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                  ON ObjectHistory_Price.ObjectId = Object_Price_View.Id 
                                                 AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                 AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_Price.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_Price.EndDate
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                       ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                      AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                          -- �������� �������� ���� �� ������� �������� �� �����. ����                                                          
                          LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                                  ON ObjectHistory_PriceEnd.ObjectId = Object_Price_View.Id 
                                                 AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                                 AND DATE_TRUNC ('DAY', inEndDate) >= ObjectHistory_PriceEnd.StartDate AND DATE_TRUNC ('DAY', inEndDate) < ObjectHistory_PriceEnd.EndDate
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceEnd
                                                       ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                                      AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()
                        )
        --���������
        SELECT
             Object_Goods_View.Id                            AS GoodsId
           , Object_Goods_View.GoodsCodeInt  ::Integer       AS GoodsCode
           , Object_Goods_View.GoodsName                     AS GoodsName
           , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
           , Object_Goods_View.NDSKindName
           , tmpRemains.MinExpirationDate         :: TDateTime 
           , tmpRemains.MaxOperDateIncome         :: TDateTime     AS OperDate_LastIncome
           , tmpRemains.Amount_Income             :: TFloat        AS Amount_LastIncome
           , tmpPriceRemains.Price_Remains        :: TFloat
           , tmpPriceRemains.Price_RemainsEnd     :: TFloat

           , tmpRemains.RemainsStart :: TFloat AS RemainsStart
           , tmpRemains.RemainsEnd   :: TFloat AS RemainsEnd
           , CASE WHEN tmpCheck.Amount_Sale <> 0 THEN tmpCheck.Summa_Sale / tmpCheck.Amount_Sale ELSE 0 END :: TFloat AS Price_Sale

           , (tmpRemains.RemainsStart * tmpPriceRemains.Price_Remains)  :: TFloat AS Summa_Remains
           , (tmpRemains.RemainsEnd * tmpPriceRemains.Price_RemainsEnd) :: TFloat AS Summa_RemainsEnd

           , tmpCheck.Amount_Sale       :: TFloat AS Amount_Sale
           , tmpCheck.Summa_Sale        :: TFloat AS Summa_Sale

           , tmpCheck.Amount_Sale1      :: TFloat AS Amount_Sale1
           , tmpCheck.Summa_Sale1       :: TFloat AS Summa_Sale1
           , tmpCheck.Amount_Sale3      :: TFloat AS Amount_Sale3
           , tmpCheck.Summa_Sale3       :: TFloat AS Summa_Sale3
           , tmpCheck.Amount_Sale6      :: TFloat AS Amount_Sale6
           , tmpCheck.Summa_Sale6       :: TFloat AS Summa_Sale6

        FROM tmpRemains
             LEFT JOIN tmpCheck ON tmpCheck.GoodsId = tmpRemains.GoodsId
             LEFT JOIN tmpPriceRemains ON tmpPriceRemains.GoodsId = tmpRemains.GoodsId
             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpRemains.GoodsId

        WHERE COALESCE (tmpCheck.Amount_Sale1, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale3, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale6, 0) =0
        ORDER BY GoodsGroupName, GoodsName;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 06.10.16         * parce
 05.09.16         *
*/

-- ����
--SELECT * FROM gpReport_Movement_Check_UnLiquid(inUnitId := 183292 , inStartDate := ('01.02.2016')::TDateTime , inEndDate := ('02.02.2016')::TDateTime , inSession := '3');
-- SELECT * FROM gpReport_Movement_Check_UnLiquid (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime,inSession:= '3' ::TVarChar)
