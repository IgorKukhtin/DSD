-- Function: gpDelete_Object_Print ()

DROP FUNCTION IF EXISTS gpDelete_Object_Print (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_Print(
    IN inSession       VarChar      -- ������ ������������
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!������� ������ �� �������� ������������
   DELETE FROM ObjectPrint WHERE ObjectPrint.UserId = vbUserId;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.05.20         *
*/

-- ����
--