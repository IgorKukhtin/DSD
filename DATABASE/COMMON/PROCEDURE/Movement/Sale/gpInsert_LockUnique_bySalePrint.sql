-- Function: gpInsert_LockUnique_bySalePrint()

DROP FUNCTION IF EXISTS gpInsert_LockUnique_bySalePrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_LockUnique_bySalePrint(
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
      PERFORM lpInsert_LockUnique (inKeyData := inMovementId :: TVarChar
                                 , inUserId  := vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.12.17         *
*/

-- ����
-- SELECT * FROM gpInsert_LockUnique_bySalePrint (inMovementId:= 56464, inSession:= '2')
