-- Function: lfCheck_Movement_ParentStatus (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lfCheck_Movement_ParentStatus (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lfCheck_Movement_ParentStatus(
    IN inMovementId  Integer ,
    IN inNewStatusId Integer ,
    IN inComment     TVarChar
)
  RETURNS void
AS
$BODY$
  DECLARE vbOperDate  TDateTime;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbItemName  TVarChar;
BEGIN

     -- �������� ��� ��������� <Child> �� ��������/����������� - ���� <Master> ������, �� <������>
     IF inNewStatusId <> zc_Enum_Status_Erased()
     THEN
     IF EXISTS (SELECT Movement.Id FROM Movement JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId AND Movement_Parent.StatusId = zc_Enum_Status_Erased() WHERE Movement.Id = inMovementId)
     THEN
         -- ������� ��������� <Master> ���������
         SELECT Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                INTO vbOperDate, vbInvNumber, vbItemName
         FROM (SELECT MAX (Movement_Parent.Id) AS MovementId_Parent
               FROM Movement
                    JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
                                                    AND Movement_Parent.StatusId = zc_Enum_Status_Erased()
               WHERE Movement.Id = inMovementId
              ) AS tmpMovement
              LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId_Parent
              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
         --
         RAISE EXCEPTION '������.���������� % �������� �.�. ������ <�������> �������� <%> � <%> �� <%> .', inComment, vbItemName, vbInvNumber, vbOperDate;
     END IF;
     END IF;

     -- �������� ��� ��������� <Child> �� ������ - ���� <Master> ��������, �� <������>
     IF inNewStatusId = zc_Enum_Status_Erased()
     THEN
     IF EXISTS (SELECT Movement.Id FROM Movement JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId AND Movement_Parent.StatusId = zc_Enum_Status_Complete() WHERE Movement.Id = inMovementId)
     THEN
         -- ������� ��������� <Master> ���������
         SELECT Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                INTO vbOperDate, vbInvNumber, vbItemName
         FROM (SELECT MAX (Movement_Parent.Id) AS MovementId_Parent
               FROM Movement
                    JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
                                                    AND Movement_Parent.StatusId = zc_Enum_Status_Complete()
               WHERE Movement.Id = inMovementId
              ) AS tmpMovement
              LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId_Parent
              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
         --
         RAISE EXCEPTION '������.���������� % �������� �.�. �������� <�������> �������� <%> � <%> �� <%> .', inComment, vbItemName, vbInvNumber, vbOperDate;
     END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfCheck_Movement_ParentStatus (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.13                                        *
*/

-- ����
-- SELECT * FROM lfCheck_Movement_ParentStatus (0, '���������')

