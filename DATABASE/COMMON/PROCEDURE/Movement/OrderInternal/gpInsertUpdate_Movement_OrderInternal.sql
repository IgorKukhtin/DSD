-- Function: gpInsertUpdate_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternal(Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� (������������ ������)
   OUT outOperDatePartner    TDateTime , -- ���� ��������� (������������)
 INOUT ioOperDateStart       TDateTime , -- ���� ������� (���.)
 INOUT ioOperDateEnd         TDateTime , -- ���� ������� (������.)
   OUT outDayCount           TFloat    , -- ���������� ���� �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inIsRemains           Boolean   , -- 
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());

     -- 1. ��� ��������� ������ +1 ����
     IF inToId = 8451 -- ��� ��������
        OR inFromId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp) -- ��� �������+���-��
     THEN
         outOperDatePartner:= inOperDate;
     ELSE 
         outOperDatePartner:= inOperDate + INTERVAL '1 DAY';
     END IF;
     -- 1. ��� ��������� ������ -56 ����
     -- ioOperDateStart:= inOperDate - INTERVAL '56 DAY';
     -- 1. ��� ��������� ������ -1 ����
     -- ioOperDateEnd:= inOperDate - INTERVAL '1 DAY';
     -- 0.
     outDayCount:= 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (ioOperDateEnd) - zfConvert_DateTimeWithOutTZ (ioOperDateStart)));

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternal(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <���� ������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, outOperDatePartner);
     -- ��������� �������� <���� ������ �>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, ioOperDateStart);
     -- ��������� �������� <���� ������ ��>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, ioOperDateEnd);                                          

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- IsRemains
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), ioId, inIsRemains);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.06.15                                        * all
 02.03.15         * add OperDatePartner, OperDateStart, OperDateEnd, DayCount
 06.06.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_OrderInternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
