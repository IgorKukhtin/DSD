-- Function: gpSelect_Movement_WeighingProduction_PrintBarcode (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_PrintBarcode (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_PrintBarcode(
    IN inMovementId        Integer   ,   -- ���� ���������
    IN inId                Integer   ,   -- ������
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbStoreKeeperName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_wms_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �� ���������
     SELECT Movement.DescId, Movement.StatusId
          , Object_User.ValueData  :: TVarChar AS StoreKeeperName -- ���������
            INTO vbDescId, vbStatusId, vbStoreKeeperName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                       ON MovementLinkObject_User.MovementId = Movement.Id
                                      AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
          LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
     WHERE Movement.Id = inMovementId;

    -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
    END IF;

     OPEN Cursor1 FOR

       -- ��������� 
    WITH
    -- ��� 1-�� ������
    tmpMI AS (SELECT MovementItem.Id                           AS MovementItemId
                   , MovementItem.ObjectId                     AS GoodsId
                   , MILinkObject_GoodsKind.ObjectId           AS GoodsKindId
                   , MIDate_PartionGoods.ValueData             AS PartionGoodsDate
                   , MIString_PartionGoods.ValueData           AS PartionGoods
                   , MILinkObject_PartionGoods.ObjectId        AS PartionGoodsId
                   , MovementItem.Amount                       AS Amount
                   , COALESCE (MIFloat_Count.ValueData, 0)     AS Count
                   , COALESCE (MIFloat_CountPack.ValueData, 0) AS CountPack
                   , COALESCE (MIFloat_HeadCount.ValueData, 0) AS HeadCount

                   , COALESCE (MIFloat_CountSkewer1.ValueData, 0)+ COALESCE (MIFloat_CountSkewer2.ValueData, 0)   AS CountSkewer
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_Count
                                               ON MIFloat_Count.MovementItemId = MovementItem.Id
                                              AND MIFloat_Count.DescId = zc_MIFloat_Count()
                   LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                               ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                              AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                               ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
 
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
 
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                    ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
 
                   LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer1
                                              ON MIFloat_CountSkewer1.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountSkewer1.DescId = zc_MIFloat_CountSkewer1()

                   LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer2
                                               ON MIFloat_CountSkewer2.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountSkewer2.DescId = zc_MIFloat_CountSkewer2()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.Id         = inId
             )

       --���������
       SELECT
             Object_Goods.Id                    AS GoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMI.Amount
           , tmpMI.Count
           , tmpMI.CountPack
           , tmpMI.HeadCount
           , tmpMI.CountSkewer
           , CAST ((tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
           , CASE WHEN COALESCE (tmpMI.Count, 0) <> 0 
                  THEN (tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / tmpMI.Count)
                  ELSE 0
             END AS WeightOne     -- "��� 1 ��." = ��� / ���-�� �������
           , tmpMI.PartionGoodsDate
           , tmpMI.PartionGoods
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName

           , Object_PartionGoods.Id             AS PartionGoodsId
           , Object_PartionGoods.ValueData      AS PartionGoodsName
           , ObjectDate_Value.ValueData         AS PartionGoodsOperDate
           
           , vbStoreKeeperName  :: TVarChar     AS StoreKeeperName

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                 
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI.PartionGoodsId

            LEFT JOIN ObjectDate AS ObjectDate_Value
                                 ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id                    -- ����
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id
        ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
03.02.20          *
*/

-- ����
-- select * from gpSelect_Movement_WeighingProduction_PrintBarCode(inMovementId := 15745229 , inId := 162901040 ,  inSession := '5');
--FETCH ALL "<unnamed portal 12>";