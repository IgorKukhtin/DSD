 -- Function: gpReport_Send_PersonalGroup ()

DROP FUNCTION IF EXISTS gpReport_Send_PersonalGroup (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_PersonalGroup (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Send_PersonalGroup (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inFromId            Integer   ,
    IN inToId              Integer   ,
    IN inGoodsGroupId      Integer   ,
    IN inIsDays            Boolean   , --
    IN inisGoods           Boolean   , --
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight         TFloat
             , WeightTotal    TFloat
             , FromCode Integer, FromName TVarChar
             --, ToCode Integer
             , ToName TVarChar
             , PersonalGroupCode Integer, PersonalGroupName TVarChar
             , AmountHour     TFloat
             , CountPack      TFloat
             , CountPack_in   TFloat
             , CountPack_out  TFloat
             , Amount         TFloat
             , AmountIn       TFloat
             , AmountOut      TFloat
             , Amount_kg      TFloat
             , AmountIn_kg    TFloat
             , AmountOut_kg   TFloat
             , isError        Boolean
             )  
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY

     WITH -- ����������� �� ������
          _tmpGoods AS -- (GoodsId, InfoMoneyId, TradeMarkId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, 0) AS InfoMoneyId, COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) AS TradeMarkId
                , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                , ObjectFloat_Weight.ValueData           AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = lfSelect.GoodsId
                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfSelect.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
        UNION ALL
           SELECT Object.Id, COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, 0) AS InfoMoneyId, COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) AS TradeMarkId
                , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                , ObjectFloat_Weight.ValueData           AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id
                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object.Id
                                    AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
          )

    /*    -- ������ ������������� ��� �������������
      , tmpFrom AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect WHERE inUnitId > 0
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inUnitId = 0
                    )
      , tmpTo AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect WHERE inToId > 0
                 UNION
                  SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inToId = 0
                 )
    ,  _tmpUnit AS (SELECT tmpFrom.UnitId, COALESCE (tmpTo.UnitId, 0) AS UnitId_by
                    FROM tmpFrom 
                         LEFT JOIN tmpTo ON tmpTo.UnitId > 0
                    )
     */           
      , tmpContainer AS (SELECT MIContainer.OperDate ::TDateTime AS OperDate
                              , MIContainer.WhereObjectId_analyzer  AS FromId
                              , MIContainer.ObjectExtId_Analyzer    AS ToId
                              , MovementLinkObject_PersonalGroup.ObjectId                                      AS PersonalGroupId
                              , CASE WHEN inisGoods = TRUE THEN MIContainer.ObjectId_analyzer ELSE NULL END    AS GoodsId
                              , CASE WHEN inisGoods = TRUE THEN MIContainer.ObjectIntId_analyzer ELSE NULL END AS GoodsKindId
                                -- ���-�� �����
                              , SUM (MIContainer.Amount) AS Amount
                                --  ���-�� ������
                              , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut
                                -- ���-�� ������
                              , SUM (CASE WHEN MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS AmountIn
                              
                              , SUM (COALESCE (MIFloat_CountPack.ValueData ,0)) AS CountPack  
                              --������� ����
                              , ROW_NUMBER() OVER (PARTITION BY MIContainer.OperDate, MovementLinkObject_PersonalGroup.ObjectId) AS Ord
                         FROM MovementItemContainer AS MIContainer
                              LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                          ON MIFloat_CountPack.MovementItemId = MIContainer.MovementItemId
                                                         AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                           ON MovementLinkObject_PersonalGroup.MovementId = MIContainer.MovementId
                                                          AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
                         WHERE MIContainer.MovementDescId = zc_Movement_Send()
                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                           AND MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.WhereObjectId_analyzer = inUnitId
                           AND ( ( (MIContainer.isActive = FALSE AND MIContainer.ObjectExtId_Analyzer = inToId) OR COALESCE (inToId,0) = 0 )
                               OR ((MIContainer.isActive = TRUE  AND  MIContainer.ObjectExtId_Analyzer = inFromId) OR COALESCE (inFromId,0) = 0)
                               )
                         GROUP BY MIContainer.OperDate
                                , MovementLinkObject_PersonalGroup.ObjectId
                                , MIContainer.WhereObjectId_analyzer    
                                , MIContainer.ObjectExtId_Analyzer      
                                , CASE WHEN inisGoods = TRUE THEN MIContainer.ObjectId_analyzer ELSE NULL END
                                , CASE WHEN inisGoods = TRUE THEN MIContainer.ObjectIntId_analyzer ELSE NULL END     
                  )         
        --������ �� ������ ������� ���-�� ����� 
      , tmpOperDate AS (SELECT generate_series(inStartDate, inEndDate, '1 DAY'::interval) OperDate) --��� ��� ���������� �������
      
      , tmpSheetWorkTime AS (SELECT tmpOperDate.OperDate
                                  , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                                  , MovementLinkObject_Unit.ObjectId              AS UnitId
                                  , SUM (MI_SheetWorkTime.Amount ) AS Amount
                             FROM tmpOperDate
                                  JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                               AND Movement.DescId = zc_Movement_SheetWorkTime()
                                  JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId = inUnitId
                                  JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                       AND MI_SheetWorkTime.isErased = FALSE 
                                                                       AND COALESCE (MI_SheetWorkTime.Amount,0) > 0
                                  INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                   ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                                                  AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind() 
                                                                  AND MIObject_WorkTimeKind.ObjectId IN (zc_Enum_WorkTimeKind_WorkN()
                                                                                                        ,zc_Enum_WorkTimeKind_WorkD()
                                                                                                        ,zc_Enum_WorkTimeKind_RemoteAccess()
                                                                                                        ,zc_Enum_WorkTimeKind_Work()
                                                                                                        ,zc_Enum_WorkTimeKind_Trainee50()
                                                                                                        ,zc_Enum_WorkTimeKind_Inventory())
                                  INNER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                   ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                  AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                             GROUP BY tmpOperDate.OperDate
                                    , COALESCE(MIObject_PersonalGroup.ObjectId, 0)
                                    , MovementLinkObject_Unit.ObjectId
                             )          
       --��������� ����������� � ������� �� ���� ������� �������������
      , tmpData AS (SELECT tmp.OperDate
                         , tmp.PersonalGroupId
                         , tmp.FromId
                         , STRING_AGG (DISTINCT Object_To.ValueData, ', ') ::TVarChar AS ToName
                         , tmp.GoodsId
                         , tmp.GoodsKindId
                         , tmp.isError
                         , SUM (COALESCE (tmp.Amount,0))     AS Amount
                         , SUM (COALESCE (tmp.AmountIn,0))   AS AmountIn
                         , SUM (COALESCE (tmp.AmountOut,0))  AS AmountOut
                         , SUM (COALESCE (tmp.CountPack,0))  AS CountPack
                         , SUM (COALESCE (tmp.AmountHour,0)) AS AmountHour
                    FROM (
                          SELECT CASE WHEN inIsDays = TRUE THEN COALESCE (tmpContainer.OperDate, tmpSheetWorkTime.OperDate) ELSE NULL END ::TDateTime AS OperDate
                               , COALESCE (tmpContainer.PersonalGroupId, tmpSheetWorkTime.PersonalGroupId) AS PersonalGroupId
                               , COALESCE (tmpContainer.FromId, tmpSheetWorkTime.UnitId)  AS FromId
                               , tmpContainer.ToId
                               , tmpContainer.GoodsId
                               , tmpContainer.GoodsKindId
                               , (COALESCE (tmpContainer.Amount,0))     AS Amount
                               , (COALESCE (tmpContainer.AmountIn,0))   AS AmountIn
                               , (COALESCE (tmpContainer.AmountOut,0))  AS AmountOut
                               , (COALESCE (tmpContainer.CountPack,0))  AS CountPack
                               , (CASE WHEN tmpContainer.Ord = 1 THEN  COALESCE (tmpSheetWorkTime.Amount,0) ELSE 0 END) AS AmountHour
                               , tmpContainer.Ord 
                               , CASE WHEN ((COALESCE (tmpContainer.Amount,0) <> 0 AND COALESCE (tmpSheetWorkTime.Amount,0) = 0) 
                                         OR (COALESCE (tmpContainer.Amount,0) = 0  AND COALESCE (tmpSheetWorkTime.Amount,0) <> 0) ) 
                                       THEN TRUE
                                       ELSE FALSE
                                  END :: Boolean AS isError 
                          FROM tmpContainer
                              FULL JOIN tmpSheetWorkTime ON tmpSheetWorkTime.OperDate = tmpContainer.OperDate
                                                        --AND tmpSheetWorkTime.UnitId = tmpContainer.FromId
                                                        AND tmpSheetWorkTime.PersonalGroupId = tmpContainer.PersonalGroupId
                          ) AS tmp
                          LEFT JOIN Object AS Object_To ON Object_To.Id = tmp.ToId
                    GROUP BY tmp.OperDate
                           , tmp.PersonalGroupId
                           , tmp.FromId
                           --, tmp.ToId
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           , tmp.isError
                    )



       -- ���������
       SELECT tmpOperationGroup.OperDate
         , Object_GoodsGroup.Id                       AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , tmpOperationGroup.Weight      ::TFloat
          -- ��� � �������� - GoodsByGoodsKind
         , ObjectFloat_WeightTotal.ValueData   :: TFloat  AS WeightTotal
         
         , Object_From.ObjectCode          AS FromCode
         , Object_From.ValueData           AS FromName
         --, Object_To.ObjectCode            AS ToCode
         , tmpOperationGroup.ToName        AS ToName
         , Object_PersonalGroup.ObjectCode AS PersonalGroupCode 
         , Object_PersonalGroup.ValueData  AS PersonalGroupName
         
         , tmpOperationGroup.AmountHour :: TFloat
         , tmpOperationGroup.CountPack  :: TFloat 
         , CASE WHEN COALESCE(ObjectFloat_WeightTotal.ValueData,0) <> 0 THEN tmpOperationGroup.AmountIn_kg / ObjectFloat_WeightTotal.ValueData ELSE 0 END  ::TFloat AS CountPack_in
         , CASE WHEN COALESCE(ObjectFloat_WeightTotal.ValueData,0) <> 0 THEN tmpOperationGroup.AmountOut_kg / ObjectFloat_WeightTotal.ValueData ELSE 0 END ::TFloat AS CountPack_out
         
         , tmpOperationGroup.Amount        :: TFloat
         , tmpOperationGroup.AmountIn      :: TFloat
         , tmpOperationGroup.AmountOut     :: TFloat
         , tmpOperationGroup.Amount_kg     :: TFloat
         , tmpOperationGroup.AmountIn_kg   :: TFloat
         , tmpOperationGroup.AmountOut_kg  :: TFloat
                  
         , tmpOperationGroup.isError       ::Boolean

        /* , CASE WHEN ((COALESCE (tmpOperationGroup.Amount,0) <> 0 AND  COALESCE (tmpOperationGroup.AmountHour,0) = 0) 
                  OR (COALESCE (tmpOperationGroup.Amount,0) = 0 AND  COALESCE (tmpOperationGroup.AmountHour,0) <> 0) ) 
                     AND inisGoods = FALSE
                THEN TRUE
                ELSE FALSE
           END :: Boolean AS isError*/
          
     FROM (SELECT tmpData.OperDate
                , tmpData.FromId
                , tmpData.ToName
                , tmpData.GoodsId
                , tmpData.GoodsKindId
                , _tmpGoods.MeasureId
                , _tmpGoods.Weight
                , tmpData.PersonalGroupId
                , tmpData.isError    
                , tmpData.AmountHour  AS AmountHour
                , tmpData.CountPack   AS CountPack
                
                , tmpData.Amount      AS Amount
                , tmpData.AmountIn    AS AmountIn
                , tmpData.AmountOut   AS AmountOut
                , (tmpData.Amount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)     AS Amount_kg
                , (tmpData.AmountIn * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)   AS AmountIn_kg
                , (tmpData.AmountOut * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  AS AmountOut_kg

           FROM tmpData
                LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpData.GoodsId
           ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpOperationGroup.FromId
          --LEFT JOIN Object AS Object_To ON Object_To.Id = tmpOperationGroup.ToId
          LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpOperationGroup.PersonalGroupId
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpOperationGroup.MeasureId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          -- ����� � ��� ������
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpOperationGroup.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpOperationGroup.GoodsKindId
          -- ��� � ��������: "������" ��� + ��� 1-��� ������
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.09.23         *
*/

-- ����
--SELECT * FROM gpReport_Send_PersonalGroup (inStartDate:= '01.09.2023', inEndDate:= '05.09.2023', inUnitId:= 8451, inFromId:= 0, inToId:= 0, inGoodsGroupId:= 0, inIsDays:= true, inIsGoods:= false, inSession:= zfCalc_UserAdmin()); -- ����� ����������

