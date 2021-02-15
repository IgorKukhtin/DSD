-- Function: gpUnComplete_Movement_FinalSUA (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_FinalSUA (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_FinalSUA(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_FinalSUA());
    vbUserId := inSession;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '����������� �������� ��� ���������, ���������� � ���������� ��������������';
    END IF;

    -- ����������� �������� ��������� ������
    SELECT Movement.StatusId, Movement.OperDate
    INTO vbStatusId, vbOperDate  
    FROM Movement
    WHERE Movement.Id = inMovementId;
    
    IF vbStatusId = zc_Enum_StatusCode_Erased()
       AND EXISTS(SELECT Movement.id
                  FROM Movement 
                  WHERE Movement.OperDate = vbOperDate  
                    AND Movement.DescId = zc_Movement_FinalSUA() 
                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                  )
     THEN 
       RAISE EXCEPTION '������. �������� "�������� ���" ����� % ������ ����� ������ �������� ���������.', vbOperDate;     
     END IF;     
              
    -- �������� - ���� <Master> ������, �� <������>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_FinalSUA_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.21                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_FinalSUA (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())