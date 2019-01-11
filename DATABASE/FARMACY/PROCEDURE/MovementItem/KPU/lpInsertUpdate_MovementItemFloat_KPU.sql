-- Function: lpInsertUpdate_MovementItemFloat_KPU

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemFloat_KPU (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat_KPU(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inMovementItemId        Integer           , -- ���� 
    IN inValueData             TFloat              -- ��������
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- �������� - inValueData
     IF inValueData IS NULL
     THEN
         RAISE EXCEPTION '������-1.�� ���������� �������� �������� Id=<%> ParentId=<%> MovementId=<%> InvNumber=<%>.', inMovementItemId
                                                                                                                     , (SELECT MovementItem.ParentId   FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                                                                                                                     , (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                                                                                                                     , (SELECT Movement.InvNumber      FROM Movement     WHERE Movement.Id = (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId));
     END IF;

     -- �������� <��������>
     UPDATE MovementItemFloat SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     -- ���� �� �����
     IF NOT FOUND 
     THEN
        -- �������� <��������>
         INSERT INTO MovementItemFloat (DescId, MovementItemId, ValueData)
                                VALUES (inDescId, inMovementItemId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemFloat_KPU (Integer, Integer, TFloat) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.01.18                                                        *
*/
