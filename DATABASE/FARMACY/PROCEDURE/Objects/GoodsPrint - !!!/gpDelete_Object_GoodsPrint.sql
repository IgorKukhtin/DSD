-- Function: gpDelete_Object_GoodsPrint (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_GoodsPrint(
    IN inUnitId            Integer,
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS Void
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!������� ������� ������ ���� ������������� ������ ��� �� 7 ����!!!
   --DELETE FROM Object_GoodsPrint 
   --WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';


   -- ������� ��� �������� ��� �������� ������������
   DELETE 
   FROM Object_GoodsPrint 
   WHERE Object_GoodsPrint.UserId = vbUserId
     AND (Object_GoodsPrint.UnitId = inUnitId OR inUnitId = 0);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
27.05.19          *
*/

-- ����
--