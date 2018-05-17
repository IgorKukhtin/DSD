-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListTax(
    IN inPriceListId                Integer,    -- �����-���� ���������
    IN inUnitId                     Integer,    -- �������������
    IN inGroupGoodsId               Integer,    -- ������ ���.
    IN inBrandId                    Integer,    -- ����. �����
    IN inPeriodId                   Integer,    -- �����
    IN inLineFabricaId              Integer,    -- �����
    IN inLabelId                    Integer,    -- �������� ��� �������
    IN inOperDate                   TDateTime,  -- ��������� ���� �
    IN inPeriodYear                 TFloat,     -- ���
    IN inTax                        TFloat,     -- ����� �� ������� ����
    IN inSession                    TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- ��������
   IF COALESCE (inPriceListId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� �������� <�����-����>.';
   END IF;

   -- ��������
   IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION '������.�������� <��������� ���� �...> �� ����� ���� ������ ��� <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;


   -- (�.�. �� ���� 100�.�. ����� ���� = 50, ����� ���� ������ ���� 5000���, � ��� ��� ������� ����� ������� �� ������� � ��� ��� �� ����� � ���������� �� ����� ���)

   -- �������� ��� ������ ����.��.����������
   CREATE TEMP TABLE _tmpGoods (GoodsId Integer, OperPrice TFloat) ON COMMIT DROP;
      INSERT INTO _tmpGoods (GoodsId, OperPrice)
           WITH
           tmpPartionGoods AS (SELECT Object_PartionGoods.MovementItemId  AS PartionId
                                    , Object_PartionGoods.GoodsId         AS GoodsId
                                    , Object_PartionGoods.OperPrice       AS OperPrice
                               FROM Object_PartionGoods
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                          ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_PartionGoods.GoodsId
                                                         AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                                         AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGroupGoodsId

                                    INNER JOIN ObjectLink AS ObjectLink_Goods_LineFabrica
                                                          ON ObjectLink_Goods_LineFabrica.ObjectId = Object_PartionGoods.GoodsId
                                                         AND ObjectLink_Goods_LineFabrica.DescId = zc_ObjectLink_Goods_LineFabrica()
                                                         AND ObjectLink_Goods_LineFabrica.ChildObjectId = inLineFabricaId

                               WHERE Object_PartionGoods.isErased   = FALSE
                                 AND Object_PartionGoods.UnitId     = inUnitId
                                 AND Object_PartionGoods.BrandId    = inBrandId
                                 AND Object_PartionGoods.PeriodId   = inPeriodId
                                 AND Object_PartionGoods.PeriodYear = inPeriodYear
                                 AND Object_PartionGoods.LabelId    = inLabelId
                               )

           -- ���������� ������� ������.
           SELECT Container.ObjectId AS GoodsId
                , tmpGoods.OperPrice
           FROM Container
                INNER JOIN (SELECT tmpPartionGoods.*
                            FROM tmpPartionGoods
                            ) AS tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                         AND tmpGoods.PartionId = Container.PartionId
           WHERE Container.DescId = zc_Container_Count()
             AND Container.WhereObjectId = inUnitId
             AND Container.Amount <> 0
           GROUP BY Container.ObjectId , tmpGoods.OperPrice
           HAVING SUM (Container.Amount) <> 0
           ;

   -- ��������� ��� (��� ������� ������ ������� �� ������� � ��� ��� �� ����� � ���������� �� ����� ��� ����� ����������� ����)
   PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                     , inPriceListId := inPriceListId
                                                     , inGoodsId     := _tmpGoods.GoodsId
                                                     , inOperDate    := inOperDate
                                                                        -- ���������� ��� ������ � �� +/-50 ������, �.�. ��������� ����� ��� 50 ��� �����
                                                     , inValue       := (CEIL ((_tmpGoods.OperPrice * inTax) / 50) * 50) :: TFloat
                                                  -- , inValue       := CAST ((_tmpGoods.OperPrice * inTax) AS NUMERIC (16, 0)) :: TFloat
                                                     , inUserId      := vbUserId
                                                      )

   FROM _tmpGoods;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 12.03.18         * add inLabelId
 01.03.18         *
 21.08.15         *
*/