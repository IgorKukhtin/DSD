-- Function: gpUpdate_Movement_Check__NotMCS()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check__NotMCS(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check__NotMCS(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inisNotMCS            Boolean   , -- �� ��� ���
   OUT outisNotMCS           Boolean   , -- �� ��� ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  --������ ������� �� ��� ���
  Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_NotMCS(), inMovementId, NOT inisNotMCS);
  
  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

  outisNotMCS := NOT inisNotMCS;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 23.01.20                                                                    *
*/

-- ����