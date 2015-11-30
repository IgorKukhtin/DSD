-- Function: gpSelect_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Reprice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Reprice(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, PriceOld TFloat, PriceNew TFloat, SummReprice TFloat)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Reprice());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        SELECT
            MovementItem_Reprice.Id
          , MovementItem_Reprice.GoodsId
          , MovementItem_Reprice.GoodsCode
          , MovementItem_Reprice.GoodsName
          , MovementItem_Reprice.Amount
          , MovementItem_Reprice.PriceOld
          , MovementItem_Reprice.PriceNew
          , MovementItem_Reprice.SummReprice
        FROM 
            MovementItem_Reprice_View AS MovementItem_Reprice
        WHERE
            MovementItem_Reprice.MovementId = inMovementId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Reprice (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 27.11.15                                                          *
*/