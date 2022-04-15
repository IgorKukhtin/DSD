-- Function: gpInsertUpdate_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, tvarchar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, tvarchar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, integer, tvarchar, tvarchar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inParentId            Integer   , -- ��������� ���������
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartnerId           Integer   , -- ����������
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inBranchId            Integer   , -- ������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PriceCorrective());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_PriceCorrective
                                       (ioId               := ioId
                                      , inParentId         := inParentId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inPriceWithVAT     := inPriceWithVAT
                                      , inVATPercent       := inVATPercent
                                      , inInvNumberPartner := inInvNumberPartner
                                      , inInvNumberMark    := inInvNumberMark
                                      , inFromId           := inFromId
                                      , inToId             := inToId
                                      , inPartnerId        := inPartnerId
                                      , inPaidKindId       := inPaidKindId
                                      , inContractId       := inContractId   
                                      , inBranchId         := inBranchId
                                      , inUserId           := vbUserId
                                       );
     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.04.22         * inBranchId
 02.02.18         *
 17.06.14         * add inInvNumberPartner 
                      , inInvNumberMark  
 29.05.14         *
 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PriceCorrective (ioId:= 0, inParentId:=0 , inInvNumber:= '-1', inOperDate:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2,  inPartnerId:= 0, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
