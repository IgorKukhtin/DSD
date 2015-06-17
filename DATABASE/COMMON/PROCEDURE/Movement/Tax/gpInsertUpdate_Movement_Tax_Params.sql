-- gpInsertUpdate_Movement_Tax_Params()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_Params (
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inDateRegistered      TDateTime , -- ���� �����������
    IN inIsElectron          Boolean   , -- ����������� (��/���)
    IN inInvNumberRegistered TVarChar  , -- ����� ����������� ��������� 
    IN inContractId          Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF (SELECT DescId FROM Movement WHERE Id = ioId) = zc_Movement_Tax() 
     THEN
	vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Tax_IsRegistered());
     ELSE 
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_TaxCorrective_IsRegistered());
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������.';
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Tax_Params(ioId, inInvNumber, inOperDate, inDateRegistered, inIsElectron, inInvNumberRegistered, inContractId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.15         * add inInvNumberRegistered
 24.03.14                                        * add zc_Enum_Process_Update_Movement_Tax_IsRegistered
 09.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Tax_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
