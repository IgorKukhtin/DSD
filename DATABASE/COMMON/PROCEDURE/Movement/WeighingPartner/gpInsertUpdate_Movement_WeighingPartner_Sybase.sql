-- Function: gpInsertUpdate_Movement_WeighingPartner_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner_Sybase (Integer, Integer, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner_Sybase (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingPartner_Sybase(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- �������� ��������
    IN inInvNumber           TVarChar  , -- �����
    IN inOperDate            TDateTime , -- ���� ���������

    IN inStartWeighing       TDateTime , -- �������� ������ �����������
    IN inEndWeighing         TDateTime , -- �������� ��������� �����������

    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������

    IN inMovementDescId      TFloat    , -- ��� ���������
    IN inInvNumberTransport  TFloat    , -- ����� �������� �����
    IN inWeighingNumber      TFloat    , -- ����� �����������

    IN inInvNumberOrder      TVarChar  , -- ����� ������ � ����������� 
    IN inPartionGoods        TVarChar  , -- ������ ������

    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inContractId          Integer   , -- ��������
    IN inPaidKindId          Integer   , -- ����� ������
    IN inRouteSortingId      Integer   , -- ���������� ���������
    IN inUserId              Integer   , -- ������������

    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingPartner());

     -- ���������� ���� �������
     -- vbAccessKeyId:= ...;

     -- ������ ��������
     IF COALESCE (inWeighingNumber, 0) = 0 THEN inWeighingNumber:= 1; END IF;

     -- ���������� 
     IF inParentId < 0
     THEN
         vbInvNumber:= -1 * inParentId;
         inParentId:= 0;
     ELSE
         IF COALESCE (ioId, 0) = 0
         THEN
             vbInvNumber:= inInvNumber; -- CAST (NEXTVAL ('Movement_WeighingPartner_seq') AS TVarChar);
         ELSE
             vbInvNumber:= inInvNumber; -- (SELECT InvNumber FROM Movement WHERE Id = ioId);
         END IF;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, inParentId, vbAccessKeyId);

     -- ��������� �������� <�������� ������ ������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, inStartWeighing);
     -- ��������� �������� <�������� ��������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), ioId, inEndWeighing);
     
     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ��������� �������� <��� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDescId);
     -- ��������� �������� <����� �������� �����>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_InvNumberTransport(), ioId, inInvNumberTransport);
     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), ioId, inWeighingNumber);

     -- ��������� �������� <����� ������ � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <����� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     -- ��������� ����� � <���������� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);
     -- ��������� ����� � <������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, inUserId);


     -- ����������� �������� ����� �� ���������
     -- PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.10.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_WeighingPartner_Sybase (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
