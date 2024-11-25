-- Function: gpUpdate_Scale_Movement_ChangePercentAmount()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_ChangePercentAmount (Integer, TFloat, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_ChangePercentAmount(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-�� ����������
    IN inIsReason1           Boolean   , -- ������� ������ � ���-�� �����������
    IN inIsReason2           Boolean   , -- ������� ������ � ���-�� ��������
    IN inBranchCode          Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <�����������> �� �����������.';
     END IF;

     --
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentAmount(), inMovementId, inChangePercentAmount);

     -- ��������� �������� <������� ������ � ���-�� �����������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason1(), inMovementId, inIsReason1);

     -- ��������� �������� <������� ������ � ���-�� ��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason2(), inMovementId, inIsReason2);
       
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.10.24                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_Movement_ChangePercentAmount (inMovementId:= 29547683, inBranchCode:= 201, inIsUpdate:= TRUE, inSession:= '5')
