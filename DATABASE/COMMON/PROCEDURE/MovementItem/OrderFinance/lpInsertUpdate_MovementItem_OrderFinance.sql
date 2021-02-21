-- Function: lpInsertUpdate_MovementItem_OrderFinance()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderFinance(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inJuridicalId           Integer   , -- 
    IN inContractId            Integer   , -- 
    IN inBankAccountId         Integer   , --
    IN inAmount                TFloat    , -- 
    IN inAmountStart           TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   
BEGIN

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), ioId, inBankAccountId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStart(), ioId, inAmountStart);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     -- !!! ������� ����.!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.02.21         * inAmountStart
 29.07.19         *
*/

-- ����
--