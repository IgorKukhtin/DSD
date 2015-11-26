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
      , GoodsKindId         Integer --�� ������� <��� ������>
      , GoodsKindName       TVarChar --������������ ������� <��� ������>
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

    RETURN QUERY
        SELECT
            MI_PromoGoods.Id               --�������������
          , MI_PromoGoods.MovementId       --�� ��������� <�����>
          , MI_PromoGoods.GoodsId          --�� ������� <�����>
          , MI_PromoGoods.GoodsCode        --��� �������  <�����>
          , MI_PromoGoods.GoodsName        --������������ ������� <�����>
          , MI_PromoGoods.Measure          --������� ���������
          , MI_PromoGoods.TradeMark        --�������� �����
          , MI_PromoGoods.Amount           --% ������ �� �����
          , MI_PromoGoods.Price            --���� � ������
          , MI_PromoGoods.PriceSale        --���� �� �����
          , MI_PromoGoods.PriceWithOutVAT  --���� �������� ��� ����� ���, � ������ ������, ���
          , MI_PromoGoods.PriceWithVAT     --���� �������� � ������ ���, � ������ ������, ���
          , MI_PromoGoods.AmountReal       --����� ������ � ����������� ������, ��
          , MI_PromoGoods.AmountRealWeight --����� ������ � ����������� ������, �� ���
          , MI_PromoGoods.AmountPlanMin    --������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMinWeight --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanMax       --�������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMaxWeight --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountOrder         --���-�� ������ (����)
          , MI_PromoGoods.AmountOrderWeight   --���-�� ������ (����) ���
          , MI_PromoGoods.AmountOut           --���-�� ���������� (����)
          , MI_PromoGoods.AmountOutWeight     --���-�� ���������� (����) ���
          , MI_PromoGoods.AmountIn            --���-�� ������� (����)
          , MI_PromoGoods.AmountInWeight      --���-�� ������� (����) ���
          , MI_PromoGoods.GoodsKindId      --�� ������� <��� ������>
          , MI_PromoGoods.GoodsKindName    --������������ ������� <��� ������>
          , MI_PromoGoods.Comment          --�����������
          , MI_PromoGoods.isErased          --������
        FROM
            MovementItem_PromoGoods_View AS MI_PromoGoods
        WHERE
            MI_PromoGoods.MovementId = inMovementId
            AND
            (
                MI_PromoGoods.isErased = FALSE
                OR
                inIsErased = TRUE
            );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 05.11.15                                                          *
*/