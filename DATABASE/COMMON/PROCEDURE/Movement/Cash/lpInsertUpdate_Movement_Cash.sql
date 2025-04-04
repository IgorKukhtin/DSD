-- Function: lpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash(
 INOUT ioId                    Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ���� �������
    IN inInvNumber             TVarChar  , -- ����� ���������
    IN inOperDate              TDateTime , -- ���� ���������
    IN inServiceDate           TDateTime , -- ����� ����������
    IN inAmountIn              TFloat    , -- ����� �������
    IN inAmountOut             TFloat    , -- ����� �������
    IN inAmountSumm            TFloat    , -- C���� ���, �����
    IN inAmountCurrency        TFloat    , -- ����� � ������
    IN inComment               TVarChar  , -- ����������
    IN inCarId                 Integer   , -- ����������
    IN inCashId                Integer   , -- �����
    IN inMoneyPlaceId          Integer   , -- ������� ������ � ��������
    IN inPositionId            Integer   , -- ���������
    IN inContractId            Integer   , -- ��������
    IN inInfoMoneyId           Integer   , -- �������������� ������
    IN inMemberId              Integer   , -- ��� ���� (����� ����)
    IN inUnitId                Integer   , -- �������������
    IN inCurrencyId            Integer   , -- ������
    IN inCurrencyValue         TFloat    , -- ���� ��� �������� � ������ �������
    IN inParValue              TFloat    , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerId     Integer   , -- ������
    IN inCurrencyPartnerValue  TFloat    , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue       TFloat    , -- ������� ��� ������� ����� ��������
    IN inMovementId_Partion    Integer   , -- Id ��������� �������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbPersonalId_find Integer;
   DECLARE vbUnitId_find Integer;
   DECLARE vbPositionId_find Integer;
   DECLARE vbCurrencyPartnerId Integer;
BEGIN
     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- ��������, !!!������ ���� ��� �� �������� �� ���������!!!
     IF (COALESCE (inAmountIn, 0) = 0) AND (COALESCE (inAmountOut, 0) = 0) AND COALESCE (inParentId, 0) = 0 THEN
        RAISE EXCEPTION '������.������� �����.';
     END IF;
     -- ��������
     IF (COALESCE (inAmountIn, 0) <> 0) AND (COALESCE (inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION '������.������ ���� ������� ������ ���� �����: <������> ��� <������>.';
     END IF;
     -- �������� + !!!�������� ��� ������ ����!!!
     IF COALESCE (inInfoMoneyId, 0) = 0 AND (inUserId <> 5) THEN
        RAISE EXCEPTION '������.������ ���� ������� �������� <�� ������ ����������>.';
     END IF;
     -- ��������
     IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inUnitId AND Object.ValueData ILIKE '%���������%') 
        AND COALESCE (inCarId, 0) = 0 AND inInfoMoneyId = zc_Enum_InfoMoney_20101()
     THEN
        RAISE EXCEPTION '������.������ ���� ������� �������� <����������>.';
     END IF;
     -- ��������
     IF EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_80300()) -- ������� � �����������
     THEN
         IF COALESCE (inMoneyPlaceId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <�� ����, ����> ������ ���� ���������.';
         END IF;
         IF EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Founder())
           AND NOT EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inMoneyPlaceId AND DescId = zc_ObjectLink_Founder_InfoMoney() AND ChildObjectId = inInfoMoneyId)
         THEN
             RAISE EXCEPTION '������.�������� <�� ������ ����������> ������ �������������� �������� <�� ����, ����>.';
         END IF;
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId IN (zc_Object_Partner(), zc_Object_Juridical()))
     THEN
         RAISE EXCEPTION '������.�������� <�������> ������ ���� ���������.';
     END IF;

     -- ��������
     /*IF EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_60000()) -- ���������� �����
     THEN
         IF inOperDate < '01.09.2014' AND inServiceDate < '01.08.2014' AND 1 = 0
         THEN
             IF inMoneyPlaceId <> 0 THEN
               RAISE EXCEPTION '������.��� ������� ������� �������� <�� ����, ����> ������ ���� ������.';
             END IF;
         ELSE
             IF NOT EXISTS (SELECT PersonalId FROM Object_Personal_View WHERE PersonalId = inMoneyPlaceId)
             THEN
                 RAISE EXCEPTION '������.�������� <�� ����, ����> ������ ��������� ��� ����������.';
             END IF;
             IF COALESCE (inPositionId, 0) = 0
             THEN
               RAISE EXCEPTION '������.�� ����������� �������� <���������>.';
             END IF;
         END IF;
     END IF;*/

     -- ������
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- ����������
     IF inCurrencyPartnerId > 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Cash())
     THEN
        vbCurrencyPartnerId:= inCurrencyPartnerId;
     ELSEIF COALESCE (inCurrencyId, 0) NOT IN (0, zc_Enum_Currency_Basis())
     THEN
        vbCurrencyPartnerId:= inCurrencyPartnerId;
     ELSE
        vbCurrencyPartnerId:= COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_Currency())
                                      , zc_Enum_Currency_Basis());
     END IF;

     -- ���������� ���� �������
