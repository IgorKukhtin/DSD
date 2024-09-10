-- Function: gpDelete_Object_Print_byUser ()

DROP FUNCTION IF EXISTS gpDelete_Object_Print_byUser (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_Print_byUser(
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   --
   DELETE FROM Object_Print WHERE UserId = vbUserId;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.09.24         *
*/

-- ����
--