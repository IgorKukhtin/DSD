-- Function: gpUnComplete_Movement_SendPartionDate (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SendPartionDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SendPartionDate(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendPartionDate());

    IF EXISTS(SELECT 1 FROM Movement AS MovementCurr
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCurr
                                              ON MovementLinkObject_UnitCurr.MovementId = MovementCurr.Id
                                             AND MovementLinkObject_UnitCurr.DescId = zc_MovementLinkObject_Unit()

                 INNER JOIN Movement AS MovementNext
                                     ON MovementNext.OperDate >= MovementCurr.OperDate
                                    AND MovementNext.DescId = zc_Movement_SendPartionDate()
                                    AND MovementNext.StatusId = zc_Enum_Status_Complete()
                                    AND MovementNext.ID <> inMovementId
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitNext
                                              ON MovementLinkObject_UnitNext.MovementId = MovementNext.Id
                                             AND MovementLinkObject_UnitNext.DescId = zc_MovementLinkObject_Unit()
                                             AND MovementLinkObject_UnitNext.ObjectId = MovementLinkObject_UnitCurr.ObjectId

              WHERE MovementCurr.ID = inMovementId
                AND MovementCurr.StatusId = zc_Enum_Status_Complete()
             )
    THEN
        RAISE EXCEPTION '������.������������ ����� ������ ��������� �������� �� �������������...';
    END IF;

    -- �������� - ���� <Master> ������, �� <������>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    --������������� ����� ��������� �� ��������� �����
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.08.18                                                       *
 15.08.18         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_SendPartionDate (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())