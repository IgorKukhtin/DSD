-- Function: gpSelect_MovementItem_PromoUnit()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoUnit (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoUnit(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountPlanMax TFloat
             , Price TFloat
             , Summ TFloat, SummPlanMax TFloat 
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
    DECLARE vbUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoUnit());
    vbUserId:= lpGetUserBySession (inSession);

    -- ����� <�������� ����>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbUnitId := (SELECT ML.ObjectId FROM MovementLinkObject AS ML WHERE  ML.MovementId = inMovementId AND ML.DescId = zc_MovementLinkObject_Unit());

    -- ���������
    IF inShowAll THEN
        -- ��������� �����
        RETURN QUERY
            WITH 
            tmpPrice AS (SELECT Object_Price_View.GoodsId
                              , Object_Price_View.Price
                         FROM Object_Price_View
                         WHERE Object_Price_View.UnitId = vbUnitId
                         )

        , MI_PromoUnit AS (SELECT MI_PromoUnit.Id
                                , MI_PromoUnit.ObjectId       AS GoodsId
                                , MI_PromoUnit.Amount
                                , MIFloat_AmountPlanMax.ValueData  ::TFloat AS AmountPlanMax
                                , MIFloat_Price.ValueData AS Price
                                , COALESCE(MI_PromoUnit.Amount,0) * COALESCE(MIFloat_Price.ValueData,0) AS Summ
                                , COALESCE(MIFloat_AmountPlanMax.ValueData,0) * COALESCE(MIFloat_Price.ValueData,0) AS SummPlanMax
                                , MIString_Comment.ValueData       ::TVarChar AS Comment
                                , MI_PromoUnit.IsErased
                         FROM MovementItem AS MI_PromoUnit
                             LEFT JOIN MovementItemString AS MIString_Comment
                                                          ON MIString_Comment.MovementItemId = MI_PromoUnit.Id
                                                         AND MIString_Comment.DescId = zc_MIString_Comment()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                         ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                                        AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         WHERE MI_PromoUnit.MovementId = inMovementId
                           AND MI_PromoUnit.DescId = zc_MI_Master()
                           AND (MI_PromoUnit.isErased = FALSE or inIsErased = TRUE)
                         )

            SELECT COALESCE(MI_PromoUnit.Id,0)           AS Id
                 , Object_Goods.Id                       AS GoodsId
                 , Object_Goods.ObjectCode               AS GoodsCode
                 , Object_Goods.ValueData                AS GoodsName
                 , MI_PromoUnit.Amount                   AS Amount
                 , MI_PromoUnit.AmountPlanMax            AS AmountPlanMax
                 , COALESCE(MI_PromoUnit.Price,tmpPrice.Price) ::TFloat   AS Price
                 , MI_PromoUnit.Summ              ::TFloat   AS Summ
                 , MI_PromoUnit.SummPlanMax       ::TFloat   AS SummPlanMax
                 , COALESCE(MI_PromoUnit.Comment, '') ::TVarChar AS Comment
                 , COALESCE(MI_PromoUnit.IsErased,FALSE)     AS isErased
            FROM tmpPrice
                FULL OUTER JOIN MI_PromoUnit ON tmpPrice.GoodsId = MI_PromoUnit.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MI_PromoUnit.GoodsId,tmpPrice.GoodsId)
            WHERE Object_Goods.isErased = FALSE 
               OR MI_PromoUnit.id is not null;
    ELSE
        -- ��������� ������
        RETURN QUERY
           SELECT MI_PromoUnit.Id
                , MI_PromoUnit.ObjectId                AS GoodsId
                , Object_Goods.ObjectCode              AS GoodsCode
                , Object_Goods.ValueData               AS GoodsName
                , MI_PromoUnit.Amount              ::TFloat 
                , MIFloat_AmountPlanMax.ValueData  ::TFloat AS AmountPlanMax
                , MIFloat_Price.ValueData          ::TFloat AS Price
                , (COALESCE(MI_PromoUnit.Amount,0) * COALESCE(MIFloat_Price.ValueData,0))           ::TFloat AS Summ
                , (COALESCE(MIFloat_AmountPlanMax.ValueData,0) * COALESCE(MIFloat_Price.ValueData,0)) ::TFloat AS SummPlanMax
                , MIString_Comment.ValueData       ::TVarChar AS Comment
                , MI_PromoUnit.IsErased
           FROM MovementItem AS MI_PromoUnit
              LEFT JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MI_PromoUnit.Id
                                          AND MIString_Comment.DescId = zc_MIString_Comment()

              LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                          ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                         AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PromoUnit.ObjectId                                         
           WHERE MI_PromoUnit.MovementId = inMovementId
             AND MI_PromoUnit.DescId = zc_MI_Master()
             AND (MI_PromoUnit.isErased = FALSE or inIsErased = TRUE);
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 04.02.17         *
*/

--select * from gpSelect_MovementItem_PromoUnit(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
--select * from gpSelect_MovementItem_PromoUnitChild(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');