-- Function: gpInsertUpdate_Movement_ExchangeCurrency()

-- DROP FUNCTION gpInsertUpdate_Movement_ExchangeCurrency();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ExchangeCurrency(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    
    IN inAmountFrom          TFloat    , -- ����� ������� �� ������� ��������� �����
    IN inAmountTo            TFloat    , -- ����� ��������� �� ������ ��������� �����
    
    IN inFromId              Integer   , -- �����, ��������� ����
    IN inToId                Integer   , -- �����, ��������� ����
    IN inInfoMoneyId         Integer   , -- ������ ���������� 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ExchangeCurrency());
     vbUserId := inSession;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ExchangeCurrency(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountFrom(), ioId, inAmountFrom);

     -- ��������� �������� <����� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountTo(), ioId, inAmountTo);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <����������� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     
     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ExchangeCurrency (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
