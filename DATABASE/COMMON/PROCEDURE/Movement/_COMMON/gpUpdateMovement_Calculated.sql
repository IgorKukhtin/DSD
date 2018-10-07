-- Function: gpUpdateMovement_Calculated()

DROP FUNCTION IF EXISTS gpUpdateMovement_Calculated (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Calculated(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT ioisCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession;

     -- ���������� �������
     ioisCalculated:= NOT ioisCalculated;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Calculated(), inId, ioisCalculated);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.10.18         * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_Calculated (inId:= 275079, ioisCalculated:= 'False', inSession:= '2')
