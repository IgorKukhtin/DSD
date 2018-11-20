-- Function: lpInsertUpdate_MI_ReportUnLiquid()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ReportUnLiquid (Integer, Integer, Integer
                                                                  , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                  , TDateTime, TDateTime, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ReportUnLiquid (Integer, Integer, Integer
                                                                  , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                  , TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ReportUnLiquid(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- 
    IN inRemainsStart        TFloat    , --
    IN inRemainsEnd          TFloat    , --
    IN inAmountM1            TFloat    , --
    IN inAmountM3            TFloat    , --
    IN inAmountM6            TFloat    , --
    IN inAmountIncome        TFloat    , --
    IN inSumm                TFloat    , --
    IN inSummStart           TFloat    , --
    IN inSummEnd             TFloat    , --
    IN inSummM1              TFloat    , --
    IN inSummM3              TFloat    , --
    IN inSummM6              TFloat    , --
    IN inDateIncome          TDateTime , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
BEGIN

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsStart(), ioId, inRemainsStart);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsEnd(), ioId, inRemainsEnd);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountM1(), ioId, inAmountM1);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountM3(), ioId, inAmountM3);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountM6(), ioId, inAmountM6);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Income(), ioId, inAmountIncome);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummStart(), ioId, inSummStart);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummEnd(), ioId, inSummEnd);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummM1(), ioId, inSummM1);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummM3(), ioId, inSummM3);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummM6(), ioId, inSummM6);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Income(), ioId, inDateIncome);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
     
     -- ��������� �������� <>
     --PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);



     -- ��������� ��������
     --PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.18         *
*/

-- ����
--