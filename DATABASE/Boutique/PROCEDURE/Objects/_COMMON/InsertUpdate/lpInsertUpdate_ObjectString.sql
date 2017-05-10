-- Function: lpInsertUpdate_MovementString

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectString (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectString(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inObjectId              Integer           , -- ���� 
    IN inValueData             TVarChar            -- ��������
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- �������� <��������>
     UPDATE ObjectString SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    
     -- ���� �� ����� + ��������� ����� �� ���������
     IF NOT FOUND AND inValueData <> ''
     THEN
        -- �������� <��������>
        INSERT INTO ObjectString (DescId, ObjectId, ValueData)
                          VALUES (inDescId, inObjectId, inValueData);
     END IF;

     RETURN (TRUE);
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectString (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.17                                        * IF ... AND inValueData <> ''
*/
