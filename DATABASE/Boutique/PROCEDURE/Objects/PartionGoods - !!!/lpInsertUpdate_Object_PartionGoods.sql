-- Function: lpInsertUpdate_Object_PartionGoods

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer
                                                           );
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionGoods(
    IN inMovementItemId         Integer,       -- ���� ������
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
    IN inJuridicalId            Integer,       -- ��.����(����)
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
BEGIN
       -- �������� ������� - �� �������� <���� ������>
       UPDATE Object_PartionGoods
              SET MovementId         = inMovementId
                , SybaseId           = CASE WHEN inSybaseId > 0 THEN inSybaseId ELSE SybaseId END -- !!!���� ��� - ������� ��� ���������!!!
                , PartnerId          = inPartnerId
                , UnitId             = inUnitId
                , OperDate           = inOperDate
                , GoodsId            = inGoodsId
                , GoodsItemId        = inGoodsItemId
                , CurrencyId         = inCurrencyId
                , Amount             = inAmount
                , OperPrice          = inOperPrice
                , PriceSale          = inPriceSale
                , BrandId            = inBrandId
                , PeriodId           = inPeriodId
                , PeriodYear         = inPeriodYear
                , FabrikaId          = inFabrikaId
                , GoodsGroupId       = inGoodsGroupId
                , MeasureId          = inMeasureId
                , CompositionId      = inCompositionId
                , GoodsInfoId        = inGoodsInfoId
                , LineFabricaId      = inLineFabricaId
                , LabelId            = inLabelId
                , CompositionGroupId = inCompositionGroupId
                , GoodsSizeId        = inGoodsSizeId
       WHERE MovementItemId = inMovementItemId ;
                                     
                                     
       -- ���� ����� ������� ����� ������
       IF NOT FOUND THEN             
          -- �������� ����� �������
          INSERT INTO Object_PartionGoods (MovementItemId, MovementId, SybaseId, PartnerId, UnitId, OperDate, GoodsId, GoodsItemId, CurrencyId, Amount, OperPrice, PriceSale, BrandId, PeriodId, PeriodYear, FabrikaId, GoodsGroupId, MeasureId, CompositionId, GoodsInfoId, LineFabricaId, LabelId, CompositionGroupId, GoodsSizeId)
                                   VALUES (inMovementItemId, inMovementId, inSybaseId, inPartnerId, inUnitId, inOperDate, inGoodsId, inGoodsItemId, inCurrencyId, inAmount, inOperPrice, inPriceSale, inBrandId, inPeriodId, inPeriodYear, inFabrikaId, inGoodsGroupId, inMeasureId, inCompositionId, inGoodsInfoId, inLineFabricaId, inLabelId, inCompositionGroupId, inGoodsSizeId);
       END IF; -- if NOT FOUND       

       -- !!!������ � ��������� ������ - ��� ��-��!!!
                                     
                                     
END;                                 
$BODY$                               
                                     
LANGUAGE plpgsql VOLATILE;           
                                     
/*------------------------------     -------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
24.04.17                                         * all
11.04.17          * lp
15.03.17                                                          *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_PartionGoods()
