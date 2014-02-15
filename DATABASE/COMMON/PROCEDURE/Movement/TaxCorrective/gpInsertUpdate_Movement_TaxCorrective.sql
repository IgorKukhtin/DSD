-- Function: gpInsertUpdate_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ���������� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
    IN inDocument            Boolean   , -- ���� �� ����������� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inContractId          Integer   , -- ��������
    IN inDocumentTaxKindId   Integer   , -- ��� ������������ ���������� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());
     vbUserId:= 5;

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

     ioId := lpInsertUpdate_Movement_TaxCorrective(ioId, inInvNumber, inInvNumberPartner, inOperDate,
                                         inChecked, inDocument, inPriceWithVAT, inVATPercent,
                                         inFromId, inToId, inContractId, inDocumentTaxKindId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.14                                                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKindId:= 0, inSession:= '2')