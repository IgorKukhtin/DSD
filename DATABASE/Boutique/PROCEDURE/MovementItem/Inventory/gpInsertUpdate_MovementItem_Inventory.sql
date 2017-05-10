-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TFloat,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                         Integer   , -- ���� ������� <��������>
    IN inGoodsId                            Integer   , -- ������
    IN inPartionId                          Integer   , -- ������
    IN inAmount                             TFloat    , -- ���������� ������� - ����. �������
    IN inAmountSecond                       TFloat    , -- ���������� ����� - ����. �������
   OUT outAmountRemains                     TFloat    , -- ���������� ������� - ��������� �������
   OUT outAmountSecondRemains               TFloat    , -- ���������� ����� - ��������� �������
   OUT outCountForPrice                     TFloat    , -- ���� �� ����������
   OUT outOperPrice                         TFloat    , -- ����
   OUT outAmountSumm                        TFloat    , -- ����� ���������
   OUT outAmountSecondSumm                  TFloat    , -- ����� ��������� (�����)
   OUT outAmountSummRemains                 TFloat    , -- ����� ��������� �������
   OUT outAmountSecondRemainsSumm           TFloat    , -- ����� ��������� ������� (�����)
   OUT outOperPriceList                     TFloat    , -- ���� �� ������
   OUT outAmountPriceListSumm               TFloat    , -- ����� �� ������
   OUT outAmountSecondPriceListSumm         TFloat    , -- ����� �� ������
   OUT outAmountPriceListSummRemains        TFloat    , -- ����� �� ������ ������� 
   OUT outAmountSecondRemainsPLSumm         TFloat    , -- ����� �� ������ �������

   OUT outAmountClient                      TFloat    , -- ���������� � ���������� - ��������� �������
   OUT outAmountClientSumm                  TFloat    , -- ����� � ���������� - ��������� �������
   OUT outAmountClientPriceListSumm         TFloat    , -- ����� �� ������ � ���������� - ��������� �������

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
     -- ������ �� ������ : OperPrice � CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
    INTO outCountForPrice, outOperPrice
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

      
     outAmountRemains := 1;        -- �������� ������
     outAmountSecondRemains := 1;  -- �������� ������
     outAmountClient := 1;         -- �������� ������

     -- �������� �������� <���� �� ����������>
     --IF COALESCE (outCountForPrice, 0) = 0 THEN outCountForPrice := 1; END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL);
      
      -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- ��������� �������� <���� �� ����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);
     -- ��������� �������� <������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, outAmountRemains);
     -- ��������� �������� <���-�� ���� c����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);
     -- ��������� �������� <������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), ioId, outAmountSecondRemains);
     -- ��������� �������� <������� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountClient(), ioId, outAmountClient);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     outAmountSecondSumm := CASE WHEN outCountForPrice > 0
                                     THEN CAST (inAmountSecond * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (inAmountSecond * outOperPrice AS NUMERIC (16, 2))
                            END;
     outAmountSummRemains := CASE WHEN outCountForPrice > 0
                                      THEN CAST (outAmountRemains * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (outAmountRemains * outOperPrice AS NUMERIC (16, 2))
                             END;
     outAmountSecondRemainsSumm := CASE WHEN outCountForPrice > 0
                                            THEN CAST (outAmountSecondRemains * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                        ELSE CAST (outAmountSecondRemains * outOperPrice AS NUMERIC (16, 2))
                                   END;
     outAmountClientSumm := CASE WHEN outCountForPrice > 0
                                      THEN CAST (outAmountClient * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (outAmountClient * outOperPrice AS NUMERIC (16, 2))
                            END;
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outAmountPriceListSumm := CASE WHEN outCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;
     outAmountSecondPriceListSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (inAmountSecond * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (inAmountSecond * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountPriceListSummRemains := CASE WHEN outCountForPrice > 0
                                                THEN CAST (outAmountRemains * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                           ELSE CAST (outAmountRemains * outOperPriceList AS NUMERIC (16, 2))
                                      END;
     outAmountSecondRemainsPLSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (outAmountSecondRemains * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (outAmountSecondRemains * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountClientPriceListSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (outAmountClient * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (outAmountClient * outOperPriceList AS NUMERIC (16, 2))
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
-- select * from gpInsertUpdate_MovementItem_Inventory(ioId := 52 , inMovementId := 23 , inGoodsId := 406 , inPartionId := 49 , inAmount := 2 , inAmountSecond := 3 , inComment := '' ,  inSession := '2');