-- 280297;9;"����� ����";f;"���";"������ ����";"��� ����";"";"���"
-- 280298;10;"����� ��������";f;"���";"������ ��������";"��� ����";"";"���"

     vbAccessKeyId:= CASE WHEN inCashId = 296540 -- ����� ����� ��
                               THEN zc_Enum_Process_AccessKey_CashOfficialDnepr()
                          WHEN inCashId = 14686 -- ����� ����
                               THEN zc_Enum_Process_AccessKey_CashKiev()
                          WHEN inCashId = 3259636 -- ����� �����
                               THEN zc_Enum_Process_AccessKey_CashLviv()
                          WHEN inCashId = 279788 -- ����� ������ ���
                               THEN zc_Enum_Process_AccessKey_CashKrRog()
                          WHEN inCashId = 279789 -- ����� ��������
                               THEN zc_Enum_Process_AccessKey_CashNikolaev()
                          WHEN inCashId = 279790 -- ����� �������
                               THEN zc_Enum_Process_AccessKey_CashKharkov()
                          WHEN inCashId = 279791 -- ����� ��������
                               THEN zc_Enum_Process_AccessKey_CashCherkassi()
                          WHEN inCashId = 280185 -- ����� ������
                               THEN zc_Enum_Process_AccessKey_CashDoneck()
                          WHEN inCashId = 280296 -- ����� ������
                               THEN zc_Enum_Process_AccessKey_CashOdessa()
                          WHEN inCashId = 301799 -- ����� ���������
                               THEN zc_Enum_Process_AccessKey_CashZaporozhye()
                          WHEN inCashId = 8073040 -- ����� ����
                               THEN zc_Enum_Process_AccessKey_CashIrna()
                          WHEN inCashId = 11921030-- ����� �������
                               THEN zc_Enum_Process_AccessKey_CashVinnica()

                          ELSE zc_Enum_Process_AccessKey_CashDnepr() -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Cash())
                     END;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Cash(), inInvNumber, inOperDate, inParentId, vbAccessKeyId, inUserId);


     IF EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Personal())
        AND (inInfoMoneyId = zc_Enum_InfoMoney_60101() -- ���������� �����
          OR inServiceDate >= '01.01.2019'
            )
     THEN
         -- ���� ������������ "�� �����������", ���������� - ������� �� �����
         vbPersonalServiceListId:= (SELECT ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                    WHERE ObjectLink_Personal_PersonalServiceList.ObjectId = inMoneyPlaceId
                                      AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                   );
         -- ���� ������������ "��� �������", ���������� - ������� �� �����
         /*vbPersonalServiceListId:= (SELECT MLO_PersonalServiceList.ObjectId
                                    FROM (SELECT inServiceDate AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '1 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '2 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '3 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '4 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '5 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '6 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '7 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '8 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '9 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '10 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '11 MONTH' AS ServiceDate
                                         UNION
                                          SELECT inServiceDate - INTERVAL '12 MONTH' AS ServiceDate
                                         ) AS tmpDate
                                         INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                                 ON MovementDate_ServiceDate.ValueData = tmpDate.ServiceDate
                                                                AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                                         INNER JOIN MovementItem ON MovementItem.MovementId = MovementDate_ServiceDate.MovementId
                                                                AND MovementItem.DescId = zc_MI_Master()
                                                                AND MovementItem.ObjectId = inMoneyPlaceId
                                                                AND MovementItem.isErased = FALSE
                                                                AND MovementItem.Amount <> 0
                                         INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                                          AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
                                         INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                          AND MILinkObject_Unit.ObjectId = inUnitId
                                         INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                           ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                                          AND MILinkObject_Position.ObjectId = inPositionId

                                         INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                                         INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                       ON MLO_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                                      AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                                      -- AND MLO_PersonalServiceList.ObjectId <> 298695
                                    ORDER BY MovementDate_ServiceDate.ValueData DESC, MovementItem.Amount DESC
                                    LIMIT 1
                                   );*/
         -- ��������
         IF COALESCE (vbPersonalServiceListId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� <��������� ���������� ��������>.';
         END IF;
         
         -- ��������
         SELECT lfSelect.PersonalId, lfSelect.UnitId, lfSelect.PositionId
                 INTO vbPersonalId_find, vbUnitId_find, vbPositionId_find
         FROM lfSelect_Object_Member_findPersonal (inUserId :: TVarChar) AS lfSelect
         WHERE lfSelect.PersonalId = inMoneyPlaceId;
         
         -- ��������
         IF COALESCE (vbPersonalId_find, 0) = 0
         THEN
             RAISE EXCEPTION '������.������ ������� ���������� <%> %� ���������� <%>.%����� ������� ������ �������� ����� ������.', lfGet_Object_ValueData_sh (inMoneyPlaceId), CHR (13), lfGet_Object_ValueData_sh (inPositionId), CHR (13);
         END IF;
         -- ��������
         IF COALESCE (vbUnitId_find, 0) <> inUnitId
         THEN
             RAISE EXCEPTION '������.��� ���������� <%> %��������� ������� ������������� <%>.%������� <%>.', lfGet_Object_ValueData_sh (inMoneyPlaceId), CHR (13), lfGet_Object_ValueData_sh (vbUnitId_find), CHR (13), lfGet_Object_ValueData_sh (inUnitId);
         END IF;
         -- ��������
         IF COALESCE (vbPositionId_find, 0) <> inPositionId
         THEN
             RAISE EXCEPTION '������.��� ���������� <%> %��������� ������� ��������� <%>.%������� <%>.', lfGet_Object_ValueData_sh (inMoneyPlaceId), CHR (13), lfGet_Object_ValueData_sh (vbPositionId_find), CHR (13), lfGet_Object_ValueData_sh (inPositionId);
         END IF;


         --
         IF inUserId <> 14599 -- ���������� �.�.
        --AND inUserId = 5
        --AND 1=0
        AND NOT EXISTS (SELECT 1
                        FROM MovementDate
                             INNER JOIN Movement ON Movement.Id       = MovementDate.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                                AND Movement.DescId   = zc_Movement_PersonalService()
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.ObjectId   = inMoneyPlaceId
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                           ON MLO_PersonalServiceList.MovementId = MovementDate.MovementId
                                                          AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                          AND MLO_PersonalServiceList.ObjectId   = vbPersonalServiceListId
                        WHERE MovementDate.ValueData = inServiceDate
                          AND MovementDate.DescId    = zc_MIDate_ServiceDate()
                       )
         THEN
             RAISE EXCEPTION '������.�� ������� ��������� ���������� <%> �� <%> % <%>.'
                           , lfGet_Object_ValueData_sh (vbPersonalServiceListId)
                           , zfCalc_MonthYearName (inServiceDate)
                           , CHR (13)
                           , lfGet_Object_ValueData_sh (inMoneyPlaceId)
                            ;
         END IF;

         -- ��������� ����� � <��������� ����������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, vbPersonalServiceListId);
     ELSE
         -- �������� ����� � <��������� ����������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, NULL);
     END IF;


     -- C���� ���, �����
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmountSumm);
     -- ����� � ������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), ioId, inAmountCurrency);
     -- ���� ��� �������� � ������ �������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ������� ��� �������� � ������ �������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);
     -- ���� ��� ������� ����� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- ������� ��� ������� ����� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);

     -- ����� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCashId, ioId, vbAmount, NULL);


     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);

     -- ��������� �������� <���� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- ��������� ����� � <��� ���� (����� ����)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Member(), vbMovementItemId, inMemberId);
     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), vbMovementItemId, inPositionId);
     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), vbMovementItemId, inCurrencyId);
     -- ��������� ����� � <������� �����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CurrencyPartner(), vbMovementItemId, vbCurrencyPartnerId);
     -- ��������� ����� � <����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), vbMovementItemId, inCarId);

     -- ��������� �������� <id ��������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbMovementItemId, inMovementId_Partion);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 01.09.18         * add Car
 21.05.17         * add inCurrencyPartnerId
 27.04.15         add MovementId_Partion
 29.08.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
