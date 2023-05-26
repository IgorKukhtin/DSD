-- Function: lpInsertUpdate_MovementItemDate

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemDate (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemDate(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inMovementItemId        Integer           , -- ���� 
    IN inValueData             TDateTime           -- ��������
))
RETURNS Boolean
AS
$BODY$
BEGIN

     -- �������� <��������>
     UPDATE MovementItemDate SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     -- ���� �� �����
     IF NOT FOUND
     THEN
         -- �������� <��������>
        INSERT INTO MovementItemDate (DescId, MovementItemId, ValueData)
            VALUES (inDescId, inMovementItemId, inValueData);
     END IF;             

     RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.15                                        * IF ... AND inValueData <> 0
 17.05.14                                        * add �������� - inValueData
*/
