
-- Function: gpReport_HistoryCost_Difference()

DROP FUNCTION IF EXISTS gpReport_HistoryCost_Difference (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HistoryCost_Difference (
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- �������������
    IN inPriceListId        Integer,    -- 
    IN inSession            TVarChar   -- ������������
)
RETURNS TABLE (GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Price_hc        TFloat   --���� �������������
             , Price_pl        TFloat   --���� ������    
             , Price_diff       TFloat   -- ���� ������ ����� ���� �������������
             , CountStart      TFloat
             , CountEnd        TFloat
             , CountIn         TFloat
             , CountOut        TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);
     
     
    RETURN QUERY
    WITH
        tmpHistoryCost AS (SELECT SUM (HistoryCost.Price) AS Price   --container_count.Id, sum (HistoryCost.Price)
                                , �ontainer_count.Id     AS �ontainerId_count
                                , �ontainer_count.ObjectId AS GoodsId
                                , �ontainer_count.Amount AS Amount_count
                          FROM HistoryCost 
                              JOIN Container AS Container_sum ON Container_sum.Id = HistoryCost.containerId
                                                             AND Container_sum.DescId = zc_Container_Summ()
                              JOIN Container AS �ontainer_count ON �ontainer_count.Id = Container_sum.ParentId 
                                                               AND �ontainer_count.DescId = zc_Container_Count()
                                                               AND �ontainer_count.WhereObjectId =  inUnitId   --8455 -- =
                              LEFT JOIN ContainerLinkObject AS CLO_Account
                                                            ON CLO_Account.ContainerId = �ontainer_count.Id
                                                           AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                          WHERE HistoryCost.StartDate <= inEndDate 
                            AND HistoryCost.EndDate >= inStartDate
                            -- ��� ����� � ����
                            AND CLO_Account.ObjectId IS NULL
                          GROUP BY �ontainer_count.Id
                                 , �ontainer_count.ObjectId
                                 , �ontainer_count.Amount 
                          )
      , tmpMIContainer AS (SELECT MIContainer.ContainerId AS ContainerId
                                , SUM (CASE WHEN MIContainer.OperDate >= '01.08.2023'/*inStartDate*/ THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS SummStart
                                , SUM (CASE WHEN MIContainer.OperDate > '31.08.2023'/*inEndDate*/ THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS SummEnd
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN '01.08.2023' AND '31.08.2023' --inStartDate AND inEndDate
                                             AND MIContainer.isActive = TRUE
                                            THEN MIContainer.Amount
                                            ELSE 0
                                       END) AS CountIn
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN '01.08.2023' AND '31.08.2023' --inStartDate AND inEndDate
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * MIContainer.Amount
                                            ELSE 0
                                       END) AS CountOut
                           FROM MovementItemContainer AS MIContainer
                           WHERE MIContainer.ContainerId IN (SELECT DISTINCT �ontainerId_count FROM tmpHistoryCost)
                             AND MIContainer.DescId = zc_MIContainer_Count()
                             AND MIContainer.OperDate >= '01.08.2023' --inStartDate
                           GROUP BY MIContainer.ContainerId
                           )


      , tmpCLO_GoodsKind AS (SELECT CLO_GoodsKind.ContainerId
                                  , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                             FROM ContainerLinkObject AS CLO_GoodsKind 
                             WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT �ontainerId_count FROM tmpHistoryCost)
                               AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                             )

       -- ���� �� ������
      , tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice  AS Price_PriceList
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18840, inOperDate:= '01.08.2023') AS lfSelect 
                        )
        -- ��� ������� + ������ + ������ + ������� + ���� ����� + ���� �/� + �������
      , tmpResult AS (SELECT tmpHistoryCost.GoodsId
                           , CLO_GoodsKind.GoodsKindId
                           , tmpHistoryCost.Price
                           , COALESCE (tmpPriceList.Price_PriceList , tmpPriceList2.Price_PriceList) AS Price_PriceList
                           , tmpHistoryCost.Amount_count - tmpMIContainer.SummStart AS RemainsStart
                           , tmpHistoryCost.Amount_count - tmpMIContainer.SummEnd   AS RemainsEnd
                           , tmpMIContainer.CountIn
                           , tmpMIContainer.CountOut
                      FROM tmpHistoryCost
                           LEFT JOIN tmpCLO_GoodsKind AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = tmpHistoryCost.�ontainerId_count
   
                           FULL JOIN tmpMIContainer ON tmpMIContainer.ContainerId = tmpHistoryCost.�ontainerId_count
   
                           LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpHistoryCost.GoodsId
                                                 AND COALESCE (tmpPriceList.GoodsKindId,0) = COALESCE (CLO_GoodsKind.GoodsKindId,0)
   
                           LEFT JOIN tmpPriceList AS tmpPriceList2
                                                  ON tmpPriceList2.GoodsId = tmpHistoryCost.GoodsId 
                                                 AND COALESCE (tmpPriceList.Price_PriceList,0) = 0
                                                 AND COALESCE (tmpPriceList2.GoodsKindId,0) = 0
                      )


   SELECT Object_GoodsGroup.Id           AS GoodsGroupId
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , Object_Goods.Id                AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , Object_Goods.ValueData         AS GoodsName
        , Object_GoodsKind.Id            AS GoodsKindId
        , Object_GoodsKind.ValueData     AS GoodsKindName
        , Object_Measure.ValueData       AS MeasureName
        
        , tmpResult.Price ::TFloat       AS Price_hc
        , tmpResult.Price_PriceList ::TFloat AS Price_pl
        , (COALESCE (tmpResult.Price_PriceList,0) - COALESCE (tmpResult.Price,0) ):: TFloat AS Price_diff 
        
        , tmpResult.RemainsStart ::TFloat AS CountStart
        , tmpResult.RemainsEnd   ::TFloat AS CountEnd
        
        , tmpResult.CountIn      ::TFloat AS CountIn
        , tmpResult.CountOut     ::TFloat AS CountOut
   FROM tmpResult
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
        
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure 
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.09.23         *
*/

-- ����
-- SELECT * FROM gpReport_HistoryCost_Difference (inStartDate := '01.08.2023' ::TDateTime, inEndDate := '01.08.2023' ::TDateTime, inUnitId := 8455, inPriceListId:= 18840, inSession := zfCalc_UserAdmin() )

