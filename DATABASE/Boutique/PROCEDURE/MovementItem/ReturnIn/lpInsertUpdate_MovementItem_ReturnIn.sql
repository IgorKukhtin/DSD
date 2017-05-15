-- Function: lpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inPartionId             Integer   , -- ������
    IN inPartionMI_Id          Integer   , -- ������ �������� �������/�������
    IN inSaleMI_Id             Integer   , -- ������ ���. �������
    IN inAmount                TFloat    , -- ����������
    IN inOperPrice             TFloat    , -- ����
    IN inCountForPrice         TFloat    , -- ���� �� ����������
    IN inOperPriceList         TFloat    , -- ���� �� ������
    IN inCurrencyValue         TFloat    , -- 
    IN inParValue              TFloat    , -- 
    IN inTotalChangePercent    TFloat    , -- 
    IN inTotalPay              TFloat    , -- 
    IN inTotalPayOth           TFloat    , -- 
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, inParValue);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), ioId, inTotalChangePercent);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, inTotalPay);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPayOth(), ioId, inTotalPayOth);
    
     IF COALESCE (inPartionMI_Id) = 0 
        THEN 
            inPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);
     END IF;
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionMI(), ioId, inPartionMI_Id);


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
 15.05.17         *
*/

-- ����
-- 