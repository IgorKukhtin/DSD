-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, TFloat, Integer);
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
RETURNS Integer
AS
$BODY$
  DECLARE vbOperDate         TDateTime;
  DECLARE vbStatusId          Integer;
  DECLARE vbMovementDescId    Integer;
  DECLARE vbInvNumber         TVarChar;
  DECLARE vbIsErased          Boolean;
BEGIN
     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, ioId, NULL, inUserId);


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
     SELECT StatusId, OperDate, InvNumber, DescId INTO vbStatusId, vbOperDate, vbInvNumber, vbMovementDescId FROM Movement WHERE Id = inMovementId;
     -- �������� - �����������/��������� ��������� �������� ������ + !!!�������� ����������� -12345!!!
     IF vbStatusId <> zc_Enum_Status_UnComplete() AND COALESCE (inUserId, 0) NOT IN (-12345, zc_Enum_Process_Auto_PartionClose()) -- , 5 
        AND inDescId <> zc_MI_Sign() AND inDescId <> zc_MI_Message() -- AND inDescId <> zc_MI_Detail()
        AND (COALESCE (vbMovementDescId, 0) <> zc_Movement_OrderExternal() OR inDescId <> zc_MI_Child())
        AND (COALESCE (vbMovementDescId, 0) <> zc_Movement_ChangePercent() OR inDescId <> zc_MI_Child())
        AND (COALESCE (vbMovementDescId, 0) <> zc_Movement_BankAccount() OR inDescId <> zc_MI_Detail())
        AND (COALESCE (vbMovementDescId, 0) <> zc_Movement_Promo() OR inDescId <> zc_MI_Detail())
        --AND inUserId <> 5
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.(%)', vbInvNumber, lfGet_Object_ValueData (vbStatusId), inMovementId;
     END IF;
     -- �������� - inAmount
     IF inAmount IS NULL
     THEN
         RAISE EXCEPTION '������-1.�� ���������� ����������/����� � ��������� � <%>.(%)(%)(%)', vbInvNumber, inMovementId, inObjectId, inDescId;
     END IF;
     -- �������� - inObjectId
     IF inObjectId IS NULL
     THEN
--         RAISE EXCEPTION '������-1.�� ��������� ������ � ��������� � <%>.', vbInvNumber;
     END IF;


     -- �������� - �������� �.�.
     IF inUserId IN (9031170)
        -- ����������� 7 ���� ��-�� (��������)
        OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  AS UserRole_View WHERE UserRole_View.UserId = inUserId AND UserRole_View.RoleId = 11841068)
     THEN
         PERFORM lpCheckPeriodClose_local (vbOperDate, inMovementId, vbMovementDescId, inUserId);
     END IF;


     IF COALESCE (ioId, 0) = 0
     THEN
         --
         INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
                           VALUES (inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
     ELSE
         --
         UPDATE MovementItem SET ObjectId = inObjectId, Amount = inAmount, ParentId = inParentId/*, MovementId = inMovementId*/ WHERE Id = ioId
         RETURNING isErased INTO vbIsErased;
         --
         IF NOT FOUND THEN
            RAISE EXCEPTION '������.������� <%> � ��������� � <%> �� �������.', ioId, vbInvNumber;
            INSERT INTO MovementItem (Id, DescId, ObjectId, MovementId, Amount, ParentId)
                              VALUES (ioId, inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
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
 11.07.15                                        * add inUserId
 17.05.14                                        * add �������� - inAmount and inObjectId
 05.04.14                                        * add vbIsErased
 31.10.13                                        * add vbInvNumber
 06.10.13                                        * add vbStatusId
 09.08.13                                        * add inObjectId := NULL
 09.08.13                                        * add inObjectId := NULL
 23.07.13                                        * add inParentId := NULL
*/

-- ����
