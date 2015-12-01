--

DROP VIEW IF EXISTS MovementItem_PromoGoods_View;

CREATE OR REPLACE VIEW MovementItem_PromoGoods_View AS
    SELECT
        MovementItem.Id                        AS Id                  --�������������
      , MovementItem.MovementId                AS MovementId          --�� ��������� <�����>
      , MovementItem.ObjectId                  AS GoodsId             --�� ������� <�����>
      , Object_Goods.ObjectCode::Integer       AS GoodsCode           --��� �������  <�����>
      , Object_Goods.ValueData                 AS GoodsName           --������������ ������� <�����>
      , Object_Measure.ValueData               AS Measure             --������� ���������
      , Object_TradeMark.ValueData             AS TradeMark           --�������� �����
      , MovementItem.Amount                    AS Amount              --% ������ �� �����
      , MIFloat_Price.ValueData                AS Price               --���� � ������
      , MIFloat_PriceWithOutVAT.ValueData      AS PriceWithOutVAT     --���� �������� ��� ����� ���, � ������ ������, ���
      , MIFloat_PriceWithVAT.ValueData         AS PriceWithVAT        --���� �������� � ������ ���, � ������ ������, ���
      , MIFloat_PriceSale.ValueData            AS PriceSale           --���� �� �����
      , MIFloat_AmountReal.ValueData           AS AmountReal          --����� ������ � ����������� ������, ��
      , (MIFloat_AmountReal.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealWeight    --����� ������ � ����������� ������, �� ���
      , MIFloat_AmountPlanMin.ValueData        AS AmountPlanMin       --������� ������������ ������ ������ �� ��������� ������ (� ��)
      , (MIFloat_AmountPlanMin.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMinWeight --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
      , MIFloat_AmountPlanMax.ValueData        AS AmountPlanMax       --�������� ������������ ������ ������ �� ��������� ������ (� ��)
      , (MIFloat_AmountPlanMax.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMaxWeight --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
      , MIFloat_AmountOrder.ValueData          AS AmountOrder         --���-�� ������ (����)
      , (MIFloat_AmountOrder.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOrderWeight   --���-�� ������ (����) ���
      , MIFloat_AmountOut.ValueData            AS AmountOut           --���-�� ���������� (����)
      , (MIFloat_AmountOut.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOutWeight     --���-�� ���������� (����) ���
      , MIFloat_AmountIn.ValueData             AS AmountIn            --���-�� ������� (����)
      , (MIFloat_AmountIn.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountInWeight      --���-�� ������� (����) ���
      , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId         --�� ������� <��� ������>
      , Object_GoodsKind.ValueData             AS GoodsKindName       --������������ ������� <��� ������>
      , MIString_Comment.ValueData             AS Comment             -- ����������
      , MovementItem.isErased                  AS isErased            -- ������
      , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- ���
    FROM MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                    ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                    ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                    ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                    ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountIn
                                    ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                    ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMin
                                    ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                    ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
        LEFT JOIN Object AS Object_Goods 
                         ON Object_Goods.Id = MovementItem.ObjectId
        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind
                         ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                                        
        LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MovementItem.ID
                                          AND MIString_Comment.DescId = zc_MIString_Comment()
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure 
                         ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                             ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                            AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
        LEFT JOIN Object AS Object_TradeMark 
                         ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                    ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                   AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

    WHERE MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_PromoGoods_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 02.11.15                                                         *
*/

-- ����
-- SELECT * FROM MovementItem_PromoGoods_View WHERE MovementId = 2641111
