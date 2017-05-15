-- Function: gpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionGoods(
 INOUT ioMovementItemId         Integer,       -- ���� ������            
    IN inMovementId             Integer,       -- ���� ���������             
    IN inSybaseId               Integer,       -- ���� ������ � Sybase
    IN inPartnerId              Integer,       -- ��c�������
    IN inUnitId                 Integer,       -- �������������(�������)
    IN inOperDate               TDateTime,     -- ���� �������
    IN inGoodsId                Integer,       -- ������
    IN inGoodsItemId            Integer,       -- ������ � ���������
    IN inCurrencyId             Integer,       -- ������ ��� ���� �������
    IN inAmount                 TFloat,        -- ���-�� ������
    IN inOperPrice              TFloat,        -- ���� �������
    IN inCountForPrice          TFloat,        -- ���� �� ����������
    IN inPriceSale              TFloat,        -- ���� �������, !!!���!!!
    IN inBrandId                Integer,       -- �������� �����
    IN inPeriodId               Integer,       -- �����
    IN inPeriodYear             Integer,       -- ���
    IN inFabrikaId              Integer,       -- ������� �������������
    IN inGoodsGroupId           Integer,       -- ������ �������
    IN inMeasureId              Integer,       -- ������� ���������
    IN inCompositionId          Integer,       -- ������ ������
    IN inGoodsInfoId            Integer,       -- �������� ������
    IN inLineFabricaId          Integer,       -- ����� ���������
    IN inLabelId                Integer,       -- �������� ��� �������
    IN inCompositionGroupId     Integer,       -- ������ ��� ������� ������
    IN inGoodsSizeId            Integer,       -- ������ ������
    IN inSession                TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF NOT EXISTS (SELECT 1 FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId := ioMovementItemId) THEN
      -- �������� ����� ������� ����������� � ������� �������� <���� �������>
      RAISE EXCEPTION '�������� ����� ������� ����������� � ������� �������� <���� �������>';
   ELSE
     -- c�������� Object_PartionGoods + Update ��-�� � ��������� ������ ����� vbGoodsId
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId := ioMovementItemId
                                               , inMovementId     := inMovementId
                                               , inSybaseId       := NULL -- !!!���� ��� - ������� ��� ���������!!!
                                               , inPartnerId      := vbPartnerId
                                               , inUnitId         := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inOperDate       := vbOperDate
                                               , inGoodsId        := vbGoodsId
                                               , inGoodsItemId    := vbGoodsItemId
                                               , inCurrencyId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument())
                                               , inAmount         := inAmount
                                               , inOperPrice      := inOperPrice
                                               , inCountForPrice  := inCountForPrice
                                               , inPriceSale      := inOperPriceList
                                               , inBrandId        := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Brand())
                                               , inPeriodId       := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Period())
                                               , inPeriodYear     := (SELECT ObF.ValueData FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbPartnerId AND ObF.DescId = zc_ObjectFloat_Partner_PeriodYear()) :: Integer
                                               , inFabrikaId      := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Fabrika())
                                               , inGoodsGroupId   := inGoodsGroupId
                                               , inMeasureId      := inMeasureId
                                               , inCompositionId  := vbCompositionId
                                               , inGoodsInfoId    := vbGoodsInfoId
                                               , inLineFabricaId  := vbLineFabricaId
                                               , inLabelId        := vbLabelId
                                               , inCompositionGroupId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbCompositionId AND OL.DescId = zc_ObjectLink_Composition_CompositionGroup())
                                               , inGoodsSizeId    := vbGoodsSizeId
                                               , inJuridicalId    := inJuridicalId
                                               , inUserId         := vbUserId
                                                );

   END IF; -- if COALESCE (ioMovementItemId, 0) = 0  


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
15.03.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PartionGoods()
