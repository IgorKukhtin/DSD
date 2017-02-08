-- Function: lpinsertupdate_objectBLOB()

-- DROP FUNCTION lpinsertupdate_objectBLOB();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectBLOB(
 inDescId                    Integer           ,  /* ��� ������ ��������  */
 inObjectId                  Integer           ,  /* ���� �������         */
 inValueData                 TBLOB             /* ������ ��������      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* �������� ������ �� �������� <���� ��������> � <���� �������> */
    UPDATE ObjectBLOB SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������> � <������> */
       INSERT INTO ObjectBLOB (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectBLOB(Integer, Integer, TBLOB)
  OWNER TO postgres;
