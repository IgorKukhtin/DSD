-- Function: gpInsertUpdate_MovementItem_Income()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����������
 INOUT ioAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountPacker        TFloat    , -- ���������� � ������������
    IN inIsCalcAmountPartner Boolean   , -- ������� - ����� �� ��������� <���������� � �����������>
    IN inPrice               TFloat    , -- ����
   OUT outPriceNoVat         TFloat    , -- ���� ��� ���
    IN inMIId_Invoice        TFloat    , -- ������� ��������� C���
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inLiveWeight          TFloat    , -- ����� ���
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������
 INOUT ioPartNumber          TVarChar  , -- � �� ��� ��������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���) 
    IN inStorageId           Integer   , -- ����� ��������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbVATPercent   TFloat;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());


     -- !!!�������� ��������!!!
     IF inIsCalcAmountPartner = TRUE --  OR 1 = 1 -- �������� OR...
     THEN ioAmountPartner:= ioAmount;
     END IF;

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := ioAmount
                                              , inAmountPartner      := ioAmountPartner
                                              , inAmountPacker       := inAmountPacker
                                              , inPrice              := inPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inLiveWeight         := inLiveWeight
                                              , inHeadCount          := inHeadCount
                                              , inPartionGoods       := inPartionGoods
                                              , inPartNumber         := ioPartNumber
                                              , inGoodsKindId        := inGoodsKindId
                                              , inAssetId            := inAssetId
                                              , inStorageId          := inStorageId
                                              , inUserId             := vbUserId
                                               );

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIId_Invoice);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmountPartner * inPrice AS NUMERIC (16, 2))
                      END; 
                             
     
     -- ��������� �� ���������
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          
            INTO vbPriceWithVAT, vbVATPercent
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE Movement.Id = inMovementId;

     -- ������ ���� ��� ���, �� 4 ������
     outPriceNoVat := (CASE WHEN vbPriceWithVAT = TRUE
                            THEN CAST (inPrice - inPrice * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                            ELSE inPrice
                       END  / CASE WHEN ioCountForPrice <> 0 THEN ioCountForPrice ELSE 1 END)
                       ::TFloat;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.01.25         *
 27.06.23         *
 21.07.16         *
 29.06.15                                        * add inIsCalcAmountPartner
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
