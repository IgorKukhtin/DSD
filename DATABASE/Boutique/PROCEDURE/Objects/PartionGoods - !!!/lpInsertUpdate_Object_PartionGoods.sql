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

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           );

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat
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
    IN inGoodsId_old            Integer,       -- �����, �� ��������� ������
    IN inGoodsItemId            Integer,       -- ����� � ��������
    IN inCurrencyId             Integer,       -- ������ ��� ���� �������
    IN inAmount                 TFloat,        -- ���-�� ������
    IN inOperPrice              TFloat,        -- ���� �������
    IN inCountForPrice          TFloat,        -- ���� �� ����������
    IN inOperPriceList          TFloat,        -- ���� �������, !!!���!!!
    IN inOperPriceList_old      TFloat,        -- ���� �������, �� ��������� ������
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
   DECLARE vbPriceList_change Boolean;
   DECLARE vbRePrice_exists   Boolean;
   DECLARE vbId_income_ch     Integer;
   DECLARE vbId_sale_ch       Integer;
   DECLARE vbId_sale_part     Integer;
BEGIN
     -- ��������
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice:= 1; END IF;


     -- 1.0. ��� ������
     IF -- inUserId <> zc_User_Sybase() AND  - !!!����� Sybase!!!
        inMovementItemId > 0 AND (inOperPrice     <> (SELECT COALESCE (Object_PartionGoods.OperPrice, 0)     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inCountForPrice <> (SELECT COALESCE (Object_PartionGoods.CountForPrice, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inGoodsSizeId   <> (SELECT COALESCE (Object_PartionGoods.GoodsSizeId, 0)   FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                               OR inGoodsId       <> inGoodsId_old
                                 )
     THEN
        -- ���� �� ����������� ��������� - ���
        vbId_sale_part:= (SELECT MovementItem.Id
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!������ �����������!!!
                                                  AND Movement.DescId   <> zc_Movement_Income()     -- !!!������ �� ������ �� ������.!!!
                          WHERE MovementItem.PartionId = inMovementItemId
                            AND MovementItem.isErased  = FALSE -- !!!������ �� ���������!!!
                            -- AND MovementItem.DescId = ...   -- !!!����� Desc!!!
                          ORDER BY Movement.OperDate DESC
                          LIMIT 1
                         );
         -- �������� ����� - ��� ������
        IF vbId_sale_part > 0
        THEN
            RAISE EXCEPTION '������.������� �������� <%> � <%> �� <%>.������ �������������� <���� ��.> ��� <�������> ��� <������>.(<%><%>)(<%><%>)(<%><%>)(<%><%>)(<%>)'
                          , (SELECT MovementDesc.ItemName
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                  INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , (SELECT Movement.InvNumber
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , (SELECT zfConvert_DateToString (Movement.OperDate)
                             FROM MovementItem
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                             WHERE MovementItem.Id = vbId_sale_part
                            )
                          , inOperPrice,     (SELECT COALESCE (Object_PartionGoods.OperPrice, 0)     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                          , inCountForPrice, (SELECT COALESCE (Object_PartionGoods.CountForPrice, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                          , inGoodsSizeId,   (SELECT COALESCE (Object_PartionGoods.GoodsSizeId, 0)   FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
                          , inGoodsId,       inGoodsId_old
                          , inMovementItemId
                           ;
        END IF;
     END IF;


     -- 1.1. ���� �� ����������
     vbRePrice_exists:= EXISTS (SELECT 1
                                FROM ObjectLink AS ObjectLink_Goods
                                     INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                           ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                                          AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                                          AND ObjectLink_PriceList.ChildObjectId = zc_PriceList_Basis()  -- !!!������� �����!!!
                                     INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                              ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                             AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                             AND ObjectHistory_PriceListItem.EndDate  < zc_DateEnd() -- !!!���� ������� > 1!!!
                                WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                  AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                               );

     IF 1=1 THEN
        -- ���� �� ������ � ������ ����������� ���������� - ���
        vbId_income_ch:= (SELECT MovementItem.Id
                          FROM Object_PartionGoods
                               INNER JOIN MovementItem ON MovementItem.PartionId = Object_PartionGoods.MovementItemId
                                                     AND MovementItem.isErased  = FALSE
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!������ �����������!!!
                                                  AND Movement.DescId   = zc_Movement_Income()      -- !!!������ ������ �� ������.!!!
                          WHERE Object_PartionGoods.GoodsId    = inGoodsId
                            AND Object_PartionGoods.MovementId <> inMovementId
                          ORDER BY Movement.OperDate DESC
                          LIMIT 1
                         );
     END IF;

     IF 1=1 THEN
        -- ���� �� ����������� ��������� - ���
        vbId_sale_ch:= (SELECT MovementItem.Id
                        FROM MovementItem
                             INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!������ �����������!!!
                                                AND Movement.DescId   <> zc_Movement_Income()     -- !!!������ �� ������ �� ������.!!!
                        WHERE MovementItem.ObjectId = inGoodsId
                          AND MovementItem.isErased = FALSE -- !!!������ �� ���������!!!
                          -- AND MovementItem.DescId= ...   -- !!!����� Desc!!!
                        ORDER BY Movement.OperDate DESC
                        LIMIT 1
                       );
     END IF;


     -- 1.2.1. ������: ���������� - ����� �� ������ ����
     IF inUserId = zc_User_Sybase()
     THEN
          vbPriceList_change:= TRUE;

     -- 1.2.2. ���� ��� �� �������� + ����� �� ������� ��� Insert
     ELSEIF inOperPriceList = inOperPriceList_old AND (inGoodsId = inGoodsId_old OR inGoodsId_old = 0)
     THEN
         vbPriceList_change:= FALSE;

     -- 1.2.3. ���� Insert � � ��������� �� ������ ��� ��� �� �������� + ���� ������������ �������� � ������� - !!!������� �����!!!
     ELSEIF /*(inOperPriceList_old = 0 OR inOperPriceList = inOperPriceList_old) AND*/
           inOperPriceList = (SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (inOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp)
     THEN
         vbPriceList_change:= FALSE;

     -- 1.3.1. ���� ���� ����������
     ELSEIF vbRePrice_exists = TRUE
     THEN
         RAISE EXCEPTION '������.�� ������ <%> ���� ����������.����� ������ ������ � ����� ������� = <%>.'
                       , lfGet_Object_ValueData (inGoodsId)
                       , zfConvert_FloatToString (((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (inOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp))) || ' ���.'
                        ;

     -- 1.3.2. ���� ������ � ������ ����������� ����������
     ELSEIF vbId_income_ch > 0
     THEN
         RAISE EXCEPTION '������.��� ���� ������ � <%> �� <%> � ����� ������� = <%>.��� ������������ ������� � ������ ����� ���������� ������� �������� ����������.'
                       , (SELECT Movement.InvNumber
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_income_ch
                         )
                       , (SELECT zfConvert_DateToString (Movement.OperDate)
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_income_ch
                         )
                       , (SELECT zfConvert_FloatToString (MIF.ValueData) || ' ���.' FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId_income_ch AND MIF.DescId = zc_MIFloat_OperPriceList())
                        ;

     -- 1.3.3. ���� �� ����������� ��������� - ���
     ELSEIF vbId_sale_ch > 0
     THEN
         RAISE EXCEPTION '������.������� �������� <%> � <%> �� <%> � ����� ������� = <%>.��� ������������ ������� � ������ ����� ���������� ������� �������� ����������.'
                       , (SELECT MovementDesc.ItemName
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                               INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                          WHERE MovementItem.Id = vbId_sale_ch
                         )
                       , (SELECT Movement.InvNumber
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_sale_ch
                         )
                       , (SELECT zfConvert_DateToString (Movement.OperDate)
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                          WHERE MovementItem.Id = vbId_sale_ch
                         )
                       , (SELECT zfConvert_FloatToString (MIF.ValueData) || ' ���.' FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId_sale_ch AND MIF.DescId = zc_MIFloat_OperPriceList())
                        ;


     -- 1.3.4. !!!��� ������� - ����� ������ ����!!!
     ELSE vbPriceList_change:= TRUE;


     END IF;
     -- 1. ���������: ���������� - ����� �� ������ ����


     -- 2.1. ������: ���������� - ����� �� �������� ��-�� - !!!����� Sybase!!!
     IF inUserId <> zc_User_Sybase()
        AND (vbId_income_ch <> 0 OR vbId_sale_ch <> 0)
        AND inMovementItemId > 0
        AND (inCompositionId <> (SELECT COALESCE (Object_PartionGoods.CompositionId, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
          OR inGoodsInfoId   <> (SELECT COALESCE (Object_PartionGoods.GoodsInfoId, 0)   FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
          OR inLineFabricaId <> (SELECT COALESCE (Object_PartionGoods.LineFabricaId, 0) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
          OR inLabelId       <> (SELECT COALESCE (Object_PartionGoods.LabelId, 0)       FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inMovementItemId)
            )
     THEN
        -- 2.1.1. ���� �� ����������� ��������� - ���
         IF vbId_income_ch > 0
         THEN
             RAISE EXCEPTION '������.��� ���� ������ � <%> �� <%>.������ �������������� <���� ��.> ��� <������> ��� <��������> ��� <�����> ��� <��������>.'
                           , (SELECT Movement.InvNumber
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_income_ch
                             )
                           , (SELECT zfConvert_DateToString (Movement.OperDate)
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_income_ch
                             )
                            ;
    
         -- 2.1.2. ���� �� ����������� ��������� - ���
         ELSE
             RAISE EXCEPTION '������.������� �������� <%> � <%> �� <%>.������ �������������� <������> ��� <��������> ��� <�����> ��� <��������>.'
                           , (SELECT MovementDesc.ItemName
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                   INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                              WHERE MovementItem.Id = vbId_sale_ch
                             )
                           , (SELECT Movement.InvNumber
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_sale_ch
                             )
                           , (SELECT zfConvert_DateToString (Movement.OperDate)
                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              WHERE MovementItem.Id = vbId_sale_ch
                             )
                            ;
         END IF;
     END IF;
     -- 2. ���������: ���������� - ����� �� �������� ��-�� - !!!����� Sybase!!!


     -- �������� ������� - �� �������� <���� ������>
     UPDATE Object_PartionGoods
            SET MovementId           = inMovementId
              , PartnerId            = inPartnerId
              , UnitId               = inUnitId
              , OperDate             = inOperDate
              , GoodsId              = inGoodsId
              , GoodsItemId          = inGoodsItemId -- ***
              , CurrencyId           = inCurrencyId
              , Amount               = inAmount
              , OperPrice            = inOperPrice
              , CountForPrice        = inCountForPrice
              , OperPriceList        = CASE WHEN vbPriceList_change = TRUE THEN inOperPriceList ELSE Object_PartionGoods.OperPriceList END
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
     WHERE Object_PartionGoods.MovementItemId = inMovementItemId;


     -- ���� ����� ������� �� ��� ������
     IF NOT FOUND THEN
        -- �������� ����� �������
        INSERT INTO Object_PartionGoods (MovementItemId, MovementId, PartnerId, UnitId, OperDate, GoodsId, GoodsItemId
                                       , CurrencyId, Amount, OperPrice, CountForPrice, OperPriceList, BrandId, PeriodId, PeriodYear
                                       , FabrikaId, GoodsGroupId, MeasureId
                                       , CompositionId, GoodsInfoId, LineFabricaId
                                       , LabelId, CompositionGroupId, GoodsSizeId, JuridicalId)
                                 VALUES (inMovementItemId, inMovementId, inPartnerId, inUnitId, inOperDate, inGoodsId, inGoodsItemId
                                       , inCurrencyId, inAmount, inOperPrice, inCountForPrice
                                         -- "������" �������� ����
                                       , inOperPriceList
                                       , inBrandId, inPeriodId, inPeriodYear
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
                                  -- , CountForPrice       = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inCountForPrice                     ELSE Object_PartionGoods.CountForPrice END
                                  , OperPriceList          = CASE WHEN vbPriceList_change = TRUE THEN inOperPriceList ELSE Object_PartionGoods.OperPriceList END
     WHERE Object_PartionGoods.MovementItemId <> inMovementItemId
       AND Object_PartionGoods.GoodsId        = inGoodsId;


     -- c�������� ���� � ������� - !!!����� Sybase!!!
     IF vbPriceList_change = TRUE AND inUserId <> zc_User_Sybase()
     THEN
         -- ����� ��� Update - Object_PartionGoods.OperPriceList
         PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := NULL                  -- ��� ������ ������ Id
                                                               , inPriceListId:= zc_PriceList_Basis()  -- !!!������� �����!!!
                                                               , inGoodsId    := inGoodsId
                                                               , inOperDate   := zc_DateStart()
                                                               , inValue      := inOperPriceList
                                                               , inIsLast     := TRUE
                                                               , inSession    := inUserId :: TVarChar
                                                                );
     END IF;


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
