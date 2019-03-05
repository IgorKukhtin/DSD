 -- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar
                                                       , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                       Integer   , -- ���� ������� <��������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inOperDatePartner          TDateTime , -- ���� ����(�����������)
    IN inInvNumberPartner         TVarChar  , -- ����� ���� (�����������)
 INOUT ioAmountIn                 TFloat    , -- ����� ����� (�� �������)
 INOUT ioAmountOut                TFloat    , -- ����� ������ (�� ��������)
 INOUT ioAmountCurrencyDebet      TFloat    , -- ����� ����� (� ������)
 INOUT ioAmountCurrencyKredit     TFloat    , -- ����� ������ (� ������)
    IN inCurrencyPartnerValue     TFloat    , -- ���� ��� ������� ����� �������� � ���
    IN inParPartnerValue          TFloat    , -- ������� ��� ������� ����� �������� � ���
    IN inMovementId_List          TVarChar  , -- ������ �� ��� ��� ������
    IN inComment                  TVarChar  , -- �����������
    IN inBusinessId               Integer   , -- ������
    IN inContractId               Integer   , -- �������
    IN inInfoMoneyId              Integer   , -- ������ ����������
    IN inJuridicalId              Integer   , -- ��. ����
    IN inPartnerId                Integer   , -- ����������
    IN inJuridicalBasisId         Integer   , -- ������� ��. ����
    IN inPaidKindId               Integer   , -- ���� ���� ������
    IN inUnitId                   Integer   , -- �������������
    IN inMovementId_Invoice       Integer   , -- �������� ����
    IN inAssetId                  Integer   , -- ��� ��
    IN inCurrencyPartnerId        Integer   , -- ������ (�����������)
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIndex Integer;
   DECLARE vbAmountCurrency TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service());

     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Service());


     -- ���� ������ �������
     IF COALESCE (inCurrencyPartnerId, 0) NOT IN (0, zc_Enum_Currency_Basis())
     THEN
         -- �������� ����� ��� - ����� (�� �������)
         ioAmountIn := CASE WHEN ioAmountCurrencyDebet <> 0
                            THEN ioAmountCurrencyDebet
                            ELSE 0
                        END
                        -- �� �����
                      * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                             ELSE inCurrencyPartnerValue
                        END;
         -- �������� ����� ��� - ������ (�� ��������)
         ioAmountOut:= CASE WHEN ioAmountCurrencyKredit <> 0
                            THEN ioAmountCurrencyKredit
                            ELSE 0
                        END
                        -- �� �����
                      * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                             ELSE inCurrencyPartnerValue
                        END;
         -- ������ - ����� � ������
         vbAmountCurrency := CASE WHEN ioAmountCurrencyDebet  <> 0 THEN  1 * ioAmountCurrencyDebet
                                  WHEN ioAmountCurrencyKredit <> 0 THEN -1 * ioAmountCurrencyKredit
                                  ELSE 0
                             END;
     ELSE
         ioAmountCurrencyDebet := 0;
         ioAmountCurrencyKredit:= 0;
     END IF;


     -- ��������
     IF COALESCE (ioAmountCurrencyDebet, 0) = 0 AND COALESCE (ioAmountCurrencyKredit, 0) = 0 AND COALESCE (inCurrencyPartnerId, 0) NOT IN (0, zc_Enum_Currency_Basis())
     THEN
        RAISE EXCEPTION '������� ����� � ������.';
     END IF;
     -- ��������
     IF COALESCE (ioAmountIn, 0) = 0 AND COALESCE (ioAmountOut, 0) = 0 AND COALESCE (inCurrencyPartnerId, 0) IN (0, zc_Enum_Currency_Basis())
     THEN
        RAISE EXCEPTION '������� �����.';
     END IF;
     -- ��������
     IF COALESCE (ioAmountIn, 0) <> 0 AND COALESCE (ioAmountOut, 0) <> 0 THEN
        RAISE EXCEPTION '������ ���� ������� ������ ���� �����: <�����> ��� <������>.';
     END IF;
     -- ��������
     IF COALESCE (ioAmountCurrencyDebet, 0) <> 0 AND COALESCE (ioAmountCurrencyKredit, 0) <> 0 THEN
        RAISE EXCEPTION '������ ���� ������� ������ ���� ����� � ������: <�����> ��� <������>.';
     END IF;
     -- ��������
     IF (COALESCE (inJuridicalId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <����������� ����>.';
     END IF;
     -- ��������
     IF inPaidKindId = zc_Enum_PaidKind_SecondForm() AND (COALESCE (inPartnerId, 0) = 0)
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalId AND DescId = zc_ObjectLink_Partner_Juridical() GROUP BY ChildObjectId HAVING COUNT(*) = 1)
     THEN
         RAISE EXCEPTION '������. ��� ����� ������ <%> ������ ���� ���������� <����������>.', lfGet_Object_ValueData (inPaidKindId);
     END IF;


     -- ������ ����� � ���
     IF ioAmountIn <> 0
     THEN
        vbAmount := ioAmountIn;
     ELSE
        vbAmount := -1 * ioAmountOut;
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Service())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Service(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_MovementId(), ioId, inMovementId_List);
     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     -- ��������� ����� � <������ (�����������) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);
     -- ��������� �������� <���� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- ��������� �������� <������� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);
     -- ��������� �������� <����� �������� (� ������)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), ioId, vbAmountCurrency);


     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), CASE WHEN inPartnerId <> 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN inPartnerId ELSE inJuridicalId END, ioId, vbAmount, NULL);

     -- �����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- ��������� ����� � <���� ���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);
     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);

     -- ��������� ����� � <��� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), vbMovementItemId, inAssetId);

     -- ��������� ����� � <���� ������� ���������>
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), vbMovementItemId, inContractConditionKindId);


     --- ��������� ����� � ���������� ������ �� ����������
     -- �������
     CREATE TEMP TABLE tmp_List (MovementId Integer) ON COMMIT DROP;
     -- ������
     vbIndex := 1;
     WHILE SPLIT_PART (inMovementId_List, ',', vbIndex) <> '' LOOP
         -- ��������� �� ��� �����
         INSERT INTO tmp_List (MovementId) SELECT SPLIT_PART (inMovementId_List, ',', vbIndex) :: Integer;
         -- ������ ����������
         vbIndex := vbIndex + 1;
     END LOOP;

     -- ��������� <�������� ������> , ���� ������ ��� ���
     PERFORM lpInsertUpdate_Movement_IncomeCost (ioId         := 0
                                               , inParentId   := tmp_List.MovementId -- ��� ������
                                               , inMovementId := ioId                -- ��� �����
                                               , inComment    := ''::TVarChar
                                               , inUserId     := vbUserId
                                                )
     FROM tmp_List
       LEFT JOIN (SELECT Movement.Id, tmp_List.MovementId AS ParentId
                  FROM tmp_List
                     INNER JOIN Movement on tmp_List.MovementId = Movement.ParentId
                     INNER JOIN MovemenTFloat AS MovemenTFloat_MovementId
                                              ON MovemenTFloat_MovementId.MovementId = Movement.Id
                                             AND MovemenTFloat_MovementId.DescId = zc_MovemenTFloat_MovementId()
                                             AND MovemenTFloat_MovementId.ValueData = ioId
                  WHERE tmp_List.MovementId <> 0
                  ) as tmp on tmp.ParentId =  tmp_List.MovementId
     WHERE tmp.Id isnull AND tmp_List.MovementId <> 0;

     -- ����� �� �������� ���.������ � �������� �� �� ������
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId)
     FROM (SELECT Movement.ParentId
                , MovemenTFloat.MovementId
           FROM MovemenTFloat
              LEFT JOIN Movement ON Movement.Id = MovemenTFloat.Movementid
           WHERE MovemenTFloat.DescId = zc_MovemenTFloat_MovementId()
             AND MovemenTFloat.ValueData ::Integer = ioId
           ) AS tmp
           LEFT JOIN tmp_List ON tmp_List.MovementId = tmp.ParentId
     WHERE tmp_List.MovementId Isnull;
     ---------------------

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
          PERFORM lpComplete_Movement_Service (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 01.08.17         *
 27.08.16         * add asset
 29.04.16         *
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 24.09.14                                        * add inPartnerId
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 10.05.14                                        * add lpInsert_MovementItemProtocol
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 17.03.14         * add zc_MovementDate_OperDatePartner, zc_MovementString_InvNumberPartner
 19.01.14         * del ContractConditionKind
 28.01.14         * add ContractConditionKind
 22.01.14                                        * add IsMaster
 26.12.13                                        * add lpComplete_Movement_Service
 24.12.13                        *
 11.08.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Service (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inJuridicalId:= 1, inJuridicalBasisId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inSession:= '2')
