-- Function: gpInsertUpdate_MovementItem_Income20202()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income20202 (Integer, Integer, Integer, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income20202(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����������
 INOUT ioAmountPartner       TFloat    , -- ���������� � �����������
    IN inIsCalcAmountPartner Boolean   , -- ������� - ����� �� ��������� <���������� � �����������>
    IN inPrice               TFloat    , -- ����
    IN inMIId_Invoice        TFloat    , -- ������� ��������� C���               
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inPartionNumStart     TFloat    , -- ��������� � ��� ������ ������
 INOUT ioPartionNumEnd       TFloat    , -- ��������� � ��� ������ ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���) 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());


     -- �������� - ��� 
     IF COALESCE (inPartionNumStart, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� �������� <� ������ � ...>.';
     END IF;
     -- �������� - ��� 
     IF COALESCE (TRIM (inPartionGoods), '') = ''
     THEN
         RAISE EXCEPTION '������.�� ������� �������� <������ ��� ������>.';
     END IF;
     -- �������� - ��� 
     IF COALESCE (ioAmount, 0) = 0
     THEN
         ioAmount:= 1;
       --RAISE EXCEPTION '������.�� ������� �������� <���-�� (�����)>.';
     END IF;
     -- ������ ��������
     ioPartionNumEnd:= inPartionNumStart + ioAmount - 1;


     -- !!!�������� ��������!!!
     IF inIsCalcAmountPartner = TRUE OR 1 = 1 -- �������� ��� ��������� ...
     THEN ioAmountPartner:= ioAmount;
     END IF;

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Income20202 (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := ioAmount
                                                   , inAmountPartner      := ioAmountPartner
                                                   , inPrice              := inPrice
                                                   , inCountForPrice      := ioCountForPrice
                                                   , inPartionNumStart    := inPartionNumStart
                                                   , inPartionNumEnd      := ioPartionNumEnd
                                                   , inPartionGoods       := inPartionGoods
                                                   , inGoodsKindId        := inGoodsKindId
                                                   , inAssetId            := inAssetId
                                                   , inUserId             := vbUserId
                                                    );

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIId_Invoice);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmountPartner * inPrice AS NUMERIC (16, 2))
                      END;
                      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.21         * 20202
 21.07.16         *
 29.06.15                                        * add inIsCalcAmountPartner
 29.05.15                                        *
*/

-- ����
--