-- Function: lpinsertupdate_objectBoolean()

-- DROP FUNCTION lpinsertupdate_objectBoolean();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectBoolean(
 inDescId                    Integer           ,  /* ��� ������ ��������  */
 inObjectId                  Integer           ,  /* ���� �������         */
 inValueData                 Boolean              /* ������ ��������      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* �������� ������ �� �������� <���� ��������> � <���� �������> */
    UPDATE ObjectBoolean SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������> � <������> */
       INSERT INTO ObjectBoolean (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectBoolean(Integer, Integer, Boolean)
  OWNER TO postgres;
