--

-- Function: gpSelect_MovementItem_Promo()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Promo (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Promo(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat, Summ TFloat
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    -- ����� <�������� ����>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    -- ������������ �������������
    --SELECT Movement_Promo.UnitId
    --INTO vbUnitId
    --FROM Movement
    --WHERE Movement.Id = inMovementId;

    -- ���������
    IF inShowAll THEN
        -- ��������� �����
        RETURN QUERY
            WITH 
                
            tmpGoods AS (  SELECT Object_Goods_View.Id
                                , Object_Goods_View.isErased
                                , Object_Goods_View.Price
                                , CASE WHEN Object_Goods_View.isSecond = TRUE THEN 16440317 WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc   --10965163
                           FROM Object_Goods_View
                             --   LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = Object_Goods_View.ObjectId
                           WHERE Object_Goods_View.ObjectId = vbObjectId
                             AND (Object_Goods_View.isErased = FALSE OR (Object_Goods_View.isErased = TRUE AND inIsErased = TRUE))
                         )

           ,MI_Promo AS (SELECT   MI_Promo.Id
                                , MI_Promo.ObjectId       AS GoodsId
                                , MI_Promo.Amount
                                , MIFloat_Price.ValueData AS Price
                                , COALESCE(MI_Promo.Amount,0) * COALESCE(MIFloat_Price.ValueData,0) AS Summ
                                , MI_Promo.IsErased
                         FROM MovementItem AS MI_Promo
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MI_Promo.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         WHERE MI_Promo.MovementId = inMovementId
                           AND MI_Promo.DescId = zc_MI_Master()
                           AND (MI_Promo.isErased = FALSE or inIsErased = TRUE)
                         )

            SELECT COALESCE(MI_Promo.Id,0)     AS Id
                 , Object_Goods.Id                       AS GoodsId
                 , Object_Goods.ObjectCode               AS GoodsCode
                 , Object_Goods.ValueData                AS GoodsName
                 , MI_Promo.Amount                       AS Amount
                 , COALESCE(MI_Promo.Price,0) ::TFloat   AS Price
                 , MI_Promo.Summ              ::TFloat   AS Summ
                 , COALESCE(MI_Promo.IsErased,FALSE)     AS isErased
            FROM tmpGoods
                FULL OUTER JOIN MI_Promo ON tmpGoods.Id = MI_Promo.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MI_Promo.GoodsId,tmpGoods.Id)

            WHERE Object_Goods.isErased = FALSE 
               OR MI_Promo.id is not null;
    ELSE
        -- ��������� ������
        RETURN QUERY

           SELECT MI_Promo.Id
                , MI_Promo.ObjectId                    AS GoodsId
                , Object_Goods.ObjectCode              AS GoodsCode
                , Object_Goods.ValueData               AS GoodsName
                , MI_Promo.Amount             ::TFloat 
                , MIFloat_Price.ValueData     ::TFloat AS Price
                , (COALESCE(MI_Promo.Amount,0) * COALESCE(MIFloat_Price.ValueData,0)) ::TFloat AS Summ
                , MI_Promo.IsErased
           FROM MovementItem AS MI_Promo
              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MI_Promo.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Promo.ObjectId                                         
           WHERE MI_Promo.MovementId = inMovementId
             AND MI_Promo.DescId = zc_MI_Master()
             AND (MI_Promo.isErased = FALSE or inIsErased = TRUE);
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Promo (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 24.04.16         *
*/

--select * from gpSelect_MovementItem_Promo(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
--select * from gpSelect_MovementItem_PromoChild(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');