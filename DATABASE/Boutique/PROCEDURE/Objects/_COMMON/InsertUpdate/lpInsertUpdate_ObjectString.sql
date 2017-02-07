-- Function: lpinsertupdate_objectstring()

-- DROP FUNCTION lpinsertupdate_objectstring();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectString(
 inDescId                    Integer           ,  /* ��� ������ ��������  */
 inObjectId                  Integer           ,  /* ���� �������         */
 inValueData                 TVarChar             /* ������ ��������      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* �������� ������ �� �������� <���� ��������> � <���� �������> */
    UPDATE ObjectString SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������> � <������> */
       INSERT INTO ObjectString (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectString(Integer, Integer, TVarChar)
  OWNER TO postgres;
