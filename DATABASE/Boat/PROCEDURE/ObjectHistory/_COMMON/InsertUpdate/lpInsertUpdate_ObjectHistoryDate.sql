-- Function: lpInsertUpdate_ObjectHistoryDate()

-- DROP FUNCTION lpInsertUpdate_ObjectHistoryDate();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistoryDate(
 inDescId                    Integer           ,  /* ��� ������ ��������  */
 inObjectHistoryId           Integer           ,  /* ���� �������         */
 inValueData                 TDateTime            /* ������ ��������      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* �������� ������ �� �������� <���� ��������> � <���� �������> */
    UPDATE ObjectHistoryDate SET ValueData = inValueData WHERE ObjectHistoryId = inObjectHistoryId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������> � <������> */
       INSERT INTO ObjectHistoryDate (DescId, ObjectHistoryId, ValueData)
           VALUES (inDescId, inObjectHistoryId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$ 
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.03.17         *
*/