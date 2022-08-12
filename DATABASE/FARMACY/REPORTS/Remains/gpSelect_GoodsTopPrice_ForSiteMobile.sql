-- Function: gpSelect_GoodsTopPrice_ForSiteMobile()

DROP FUNCTION IF EXISTS gpSelect_GoodsTopPrice_ForSiteMobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsTopPrice_ForSiteMobile(
    IN inGoodsId       Integer  ,  -- ������ �������, ����� ���
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (UnitId            Integer -- ������
             , Price_unit        TFloat -- ���� ������
             , Price_unit_sale   TFloat -- ���� ������ �� �������
             , Remains           TFloat -- ������� (� ������ �������)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    SELECT p.UnitId 
         , p.Price_unit
         , p.Price_unit_sale
         , p.Remains
    FROM gpSelect_GoodsOnUnit_ForSiteMobile ('', inGoodsId::TVarChar, zfCalc_UserSite()) AS p
    WHERE COALESCE(p.Remains, 0) > 0
    ORDER BY p.Price_unit, p.Remains DESC
    LIMIT 3
    ;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.08.22                                                       *
*/

-- ����

SELECT p.* FROM gpSelect_GoodsTopPrice_ForSiteMobile (6307, zfCalc_UserSite()) AS p
