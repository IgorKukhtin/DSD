CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementLinkObject(
 inDescId                Integer           ,  /* ��� ������ ��������       */
 inMovementId            Integer           ,  /* ���� �������� �������     */
 inObjectId              Integer              /* ���� ������������ ������� */
)
  RETURNS boolean AS
$BODY$BEGIN
    IF inObjectId = 0 THEN
       inObjectId := NULL;
    END IF;

    /* �������� ������ �� �������� <���� �������> */
    UPDATE MovementLinkObject SET ObjectId = inObjectId WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������� �������> � <���� ������������ �������> */
       INSERT INTO MovementLinkObject (DescId, MovementId, ObjectId)
           VALUES (inDescId, inMovementId, inObjectId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementLinkObject(Integer, Integer, Integer)
  OWNER TO postgres;
