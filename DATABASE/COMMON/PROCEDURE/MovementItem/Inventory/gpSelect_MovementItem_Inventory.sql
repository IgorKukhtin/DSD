-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_old TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , HeadCount TFloat, Count TFloat
             , Price TFloat, Summ TFloat
             , Price_pr TFloat, Summ_pr TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar
             , PartNumber TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsKindId_Complete Integer, GoodsKindName_Complete  TVarChar
             , AssetId Integer, AssetName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , StorageId Integer, StorageName TVarChar
             , PartionModelId Integer, PartionModelName TVarChar
             , PartionCellCode_1 Integer, PartionCellName_1 TVarChar
             , ContainerId Integer
             , isErased Boolean
             , PartionGoodsId Integer
             , IdBarCode TVarChar
             , OperDate TDateTime 
             
           --  , Price_Partion     TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     --
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     --
     vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

     --
     vbPriceListId := COALESCE ((SELECT MovementLinkObject_PriceList.ObjectId
                                 FROM MovementLinkObject AS MovementLinkObject_PriceList
                                 WHERE MovementLinkObject_PriceList.MovementId = inMovementId
                                   AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList())
                                 , zc_PriceList_Basis()
                                 );


     -- inShowAll:= TRUE;

     IF inShowAll = TRUE
     THEN

     RETURN QUERY
       WITH tmpPrice AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                              , lfObjectHistory_PriceListItem.GoodsKindId
                              , lfObjectHistory_PriceListItem.ValuePrice AS Price
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) + INTERVAL '1 DAY')
                              AS lfObjectHistory_PriceListItem
                         WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                        )  
           -- ���� �� ������
          , tmpPricePR AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , lfObjectHistory_PriceListItem.GoodsKindId
                                , lfObjectHistory_PriceListItem.ValuePrice AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                                AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )

            --����� �������� �� ��������
          , tmpContainer AS (SELECT MIContainer.MovementItemId
                                 , SUM (MIContainer.Amount) AS Amount
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementId = inMovementId  
                               AND MIContainer.MovementDescId = zc_Movement_Inventory()
                               AND MIContainer.DescId = zc_MIContainer_Count()
                             GROUP BY  MIContainer.MovementItemId
                             )

       SELECT
             0 AS Id
           , tmpGoods.GoodsId
           , tmpGoods.GoodsCode
           , tmpGoods.GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat)              AS Amount
           , CAST (NULL AS TFloat)              AS HeadCount
           , CAST (NULL AS TFloat)              AS Count
           , COALESCE (tmpPrice_Kind.Price, tmpPrice.Price) :: TFloat AS Price
           , CAST (NULL AS TFloat)              AS Summ
           , COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price) :: TFloat AS Price_pr
           , CAST (NULL AS TFloat)              AS Summ_pr 
           , CAST (NULL AS TDateTime)           AS PartionGoodsDate
           , CAST (NULL AS TVarChar)            AS PartionGoods 
           , CAST (NULL AS TVarChar)            AS PartNumber
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , CAST (NULL AS Integer)             AS GoodsKindId_Complete
           , CAST (NULL AS TVarchar)            AS GoodsKindName_Complete
           , CAST (0 AS Integer)                AS AssetId
           , CAST (NULL AS TVarChar)            AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , CAST (0 AS Integer)                AS UnitId
           , CAST (NULL AS TVarChar)            AS UnitName
           , CAST (0 AS Integer)                AS StorageId
           , CAST (NULL AS TVarChar)            AS StorageName
           , CAST (0 AS Integer)                AS PartionModelId
           , CAST (NULL AS TVarChar)            AS PartionModelName
           , CAST (0 AS Integer)                AS PartionCellCode_1
           , CAST (NULL AS TVarChar)            AS PartionCellName_1

           , 0 :: Integer AS ContainerId

           , FALSE        AS isErased

           , 0 :: Integer                    AS PartionGoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), tmpGoods.GoodsId) :: TVarChar AS IdBarCode
           , Null ::TDateTime  AS OperDate
         --  , CAST (NULL AS TFloat)           AS Price_Partion
           
       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId
                  , ObjectLink_Goods_InfoMoney.ChildObjectId                          AS InfoMoneyId
             FROM Object AS Object_Goods
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                       ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                      AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND (ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ��������� + ������ ������ �����
                                                          OR ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                                                            )
             WHERE Object_Goods.DescId = zc_Object_Goods()
               AND Object_Goods.isErased = FALSE
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpGoods.InfoMoneyId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- ����������� ���� 2 ���� �� ���� ������ � ���
            LEFT JOIN tmpPrice AS tmpPrice_Kind 
                               ON tmpPrice_Kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL


            -- ����������� ���� �� ������ 2 ���� �� ���� ������ � ���
            LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                                 ON tmpPricePR_Kind.GoodsId = tmpGoods.GoodsId
                                AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = tmpGoods.GoodsId
                                AND tmpPricePR.GoodsKindId IS NULL

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                AS Amount
           , MIFloat_HeadCount.ValueData        AS HeadCount
           , MIFloat_Count.ValueData            AS Count
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectFloat_Price_Partion.ValueData ELSE (CASE WHEN MIFloat_Price.ValueData <> 0 THEN MIFloat_Price.ValueData ELSE COALESCE (tmpPrice_Kind.Price, tmpPrice.Price) END) END:: TFloat AS Price
           , MIFloat_Summ.ValueData   :: TFloat AS Summ    

           , COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)                         ::TFloat AS Price_pr
           , (tmpContainer.Amount * COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)) ::TFloat AS Summ_pr

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectDate_Value.ValueData    ELSE MIDate_PartionGoods.ValueData   END AS PartionGoodsDate
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 AND Object_PartionGoods.ValueData <> '0' THEN Object_PartionGoods.ValueData ELSE MIString_PartionGoods.ValueData END AS PartionGoods
           , CASE WHEN COALESCE (MIString_PartNumber.ValueData,'') = '' THEN ObjectString_PartNumber.ValueData ELSE MIString_PartNumber.ValueData END :: TVarChar     AS PartNumber
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete
           , Object_Asset.Id                    AS AssetId
           , Object_Asset.ValueData             AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.Id ELSE Object_Unit.Id               END AS UnitId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.ValueData ELSE Object_Unit.ValueData END AS UnitName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.Id ELSE Object_Storage.Id               END AS StorageId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.ValueData ELSE Object_Storage.ValueData END AS StorageName 
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_PartionModel_Partion.Id ELSE Object_PartionModel.Id               END AS PartionModelId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_PartionModel_Partion.ValueData ELSE Object_PartionModel.ValueData END AS PartionModelName

           , Object_PartionCell_1.ObjectCode    AS PartionCellCode_1
           , Object_PartionCell_1.ValueData     AS PartionCellName_1

           , MIFloat_ContainerId.ValueData :: Integer AS ContainerId
           , MovementItem.isErased              AS isErased
           
           -- �� ������
           , Object_PartionGoods.Id                AS PartionGoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.Id) :: TVarChar AS IdBarCode
           , Null ::TDateTime  AS OperDate
           
