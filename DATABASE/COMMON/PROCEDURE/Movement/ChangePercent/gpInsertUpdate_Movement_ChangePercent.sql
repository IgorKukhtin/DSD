-- Function: gpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangePercent (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangePercent (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


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
    IN inDocumentTaxKindId   Integer   , 
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbToId Integer;
   DECLARE vbContractId Integer;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangePercent());

     --�������� ������� ������ ��� ���������
     SELECT MovementLinkObject_Contract.ObjectId AS ContractId
          , MovementLinkObject_To.ObjectId       AS ToId
     INTO vbContractId, vbToId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
     WHERE Movement.Id = COALESCE (ioId,0);
     
     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_ChangePercent (ioId                := ioId
                                                 , inInvNumber         := inInvNumber
                                                 , inInvNumberPartner  := inInvNumberPartner
                                                 , inOperDate          := inOperDate
                                                 , inChecked           := inChecked
                                                 , inPriceWithVAT      := inPriceWithVAT
                                                 , inVATPercent        := inVATPercent
                                                 , inChangePercent     := inChangePercent
                                                 , inFromId            := inFromId
                                                 , inToId              := inToId
                                                 , inPaidKindId        := inPaidKindId
                                                 , inContractId        := inContractId
                                                 , inPartnerId         := inPartnerId
                                                 , inDocumentTaxKindId := inDocumentTaxKindId
                                                 , inComment           := inComment
                                                 , inUserId            := vbUserId
                                                  ) AS tmp;

     --��������, ���� ����� �������� ��� �������� �������/��.���� �������������� ������
     IF COALESCE(vbToId,0) <> inToId OR COALESCE (vbContractId,0) <> inContractId
     THEN
         --
         PERFORM lpInsertUpdate_MI_ChangePercent_byTax (ioId, vbUserId);
     END IF;

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