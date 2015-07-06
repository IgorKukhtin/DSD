-- Function: lpSetErased_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement(
    IN inMovementId        Integer  , -- ���� ������� <��������>
    IN inUserId            Integer    -- ������������
)                              
  RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbDescId Integer;
  DECLARE vbAccessKeyId Integer;
BEGIN

  -- 0. ��������
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION '������.�������� �� ��������.';
  END IF;

  -- 1. �������� �� "�������������" / "��������"
  PERFORM lpCheck_Movement_Status (inMovementId, inUserId);

  -- 2. ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId
  RETURNING OperDate, DescId, AccessKeyId INTO vbOperDate, vbDescId, vbAccessKeyId;


  -- ��� ������  - ��� �����
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN 
  -- �������� ���� ��� <AccessKey>
  IF vbDescId = zc_Movement_Sale()
  THEN 
      IF lpGetAccessKey (inUserId, COALESCE ((SELECT MAX (ProcessId) FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Sale(), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())), zc_Enum_Process_InsertUpdate_Movement_Sale()))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- ������� �.�. !!!��������!!!
         AND inUserId <> 442559 -- ���������� �.�. -- 409618 -- �������� �.�. !!!��������!!!
         AND inUserId <> 81707 -- ������ �.�.
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� �������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF vbDescId = zc_Movement_ReturnIn()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_ReturnIn())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- ������� �.�. !!!��������!!!
         AND inUserId <> 442559 -- ���������� �.�. -- 409618 -- �������� �.�. !!!��������!!!
         AND inUserId <> 81707 -- ������ �.�.
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� �������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF vbDescId = zc_Movement_Tax()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Tax())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� �������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF vbDescId = zc_Movement_TaxCorrective()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� �������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  END IF;
  END IF;
  END IF;
  END IF;

  ELSE 
      -- !!!��� ������!!!
      -- 1. �������� �� "�������������" / "��������"
      PERFORM lpCheck_Movement_Status (inMovementId, inUserId);
  END IF;


  -- 3.1. ������� ��� ��������
  PERFORM lpDelete_MovementItemContainer (inMovementId);
  -- 3.2. ������� ��� �������� ��� ������
  PERFORM lpDelete_MovementItemReport (inMovementId);

  -- 4. ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetErased_Movement (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.14                                        * add vbAccessKeyId
 05.09.14                                        * add lpCheck_Movement_Status
 25.05.14                                        * add �������� ���� ��� <�������� �������>
 10.05.14                                        * add �������� <���������������>
 10.05.14                                        * add lpInsert_MovementProtocol
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- ����
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
