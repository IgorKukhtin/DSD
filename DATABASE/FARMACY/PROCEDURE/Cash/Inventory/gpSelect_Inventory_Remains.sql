-- Function: gpSelect_Inventory_Remains()

DROP FUNCTION IF EXISTS gpSelect_Inventory_Remains(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Inventory_Remains(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (UnitId Integer, GoodsId Integer, Remains TFloat
              ) AS
$BODY$ 
  DECLARE vbUserId Integer;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY 
   SELECT Container.WhereObjectId        AS UnitId
        , Container.ObjectId             AS GoodsId
        , SUM(Container.Amount)::TFloat  AS Remains
      FROM Container
      WHERE Container.DescId = zc_Container_Count()
        AND Container.Amount <> 0 
        AND Container.WhereObjectId in (SELECT ID FROM gpSelect_Object_Unit_Active(0, inSession))
      GROUP BY Container.WhereObjectId
             , Container.ObjectId;       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 13.07.23                                                      *
*/

-- ����
--     

select * from gpSelect_Inventory_Remains (inSession := '3')