-- Function: lpInsertUpdate_Movement_PersonalTransport()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PersonalTransport (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PersonalTransport(
 INOUT ioId                     Integer   , -- ���� ������� <��������>
    IN inInvNumber              TVarChar  , -- ����� ���������
    IN inOperDate               TDateTime , -- ���� ���������
    IN inServiceDate            TDateTime , -- ����� ����������
    IN inPersonalServiceListId  Integer   , -- ��������� ����������
    IN inComment                TVarChar  , -- ����������
    IN inUserId                 Integer    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean; 
   DECLARE vbMovementId_check Integer;
BEGIN

     -- ��������
     IF inOperDate <> DATE_TRUNC ('Day', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <��������� ����������>.';
     END IF;


     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- �������� - ������ ���� �� ������
     vbMovementId_check:= (SELECT MovementDate.MovementId
                           FROM MovementDate
                                INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate.MovementId
                                                             AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                             AND MovementLinkObject.ObjectId = inPersonalServiceListId
                                INNER JOIN Movement ON Movement.Id = MovementDate.MovementId
                                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                   AND Movement.Id <> COALESCE (ioId, 0)
                           WHERE MovementDate.ValueData = inServiceDate
                             AND MovementDate.DescId = zc_MIDate_ServiceDate()
                           LIMIT 1
                          );
     IF vbMovementId_check <> 0 AND 1=0 -- AND inUserId <> 5
     THEN
         RAISE EXCEPTION '������.������� ������ <��������� ���������� �������> � <%> �� <%> ��� <%> �� <%>.������������ ���������.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_check)
                                                                                                                                    , DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_check))
                                                                                                                                    , lfGet_Object_ValueData ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = vbMovementId_check AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()))
                                                                                                                                    , zfCalc_MonthYearName ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = vbMovementId_check AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalTransport(), inInvNumber, inOperDate, Null);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- ��������� �������� <����� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, inServiceDate);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.08.22         *
*/

-- ����
--