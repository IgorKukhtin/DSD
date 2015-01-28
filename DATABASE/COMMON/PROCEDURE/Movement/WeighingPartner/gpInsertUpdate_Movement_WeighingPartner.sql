-- Function: gpInsertUpdate_Movement_WeighingPartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, Integer, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingPartner(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inInvNumberOrder      TVarChar  , -- ����� ������ �����������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inWeighingNumber      Integer   , -- ����� �����������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inContractId          Integer   , -- ��������
    IN inPaidKindId          Integer   , -- ����� ������
    IN inMovementId_Order    Integer   , -- ���� ��������� ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber TVarChar;
   DECLARE vbParentId Integer;
   DECLARE vbStartWeighing TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ���� �������
     -- vbAccessKeyId:= ...;

     IF COALESCE (ioId, 0) = 0
     THEN
         vbInvNumber:= CAST (NEXTVAL ('Movement_WeighingPartner_seq') AS TVarChar);
         vbParentId:= NULL;
         vbStartWeighing:= CURRENT_TIMESTAMP;
     ELSE
         SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = ioId;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <�������� ������ �����������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, vbStartWeighing);
     END IF;
     
     -- ��������� �������� <��� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDescId);
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

     -- ��������� ����� � <������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, vbUserId);

     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inMovementId_Order);

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
 27.01.15                                        * all
 11.10.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_WeighingPartner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
