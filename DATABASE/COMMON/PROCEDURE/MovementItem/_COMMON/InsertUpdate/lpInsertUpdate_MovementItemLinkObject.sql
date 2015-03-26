-- Function: lpInsertUpdate_MovementItemLinkObject

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemLinkObject (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemLinkObject(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inMovementItemId        Integer           , -- ���� 
    IN inObjectId              Integer             -- ���� �������
)
RETURNS Boolean
AS
$BODY$
BEGIN
    IF inObjectId = 0
    THEN
        inObjectId := NULL;
    END IF;

    -- �������� <��������>
    UPDATE MovementItemLinkObject SET ObjectId = inObjectId WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

    -- ���� �� �����
    IF NOT FOUND AND inObjectId IS NOT NULL
    THEN
        -- �������� <��������>
        INSERT INTO MovementItemLinkObject (DescId, MovementItemId, ObjectId)
                                    VALUES (inDescId, inMovementItemId, inObjectId);
    END IF;             

    RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemLinkObject (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.15                                        * IF ... AND inObjectId IS NOT NULL
*/

-- ����
