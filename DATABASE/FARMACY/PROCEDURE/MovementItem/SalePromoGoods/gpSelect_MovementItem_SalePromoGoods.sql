-- Function: gpSelect_MovementItem_SalePromoGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SalePromoGoods (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SalePromoGoods(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ����� <�������� ����>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- ���������
    IF inShowAll THEN
        -- ��������� �����
        RETURN QUERY
            WITH 
                
            MI_PromoCode AS (SELECT MI_PromoCode.Id
                                  , MI_PromoCode.ObjectId AS GoodsId
                                  , MI_PromoCode.Amount
                                  , MI_PromoCode.IsErased
                             FROM MovementItem AS MI_PromoCode
                             WHERE MI_PromoCode.MovementId = inMovementId
                               AND MI_PromoCode.DescId = zc_MI_Master()
                               AND (MI_PromoCode.isErased = FALSE or inIsErased = TRUE)
                             )

            SELECT COALESCE(MI_PromoCode.Id,0)           AS Id
                 , Object_Goods.Id                       AS GoodsId
                 , Object_Goods.ObjectCode               AS GoodsCode
                 , Object_Goods.Name                     AS GoodsName
                 , MI_PromoCode.Amount                   AS Amount
                 , COALESCE(MI_PromoCode.IsErased,FALSE) AS isErased
            FROM Object_Goods_Main AS Object_Goods
                FULL OUTER JOIN MI_PromoCode ON MI_PromoCode.GoodsId = Object_Goods.Id
            WHERE Object_Goods.isErased = FALSE 
               OR MI_PromoCode.Id IS NOT NULL;
    ELSE
        -- ��������� ������
        RETURN QUERY

           SELECT MI_PromoCode.Id
                , MI_PromoCode.ObjectId     AS GoodsId
                , Object_Goods.ObjectCode   AS GoodsCode
                , Object_Goods.Name         AS GoodsName
                , MI_PromoCode.Amount       AS Amount
                , MI_PromoCode.IsErased
           FROM MovementItem AS MI_PromoCode
                LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MI_PromoCode.ObjectId  
   
           WHERE MI_PromoCode.MovementId = inMovementId
             AND MI_PromoCode.DescId = zc_MI_Master()
             AND (MI_PromoCode.isErased = FALSE or inIsErased = TRUE);
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.22                                                       *
*/

-- select * from gpSelect_MovementItem_SalePromoGoods(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3'::TVarChar);