/*         , ObjectFloat_Price_Partion.ValueData   AS Price_Partion
           
           , Object_Storage_Partion.Id             AS StorageId_Partion
           , Object_Storage_Partion.ValueData      AS StorageName_Partion
          
           , Object_Unit_Partion.Id                AS UnitId_Partion
           , Object_Unit_Partion.ValueData         AS UnitName_Partion
*/
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionModel
                                             ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionModel.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = MILinkObject_PartionModel.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell
                                        ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell.DescId = zc_MIFloat_PartionCell()
            LEFT JOIN Object AS Object_PartionCell_1 ON Object_PartionCell_1.Id = MIFloat_PartionCell.ValueData :: Integer

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- ����������� ���� 2 ���� �� ���� ������ � ���
            LEFT JOIN tmpPrice AS tmpPrice_Kind 
                               ON tmpPrice_Kind.GoodsId = MovementItem.ObjectId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                              AND tmpPrice.GoodsKindId IS NULL

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
            -- �������� �� ������
            LEFT JOIN ObjectDate AS ObjectDate_Value 
                                 ON ObjectDate_Value.ObjectId = MILinkObject_PartionGoods.ObjectId                      -- ����
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()
            LEFT JOIN ObjectString AS ObjectString_PartNumber
                                   ON ObjectString_PartNumber.ObjectId = MILinkObject_PartionGoods.ObjectId             -- ���. �����
                                  AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

            LEFT JOIN ObjectFloat AS ObjectFloat_Price_Partion 
                                  ON ObjectFloat_Price_Partion.ObjectId = MILinkObject_PartionGoods.ObjectId                 -- ����
                                 AND ObjectFloat_Price_Partion.DescId = zc_ObjectFloat_PartionGoods_Price()    

            LEFT JOIN ObjectLink AS ObjectLink_Unit 
                                 ON ObjectLink_Unit.ObjectId = MILinkObject_PartionGoods.ObjectId		                -- �������������
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
            LEFT JOIN Object AS Object_Unit_Partion ON Object_Unit_Partion.Id = ObjectLink_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Storage 
                                 ON ObjectLink_Storage.ObjectId = MILinkObject_PartionGoods.ObjectId	                -- �����
                                AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage_Partion ON Object_Storage_Partion.Id = ObjectLink_Storage.ChildObjectId  

            LEFT JOIN ObjectLink AS ObjectLink_PartionModel 
                                 ON ObjectLink_PartionModel.ObjectId = MILinkObject_PartionGoods.ObjectId	            -- ������
                                AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_PartionModel_Partion ON Object_PartionModel_Partion.Id = ObjectLink_PartionModel.ChildObjectId

            -- ����������� ���� �� ������ 2 ���� �� ���� ������ � ���
            LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                                 ON tmpPricePR_Kind.GoodsId = MovementItem.ObjectId
                                AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = MovementItem.ObjectId
                                AND tmpPricePR.GoodsKindId IS NULL

            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = MovementItem.Id                                 
       ;

     ELSE

         CREATE TEMP TABLE _tmpMI_all ON COMMIT DROP AS 
            SELECT MovementItem.*
            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmp
                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = tmp.isErased
             ;
         ANALYZE _tmpMI_all;


         CREATE TEMP TABLE tmpMIF_all ON COMMIT DROP AS 
            SELECT MovementItemFloat.*
            FROM MovementItemFloat
            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT _tmpMI_all.Id FROM _tmpMI_all)
           ;

    -- RAISE EXCEPTION '������.<%>  <%>', (select count(*) from _tmpMI_all), (select count(*) from tmpMIF_all);


     RETURN QUERY
       WITH tmpPrice AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                              , lfObjectHistory_PriceListItem.GoodsKindId
                              , lfObjectHistory_PriceListItem.ValuePrice AS Price
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= CASE WHEN vbUserId = 5 THEN -1 WHEN vbUnitId = zc_Unit_RK() AND vbStatusId = zc_Enum_Status_UnComplete() THEN -1 ELSE zc_PriceList_Basis() END, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                              AS lfObjectHistory_PriceListItem
                         WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                        )


           -- ���� �� ������
          , tmpPricePR AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , lfObjectHistory_PriceListItem.GoodsKindId
                                , lfObjectHistory_PriceListItem.ValuePrice AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= CASE WHEN vbUserId = 5 THEN -1 WHEN vbUnitId = zc_Unit_RK() AND vbStatusId = zc_Enum_Status_UnComplete() THEN -1 ELSE vbPriceListId END, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) )
                                AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )
            --����� �������� �� ��������
          , tmpContainer AS (SELECT MIContainer.MovementItemId
                                 , SUM (MIContainer.Amount) AS Amount
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementId = inMovementId  
                               AND MIContainer.MovementDescId = zc_Movement_Inventory()
                               AND MIContainer.DescId = zc_MIContainer_Count()
                               AND (vbUnitId <> zc_Unit_RK() OR vbStatusId <> zc_Enum_Status_UnComplete())
                               AND vbUserId <> 5
                             GROUP BY MIContainer.MovementItemId
                             )
           , tmpMI_all AS (SELECT _tmpMI_all.*
                           FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmp
                                INNER JOIN _tmpMI_all ON _tmpMI_all.isErased = tmp.isErased
                          )
         , tmpMILO_all AS (SELECT MovementItemLinkObject.*
                           FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
  , tmpMIF_ContainerId AS (SELECT tmpMIF_all.MovementItemId, tmpMIF_all.ValueData :: Integer AS ContainerId
                           FROM tmpMIF_all
                           WHERE tmpMIF_all.DescId = zc_MIFloat_ContainerId()
                          )
          , tmpCLO_all AS (SELECT ContainerLinkObject.*
                           FROM ContainerLinkObject
                           WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpMIF_ContainerId.ContainerId FROM tmpMIF_ContainerId)
                          )
          , tmpMIS_all AS (SELECT MovementItemString.*
                           FROM MovementItemString
                           WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMID_all AS (SELECT MovementItemDate.*
                           FROM MovementItemDate
                           WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
       -- ���������
       SELECT
             MovementItem.Id                     AS Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData            AS MeasureName

           , MovementItem.Amount                 AS Amount
           , MIFloat_HeadCount.ValueData         AS HeadCount
           , MIFloat_Count.ValueData             AS Count
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectFloat_Price_Partion.ValueData ELSE (CASE WHEN COALESCE (MIFloat_Price.ValueData, 0) <> 0 THEN MIFloat_Price.ValueData ELSE COALESCE (tmpPrice_Kind.Price, tmpPrice.Price) END) END :: TFloat AS Price
           
           , MIFloat_Summ.ValueData  :: TFloat AS Summ   
           
           , COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)                         ::TFloat AS Price_pr
           , (tmpContainer.Amount * COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)) ::TFloat AS Summ_pr
           
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectDate_Value.ValueData    ELSE MIDate_PartionGoods.ValueData   END AS PartionGoodsDate

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 AND Object_PartionGoods.ValueData <> '0'
                       THEN Object_PartionGoods.ValueData
                  WHEN MIString_PartionGoods.ValueData <> ''
                       THEN  MIString_PartionGoods.ValueData
                  ELSE ''
             END :: TVarChar AS PartionGoods

           , CASE WHEN COALESCE (MIString_PartNumber.ValueData,'') = '' THEN ObjectString_PartNumber.ValueData ELSE MIString_PartNumber.ValueData END :: TVarChar     AS PartNumber

           , Object_GoodsKind.Id                 AS GoodsKindId
           , CASE WHEN MILinkObject_GoodsKind.ObjectId > 0 THEN Object_GoodsKind.ValueData WHEN vbUserId = 5 THEN '***' || Object_GoodsKind.ValueData ELSE Object_GoodsKind.ValueData END :: TVarChar AS GoodsKindName

           , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
           , (COALESCE (Object_GoodsKindComplete.ValueData, '') || CASE WHEN vbUserId = 5 AND Object_PartionGoods_container.ValueData <> ''
                                                                             THEN '***'  || Object_PartionGoods_container.ValueData
                                                                        WHEN vbUserId = 5 AND Object_PartionGoods_container.Id <> 0
                                                                             THEN '***'  || Object_PartionGoods_container.Id :: TVarChar || ' * ' || COALESCE (MIFloat_ContainerId.ContainerId, 0)
                                                                        WHEN vbUserId = 5 AND MIFloat_ContainerId.ContainerId <> 0
                                                                             THEN '*'  || MIFloat_ContainerId.ContainerId :: TVarChar
                                                                        ELSE ''
                                                                   END) :: TVarChar AS GoodsKindName_Complete
             --
           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ValueData              AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.Id ELSE Object_Unit.Id               END AS UnitId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.ValueData ELSE Object_Unit.ValueData END AS UnitName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.Id ELSE Object_Storage.Id               END AS StorageId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.ValueData ELSE Object_Storage.ValueData END AS StorageName
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_PartionModel_Partion.Id ELSE Object_PartionModel.Id               END AS PartionModelId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_PartionModel_Partion.ValueData ELSE Object_PartionModel.ValueData END AS PartionModelName
           
           , Object_PartionCell_1.ObjectCode    AS PartionCellCode_1
           , Object_PartionCell_1.ValueData     AS PartionCellName_1

           , MIFloat_ContainerId.ContainerId

           , MovementItem.isErased               AS isErased

           -- Id ������
           , Object_PartionGoods.Id              AS PartionGoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.Id) :: TVarChar AS IdBarCode
           , Null ::TDateTime  AS OperDate

       FROM tmpMI_all AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpMIF_ContainerId AS MIFloat_ContainerId
                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id

            LEFT JOIN tmpCLO_all AS CLO_PartionGoods
                                 ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ContainerId
                                AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods_container ON Object_PartionGoods_container.Id = CLO_PartionGoods.ObjectId

            LEFT JOIN tmpMIF_all AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN tmpMIF_all AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()

            LEFT JOIN tmpMIF_all AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN tmpMIF_all AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN tmpMID_all AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN tmpMIS_all AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
            LEFT JOIN tmpMIS_all AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

            LEFT JOIN tmpCLO_all AS CLO_GoodsKind
                                 ON CLO_GoodsKind.ContainerId = MIFloat_ContainerId.ContainerId
                                AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()

            LEFT JOIN tmpMILO_all AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            -- LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (CLO_GoodsKind.ObjectId, MILinkObject_GoodsKind.ObjectId)
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (MILinkObject_GoodsKind.ObjectId, CLO_GoodsKind.ObjectId)

            LEFT JOIN tmpMILO_all AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

            LEFT JOIN tmpMILO_all AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            LEFT JOIN tmpMILO_all AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN tmpMILO_all AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

            LEFT JOIN tmpMILO_all AS MILinkObject_PartionModel
                                             ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionModel.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = MILinkObject_PartionModel.ObjectId

            LEFT JOIN tmpMIF_all AS MIFloat_PartionCell
                                        ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell.DescId = zc_MIFloat_PartionCell()
            LEFT JOIN Object AS Object_PartionCell_1 ON Object_PartionCell_1.Id = MIFloat_PartionCell.ValueData

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- ����������� ���� 2 ���� �� ���� ������ � ���
            LEFT JOIN tmpPrice AS tmpPrice_Kind 
                               ON tmpPrice_Kind.GoodsId = MovementItem.ObjectId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                              AND tmpPrice.GoodsKindId IS NULL

            LEFT JOIN tmpMILO_all AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
            -- �������� �� ������
            LEFT JOIN ObjectDate AS ObjectDate_Value 
                                 ON ObjectDate_Value.ObjectId = MILinkObject_PartionGoods.ObjectId                      -- ����
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()
            LEFT JOIN ObjectString AS ObjectString_PartNumber
                                   ON ObjectString_PartNumber.ObjectId = MILinkObject_PartionGoods.ObjectId             -- ���. �����
                                  AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()
                                
            LEFT JOIN ObjectFloat AS ObjectFloat_Price_Partion 
                                  ON ObjectFloat_Price_Partion.ObjectId = MILinkObject_PartionGoods.ObjectId                 -- ����
                                 AND ObjectFloat_Price_Partion.DescId = zc_ObjectFloat_PartionGoods_Price()    

            LEFT JOIN ObjectLink AS ObjectLink_Unit 
                                 ON ObjectLink_Unit.ObjectId = MILinkObject_PartionGoods.ObjectId		               -- �������������
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
            LEFT JOIN Object AS Object_Unit_Partion ON Object_Unit_Partion.Id = ObjectLink_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Storage 
                                 ON ObjectLink_Storage.ObjectId = MILinkObject_PartionGoods.ObjectId	                -- �����
                                AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage_Partion ON Object_Storage_Partion.Id = ObjectLink_Storage.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_PartionModel 
                                 ON ObjectLink_PartionModel.ObjectId = MILinkObject_PartionGoods.ObjectId	            -- ������
                                AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_PartionModel_Partion ON Object_PartionModel_Partion.Id = ObjectLink_PartionModel.ChildObjectId
            
            -- ����������� ���� �� ������ 2 ���� �� ���� ������ � ���
            LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                                 ON tmpPricePR_Kind.GoodsId = MovementItem.ObjectId
                                AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = MovementItem.ObjectId
                                AND tmpPricePR.GoodsKindId IS NULL  
            
            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = MovementItem.Id
       ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 22.01.24         * GoodsName_old
 27.05.23         *
 02.12.19         * ���� � ������ ���� ������
 19.12.18         *
 31.03.15         * add GoodsGroupNameFull, MeasureName
 01.09.14                                                       * add Unit, Storage
 27.07.14                                        * add Price
 23.07.14                                        * add Object_InfoMoney_View
 27.01.14                                        * all
 22.07.13         * add PartionGoodsDate
 18.07.13         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
