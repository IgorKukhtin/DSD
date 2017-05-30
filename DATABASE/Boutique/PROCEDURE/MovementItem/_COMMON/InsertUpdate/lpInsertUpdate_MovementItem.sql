-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem(
 INOUT ioId           Integer, 
    IN inDescId       Integer, 
    IN inObjectId     Integer, 
    IN inPartionId    Integer, -- ������
    IN inMovementId   Integer,
    IN inAmount       TFloat,
    IN inParentId     Integer,
    IN inUserId       Integer DEFAULT 0 -- ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbStatusId  Integer;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbIsErased  Boolean;
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

     -- ������ ��������  
     IF inPartionId = 0
     THEN
         inPartionId := NULL;
     END IF;

     -- 0. ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;


     -- ���������� <������>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;
     -- �������� - �����������/��������� ��������� �������� ������ + !!!�������� ����������� -12345!!!
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- �������� - inAmount
     IF inAmount IS NULL
     THEN
         RAISE EXCEPTION '������-1.�� ���������� ����������/����� � ��������� � <%>.', vbInvNumber;
     END IF;
     -- �������� - inObjectId
     IF inObjectId IS NULL
     THEN
--         RAISE EXCEPTION '������-1.�� ��������� ������ � ��������� � <%>.', vbInvNumber;
     END IF;


     IF COALESCE (ioId, 0) = 0
     THEN
         --
         INSERT INTO MovementItem (DescId, ObjectId, PartionId, MovementId, Amount, ParentId)
                           VALUES (inDescId, inObjectId, inPartionId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
     ELSE
         --
         UPDATE MovementItem SET ObjectId = inObjectId, PartionId = inPartionId, Amount = inAmount, ParentId = inParentId/*, MovementId = inMovementId*/ WHERE Id = ioId
         RETURNING isErased INTO vbIsErased;
         --
         IF NOT FOUND THEN
            RAISE EXCEPTION '������.������� <%> � ��������� � <%> �� �������.', ioId, vbInvNumber;
            INSERT INTO MovementItem (Id, DescId, ObjectId, PartionId, MovementId, Amount, ParentId)
                              VALUES (ioId, inDescId, inObjectId, inPartionId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
         END IF;
         --
         IF vbIsErased = TRUE
         THEN
             RAISE EXCEPTION '������.������� �� ����� ���������������� �.�. �� <������>.';
         END IF;
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.04.17         * add PartionId
*/

-- ����
