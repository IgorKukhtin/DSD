-- Function: gpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);*/

/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);*/

/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
  */
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);*/

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������
    IN inIsMain                Boolean   , -- �������� ����� ������
   OUT outisAuto               Boolean   , -- ������ �������������
   OUT outAmount               TFloat    , -- ***����� (�������)
   OUT outAmountToPay          TFloat    , -- ***����� � ������� (����)
   OUT outAmountCash           TFloat    , -- ***����� � ������� �� �����
   OUT outSummTransport        TFloat    , -- ***����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)
   OUT outSummTransportAdd     TFloat    , -- ***����� ��������������� (�������)
   OUT outSummTransportAddLong TFloat    , -- ***����� ������������ (�������, ���� ���������������)
   OUT outSummTransportTaxi    TFloat    , -- ***����� �� ����� (�������)
   OUT outSummPhone            TFloat    , -- ***����� ���.����� (���������)
    IN inSummService           TFloat    , -- ����� ���������
    IN inSummCardRecalc        TFloat    , -- ����� �� (����) - 1�.
    IN inSummCardSecondRecalc  TFloat    , -- ����� �� (����) - 2�.
    IN inSummCardSecondCash    TFloat    , -- ����� �� (�����) - 2�.
    IN inSummAvCardSecondRecalc  TFloat    , -- ����� �� (����) - 2�. �����
    IN inSummNalogRecalc       TFloat    , -- ������ - ��������� (����)
    IN inSummNalogRet          TFloat    , -- ������ - ���������� � �� !!!�� ����!!!
    IN inSummMinus             TFloat    , -- ����� ���������
    IN inSummAdd               TFloat    , -- ����� ������
    IN inSummAddOthRecalc      TFloat    , -- ����� ������ (���� ��� �������������)
    IN inSummHoliday           TFloat    , -- ����� ���������
    IN inSummSocialIn          TFloat    , -- ����� ��� ������� (�� ��������)
    IN inSummSocialAdd         TFloat    , -- ����� ��� ������� (���. ��������)
    IN inSummChildRecalc       TFloat    , -- �������� - ��������� (����)
    IN inSummMinusExtRecalc    TFloat    , -- ��������� ������. ��.�. (����)
    IN inSummFine              TFloat    , -- �����
    IN inSummFineOthRecalc     TFloat    , -- ����� (���� ��� �������������)
    IN inSummHosp              TFloat    , -- ����������
    IN inSummHospOthRecalc     TFloat    , -- ���������� (���� ��� �������������)
    IN inSummCompensationRecalc TFloat   , -- ����������� (����)
    IN inSummAuditAdd           TFloat   , -- ����� ������� �� �����
    IN inSummHouseAdd           TFloat   , -- ����� ����������� �����
    IN inSummAvanceRecalc       TFloat    , --  A����
    IN inComment               TVarChar  , --
    IN inInfoMoneyId           Integer   , -- ������ ����������
    IN inUnitId                Integer   , -- �������������
    IN inPositionId            Integer   , -- ���������
    IN inMemberId              Integer   , --
    IN inPersonalServiceListId Integer   , -- ��������� ����������
    IN inFineSubjectId         Integer   , -- ��� ���������
    IN inUnitFineSubjectId     Integer   , -- ��� ���������� ���������
 INOUT ioBankOutDate           TDateTime ,
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisBankOut Boolean;
   DECLARE vbisDetail Boolean;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbSummAvanceMax TFloat;
   -- !!! ������
   DECLARE inNumber TVarChar; --  � ���������������
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());

     --��������, ���� ��������� �� �����, �� vbisDetail ������ ���� = TRUE
     -- �������� �������� PersonalServiceList
     vbPersonalServiceListId:= (SELECT MovementLinkObject.ObjectId
                                FROM MovementLinkObject
                                WHERE MovementLinkObject.MovementId = inMovementId
                                  AND MovementLinkObject.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                );
     vbisDetail := COALESCE ((SELECT ObjectBoolean.ValueData
                              FROM ObjectBoolean
                              WHERE ObjectBoolean.ObjectId = vbPersonalServiceListId
                                AND ObjectBoolean.DescId = zc_ObjectBoolean_PersonalServiceList_Detail())
                             , FALSE) ::Boolean;
     IF COALESCE (ioId,0) = 0
        AND vbisDetail = FALSE
        AND EXISTS (SELECT 1
                    FROM MovementItem AS MI
                    WHERE MI.MovementId = inMovementId
                      AND MI.DescId = zc_MI_Master()
                      AND MI.isErased = FALSE
                      AND MI.ObjectId = inPersonalId)
     THEN
         --
         RAISE EXCEPTION '������.��� ������� ��������� ��� ����������� ������.������������ ���������.';
     END IF;

     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_isAuto() AND MB.ValueData = TRUE)
     THEN
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inMovementId, FALSE);
     END IF;


     --������� �������� ���� ����� ������ ��� ���������
     vbSummAvanceMax := (SELECT COALESCE (ObjectFloat_SummAvanceMax.ValueData, 0) :: TFloat AS SummAvanceMax
                         FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                              INNER JOIN ObjectFloat AS ObjectFloat_SummAvanceMax
                                                     ON ObjectFloat_SummAvanceMax.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                                    AND ObjectFloat_SummAvanceMax.DescId = zc_ObjectFloat_PersonalServiceList_SummAvanceMax()
                         WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                           AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                         );
     --��������
     IF COALESCE (inSummAvanceRecalc,0) > COALESCE (vbSummAvanceMax,0) AND COALESCE (vbSummAvanceMax,0) <> 0
     THEN
         RAISE EXCEPTION '������.����� <%> ��������� ����������� ���������� <%> ��� ������ ���������.', inSummAvanceRecalc, vbSummAvanceMax;
     END IF;

     -- ���������
     SELECT tmp.ioId, tmp.outAmount, tmp.outAmountToPay, tmp.outAmountCash
          , tmp.outSummTransport, tmp.outSummTransportAdd, tmp.outSummTransportAddLong, tmp.outSummTransportTaxi, tmp.outSummPhone
            INTO ioId, outAmount, outAmountToPay, outAmountCash
               , outSummTransport, outSummTransportAdd, outSummTransportAddLong, outSummTransportTaxi, outSummPhone
     FROM lpInsertUpdate_MovementItem_PersonalService (ioId                    := ioId
                                                     , inMovementId            := inMovementId
                                                     , inPersonalId            := inPersonalId
                                                     , inIsMain                := inIsMain
                                                     , inSummService           := inSummService
                                                     , inSummCardRecalc        := inSummCardRecalc
                                                     , inSummCardSecondRecalc  := inSummCardSecondRecalc
                                                     , inSummCardSecondCash    := inSummCardSecondCash
                                                     , inSummAvCardSecondRecalc  := inSummAvCardSecondRecalc
                                                     , inSummNalogRecalc       := inSummNalogRecalc
                                                     , inSummNalogRetRecalc    := 0
                                                     , inSummMinus             := inSummMinus
                                                     , inSummAdd               := inSummAdd
                                                     , inSummAddOthRecalc      := inSummAddOthRecalc
                                                     , inSummHoliday           := inSummHoliday
                                                     , inSummSocialIn          := inSummSocialIn
                                                     , inSummSocialAdd         := inSummSocialAdd
                                                     , inSummChildRecalc       := inSummChildRecalc
                                                     , inSummMinusExtRecalc    := inSummMinusExtRecalc
                                                     , inSummFine              := inSummFine
                                                     , inSummFineOthRecalc     := inSummFineOthRecalc
                                                     , inSummHosp              := inSummHosp
                                                     , inSummHospOthRecalc     := inSummHospOthRecalc
                                                     , inSummCompensationRecalc:= inSummCompensationRecalc
                                                     , inSummAuditAdd          := inSummAuditAdd
                                                     , inSummHouseAdd          := inSummHouseAdd
                                                     , inSummAvanceRecalc      := inSummAvanceRecalc
                                                     , inNumber                := inNumber
                                                     , inComment               := inComment
                                                     , inInfoMoneyId           := inInfoMoneyId
                                                     , inUnitId                := inUnitId
                                                     , inPositionId            := inPositionId
                                                     , inMemberId              := inMemberId
                                                     , inPersonalServiceListId := inPersonalServiceListId
                                                     , inFineSubjectId         := inFineSubjectId
                                                     , inUnitFineSubjectId     := inUnitFineSubjectId
                                                     , inUserId                := vbUserId
                                                      ) AS tmp;


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRet(), ioId, inSummNalogRet);

     -- ��������  ���� zc_ObjectBoolean_PersonalServiceList_BankOut - ����������� ���� ����, ����� ��������� ����
     vbisBankOut := COALESCE ((SELECT ObjectBoolean_BankOut.ValueData
                               FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_BankOut
                                                            ON ObjectBoolean_BankOut.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                                           AND ObjectBoolean_BankOut.DescId   = zc_ObjectBoolean_PersonalServiceList_BankOut()
                               WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                                 AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                              ), FALSE);


     --RAISE EXCEPTION '������. %   % .', vbisBankOut, lfGet_Object_ValueData_sh (inPersonalServiceListId);

     --
     IF COALESCE (vbisBankOut, FALSE) = TRUE
     THEN
         IF COALESCE (ioBankOutDate, zc_DateStart()) <> zc_DateStart()
         THEN
             -- ��������� �������� <���� ������� �� �����>
             PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_BankOut(), ioId, ioBankOutDate);
         ELSE
             RAISE EXCEPTION '������.���� ������� ����� ������ ���� ���������.';
         END IF;
     ELSE
         -- ��������� �������� <���� ������� �� �����>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_BankOut(), ioId, NULL);
         ioBankOutDate := CAST (NULL AS TDateTime);
     END IF;


     outisAuto := FALSE;

     -- ��������� �������� ������ <������ �������������>
     IF NOT EXISTS (SELECT 1 FROM MovementItemBoolean WHERE MovementItemBoolean.DescId = zc_MIBoolean_isAuto() AND MovementItemBoolean.MovementItemId = ioId AND MovementItemBoolean.ValueData = FALSE)
     THEN
         -- ���������
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, FALSE);
         -- ��������
         PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, FALSE);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.05.23         *
 17.01.23         *
 23.12.21         * add inNumber
 17.11.21         * inSummHouseAdd
 06.05.21         * inUnitFineSubjectId
 19.11.20         * ioBankOutDate
 25.03.20         * inSummAuditAdd
 27.01.20         * inSummCompensationRecalc
 29.07.19         *
 25.06.18         * inSummAddOthRecalc
 05.01.18         * add inSummNalogRetRecalc
 20.06.17         * add inSummCardSecondCash
 24.02.17         *
 20.04.16         * inSummHoliday
 08.05.15         * add PersonalServiceList
 14.09.14                                        * add outAmountToPay
 02.10.14                                        * del inSummCard
 01.10.14         * add redmine 30.09
 14.09.14                                        * add out...
 11.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalService (ioId:= 0, inMovementId:= 258038 , inPersonalId:= 8473, inAmount:= 44, inSummService:= 20, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8426, inPositionId:=12431, inSession:= '2')
