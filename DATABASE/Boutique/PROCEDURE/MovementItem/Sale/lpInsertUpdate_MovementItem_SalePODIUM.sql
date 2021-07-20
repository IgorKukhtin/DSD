-- Function: lpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, TVarChar, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, TVarChar, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer
                                                        , TFloat, TFloat, TFloat, TFloat, TFloat
                                                        , TFloat, TFloat, TFloat, TFloat
                                                        , TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- �����
    IN inPartionId             Integer   , -- ������
    IN inDiscountSaleKindId    Integer   , -- ��� ������ ��� �������
    IN inAmount                TFloat    , -- ����������
    IN inChangePercent         TFloat    , -- % ������
    IN inChangePercentNext     TFloat    , -- % ������
    -- IN inSummChangePercent     TFloat    , -- �������������� ������ � ������� ���
    IN inOperPrice             TFloat    , -- ���� ��. � ������
    IN inCountForPrice         TFloat    , -- ���� ��.�� ����������
    IN inOperPriceList         TFloat    , -- ���� �� ������
    IN inCurrencyValue         TFloat    , -- ���� ��� �������� �� ������ ������ � ���
    IN inParValue              TFloat    , -- ������� ��� �������� �� ������ ������ � ���
    IN inTotalChangePercent    TFloat    , -- ����� ������ � ������� ���
    -- IN inTotalChangePercentPay TFloat    , --
    -- IN inTotalPay              TFloat    , -- ����� ������ � ������� ���
    -- IN inTotalPayOth           TFloat    , --
    -- IN inTotalCountReturn      TFloat    , --
    -- IN inTotalReturn           TFloat    , --
    -- IN inTotalPayReturn        TFloat    , --

    IN inBarCode               TVarChar  , -- �����-��� ����������
    IN inComment               TVarChar  , -- ����������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� �������� <���� (�����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);
     -- ��������� �������� <���� ��� �������� �� ������ ������ � ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ��������� �������� <������� ��� �������� �� ������ ������ � ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, inParValue);

     -- ��������� �������� <����� ������ � ������� ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), ioId, inTotalChangePercent);

     -- ��������� �������� <% ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentNext(), ioId, inChangePercentNext);

     -- ��������� �������� <�����-��� ����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BarCode(), ioId, inBarCode);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <��� ������ ��� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DiscountSaleKind(), ioId, inDiscountSaleKindId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.17         *
 10.05.17         *
*/

-- ����
--