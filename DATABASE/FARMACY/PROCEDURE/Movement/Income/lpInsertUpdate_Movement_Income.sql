-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inNDSKindId           Integer   , -- ���� ���
    IN inContractId          Integer   , -- �������
    IN inOrderId             Integer   , -- �c���� �� ������ ���������� 
    IN inPaymentDate         TDateTime , -- ���� �������
    IN inJuridicalId         Integer   , -- ������ ����������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumberPoint Integer;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <���� ���>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_NDSKind(), ioId, inNDSKindId);
     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, (Select ValueData from ObjectFloat Where ObjectID = inNDSKindId AND DescId = zc_ObjectFloat_NDSKind_NDS()));

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- 
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Payment(), ioId, inPaymentDate);

     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     
     -- ��������� ����� � <���������� ������ ����������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inOrderId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);


    -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, inUserId);
         END IF;
     END IF;


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 22.04.16         *
 21.12.15                                                                       *
 07.12.15                                                                       *
 24.12.14                         *
 02.12.14                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
