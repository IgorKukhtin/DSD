-- Function: gpUpdate_Movement_WeighingPartnerEdit()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartnerEdit (Integer, TDateTime, Boolean, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartnerEdit (Integer, TDateTime, Boolean, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartnerEdit(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inOperDate             TDateTime , -- ���� ���������
    IN inPriceWithVAT         Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent           TFloat    , -- % ���
    IN inChangePercent        TFloat    , -- (-)% ������ (+)% �������
    IN inInvNumberOrder       TVarChar  , -- ����� ������ � ����������� 
    IN inMovementDescId       Integer   , -- ��� ���������
    IN inMovementDescNumber   Integer   , -- ��� �������� (�����������)
    IN inWeighingNumber       Integer   , -- ����� �����������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inContractId           Integer   , -- ��������
    IN inPaidKindId           Integer   , -- ����� ������
    IN inMovementId_Order     Integer   , -- ���� ��������� ������
    IN inMovementId_Transport Integer   , -- �������� ������� ����
    IN inParentId             Integer   , -- ������� �������� 
    IN inMemberId             Integer   , -- ��������/����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbParentId  Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbStartWeighing TDateTime;
   DECLARE vbPriceWithVAT  Boolean;
   DECLARE vbVATPercent    TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingPartner());
     --vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());

     SELECT InvNumber INTO vbInvNumber FROM Movement WHERE Id = inId;

     -- ��������� <��������>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, inParentId, vbAccessKeyId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);


     -- ��������� �������� <��� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), inId, inMovementDescId);
     -- ��������� �������� <��� �������� (�����������)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), inId, inMovementDescNumber);

     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);

     -- ��������� �������� <����� ������ � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), inId, inInvNumberOrder);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);

     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inId, inContractId);
     -- ��������� ����� � <����� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), inId, inPaidKindId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), inId, inMemberId);


     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- ��������� ����� � ���������� <Transport>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), inId, inMovementId_Transport);

     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);


     -- �������� zc_MovementFloat_GPSN + zc_MovementFloat_GPSE
     vbParentId:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inId);
     IF vbParentId > 0
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSN(), inId, COALESCE ((SELECT EXTRACT (DAY FROM Movement.OperDate) :: TFloat FROM Movement WHERE Movement.Id = vbParentId), 0));
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSE(), inId, COALESCE ((SELECT EXTRACT (DAY FROM MovementDate.ValueData) :: TFloat FROM MovementDate WHERE MovementDate.MovementId = vbParentId AND MovementDate.DescId = zc_MovementDate_OperDatePartner()), 0));
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 15.03.17         * add Member
 18.11.16         *
*/

-- ����
-- select * from gpUpdate_Movement_WeighingPartnerEdit(inId := 4316459 , inOperDate := ('31.08.2016')::TDateTime , inPriceWithVAT := '' , inVATPercent := 20 , inChangePercent := 0 , inInvNumberOrder := '***261779' , inMovementDescId := 0 , inMovementDescNumber := 16 , inWeighingNumber := 2 , inFromId := 133049 , inToId := 309292 , inContractId := 540132 , inPaidKindId := 3 , inMovementId_Order := 4314361 , inMovementId_Transport := 4297350 , inParentId := 4316461 ,  inSession := '5');
