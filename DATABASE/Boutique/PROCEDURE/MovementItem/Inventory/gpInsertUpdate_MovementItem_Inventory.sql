-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TFloat,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                         Integer   , -- ���� ������� <��������>
    IN inGoodsId                            Integer   , -- ������
    IN inPartionId                          Integer   , -- ������
    IN inAmount                             TFloat    , -- ���������� ������� - ����. �������
    IN inAmountSecond                       TFloat    , -- ���������� ����� - ����. �������
    IN inAmountRemains                      TFloat    , -- ���������� ������� - ��������� �������
    IN inAmountSecondRemains                TFloat    , -- ���������� ����� - ��������� �������
 INOUT ioCountForPrice                      TFloat    , -- ���� �� ����������
    IN inOperPrice                          TFloat    , -- ����
   OUT outAmountSumm                        TFloat    , -- ����� ���������
   OUT outAmountSecondSumm                  TFloat    , -- ����� ��������� (�����)
   OUT outAmountSummRemains                 TFloat    , -- ����� ��������� �������
   OUT outAmountSecondRemainsSumm           TFloat    , -- ����� ��������� ������� (�����)
   OUT outOperPriceList                     TFloat    , -- ���� �� ������
   OUT outAmountPriceListSumm               TFloat    , -- ����� �� ������
   OUT outAmountSecondPriceListSumm         TFloat    , -- ����� �� ������
   OUT outAmountPriceListSummRemains        TFloat    , -- ����� �� ������ ������� 
   OUT outAmountSecondRemainsPLSumm  TFloat    , -- ����� �� ������ �������
    IN inComment                            TVarChar  , -- ����������
    IN inSession                            TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);    
     -- �������� ���� �� ������ �� ���� ���. 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL);
      
      -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <���� �� ����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);
     -- ��������� �������� <������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, inAmountRemains);
     -- ��������� �������� <���-�� ���� c����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);
     -- ��������� �������� <������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), ioId, inAmountSecondRemains);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inOperPrice AS NUMERIC (16, 2))
                      END;
     outAmountSecondSumm := CASE WHEN ioCountForPrice > 0
                                     THEN CAST (inAmountSecond * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (inAmountSecond * inOperPrice AS NUMERIC (16, 2))
                            END;
     outAmountSummRemains := CASE WHEN ioCountForPrice > 0
                                      THEN CAST (inAmountRemains * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (inAmountRemains * inOperPrice AS NUMERIC (16, 2))
                             END;
     outAmountSecondRemainsSumm := CASE WHEN ioCountForPrice > 0
                                            THEN CAST (inAmountSecondRemains * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                                        ELSE CAST (inAmountSecondRemains * inOperPrice AS NUMERIC (16, 2))
                                   END;
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outAmountPriceListSumm := CASE WHEN ioCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;
     outAmountSecondPriceListSumm := CASE WHEN ioCountForPrice > 0
                                               THEN CAST (inAmountSecond * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (inAmountSecond * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountPriceListSummRemains := CASE WHEN ioCountForPrice > 0
                                                THEN CAST (inAmountRemains * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                           ELSE CAST (inAmountRemains * outOperPriceList AS NUMERIC (16, 2))
                                      END;
     outAmountSecondRemainsPLSumm := CASE WHEN ioCountForPrice > 0
                                               THEN CAST (inAmountSecondRemains * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (inAmountSecondRemains * outOperPriceList AS NUMERIC (16, 2))
                                     END;

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
 02.05.17         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_Inventory(ioId := 52 , inMovementId := 23 , inGoodsId := 406 , inPartionId := 49 , inAmount := 2 , inAmountSecond := 3 , inAmountRemains := 1 , inAmountSecondRemains := 1 , ioCountForPrice := 1 , inOperPrice := 87 , inComment := '' ,  inSession := '2');