-- gpInsertUpdate_Movement_TaxCorrective_Params()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_Params (
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inDateRegistered      TDateTime , -- ���� �����������
    IN inRegistered          Boolean   , -- ���������������� (��/���)
    IN inContractId          Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective_Params());

     -- �������� - �����������/��������� �������� �� ����� ����������������
     IF ioId <> 0 AND NOT EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND StatusId = zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION '������.�������� �� ����� ���������������� �.�. �� <%>.', lfGet_Object_ValueData ((SELECT StatusId FROM Movement WHERE Id = ioId));
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ���������� �������.';
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_TaxCorrective_Params(ioId, inInvNumber, inOperDate, inDateRegistered, inRegistered, inContractId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.03.14                                        * add zc_Enum_Process_InsertUpdate_Movement_TaxCorrective_Params
 11.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
