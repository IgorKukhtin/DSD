-- Function: lfCheck_Movement_ChildStatus (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lfCheck_Movement_ChildStatus (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lfCheck_Movement_ChildStatus(
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

     -- �������� ��� ��������� <Master> �� ������ - ���� <Child> ��������, �� <������>
     IF inNewStatusId = zc_Enum_Status_Erased()
     THEN
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- ������� ��������� <Child> ���������
         SELECT Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                INTO vbOperDate, vbInvNumber, vbItemName
         FROM (SELECT MAX (Movement.Id) AS MovementId
               FROM Movement
               WHERE Movement.ParentId = inMovementId
                 AND Movement.StatusId = zc_Enum_Status_Complete()
              ) AS tmpMovement
              LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
         --
         RAISE EXCEPTION '������.���������� % �������� �.�. �������� <�����������> �������� <%> � <%> �� <%> .', inComment, vbItemName, vbInvNumber, vbOperDate;
     END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfCheck_Movement_ChildStatus (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.13                                        *
*/

-- ����
-- SELECT * FROM lfCheck_Movement_ChildStatus (0, 0, 'test')
