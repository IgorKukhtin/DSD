-- Function: lpInsertUpdate_MovementLinkMovement()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementLinkMovement (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementLinkMovement(
    IN inDescId                Integer           ,  -- ��� ������ ��������
    IN inMovementId            Integer           ,  -- ���� �������� ���������
    IN inMovementChildId       Integer              -- ���� ������������ ���������
)
  RETURNS Boolean AS
$BODY$
BEGIN
    IF inMovementChildId = 0 THEN
       inMovementChildId := NULL;
    END IF;

    -- �������� - ���� ������ � �������, �� ��� ������ ���� ������������
    IF inMovementId = inMovementChildId
    THEN
        RAISE EXCEPTION '������.�������� � <%> �� <%> �� ����� ���� ������ ��� � �����.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
    END IF;

    -- �������� ������ �� �������� <���� �������>
    UPDATE MovementLinkMovement SET MovementChildId = inMovementChildId WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT FOUND THEN            
       -- �������� <���� ��������> , <���� �������� �������> � <���� ������������ �������>
       INSERT INTO MovementLinkMovement (DescId, MovementId, MovementChildId)
                                 VALUES (inDescId, inMovementId, inMovementChildId);
    END IF;             
    RETURN TRUE;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementLinkMovement (Integer, Integer, Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 16.03.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementLinkMovement (inDescId:= zc_MovementLinkMovement_Child(), inMovementId:= 1, inMovementChildId:= 2)
