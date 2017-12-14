-- Function: gpDelete_LockUnique_byPrint()

DROP FUNCTION IF EXISTS gpDelete_LockUnique_byPrint (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_LockUnique_byPrint(
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);

     -- �������� ���� ��� ��������� ����� ���. ������������
      DELETE FROM LockUnique WHERE UserId = vbUserId;
      
      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.12.17         *
*/

-- ����
-- SELECT * FROM gpDelete_LockUnique_byPrint (inSession:= '2')
