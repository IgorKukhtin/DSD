-- Function: lpInsertUpdate_MovementItemLinkObject

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementLinkObject (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementLinkObject(
    IN inDescId                Integer           , -- ��� ������ ��������
    IN inMovementId            Integer           , -- ���� 
    IN inObjectId              Integer             -- ���� �������
)
RETURNS Boolean
AS
$BODY$
BEGIN
    -- �������� ��������
    IF inObjectId = 0
    THEN
        inObjectId := NULL;
    END IF;

    -- �������� <��������>
    UPDATE MovementLinkObject SET ObjectId = inObjectId WHERE MovementId = inMovementId AND DescId = inDescId;

    -- ���� �� �����
    IF NOT FOUND AND inObjectId IS NOT NULL
    THEN
        -- �������� <��������>
        INSERT INTO MovementLinkObject (DescId, MovementId, ObjectId)
                                VALUES (inDescId, inMovementId, inObjectId);
    END IF;
  
    RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementLinkObject (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.15                                        * IF ... AND inObjectId IS NOT NULL
*/

-- ����
