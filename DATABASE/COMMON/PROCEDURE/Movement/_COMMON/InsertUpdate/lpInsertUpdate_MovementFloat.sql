-- Function: lpInsertUpdate_MovementItemFloat

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inMovementId            Integer           , -- ���� 
    IN inValueData             TFloat             -- ��������
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- �������� <��������>
     UPDATE MovementFloat SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;

     -- ���� �� �����
     IF NOT FOUND AND inValueData <> 0
     THEN
        -- �������� <��������>
        INSERT INTO MovementFloat (DescId, MovementId, ValueData)
                           VALUES (inDescId, inMovementId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat (Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.15                                        * IF ... AND inValueData <> 0
*/
