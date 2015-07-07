-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer              , --��� ������ 0-������, 1-�����
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
  vbUserId:= inSession;

  --�������� ���� ��������� 
  UPDATE Movement SET OperDate = CURRENT_TIMESTAMP WHERE Id = inMovementId;
  
  --��������� ��� ������
  if inPaidType = 0 then
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Cash());
  ELSEIF inPaidType = 1 THEN
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Card());
  ELSE
    RAISE EXCEPTION '������.�� ��������� ��� ������';
  END IF;

  -- ����������� �������� �����
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

  -- ���������� ��������
  PERFORM lpComplete_Movement_Check(inMovementId, -- ���� ���������
                                    vbUserId);    -- ������������                          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 06.07.15                                                                       *  �������� ��� ������
 05.02.15                         * 

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
