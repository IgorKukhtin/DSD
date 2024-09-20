--

DROP VIEW IF EXISTS MovementItem_PromoGoods_View;

CREATE OR REPLACE VIEW MovementItem_PromoGoods_View AS
    SELECT
        MovementItem.Id                        AS Id                  --�������������
      , MovementItem.MovementId                AS MovementId          --�� ��������� <�����>
      , MovementItem.ObjectId                  AS GoodsId             --�� ������� <�����>
      , Object_Goods.ObjectCode::Integer       AS GoodsCode           --��� �������  <�����>
      , Object_Goods.ValueData                 AS GoodsName           --������������ ������� <�����>
      , Object_Measure.Id                      AS MeasureId           --������� ���������
      , Object_Measure.ValueData               AS Measure             --������� ���������
      , Object_TradeMark.ValueData             AS TradeMark           --�������� �����
      , MovementItem.Amount                    AS Amount              --% ������ �� �����
      , (MIFloat_Price.ValueData           / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat               AS Price               --���� � ������ � ������ ������ �� ��������
      , CAST (MIFloat_PriceWithOutVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS Numeric (16,8))  AS PriceWithOutVAT     --���� �������� ��� ����� ���, � ������ ������, ���
      , CAST (MIFloat_PriceWithVAT.ValueData    / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS Numeric (16,8))  AS PriceWithVAT        --���� �������� � ������ ���, � ������ ������, ���
      , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END :: TFloat AS CountForPrice
      , MIFloat_PriceWithOutVAT.ValueData      AS PriceWithOutVAT_orig--���� �������� ��� ����� ���, � ������ ������, ���
      , MIFloat_PriceWithVAT.ValueData         AS PriceWithVAT_orig   --���� �������� � ������ ���, � ������ ������, ���
      , MIFloat_PriceSale.ValueData            AS PriceSale           --���� �� �����

      , MIFloat_AmountReal.ValueData           AS AmountReal          --����� ������ � ����������� ������, ��
      , (MIFloat_AmountReal.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealWeight    --����� ������ � ����������� ������, �� ���

      , MIFloat_AmountRetIn.ValueData          AS AmountRetIn          --����� ������� � ����������� ������, ��
      , (MIFloat_AmountRetIn.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRetInWeight    --����� ������� � ����������� ������, �� ���

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
      , MILinkObject_GoodsKindComplete.ObjectId        AS GoodsKindCompleteId         --�� ������� <��� ������ (����������)>
      , Object_GoodsKindComplete.ValueData             AS GoodsKindCompleteName       --������������ ������� <��� ������ (����������)>
      , MIFloat_MainDiscount.ValueData   ::TFloat AS MainDiscount       -- ����� ������ ��� ����������, %
      , (MIFloat_OperPriceList.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END)  ::TFloat AS OperPriceList      -- ���� � ������
      , MIFloat_ContractCondition.ValueData    AS ContractCondition      -- ����� ����, %

      , (COALESCE (MIFloat_SummOutMarket.ValueData, 0) - COALESCE (MIFloat_SummInMarket.ValueData, 0)) :: TFloat AS SummOutMarket

    FROM MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                    ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                   AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                    ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                    ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                    ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                   AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

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
        LEFT JOIN MovementItemFloat AS MIFloat_AmountRetIn
                                    ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMin
                                    ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                    ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

        LEFT JOIN MovementItemFloat AS MIFloat_MainDiscount
                                    ON MIFloat_MainDiscount.MovementItemId = MovementItem.Id 
                                   AND MIFloat_MainDiscount.DescId = zc_MIFloat_MainDiscount()

        LEFT JOIN MovementItemFloat AS MIFloat_SummOutMarket
                                    ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                   AND MIFloat_SummOutMarket.DescId = zc_MIFloat_SummOutMarket()
        LEFT JOIN MovementItemFloat AS MIFloat_SummInMarket
                                    ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                   AND MIFloat_SummInMarket.DescId = zc_MIFloat_SummInMarket()

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                         ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
        LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId

        LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MovementItem.ID
                                          AND MIString_Comment.DescId = zc_MIString_Comment()

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

        LEFT JOIN MovementItemFloat AS MIFloat_ContractCondition
                                    ON MIFloat_ContractCondition.MovementItemId = MovementItem.Id
                                   AND MIFloat_ContractCondition.DescId = zc_MIFloat_ContractCondition()
                                                     
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
