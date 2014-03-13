-- Function: gpInsertUpdate_Movement_WeighingProduction()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingProduction(
 INOUT ioId                  Integer   , -- ���� ������� <��������  ����������� (������������)>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inParentId            Integer   , -- �������� ��������
    IN inStartWeighing       TDateTime , -- �������� ������ �����������
    IN inEndWeighing         TDateTime , -- �������� ��������� �����������

    IN inMovementDesc        TFloat    , -- ��� ���������
 
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inUserId              Integer   , -- ������������

    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingProduction(), inInvNumber, inOperDate, inParentId, vbAccessKeyId);

     -- ��������� �������� <�������� ������ ������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, inStartWeighing);
     -- ��������� �������� <�������� ��������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighingr(), ioId, inEndWeighingr);
     
     -- ��������� �������� <��� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDesc);
 
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, inUserId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_WeighingProduction (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
