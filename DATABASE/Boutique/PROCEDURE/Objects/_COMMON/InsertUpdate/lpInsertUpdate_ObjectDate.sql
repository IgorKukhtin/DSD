-- Function: lpinsertupdate_objectDate()

-- DROP FUNCTION lpinsertupdate_objectDate();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectDate(
 inDescId                    Integer           ,  /* ��� ������ ��������  */
 inObjectId                  Integer           ,  /* ���� �������         */
 inValueData                 TDateTime            /* ������ ��������      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* �������� ������ �� �������� <���� ��������> � <���� �������> */
    UPDATE ObjectDate SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������> � <������> */
       INSERT INTO ObjectDate (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectDate(Integer, Integer, TDateTime)  OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.13          * 

*/