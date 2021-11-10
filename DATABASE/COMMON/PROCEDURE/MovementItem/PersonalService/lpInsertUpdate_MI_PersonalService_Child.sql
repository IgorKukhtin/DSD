-- Function: lpInsertUpdate_MI_PersonalService_Child()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PersonalService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PersonalService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PersonalService_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inMemberId            Integer   , -- 
    IN inPositionLevelId     Integer   , -- 
    IN inStaffListId         Integer   , -- 
    IN inModelServiceId      Integer   , -- 
    IN inStaffListSummKindId Integer   , -- 

    IN inAmount              TFloat    , -- 
    IN inMemberCount         TFloat    , -- 
    IN inDayCount            TFloat    , -- 
    IN inWorkTimeHoursOne   TFloat    , -- 
    IN inWorkTimeHours       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inHoursPlan           TFloat    , -- 
    IN inHoursDay            TFloat  , -- 
    IN inPersonalCount       TFloat    , -- 
    IN inGrossOne            TFloat  , -- 
    IN inKoeff               TFloat  , -- 

    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inMemberId, inMovementId, inAmount, inParentId, inUserId);
   
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MemberCount(), ioId, inMemberCount);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayCount(), ioId, inDayCount);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WorkTimeHoursOne(), ioId, inWorkTimeHoursOne);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WorkTimeHours(), ioId, inWorkTimeHours);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HoursPlan(), ioId, inHoursPlan);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HoursDay(), ioId, inHoursDay);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PersonalCount(), ioId, inPersonalCount);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GrossOne(), ioId, inGrossOne);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(), ioId, inKoeff);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffList(), ioId, inStaffListId );
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ModelService(), ioId, inModelServiceId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffListSummKind(), ioId, inStaffListSummKindId);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.11.21         *
 22.06.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_PersonalService_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
