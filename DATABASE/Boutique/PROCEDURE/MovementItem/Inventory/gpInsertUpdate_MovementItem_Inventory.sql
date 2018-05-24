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

   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());


     -- ������������ ��������� �� ���������
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbFromId, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;



     -- ������ �� ������ : OperPrice + CountForPrice + OperPriceList
     SELECT Object_PartionGoods.CountForPrice
          , Object_PartionGoods.OperPrice
          , Object_PartionGoods.OperPriceList
            INTO outCountForPrice, outOperPrice, outOperPriceList
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;


     outAmountRemains := 0;        -- �������� ������
     outAmountSecondRemains := 0;  -- �������� ������
     outAmountClient := 0;         -- �������� ������


     -- ����� �����
     IF ioId < 0
     THEN
         -- �����
         ioId:= (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId);
         -- 
         inAmount:= inAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId), 0);

     END IF;
     

     -- �������� - ���������� vbGoodsItemId
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.Id <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION '������.� ��������� ��� ���� ����� <% %> �.<%>.������������ ���������.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = inGoodsId AND Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = inGoodsId AND Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = inGoodsId AND Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������> - ����� <������� ���� �������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);

     -- ��������� �������� <������� ���� c����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- ��������� �������� <���� �� ����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- ��������� �������� <���� (�����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);

     -- ��������� �������� <������� �������>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, outAmountRemains);
     -- ��������� �������� <������� �����>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), ioId, outAmountSecondRemains);
     -- ��������� �������� <������� ����������>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountClient(), ioId, outAmountClient);

     -- ������� �������
     outAmountRemains:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountRemains());
     -- ������� �����
     outAmountSecondRemains:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountSecondRemains());
     -- ������� ����������
     outAmountClient:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountClient());

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
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory(ioId := 52 , inMovementId := 23 , inGoodsId := 406 , inPartionId := 49 , inAmount := 2 , inAmountSecond := 3 , inComment := '' ,  inSession := '2');
