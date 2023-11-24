-- gpUpdate_Movement_Tax_UKTZ_new()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Tax_UKTZ_new (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Tax_UKTZ_new (
    IN inMovementId          Integer   , -- ���� ������� <>
 INOUT ioIsUKTZ_new          Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- ��������� ������ ��� zc_Enum_DocumentTaxKind_Prepay
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax_UKTZ_new());
    

     -- ���������� �������
     ioIsUKTZ_new:= NOT ioIsUKTZ_new;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_UKTZ_new(), inMovementId, ioIsUKTZ_new);


    IF vbUserId = 9457 OR vbUserId = 5
    THEN
          RAISE EXCEPTION '����. ��. <%>', ioIsUKTZ_new; 
    END IF; 
 
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.11.23         *
*/

-- ����
--