-- Function: lpInsertUpdate_Movement_PersonalGroup()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PersonalGroup (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PersonalGroup(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ����(�����)
    IN inUnitId              Integer   , -- 
    IN inPersonalGroupId     Integer   , -- 
    IN inPairDayId           Integer   , -- 
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
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalGroup(), inInvNumber, inOperDate, Null);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), ioId, inPersonalGroupId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PairDay(), ioId, inPairDayId);

     IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
             -- ��������� �������� <���� �������������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (�������������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_PersonalGroup (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPersonalTradeId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())