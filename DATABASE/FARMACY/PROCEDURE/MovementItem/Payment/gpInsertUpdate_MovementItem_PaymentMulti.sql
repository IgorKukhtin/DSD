-- Function: gpInsertUpdate_MovementItem_PaymentMulti()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer,  Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer,  Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer,  Integer, Integer, TFloat, TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PaymentMulti(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIncomeId            Integer   , -- ���� ��������� <��������� ���������>
    IN inBankAccountId       Integer   , -- ���� ������� <��������� ����>
    IN inCurrencyId          Integer   , -- ���� ������� <������>
    IN inSummaPay            TFloat    , -- ����� �������
    IN inSummaCorrBonus      TFloat    , -- ����� ������������� ����� �� ������
    IN inSummaCorrReturnOut  TFloat    , -- ����� ������������� ����� �� ���������
    IN inSummaCorrOther      TFloat    , -- ����� ������������� ����� �� ������ ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    --��������� ��������� ����
    
    PERFORM lpInsertUpdate_MovementItem_Payment (ioId              := inId
                                            , inMovementId         := inMovementId
                                            , inIncomeId           := inIncomeId
                                            , inBankAccountId      := inBankAccountId
                                            , inCurrencyId         := inCurrencyId
                                            , inSummaPay           := inSummaPay
                                            , inSummaCorrBonus     := inSummaCorrBonus
                                            , inSummaCorrReturnOut := inSummaCorrReturnOut
                                            , inSummaCorrOther     := inSummaCorrOther
                                            , inNeedPay            := TRUE
                                            , inNeedRecalcSumm     := FALSE
                                            , inUserId             := vbUserId
                                             );
    -- PERFORM gpInsertUpdate_MovementItem_Payment(ioId             := inId, -- ���� ������� <������� ���������>
                                                -- inMovementId     := inMovementId, -- ���� ������� <��������>
                                                -- inIncomeId       := inIncomeId, -- ���� ��������� <��������� ���������>
                                                -- ioBankAccountId  := inBankAccountId, -- ���� ������� <��������� ����>
                                                -- inSummaPay       := inSummaPay, -- ����� �������
                                                -- inNeedPay        := TRUE, -- ����� �������
                                                -- inSession        := inSession-- ������ ������������
                                            -- );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat,TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 07.12.15                                                                         *
*/