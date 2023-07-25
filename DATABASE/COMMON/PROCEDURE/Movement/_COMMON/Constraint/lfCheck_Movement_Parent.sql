-- Function: lfCheck_Movement_Parent (Integer, TVarChar)

DROP FUNCTION IF EXISTS lfCheck_Movement_Parent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lfCheck_Movement_Parent(
    IN inMovementId Integer ,
    IN inComment   TVarChar
)
  RETURNS void
AS
$BODY$
  DECLARE vbOperDate  TDateTime;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbItemName  TVarChar;
BEGIN

     -- �������� - ��������� ��������� �������� ������
     IF EXISTS (SELECT 1
                FROM Movement
                     JOIN Movement AS Movement_parent ON Movement_parent.Id     = Movement.ParentId
                                                     AND Movement_parent.DescId <> zc_Movement_WeighingPartner()
                WHERE Movement.Id = inMovementId AND Movement.ParentId IS NOT NULL
               )
     THEN
         -- ������� ��������� "��������" ���������
         SELECT Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                INTO vbOperDate, vbInvNumber, vbItemName
         FROM (SELECT MAX (Movement_Parent.Id) AS MovementId_Parent
               FROM Movement
                    JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
               WHERE Movement.Id = inMovementId
              ) AS tmpMovement
              LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId_Parent
              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
         --
         RAISE EXCEPTION '������.���������� % ��������� �.�. �� ������ � <%> � <%> �� <%>.', inComment, vbItemName, vbInvNumber, vbOperDate;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM lfCheck_Movement_Parent (0, '���������')
