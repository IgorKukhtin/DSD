-- Function: gpInsertUpdate_Movement_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingProduction(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� �������� (�����������)
    IN inWeighingNumber      Integer   , -- ����� �����������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inDocumentKindId      Integer   , -- ��� ���������
    IN inSubjectDocId        Integer   , --
    IN inPersonalGroupId     Integer   , --
    IN inMovementId_Order    Integer   , -- ���� ��������� ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inIsProductionIn      Boolean   , --
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber TVarChar;
   DECLARE vbParentId Integer;
   DECLARE vbStartWeighing TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ���� �������
     -- vbAccessKeyId:= ...;

     IF COALESCE (ioId, 0) = 0
     THEN
         vbInvNumber:= CAST (NEXTVAL ('Movement_WeighingProduction_seq') AS TVarChar);
         vbParentId:= NULL;
         vbStartWeighing:= CURRENT_TIMESTAMP;
     ELSE
         SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = ioId;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingProduction(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <�������� ������ �����������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, vbStartWeighing);
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isIncome(), ioId, inIsProductionIn);

     -- ��������� �������� <��� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDescId);
     -- ��������� �������� <��� �������� (�����������)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), ioId, inMovementDescNumber);
     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), ioId, inWeighingNumber);

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), ioId, inPartionGoods);
     -- ��������� �������� <Comment>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <��� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentKind(), ioId, inDocumentKindId);

     -- ��������� ����� � <��������� ��� �����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);

     -- ��������� ����� � <��������� ��� �����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), ioId, inPersonalGroupId);

     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inMovementId_Order);

     -- !!!������ ��� ��������!!!
     IF vbIsInsert = TRUE
     THEN
       -- ��������� ����� � <������������>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, vbUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.06.15                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_WeighingProduction (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
