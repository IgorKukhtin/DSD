-- Function: gpUpdate_Movement_Check_RetrievedAccounting()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_RetrievedAccounting(Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_RetrievedAccounting(
    IN inMovementId                Integer   , -- ���� ������� <��������>
    IN inisRetrievedAccounting     Boolean   , -- �������� ������������
    IN inTotalSumm                 TFloat    , -- �����
 INOUT ioSummaReceivedFact         TFloat    , -- ����� �������� �� �����
 INOUT ioRetrievedAccounting       TFloat    , -- �������� ������������
 INOUT ioSummaReceived             TFloat    , -- ����� �� �����
 INOUT ioSummaReceivedDelta        TFloat    , -- �������
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 6534523))
  THEN
    RAISE EXCEPTION '��������� �������� <�������� ������������> ��� ���������.';
  END IF;
  
  IF COALESCE(inisRetrievedAccounting, False) = TRUE AND
     EXISTS(SELECT * FROM  MovementFloat AS MovementFloat_SummaReceivedFact
            WHERE MovementFloat_SummaReceivedFact.MovementId =  inMovementId
              AND MovementFloat_SummaReceivedFact.DescId = zc_MovementFloat_SummaReceivedFact()
              AND COALESCE(MovementFloat_SummaReceivedFact.ValueData, 0) <> 0)
  THEN
    RAISE EXCEPTION '��������� <����� �������� �� �����> �������� <�������� ������������> ������������� ������.';
  END IF;
  
      
  --������ �������� ������������
  PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_RetrievedAccounting(), inMovementId, inisRetrievedAccounting);

  --������ ����� �������� �� �����
  IF COALESCE (ioSummaReceivedFact, 0) <> 0
  THEN
    PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), inMovementId, 0);
      
    ioRetrievedAccounting := ioRetrievedAccounting - inTotalSumm;
    ioSummaReceived := ioSummaReceived - ioSummaReceivedFact;      
  END IF;
  
  IF inisRetrievedAccounting = TRUE
  THEN
    ioRetrievedAccounting := ioRetrievedAccounting + inTotalSumm;
    ioSummaReceived := ioSummaReceived + inTotalSumm;
  ELSE
    ioRetrievedAccounting := ioRetrievedAccounting - inTotalSumm;
    ioSummaReceived := ioSummaReceived - inTotalSumm;  
  END IF;
  
  ioSummaReceivedDelta := ioRetrievedAccounting - ioSummaReceived;
  ioSummaReceivedFact := 0;
    
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