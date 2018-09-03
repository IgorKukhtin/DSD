-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash (Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inAmountIn             TFloat    , -- ����� �������
    IN inAmountOut            TFloat    , -- ����� �������
    IN inAmountSumm           TFloat    , -- C���� ���, �����
    IN inComment              TVarChar  , -- �����������
    IN inCarId                Integer   , -- ����������
    IN inCashId               Integer   , -- �����
    IN inMoneyPlaceId         Integer   , -- ������� ������ � ��������
    IN inPositionId           Integer   , -- ���������
    IN inMemberId             Integer   , -- ��� ���� (����� ����)
    IN inContractId           Integer   , -- ��������
    IN inInfoMoneyId          Integer   , -- �������������� ������
    IN inUnitId               Integer   , -- �������������
    IN inMovementId_Invoice   Integer   , -- �������� ����

    IN inCurrencyId           Integer   , -- ������
   OUT outCurrencyValue       TFloat    , -- ���� ��� �������� � ������ �������
   OUT outParValue            TFloat    , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerId    Integer   , -- ������
    IN inCurrencyPartnerValue TFloat    , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue      TFloat    , -- ������� ��� ������� ����� ��������
    IN inMovementId_Partion   Integer   , -- Id ��������� �������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmount TFloat;
   DECLARE vbAmountIn TFloat;
   DECLARE vbAmountOut TFloat;
   DECLARE vbAmountCurrency TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());


     -- ��������� ��� �������� �� ������ ������
     IF EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_CashReplace() AND UserId = vbUserId)
        AND (NOT (inOperDate BETWEEN zc_DateStart_Role_CashReplace() AND zc_DateEnd_Role_CashReplace())
          OR inCashId    <> 14462 -- ����� �����
          OR inAmountOut <> 0
            )
     THEN
         RAISE EXCEPTION '������.��� ���� �� ��������� ������ ��� <%>.', lfGet_Object_ValueData (vbUserId);
     END IF;


     -- ��������
     IF COALESCE (inMovementId_Invoice, 0) = 0 AND EXISTS (SELECT 1 FROM Object_InfoMoney_View AS View_InfoMoney WHERE View_InfoMoney.InfoMoneyId = inInfoMoneyId AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()) -- ����������
     THEN
        RAISE EXCEPTION '������.��� �� ������ <%> ���������� ��������� �������� <� ���. ����>.', lfGet_Object_ValueData (inInfoMoneyId);
     END IF;
     -- �������� ��� ���� �� �������
     IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId_Invoice AND MB.DescId = zc_MovementBoolean_Closed() AND MB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION '������.���� � <%> �� <%> ��� �������� �������.�������� ������.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Invoice), DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Invoice));
     END IF;


     -- 1. ����  update
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Cash())
     THEN
         -- ��������
         IF EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND ParentId <> 0)
         THEN
             RAISE EXCEPTION '������.�������� � <%> ����� ���������������� ������ ����� <����� ������� ��>.', inInvNumber;
         END IF;

         -- 1. ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������
     IF COALESCE (inCurrencyId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <������> �� ����������.';
     END IF;
     -- ��������
     IF inCurrencyId = zc_Enum_Currency_Basis() AND inAmountSumm <> 0
     THEN
         RAISE EXCEPTION '������.�������� <������> ��� ����� ������ �� ����������.';
     END IF;
     -- ��������
     IF inAmountSumm < 0
     THEN
         RAISE EXCEPTION '������.�������� <C���� ���, �����> �� ����������.';
     END IF;

     -- ����� ��� ������� � ������� - ����� ��� �������
     IF inCurrencyId <> zc_Enum_Currency_Basis()
     THEN
         -- ��������
         IF COALESCE (inCurrencyPartnerValue, 0) <= 0
         THEN
             RAISE EXCEPTION '������.�������� <����> �� ����������.';
         END IF;

         -- !!!������!!!
         inParPartnerValue:= CASE WHEN inParPartnerValue > 0 THEN inParPartnerValue ELSE 1 END;

         -- !!!������!!!
         IF inAmountSumm = 0 AND inInfoMoneyId = zc_Enum_InfoMoney_41001() -- �������/������� ������
         THEN
             inAmountSumm:= (inAmountIn + inAmountOut) * inCurrencyPartnerValue / inParPartnerValue;
         END IF;

         -- ���� �����
         IF inAmountSumm <> 0 OR (EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Cash())
                             AND inCurrencyId <> COALESCE (inCurrencyPartnerId, 0)
                                )
         THEN
            -- ������ - ���� - ������
            inCurrencyPartnerValue:= CASE WHEN inAmountSumm > 0 THEN inAmountSumm / (inAmountIn + inAmountOut) ELSE inCurrencyPartnerValue END;
            --
            IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Cash())
            THEN
                -- ������
                inMoneyPlaceId:= inCashId;
            END IF;

            -- ������
            inContractId  := 0;
            inInfoMoneyId := zc_Enum_InfoMoney_41001(); -- �������/������� ������

         /*ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Cash())
         THEN
            -- ������ - ������ �� �����
            inAmountSumm  := inCurrencyPartnerValue * (inAmountIn + inAmountOut) / inParPartnerValue;*/

         END IF;

          -- !!!������������ ��� ��������!!!
          outCurrencyValue      := inCurrencyPartnerValue;
          outParValue           := inParPartnerValue;
     ELSE
         -- !!!����������!!!
         outCurrencyValue      := 0;
         outParValue           := 0;
         inCurrencyPartnerValue:= 0;
         inParPartnerValue     := 0;
     END IF;


     -- !!!����� ������ ������!!!
     IF inAmountIn <> 0 THEN
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- ������� �������� - ����� � ������
             vbAmountCurrency := inAmountIn;
             -- ����� � ��� - ��������� - ����� ������
             vbAmount         := CASE WHEN inAmountSumm > 0 THEN inAmountSumm ELSE CAST (inAmountIn * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- ��� �������� � ��� - ��������
             vbAmountIn       := vbAmount;

        ELSE -- ��� � ���
             vbAmount         := inAmountIn;
             vbAmountIn       := inAmountIn;
        END IF;

     ELSE
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- ������� �������� - ����� � ������
             vbAmountCurrency := -1 * inAmountOut;
             -- ����� � ��� - ��������� - ����� ������
             vbAmount         := -1 * CASE WHEN inAmountSumm > 0 THEN inAmountSumm ELSE CAST (inAmountOut * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- ��� �������� � ��� - ��������
             vbAmountOut      := ABS (vbAmount);

        ELSE -- ��� � ���
             vbAmount         := -1 * inAmountOut;
             vbAmountOut      := inAmountOut;
        END IF;
     END IF;

     -- ��������
     IF COALESCE (vbAmount, 0) = 0 AND inCurrencyId <> 0
     THEN
        RAISE EXCEPTION '������.����� ��������� �� ������ <%> � ������ <%> �� ������ ���� = 0.', lfGet_Object_ValueData (inCurrencyId), lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;

     -- ���������
     ioId := lpInsertUpdate_Movement_Cash (ioId          := ioId
                                         , inParentId    := NULL
                                         , inInvNumber   := inInvNumber
                                         , inOperDate    := inOperDate
                                         , inServiceDate := inServiceDate
                                         , inAmountIn    := vbAmountIn
                                         , inAmountOut   := vbAmountOut
                                         , inAmountSumm  := inAmountSumm
                                         , inAmountCurrency := vbAmountCurrency
                                         , inComment     := inComment
                                         , inCarId       := inCarId
                                         , inCashId      := inCashId
                                         , inMoneyPlaceId:= inMoneyPlaceId
                                         , inPositionId  := inPositionId
                                         , inContractId  := inContractId
                                         , inInfoMoneyId := inInfoMoneyId
                                         , inMemberId    := inMemberId
                                         , inUnitId      := inUnitId
                                         , inCurrencyId           := inCurrencyId
                                         , inCurrencyValue        := outCurrencyValue
                                         , inParValue             := outParValue
                                         , inCurrencyPartnerId    := inCurrencyPartnerId
                                         , inCurrencyPartnerValue := inCurrencyPartnerValue
                                         , inParPartnerValue      := inParPartnerValue
                                         , inMovementId_Partion   := inMovementId_Partion
                                         , inUserId      := vbUserId
                                          );

     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- ��� ��������
     /*IF (inInfoMoneyId <> 0 AND inMoneyPlaceId <> 0 AND (inContractId <> 0 OR EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId IN (zc_Object_Founder(), zc_Object_Member(), zc_Object_Personal())))) OR vbUserId <> 5 -- ����� -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN*/
         -- 5.3. �������� ��������
         IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Cash())
         THEN
              PERFORM lpComplete_Movement_Cash (inMovementId := ioId
                                              , inUserId     := vbUserId);
         END IF;
     -- END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 01.09.18         * add Car
 21.05.17         * inCurrencyPartnerId
 26.07.16         *
 27.05.15         * add MovementId_Partion
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 09.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 30.08.14                                        * ��� ��������
 29.08.14                                        * all
 17.08.14                                        * add MovementDescId
 10.05.14                                        * add lpInsert_MovementItemProtocol
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 22.01.14                                        * add IsMaster
 14.01.14                                        *
 26.12.13                                        * add lpComplete_Movement_Cash
 26.12.13                                        * add lpGetAccessKey
 23.12.13                        *
 19.11.13                        *
 06.08.13                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
