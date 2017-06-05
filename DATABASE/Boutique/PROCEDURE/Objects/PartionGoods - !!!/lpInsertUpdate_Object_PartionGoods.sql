-- Function: lpInsertUpdate_Object_PartionGoods

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           );
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           );
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionGoods(
    IN inMovementItemId         Integer,       -- ���� ������
    IN inMovementId             Integer,       -- ���� ���������
    IN inPartnerId              Integer,       -- ��c������
    IN inUnitId                 Integer,       -- �������������(�������)
    IN inOperDate               TDateTime,     -- ���� �������
    IN inGoodsId                Integer,       -- �����
    IN inGoodsItemId            Integer,       -- ����� � ��������
    IN inCurrencyId             Integer,       -- ������ ��� ���� �������
    IN inAmount                 TFloat,        -- ���-�� ������
    IN inOperPrice              TFloat,        -- ���� �������
    IN inCountForPrice          TFloat,        -- ���� �� ����������
    IN inPriceSale              TFloat,        -- ���� �������, !!!���!!!
    IN inBrandId                Integer,       -- �������� �����
    IN inPeriodId               Integer,       -- �����
    IN inPeriodYear             Integer,       -- ���
    IN inFabrikaId              Integer,       -- ������� �������������
    IN inGoodsGroupId           Integer,       -- ������ ������
    IN inMeasureId              Integer,       -- ������� ���������
    IN inCompositionId          Integer,       -- ������
    IN inGoodsInfoId            Integer,       -- ��������
    IN inLineFabricaId          Integer,       -- �����
    IN inLabelId                Integer,       -- �������� � �������
    IN inCompositionGroupId     Integer,       -- ������ �������
    IN inGoodsSizeId            Integer,       -- ������
    IN inJuridicalId            Integer,       -- ��.����
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
BEGIN
       -- ��������
       IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice:= 1; END IF;

       -- �������� ������� - �� �������� <���� ������>
       UPDATE Object_PartionGoods
              SET MovementId           = inMovementId
                -- , SybaseId             = CASE WHEN inSybaseId > 0 THEN inSybaseId ELSE SybaseId END -- !!!���� ��� - ������� ��� ���������!!!
                , PartnerId            = inPartnerId
                , UnitId               = inUnitId
                , OperDate             = inOperDate
                , GoodsId              = inGoodsId
                , GoodsItemId          = inGoodsItemId -- ***
                , CurrencyId           = inCurrencyId
                , Amount               = inAmount
                , OperPrice            = inOperPrice
                , CountForPrice        = inCountForPrice
                , PriceSale            = inPriceSale
                , BrandId              = inBrandId
                , PeriodId             = inPeriodId
                , PeriodYear           = inPeriodYear
                , FabrikaId            = zfConvert_IntToNull (inFabrikaId)
                , GoodsGroupId         = inGoodsGroupId
                , MeasureId            = inMeasureId
                , CompositionId        = zfConvert_IntToNull (inCompositionId)
                , GoodsInfoId          = zfConvert_IntToNull (inGoodsInfoId)
                , LineFabricaId        = zfConvert_IntToNull (inLineFabricaId)
                , LabelId              = inLabelId
                , CompositionGroupId   = zfConvert_IntToNull (inCompositionGroupId)
                , GoodsSizeId          = inGoodsSizeId
                , JuridicalId          = zfConvert_IntToNull (inJuridicalId)
       WHERE Object_PartionGoods.MovementItemId = inMovementItemId ;
                                     
                                     
       -- ���� ����� ������� �� ��� ������
       IF NOT FOUND THEN             
          -- �������� ����� �������
          INSERT INTO Object_PartionGoods (MovementItemId, MovementId, /*SybaseId,*/ PartnerId, UnitId, OperDate, GoodsId, GoodsItemId
                                         , CurrencyId, Amount, OperPrice, CountForPrice, PriceSale, BrandId, PeriodId, PeriodYear
                                         , FabrikaId, GoodsGroupId, MeasureId
                                         , CompositionId, GoodsInfoId, LineFabricaId
                                         , LabelId, CompositionGroupId, GoodsSizeId, JuridicalId)
                                   VALUES (inMovementItemId, inMovementId, /*inSybaseId, */ inPartnerId, inUnitId, inOperDate, inGoodsId, inGoodsItemId
                                         , inCurrencyId, inAmount, inOperPrice, inCountForPrice, inPriceSale, inBrandId, inPeriodId, inPeriodYear
                                         , zfConvert_IntToNull (inFabrikaId), inGoodsGroupId, inMeasureId
                                         , zfConvert_IntToNull (inCompositionId), zfConvert_IntToNull (inGoodsInfoId), zfConvert_IntToNull (inLineFabricaId)
                                         , inLabelId, zfConvert_IntToNull (inCompositionGroupId), inGoodsSizeId, zfConvert_IntToNull (inJuridicalId));
       ELSE
           -- !!!�� ������ - ��������� ��� ��� ��������, ����� ���� � ������ ����� ������!!!
           -- PERFORM lpCheck ...

       END IF; -- if NOT FOUND       

       -- !!!������ � ��������� ������ - ��� ��-��!!!
       UPDATE Object_PartionGoods SET FabrikaId              = zfConvert_IntToNull (inFabrikaId)
                                    , GoodsGroupId           = inGoodsGroupId
                                    , MeasureId              = inMeasureId
                                    , CompositionId          = zfConvert_IntToNull (inCompositionId)
                                    , GoodsInfoId            = zfConvert_IntToNull (inGoodsInfoId)
                                    , LineFabricaId          = zfConvert_IntToNull (inLineFabricaId)
                                    , LabelId                = inLabelId
                                    , CompositionGroupId     = zfConvert_IntToNull (inCompositionGroupId)
                                      -- ������ ��� ��������� inMovementId
                                    , JuridicalId            = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN zfConvert_IntToNull (inJuridicalId) ELSE Object_PartionGoods.JuridicalId   END
                                    -- , OperPrice              = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inOperPrice                         ELSE Object_PartionGoods.OperPrice     END
                                    -- , CountForPrice          = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inCountForPrice                     ELSE Object_PartionGoods.CountForPrice END
                                    , PriceSale              = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inPriceSale                         ELSE Object_PartionGoods.PriceSale     END
       WHERE Object_PartionGoods.MovementItemId <> inMovementItemId
         AND Object_PartionGoods.GoodsId        = inGoodsId;
                                     
                                     
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
