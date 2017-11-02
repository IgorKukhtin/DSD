-- Function: lpInsertUpdate_MovementItemFloat_byDesc

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemFloat_byDesc (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat_byDesc(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inMovementItemId        Integer           , -- ���� 
    IN inValueData             TFloat              -- ��������
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- ������ ��� �������������� inDescId
     IF inDescId > 0
     THEN
         RETURN lpInsertUpdate_MovementItemFloat (inDescId        := inDescId
                                                , inMovementItemId:= inMovementItemId
                                                , inValueData     := inValueData
                                                 );
     ELSE
         RETURN FALSE;
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemFloat_byDesc (Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.10.17                                        *
*/
