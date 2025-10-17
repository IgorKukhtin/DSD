-- Function: gpUnComplete_Movement_StaffListMember (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_StaffListMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_StaffListMember(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_StaffListMember());
      vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ��� �� ��������� ����� 
     SELECT Movement.OperDate
          , MovementLinkObject_Member.ObjectId AS MemberId
    INTO vbOperDate, vbMemberId
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                        ON MovementLinkObject_Member.MovementId = Movement.Id
                                       AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
     WHERE Movement.Id = inMovementId
     ;

     vbMovementId_last := (--�������� �� ������� ���� ������ ��������� ����� ��������
                           SELECT Movement.*
                           FROM Movement 
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                                              ON MovementLinkObject_Member.MovementId = Movement.Id
                                                             AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                                             AND MovementLinkObject_Member.ObjectId = vbMemberId
                           WHERE Movement.DescId = zc_Movement_StaffListMember()
                             AND Movement.OperDate >= vbOperDate
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.Id <> inMovementId
                           LIMIT 1
                           );

     IF COALESCE (vbMovementId_last,0) <> 0
     THEN
          RAISE EXCEPTION '������.���������� ���������. ���� ����� ������� ���������. ';  
     END IF;

      -- ����������� ��������
      PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                   , inUserId     := vbUserId
                                    ); 
     if vbUserId = 9457 then RAISE EXCEPTION '�����.Test Ok.';  end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         *
*/

-- ����
--