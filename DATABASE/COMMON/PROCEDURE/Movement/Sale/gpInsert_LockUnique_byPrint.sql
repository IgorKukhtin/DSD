-- Function: gpInsert_LockUnique_byPrint()

DROP FUNCTION IF EXISTS gpInsert_LockUnique_byPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_LockUnique_byPrint(
    IN inMovementId      Integer,    -- Id ���������
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);

      -- ��������� �� ����������  ����. LockUnique
      INSERT INTO LockUnique (KeyData, UserId, OperDate)
             VALUES (inMovementId :: TVarChar, vbUserId, CURRENT_DATE);   --CURRENT_TIMESTAMP

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.12.17         *
*/

-- ����
-- SELECT * FROM gpInsert_LockUnique_byPrint (inMovementId:= 56464, inSession:= '2')
