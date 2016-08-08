-- Function: lpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inComment             TVarChar   , -- ����������
    IN inChecked             Boolean   , -- ��������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Send(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (ioId);


    -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 28.06.16         *
 20.03.16         *
 29.07.15                                                                       *
 */

/*
select  Movement.*
             -- ��������� �������� <���� ��������>
             , lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), a.Id, mp1.OperDate)
             -- ��������� �������� <������������ (��������)>
             , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), a.Id, mp1.UserId)


             , lpInsertUpdate_MovementDate (zc_MovementDate_Update(), a.Id, mp2.OperDate)
             -- ��������� �������� <������������ (��������)>
             , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), a.Id, mp2.UserId)
from (
SELECT Movement.Id, min (MovementProtocol.Id) as id1, max (MovementProtocol.Id) as id2
FROM Movement
            LEFT JOIN MovementProtocol on MovementProtocol.MovementId = Movement.Id
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
where Movement.descId = zc_Movement_Send()
   and MLO_Insert.MovementId is null
--   and Movement.OperDate < '01.07.2016'
group by Movement.Id
) as a
            LEFT JOIN Movement on Movement.Id = a.Id
            LEFT JOIN MovementProtocol as mp1  on mp1.Id = a.Id1
            LEFT JOIN MovementProtocol as mp2  on mp2.Id = a.Id2 and  a.Id1 <> a.Id2

*/
-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
