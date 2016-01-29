-- Function: gpInsertUpdate_MovementItem_Payment()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

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
    SELECT
        Object_BankAccount.Id
       ,Object_BankAccount.Name
       ,Object_BankAccount.BankName
       ,Object_BankAccount.CurrencyId
    INTO
       ioBankAccountId
      ,outBankAccountName
      ,outBankName
      ,vbCurrencyId
    FROM
        Object_BankAccount_View AS Object_BankAccount
    WHERE
        (
            Object_BankAccount.Id = COALESCE(ioBankAccountId,0)
            or
            COALESCE(ioBankAccountId,0) = 0
        )
        AND
        JuridicalId = (Select Movement_Payment_View.JuridicalId from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId);

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

    ioSummaPay := COALESCE(inIncome_PaySumm,0)-COALESCE(inSummaCorrBonus,0)-COALESCE(inSummaCorrReturnOut,0)-COALESCE(inSummaCorrOther,0);
    IF ioSummaPay < 0 
    THEN
        RAISE EXCEPTION '������! ����� ����� ������� �� ������ ��������� ���� �� ���������.';
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
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 13.10.15                                                                         *
*/