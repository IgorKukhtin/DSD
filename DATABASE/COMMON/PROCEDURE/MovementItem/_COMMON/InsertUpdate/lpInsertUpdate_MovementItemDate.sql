CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemDate(
 inDescId                    Integer           ,  /* ��� ������ ��������       */
 inMovementItemId            Integer           ,  /* ���� �������� �������     */
 inValueData                 TDateTime            /* �������� */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementItemDate SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;
    IF NOT found THEN            
       /* �������� <���� ��������> , <���� �������� �������> � <���� ������������ �������> */
       INSERT INTO MovementItemDate (DescId, MovementItemId, ValueData)
           VALUES (inDescId, inMovementItemId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemDate(Integer, Integer, TDateTime)
  OWNER TO postgres;

