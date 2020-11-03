-- Function: gpInsertUpdate_MovementItem_Payment()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIncomeId            Integer   , -- ���� ��������� <��������� ���������>
 INOUT ioBankAccountId       Integer   , -- ���� ������� <��������� ����>
   OUT outBankAccountName    TVarChar  , -- �������� ������� <��������� ����>
   OUT outBankName           TVarChar  , -- ������������ �����
    IN inIncome_PaySumm      TFloat    , -- ����� ������� �� ���������
 INOUT ioSummaPay            TFloat    , -- ����� �������
    IN inSummaCorrBonus      TFloat    , -- ����� ������������� ����� �� ������
    IN inSummaCorrReturnOut  TFloat    , -- ����� ������������� ����� �� ���������
    IN inSummaCorrOther      TFloat    , -- ����� ������������� ����� �� ������ ��������
 INOUT ioNeedPay             Boolean   , -- ����� �������
    IN inisPartialPay        Boolean   , -- ��������� ������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyId Integer;
   DECLARE vbOldSummaPay TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    --��������� ��������� ����
    SELECT Object_BankAccount.Id
          ,Object_BankAccount.Name
          ,Object_BankAccount.BankName
          ,Object_BankAccount.CurrencyId
           INTO ioBankAccountId
               ,outBankAccountName
               ,outBankName
               ,vbCurrencyId
    FROM Object_BankAccount_View AS Object_BankAccount
    WHERE (Object_BankAccount.Id = COALESCE (ioBankAccountId, 0)
        OR COALESCE(ioBankAccountId,0) = 0
          )
        AND JuridicalId = (Select Movement_Payment_View.JuridicalId from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId)
        AND isErased = FALSE
     ;


    IF COALESCE(ioBankAccountId) = 0
    THEN
        RAISE EXCEPTION '������. ��� ������ <%> �� ������� �� ������ ���������� �����',(Select Movement_Payment_View.JuridicalName from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId);
    END IF;
    --��������� ����� ������� �� �������
    SELECT
        MovementItem.Amount
    INTO
        vbOldSummaPay
    FROM
        MovementItem
    WHERE
        MovementItem.Id = ioId;

    IF COALESCE(inisPartialPay, FALSE) = TRUE
    THEN
      IF NOT EXISTS(SELECT 1 FROM Movement_Payment_View
                          INNER JOIN Movement_ChangeIncomePayment_View ON Movement_ChangeIncomePayment_View.OperDate = Movement_Payment_View.OperDate
                                                                      AND Movement_ChangeIncomePayment_View.StatusId = zc_Enum_Status_Complete()
                                                                      AND Movement_ChangeIncomePayment_View.FromId = (SELECT MLO_From.ObjectId
                                                                                                                      FROM MovementLinkObject AS MLO_From
                                                                                                                      WHERE MLO_From.MovementId = inIncomeId
                                                                                                                        AND MLO_From.DescId = zc_MovementLinkObject_From())
                                                                      AND Movement_ChangeIncomePayment_View.JuridicalId = Movement_Payment_View.JuridicalId
                                                                      AND Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindId = zc_Enum_ChangeIncomePaymentKind_PartialSale()
                    WHERE Movement_Payment_View.ID = inMovementId)
      THEN
          RAISE EXCEPTION '������! �� ������� ��������� ����� �� �������� ���������� � ����� <��������� �������>.';
      END IF;

      SELECT Movement_ChangeIncomePayment_View.TotalSumm
      INTO ioSummaPay
      FROM Movement_Payment_View
           INNER JOIN Movement_ChangeIncomePayment_View ON Movement_ChangeIncomePayment_View.OperDate = Movement_Payment_View.OperDate
                                                       AND Movement_ChangeIncomePayment_View.StatusId = zc_Enum_Status_Complete()
                                                       AND Movement_ChangeIncomePayment_View.FromId = (SELECT MLO_From.ObjectId
                                                                                                       FROM MovementLinkObject AS MLO_From
                                                                                                       WHERE MLO_From.MovementId = inIncomeId
                                                                                                         AND MLO_From.DescId = zc_MovementLinkObject_From())
                                                       AND Movement_ChangeIncomePayment_View.JuridicalId = Movement_Payment_View.JuridicalId
                                                       AND Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindId = zc_Enum_ChangeIncomePaymentKind_PartialSale()
      WHERE Movement_Payment_View.ID = inMovementId;

      IF ioSummaPay > COALESCE(inIncome_PaySumm,0)-COALESCE(inSummaCorrBonus,0)-COALESCE(inSummaCorrReturnOut,0)-COALESCE(inSummaCorrOther,0)
      THEN
          RAISE EXCEPTION '������! ����� ����� ������� �� ������ ��������� ���� �� ���������.';
      END IF;
    ELSE
      ioSummaPay := COALESCE(inIncome_PaySumm,0)-COALESCE(inSummaCorrBonus,0)-COALESCE(inSummaCorrReturnOut,0)-COALESCE(inSummaCorrOther,0);
      IF ioSummaPay < 0
      THEN
          RAISE EXCEPTION '������! ����� ����� ������� �� ������ ��������� ���� �� ���������.';
      END IF;
    END IF;

    IF COALESCE(ioID,0) = 0
    THEN
        ioNeedPay := TRUE;
    END IF;

    -- ���������
    ioId := lpInsertUpdate_MovementItem_Payment (ioId              := ioId
                                            , inMovementId         := inMovementId
                                            , inIncomeId           := inIncomeId
                                            , inBankAccountId      := ioBankAccountId
                                            , inCurrencyId         := vbCurrencyId
                                            , inSummaPay           := ioSummaPay
                                            , inSummaCorrBonus     := inSummaCorrBonus
                                            , inSummaCorrReturnOut := inSummaCorrReturnOut
                                            , inSummaCorrOther     := inSummaCorrOther
                                            , inNeedPay            := ioNeedPay
                                            , inisPartialPay       := inisPartialPay
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 13.10.15                                                                         *
*/
