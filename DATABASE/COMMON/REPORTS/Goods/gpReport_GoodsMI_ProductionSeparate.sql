 -- Function: gpReport_GoodsMI_ProductionSeparate ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionSeparate (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inIsPartion          Boolean   ,
    IN inIsStorageLine      Boolean   ,
    IN inisCalculated       Boolean   ,   -- "�������� Calculated" + �������� � ����
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inChildGoodsGroupId  Integer   ,
    IN inChildGoodsId       Integer   ,
    IN inFromId             Integer   ,    -- �� ���� 
    IN inToId               Integer   ,    -- ����
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime, PartionGoods  TVarChar 
             , GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , StorageLineName TVarChar
             , Amount TFloat, HeadCount TFloat, Summ TFloat
             , ChildGoodsGroupName TVarChar, ChildGoodsCode Integer,  ChildGoodsName TVarChar
             , isCalculated Boolean
             , ChildAmount TFloat, ChildSumm TFloat, Price TFloat
             , ChildPrice TFloat, Percent TFloat
             , Num Integer
             )   
AS
$BODY$
    DECLARE vbDescId Integer;
BEGIN
    -- !!!��������!!
    -- inIsMovement:= NOT inIsMovement;
    -- inIsPartion:= NOT inIsPartion;

    -- ����������� �� ������
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpChildGoods (ChildGoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpToGroup (ToId  Integer) ON COMMIT DROP;
  
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    IF inChildGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpChildGoods (ChildGoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inChildGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inChildGoodsId <> 0
         THEN
             INSERT INTO _tmpChildGoods (ChildGoodsId)
              SELECT inChildGoodsId;
         ELSE
             INSERT INTO _tmpChildGoods (ChildGoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;


    -- ����������� �� �� ����
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpFromGroup (FromId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpFromGroup (FromId)
          SELECT Id FROM Object_Unit_View;  --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;

    -- ����������� �� ����
    IF inToId <> 0
    THEN
        INSERT INTO _tmpToGroup (ToId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        INSERT INTO _tmpToGroup (ToId)
          SELECT Id FROM Object_Unit_View ;   --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;

  
   -- ���������
    RETURN QUERY
    
    -- ������������ �� ���� ���������  , �� �� ���� / ����
      WITH tmpMovement AS 
                        (SELECT Movement.Id        AS MovementId
                              , Movement.InvNumber AS InvNumber
                              , Movement.OperDate  AS OperDate
                              , MovementString_PartionGoods.ValueData AS PartionGoods 
                         FROM Movement 
                              LEFT JOIN MovementString AS MovementString_PartionGoods
                                                       ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                      AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

			      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
				                           ON MovementLinkObject_From.MovementId = Movement.Id
						          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
			      JOIN _tmpFromGroup on _tmpFromGroup.FromId = MovementLinkObject_From.ObjectId
			      
  			      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
				 		           ON MovementLinkObject_To.MovementId = Movement.Id
							  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
			      JOIN _tmpToGroup on _tmpToGroup.ToId = MovementLinkObject_To.ObjectId
				  
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                           AND Movement.DescId  = zc_Movement_ProductionSeparate()
                            
                         GROUP BY Movement.Id
                                , Movement.InvNumber 
                                , Movement.OperDate  
                                , MovementString_PartionGoods.ValueData
                         )

, tmpMI_Container AS (SELECT tmpMovement.MovementId                            AS MovementId
                             , tmpMovement.InvNumber                           AS InvNumber
                             , tmpMovement.OperDate                            AS OperDate
                             , tmpMovement.PartionGoods                        AS PartionGoods
                             , MIContainer.ObjectId_Analyzer                   AS GoodsId
                            -- , 0 AS Summ
                             , SUM (MIContainer.Amount)                        AS Amount
                             , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount
                             , MIContainer.DescId                              AS MIContainerDescId
                             , MIContainer.isActive                            AS isActive
                             , CASE WHEN inisCalculated = TRUE THEN COALESCE (MIBoolean_Calculated.ValueData, FALSE) ELSE FALSE END  ::Boolean AS isCalculated
                             , CASE WHEN inIsStorageLine = TRUE THEN MILinkObject_StorageLine.ObjectId ELSE 0 END AS StorageLineId
                        FROM tmpMovement
                             JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.MovementId = tmpMovement.MovementId
	                     LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                         ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                                        AND MIContainer.isActive = FALSE
                                                        
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                              ON MILinkObject_StorageLine.MovementItemId = MIContainer.MovementItemId
                                                             AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()

                             LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                           ON MIBoolean_Calculated.MovementItemId = MIContainer.MovementItemId
                                                          AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

                        GROUP BY tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , tmpMovement.PartionGoods
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.DescId
                               , MIContainer.isActive
                               , CASE WHEN inIsStorageLine = TRUE THEN MILinkObject_StorageLine.ObjectId ELSE 0 END
                               , CASE WHEN inisCalculated = TRUE THEN COALESCE (MIBoolean_Calculated.ValueData, FALSE) ELSE FALSE END
                        )
                         
      , tmpMI_Count AS (SELECT tmpMI_Container.MovementId 
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoods
                             , tmpMI_Container.GoodsId 
                             , tmpMI_Container.StorageLineId
                             , 0 AS Summ
                             , SUM (tmpMI_Container.Amount) AS Amount
                             , SUM (tmpMI_Container.HeadCount) AS HeadCount
                             , tmpMI_Container.isActive
                             , tmpMI_Container.isCalculated
                        FROM tmpMI_Container
                        Where tmpMI_Container.MIContainerDescId = zc_MIContainer_Count()
                        GROUP BY tmpMI_Container.MovementId 
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoods
                             , tmpMI_Container.GoodsId 
                             , tmpMI_Container.StorageLineId
                             , tmpMI_Container.isActive
                             , tmpMI_Container.isCalculated
                           )

  , tmpMI_sum AS (SELECT tmpMI_Container.MovementId 
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoods
                             , tmpMI_Container.GoodsId 
                             , tmpMI_Container.StorageLineId
                             , SUM (tmpMI_Container.Amount)  AS Summ
                             , 0 AS Amount
                             , tmpMI_Container.isActive
                             , tmpMI_Container.isCalculated
                        FROM tmpMI_Container
                          -- JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                          --       ) AS tmpAccount on tmpAccount.AccountID = tmpMI_Container.ContainerObjectId
                        Where tmpMI_Container.MIContainerDescId = zc_MIContainer_Summ()
                        GROUP BY tmpMI_Container.MovementId 
                               , tmpMI_Container.InvNumber
                               , tmpMI_Container.OperDate
                               , tmpMI_Container.PartionGoods
                               , tmpMI_Container.GoodsId
                               , tmpMI_Container.StorageLineId
                               , tmpMI_Container.isActive
                               , tmpMI_Container.isCalculated
                           )

  , tmpMI_total AS
           (SELECT tmpMI.GoodsId 
                , -1* SUM (tmpMI.Summ) AS Summ
                , -1* SUM (tmpMI.Amount) AS Amount
                ,  SUM (tmpMI.HeadCount) AS HeadCount
            FROM (SELECT  tmpMI_out.GoodsId as GoodsId       
                        , tmpMI_out.Summ
                        , tmpMI_out.Amount
                        , tmpMI_out.HeadCount
                  FROM tmpMI_Count AS tmpMI_out
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out.GoodsId
                  Where tmpMI_out.isActive = FALSE
                    AND inIsMovement       = FALSE
                    AND inIsPartion        = FALSE
                    
                 UNION ALL
                  SELECT  tmpMI_out_Sum.GoodsId       
                        , tmpMI_out_Sum.Summ
                        , tmpMI_out_Sum.Amount
                        , 0 AS HeadCount
                  FROM tmpMI_sum AS tmpMI_out_Sum
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out_Sum.GoodsId
                  Where tmpMI_out_Sum.isActive = FALSE
                    AND inIsMovement           = FALSE
                    AND inIsPartion            = FALSE
                 ) AS tmpMI 
            GROUP BY tmpMI.GoodsId
           )
  , tmpMI_totalPartion AS
           (SELECT tmpMI.GoodsId 
                 , tmpMI.PartionGoods 
                 , -1* SUM (tmpMI.Summ) AS Summ
                 , -1* SUM (tmpMI.Amount) AS Amount
                 ,  SUM (tmpMI.HeadCount) AS HeadCount
            FROM (SELECT  tmpMI_out.GoodsId
                        , tmpMI_out.PartionGoods
                        , tmpMI_out.Summ
                        , tmpMI_out.Amount
                        , tmpMI_out.HeadCount
                  FROM tmpMI_Count AS tmpMI_out
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out.GoodsId
                  Where tmpMI_out.isActive = FALSE
                    AND inIsMovement       = FALSE
                    AND inIsPartion        = TRUE
                 UNION ALL
                  SELECT  tmpMI_out_Sum.GoodsId       
                        , tmpMI_out_Sum.PartionGoods
                        , tmpMI_out_Sum.Summ
                        , tmpMI_out_Sum.Amount
                        , 0 AS HeadCount
                  FROM tmpMI_sum AS tmpMI_out_Sum
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out_Sum.GoodsId
                  Where tmpMI_out_Sum.isActive = FALSE
                    AND inIsMovement           = FALSE
                    AND inIsPartion            = TRUE
                 ) AS tmpMI 
            GROUP BY tmpMI.GoodsId
                   , tmpMI.PartionGoods
           )
           
      -- ���������
      SELECT CAST (tmpOperationGroup.InvNumber AS TVarChar)    AS InvNumber
           , CAST (tmpOperationGroup.OperDate AS TDateTime)    AS OperDate
           , CAST (tmpOperationGroup.PartionGoods AS TVarChar) AS PartionGoods

           , Object_GoodsGroup.ValueData                       AS GoodsGroupName 
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName  

           , Object_StorageLine.ValueData                      AS StorageLineName

           , COALESCE (tmpMI_total.Amount,    COALESCE (tmpMI_totalPartion.Amount,    tmpOperationGroup.Amount))    :: TFloat AS Amount
           , COALESCE (tmpMI_total.HeadCount, COALESCE (tmpMI_totalPartion.HeadCount, tmpOperationGroup.HeadCount)) :: TFloat AS HeadCount

           , COALESCE (tmpMI_total.Summ, COALESCE (tmpMI_totalPartion.Summ, tmpOperationGroup.Summ))                :: TFloat AS Summ

           , Object_GoodsGroupChild.ValueData AS ChildGoodsGroupName 
           , Object_GoodsChild.ObjectCode     AS ChildGoodsCode
           , Object_GoodsChild.ValueData      AS ChildGoodsName
           , tmpOperationGroup.isCalculated :: Boolean

           , tmpOperationGroup.ChildAmount  :: TFloat AS ChildAmount

           , tmpOperationGroup.ChildSumm    :: TFloat AS ChildSumm
           , CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           
           , CASE WHEN tmpOperationGroup.ChildAmount <> 0 THEN COALESCE ((tmpOperationGroup.ChildSumm / tmpOperationGroup.ChildAmount) ,0) ELSE 0 END  :: TFloat         AS ChildPrice
           , CASE WHEN COALESCE (tmpMI_total.Amount, COALESCE (tmpMI_totalPartion.Amount, tmpOperationGroup.Amount)) <> 0 THEN COALESCE((tmpOperationGroup.ChildAmount * 100 / COALESCE (tmpMI_total.Amount, COALESCE (tmpMI_totalPartion.Amount, tmpOperationGroup.Amount))) ,0) ELSE 0 END :: TFloat   AS Percent  
           
           , CAST (ROW_NUMBER() OVER (PARTITION BY Object_Goods.ValueData, tmpOperationGroup.PartionGoods, tmpOperationGroup.InvNumber ORDER BY tmpOperationGroup.PartionGoods,tmpOperationGroup.InvNumber) AS Integer) AS Num

      FROM (SELECT CASE when inIsMovement = True THEN tmpMI.InvNumber ELSE '' END                      AS InvNumber
                 , CASE when inIsMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END AS OperDate
                 , CASE when inIsPartion = True THEN tmpMI.PartionGoods ELSE '' END                    AS PartionGoods
                 , tmpMI.GoodsId  
                 , tmpMI.StorageLineId     
                 , ABS (SUM(tmpMI.Summ))        AS Summ
                 , ABS (SUM(tmpMI.Amount))      AS Amount
                 , ABS (SUM(tmpMI.HeadCount))   AS HeadCount
                 , tmpMI.ChildGoodsId     
                 , ABS (SUM(tmpMI.ChildSumm))   AS ChildSumm
                 , ABS (SUM(tmpMI.ChildAmount)) AS ChildAmount
                 , tmpMI.isCalculated

            FROM (SELECT  tmpMI_out.InvNumber
                        , tmpMI_out.OperDate
                        , tmpMI_out.PartionGoods 
                        , tmpMI_out.GoodsId
                        , tmpMI_out.StorageLineId    
                        , tmpMI_out.Summ
                        , tmpMI_out.Amount
                        , tmpMI_out.HeadCount
                        , tmpMI_in.GoodsId  AS ChildGoodsId     
                        , tmpMI_in.Summ     AS ChildSumm
                        , tmpMI_in.Amount   AS ChildAmount
                        , tmpMI_in.isCalculated
                  FROM tmpMI_Count AS tmpMI_out
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out.GoodsId
                       LEFT JOIN tmpMI_Count AS tmpMI_in on tmpMI_in.MovementId = tmpMI_out.MovementId
                                                        AND tmpMI_in.isActive = TRUE
                       JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMI_in.GoodsId
                  Where tmpMI_out.isActive = FALSE
                   AND COALESCE (tmpMI_in.Amount, -1 ) <> 0
                 UNION ALL
                  SELECT  tmpMI_out_Sum.InvNumber
                        , tmpMI_out_Sum.OperDate
                        , tmpMI_out_Sum.PartionGoods 
                        , tmpMI_out_Sum.GoodsId 
                        , tmpMI_out_Sum.StorageLineId    
                        , tmpMI_out_Sum.Summ
                        , tmpMI_out_Sum.Amount
                        , 0 AS HeadCount
                        , tmpMI_in_Sum.GoodsId  AS ChildGoodsId     
                        , tmpMI_in_Sum.Summ     AS ChildSumm
                        , tmpMI_in_Sum.Amount   AS ChildAmount
                        , tmpMI_in_Sum.isCalculated
                  FROM tmpMI_sum AS tmpMI_out_Sum
                       JOIN tmpMI_sum AS tmpMI_in_Sum on tmpMI_out_Sum.MovementId = tmpMI_in_Sum.MovementId
                                                       AND tmpMI_in_Sum.isActive = TRUE
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out_Sum.GoodsId
                       JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMI_in_Sum.GoodsId
                  Where tmpMI_out_Sum.isActive = FALSE
                         
                 ) AS tmpMI 
                 GROUP BY CASE when inIsMovement = True THEN tmpMI.InvNumber ELSE '' END
                        , CASE when inIsMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END
                        , CASE when inIsPartion = True THEN tmpMI.PartionGoods ELSE '' END 
                        , tmpMI.GoodsId       
                        , tmpMI.ChildGoodsId   
                        , tmpMI.StorageLineId
                        , tmpMI.isCalculated
            ) AS tmpOperationGroup

             LEFT JOIN tmpMI_total        ON tmpMI_total.GoodsId             = tmpOperationGroup.GoodsId
             LEFT JOIN tmpMI_totalPartion ON tmpMI_totalPartion.GoodsId      = tmpOperationGroup.GoodsId
                                         AND tmpMI_totalPartion.PartionGoods = tmpOperationGroup.PartionGoods

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsChild on Object_GoodsChild.Id = tmpOperationGroup.ChildGoodsId

             LEFT JOIN Object AS Object_StorageLine on Object_StorageLine.Id = tmpOperationGroup.StorageLineId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupChild
                                  ON ObjectLink_Goods_GoodsGroupChild.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_Goods_GoodsGroupChild.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroupChild ON Object_GoodsGroupChild.Id = ObjectLink_Goods_GoodsGroupChild.ChildObjectId

             LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_ProductionSeparate(), inOperDate:= inEndDate)
                                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = Object_GoodsChild.Id

      ORDER BY tmpOperationGroup.InvNumber
             , tmpOperationGroup.OperDate
             , tmpOperationGroup.PartionGoods 
             , Object_GoodsGroup.ValueData 
             , Object_Goods.ObjectCode     
             , Object_Goods.ValueData      
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.11.16         *
 27.11.14         *
 19.11.14         *
 21.08.14         * 
*/

-- ����
-- SELECT * FROM gpReport_GoodsMI_ProductionSeparate (inStartDate:= '03.06.2016', inEndDate:= '03.06.2016', inIsMovement:= FALSE, inIsPartion:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inChildGoodsGroupId:= 0, inChildGoodsId:=0, inFromId:= 0, inToId:= 0, inSession:= zfCalc_UserAdmin());
-- select * from gpReport_GoodsMI_ProductionSeparate (inStartDate := ('13.10.2018')::TDateTime , inEndDate := ('14.10.2018')::TDateTime , inIsMovement := 'true' , inIsPartion := 'true' , inIsStorageLine := 'true' , inisCalculated := 'true', inGoodsGroupId := 0 , inGoodsId := 0 , inChildGoodsGroupId := 0 , inChildGoodsId := 0 , inFromId := 133049  , inToId := 133049  ,  inSession := '5') as tt
--
