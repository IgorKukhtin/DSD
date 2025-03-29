 -- Function: lpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/

/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/

/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);  */
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inPersonalId             Integer   , -- ����������
    IN inisMain                 Boolean   , -- �������� ����� ������
   OUT outAmount                TFloat    , -- ***����� (�������)
   OUT outAmountToPay           TFloat    , -- ***����� � ������� (����)
   OUT outAmountCash            TFloat    , -- ***����� � ������� �� �����
   OUT outSummTransport         TFloat    , -- ***����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)
   OUT outSummTransportAdd      TFloat    , -- ***����� ��������������� (�������)
   OUT outSummTransportAddLong  TFloat    , -- ***����� ������������ (�������, ���� ���������������)
   OUT outSummTransportTaxi     TFloat    , -- ***����� �� ����� (�������)
   OUT outSummPhone             TFloat    , -- ***����� ���.����� (���������)

    IN inSummService            TFloat    , -- ����� ���������
    IN inSummCardRecalc         TFloat    , -- ����� �� (����) - 1�.
    IN inSummCardSecondRecalc   TFloat    , -- ����� �� (����) - 2�.
    IN inSummCardSecondCash     TFloat    , -- ����� �� (�����) - 2�.
    IN inSummAvCardSecondRecalc TFloat    , -- ����� �� (����) - 2�. �����
    IN inSummNalogRecalc        TFloat    , -- ������ - ��������� � �� (����)
    IN inSummNalogRetRecalc     TFloat    , -- ������ - ���������� � �� (����)
    IN inSummMinus              TFloat    , -- ����� ���������
    IN inSummAdd                TFloat    , -- ����� ������
    IN inSummAddOthRecalc       TFloat    , -- ����� ������ (���� ��� �������������)
    
    IN inSummHoliday            TFloat    , -- ����� ���������    
    IN inSummSocialIn           TFloat    , -- ����� ��� ������� (�� ��������)
    IN inSummSocialAdd          TFloat    , -- ����� ��� ������� (���. ��������)
    IN inSummChildRecalc        TFloat    , -- �������� - ��������� (����)
    IN inSummMinusExtRecalc     TFloat    , -- ��������� ������. ��.�. (����)
    IN inSummFine               TFloat    , -- �����
    IN inSummFineOthRecalc      TFloat    , -- ����� (���� ��� �������������)
    IN inSummHosp               TFloat    , -- ����������
    IN inSummHospOthRecalc      TFloat    , -- ���������� (���� ��� �������������)
    IN inSummCompensationRecalc TFloat    , -- ����������� ���� (����)
    IN inSummAuditAdd           TFloat    , -- ����� ������� �� �����
    IN inSummHouseAdd           TFloat    , -- ����� ����������� ����� 
    IN inSummAvanceRecalc       TFloat    , -- ����� ������
    
    IN inNumber                 TVarChar  , -- � ��������������� �����
    IN inComment                TVarChar  , --
    IN inInfoMoneyId            Integer   , -- ������ ����������
    IN inUnitId                 Integer   , -- �������������
    IN inPositionId             Integer   , -- ���������
    IN inMemberId               Integer   , -- ��� ���� (���� ��������� ��������)
    IN inPersonalServiceListId  Integer   , -- ��������� ����������
    IN inFineSubjectId          Integer   , -- ��� ���������
    IN inUnitFineSubjectId      Integer   , -- ��� ���������� ���������
    IN inUserId                 Integer     -- ������������
)                               
RETURNS RECORD AS               
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAccessKeyId Integer;

   DECLARE vbServiceDateId Integer;
   DECLARE vbisDetail Boolean;
   DECLARE vbPersonalServiceListId Integer;
