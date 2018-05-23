-- Function: gpUpdateMovement_isList()

DROP FUNCTION IF EXISTS gpUpdateMovement_isList (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isList(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIsList              Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), inMovementId, inIsList);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.18                                        * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_isList (inMovementId:= 275079, inisList:= TRUE, inSession:= zfCalc_UserAdmin())
