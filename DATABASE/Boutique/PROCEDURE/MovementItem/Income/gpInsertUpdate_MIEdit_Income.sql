-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MIEdit_Income(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsGroupId          Integer   , --
    IN inMeasureId             Integer   , --
    IN inJuridicalId           Integer   , -- ��.����(����)
    IN inGoodsName             TVarChar  , -- ������
    IN inGoodsInfoName         TVarChar  , --
    IN inGoodsSizeName         TVarChar  , --
    IN inCompositionName       TVarChar  , --
    IN inLineFabricaName       TVarChar  , --
    IN inLabelName             TVarChar  , --
    IN inAmount                TFloat    , -- ����������
    IN inOperPrice             TFloat    , -- ����
    IN inCountForPrice         TFloat    , -- ���� �� ����������
    IN inOperPriceList         TFloat    , -- ���� �� ������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbLineFabricaId Integer;
   DECLARE vbCompositionId Integer;
   DECLARE vbGoodsSizeId   Integer;
   DECLARE vbGoodsId       Integer;
   DECLARE vbGoodsInfoId   Integer;
   DECLARE vbGoodsItemId   Integer;
   DECLARE vblabelid       Integer;

   DECLARE vbOperDate  TDateTime;
   DECLARE vbPartnerId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

     -- ��������� �� ���������
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbPartnerId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbPartnerId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <��c������>.';
     END IF;


     -- ����� ���������
     inLineFabricaName:= TRIM (inLineFabricaName);
     IF inLineFabricaName <> ''
     THEN
         -- �����
         vbLineFabricaId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_LineFabrica() AND UPPER (Object.ValueData) LIKE UPPER (inLineFabricaName));
         --
         IF COALESCE (vbLineFabricaId, 0) = 0
         THEN
             -- ��������
             vbLineFabricaId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_LineFabrica (ioId     := 0
                                                                                       , ioCode   := 0
                                                                                       , inName   := inLineFabricaName
                                                                                       , inSession:= inSession
                                                                                         ) AS tmp);
         END IF;
     END IF;

     -- ������ ������
     inCompositionName:= TRIM (inCompositionName);
     IF inCompositionName <> ''
     THEN
         -- ����� !!!��� ������!!!
         vbCompositionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND TRIM (UPPER (Object.ValueData), '\%')  LIKE TRIM (UPPER (inCompositionName), '\%') limit 1);   -- limit 1 ��� ��� ������  ��� inCompositionName = '100%������'  ���������� 2 ������       
         --
         IF COALESCE (vbCompositionId,0) = 0
         THEN
             -- ��������
             vbCompositionId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Composition (ioId                 := 0
                                                                                       , ioCode               := 0
                                                                                       , inName               := inCompositionName
                                                                                       , inCompositionGroupId := 0 -- ��������� � ������ �������
                                                                                       , inSession            := inSession
                                                                                         ) AS tmp);
         END IF;
     END IF;

     -- �������� ������
     inGoodsInfoName:= TRIM (inGoodsInfoName);
     IF COALESCE (TRIM (inGoodsInfoName), '') <> ''
     THEN
         -- ����� !!!��� ������!!!
         vbGoodsInfoId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsInfo() AND TRIM (UPPER (Object.ValueData), '\%') LIKE TRIM (UPPER (inGoodsInfoName), '\%'));   --  '\%'  ��� ��� ������ ���  inGoodsInfoName = '\�����  '   ��� ��� �������� ����� �� ����������� � ��������� ��������� 
         --
         IF COALESCE (vbGoodsInfoId, 0) = 0
         THEN
             -- ��������
             vbGoodsInfoId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsInfo (ioId     := 0
                                                                                   , ioCode   := 0
                                                                                   , inName   := inGoodsInfoName
                                                                                   , inSession:= inSession
                                                                                     ) AS tmp);
         END IF;
     END IF;

     -- �������� ��� �������
     inLabelName:= TRIM (inLabelName);
     IF inLabelName <> ''
     THEN
         -- �����
         vbLabelId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND UPPER (Object.ValueData) LIKE UPPER (inLabelName));
         --
         IF COALESCE (vbLabelId, 0) = 0
         THEN
             -- ��������
             vbLabelId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Label (ioId     := 0
                                                                           , ioCode   := 0
                                                                           , inName   := inLabelName
                                                                           , inSession:= inSession
                                                                             ) AS tmp);
         END IF;
     END IF;

     -- ������ ������
     inGoodsSizeName:= COALESCE (TRIM (inGoodsSizeName), '');
     -- �������� - �������� ������ ���� �����������
     -- IF inGoodsSizeName = '' THEN
     --    RAISE EXCEPTION '������.�� ����������� �������� <������ ������>.';
     -- END IF;
     --
     -- ����� - ������
     vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND UPPER (Object.ValueData) LIKE UPPER (inGoodsSizeName));
     --
     IF COALESCE (vbGoodsSizeId, 0) = 0
     THEN
         -- ��������
         vbGoodsSizeId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsSize (ioId     := 0
                                                                               , ioCode   := 0
                                                                               , inName   := inGoodsSizeName
                                                                               , inSession:= inSession
                                                                                 ) AS tmp);
     END IF;

     -- ������
     inGoodsName:= COALESCE (TRIM (inGoodsName), '');
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inGoodsGroupId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������ �������>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF inGoodsName = '' THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- ����� - !!!��� ������!!!
     vbGoodsId:= (SELECT DISTINCT Object.Id
                  FROM Object
                       -- ����������� ������� �� ������
                       INNER JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                                                     AND Object_PartionGoods.PartnerId = vbPartnerId -- ����� + ��� + �����
                       /*INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                             ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                            AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                            AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId*/
                  WHERE Object.Descid    = zc_Object_Goods()
                    AND Object.ValueData = inGoodsName
                 );


     IF COALESCE (vbGoodsId, 0) = 0
     THEN
         -- ��������
         vbGoodsId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Goods (ioId            := vbGoodsId
                                                                       , ioCode          := 0
                                                                       , inName          := inGoodsName
                                                                       , inGoodsGroupId  := inGoodsGroupId
                                                                       , inMeasureId     := inMeasureId
                                                                       , inCompositionId := vbCompositionId
                                                                       , inGoodsInfoId   := vbGoodsInfoId
                                                                       , inLineFabricaId := vbLineFabricaId
                                                                       , inLabelId       := vbLabelId
                                                                       , inSession       := inSession
                                                                         ) AS tmp);

     ELSE
         -- ���� ��������� - ������ �������
         IF inGoodsGroupId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsGroup()), 0)
         THEN
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, inGoodsGroupId);
             -- ������������� - ������ �������� ������
             PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), vbGoodsId, lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent()));
         END IF;

         -- ���� ��������� - ������� ���������
         IF inMeasureId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure()), 0)
         THEN
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), vbGoodsId, inMeasureId);
         END IF;

         -- ���� ��������� - ������ ������
         IF vbCompositionId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Composition()), 0)
         THEN
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Composition(), vbGoodsId, vbCompositionId);
         END IF;

         -- ���� ��������� - �������� ������
         IF vbGoodsInfoId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsInfo()), 0)
         THEN
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsInfo(), vbGoodsId, vbGoodsInfoId);
         END IF;

         -- ���� ��������� - ����� ���������
         IF vbLineFabricaId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_LineFabrica()), 0)
         THEN
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink ( zc_ObjectLink_Goods_LineFabrica(), vbGoodsId, vbLineFabricaId);
         END IF;

         -- ���� ��������� - �������� ��� �������
         IF vbLabelId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_Label()), 0)
         THEN
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink ( zc_ObjectLink_Goods_Label(), vbGoodsId, vbLabelId);
         END IF;

     END IF;


     -- ������ � ��������� - ������ ��� �������
     vbGoodsItemId:= lpInsertFind_Object_GoodsItem (inGoodsId      := vbGoodsId
                                                  , inGoodsSizeId  := vbGoodsSizeId
                                                  , inPartionId    := ioId
                                                  , inUserId       := vbUserId
                                                   );



     -- �������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := vbGoodsId
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := inCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );

     -- c�������� Object_PartionGoods + Update ��-�� � ��������� ������ ����� vbGoodsId
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId := ioId
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

     -- �������� - ������ = Id
     UPDATE MovementItem SET PartionId = ioId WHERE MovementItem.Id = ioId AND MovementItem.PartionId IS NULL;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 11.05.17                                                        *
 10.05.17                                                        *
 24.04.17                                                        *
 10.04.17         *
*/

-- ����
--