-- Function: lpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ���� �������
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inServiceDate         TDateTime , -- ���� ����������
    IN inAmountIn            TFloat    , -- ����� �������
    IN inAmountOut           TFloat    , -- ����� �������
    IN inComment             TVarChar  , -- �����������
    IN inCashId              Integer   , -- �����
    IN inMoneyPlaceId        Integer   , -- ������� ������ � ��������
    IN inPositionId          Integer   , -- ���������
    IN inContractId          Integer   , -- ��������
    IN inInfoMoneyId         Integer   , -- �������������� ������
    IN inMemberId            Integer   , -- ��� ���� (����� ����)
    IN inUnitId              Integer   , -- �������������
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- ��������
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


     -- ���������� ���� �������
-- 280297;9;"����� ����";f;"���";"������ ����";"��� ����";"";"���"
-- 280298;10;"����� ��������";f;"���";"������ ��������";"��� ����";"";"���"

     vbAccessKeyId:= CASE WHEN inCashId = 296540 -- ����� ����� ��
                               THEN zc_Enum_Process_AccessKey_CashOfficialDnepr()
                          WHEN inCashId = 14686 -- ����� ����
                               THEN zc_Enum_Process_AccessKey_CashKiev()
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
                          ELSE zc_Enum_Process_AccessKey_CashDnepr() -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Cash())
                     END;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Cash(), inInvNumber, inOperDate, inParentId, vbAccessKeyId);


     -- ����� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCashId, ioId, vbAmount, NULL);


     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
    
     -- ��������� ����� � <���� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);
     -- �����������
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

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 29.08.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
