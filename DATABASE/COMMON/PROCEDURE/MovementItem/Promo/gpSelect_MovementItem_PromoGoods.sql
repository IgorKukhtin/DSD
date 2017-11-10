-- Function: gpSelect_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoGoods(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (
        Id                  Integer --�������������
      , MovementId          Integer --�� ��������� <�����>
      , GoodsId             Integer --�� ������� <�����>
      , GoodsCode           Integer --��� �������  <�����>
      , GoodsName           TVarChar --������������ ������� <�����>
      , MeasureName         TVarChar --������� ���������
      , TradeMarkName       TVarChar --�������� �����
      , Amount              TFloat --% ������ �� �����
      , Price               TFloat --���� � ������
      , PriceSale           TFloat --���� �� �����
      , PriceWithOutVAT     TFloat --���� �������� ��� ����� ���, � ������ ������, ���
      , PriceWithVAT        TFloat --���� �������� � ������ ���, � ������ ������, ���
      , AmountReal          TFloat --����� ������ � ����������� ������, ��
      , AmountRealWeight    TFloat --����� ������ � ����������� ������, �� ���
      , AmountRetIn         TFloat --����� ������� � ����������� ������, ��
      , AmountRetInWeight   TFloat --����� ������� � ����������� ������, �� ���
      , AmountPlanMin       TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��)
      , AmountPlanMinWeight TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
      , AmountPlanMax       TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��)
      , AmountPlanMaxWeight TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
      , AmountOrder         TFloat --���-�� ������ (����)
      , AmountOrderWeight   TFloat --���-�� ������ (����) ���
      , AmountOut           TFloat --���-�� ���������� (����)
      , AmountOutWeight     TFloat --���-�� ���������� (����) ���
      , AmountIn            TFloat --���-�� ������� (����)
      , AmountInWeight      TFloat --���-�� ������� (����) ���
      
      , AmountPlan1         TFloat -- ���-�� ���� �������� �� ��.
      , AmountPlan2         TFloat -- ���-�� ���� �������� �� ��.
      , AmountPlan3         TFloat -- ���-�� ���� �������� �� ��.
      , AmountPlan4         TFloat -- ���-�� ���� �������� �� ��.
      , AmountPlan5         TFloat -- ���-�� ���� �������� �� ��.
      , AmountPlan6         TFloat -- ���-�� ���� �������� �� ��.
      , AmountPlan7         TFloat -- ���-�� ���� �������� �� ��.
      
      , GoodsKindId         Integer --�� ������� <��� ������>
      , GoodsKindName       TVarChar --������������ ������� <��� ������>
      , GoodsKindName_List  TVarChar --������������ ������� <��� ������ (���������)>
      , Comment             TVarChar --�����������
      , isErased            Boolean  --������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);


    CREATE TEMP TABLE _tmpPromoPartner (PartnerId Integer) ON COMMIT DROP;
    INSERT INTO _tmpPromoPartner (PartnerId)
            SELECT MI_PromoPartner.ObjectId        AS PartnerId   --�� ������� <�������>
            FROM Movement AS Movement_PromoPartner
                 INNER JOIN MovementItem AS MI_PromoPartner
                                         ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                        AND MI_PromoPartner.DescId = zc_MI_Master()
                                        AND MI_PromoPartner.IsErased = FALSE
            WHERE Movement_PromoPartner.ParentId = inMovementId
              AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner();

    CREATE TEMP TABLE _tmpGoodsKind_inf (GoodsId Integer, ValueData TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpGoodsKind_inf (GoodsId, ValueData) 
            SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                 , STRING_AGG (DISTINCT ObjectString_GoodsKind.ValueData :: TVarChar, ',') AS ValueData
            FROM _tmpPromoPartner
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                      ON ObjectLink_GoodsListSale_Partner.ChildObjectId = _tmpPromoPartner.PartnerId
                                     AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                     
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                      ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                     AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                 INNER JOIN (SELECT MovementItem.ObjectId 
                             FROM MovementItem 
                             WHERE MovementItem.MovementId = inMovementId 
                               AND MovementItem.DescId = zc_MI_Master() 
                               AND MovementItem.isErased = FALSE) AS MI_Master ON MI_Master.ObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                 INNER JOIN ObjectString AS ObjectString_GoodsKind
                                         ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                        AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                        AND ObjectString_GoodsKind.ValueData <> ''
            GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId;
                                       
    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList) 
            SELECT DISTINCT _tmpGoodsKind_inf.ValueData AS WordList
            FROM _tmpGoodsKind_inf;
            
    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);


    RETURN QUERY
        WITH
        tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, STRING_AGG (DISTINCT Object.ValueData :: TVarChar, ',')  AS GoodsKindName_list
                         FROM _tmpWord_Split_to  
                              LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                         GROUP BY _tmpWord_Split_to.WordList
                         )
      , tmpGoodsKind_list AS (SELECT _tmpGoodsKind_inf.GoodsId
                                   , STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName_List :: TVarChar, ',')  AS GoodsKindName_List
                              FROM _tmpGoodsKind_inf
                                   LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = _tmpGoodsKind_inf.ValueData
                              GROUP BY _tmpGoodsKind_inf.GoodsId
                             )
      
        SELECT MovementItem.Id                        AS Id                  --�������������
             , MovementItem.MovementId                AS MovementId          --�� ��������� <�����>
             , MovementItem.ObjectId                  AS GoodsId             --�� ������� <�����>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --��� �������  <�����>
             , Object_Goods.ValueData                 AS GoodsName           --������������ ������� <�����>
             , Object_Measure.ValueData               AS Measure             --������� ���������
             , Object_TradeMark.ValueData             AS TradeMark           --�������� �����
             , MovementItem.Amount                    AS Amount              --% ������ �� �����
             , MIFloat_Price.ValueData                AS Price               --���� � ������
             , MIFloat_PriceSale.ValueData            AS PriceSale           --���� �� �����
             , MIFloat_PriceWithOutVAT.ValueData      AS PriceWithOutVAT     --���� �������� ��� ����� ���, � ������ ������, ���
             , MIFloat_PriceWithVAT.ValueData         AS PriceWithVAT        --���� �������� � ������ ���, � ������ ������, ���
       
       
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
       
             , MIFloat_Plan1.ValueData                AS AmountPlan1
             , MIFloat_Plan2.ValueData                AS AmountPlan2
             , MIFloat_Plan3.ValueData                AS AmountPlan3
             , MIFloat_Plan4.ValueData                AS AmountPlan4
             , MIFloat_Plan5.ValueData                AS AmountPlan5
             , MIFloat_Plan6.ValueData                AS AmountPlan6
             , MIFloat_Plan7.ValueData                AS AmountPlan7 
                 
             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId         --�� ������� <��� ������>
             , Object_GoodsKind.ValueData             AS GoodsKindName       --������������ ������� <��� ������>
             , tmpGoodsKind_list.GoodsKindName_List ::TVarChar               -- ������������ ������� <��� ������ (���������)>
             
             , MIString_Comment.ValueData             AS Comment             -- ����������
             , MovementItem.isErased                  AS isErased            -- ������
             --, CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- ���
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
             LEFT JOIN MovementItemFloat AS MIFloat_AmountRetIn
                                         ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMin
                                         ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                         ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

             LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                         ON MIFloat_Plan1.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                         ON MIFloat_Plan2.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan2.DescId = zc_MIFloat_Plan2()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                         ON MIFloat_Plan3.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan3.DescId = zc_MIFloat_Plan3()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                         ON MIFloat_Plan4.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan4.DescId = zc_MIFloat_Plan4()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                         ON MIFloat_Plan5.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan5.DescId = zc_MIFloat_Plan5()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                         ON MIFloat_Plan6.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan6.DescId = zc_MIFloat_Plan6()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                         ON MIFloat_Plan7.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan7.DescId = zc_MIFloat_Plan7() 

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
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
             
             
             LEFT JOIN tmpGoodsKind_list ON tmpGoodsKind_list.GoodsId = MovementItem.ObjectId

        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 10.11.17         *
 05.11.15                                                          *
*/
-- ����
-- SELECT * FROM gpSelect_MovementItem_PromoGoods (5083159 , FALSE, zfCalc_UserAdmin());
