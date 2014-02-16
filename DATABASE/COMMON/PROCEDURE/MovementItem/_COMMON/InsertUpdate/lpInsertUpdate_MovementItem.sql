-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem(
 INOUT ioId Integer, 
    IN inDescId Integer, 
    IN inObjectId Integer, 
    IN inMovementId Integer,
    IN inAmount TFloat,
    IN inParentId Integer
)
  RETURNS Integer AS
$BODY$
  DECLARE vbStatusId Integer;
  DECLARE vbInvNumber TVarChar;
BEGIN
     -- ������ ��������
     IF inParentId = 0
     THEN
         inParentId := NULL;
     END IF;

     -- ������ ��������
     IF inObjectId = 0
     THEN
         inObjectId := NULL;
     END IF;


     -- ���������� <������>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;
     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


     IF COALESCE (ioId, 0) = 0
     THEN
         --
         INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
                           VALUES (inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
     ELSE
         --
         UPDATE MovementItem SET ObjectId = inObjectId, Amount = inAmount, ParentId = inParentId WHERE Id = ioId;
         --
         IF NOT FOUND THEN
            INSERT INTO MovementItem (Id, DescId, ObjectId, MovementId, Amount, ParentId)
                              VALUES (ioId, inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
         END IF;
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, TFloat, Integer) OWNER TO postgres; 


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.10.13                                        * add vbInvNumber
 06.10.13                                        * add vbStatusId
 09.08.13                                        * add inObjectId := NULL
 09.08.13                                        * add inObjectId := NULL
 23.07.13                                        * add inParentId := NULL
*/

-- ����
