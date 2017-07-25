-- Function: lpUpdate_MI_Partion_Total_byMovement()

DROP FUNCTION IF EXISTS lpUpdate_MI_Partion_Total_byMovement (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Partion_Total_byMovement(
    IN inMovementId           Integer    -- ���� ������� <��������>
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- ����������� "��������" ����� �� ��������� ������� / ��������
    PERFORM CASE WHEN Movement_Partion.DescId = zc_Movement_Sale()     THEN lpUpdate_MI_Sale_Total(MI_Partion.Id)
                 WHEN Movement_Partion.DescId = zc_Movement_ReturnIn() THEN lpUpdate_MI_ReturnIn_Total(MI_Partion.Id)
            END
    FROM MovementItem
         INNER JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                           ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()

         LEFT JOIN Object       AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
         LEFT JOIN MovementItem AS MI_Partion       ON MI_Partion.Id       = Object_PartionMI.ObjectCode
         LEFT JOIN Movement     AS Movement_Partion ON Movement_Partion.Id = MI_Partion.MovementId

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;
      
    -- ����������� "��������" ����� �� ��������� ������� ��� ������ ��������
    PERFORM lpUpdate_MI_Sale_Total(Object_PartionMI_level2.ObjectCode)
    FROM MovementItem
         -- �������� ����� ������ ��������
         INNER JOIN MovementItemLinkObject AS MILO_PartionMI_level1
                                           ON MILO_PartionMI_level1.MovementItemId = MovementItem.Id
                                          AND MILO_PartionMI_level1.DescId = zc_MILinkObject_PartionMI()
         LEFT JOIN Object AS Object_PartionMI_level1 ON Object_PartionMI_level1.Id = MILO_PartionMI_level1.ObjectId
         -- �������� ������ ������� ���� � ���������� ���� ������ ��������
         INNER JOIN MovementItemLinkObject AS MILO_PartionMI_level2
                                           ON MILO_PartionMI_level2.MovementItemId = Object_PartionMI_level1.ObjectCode
                                          AND MILO_PartionMI_level2.DescId         = zc_MILinkObject_PartionMI()
         LEFT JOIN Object AS Object_PartionMI_level2 ON Object_PartionMI_level2.Id = MILO_PartionMI_level2.ObjectId

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;
      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 24.07.17         *
*/

-- ����
-- 