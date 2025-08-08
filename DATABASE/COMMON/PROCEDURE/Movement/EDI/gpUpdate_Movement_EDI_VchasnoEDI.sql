-- Function: gpUpdate_Movement_EDI_VchasnoEDI()

-- DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_VchasnoEDI (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_VchasnoEDI (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_VchasnoEDI(
    IN inMovementId          Integer    , -- ���� ������� <��������>
    IN inDealId              TVarChar   , -- �������� �� ����� ���������� � ������
    IN inId_doc              TVarChar   , -- �� doc ���������� � ������ ������
    IN inSession             TVarChar     -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Params());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� DealId �������� �� ���������� � ������, ����� ����� ��������� �������� �� ������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_DealId(), inMovementId, inDealId);

     -- ��������� DocId_vch
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_DocId_vch(), inMovementId, inId_doc);

     -- ���������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), inMovementId, TRUE);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.03.23                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_EDI_VchasnoEDI (inMovementId:= 10, inisLoad:= False, inSession:= '2')