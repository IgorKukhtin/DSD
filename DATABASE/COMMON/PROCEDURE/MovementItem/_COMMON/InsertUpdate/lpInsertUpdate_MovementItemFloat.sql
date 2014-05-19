-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat(
    IN inDescId          Integer ,
    IN inMovementItemId  Integer ,
    IN inValueData       TFloat  
)
  RETURNS BOOLEAN AS
$BODY$
BEGIN
     -- �������� - inValueData
     IF inValueData IS NULL
     THEN
         RAISE EXCEPTION '������-1.�� ���������� �������� ��������.';
     END IF;

     --
     UPDATE MovementItemFloat SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     --
     IF NOT FOUND
     THEN
         -- �������� <���� ��������> , <���� ������> � <��������>
         INSERT INTO MovementItemFloat (DescId, MovementItemId, ValueData)
                                VALUES (inDescId, inMovementItemId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemFloat(Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.05.14                                        * add �������� - inValueData
*/
