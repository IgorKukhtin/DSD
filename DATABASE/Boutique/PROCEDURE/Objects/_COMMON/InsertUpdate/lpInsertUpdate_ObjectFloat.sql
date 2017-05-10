-- Function: lpinsertupdate_objectFloat()

DROP FUNCTION IF EXISTS lpinsertupdate_objectFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectFloat(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inObjectId              Integer           , -- ���� 
    IN inValueData             TFloat              -- ��������
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- �������� <��������>
    UPDATE ObjectFloat SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;

     -- ���� �� ����� + ��������� 0 �� ���������
     IF NOT FOUND AND inValueData <> 0
     THEN
        -- �������� <��������>
        INSERT INTO ObjectFloat (DescId, ObjectId, ValueData)
                         VALUES (inDescId, inObjectId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectFloat (Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.17                                        * IF ... AND inValueData <> 0
*/
