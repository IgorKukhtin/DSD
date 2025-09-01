-- Function: lpInsertUpdate_MovementItem_StaffList()
  
  ������� lpinsertupdate_movementitem_stafflist(ioid := integer, inmovementid := integer, inpositionid := integer, inpositionlevelid := integer, instaffpaidkindid := integer, instaffhoursdayid := integer, instaffhoursid := integer, inpstaffhourslengthid := integer, inpersonalid := integer
  , inamount := tfloat, inamountreport := tfloat, instaffcount_1 := tfloat, instaffcount_2 := tfloat, instaffcount_3 := tfloat, instaffcount_4 := tfloat, instaffcount_5 := tfloat, instaffcount_6 := tfloat, instaffcount_7 := tfloat, instaffcount_invent := tfloat, instaff_price := tfloat
  , instaff_summ_mk := tfloat, instaff_summ_real := tfloat, instaff_summ_add := tfloat, incomment := tvarchar, inuserid := integer) �� ����������
  
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_StaffList(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , --
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inPersonalId            Integer   , -- 
    IN inStaffPaidKindId       Integer   , -- 
    IN inStaffHoursDayId       Integer   , -- 
    IN inStaffHoursId          Integer   , -- 
    IN inStaffHoursLengthId    Integer   , -- 
    IN inAmount                TFloat    , --
    IN inAmountReport          TFloat    , --
    IN inStaffCount_1          TFloat    , --
    IN inStaffCount_2          TFloat    , --
    IN inStaffCount_3          TFloat    , --
    IN inStaffCount_4          TFloat    , --
    IN inStaffCount_5          TFloat    , --
    IN inStaffCount_6          TFloat    , --
    IN inStaffCount_7          TFloat    , --
    IN inStaffCount_Invent     TFloat    , --
    IN inStaff_Price           TFloat    , --
    IN inStaff_Summ_MK         TFloat    , --
    IN inStaff_Summ_real       TFloat    , --
    IN inStaff_Summ_add        TFloat    , --
    IN inComment               TVarChar  , -- 
    IN inUserId                Integer     -- ������������
)                               
RETURNS Integer AS               
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� �������.';
     END IF;
     -- ��������
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <���������>.';
     END IF;
    
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPositionId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReport(), ioId, inAmountReport);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_1(), ioId, inStaffCount_1);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_2(), ioId, inStaffCount_2);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_3(), ioId, inStaffCount_3);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_4(), ioId, inStaffCount_4);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_5(), ioId, inStaffCount_5);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_6(), ioId, inStaffCount_6);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_7(), ioId, inStaffCount_7);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_Invent(), ioId, inStaffCount_Invent);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Price(), ioId, inStaff_Price);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_MK(), ioId, inStaff_Summ_MK);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_real(), ioId, inStaff_Summ_real);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_add(), ioId, inStaff_Summ_add);


     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffPaidKind(), ioId, inStaffPaidKindId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffHoursDay(), ioId, inStaffHoursDayId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffHours(), ioId, inStaffHoursId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffHoursLength(), ioId, inStaffHoursLengthId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Personal(), ioId, inPersonalId);
     
     
     -- ����������� �������� ����� �� ���������
     --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.25         *
*/

-- ����
-- 