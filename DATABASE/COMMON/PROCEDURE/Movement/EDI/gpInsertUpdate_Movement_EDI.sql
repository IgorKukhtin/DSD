-- Function: gpInsertUpdate_Movement_EDI()

-- DROP FUNCTION gpInsertUpdate_Movement_EDI (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDI(
   OUT outId                 Integer   , -- ���� ������� <�������� �����������>
    IN inOrderInvNumber      TVarChar  , -- ����� ���������
    IN inOrderOperDate       TDateTime , -- ���� ���������
    IN inSaleInvNumber       TVarChar  , -- ����� ���������
    IN inSaleOperDate        TDateTime , -- ���� ���������


    IN inGLN                 TVarChar   , -- �� ���� (� ���������)
    IN inOKPO                TVarChar   , -- �� ���� (� ���������)
 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     SELECT Id INTO outId 
       FROM Movement WHERE DescId = zc_Movement_EDI() AND OperDate = inOrderOperDate AND InvNumber = inOrderInvNumber;

     -- ��������� <��������>
     IF COALESCE(outId, 0) = 0 THEN
        outId := lpInsertUpdate_Movement (outId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
     END IF;

     -- ��������� ����� � <�� ���� (� ���������)>
--     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
  --   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.05.14                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
