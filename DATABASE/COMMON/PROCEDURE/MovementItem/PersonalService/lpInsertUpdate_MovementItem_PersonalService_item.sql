-- Function: lpInsertUpdate_MovementItem_PersonalService_item()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, TVarChar
                                                                        , Integer, Integer, Integer, Integer, Integer, Integer);*/
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, TVarChar
                                                                        , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalService_item(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ����������
    IN inisMain              Boolean   , -- �������� ����� ������

    IN inSummService         TFloat    , -- ����� ���������
    IN inSummCardRecalc      TFloat    , -- ����� �� (����) - 1�.
    IN inSummCardSecondRecalc TFloat    , -- ����� �� (����) - 2�.
    IN inSummCardSecondCash  TFloat    , -- ����� �� (�����) - 2�.
    IN inSummAvCardSecondRecalc TFloat    , -- ����� �� (����) - 2�. �����
    IN inSummNalogRecalc     TFloat    , -- ������ - ��������� � �� (����)
    IN inSummNalogRetRecalc  TFloat    , -- ������ - ���������� � �� (����)
    IN inSummMinus           TFloat    , -- ����� ���������
    IN inSummAdd             TFloat    , -- ����� ������
    IN inSummAddOthRecalc    TFloat    , -- ����� ������ (���� ��� �������������)
    
    IN inSummHoliday         TFloat    , -- ����� ���������    
    IN inSummSocialIn        TFloat    , -- ����� ��� ������� (�� ��������)
    IN inSummSocialAdd       TFloat    , -- ����� ��� ������� (���. ��������)
    IN inSummChildRecalc     TFloat    , -- �������� - ��������� (����)
    IN inSummMinusExtRecalc  TFloat    , -- ��������� ������. ��.�. (����)
    
    IN inSummFine               TFloat , -- �����
    IN inSummFineOthRecalc      TFloat , -- ����� (���� ��� �������������)
    IN inSummHosp               TFloat , -- ����������
    IN inSummHospOthRecalc      TFloat , -- ���������� (���� ��� �������������)

    IN inSummCompensationRecalc TFloat , -- ����������� (����)
    IN inSummAuditAdd           TFloat , -- ����� ������� �� �����
    IN inSummHouseAdd           TFloat , -- ����� ������� �� �����
    IN inSummAvanceRecalc       TFloat , -- ����

    IN inNumber              TVarChar  , -- � ��������������� �����
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inUnitId              Integer   , -- �������������
    IN inPositionId          Integer   , -- ���������
    IN inMemberId            Integer   , -- ��� ���� (���� ��������� ��������)
    IN inPersonalServiceListId   Integer   , -- ��������� ����������
    IN inFineSubjectId          Integer   , -- ��� ���������
    IN inUnitFineSubjectId      Integer   , -- ��� ���������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
BEGIN
     -- ���������
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_PersonalService (ioId                     := ioId
                                                     , inMovementId             := inMovementId
                                                     , inPersonalId             := inPersonalId
                                                     , inIsMain                 := inIsMain

                                                     , inSummService            := inSummService
                                                     , inSummCardRecalc         := inSummCardRecalc
                                                     , inSummCardSecondRecalc   := inSummCardSecondRecalc
                                                     , inSummCardSecondCash     := inSummCardSecondCash
                                                     , inSummAvCardSecondRecalc := inSummAvCardSecondRecalc
                                                     , inSummNalogRecalc        := inSummNalogRecalc
                                                     , inSummNalogRetRecalc     := inSummNalogRetRecalc
                                                     , inSummMinus              := inSummMinus
                                                     , inSummAdd                := inSummAdd
                                                     , inSummAddOthRecalc       := inSummAddOthRecalc

                                                     , inSummHoliday            := inSummHoliday
                                                     , inSummSocialIn           := inSummSocialIn
                                                     , inSummSocialAdd          := inSummSocialAdd
                                                     , inSummChildRecalc        := inSummChildRecalc
                                                     , inSummMinusExtRecalc     := inSummMinusExtRecalc
                                                     , inSummFine               := inSummFine
                                                     , inSummFineOthRecalc      := inSummFineOthRecalc
                                                     , inSummHosp               := inSummHosp
                                                     , inSummHospOthRecalc      := inSummHospOthRecalc
                                                     , inSummCompensationRecalc := inSummCompensationRecalc
                                                     , inSummAuditAdd           := inSummAuditAdd
                                                     , inSummHouseAdd           := inSummHouseAdd
                                                     , inSummAvanceRecalc       := inSummAvanceRecalc

                                                     , inNumber                 := inNumber
                                                     , inComment                := inComment
                                                     , inInfoMoneyId            := inInfoMoneyId
                                                     , inUnitId                 := inUnitId
                                                     , inPositionId             := inPositionId
                                                     , inMemberId               := inMemberId
                                                     , inPersonalServiceListId  := inPersonalServiceListId
                                                     , inFineSubjectId          := inFineSubjectId
                                                     , inUnitFineSubjectId      := inUnitFineSubjectId
                                                     , inUserId                 := inUserId
                                                      ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.10.19         * ������ inSummFine, inSummHosp �� inSummFineRecalc, inSummHospRecalc
 05.01.18         * add inSummNalogRetRecalc
 20.06.17         * add inSummCardSecondCash
 20.04.16         * add inSummHoliday
 22.05.15                                        *
*/

-- ����
-- 