-- Function: gpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangePercent (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ChangePercent(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����� (������)>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inContractId          Integer   , -- ������� 
    IN inPaidKindId          Integer   , -- ���� ���� ������ 
    IN inPartnerId           Integer   , -- ����������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangePercent());

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_ChangePercent (ioId    := ioId
                                                  , inInvNumber        := inInvNumber
                                                  , inInvNumberPartner := inInvNumberPartner
                                                  , inOperDate         := inOperDate
                                                  , inChecked          := inChecked
                                                  , inPriceWithVAT     := inPriceWithVAT
                                                  , inVATPercent       := inVATPercent
                                                  , inChangePercent    := inChangePercent
                                                  , inFromId           := inFromId
                                                  , inToId             := inToId
                                                  , inPaidKindId       := inPaidKindId
                                                  , inContractId       := inContractId
                                                  , inPartnerId        := inPartnerId
                                                  , inUserId           := vbUserId
                                                   ) AS tmp;

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.23         *
*/

-- ����
--