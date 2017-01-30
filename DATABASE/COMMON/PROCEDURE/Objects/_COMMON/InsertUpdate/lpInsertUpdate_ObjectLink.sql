-- Function: lpInsertUpdate_ObjectLink()

-- DROP FUNCTION lpInsertUpdate_ObjectLink();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectLink(
 inDescId                    Integer           ,  /* ��� ������ ��������       */
 inObjectId                  Integer           ,  /* ���� �������� �������     */
 inChildObjectId             Integer              /* ���� ������������ ������� */
)
  RETURNS boolean AS
$BODY$BEGIN
    IF inChildObjectId = 0 THEN
       inChildObjectId := NULL;
    END IF;

    /* �������� ������ �� �������� <���� ��������> � <���� �������> */
    UPDATE ObjectLink SET ChildObjectId = inChildObjectId WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������� �������> � <���� ������������ �������> */
       INSERT INTO ObjectLink (DescId, ObjectId, ChildObjectId)
           VALUES (inDescId, inObjectId, inChildObjectId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectLink(Integer, Integer, Integer)
  OWNER TO postgres;
