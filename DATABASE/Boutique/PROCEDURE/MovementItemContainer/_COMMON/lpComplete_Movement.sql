-- Function: lpComplete_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement(
    IN inMovementId        Integer  , -- ���� ������� <��������>
    IN inDescId            Integer  , -- 
    IN inUserId            Integer    -- ������������
)                              
  RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbDescId Integer;
   DECLARE vbCloseDate TDateTime;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbStatusId Integer;

   DECLARE vbRoleName TVarChar;
BEGIN
  -- ��������
  /*IF EXISTS (SELECT MovementId FROM MovementItemContainer WHERE MovementId = inMovementId)
  THEN
      RAISE EXCEPTION '������.���������� ��������.���������� ����������.';
  END IF;*/

  -- 0. ��������
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION '������.�������� �� ��������.';
  END IF;

  -- ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  RETURNING OperDate, DescId, AccessKeyId, StatusId INTO vbOperDate, vbDescId, vbAccessKeyId, vbStatusId;


  -- 1.1. ��������
  IF COALESCE (vbDescId, -1) <> COALESCE (inDescId, -2)
  THEN
      RAISE EXCEPTION '������.��� ��������� �� ���������.<%><%>', vbDescId, inDescId;
  END IF;
  -- 1.2. ��������
  /*IF COALESCE (vbStatusId, 0) NOT IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  THEN
      RAISE EXCEPTION '������.��������� � <%> �� <%> ��� ��������.<%><%>', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbStatusId, inMovementId;
  END IF;*/


  -- �� ���� ���-��� !!!��� �������� �������!!!
  /*IF inDescId NOT IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
  THEN

  -- ��� ������  - ��� �����
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN 
  -- �������� ���� ��� <AccessKey>
  IF inDescId = zc_Movement_Sale()
  THEN 
      IF lpGetAccessKey (inUserId, COALESCE ((SELECT MAX (ProcessId) FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Sale(), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())), zc_Enum_Process_InsertUpdate_Movement_Sale()))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- ������� �.�. !!!��������!!!
         AND inUserId <> 12120 -- ��������� �.�. !!!��������!!!
         -- AND inUserId <> 442559 -- ���������� �.�. -- 409618 -- �������� �.�. !!!��������!!!
         -- AND inUserId <> 81707 -- ������ �.�.
         AND inUserId <> 131160 -- ������ �.�. !!!��������!!!
         -- AND inUserId <> 81241 -- ������� �.�. !!!��������!!!
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_ReturnIn()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_ReturnIn())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- ������� �.�. !!!��������!!!
         AND inUserId <> 12120 -- ��������� �.�. !!!��������!!!
         -- AND inUserId <> 442559 -- ���������� �.�. -- 409618 -- �������� �.�. !!!��������!!!
         -- AND inUserId <> 81707 -- ������ �.�.
         AND inUserId <> 131160 -- ������ �.�. !!!��������!!!
         -- AND inUserId <> 81241 -- ������� �.�. !!!��������!!!
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_Tax()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Tax())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 12120 -- ��������� �.�. !!!��������!!!
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� <%> � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_TaxCorrective()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 12120 -- ��������� �.�. !!!��������!!!
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� <%> � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  END IF;
  END IF;
  END IF;
  END IF;
  END IF;


  -- !!!����� ����� �������� - �������� ������!!!
  PERFORM lpCheckPeriodClose (inOperDate      := vbOperDate
                            , inMovementId    := inMovementId
                            , inMovementDescId:= inDescId
                            , inAccessKeyId   := vbAccessKeyId
                            , inUserId        := inUserId
                             );

  END IF; -- �� ���� ���-��� !!!��� �������� �������!!!
*/

  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpComplete_Movement (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.14                                        * add vbAccessKeyId
 20.10.14                                        * add !!!�������� ���� �� ���!!!
 23.09.14                                        * add Object_Role_MovementDesc_View
 25.05.14                                        * add �������� ���� ��� <�������� �������>
 10.05.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement (inMovementId:= 55, inUserId:= 2)
