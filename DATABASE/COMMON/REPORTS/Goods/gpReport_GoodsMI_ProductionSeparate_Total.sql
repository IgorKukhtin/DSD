 -- Function: gpReport_GoodsMI_ProductionSeparate_Total ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate_Total (TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionSeparate_Total (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inIsPartion          Boolean   ,
    IN inIsStorageLine      Boolean   ,
    IN inisCalculated       Boolean   ,   -- "показать Calculated" + добавить в грид
    IN inisDetail           Boolean   ,   -- "показать расходную часть"  да/нет
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inChildGoodsGroupId  Integer   ,
    IN inChildGoodsId       Integer   ,
    IN inFromId             Integer   ,    -- от кого 
    IN inToId               Integer   ,    -- кому
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , FromName TVarChar, ToName TVarChar
             
             , PartionGoods  TVarChar, PartionGoods_main  TVarChar, PartionGoods_main2  TVarChar 
             , PartionGoods_Date TVarChar --TDateTime 
             , FromCode_partion Integer, FromName_partion TVarChar
             
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , StorageLineName TVarChar, StorageLineName_in TVarChar
             , Amount TFloat, HeadCount TFloat, Summ TFloat
             , ChildGoodsGroupName TVarChar, ChildGoodsCode Integer,  ChildGoodsName TVarChar
             , ChildGoodsKindName TVarChar
             , isCalculated Boolean
             , ChildAmount TFloat, ChildSumm TFloat, Price TFloat
             , ChildPrice TFloat, Percent TFloat
             , Num Integer
             )   
AS
$BODY$
    DECLARE vbDescId Integer; 
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- !!!Временно!!
    -- inIsMovement:= NOT inIsMovement;
    -- inIsPartion:= NOT inIsPartion;

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpChildGoods (ChildGoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpToGroup (ToId  Integer) ON COMMIT DROP;
  
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
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
          SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inChildGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inChildGoodsId <> 0
         THEN
             INSERT INTO _tmpChildGoods (ChildGoodsId)
              SELECT inChildGoodsId;
         ELSE
             INSERT INTO _tmpChildGoods (ChildGoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;


    -- ограничения по ОТ КОГО
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpFromGroup (FromId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpFromGroup (FromId)
          SELECT Id FROM Object_Unit_View;  --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;

    -- ограничения по КОМУ
    IF inToId <> 0
    THEN
        INSERT INTO _tmpToGroup (ToId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        INSERT INTO _tmpToGroup (ToId)
          SELECT Id FROM Object_Unit_View ;   --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;

    -- Результат
    RETURN QUERY
    
    -- ограничиваем по виду документа  , по от кого / кому
    WITH tmpMovement AS (SELECT tmp.*
                              , zfConvert_StringToNumber (REPLACE ( SUBSTR (tmp.PartionGoods_main, Position ('-' in tmp.PartionGoods_main)  +1 , length (tmp.PartionGoods_main)-11 - Position ('-' in tmp.PartionGoods_main) +1), '-', '')) ::Integer AS FromCode_partion
                         FROM (SELECT Movement.Id        AS MovementId
                                    , Movement.InvNumber AS InvNumber
                                    , Movement.OperDate  AS OperDate
                                    , MovementString_PartionGoods.ValueData AS PartionGoods 
                                    , MovementLinkObject_From.ObjectId AS FromId
                                    , MovementLinkObject_To.ObjectId   AS ToId   
                                    , CASE WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'пр-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                           WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'об-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                           WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'мо-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                           WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'тр-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                           ELSE MovementString_PartionGoods.ValueData ::TVarChar
                                      END ::TVarChar AS PartionGoods_main
                                    --, LEFT ( MovementString_PartionGoods.ValueData ::TVarChar, length (MovementString_PartionGoods.ValueData)-11 )  ::TVarChar AS PartionGoods_main2  
                                    , CASE WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'пр-%' THEN LEFT ( MovementString_PartionGoods.ValueData ::TVarChar, length (MovementString_PartionGoods.ValueData)-11 )  ::TVarChar
                                           WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'об-%' THEN LEFT ( MovementString_PartionGoods.ValueData ::TVarChar, length (MovementString_PartionGoods.ValueData)-11 )  ::TVarChar
                                           WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'мо-%' THEN LEFT ( MovementString_PartionGoods.ValueData ::TVarChar, length (MovementString_PartionGoods.ValueData)-11 )  ::TVarChar
                                           WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'тр-%' THEN LEFT ( MovementString_PartionGoods.ValueData ::TVarChar, length (MovementString_PartionGoods.ValueData)-11 )  ::TVarChar
                                           ELSE '' ::TVarChar
                                      END ::TVarChar AS PartionGoods_main2
                               FROM Movement 
                                    LEFT JOIN MovementString AS MovementString_PartionGoods
                                                             ON MovementString_PartionGoods.MovementId = Movement.Id
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
                                      , MovementLinkObject_From.ObjectId
                                      , MovementLinkObject_To.ObjectId
                                      , CASE WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'пр-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                             WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'об-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                             WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'мо-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                             WHEN MovementString_PartionGoods.ValueData ::TVarChar LIKE 'тр-%' THEN SUBSTRING (MovementString_PartionGoods.ValueData::TVarChar FROM 4)
                                             ELSE MovementString_PartionGoods.ValueData ::TVarChar
                                        END 
                               )AS tmp
                         )

, tmpMI_Container AS (SELECT tmpMovement.MovementId                          AS MovementId
                           , tmpMovement.InvNumber                           AS InvNumber
                           , tmpMovement.OperDate                            AS OperDate
                           , tmpMovement.FromId
                           , tmpMovement.ToId
                           , tmpMovement.PartionGoods                        AS PartionGoods
                           , tmpMovement.PartionGoods_main
                           , tmpMovement.PartionGoods_main2 
                           , tmpMovement.FromCode_partion
                           , MIContainer.ObjectId_Analyzer                   AS GoodsId
                          -- , 0 AS Summ
                           , SUM (MIContainer.Amount)                        AS Amount
                           , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount
                           , MIContainer.DescId                              AS MIContainerDescId
                           , MIContainer.isActive                            AS isActive
                           , CASE WHEN inisCalculated = TRUE THEN COALESCE (MIBoolean_Calculated.ValueData, FALSE) ELSE FALSE END  ::Boolean AS isCalculated
                           , CASE WHEN inIsStorageLine = TRUE THEN MILinkObject_StorageLine_in.ObjectId ELSE 0 END  AS StorageLineId_in
                           , CASE WHEN inIsStorageLine = TRUE THEN MILinkObject_StorageLine_out.ObjectId ELSE 0 END AS StorageLineId_out
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                      FROM tmpMovement
                           JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.MovementId = tmpMovement.MovementId
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                                                      AND MIContainer.isActive = FALSE
                                                      
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine_in
                                                            ON MILinkObject_StorageLine_in.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_StorageLine_in.DescId = zc_MILinkObject_StorageLine()
                                                           AND MIContainer.isActive = TRUE
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine_out
                                                            ON MILinkObject_StorageLine_out.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_StorageLine_out.DescId = zc_MILinkObject_StorageLine()
                                                           AND MIContainer.isActive = FALSE

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                           LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                         ON MIBoolean_Calculated.MovementItemId = MIContainer.MovementItemId
                                                        AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                      --WHERE MIContainer.isActive = inisDetail OR inisDetail = TRUE
                      GROUP BY tmpMovement.MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , tmpMovement.PartionGoods
                             , tmpMovement.PartionGoods_main
                             , tmpMovement.PartionGoods_main2
                             , tmpMovement.FromCode_partion
                             , MIContainer.ObjectId_Analyzer
                             , MIContainer.DescId
                             , MIContainer.isActive
                             , CASE WHEN inIsStorageLine = TRUE THEN MILinkObject_StorageLine_in.ObjectId  ELSE 0 END
                             , CASE WHEN inIsStorageLine = TRUE THEN MILinkObject_StorageLine_out.ObjectId ELSE 0 END
                             , CASE WHEN inisCalculated = TRUE THEN COALESCE (MIBoolean_Calculated.ValueData, FALSE) ELSE FALSE END
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                             , tmpMovement.FromId
                             , tmpMovement.ToId
                      )
                         
      , tmpMI_Count AS (SELECT tmpMI_Container.MovementId 
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.FromId
                             , tmpMI_Container.ToId
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoods
                             , tmpMI_Container.PartionGoods_main
                             , tmpMI_Container.PartionGoods_main2
                             , tmpMI_Container.FromCode_partion
                             , tmpMI_Container.GoodsId 
                             , tmpMI_Container.StorageLineId_in
                             , tmpMI_Container.StorageLineId_out
                             , tmpMI_Container.GoodsKindId
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
                             , tmpMI_Container.PartionGoods_main 
                             , tmpMI_Container.PartionGoods_main2
                             , tmpMI_Container.FromCode_partion
                             , tmpMI_Container.GoodsId 
                             , tmpMI_Container.StorageLineId_in
                             , tmpMI_Container.StorageLineId_out
                             , tmpMI_Container.isActive
                             , tmpMI_Container.isCalculated
                             , tmpMI_Container.GoodsKindId
                             , tmpMI_Container.FromId
                             , tmpMI_Container.ToId
                           )

  , tmpMI_sum AS (SELECT tmpMI_Container.MovementId 
                       , tmpMI_Container.InvNumber
                       , tmpMI_Container.OperDate
                       , tmpMI_Container.FromId
                       , tmpMI_Container.ToId
                       , tmpMI_Container.PartionGoods
                       , tmpMI_Container.PartionGoods_main
                       , tmpMI_Container.PartionGoods_main2
                       , tmpMI_Container.FromCode_partion
                       , tmpMI_Container.GoodsId 
                       , tmpMI_Container.StorageLineId_in
                       , tmpMI_Container.StorageLineId_out
                       , tmpMI_Container.GoodsKindId
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
                         , tmpMI_Container.PartionGoods_main
                         , tmpMI_Container.PartionGoods_main2
                         , tmpMI_Container.FromCode_partion
                         , tmpMI_Container.GoodsId
                         , tmpMI_Container.StorageLineId_in
                         , tmpMI_Container.StorageLineId_out
                         , tmpMI_Container.isActive
                         , tmpMI_Container.isCalculated
                         , tmpMI_Container.GoodsKindId
                         , tmpMI_Container.FromId
                         , tmpMI_Container.ToId
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
                 , tmpMI.PartionGoods_main
                 , tmpMI.PartionGoods_main2 
                 , -1* SUM (tmpMI.Summ) AS Summ
                 , -1* SUM (tmpMI.Amount) AS Amount
                 ,  SUM (tmpMI.HeadCount) AS HeadCount
            FROM (SELECT  tmpMI_out.GoodsId
                        , tmpMI_out.PartionGoods
                        , tmpMI_out.PartionGoods_main
                        , tmpMI_out.PartionGoods_main2
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
                        , tmpMI_out_Sum.PartionGoods_main
                        , tmpMI_out_Sum.PartionGoods_main2
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
                   , tmpMI.PartionGoods_main
                   , tmpMI.PartionGoods_main2
           )
 
   , tmpMI_totalMovement AS
           (SELECT tmpMI.GoodsId 
                 , tmpMI.MovementId
                 , -1* SUM (tmpMI.Summ) AS Summ
                 , -1* SUM (tmpMI.Amount) AS Amount
                 ,  SUM (tmpMI.HeadCount) AS HeadCount
            FROM (SELECT  tmpMI_out.GoodsId
                        , tmpMI_out.MovementId
                        , tmpMI_out.Summ
                        , tmpMI_out.Amount
                        , tmpMI_out.HeadCount
                  FROM tmpMI_Count AS tmpMI_out
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out.GoodsId
                  Where tmpMI_out.isActive = FALSE
                    AND inIsMovement       = TRUE
                    AND inIsPartion        = TRUE
                 UNION ALL
                  SELECT  tmpMI_out_Sum.GoodsId       
                        , tmpMI_out_Sum.MovementId
                        , tmpMI_out_Sum.Summ
                        , tmpMI_out_Sum.Amount
                        , 0 AS HeadCount
                  FROM tmpMI_sum AS tmpMI_out_Sum
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out_Sum.GoodsId
                  Where tmpMI_out_Sum.isActive = FALSE
                    AND inIsMovement           = TRUE
                    AND inIsPartion            = TRUE
                 ) AS tmpMI 
            GROUP BY tmpMI.GoodsId
                   , tmpMI.MovementId
           )
                     
      -- РЕЗУЛЬТАТ
      SELECT CAST (tmpOperationGroup.MovementId AS Integer)    AS MovementId
           , CAST (tmpOperationGroup.InvNumber AS TVarChar)    AS InvNumber
           , CAST (tmpOperationGroup.OperDate AS TDateTime)    AS OperDate
           , Object_From.ValueData            ::TVarChar       AS FromName
           , Object_To.ValueData              ::TVarChar       AS ToName

           , CAST (tmpOperationGroup.PartionGoods AS TVarChar)::TVarChar  AS PartionGoods
         /*  , CASE WHEN tmpOperationGroup.PartionGoods ::TVarChar LIKE 'пр-%' THEN SUBSTRING (tmpOperationGroup.PartionGoods::TVarChar FROM 4)
                  WHEN tmpOperationGroup.PartionGoods ::TVarChar LIKE 'об-%' THEN SUBSTRING (tmpOperationGroup.PartionGoods::TVarChar FROM 4)
                  WHEN tmpOperationGroup.PartionGoods ::TVarChar LIKE 'мо-%' THEN SUBSTRING (tmpOperationGroup.PartionGoods::TVarChar FROM 4)
                  ELSE tmpOperationGroup.PartionGoods ::TVarChar
             END ::TVarChar AS PartionGoods_main
          */
           , tmpOperationGroup.PartionGoods_main  ::TVarChar
           --, tmpOperationGroup.PartionGoods_main2 ::TVarChar
           , CASE WHEN tmpOperationGroup.PartionGoods ::TVarChar LIKE 'пр-%' THEN LEFT ( tmpOperationGroup.PartionGoods ::TVarChar, length (tmpOperationGroup.PartionGoods)-11 )  ::TVarChar
                  WHEN tmpOperationGroup.PartionGoods ::TVarChar LIKE 'об-%' THEN LEFT ( tmpOperationGroup.PartionGoods ::TVarChar, length (tmpOperationGroup.PartionGoods)-11 )  ::TVarChar
                  WHEN tmpOperationGroup.PartionGoods ::TVarChar LIKE 'мо-%' THEN LEFT ( tmpOperationGroup.PartionGoods ::TVarChar, length (tmpOperationGroup.PartionGoods)-11 )  ::TVarChar
                  WHEN tmpOperationGroup.PartionGoods ::TVarChar LIKE 'тр-%' THEN LEFT ( tmpOperationGroup.PartionGoods ::TVarChar, length (tmpOperationGroup.PartionGoods)-11 )  ::TVarChar
                  ELSE '' ::TVarChar
             END ::TVarChar AS PartionGoods_main2
           , Right (tmpOperationGroup.PartionGoods_main ,10) ::TVarChar  AS  PartionGoods_Date 
           , Object_From_partion.ObjectCode::Integer    AS FromCode_partion
           , Object_From_partion.ValueData ::TVarChar   AS FromName_partion
           
           , Object_GoodsGroup.Id                              AS GoodsGroupId
           , Object_GoodsGroup.ValueData                       AS GoodsGroupName
           , Object_Goods.Id                                   AS GoodsId
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName
           , Object_GoodsKind.ValueData                        AS GoodsKindName

           , Object_StorageLine_out.ValueData                  AS StorageLineName
           , Object_StorageLine_in.ValueData                   AS StorageLineName_in

           , COALESCE (tmpMI_total.Amount,    tmpMI_totalPartion.Amount,    tmpMI_totalMovement.Amount,    tmpOperationGroup.Amount)    :: TFloat AS Amount
           , COALESCE (tmpMI_total.HeadCount, tmpMI_totalPartion.HeadCount, tmpMI_totalMovement.HeadCount, tmpOperationGroup.HeadCount) :: TFloat AS HeadCount

           , COALESCE (tmpMI_total.Summ, tmpMI_totalPartion.Summ, tmpMI_totalMovement.Summ, tmpOperationGroup.Summ)                     :: TFloat AS Summ

           , Object_GoodsGroupChild.ValueData AS ChildGoodsGroupName 
           , Object_GoodsChild.ObjectCode     AS ChildGoodsCode
           , Object_GoodsChild.ValueData      AS ChildGoodsName
           , Object_GoodsKindChild.ValueData  AS ChildGoodsKindName
           , tmpOperationGroup.isCalculated :: Boolean

           , tmpOperationGroup.ChildAmount  :: TFloat AS ChildAmount

           , tmpOperationGroup.ChildSumm    :: TFloat AS ChildSumm
           , CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           
           , CASE WHEN tmpOperationGroup.ChildAmount <> 0 THEN COALESCE ((tmpOperationGroup.ChildSumm / tmpOperationGroup.ChildAmount) ,0) ELSE 0 END  :: TFloat         AS ChildPrice
           , CASE WHEN COALESCE (tmpMI_total.Amount, COALESCE (tmpMI_totalPartion.Amount, tmpOperationGroup.Amount)) <> 0 THEN COALESCE((tmpOperationGroup.ChildAmount * 100 / COALESCE (tmpMI_total.Amount, COALESCE (tmpMI_totalPartion.Amount, tmpOperationGroup.Amount))) ,0) ELSE 0 END :: TFloat   AS Percent  
           
           , CAST (ROW_NUMBER() OVER (PARTITION BY Object_Goods.ValueData, tmpOperationGroup.PartionGoods, tmpOperationGroup.InvNumber ORDER BY tmpOperationGroup.PartionGoods,tmpOperationGroup.InvNumber) AS Integer) AS Num
           
      FROM (SELECT CASE WHEN inIsMovement = True THEN tmpMI.MovementId ELSE 0 END                      AS MovementId
                 , CASE WHEN inIsMovement = True THEN tmpMI.InvNumber ELSE '' END                      AS InvNumber
                 , CASE WHEN inIsMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END AS OperDate
                 , CASE WHEN inIsMovement = True THEN tmpMI.FromId ELSE 0 END                          AS FromId
                 , CASE WHEN inIsMovement = True THEN tmpMI.ToId ELSE 0 END                            AS ToId
                 , CASE WHEN inIsPartion = True THEN tmpMI.PartionGoods ELSE '' END                    AS PartionGoods
                 , CASE WHEN inIsPartion = True THEN tmpMI.PartionGoods_main ELSE '' END               AS PartionGoods_main
                 , CASE WHEN inIsPartion = True THEN tmpMI.FromCode_partion ELSE 0 END                 AS FromCode_partion
                 , tmpMI.GoodsId  
                 , tmpMI.GoodsKindId
                 , tmpMI.StorageLineId_in
                 , tmpMI.StorageLineId_out
                 , ABS (SUM(tmpMI.Summ))        AS Summ
                 , ABS (SUM(tmpMI.Amount))      AS Amount
                 , ABS (SUM(tmpMI.HeadCount))   AS HeadCount
                 , tmpMI.ChildGoodsId     
                 , tmpMI.ChildGoodsKindId
                 , ABS (SUM(tmpMI.ChildSumm))   AS ChildSumm
                 , ABS (SUM(tmpMI.ChildAmount)) AS ChildAmount
                 , tmpMI.isCalculated

            FROM (SELECT  tmpMI_out.MovementId
                        , tmpMI_out.InvNumber
                        , tmpMI_out.OperDate
                        , tmpMI_out.FromId
                        , tmpMI_out.ToId
                        , tmpMI_out.PartionGoods
                        , tmpMI_out.PartionGoods_main
                        , tmpMI_out.FromCode_partion
                        , tmpMI_out.GoodsId
                        , tmpMI_out.GoodsKindId
                        , tmpMI_out.StorageLineId_out
                        , tmpMI_in.StorageLineId_in
                        , tmpMI_out.Summ
                        , tmpMI_out.Amount
                        , tmpMI_out.HeadCount
                        , tmpMI_in.GoodsId      AS ChildGoodsId
                        , tmpMI_in.GoodsKindId  AS ChildGoodsKindId   
                        , tmpMI_in.Summ         AS ChildSumm
                        , tmpMI_in.Amount       AS ChildAmount
                        , tmpMI_in.isCalculated
                  FROM tmpMI_Count AS tmpMI_out
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out.GoodsId
                       LEFT JOIN tmpMI_Count AS tmpMI_in on tmpMI_in.MovementId = tmpMI_out.MovementId
                                                        AND tmpMI_in.isActive = TRUE 
                                                        AND inisDetail = TRUE
                       JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMI_in.GoodsId OR inisDetail = False
                  Where tmpMI_out.isActive = FALSE
                   AND COALESCE (tmpMI_in.Amount, -1 ) <> 0
                 UNION ALL
                  SELECT  tmpMI_out_Sum.MovementId
                        , tmpMI_out_Sum.InvNumber
                        , tmpMI_out_Sum.OperDate
                        , tmpMI_out_Sum.FromId
                        , tmpMI_out_Sum.ToId
                        , tmpMI_out_Sum.PartionGoods
                        , tmpMI_out_Sum.PartionGoods_main
                        , tmpMI_out_Sum.FromCode_partion 
                        , tmpMI_out_Sum.GoodsId
                        , tmpMI_out_Sum.GoodsKindId
                        , tmpMI_out_Sum.StorageLineId_out
                        , tmpMI_in_Sum.StorageLineId_in

                        , tmpMI_out_Sum.Summ
                        , tmpMI_out_Sum.Amount
                        , 0 AS HeadCount
                        , tmpMI_in_Sum.GoodsId      AS ChildGoodsId     
                        , tmpMI_in_Sum.GoodsKindId  AS ChildGoodsKindId
                        , tmpMI_in_Sum.Summ         AS ChildSumm
                        , tmpMI_in_Sum.Amount       AS ChildAmount
                        , tmpMI_in_Sum.isCalculated
                  FROM tmpMI_sum AS tmpMI_out_Sum
                       JOIN tmpMI_sum AS tmpMI_in_Sum on tmpMI_out_Sum.MovementId = tmpMI_in_Sum.MovementId
                                                       AND tmpMI_in_Sum.isActive = TRUE
                                                       AND inisDetail = TRUE
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out_Sum.GoodsId
                       JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMI_in_Sum.GoodsId OR inisDetail = False
                  Where tmpMI_out_Sum.isActive = FALSE
 
                 ) AS tmpMI 
                 GROUP BY CASE WHEN inIsMovement = True THEN tmpMI.MovementId ELSE 0 END
                        , CASE WHEN inIsMovement = True THEN tmpMI.InvNumber ELSE '' END
                        , CASE WHEN inIsMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END
                        , CASE WHEN inIsMovement = True THEN tmpMI.FromId ELSE 0 END
                        , CASE WHEN inIsMovement = True THEN tmpMI.ToId ELSE 0 END
                        , CASE WHEN inIsPartion  = True THEN tmpMI.PartionGoods ELSE '' END 
                        , CASE WHEN inIsPartion  = True THEN tmpMI.PartionGoods_main ELSE '' END
                        , CASE WHEN inIsPartion  = True THEN tmpMI.FromCode_partion ELSE 0 END
                        , tmpMI.GoodsId 
                        , tmpMI.GoodsKindId     
                        , tmpMI.ChildGoodsId
                        , tmpMI.ChildGoodsKindId
                        , tmpMI.StorageLineId_in
                        , tmpMI.StorageLineId_out
                        , tmpMI.isCalculated
            ) AS tmpOperationGroup

             LEFT JOIN tmpMI_total        ON tmpMI_total.GoodsId             = tmpOperationGroup.GoodsId
             LEFT JOIN tmpMI_totalPartion ON tmpMI_totalPartion.GoodsId      = tmpOperationGroup.GoodsId
                                         AND tmpMI_totalPartion.PartionGoods = tmpOperationGroup.PartionGoods
             LEFT JOIN tmpMI_totalMovement ON tmpMI_totalMovement.GoodsId    = tmpOperationGroup.GoodsId
                                          AND tmpMI_totalMovement.MovementId = tmpOperationGroup.MovementId


             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsChild on Object_GoodsChild.Id = tmpOperationGroup.ChildGoodsId
             
             LEFT JOIN Object AS Object_GoodsKind on Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindChild on Object_GoodsKindChild.Id = tmpOperationGroup.ChildGoodsKindId

             LEFT JOIN Object AS Object_StorageLine_out ON Object_StorageLine_out.Id = tmpOperationGroup.StorageLineId_out
             LEFT JOIN Object AS Object_StorageLine_in  ON Object_StorageLine_in.Id  = tmpOperationGroup.StorageLineId_in

             LEFT JOIN Object AS Object_From ON Object_From.Id = tmpOperationGroup.FromId
             LEFT JOIN Object AS Object_To ON Object_To.Id = tmpOperationGroup.ToId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupChild
                                  ON ObjectLink_Goods_GoodsGroupChild.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_Goods_GoodsGroupChild.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroupChild ON Object_GoodsGroupChild.Id = ObjectLink_Goods_GoodsGroupChild.ChildObjectId

             LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_ProductionSeparate(), inOperDate:= inEndDate)
                    AS lfObjectHistory_PriceListItem 
                    ON lfObjectHistory_PriceListItem.GoodsId = Object_GoodsChild.Id
                   AND lfObjectHistory_PriceListItem.GoodsKindId IS NULL  
                   
             LEFT JOIN Object AS Object_From_partion ON Object_From_partion.ObjectCode = tmpOperationGroup.FromCode_partion
                                                    AND Object_From_partion.DescId = zc_Object_Partner()
                                                    AND COALESCE (tmpOperationGroup.FromCode_partion,0) <> 0


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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.25         * gpReport_GoodsMI_ProductionSeparate_Total
 31.01.22         *
 30.11.16         *
 27.11.14         *
 19.11.14         *
 21.08.14         * 
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_ProductionSeparate_Total (inStartDate:= '17.12.2024' , inEndDate:= '17.12.2024', inIsMovement:= False, inIsPartion:= 'False', inIsStorageLine:= False, inisCalculated:= False, inisDetail:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 5225, inChildGoodsGroupId:= 0, inChildGoodsId:= 0, inFromId:= 0, inToId:= 0, inSession:= '9457');

--select * from gpReport_GoodsMI_ProductionSeparate_Total(inStartDate := ('06.06.2025')::TDateTime , inEndDate := ('06.06.2025')::TDateTime , inIsMovement := 'True' , inIsPartion := 'True' , inIsStorageLine := 'False' , inisCalculated := 'False',inisDetail:= True, inGoodsGroupId := 0 , inGoodsId := 4234 , inChildGoodsGroupId := 0 , inChildGoodsId := 0 , inFromId := 0 , inToId := 0 ,  inSession := '9457');