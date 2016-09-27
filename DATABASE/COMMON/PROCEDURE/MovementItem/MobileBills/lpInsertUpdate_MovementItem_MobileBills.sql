-- Function: lpInsertUpdate_MovementItem_MobileBills()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_MobileBills (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_MobileBills(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMobileEmployeeId    Integer   , -- ����� ��������
    IN inAmount              TFloat    , -- ����� �����
    IN inCurrMonthly         TFloat    , -- 
    IN inCurrNavigator       TFloat    , -- 
    IN inPrevNavigator       TFloat    , -- 
    IN inLimit               TFloat    , -- 
    IN inPrevLimit           TFloat    , -- 
    IN inDutyLimit           TFloat    , -- 
    IN inOverlimit           TFloat    , -- 
    IN inPrevMonthly         TFloat    , -- 
    IN inRegionId            Integer   , --
    IN inEmployeeId          Integer   , --
    IN inPrevEmployeeId      Integer   , --
    IN inMobileTariffId      Integer   , --
    IN inPrevMobileTariffId  Integer   , --
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
 
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inMobileEmployeeId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrMonthly(), ioId, inCurrMonthly);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrNavigator(), ioId, inCurrNavigator);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevNavigator(), ioId, inPrevNavigator);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Limit(), ioId, inLimit);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevLimit(), ioId, inPrevLimit);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DutyLimit(), ioId, inDutyLimit);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Overlimit(), ioId, inOverlimit);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevMonthly(), ioId, inPrevMonthly);
    
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Region(), ioId, inRegionId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Employee(), ioId, inEmployeeId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PrevEmployee(), ioId, inPrevEmployeeId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MobileTariff(), ioId, inMobileTariffId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PrevMobileTariff(), ioId, inPrevMobileTariffId);

     
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.05.15                                        * set lp
 26.07.14                                        * add inPrevMobileTariffDate and inPrevEmployeeId and inMobileTariffId and inPrevMobileTariffId and ioPrevMobileTariff
 23.05.14                                                       *
 18.07.13         * add inEmployeeId
 16.07.13                                        * del params by MobileBillsOnPrice
 12.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_MobileBills (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPrevMobileTariff:= '', inRegionId:= 0, inSession:= '2')
