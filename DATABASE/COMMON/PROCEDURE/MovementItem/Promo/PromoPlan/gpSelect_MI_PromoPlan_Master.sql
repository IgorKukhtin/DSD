-- Function: gpSelect_MI_PromoPlan_Master()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoPlan_Master (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoPlan_Master(
    IN inMovementId  Integer      , -- ���� ��������� �����
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (
        Id                  Integer --�������������
      , MovementId          Integer --�� ��������� <>
      , GoodsId             Integer --�� ������� <�����>
      , GoodsCode           Integer --��� �������  <�����>
      , GoodsName           TVarChar --������������ ������� <�����>
      , MeasureName         TVarChar --������� ���������
      , TradeMarkName       TVarChar --�������� �����
      , GoodsKindName       TVarChar --������������ ������� <��� ������> 
      , GoodsWeight         TFloat -- 
      , Amount              TFloat
      , AmountPartner       TFloat
      , OperDate            TDateTime --����� �������
      , isErased            Boolean  --������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);


    RETURN QUERY
                             
        SELECT MovementItem.Id                        AS Id                  --�������������
             , MovementItem.MovementId                AS MovementId          --�� ��������� <>
             , MovementItem.ObjectId                  AS GoodsId             --�� ������� <�����>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --��� �������  <�����>
             , Object_Goods.ValueData                 AS GoodsName           --������������ ������� <�����>
             , Object_Measure.ValueData               AS Measure             --������� ���������
             , Object_TradeMark.ValueData             AS TradeMark           --�������� �����
             , Object_GoodsKind.ValueData             AS GoodsKindName       --������������ ������� <��� ������>
             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- ���

             , MovementItem.Amount                    AS Amount
             , MIFloat_AmountPartner.ValueData        AS AmountPartner

             , MIDate_OperDate.ValueData              AS OperDate
   
             , MovementItem.isErased                  AS isErased            -- ������
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)

             LEFT JOIN MovementItemDate AS MIDate_OperDate
                                        ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                       AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id 
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
 
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                              
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                         ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                        AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        WHERE Movement.DescId = zc_Movement_PromoPlan()
          AND Movement.ParentId = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.10.21         *
*/

-- ����
-- SELECT * FROM gpSelect_MI_PromoPlan_Master (5083159 , FALSE, zfCalc_UserAdmin());