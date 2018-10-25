-- Function: gpDelete_LockUnique_byUnion()

DROP FUNCTION IF EXISTS gpDelete_LockUnique_byUnion (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_LockUnique_byUnion(
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
 20.10.18         *
*/

-- ����
-- SELECT * FROM gpDelete_LockUnique_byUnion (inSession:= '2')
