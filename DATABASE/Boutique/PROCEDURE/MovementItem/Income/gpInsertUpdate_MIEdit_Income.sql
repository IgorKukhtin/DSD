-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, TVarChar, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, TVarChar, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,Integer,TFloat, TFloat, TFloat, TFloat, TVarChar);
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
         vbLineFabricaId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_LineFabrica() AND UPPER (Object.ValueData) LIKE UPPER (inLineFabricaName) LIMIT 1);
         -- 
         IF COALESCE (vbLineFabricaId, 0) = 0
         THEN
             -- ��������
             vbLineFabricaId := gpInsertUpdate_Object_LineFabrica (ioId     := 0
                                                                 , inCode   := 0
                                                                 , inName   := inLineFabricaName
                                                                 , inSession:= inSession
                                                                  );
         END IF;
     END IF;
     
     -- ������ ������
     inCompositionName:= TRIM (inCompositionName);
     IF inCompositionName <> ''
     THEN
         -- ����� !!!��� ������!!!
         vbCompositionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND UPPER (Object.ValueData) LIKE UPPER (inCompositionName) LIMIT 1);
         -- 
         IF COALESCE (vbCompositionId,0) = 0
         THEN
             -- ��������
             vbCompositionId := gpInsertUpdate_Object_Composition (ioId                 := 0
                                                                 , inCode               := 0
                                                                 , inName               := inCompositionName
                                                                 , inCompositionGroupId := 0 -- ��������� � ������ �������
                                                                 , inSession            := inSession
                                                                  );
         END IF;
     END IF;
     
     -- �������� ������ 
     inGoodsInfoName:= TRIM (inGoodsInfoName);
     IF COALESCE (TRIM (inGoodsInfoName), '') <> ''
     THEN
         -- ����� !!!��� ������!!!
         vbGoodsInfoId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsInfo() AND UPPER (Object.ValueData) LIKE UPPER (inGoodsInfoName) LIMIT 1);
         -- 
         IF COALESCE (vbGoodsInfoId, 0) = 0
         THEN
             -- ��������
             vbGoodsInfoId := gpInsertUpdate_Object_GoodsInfo (ioId     := 0
                                                             , inCode   := 0
                                                             , inName   := inGoodsInfoName
                                                             , inSession:= inSession
                                                              );
         END IF;
     END IF;

     -- �������� ��� �������
     inLabelName:= TRIM (inLabelName);
     IF inLabelName <> ''
     THEN
         -- �����
         vbLabelId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND UPPER (Object.ValueData) LIKE UPPER (inLabelName) LIMIT 1);
         -- 
         IF COALESCE (vbLabelId, 0) = 0
         THEN
             -- ��������
             vbLabelId := gpInsertUpdate_Object_Label (ioId     := 0
                                                     , inCode   := 0
                                                     , inName   := inLabelName
                                                     , inSession:= inSession
                                                      );
         END IF;
     END IF;

     -- ������ ������
     inGoodsSizeName:= COALESCE (TRIM (inGoodsSizeName), '');
     -- �������� - �������� ������ ���� �����������
     IF inGoodsSizeName = '' THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������ ������>.';
     END IF;
     --
     IF inGoodsSizeName <> ''
     THEN
         -- �����
         vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND UPPER (Object.ValueData) LIKE UPPER (inGoodsSizeName) LIMIT 1);
         -- 
         IF COALESCE (vbGoodsSizeId, 0) = 0
         THEN
             -- ��������
             vbGoodsSizeId := gpInsertUpdate_Object_GoodsSize (ioId     := 0
                                                             , inCode   := 0
                                                             , inName   := inGoodsSizeName
                                                             , inSession:= inSession
                                                              );
         END IF;
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
     vbGoodsId:= (SELECT Object.Id 
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
         vbGoodsId := gpInsertUpdate_Object_Goods (ioId            := vbGoodsId
                                                 , inCode          := 0
                                                 , inName          := inGoodsName
                                                 , inGoodsGroupId  := inGoodsGroupId
                                                 , inMeasureId     := inMeasureId
                                                 , inCompositionId := vbCompositionId
                                                 , inGoodsInfoId   := vbGoodsInfoId
                                                 , inLineFabricaId := vbLineFabricaId
                                                 , inLabelId       := vbLabelId
                                                 , inSession       := inSession
                                                  );
              
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

      -- c�������� Object_PartionGoods
      PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId := ioId
                                                       , inMovementId     := inMovementId
                                                       , inSybaseId       := NULL -- !!!���� ��� - ������� ��� ���������!!!
                                                       , inPartnerId      := vbPartnerId
                                                       , inUnitId         := MovementLinkObject_To.ObjectId
                                                       , inOperDate       := vbOperDate
                                                       , inGoodsId        := vbGoodsId
                                                       , inGoodsItemId    := vbGoodsItemId
                                                       , inCurrencyId     := MovementLinkObject_CurrencyDocument.ObjectId
                                                       , inAmount         := inAmount
                                                       , inOperPrice      := inOperPrice
                                                       , inPriceSale      := inOperPriceList
                                                       , inBrandId        := ObjectLink_Partner_Brand.ChildObjectId
                                                       , inPeriodId       := ObjectLink_Partner_Period.ChildObjectId
                                                       , inPeriodYear     := ObjectFloat_PeriodYear.ValueData :: Integer
                                                       , inFabrikaId      := ObjectLink_Partner_Fabrika.ChildObjectId
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
                                                        )
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
            --
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                 ON ObjectLink_Partner_Brand.ObjectId = vbPartnerId
                                AND ObjectLink_Partner_Brand.DescId   = zc_ObjectLink_Partner_Brand()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                 ON ObjectLink_Partner_Period.ObjectId = vbPartnerId
                                AND ObjectLink_Partner_Period.DescId   = zc_ObjectLink_Partner_Period()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                 ON ObjectLink_Partner_Fabrika.ObjectId = vbPartnerId
                                AND ObjectLink_Partner_Fabrika.DescId   = zc_ObjectLink_Partner_Fabrika()
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear 
                                  ON ObjectFloat_PeriodYear.ObjectId = vbPartnerId
                                 AND ObjectFloat_PeriodYear.DescId   = zc_ObjectFloat_Partner_PeriodYear()

     WHERE Movement.Id = inMovementId;
     
    -- �������� - ������ = Id
    UPDATE MovementItem SET PartionId = ioId WHERE Id = ioId;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 24.04.17                                                        *
 10.04.17         *
*/

-- ����
-- 