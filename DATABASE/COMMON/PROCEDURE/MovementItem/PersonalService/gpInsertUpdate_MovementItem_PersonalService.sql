-- Function: gpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ����������
    IN inisMain              Boolean   , -- �������� ����� ������
   OUT outAmount             TFloat    , -- ����� (�������)
   OUT outAmountToPay        TFloat    , -- ����� � ������� (����)
   OUT outAmountCash         TFloat    , -- ����� � ������� �� �����
    IN inSummService         TFloat    , -- ����� ���������
    IN inSummCardRecalc      TFloat    , -- ����� �� �������� (��) ��� �������������    
    IN inSummMinus           TFloat    , -- ����� ���������
    IN inSummAdd             TFloat    , -- ����� ������
    IN inSummSocialIn        TFloat    , -- ����� ��� ������� (�� ��������)
    IN inSummSocialAdd       TFloat    , -- ����� ��� ������� (���. ��������)
    IN inSummChild           TFloat    , -- ����� �������� (���������)    
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inUnitId              Integer   , -- �������������
    IN inPositionId          Integer   , -- ���������
    IN inMemberId            Integer   , -- ��.����
    IN inPersonalServiceListId Integer   , -- ��������� ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());

     -- ���������
     SELECT tmp.ioId, tmp.outAmount, tmp.outAmountToPay, tmp.outAmountCash
        INTO ioId, outAmount, outAmountToPay, outAmountCash
     FROM lpInsertUpdate_MovementItem_PersonalService (ioId                 := ioId
                                                     , inMovementId         := inMovementId
                                                     , inPersonalId         := inPersonalId
                                                     , inIsMain             := inIsMain
                                                     , inSummService        := inSummService
                                                     , inSummCardRecalc     := inSummCardRecalc
                                                     , inSummMinus          := inSummMinus
                                                     , inSummAdd            := inSummAdd
                                                     , inSummSocialIn       := inSummSocialIn
                                                     , inSummSocialAdd      := inSummSocialAdd
                                                     , inSummChild          := inSummChild
                                                     , inComment            := inComment
                                                     , inInfoMoneyId        := inInfoMoneyId
                                                     , inUnitId             := inUnitId
                                                     , inPositionId         := inPositionId
                                                     , inMemberId           := inMemberId
                                                     , inPersonalServiceListId  := inPersonalServiceListId
                                                     , inUserId             := vbUserId
                                                      ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.05.15         * add PersonalServiceList
 14.09.14                                        * add outAmountToPay
 02.10.14                                        * del inSummCard
 01.10.14         * add redmine 30.09
 14.09.14                                        * add out...
 11.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalService (ioId:= 0, inMovementId:= 258038 , inPersonalId:= 8473, inAmount:= 44, inSummService:= 20, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8426, inPositionId:=12431, inSession:= '2')
