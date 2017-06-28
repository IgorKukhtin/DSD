-- Function: gpInsertUpdate_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- �����
    IN inPartionId           Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
   OUT outOperPrice          TFloat    , -- ����
   OUT outCountForPrice      TFloat    , -- ���� �� ����������
   OUT outTotalSumm          TFloat    , -- ����� ��.
   OUT outTotalSummBalance   TFloat    , -- ����� ��. (���)
 INOUT ioOperPriceList       TFloat    , -- ���� (�����)
   OUT outTotalSummPriceList TFloat    , -- ����� (�����)
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());

     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;


     -- ���� (�����)
     IF ioOperPriceList <> 0
     THEN
         -- !!!��� SYBASE - ����� ������!!!
         IF vbUserId <> zfCalc_UserAdmin() :: Integer THEN RAISE EXCEPTION '������.�������� ������ ��� �������� �� Sybase.'; END IF;
     ELSE
         -- �� �������
         ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                                                   , zc_PriceList_Basis()
                                                                                                   , inGoodsId
                                                                                                    ) AS tmp), 0);
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���� (�����)>.';
     END IF;


     -- ������ �� ������ : OperPrice � CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice, 1) AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)     AS OperPrice
            INTO outCountForPrice, outOperPrice
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;


     -- ���������
     ioId:= lpInsertUpdate_MovementItem_ReturnOut (ioId              := ioId
                                                 , inMovementId      := inMovementId
                                                 , inGoodsId         := inGoodsId
                                                 , inPartionId       := inPartionId
                                                 , inAmount          := inAmount
                                                 , inOperPrice       := outOperPrice
                                                 , inCountForPrice   := outCountForPrice
                                                 , inOperPriceList   := ioOperPriceList
                                                 , inUserId          := vbUserId
                                                  );

     -- ��������� <����� ��.> ��� �����
     outTotalSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     -- ��������� <����� ��. (���)> ��� �����
     outTotalSummBalance := (SELECT CASE WHEN MLO_CurrencyDocument.ObjectId = zc_Currency_Basis()
                                              THEN outTotalSumm
                                         ELSE CAST (CASE WHEN MF_ParValue.ValueData > 0 THEN outTotalSumm * MF_CurrencyValue.ValueData / MF_ParValue.ValueData ELSE outTotalSumm * MF_CurrencyValue.ValueData
                                                    END AS NUMERIC (16, 2))
                                    END
                             FROM MovementLinkObject AS MLO_CurrencyDocument
                                  LEFT JOIN MovementFloat AS MF_CurrencyValue
                                                          ON MF_CurrencyValue.MovementId = MLO_CurrencyDocument.MovementId
                                                         AND MF_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
                                  LEFT JOIN MovementFloat AS MF_ParValue
                                                          ON MF_ParValue.MovementId = MLO_CurrencyDocument.MovementId
                                                         AND MF_ParValue.DescId     = zc_MovementFloat_ParValue()
                             WHERE MLO_CurrencyDocument.MovementId = inMovementId
                               AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
                            );
     -- ��������� <����� (�����)> ��� �����
     outTotalSummPriceList := CAST (inAmount * ioOperPriceList AS NUMERIC (16, 2));
     

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.17         *
 10.04.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnOut(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 ,  inSession := '2');
