-- Function: gpUpdate_Movement_WeighingProduction()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingProduction(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� �������� (�����������)
    IN inWeighingNumber      Integer   , -- ����� �����������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inDocumentKindId      Integer   , -- ��� ���������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN InvNumber_Parent      TVarChar  , -- � ��. ���������
    IN inIsProductionIn      Boolean   , -- ������ ��� ������ � ������������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingProduction());
     --vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ���� �������
     -- vbAccessKeyId:= ...;

     SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = inId;

     IF COALESCE (InvNumber_Parent, '') = '' 
        THEN
            vbParentId:= (SELECT CAST (Null AS Integer)) ;
     END IF;

     -- ��������� <��������>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_WeighingProduction(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isIncome(), inId, inIsProductionIn);

     -- ��������� �������� <��� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), inId, inMovementDescId);
     -- ��������� �������� <��� �������� (�����������)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), inId, inMovementDescNumber);
     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);
 
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), inId, inPartionGoods);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);
     -- ��������� ����� � <��� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentKind(), inId, inDocumentKindId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.11.16         *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_WeighingProduction (inId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
