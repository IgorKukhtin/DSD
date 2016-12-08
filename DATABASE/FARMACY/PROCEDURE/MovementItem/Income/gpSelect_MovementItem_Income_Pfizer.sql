-- Function: gpSelect_MovementItem_Income_Pfizer()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_Pfizer (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_Pfizer(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (MovementItemId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, BarCode TVarChar
             , Amount TFloat, Price TFloat
             , isRegistered Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
      SELECT
                MovementItem.Id             AS MovementItemId
              , MovementItem.ObjectId       AS GoodsId
              , Object_Goods.ObjectCode     AS GoodsCode
              , Object_Goods.ValueData      AS GoodsName
              , Object_BarCode.ValueData    AS BarCode
              , MovementItem.Amount         AS Amount
              , MIFloat_Price.ValueData     AS Price
              , COALESCE (MovementBoolean.ValueData, TRUE) AS isRegistered
          FROM MovementItem
               INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                     ON ObjectLink_BarCode_Goods.ChildObjectId = MovementItem.ObjectId
                                    AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
               INNER JOIN Object AS Object_BarCode ON Object_BarCode.Id = ObjectLink_BarCode_Goods.ObjectId
                                                  AND Object_BarCode.isErased = FALSE
                                                  AND Object_BarCode.ValueData <> ''
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()

               -- ��� ��� ���������, ��� � �� ���������� ��������
               LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = inMovementId
                                        AND MovementBoolean.DescId = zc_MovementBoolean_Registered()

          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE
            AND MovementItem.Amount     <> 0
         ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 06.12.16                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Income_Pfizer (inMovementId:= 3269551, inSession:= '3')
