-- Function: gpInsertUpdate_MovementItem_MobileBills()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileBills (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_MobileBills(
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
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_MobileBills());

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_MobileBills (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inMobileEmployeeId   := inMobileEmployeeId
                                                   , inAmount             := inAmount
                                                   , inCurrMonthly        := inCurrMonthly
                                                   , inCurrNavigator      := inCurrNavigator
                                                   , inPrevNavigatory     := inPrevNavigator
                                                   , inLimit              := inLimit
                                                   , inPrevLimit          := inPrevLimit
                                                   , inDutyLimit          := inDutyLimit
                                                   , inOverlimit          := inOverlimit
                                                   , inPrevMonthly        := inPrevMonthly
                                                   , inRegionId           := inRegionId
                                                   , inEmployeeId            := inEmployeeId
                                                   , inPrevEmployeeId             := inPrevEmployeeId
                                                   , inMobileTariffId          := inMobileTariffId
                                                   , inPrevMobileTariffId     := inPrevMobileTariffId
                                                   , inUserId             := vbUserId
                                                     ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.09.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_MobileBills (ioId:= 0, inMovementId:= 10, inMobileEmployeeId:= 1, inAmount:= 0, inCurrMonthly:= 0, inPrevMobileTariff:= '', inRegionId:= 0, inSession:= '2')
