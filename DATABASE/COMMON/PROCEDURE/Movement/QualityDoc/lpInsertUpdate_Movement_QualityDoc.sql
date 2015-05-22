-- Function: lpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TransportGoods(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementId_Sale     Integer   , -- 
    IN inInvNumberMark       TVarChar  , -- 
    IN inCarId               Integer   , -- ����������
    IN inCarTrailerId        Integer   , -- ���������� (������)
    IN inPersonalDriverId    Integer   , -- ��������� (��������)
    IN inRouteId             Integer   , -- 
    IN inMemberId1           Integer   , -- ������� ����/����������
    IN inMemberId2           Integer   , -- ��������� (����������� ����� �����������������)
    IN inMemberId3           Integer   , -- ³����� ��������
    IN inMemberId4           Integer   , -- ���� (����������� ����� �����������������)
    IN inMemberId5           Integer   , -- ������� ����/����������
    IN inMemberId6           Integer   , -- ���� ����/����������
    IN inMemberId7           Integer   , -- ������� (����������� ����� �����������������) 
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- ���������� ���� �������
     IF inMovementId_Sale <> 0
     THEN
         vbAccessKeyId:= (SELECT AccessKeyId FROM Movement WHERE Id = inMovementId_Sale);
     ELSE
         IF ioId <> 0
         THEN vbAccessKeyId:= (SELECT AccessKeyId FROM Movement WHERE Id = ioId);
         ELSE vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TransportGoods());
         END IF;
     END IF;


     -- ��������
     IF inOperDate IS NULL
     THEN
         RAISE EXCEPTION '������.�� ����������� <���� ���������>.';
     END IF;

     -- ��������
     IF 1=0 AND COALESCE (inMovementId_Sale, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� <� ���. (�����)>.';
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 -- AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_TransportGoods())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := inUserId);
     END IF;


      -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransportGoods(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <����� ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
     -- ��������� ����� � <���������� (������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarTrailer(), ioId, inCarTrailerId);
     -- ��������� ����� � <��������� (��������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);

     -- ��������� ����� � <������� ����/����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member1(), ioId, inMemberId1);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member2(), ioId, inMemberId2);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member3(), ioId, inMemberId3);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member4(), ioId, inMemberId4);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member5(), ioId, inMemberId5);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member6(), ioId, inMemberId6);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member7(), ioId, inMemberId7);


     -- ���������� ����� � <������� ����������> �� ���� �������� <������-������������ ���������>
     IF inMovementId_Sale <> 0 
     THEN PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_TransportGoods(), inMovementId_Sale, ioId);
     END IF;

     -- ������� ����� � "������" <������� ����������> �� ���� �������� <������-������������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_TransportGoods(), MovementLinkMovement.MovementId, NULL)
     FROM MovementLinkMovement
     WHERE MovementLinkMovement.MovementChildId = ioId
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_TransportGoods()
       AND MovementLinkMovement.MovementId <> inMovementId_Sale
    ;

     -- 5.2. �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_TransportGoods()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.03.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_TransportGoods (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
