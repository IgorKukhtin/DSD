-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains(
    IN inUnitId           Integer  ,  -- �������������
    IN inRemainsDate      TDateTime,  -- ���� �������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     WITH 

     outRemains := COALESCE((SELECT SUM(Amount) FROM container  
               JOIN containerlinkobject AS CLO_Unit
                 ON CLO_Unit.containerid = container.id AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                AND CLO_Unit.objectid = inUnitId 
              WHERE container.descid = zc_container_count()
                AND container.ObjectId = inGoodsId), 0);
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.06.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_CashRemains (inSession:= '2')