BEGIN
     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- ��������
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <��� (���������)> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inSummService);
     END IF;
     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0 -- AND inSummService <> 0
     THEN
         IF inSummService = 0 THEN RETURN; END IF;
         RAISE EXCEPTION '������.�� ��������� �������� <�� ������> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inSummService);
     END IF;
     -- ��������
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <�������������> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inSummService);
     END IF;
     -- ��������
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <���������> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inSummService);
     END IF;

     -- �������� - ������������� !!!���� ��� ��!!!
     IF NOT EXISTS (SELECT ObjectLink_PersonalServiceList_PaidKind.ChildObjectId
                FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                     INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
                                          AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                  AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
               )
     THEN
         IF inSummCardRecalc <> 0
         THEN
             RAISE EXCEPTION '������.���� <����� �� (����) - 1�.> ����������� ������ ��� ��������� ��.';
         END IF;
         IF inSummCardSecondRecalc <> 0
         THEN
             RAISE EXCEPTION '������.���� <����� �� (����) - 2�.> ����������� ������ ��� ��������� ��.';
         END IF;
         IF inSummAvCardSecondRecalc <> 0
         THEN
             RAISE EXCEPTION '������.���� <����� �� (����) - 2�. �����> ����������� ������ ��� ��������� ��.';
         END IF;
         IF inSummNalogRecalc <> 0
         THEN
             RAISE EXCEPTION '������.���� <������ - ��������� (����)> ����������� ������ ��� ��������� ��.';
         END IF;
         IF inSummChildRecalc <> 0
         THEN
             RAISE EXCEPTION '������.���� <�������� - ��������� (����)> ����������� ������ ��� ��������� ��.';
         END IF;
         IF inSummMinusExtRecalc <> 0
         THEN
             RAISE EXCEPTION '������.���� <��������� ������. ��.�. (����)> ����������� ������ ��� ��������� ��.';
         END IF;
     END IF;



     -- �������� ���������� zc_MILinkObject_FineSubject - �� ������ ��� ��������� � ��������� zc_ObjectBoolean_PersonalServiceList_Detail  = TRUE 
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
     IF (COALESCE (inFineSubjectId,0) <> 0 OR COALESCE (inUnitFineSubjectId,0) <> 0) AND vbisDetail = FALSE
     THEN
         RAISE EXCEPTION '������.��� ������� ��������� ��� ����������� ������.';
     END IF;


     -- !!!�����!!!
     -- ���������� ���� �������
     vbAccessKeyId:= CASE WHEN EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
                               AND NOT EXISTS (SELECT 1
                                               FROM ObjectLink
                                                    INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                                                                                   AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                               WHERE ObjectLink.DescId   = zc_ObjectLink_PersonalServiceList_Member()
                                                 AND ObjectLink.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList())
                                              )
                        -- THEN zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                        THEN lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalService(), vbPersonalServiceListId)
                        ELSE
                     lpGetAccessKey (COALESCE ((SELECT ObjectLink_User_Member.ObjectId
                                                FROM ObjectLink
                                                     INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                                                                                    AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                                 WHERE ObjectLink.DescId = zc_ObjectLink_PersonalServiceList_Member()
                                                   AND ObjectLink.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList())
                                                 LIMIT 1
                                               ), inUserId)
                                   , zc_Enum_Process_InsertUpdate_Movement_PersonalService()
                                   , vbPersonalServiceListId
                                    )
                     END;
     -- !!!�����!!!
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = inMovementId;

     -- �����
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     -- �����
     SELECT -- ����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)
            SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.Amount ELSE 0 END) AS SummTransport
            -- ����� ��������������� (�������)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add()        THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAdd
            -- ����� ������������ (�������, ���� ���������������)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_AddLong()    THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAddLong
            -- ����� �� ����� (�������)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Taxi()       THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportTaxi
            -- ����� ���.����� (���������)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_MobileBills_Personal() THEN  1 * MIContainer.Amount ELSE 0 END) AS SummPhone
            INTO outSummTransport, outSummTransportAdd, outSummTransportAddLong, outSummTransportTaxi, outSummPhone
     FROM ContainerLinkObject AS CLO_ServiceDate
          INNER JOIN ContainerLinkObject AS CLO_Personal
                                         ON CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                        AND CLO_Personal.ObjectId = inPersonalId
          INNER JOIN ContainerLinkObject AS CLO_Position
                                         ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                        AND CLO_Position.ObjectId = inPositionId
          INNER JOIN ContainerLinkObject AS CLO_Unit
                                         ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                        AND CLO_Unit.ObjectId = inUnitId
          INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                         ON CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                        AND CLO_InfoMoney.ObjectId = inInfoMoneyId
          INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                         ON CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
          INNER JOIN MovementLinkObject AS MLO
                                        ON MLO.MovementId = inMovementId
                                       AND MLO.ObjectId = CLO_PersonalServiceList.ObjectId
                                       AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()
          INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = CLO_Personal.ContainerId
                                                         -- AND MIContainer.MovementDescId = zc_Movement_Income()
     WHERE CLO_ServiceDate.ObjectId = vbServiceDateId
       AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate();


     -- ������������ ����� (�������)
     outAmount:= COALESCE (inSummService, 0) - COALESCE (inSummMinus, 0) - COALESCE (inSummFine, 0)
               + COALESCE (inSummAdd, 0) + COALESCE (inSummHoliday, 0) + COALESCE (inSummHosp, 0) + COALESCE (inSummAuditAdd, 0)-- - COALESCE (inSummSocialIn, 0);
               + COALESCE (inSummHouseAdd, 0)  -- "����" ����������� �����
                 -- "����" <������ (������������)>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummAddOth()), 0)
                 -- "�����" <����� (������������)>
               - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummFineOth()), 0)
                 -- "����" <�������� (������������)>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummHospOth()), 0)
                 -- "����" <�����������(������������)>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCompensation()), 0)
                 -- "����" <�� ������������>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummMedicdayAdd()), 0)
                 -- "�����" <�� ������>
               - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummSkip()), 0)
                ;
     -- ������������ ����� � �������
     outAmountToPay:= COALESCE (inSummService, 0) - COALESCE (inSummMinus, 0) - COALESCE (inSummFine, 0)
                    + COALESCE (inSummAdd, 0) + COALESCE (inSummHoliday, 0)  + COALESCE (inSummHosp, 0) + COALESCE (inSummSocialAdd, 0) + COALESCE (inSummAuditAdd, 0)
                    + COALESCE (inSummHouseAdd, 0)  -- "����" ����������� �����
                    - COALESCE (outSummTransport, 0) + COALESCE (outSummTransportAdd, 0) + COALESCE (outSummTransportAddLong, 0) + COALESCE (outSummTransportTaxi, 0)
                    - COALESCE (outSummPhone, 0)
                      -- "����" <������ (������������)>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummAddOth()), 0)
                      -- "�����" <������ - ��������� � ��>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummNalog()), 0)
                      -- "����" <������ - ���������� � ��>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummNalogRet()), 0)    --
                      -- "�����" <�������� - ���������>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChild()), 0)
                      -- "�����" <��������� ������. ��.�.>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummMinusExt()), 0)
                      -- "�����" <����� (������������)>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummFineOth()), 0)
                      -- "����" <�������� (������������)>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummHospOth()), 0)
                      -- "����"" <�����������(������������)>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCompensation()), 0)
                      -- "����" <�� ������������>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummMedicdayAdd()), 0)
                      -- "�����" <�� ������>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummSkip()), 0)
                     ;
     -- ������������ ����� � ������� �� �����
     outAmountCash:= outAmountToPay
                     -- "�����" <����� �� - 1�.>
                   - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCard()), 0)
                     -- "�����" <����� �� - 2�.>
                   - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCardSecond()), 0)
                     -- "�����" <����� �� (�����) - 2�.>
                   - inSummCardSecondCash
                    ;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, outAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummToPay(), ioId, outAmountToPay);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummService(), ioId, inSummService);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardRecalc(), ioId, inSummCardRecalc);

     -- ��������� �������� <����� �� (����) - 2�.>
   --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondRecalc(), ioId, inSummCardSecondRecalc);
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondRecalc(), ioId, ROUND (inSummCardSecondRecalc, 1));
     IF COALESCE (inSummCardSecondRecalc, 0) = 0
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecond_num(), ioId, 0);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondTwo_num(), ioId, 0);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondDiff_num(), ioId, 0);
     END IF;

     -- ��������� �������� <����� �� (����������) - 2�>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondDiff(), ioId, inSummCardSecondRecalc - ROUND (inSummCardSecondRecalc, 1));
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondCash(), ioId, inSummCardSecondCash);
     -- ��������� �������� <����� �� (����) - 2�.> �����
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvCardSecondRecalc(), ioId, inSummAvCardSecondRecalc);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRecalc(), ioId, inSummNalogRecalc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRetRecalc(), ioId, inSummNalogRetRecalc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinus(), ioId, inSummMinus);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd(), ioId, inSummAdd );
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAuditAdd(), ioId, inSummAuditAdd );
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAddOthRecalc(), ioId, inSummAddOthRecalc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHoliday(), ioId, inSummHoliday );
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialIn(), ioId, inSummSocialIn);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialAdd(), ioId, inSummSocialAdd);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHouseAdd(), ioId, inSummHouseAdd);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Main(), ioId, inisMain);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChildRecalc(), ioId, inSummChildRecalc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinusExtRecalc(), ioId, inSummMinusExtRecalc);
     -- ��������� �������� <����������� (���� ��� �������������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensationRecalc(), ioId, inSummCompensationRecalc);

     -- ��������� �������� <����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransport(), ioId, COALESCE (outSummTransport, 0));
     -- ��������� �������� <����� ��������������� (�������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAdd(), ioId, COALESCE (outSummTransportAdd, 0));
     -- ��������� �������� <����� ������������ (�������, ���� ���������������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAddLong(), ioId, COALESCE (outSummTransportAddLong, 0));
     -- ��������� �������� <����� �� ����� (�������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportTaxi(), ioId, COALESCE (outSummTransportTaxi, 0));
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPhone(), ioId, COALESCE (outSummPhone, 0));

     -- ��������� �������� <�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFine(), ioId, inSummFine);
     -- ��������� �������� <����� (���� ��� �������������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFineOthRecalc(), ioId, inSummFineOthRecalc);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHosp(), ioId, inSummHosp);
     -- ��������� �������� <���������� (���� ��� �������������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHospOthRecalc(), ioId, inSummHospOthRecalc);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvanceRecalc(), ioId, COALESCE (inSummAvanceRecalc, 0));

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Number(), ioId, inNumber);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Member(), ioId, inMemberId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_FineSubject(), ioId, inFineSubjectId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_UnitFineSubject(), ioId, inUnitFineSubjectId);
     
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
 23.12.21         * inNumber
 06.05.21         * inUnitFineSubjectId
 28.04.21         * inFineSubjectId
 25.03.20         * inSummAuditAdd
 27.01.20         * add inSummCompensationRecalc
 15.10.19         * ������ inSummFine, inSummHosp �� inSummFineRecalc, inSummHospRecalc
 29.07.19         * inSummFine, inSummHosp
 25.06.18         * inSummAddOthRecalc
 05.01.18         * add inSummNalogRetRecalc
 20.06.17         * add inSummCardSecondCash
 24.02.17         * add SummMinusExtRecalc, CHANGE inSummChild on inSummChildRecalc
 20.02.17         * inSummCardSecondRecalc
 20.04.16         * inSummHoliday
 07.05.15         * add PersonalServiceList
 02.10.14                                        * del inSummCard
 01.10.14         * add redmine 30.09
 14.09.14                                        * add out...
 11.09.14         *
*/

-- ����
-- 