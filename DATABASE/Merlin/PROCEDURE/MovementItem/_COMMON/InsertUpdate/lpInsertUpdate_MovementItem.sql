-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, Integer, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem(
 INOUT ioId           Integer, 
    IN inDescId       Integer, 
    IN inObjectId     Integer, 
    IN inMovementId   Integer,
    IN inAmount       TFloat,
    IN inParentId     Integer,
    IN inUserId       Integer DEFAULT 0 -- ������������
)
  RETURNS Integer AS
$BODY$
  DECLARE vbStatusId        Integer;
  DECLARE vbInvNumber       TVarChar;
  DECLARE vbIsErased        Boolean;
  DECLARE vbMovementId      Integer;
  DECLARE vbMovementDescId  Integer;
  DECLARE vbDescId          Integer;
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

     -- 0. ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;


     -- ���������� <������>
     SELECT StatusId, InvNumber, DescId INTO vbStatusId, vbInvNumber, vbMovementDescId FROM Movement WHERE Id = inMovementId;

     -- �������� - �����������/��������� ��������� �������� ������ + !!!�������� ��� SYBASE -1 * zc_User_Sybase() !!!
     IF vbStatusId <> zc_Enum_Status_UnComplete()  AND (vbMovementDescId <> zc_Movement_Cash() OR inDescId <> zc_MI_Child())
        AND inDescId <> zc_MI_Sign()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData_sh (vbStatusId);
     END IF;

     -- �������� - inAmount
     IF inAmount IS NULL AND inDescId = zc_MI_Master()
     THEN
         RAISE EXCEPTION '������-1.�� ���������� ���������� � ��������� � <%>.', vbInvNumber;
     ELSEIF inAmount IS NULL AND inDescId <> zc_MI_Master()
     THEN
         RAISE EXCEPTION '������-1.�� ���������� ����� � ��������� � <%>.', vbInvNumber;
     END IF;

     -- �������� - inObjectId
     IF inObjectId IS NULL AND inDescId = zc_MI_Master()
     THEN
         RAISE EXCEPTION '������-1.�� ��������� ������� � ��������� � <%>.', vbInvNumber;
     END IF;

     IF COALESCE (ioId, 0) = 0
     THEN
         --
         INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
                           VALUES (inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;

     ELSE
         --
         UPDATE MovementItem SET ObjectId   = inObjectId
                               , Amount     = inAmount
                               , ParentId   = inParentId
                                 -- !!!�������� ��� Sybase!!!
                               , MovementId = inMovementId
                            -- , DescId     = inDescId
         WHERE Id = ioId
         RETURNING isErased, MovementId, DescId INTO vbIsErased, vbMovementId, vbDescId
        ;

         -- ���� ����� ������� �� ��� ������
         IF NOT FOUND THEN
            -- ������
            RAISE EXCEPTION '������.������� <%> � ��������� � <%> �� ������.', ioId, vbInvNumber;
            --
            INSERT INTO MovementItem (Id, DescId, ObjectId, MovementId, Amount, ParentId)
                              VALUES (ioId, inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;

         END IF;
 
         -- ��������
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
 09.01.22         *
*/

-- ����
