-- Function: gpReport_GoodsGroup ()

DROP FUNCTION IF EXISTS gpReport_GoodsGroup (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsGroup (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inUnitGroupId  Integer   ,
    IN inLocationId   Integer   , 
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE  (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime, MovementDescName TVarChar, MovementDescName_order TVarChar, isActive Boolean, isRemains Boolean
              , LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
              , CarCode Integer, CarName TVarChar
              , ObjectByDescName TVarChar, ObjectByCode Integer, ObjectByName TVarChar
              , PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, GoodsKindName_complete TVarChar, PartionGoods TVarChar
              , GoodsCode_parent Integer, GoodsName_parent TVarChar, GoodsKindName_parent TVarChar
              , Price TFloat, Price_end TFloat, Price_partner TFloat
              , SummPartnerIn TFloat, SummPartnerOut TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat, Amount TFloat
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat, Summ TFloat
              , Amount_Change TFloat, Summ_Change TFloat
              , Amount_40200 TFloat, Summ_40200 TFloat
              , Amount_Loss TFloat, Summ_Loss TFloat
               )  
AS
$BODY$
BEGIN

    RETURN QUERY
    WITH tmpSendOnPrice_out AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_SendOnPrice()
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inFromId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inToId         := 0
                                                                       , inIsMO_all     := FALSE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
        , tmpSendOnPrice_in AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_SendOnPrice()
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inFromId       := 0
                                                                       , inToId         := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inIsMO_all     := FALSE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
                  , tmpLoss AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_Loss()
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inFromId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inToId         := 0
                                                                       , inIsMO_all     := FALSE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
              , tmpSend_out AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_Send()
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inFromId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inToId         := 0
                                                                       , inIsMO_all     := FALSE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
               , tmpSend_in AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_Send()
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inFromId       := 0
                                                                       , inToId         := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inIsMO_all     := FALSE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
                           , tmpSale AS (SELECT * FROM gpReport_GoodsMI (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId            := zc_Movement_Sale()
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inUnitGroupId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inUnitId            := 0
                                                                       , inPaidKindId        := 0
                                                                       , inJuridicalId       := 0
                                                                       , inInfoMoneyId       := 0
                                                                       , inIsPartner         := TRUE
                                                                       , inIsTradeMark       := FALSE
                                                                       , inIsGoods           := FALSE
                                                                       , inIsGoodsKind       := FALSE
                                                                       , inIsPartionGoods    := FALSE
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
       , tmpResult AS (-- 1.1. SendOnPrice - Out
                       SELECT zc_Movement_SendOnPrice()       AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , tmp.AmountIn_Weight             AS AmountOut
                            , tmp.SummIn_zavod                AS SummOut
                            , tmp.SummIn_branch               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummPartnerIn
                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd 
                            , 0                               AS SummStart
                            , 0                               AS SummEnd 
                            , FALSE                           AS isActive
                            , tmp.AmountOut_Weight - tmp.AmountIn_Weight  AS Amount_Change
                            , tmp.SummOut_zavod    - tmp.SummIn_zavod     AS Summ_Change
                            , 0                               AS Amount_40200 
                            , 0                               AS Summ_40200
                            , 0                               AS Amount_Loss 
                            , 0                               AS Summ_Loss
                       FROM tmpSendOnPrice_out AS tmp
                      UNION ALL
                       -- 1.2. SendOnPrice - In
                       SELECT zc_Movement_SendOnPrice()       AS MovementDescId
                            , tmp.LocationCode_by             AS LocationCode
                            , tmp.LocationName_by             AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , tmp.LocationName                AS ObjectByName
                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummPartnerOut
                            , tmp.AmountIn_Weight             AS AmountIn
                            , tmp.SummIn_zavod                AS SummIn
                            , tmp.SummOut_branch              AS SummPartnerIn
                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd 
                            , 0                               AS SummStart
                            , 0                               AS SummEnd 
                            , TRUE                            AS isActive
                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change
                            , 0                               AS Amount_40200 
                            , 0                               AS Summ_40200
                            , 0                               AS Amount_Loss 
                            , 0                               AS Summ_Loss
                       FROM tmpSendOnPrice_in AS tmp
                      UNION ALL
                       -- 2. Loss
                       SELECT zc_Movement_Loss()              AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , 0                               AS ObjectByCode
                            , COALESCE (tmp.LocationName_by, '') ||  CASE WHEN tmp.LocationName_by <> '' AND tmp.ArticleLossName <> '' THEN ' *** ' ELSE '' END || COALESCE (tmp.ArticleLossName, '') AS ObjectByName
                            , tmp.AmountOut_Weight            AS AmountOut
                            , tmp.SummOut_zavod               AS SummOut
                            , tmp.SummOut_branch              AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummPartnerIn
                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd 
                            , 0                               AS SummStart
                            , 0                               AS SummEnd 
                            , FALSE                           AS isActive
                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change
                            , 0                               AS Amount_40200 
                            , 0                               AS Summ_40200
                            , 0                               AS Amount_Loss 
                            , 0                               AS Summ_Loss
                       FROM tmpLoss AS tmp
                      UNION ALL
                       -- 3.1. Send - Out
                       SELECT zc_Movement_Send()              AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , tmp.AmountOut_Weight            AS AmountOut
                            , tmp.SummOut_zavod               AS SummOut
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummPartnerIn
                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd 
                            , 0                               AS SummStart
                            , 0                               AS SummEnd 
                            , FALSE                           AS isActive
                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change
                            , 0                               AS Amount_40200 
                            , 0                               AS Summ_40200
                            , 0                               AS Amount_Loss 
                            , 0                               AS Summ_Loss
                       FROM tmpSend_out AS tmp
                      UNION ALL
                       -- 3.2. Send - In
                       SELECT zc_Movement_Send()              AS MovementDescId
                            , tmp.LocationCode_by             AS LocationCode
                            , tmp.LocationName_by             AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , tmp.LocationName                AS ObjectByName
                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummPartnerOut
                            , tmp.AmountIn_Weight             AS AmountIn
                            , tmp.SummIn_zavod                AS SummIn
                            , 0                               AS SummPartnerIn
                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd 
                            , 0                               AS SummStart
                            , 0                               AS SummEnd 
                            , TRUE                            AS isActive
                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change
                            , 0                               AS Amount_40200 
                            , 0                               AS Summ_40200
                            , 0                               AS Amount_Loss 
                            , 0                               AS Summ_Loss
                       FROM tmpSend_in AS tmp
                      UNION ALL
                       -- 4. Sale
                       SELECT zc_Movement_Sale()              AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.PartnerCode                 AS ObjectByCode
                            , tmp.PartnerName                 AS ObjectByName
                            , SUM (tmp.OperCount_Partner)     AS AmountOut
                            , SUM (tmp.SummIn_Partner_branch) AS SummOut
                            , SUM (tmp.SummOut_Partner)       AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummPartnerIn
                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd 
                            , 0                               AS SummStart
                            , 0                               AS SummEnd 
                            , FALSE                           AS isActive
                            , SUM (tmp.OperCount_Change)      AS Amount_Change
                            , SUM (tmp.SummIn_Change_branch)  AS Summ_Change
                            , SUM (tmp.OperCount_40200)       AS Amount_40200 
                            , SUM (tmp.SummIn_40200_branch)   AS Summ_40200
                            , SUM (tmp.OperCount_Loss)        AS Amount_Loss 
                            , SUM (tmp.SummIn_Loss_zavod)     AS Summ_Loss
                       FROM tmpSale AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName, tmp.PartnerCode, tmp.PartnerName
                      )
   SELECT 0    :: Integer   AS MovementId
        , ''   :: TVarChar  AS InvNumber
        , NULL :: TDateTime AS OperDate
        , NULL :: TDateTime AS OperDatePartner
        , CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = TRUE
                    THEN MovementDesc.ItemName || ' ÏÐÈÕÎÄ'
               WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = FALSE
                    THEN MovementDesc.ItemName || ' ÐÀÑÕÎÄ'
               ELSE MovementDesc.ItemName
          END :: TVarChar AS MovementDescName
        , CASE WHEN tmpResult.MovementDescId = zc_Movement_Income()
                    THEN '01 ' || MovementDesc.ItemName
               ELSE MovementDesc.ItemName
          END :: TVarChar AS MovementDescName_order

        , tmpResult.isActive AS isActive
        , FALSE              AS isRemains

        , ''   :: TVarChar  AS LocationDescName
        , tmpResult.LocationCode
        , tmpResult.LocationName
        , 0    :: Integer   AS CarCode
        , ''   :: TVarChar  AS CarName
        , ''   :: TVarChar  AS ObjectByDescName
        , tmpResult.ObjectByCode :: Integer  AS ObjectByCode
        , tmpResult.ObjectByName :: TVarChar AS ObjectByName

        , ''   :: TVarChar  AS PaidKindName

        , 0    :: Integer   AS GoodsCode
        , ''   :: TVarChar  AS GoodsName
        , ''   :: TVarChar  AS GoodsKindName
        , ''   :: TVarChar  AS GoodsKindName_complete
        , ''   :: TVarChar  AS PartionGoods
        , 0    :: Integer   AS GoodsCode_parent
        , ''   :: TVarChar  AS GoodsName_parent
        , ''   :: TVarChar  AS GoodsKindName_parent



        , CAST (CASE WHEN tmpResult.MovementDescId = zc_Movement_Income() AND 1=0
                          THEN 0 -- MIFloat_Price.ValueData
                     WHEN /*tmpResult.MovementId = -1 AND */tmpResult.AmountStart <> 0
                          THEN tmpResult.SummStart / tmpResult.AmountStart
                     /*WHEN tmpResult.MovementId = -2 AND tmpResult.AmountEnd <> 0
                          THEN tmpResult.SummEnd / tmpResult.AmountEnd*/
                     WHEN tmpResult.AmountIn <> 0
                          THEN tmpResult.SummIn / tmpResult.AmountIn
                     WHEN tmpResult.AmountOut <> 0
                          THEN tmpResult.SummOut / tmpResult.AmountOut
                     ELSE 0
                END AS TFloat) AS Price
        , CAST (CASE WHEN tmpResult.AmountEnd <> 0
                          THEN tmpResult.SummEnd / tmpResult.AmountEnd
                     ELSE 0
                END AS TFloat) AS Price_end
        , CAST (CASE WHEN tmpResult.AmountIn <> 0
                          THEN tmpResult.SummPartnerIn / tmpResult.AmountIn
                     WHEN tmpResult.AmountOut <> 0
                          THEN tmpResult.SummPartnerOut / tmpResult.AmountOut
                     ELSE 0
                END AS TFloat) AS Price_partner

        , CAST (tmpResult.SummPartnerIn AS TFloat)      AS SummPartnerIn
        , CAST (tmpResult.SummPartnerOut AS TFloat)     AS SummPartnerOut

        , CAST (tmpResult.AmountStart AS TFloat) AS AmountStart
        , CAST (tmpResult.AmountIn AS TFloat)    AS AmountIn
        , CAST (tmpResult.AmountOut AS TFloat)   AS AmountOut
        , CAST (tmpResult.AmountEnd AS TFloat)   AS AmountEnd 
        , CAST ((tmpResult.AmountIn - tmpResult.AmountOut)
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = FALSE THEN -1 ELSE 1 END
                AS TFloat) AS Amount

        , CAST (tmpResult.SummStart AS TFloat)   AS SummStart
        , CAST (tmpResult.SummIn AS TFloat)      AS SummIn
        , CAST (tmpResult.SummOut AS TFloat)     AS SummOut
        , CAST (tmpResult.SummEnd AS TFloat)     AS SummEnd
        , CAST ((tmpResult.SummIn - tmpResult.SummOut)
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = FALSE THEN -1 ELSE 1 END
                AS TFloat) AS Summ

        , tmpResult.Amount_Change :: TFloat  AS Amount_Change
        , tmpResult.Summ_Change   :: TFloat  AS Summ_Change
        , tmpResult.Amount_40200  :: TFloat  AS Amount_40200
        , tmpResult.Summ_40200    :: TFloat  AS Summ_40200
        , tmpResult.Amount_Loss   :: TFloat  AS Amount_Loss
        , tmpResult.Summ_Loss     :: TFloat  AS Summ_Loss

   FROM tmpResult
        LEFT JOIN MovementDesc ON MovementDesc.Id = tmpResult.MovementDescId
   ;
    
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsGroup (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 12.08.15                                        *
*/

-- òåñò
-- SELECT * FROM gpReport_GoodsGroup (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inUnitGroupId:= 0, inLocationId:= 8459, inGoodsGroupId:= 1832, inSession:= zfCalc_UserAdmin());
