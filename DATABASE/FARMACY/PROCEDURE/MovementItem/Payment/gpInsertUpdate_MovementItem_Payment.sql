-- Function: gpInsertUpdate_MovementItem_Payment()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIncomeId            Integer   , -- ���� ��������� <��������� ���������>
 INOUT ioBankAccountId       Integer   , -- ���� ��������� <������ �� �����>
 INOUT ioAccountId           Integer   , -- ���� ������� <��������� ����>
   OUT outAccountName        TVarChar  , -- �������� ������� <��������� ����>
   OUT outBankName           TVarChar  , -- ������������ �����
    IN inSummaPay            TFloat    , -- ����� �������
    IN inNeedPay             Boolean   , -- ����� �������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyId Integer;
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
       ioAccountId
      ,outAccountName
      ,outBankName
      ,vbCurrencyId
    FROM
        Object_BankAccount_View AS Object_BankAccount
    WHERE
        (
            Object_BankAccount.Id = COALESCE(ioAccountId,0)
            or
            COALESCE(ioAccountId,0) = 0
        )
        AND
        JuridicalId = (Select Movement_Payment_View.JuridicalId from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId);

    IF COALESCE(ioAccountId) = 0
    THEN
        RAISE EXCEPTION '������. ��� ������ <%> �� ������� �� ������ ���������� �����',(Select Movement_Payment_View.JuridicalName from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId);
    END IF;
    -- ���������

    SELECT
        TT.ioId
       ,TT.ioBankAccountId
    INTO
        ioId 
        ioBankAccountId
    FROM lpInsertUpdate_MovementItem_Payment (ioId              := ioId
                                            , inMovementId         := inMovementId
                                            , inIncomeId           := inIncomeId
                                            , ioBankAccountId      := ioBankAccountId
                                            , inAccountId          := ioAccountId
                                            , inCurrencyId         := vbCurrencyId
                                            , inSummaPay           := inSummaPay
                                            , inNeedPay            := inNeedPay
                                            , inUserId             := vbUserId
                                             ) as TT;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 13.10.15                                                                         *
*/