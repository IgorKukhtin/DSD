-- Function: lpInsertUpdate_Movement_ChangeIncomePayment()
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ChangeIncomePayment 
    (Integer, TVarChar, TDateTime, TFloat, 
     Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ChangeIncomePayment 
    (Integer, TVarChar, TDateTime, TFloat, 
     Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ChangeIncomePayment(
 INOUT ioId                                 Integer   , -- ���� ������� <�������� ��������� ����� �� ��������>
    IN inInvNumber                          TVarChar  , -- ����� ���������
    IN inOperDate                           TDateTime , -- ���� ���������
    IN inTotalSumm                          TFloat    , -- ����� ��������� �����
    IN inFromId                             Integer   , -- �� ���� (� ���������)
    IN inJuridicalId                        Integer   , -- ��� ������ ������
    IN inChangeIncomePaymentKindId          Integer   , -- ���� ��������� ����� �����
    IN inComment                            TVarChar  , -- �����������
    IN inUserId                             Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ChangeIncomePayment(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <����� ��������� �����>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- ��������� ����� � <��� ��������� ����� �����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ChangeIncomePaymentKind(), ioId, inChangeIncomePaymentKindId);
     -- ��������� <�����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 10.12.15                                                                       *
 
*/