-- Function: gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat,  TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Transport(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    
    IN inStartRunPlan        TDateTime , -- ����/����� ������ ����
    IN inEndRunPlan          TDateTime , -- ����/����� ����������� ����
    IN inStartRun            TDateTime , -- ����/����� ������ ����
    IN inEndRun              TDateTime , -- ����/����� ����������� ����

    IN inHoursAdd            TFloat    , -- ���-�� ����������� ������� �����
   OUT outHoursWork          TFloat    , -- ���-�� ������� �����

    IN inComment             TVarChar  , -- ����������
    
    IN inCarId                Integer   , -- ����������
    IN inCarTrailerId         Integer   , -- ���������� (������)
    IN inPersonalDriverId     Integer   , -- ��������� (��������)
    IN inPersonalDriverMoreId Integer   , -- ��������� (��������, ��������������)
    IN inPersonalId           Integer   , -- ��������� (����������)
    IN inUnitForwardingId     Integer   , -- ������������� (����� ��������)

    IN inSession              TVarChar    -- ������ ������������

)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbChild_byMaster Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Transport());


     -- ��������
     IF inHoursAdd > 0
     THEN
         RAISE EXCEPTION '������.��������� ���� ��� <���-�� ����������� ������� �����>.';
     END IF;

     -- ���������� - ���� ���������� ���������, ���� � ����� ����������� Child - �������� ����
     IF ioId <> 0 AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Car() AND ObjectId = inCarId)
     THEN vbChild_byMaster:= TRUE;
     ELSE vbChild_byMaster:= FALSE;
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Transport(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <����/����� ������ ����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), ioId, inStartRunPlan);
     -- ��������� ����� � <����/����� ����������� ����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRunPlan(), ioId, inEndRunPlan);
     -- ��������� ����� � <����/����� ������ ����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), ioId, inStartRun);
     -- ��������� ����� � <����/����� ����������� ����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRun(), ioId, inEndRun);

     -- ��������� �������� <���-�� ������� �����>
     outHoursWork := EXTRACT (DAY FROM (inEndRun - inStartRun)) * 24 + EXTRACT (HOUR FROM (inEndRun - inStartRun)) + CAST (EXTRACT (MIN FROM (inEndRun - inStartRun)) / 60 AS NUMERIC (16, 2));
     -- ��������� �������� <���-�� ������� �����>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), ioId, outHoursWork);

     -- ��������� ��� � ��������� ������ � ������� �������� <���-�� ������� �����> !!!� ������ �����������!!!
     outHoursWork := outHoursWork + COALESCE (inHoursAdd, 0);

     -- ��������� �������� <���-�� ����������� ������� �����>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursAdd(), ioId, inHoursAdd);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
     -- ��������� ����� � <���������� (������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarTrailer(), ioId, inCarTrailerId);

     -- ��������� ����� � <��������� (��������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
     -- ��������� ����� � <��������� (��������, ��������������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriverMore(), ioId, inPersonalDriverMoreId);
     -- ��������� ����� � <��������� (����������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
     
     -- ��������� ����� � <������������� (����� ��������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, inUnitForwardingId);


     -- �������� �������� � ����������� ����������
     PERFORM lpInsertUpdate_Movement (ioId:= Movement.Id, inDescId:=zc_Movement_Income(), inInvNumber:= Movement.InvNumber, inOperDate:= inOperDate, inParentId:= Movement.ParentId)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), Movement.Id, inCarId)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), Movement.Id, inPersonalDriverId)
     FROM Movement
     WHERE Movement.ParentId = ioId
       AND Movement.DescId   = zc_Movement_Income();


     -- !!!�����������!!! ����������� Child
     IF vbChild_byMaster = TRUE
     THEN PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := ioId, inParentId := MovementItem.Id, inRouteKindId:= MILinkObject_RouteKind.ObjectId, inUserId := vbUserId)
          FROM MovementItem
               LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id 
                                               AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
          WHERE MovementItem.MovementId = ioId
            AND MovementItem.DescId = zc_MI_Master();
     END IF;


     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.13                                        * add lpGetAccessKey
 02.12.13         * add Personal (changes in wiki)
 31.10.13                                        * add lpInsertUpdate_Movement - �������� �������� � ����������� ����������
 24.10.13                                        * add !!!� ������ �����������!!!
 24.10.13                                        * add min to outHoursWork
 13.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 12.10.13                                        * add IF inHoursAdd > 0
 06.10.13                                        * add zc_Movement_Income
 26.09.13                                        * changes in wiki                 
 25.09.13         * changes in wiki                 
 20.08.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Transport (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00', inStartRunPlan:= '30.09.2013 3:00:00', inEndRunPlan:= '30.09.2013 3:00:00', inStartRun:= '30.09.2013 3:00:00', inEndRun:= '30.09.2013 3:00:00', inHoursAdd:= 0, inComment:= ''    , inCarId:= 67657, inCarTrailerId:= 0, inPersonalDriverId:= 19476, inPersonalDriverMoreId:= 19476, inUnitForwardingId:= 1000, inSession:= '2')
