 -- Function: gpInsertUpdate_Movement_BankAccount_SplitByDetail ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount_SplitByDetail (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount_SplitByDetail(
    IN inMovementId          Integer   , -- ���� ������� <��������> BankAccount
    IN inInvNumberInvoice    TVarChar  , -- ����(�������)
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount_BS TFloat; -- ����� �� ������� �����
   DECLARE vbAmount_BA TFloat; -- ����� �� BankAccount
   DECLARE vbParentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount_From_BankS());

     --�������� �����
     vbAmount_BS := (SELECT MovementFloat_Amount.ValueData ::TFloat 
                     FROM Movement
                          INNER JOIN MovementFloat
                                  AS MovementFloat_Amount
                                  ON MovementFloat_Amount.MovementId = Movement.ParentId
                                 AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                     WHERE Movement.Id = inMovementId
                   );
     vbAmount_BA := (SELECT SUM (COALESCE (MI.Amount,0))
                     FROM MovementItem AS MI
                     WHERE MI.MovementId = inMovementId
                       AND MI.DescId = zc_MI_Master()
                     ); 
     
     IF COALESCE (vbAmount_BS,0) > COALESCE (vbAmount_BA,0)
     THEN
         RAISE EXCEPTION '������.����� <��������� ����, ������/������> ��� ���� ���������.';
     END IF;

     --�������� �� ����������
     IF ABS(COALESCE (vbAmount_BA,0)) <> (SELECT SUM (COALESCE (MI.Amount,0))
                                          FROM MovementItem AS MI
                                          WHERE MI.MovementId = inMovementId
                                            AND MI.DescId = zc_MI_Detail())
     THEN
         RAISE EXCEPTION '������.����� ������������� �� ������������� ����� ���������.';
     END IF;     

     --��������
     IF COALESCE (inInvNumberInvoice,'') = ''
     THEN
          RAISE EXCEPTION '������.�������� <����(�������)> ������ ���� ��������.';
     ELSE
         -- ����(�������)
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberInvoice(), inMovementId, inInvNumberInvoice);
     END IF;



     -- ����������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     vbParentId := (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);

     -- �������� ������ zc_MI_Detail � �� ��� ��������� ����� ��������� BankAccount
     PERFORM lpInsertUpdate_Movement_BankAccount(ioId                   := tmp.Id
                                               , inInvNumber            := tmp.InvNumber
                                               , inOperDate             := tmp.OperDate
                                               , inServiceDate          := tmp.ServiceDate
                                               , inAmount               := tmp.Amount
                                               , inAmountSumm           := tmp.AmountSumm
                                               , inAmountCurrency       := tmp.AmountCurrency
                                               , inBankAccountId        := tmp.BankAccountId
                                               , inComment              := tmp.Comment
                                               , inMoneyPlaceId         := tmp.MoneyPlaceId
                                               , inPartnerId            := tmp.PartnerId
                                               , inContractId           := tmp.ContractId
                                               , inInfoMoneyId          := tmp.InfoMoneyId
                                               , inUnitId               := tmp.UnitId
                                               , inMovementId_Invoice   := tmp.MovementId_Invoice
                                               , inCurrencyId           := tmp.CurrencyId
                                               , inCurrencyValue        := tmp.CurrencyValue
                                               , inParValue             := tmp.ParValue
                                               , inCurrencyPartnerValue := tmp.CurrencyPartnerValue
                                               , inParPartnerValue      := tmp.ParPartnerValue
                                               , inParentId             := tmp.ParentId
                                               , inBankAccountPartnerId := tmp.BankAccountPartnerId
                                               , inUserId               := vbUserId
                                                )
       FROM (WITH tmpBankAccount AS (SELECT tmp.*
                                     FROM gpGet_Movement_BankAccount (inMovementId:= inMovementId, inMovementId_Value:= inMovementId, inOperDate:= NULL :: TDateTime, inSession:= inSession) AS tmp
                                    )
                , tmpMI_Detail AS (SELECT MovementItem.ObjectId            AS InfoMoneyId
                                        , COALESCE (MovementItem.Amount,0) AS Amount
                                   FROM MovementItem
                                   WHERE MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Detail()
                                     AND MovementItem.isErased   = FALSE
                                  )

             -- ���������
             SELECT tmpBankAccount.Id
                  , tmpBankAccount.InvNumber
                  , tmpBankAccount.OperDate
                  , tmpBankAccount.ServiceDate
                  , tmpBankAccount.ParentId
                  , ( (CASE WHEN COALESCE (tmpBankAccount.AmountIn,0) > 0 THEN 1 ELSE -1 END)
                    * (CASE WHEN tmpBankAccount.CurrencyId <> zc_Enum_Currency_Basis() THEN CAST (tmp1.Amount * tmpBankAccount.CurrencyValue / tmpBankAccount.ParValue AS NUMERIC (16, 2)) ELSE tmp1.Amount END)) AS Amount
                  , tmpBankAccount.AmountSumm
                  , CASE WHEN tmpBankAccount.CurrencyId <> zc_Enum_Currency_Basis() THEN tmp1.Amount ELSE 0  END AS AmountCurrency
                  , tmpBankAccount.BankAccountId
                  , tmpBankAccount.Comment
                  , tmpBankAccount.MoneyPlaceId 
                  , tmpBankAccount.PartnerId
                  , tmpBankAccount.ContractId
                  , tmp1.InfoMoneyId
                  , tmpBankAccount.UnitId
                  , tmpBankAccount.MovementId_Invoice
                  , tmpBankAccount.CurrencyId
                  , tmpBankAccount.CurrencyValue
                  , tmpBankAccount.ParValue
                  , tmpBankAccount.CurrencyPartnerValue
                  , tmpBankAccount.ParPartnerValue
                  , tmpBankAccount.BankAccountPartnerId
             FROM tmpBankAccount
                  INNER JOIN tmpMI_Detail AS tmp1 ON tmp1.InfoMoneyId = tmpBankAccount.InfoMoneyId
            UNION ALL
             SELECT 0 AS Id
                  , CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar) AS InvNumber
                  , tmpBankAccount.OperDate
                  , tmpBankAccount.ServiceDate
                  , tmpBankAccount.ParentId
                  , ( (CASE WHEN COALESCE (tmpBankAccount.AmountIn,0) > 0 THEN 1 ELSE -1 END)
                    * (CASE WHEN  tmpBankAccount.CurrencyId <> zc_Enum_Currency_Basis() THEN CAST (tmp2.Amount * tmpBankAccount.CurrencyValue / tmpBankAccount.ParValue AS NUMERIC (16, 2)) ELSE tmp2.Amount END)) AS Amount
                  , tmpBankAccount.AmountSumm
                  , CASE WHEN tmpBankAccount.CurrencyId <> zc_Enum_Currency_Basis() THEN tmp2.Amount ELSE 0  END AS AmountCurrency
                  , tmpBankAccount.BankAccountId
                  , tmpBankAccount.Comment
                  , tmpBankAccount.MoneyPlaceId 
                  , tmpBankAccount.PartnerId
                  , tmpBankAccount.ContractId
                  , tmp2.InfoMoneyId
                  , tmpBankAccount.UnitId
                  , tmpBankAccount.MovementId_Invoice
                  , tmpBankAccount.CurrencyId
                  , tmpBankAccount.CurrencyValue
                  , tmpBankAccount.ParValue
                  , tmpBankAccount.CurrencyPartnerValue
                  , tmpBankAccount.ParPartnerValue
                  , tmpBankAccount.BankAccountPartnerId
             FROM tmpBankAccount
                  LEFT JOIN tmpMI_Detail AS tmp2 ON tmp2.InfoMoneyId <> tmpBankAccount.InfoMoneyId
            ) AS tmp;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��� ��������� ���������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_BankAccount())
     THEN
         PERFORM lpComplete_Movement_BankAccount (inMovementId := Movement.Id
                                                , inUserId     := vbUserId)
         FROM Movement
         WHERE Movement.ParentId = vbParentId
           AND Movement.DescId = zc_Movement_BankAccount();
     END IF;


     if vbUserId = 9457
     then
        RAISE EXCEPTION 'Test. Ok';
     end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.10.24         *
*/

-- ����
--