-- Function: gpUpdate_Movement_WeighingPartnerEdit()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartnerEdit (Integer, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartnerEdit(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inOperDate             TDateTime , -- ���� ���������

    IN inStartWeighing        TDateTime , -- �������� ������ �����������
    IN inEndWeighing          TDateTime , -- �������� ��������� �����������

    IN inPriceWithVAT         Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent           TFloat    , -- % ���
    IN inChangePercent        TFloat    , -- (-)% ������ (+)% �������

    IN inInvNumberOrder      TVarChar  , -- ����� ������ � ����������� 
    IN inPartionGoods        TVarChar  , -- ������ ������
  --  IN inMovementDescId       Integer   , -- ��� ���������
  --  IN inMovementDescNumber   Integer   , -- ��� �������� (�����������)
    IN inWeighingNumber       Integer   , -- ����� �����������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inContractId           Integer   , -- ��������
    IN inPaidKindId           Integer   , -- ����� ������
    IN inMovementId_Order     Integer   , -- ���� ��������� ������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber TVarChar;
   DECLARE vbParentId Integer;
   DECLARE vbStartWeighing TDateTime;
   DECLARE vbPriceWithVAT  Boolean;
   DECLARE vbVATPercent    TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());

     SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = inId;

     -- ��������� <��������>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     -- ��������� �������� <�������� ������ ������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), inId, inStartWeighing);
     -- ��������� �������� <�������� ��������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inId, inEndWeighing);
     
     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);


/*
     -- ��������� �������� <��� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), inId, inMovementDescId);
     -- ��������� �������� <��� �������� (�����������)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), inId, inMovementDescNumber);
*/
     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);

     -- ��������� �������� <����� ������ � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), inId, inInvNumberOrder);
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), inId, inPartionGoods);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);

     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inId, inContractId);
     -- ��������� ����� � <����� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), inId, inPaidKindId);

     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- ��������� ����� � ���������� <Transport>
     --PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), inId, inMovementId_Transport);

     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.11.16         *
*/

-- ����
--