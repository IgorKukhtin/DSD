-- Function: lpInsertUpdate_Movement_Task()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Task (Integer, TVarChar, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Task(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ����(�����)
    IN inPersonalTradeId     Integer   , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_TaxCorrective Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;
     
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Task(), inInvNumber, inOperDate, Null);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, inPersonalTradeId);

     IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.03.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Task (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPersonalTradeId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())