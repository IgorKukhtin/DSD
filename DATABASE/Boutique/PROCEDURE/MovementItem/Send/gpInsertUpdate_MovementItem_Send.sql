-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   , -- ���� ������� <��������>
    IN inGoodsId              Integer   , -- ������
    IN inPartionId            Integer   , -- ������
    IN inAmount               TFloat    , -- ����������
   OUT outOperPrice           TFloat    , -- ����
   OUT outCountForPrice       TFloat    , -- ���� �� ����������
   OUT outOperPriceList       TFloat    , -- ���� �� ������
   OUT outTotalSumm           TFloat    , -- ����� ���������
   OUT outTotalSummPriceList  TFloat    , -- ����� �� ������
   OUT outCurrencyValue       TFloat    , -- 
   OUT outParValue            TFloat    , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- ������ �� ������ : OperPrice � CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis())
    INTO outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     IF vbCurrencyId <> zc_Currency_Basis()
     THEN
         -- ���������� ���� �� ���� ���������
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId
                                                ) AS tmp;       
     END IF;

     IF COALESCE (outCurrencyValue, 0) = 0
        THEN
             outParValue:= 0;
             outCurrencyValue:= 1;
     END IF;

     -- ���� ������� �� ������ 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (outCountForPrice, 0) = 0 THEN outCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, outParValue);

     -- ��������� ����� �� ��������, ��� �����
     outTotalSumm := CASE WHEN outCountForPrice > 0
                               THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                          ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                     END;
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList := CAST ((inAmount * outOperPriceList) AS NUMERIC (16, 2));

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.17         *
 25.04.17         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_Send(ioId := 31 , inMovementId := 13 , inGoodsId := 349 , inPartionId := 41 , inAmount := 10 ,  inSession := '2');