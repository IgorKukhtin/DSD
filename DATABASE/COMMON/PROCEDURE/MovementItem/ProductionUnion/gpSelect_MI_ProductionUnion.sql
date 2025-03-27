-- Function: gpSelect_MI_ProductionUnion()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Master (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion(
    IN inMovementId          Integer,
    IN inShowAll             Boolean,
    IN inisErased            Boolean      , --
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDocumentKindId Integer;
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);
   
   -- определили <Тип документа>
   vbDocumentKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentKind());


   IF inShowAll THEN
    OPEN Cursor1 FOR
       SELECT
              0                                     AS Id
--            , 0                                     AS LineNum
            , tmpGoods.GoodsId                      AS GoodsId
            , tmpGoods.GoodsCode                    AS GoodsCode
            , tmpGoods.GoodsName                    AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData              AS MeasureName
            , CAST (NULL AS TFloat)                 AS Amount
            , CAST (NULL AS TFloat)                 AS Amount_weight 

            , CAST (NULL AS Boolean)                AS isPartionClose
            , CAST (NULL AS TDateTime)              AS PartionGoodsDate
            , CAST (NULL AS TVarchar)               AS PartionGoods

            , CAST (NULL AS TVarchar)               AS Comment
            , CAST (NULL AS TFloat)                 AS Count
            , CAST (NULL AS TFloat)                 AS CountReal
            , CAST (NULL AS TFloat)                 AS CountReal_LAK
            , CAST (NULL AS TFloat)                 AS RealWeight

            , CAST (NULL AS TFloat)                 AS CuterCount
            , CAST (NULL AS TFloat)                 AS CuterWeight

            , CAST (NULL AS TFloat)                 AS RealWeightShp
            , CAST (NULL AS TFloat)                 AS RealWeightMsg  
            , CAST (NULL AS TFloat)                 AS Amount_Remains 
            , CAST (NULL AS TFloat)                 AS AmountForm
            , CAST (NULL AS TFloat)                 AS AmountForm_two
            , CAST (NULL AS TFloat)                 AS AmountNext_out

            , CAST (NULL AS Integer)                AS GoodsKindId
            , CAST (NULL AS Integer)                AS GoodsKindCode
            , CAST (NULL AS TVarchar)               AS GoodsKindName
            , CAST (NULL AS Integer)                AS GoodsKindId_Complete
            , CAST (NULL AS Integer)                AS GoodsKindCode_Complete
            , CAST (NULL AS TVarchar)               AS GoodsKindName_Complete

            , CAST (NULL AS Integer)                AS ReceiptId
            , CAST (NULL AS TVarchar)               AS ReceiptCode
            , CAST (NULL AS TVarchar)               AS ReceiptName

            , CAST (NULL AS Integer)                AS StorageId
            , CAST (NULL AS TVarChar)               AS StorageName            
            , '' ::TVarChar                         AS PartNumber
            , '' ::TVarChar                         AS Model

            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyGroupName
            , Object_InfoMoney_View.InfoMoneyDestinationName
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyName_all
            , FALSE                                 AS isAuto  
            , FALSE                                 AS isClose
            , FALSE                                 AS isErased

            , CAST (NULL AS Integer)                AS PersonalId_KVK
            , CAST (NULL AS TVarchar)               AS PersonalName_KVK
            , CAST (NULL AS Integer)                AS PositionCode_KVK
            , CAST (NULL AS TVarchar)               AS PositionName_KVK
            , CAST (NULL AS Integer)                AS UnitCode_KVK
            , CAST (NULL AS TVarchar)               AS UnitName_KVK
            , CAST (NULL AS TVarchar)               AS KVK

       FROM (SELECT Object_Goods.Id                          AS GoodsId
                  , Object_Goods.ObjectCode                  AS GoodsCode
                  , Object_Goods.ValueData                   AS GoodsName
                  , ObjectLink_Goods_InfoMoney.ChildObjectId AS InfoMoneyId
             FROM Object AS Object_Goods
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             WHERE Object_Goods.DescId = zc_Object_Goods()
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpGoods.InfoMoneyId

       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
--           , 0 AS LineNum
--           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData          AS MeasureName

            , MovementItem.Amount               AS Amount

            , (MovementItem.Amount
            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData
                   WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_kg() THEN 1
                   ELSE 0
              END)                    :: TFloat AS Amount_weight

            , MIBoolean_PartionClose.ValueData  AS isPartionClose
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment
            , MIFloat_Count.ValueData           AS Count
            , CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()) THEN 0 ELSE MIFloat_CountReal.ValueData END :: TFloat AS CountReal
            , CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()) THEN MIFloat_CountReal.ValueData ELSE 0 END :: TFloat AS CountReal_LAK

            , MIFloat_RealWeight.ValueData      AS RealWeight
            , MIFloat_CuterCount.ValueData      AS CuterCount
            , MIFloat_CuterWeight.ValueData     AS CuterWeight
            
            , MIFloat_RealWeightShp.ValueData  ::TFloat  AS RealWeightShp
            , MIFloat_RealWeightMsg.ValueData  ::TFloat  AS RealWeightMsg 
            , MIFloat_Remains.ValueData        ::TFloat  AS Amount_Remains
            , MIFloat_AmountForm.ValueData     ::TFloat  AS AmountForm
            , MIFloat_AmountForm_two.ValueData ::TFloat  AS AmountForm_two
            , MIFloat_AmountNext_out.ValueData ::TFloat  AS AmountNext_out

            , Object_GoodsKind.Id                 AS GoodsKindId
            , Object_GoodsKind.ObjectCode         AS GoodsKindCode
            , Object_GoodsKind.ValueData          AS GoodsKindName
            , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
            , Object_GoodsKindComplete.ObjectCode AS GoodsKindCode_Complete
            , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete

            , Object_Receipt.Id                   AS ReceiptId
            , ObjectString_Receipt_Code.ValueData AS ReceiptCode
            , Object_Receipt.ValueData            AS ReceiptName

            , Object_Storage.Id                         AS StorageId
            , Object_Storage.ValueData                  AS StorageName
            , MIString_PartNumber.ValueData :: TVarChar AS PartNumber
            , MIString_Model.ValueData      :: TVarChar AS Model

            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyGroupName
            , Object_InfoMoney_View.InfoMoneyDestinationName
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyName_all
            , COALESCE(MIBoolean_isAuto.ValueData, FALSE)  AS isAuto    
            , COALESCE(MIBoolean_Close.ValueData, FALSE) ::Boolean AS isClose

            , MovementItem.isErased               AS isErased

           , Object_PersonalKVK.Id          AS PersonalId_KVK
           , Object_PersonalKVK.ValueData   AS PersonalName_KVK
           , Object_PositionKVK.ObjectCode  AS PositionCode_KVK
           , Object_PositionKVK.ValueData   AS PositionName_KVK
           , Object_UnitKVK.ObjectCode      AS UnitCode_KVK
           , Object_UnitKVK.ValueData       AS UnitName_KVK
           , MIString_KVK.ValueData         AS KVK

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                              ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalKVK
                                              ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
             LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = MILinkObject_PersonalKVK.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionKVK
                                  ON ObjectLink_Personal_PositionKVK.ObjectId = Object_PersonalKVK.Id
                                 AND ObjectLink_Personal_PositionKVK.DescId = zc_ObjectLink_Personal_Position()
             LEFT JOIN Object AS Object_PositionKVK ON Object_PositionKVK.Id = ObjectLink_Personal_PositionKVK.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Personal_UnitKVK
                                  ON ObjectLink_Personal_UnitKVK.ObjectId = Object_PersonalKVK.Id
                                 AND ObjectLink_Personal_UnitKVK.DescId = zc_ObjectLink_Personal_Unit()
             LEFT JOIN Object AS Object_UnitKVK ON Object_UnitKVK.Id = ObjectLink_Personal_UnitKVK.ChildObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Storage.DescId         = zc_MILinkObject_Storage()
             LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()
             LEFT JOIN MovementItemFloat AS MIFloat_CountReal
                                         ON MIFloat_CountReal.MovementItemId = MovementItem.Id
                                        AND MIFloat_CountReal.DescId = zc_MIFloat_CountReal()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
             LEFT JOIN MovementItemFloat AS MIFloat_CuterWeight
                                         ON MIFloat_CuterWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeightShp
                                         ON MIFloat_RealWeightShp.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeightShp.DescId = zc_MIFloat_RealWeightShp()
             LEFT JOIN MovementItemFloat AS MIFloat_RealWeightMsg
                                         ON MIFloat_RealWeightMsg.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeightMsg.DescId = zc_MIFloat_RealWeightMsg()

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountForm
                                         ON MIFloat_AmountForm.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountForm.DescId = zc_MIFloat_AmountForm()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountForm_two
                                         ON MIFloat_AmountForm_two.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountForm_two.DescId = zc_MIFloat_AmountForm_two()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountNext_out
                                         ON MIFloat_AmountNext_out.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountNext_out.DescId = zc_MIFloat_AmountNext_out()

             LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                           ON MIBoolean_PartionClose.MovementItemId = MovementItem.Id
                                          AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()

             LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                           ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                          AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

             LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                           ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                          AND MIBoolean_Close.DescId = zc_MIBoolean_Close()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_KVK
                                          ON MIString_KVK.MovementItemId = MovementItem.Id
                                         AND MIString_KVK.DescId = zc_MIString_KVK()

             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
             LEFT JOIN MovementItemString AS MIString_Model
                                          ON MIString_Model.MovementItemId = MovementItem.Id
                                         AND MIString_Model.DescId = zc_MIString_Model()

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

             LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                    ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                   AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            ;

    RETURN NEXT Cursor1;

   ELSE

    OPEN Cursor1 FOR
       SELECT
             MovementItem.Id					AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , (Object_Goods.ValueData || CASE WHEN Movement_partion.Id > 0 THEN '   ***Партия № <' || Movement_partion.InvNumber || '> от <' || zfConvert_DateToString (Movement_partion.OperDate) || '>' ELSE '' END) :: TVarChar AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

            , MovementItem.Amount               AS Amount
            , (MovementItem.Amount
            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData
                   WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_kg() THEN 1
                   ELSE 0
              END)                    :: TFloat AS Amount_weight

            , MIBoolean_PartionClose.ValueData  AS isPartionClose
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment
            , MIFloat_Count.ValueData           AS Count
            , CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()) THEN 0 ELSE MIFloat_CountReal.ValueData END :: TFloat AS CountReal
            , CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()) THEN MIFloat_CountReal.ValueData ELSE 0 END :: TFloat AS CountReal_LAK
            , MIFloat_RealWeight.ValueData      AS RealWeight
            , MIFloat_CuterCount.ValueData      AS CuterCount
            , MIFloat_CuterWeight.ValueData     AS CuterWeight

            , MIFloat_RealWeightShp.ValueData  ::TFloat  AS RealWeightShp
            , MIFloat_RealWeightMsg.ValueData  ::TFloat  AS RealWeightMsg
            , MIFloat_Remains.ValueData        ::TFloat  AS Amount_Remains
            , MIFloat_AmountForm.ValueData     ::TFloat  AS AmountForm
            , MIFloat_AmountForm_two.ValueData ::TFloat  AS AmountForm_two 
            , MIFloat_AmountNext_out.ValueData ::TFloat  AS AmountNext_out

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_Measure.ValueData          AS MeasureName

            , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
            , Object_GoodsKindComplete.ObjectCode AS GoodsKindCode_Complete
            , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete

            , Object_Receipt.Id                   AS ReceiptId
            , ObjectString_Receipt_Code.ValueData AS ReceiptCode
            , Object_Receipt.ValueData            AS ReceiptName

            , Object_Storage.Id                         AS StorageId
            , Object_Storage.ValueData                  AS StorageName
            , MIString_PartNumber.ValueData :: TVarChar AS PartNumber
            , MIString_Model.ValueData      :: TVarChar AS Model

            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyGroupName
            , Object_InfoMoney_View.InfoMoneyDestinationName
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyName_all
            , COALESCE(MIBoolean_isAuto.ValueData, FALSE)  AS isAuto       
            , COALESCE(MIBoolean_Close.ValueData, FALSE) ::Boolean AS isClose

            , MovementItem.isErased               AS isErased

            , Object_PersonalKVK.Id          AS PersonalId_KVK
            , Object_PersonalKVK.ValueData   AS PersonalName_KVK
            , Object_PositionKVK.ObjectCode  AS PositionCode_KVK
            , Object_PositionKVK.ValueData   AS PositionName_KVK
            , Object_UnitKVK.ObjectCode      AS UnitCode_KVK
            , Object_UnitKVK.ValueData       AS UnitName_KVK
            , MIString_KVK.ValueData       AS KVK

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                              ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalKVK
                                              ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
             LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = MILinkObject_PersonalKVK.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionKVK
                                  ON ObjectLink_Personal_PositionKVK.ObjectId = Object_PersonalKVK.Id
                                 AND ObjectLink_Personal_PositionKVK.DescId = zc_ObjectLink_Personal_Position()
             LEFT JOIN Object AS Object_PositionKVK ON Object_PositionKVK.Id = ObjectLink_Personal_PositionKVK.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Personal_UnitKVK
                                  ON ObjectLink_Personal_UnitKVK.ObjectId = Object_PersonalKVK.Id
                                 AND ObjectLink_Personal_UnitKVK.DescId = zc_ObjectLink_Personal_Unit()
             LEFT JOIN Object AS Object_UnitKVK ON Object_UnitKVK.Id = ObjectLink_Personal_UnitKVK.ChildObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Storage.DescId         = zc_MILinkObject_Storage()
             LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()
             LEFT JOIN MovementItemFloat AS MIFloat_CountReal
                                         ON MIFloat_CountReal.MovementItemId = MovementItem.Id
                                        AND MIFloat_CountReal.DescId = zc_MIFloat_CountReal()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
             LEFT JOIN MovementItemFloat AS MIFloat_CuterWeight
                                         ON MIFloat_CuterWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeightShp
                                         ON MIFloat_RealWeightShp.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeightShp.DescId = zc_MIFloat_RealWeightShp()
             LEFT JOIN MovementItemFloat AS MIFloat_RealWeightMsg
                                         ON MIFloat_RealWeightMsg.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeightMsg.DescId = zc_MIFloat_RealWeightMsg()

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountForm
                                         ON MIFloat_AmountForm.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountForm.DescId = zc_MIFloat_AmountForm()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountForm_two
                                         ON MIFloat_AmountForm_two.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountForm_two.DescId = zc_MIFloat_AmountForm_two()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountNext_out
                                         ON MIFloat_AmountNext_out.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountNext_out.DescId = zc_MIFloat_AmountNext_out()

             LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                         ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                        AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
             LEFT JOIN MovementItem AS MovementItem_partion ON MovementItem_partion.Id = MIFloat_MovementItemId.ValueData :: Integer
             LEFT JOIN Movement AS Movement_partion ON Movement_partion.Id = MovementItem_partion.MovementId

             LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                           ON MIBoolean_PartionClose.MovementItemId = MovementItem.Id
                                          AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()

             LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                           ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                          AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

             LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                           ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                          AND MIBoolean_Close.DescId = zc_MIBoolean_Close()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_KVK
                                          ON MIString_KVK.MovementItemId = MovementItem.Id
                                         AND MIString_KVK.DescId = zc_MIString_KVK()

             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
             LEFT JOIN MovementItemString AS MIString_Model
                                          ON MIString_Model.MovementItemId = MovementItem.Id
                                         AND MIString_Model.DescId = zc_MIString_Model()
                                         
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
             LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                    ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                   AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
           ;

    RETURN NEXT Cursor1;
   END IF;

    OPEN Cursor2 FOR

       SELECT
              MovementItem.Id					AS Id
            , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
            , Object_Goods.Id                   AS GoodsId
            , case when vbUserId = 5 AND 1=0 then MovementItem.Id else Object_Goods.ObjectCode end :: Integer AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
  
            , MovementItem.Amount               AS Amount
            , (MovementItem.Amount
            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData
                   WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_kg() THEN 1
                   ELSE 0
              END)                    :: TFloat AS Amount_weight

            , MovementItem.ParentId             AS ParentId

            , MIFloat_AmountReceipt.ValueData   AS AmountReceipt

            , MIFloat_CuterCount.ValueData * MIFloat_AmountReceipt.ValueData AS AmountCalc

            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_Measure.ValueData          AS MeasureName

            , Object_GoodsKindComplete.Id         AS GoodsKindCompleteId
            , Object_GoodsKindComplete.ObjectCode AS GoodsKindCompleteCode
            , Object_GoodsKindComplete.ValueData  AS GoodsKindCompleteName

            , MIFloat_Count.ValueData           AS Count_onCount

            , Object_Receipt.Id                 AS ReceiptId
            , Object_Receipt.ObjectCode         AS ReceiptCode
            , Object_Receipt.ValueData          AS ReceiptName


            , Object_Storage.Id                         AS StorageId
            , Object_Storage.ValueData                  AS StorageName
            , MIString_PartNumber.ValueData :: TVarChar AS PartNumber
            , MIString_Model.ValueData      :: TVarChar AS Model

            , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := Object_Goods.Id
                                             , inGoodsKindId            := Object_GoodsKind.Id
                                             , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                             , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                             , inIsWeightMain           := MIBoolean_WeightMain.ValueData
                                             , inIsTaxExit              := MIBoolean_TaxExit.ValueData
                                              ) AS GroupNumber

            , COALESCE(MIBoolean_isAuto.ValueData, False)  AS isAuto 
            , COALESCE (MIBoolean_Etiketka.ValueData, False) ::Boolean AS isEtiketka
            , MovementItem.isErased             AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                           ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                          AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                           ON MIBoolean_TaxExit.MovementItemId =  MovementItem.Id
                                          AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
             LEFT JOIN MovementItemBoolean AS MIBoolean_WeightMain
                                           ON MIBoolean_WeightMain.MovementItemId = MovementItem.Id
                                          AND MIBoolean_WeightMain.DescId = zc_MIBoolean_WeightMain()
 
             LEFT JOIN MovementItemBoolean AS MIBoolean_Etiketka
                                           ON MIBoolean_Etiketka.MovementItemId = MovementItem.Id
                                          AND MIBoolean_Etiketka.DescId = zc_MIBoolean_Etiketka()

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                         AND MIString_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                         ON MIFloat_AmountReceipt.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.ParentId
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
             LEFT JOIN MovementItemString AS MIString_Model
                                          ON MIString_Model.MovementItemId = MovementItem.Id
                                         AND MIString_Model.DescId = zc_MIString_Model()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                              ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Storage.DescId         = zc_MILinkObject_Storage()
             LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_ProductionUnion (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.03.25         * AmountForm_two
 13.08.24         * AmountNext_out
 30.07.24         * AmountForm
 19.05.23         *
 13.09.22         *
 31.03.15         * add GoodsGroupNameFull
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 02.06.14                                                       *
 27.05.14                                                       * поменял все
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionUnion (inMovementId:= 1, inShowAll:= TRUE, inisErased:= FALSE, inSession:= '2')
