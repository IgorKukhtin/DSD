-- Function: gpUpdate_Movement_Check_SummaReceivedFact()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SummaReceivedFact(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SummaReceivedFact(
    IN inMovementId                Integer   , -- ���� ������� <��������>
    IN inSummaReceivedFact         TFloat    , --����� �������� �� �����
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 6534523))
  THEN
    RAISE EXCEPTION '��������� �������� <����� �������� �� �����> ��� ���������.';
  END IF;
      
  IF COALESCE(inSummaReceivedFact, 0) < 0
  THEN
    RAISE EXCEPTION '����� <����� �������� �� �����> ������ ���� �������������.';
  END IF;
  
  IF COALESCE(inSummaReceivedFact, 0) <> 0 AND
     EXISTS(SELECT * FROM  MovementBoolean AS MovementBoolean_RetrievedAccounting
            WHERE MovementBoolean_RetrievedAccounting.MovementId =  inMovementId
              AND MovementBoolean_RetrievedAccounting.DescId = zc_MovementBoolean_RetrievedAccounting()
              AND COALESCE(MovementBoolean_RetrievedAccounting.ValueData, False) = True)
  THEN
    RAISE EXCEPTION '���������� ������� <�������� ������������> ��������� <����� �������� �� �����> ������.';
  END IF;
    
  IF COALESCE(inSummaReceivedFact, 0) >= COALESCE((SELECT MovementFloat_TotalSumm.ValueData FROM  MovementFloat AS MovementFloat_TotalSumm
                                                  WHERE MovementFloat_TotalSumm.MovementId =  inMovementId
                                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()), 0)
  THEN
    RAISE EXCEPTION '����� <����� �������� �� �����> ������ ���� ������ ����� ����.';
  END IF;
  
  --������ ����� �������� �� �����
  Perform lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), inMovementId, inSummaReceivedFact);
  
  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 29.07.21                                                                    *
*/

-- ����