-- Function: lpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, Integer);                                                           

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, Integer);  


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inPartionId             Integer   , -- ������
    IN inPartionMI_Id          Integer   , -- ������ �������� �������/�������
   -- IN inSaleMI_Id             Integer   , -- ������ ���. �������
    IN inAmount                TFloat    , -- ����������
    IN inAmountPartner         TFloat    , -- ���-�� ��������� � �������� � ����
    IN inOperPrice             TFloat    , -- ����
    IN inCountForPrice         TFloat    , -- ���� �� ����������
    IN inOperPriceList         TFloat    , -- ���� �� ������
    IN inCurrencyValue         TFloat    , -- 
    IN inParValue              TFloat    , -- 
    IN inTotalChangePercent    TFloat    , -- 
    --IN inTotalPay              TFloat    , -- 
    --IN inTotalPayOth           TFloat    , -- 
    IN inComment               TVarChar  , -- ����������    
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert     Boolean;
   DECLARE vbOperDate_pay TDateTime;
BEGIN
     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');


     -- ���� ��� ���� ������� > 31 ����
     IF NOT EXISTS (SELECT 1
                    FROM Object AS Object_PartionMI
                         INNER JOIN MovementItemBoolean AS MIBoolean
                                                        ON MIBoolean.MovementItemId = Object_PartionMI.ObjectCode
                                                       AND MIBoolean.DescId         = zc_MIBoolean_Checked()
                                                       AND MIBoolean.ValueData      = TRUE
                    WHERE Object_PartionMI.Id = inPartionMI_Id
                   )
        AND zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         -- �������� - ������� ���� ������ � ������� �������� ���-�� � ���������� - �.�. � ������� �������� �������
         vbOperDate_pay:= COALESCE ((SELECT MAX (MIContainer.OperDate)
                                     FROM ContainerLinkObject AS CLO_PartionMI
                                          INNER JOIN Container ON Container.Id     = CLO_PartionMI.ContainerId
                                                              AND Container.DescId = zc_Container_Count()
                                          INNER JOIN MovementItemContainer AS MIContainer
                                                                           ON MIContainer.ContainerId  = CLO_PartionMI.ContainerId
                                                                          AND MIContainer.AnalyzerId   = zc_Enum_AnalyzerId_SaleCount_10100() -- ���-��, ���������� - ���� �������� (��������)
                                                                          AND MIContainer.Amount       < 0
                                     WHERE CLO_PartionMI.ObjectId = inPartionMI_Id
                                       AND CLO_PartionMI.DescId   = zc_ContainerLinkObject_PartionMI()
                                    ), zc_DateEnd());
         -- 
         IF vbOperDate_pay < CURRENT_DATE - INTERVAL '32 DAY'
         THEN
             RAISE EXCEPTION '������. ��� ���� ������ ������� ��� ������� �� <%>.%������ ������ ��� 31 ����.', zfConvert_DateToString (vbOperDate_pay), CHR (13);
         END IF;
         
     END IF;
     

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);
   
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
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionMI(), ioId, inPartionMI_Id);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     

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
 26.04.21         * AmountPartner
 15.05.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn (ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inisPay := False ,  inAmount := 4 ,inSummChangePercent:=0, ioOperPriceList := 1030 , inBarCode := '1' ::TVarChar,  inSession := '2');
