-- Function: lpInsertUpdate_MovementItemFloat

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat(
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
     IF NOT FOUND AND inValueData <> 0
     THEN
        -- �������� <��������>
         INSERT INTO MovementItemFloat (DescId, MovementItemId, ValueData)
                                VALUES (inDescId, inMovementItemId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemFloat (Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.15                                        * IF ... AND inValueData <> 0
 17.05.14                                        * add �������� - inValueData
*/
