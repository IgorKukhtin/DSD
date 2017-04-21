-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, TVarChar, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, TVarChar, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer ,Integer,Integer,Integer,Integer,Integer,Integer,TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MIEdit_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsGroupId        Integer   , --
    IN inGoodsId             Integer   , -- ������
    IN inGoodsInfoId         Integer   , --
    IN inGoodsSizeId         Integer   , --
    IN inCompositionGroupId  Integer   , --  �������� ���� �������� ������ 
    IN inCompositionId       Integer   , --
    IN inLineFabricaId       Integer   , --
    IN inLabelId             Integer   , --
    IN inMeasureId           Integer   , --
    IN inAmount              TFloat    , -- ����������
    IN inOperPrice           TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
    IN inOperPriceList       TFloat    , -- ���� �� ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsItemId Integer;
   DECLARE vbPartionId Integer; 
  
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
    
     PERFORM lpInsert_ObjectProtocol (inGoodsGroupId, vbUserId);

          

   ----gpInsertUpdate_Object_GoodsItem ����� ��������� ����� ����� - ������
   IF COALESCE (inGoodsId, 0) <> 0 AND COALESCE (inGoodsSizeId, 0) <> 0
      THEN
          --
          vbGoodsItemId := (SELECT Object_GoodsItem.Id 
                            FROM Object_GoodsItem 
                            WHERE Object_GoodsItem.GoodsId = inGoodsId AND Object_GoodsItem.GoodsSizeId = inGoodsSizeId);
          IF COALESCE (vbGoodsItemId,0) = 0
             THEN
                 -- �������� ����� ������� ����������� � ������� �������� <���� �������>
                 INSERT INTO Object_GoodsItem (GoodsId, GoodsSizeId)
                        VALUES (inGoodsId, inGoodsSizeId) RETURNING Id INTO vbGoodsItemId;

          END IF;
   END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := COALESCE (inGoodsId,0)
                                              , inPartionId          := Null :: integer
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );

      -- c�������� Object_PartionGoods
      vbPartionId := lpInsertUpdate_Object_PartionGoods (
                                                  ioMovementItemId := ioId
                                                , inMovementId     := inMovementId
                                                , inSybaseId       := Null
                                                , inPartnerId      := MovementLinkObject_From.ObjectId
                                                , inUnitId         := MovementLinkObject_To.ObjectId
                                                , inOperDate       := Movement.OperDate
                                                , inGoodsId        := inGoodsId
                                                , inGoodsItemId    := vbGoodsItemId
                                                , inCurrencyId     := MovementLinkObject_CurrencyDocument.ObjectId
                                                , inAmount         := inAmount
                                                , inOperPrice      := inOperPrice
                                                , inPriceSale      := inOperPriceList
                                                , inBrandId        := ObjectLink_Partner_Brand.ChildObjectId
                                                , inPeriodId       := ObjectLink_Partner_Period.ChildObjectId
                                                , inPeriodYear     := ObjectFloat_PeriodYear.ValueData         :: integer
                                                , inFabrikaId      := ObjectLink_Partner_Fabrika.ChildObjectId
                                                , inGoodsGroupId   := inGoodsGroupId
                                                , inMeasureId      := inMeasureId
                                                , inCompositionId  := inCompositionId
                                                , inGoodsInfoId    := inGoodsInfoId
                                                , inLineFabricaId  := inLineFabricaId
                                                , inLabelId        := inLabelId
                                                , inCompositionGroupId := ObjectLink_Composition_CompositionGroup.ChildObjectId -- ����������� ����� ������� ������ 
                                                , inGoodsSizeId    := inGoodsSizeId 
                                                , inUserId         := vbUserId
                                                        )
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            --
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                 ON ObjectLink_Partner_Brand.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Brand.DescId = zc_ObjectLink_Partner_Brand()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                 ON ObjectLink_Partner_Period.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                 ON ObjectLink_Partner_Fabrika.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Fabrika.DescId = zc_ObjectLink_Partner_Fabrika()
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear 
                                  ON ObjectFloat_PeriodYear.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
            --
            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                ON ObjectLink_Composition_CompositionGroup.ObjectId = inCompositionId
                               AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()

     WHERE Movement.Id = inMovementId;

     -- ��������� ������������� � �������
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := COALESCE (inGoodsId,0)
                                              , inPartionId          := vbPartionId
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. ��������� �.�.
 21.04.17                                                       *
 10.04.17         *
*/

-- ����
-- 