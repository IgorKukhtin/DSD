-- Function: gpUnComplete_Movement_Layout (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Layout (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Layout(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbLayoutId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Layout());

     -- �������� ����, ��������, ���. ��� ������ , �� ������ ��������� ������������ ���� ���� ����� � ����� ���������
     vbLayoutId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Layout() AND MLO.MovementId = inMovementId);

     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Layout
                                                   ON MovementLinkObject_Layout.MovementId = Movement.Id
                                                  AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
                                                  AND MovementLinkObject_Layout.ObjectId = vbLayoutId
                WHERE Movement.DescId = zc_Movement_Layout()
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                  AND Movement.Id <> inMovementId)
     THEN
          RAISE EXCEPTION '������.�������� ��� �������� <%> ��� ����������.', lfGet_Object_ValueData (vbLayoutId);
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
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.08.20         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Layout (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
