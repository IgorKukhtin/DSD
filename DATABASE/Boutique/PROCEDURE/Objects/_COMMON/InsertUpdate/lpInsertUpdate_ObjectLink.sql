-- Function: lpInsertUpdate_ObjectLink

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectLink (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectLink(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inObjectId              Integer           , -- ���� �������� �������
    IN inChildObjectId         Integer             -- ���� ������������ �������
)
RETURNS Boolean

AS
$BODY$
BEGIN
    -- ��������
    IF inChildObjectId = 0
    THEN
        inChildObjectId := NULL;
    END IF;


    -- �������� <��������>
    UPDATE ObjectLink SET ChildObjectId = inChildObjectId WHERE ObjectId = inObjectId AND DescId = inDescId;

    -- ���� �� ����� + ��������� NULL �� ���������
    IF NOT FOUND AND inChildObjectId IS NOT NULL
    THEN
        -- �������� <��������>
        INSERT INTO ObjectLink (DescId, ObjectId, ChildObjectId)
                        VALUES (inDescId, inObjectId, inChildObjectId);
    END IF;             

    RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectLink (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.15                                        * IF ... AND inChildObjectId IS NOT NULL
*/
