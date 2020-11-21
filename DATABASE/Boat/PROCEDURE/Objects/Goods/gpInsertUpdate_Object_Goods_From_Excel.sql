--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , Integer, Integer, Integer
                                                              , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , Boolean
                                                              , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                              , TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_From_Excel(
    IN inArticle         TVarChar,
    IN inArticleVergl    TVarChar,
    IN inName            TVarChar,
    IN inMatchcode       TVarChar,
    IN inEAN             TVarChar,
    IN inASIN            TVarChar,
    IN inFeeNumber       TVarChar,
    IN inGoodsTag        TVarChar,
    IN inProdColor       TVarChar,
    IN inGoodsSize       TVarChar,
    IN inGoodsGroupCode  Integer ,
    IN inPartnerCode     Integer ,
    IN inObjectCode      Integer ,
    IN inGoodsType       TVarChar,
    IN inTaxKind         TVarChar,
    IN inDiscountParner  TVarChar,
    IN inComment1        TVarChar,
    IN inComment2        TVarChar,
    IN inModelEtiketen   TVarChar,
    IN inisArc           Boolean ,
    IN inEKPrice         TFloat  ,
    IN inEmpfPrice       TFloat  ,
    IN inMin             TFloat  ,
    IN inRefer           TFloat  ,
    IN inPrice1          TFloat  ,
    IN inPrice2          TFloat  ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsGroupId Integer;   
   DECLARE vbGoodsId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbTaxKindId Integer;
   DECLARE vbGoodsTagId Integer;
   DECLARE vbGoodsTypeId Integer;
   DECLARE vbProdColorId Integer;
   DECLARE vbGoodsSizeId Integer;
   DECLARE vbDiscountParnerId Integer;
   DECLARE vbPriceList1Id Integer;
   DECLARE vbPriceList2Id Integer;
   DECLARE vbMeasureId Integer;
   DECLARE vbmodeletiketenid Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��.���. ������ ��
   vbMeasureId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Measure() AND Object.ValueData Like ('��'));
   --���� �� ������� �������
   IF COALESCE (vbMeasureId,0) = 0
   THEN
        vbMeasureId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_Measure (ioId           := 0         :: Integer
                                                          , ioCode         := 0         :: Integer
                                                          , inName         := '��'      :: TVarChar
                                                          , inInternalCode := ''        :: TVarChar
                                                          , inInternalName := ''        :: TVarChar
                                                          , inSession      := inSession :: TVarChar
                                                           ) AS tmp);
   END IF;

-- ������� ��� ������ ��������
   -- ������� ����� �������
   IF COALESCE (inName, '') <> '' OR COALESCE (inObjectCode, 0) = 0
   THEN
       vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inObjectCode);
       
   ELSE
       IF COALESCE (vbGoodsId, 0) = 0
       THEN
           RAISE EXCEPTION '������.��� ������ <%> <%> �� ���������� ��� <%>.', inArticle, inName, inObjectCode;
       END IF;

       RETURN;
   END IF;



   IF COALESCE (inGoodsGroupCode, 0) <> 0
   THEN
       -- ������� ����� ������ ��������
       vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ObjectCode = inGoodsGroupCode);

       --���� ��� ����� ������ �������
       IF COALESCE (vbGoodsGroupId,0) = 0
       THEN
            vbGoodsGroupId := (SELECT tmp.ioId
                               FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                    , ioCode            := inGoodsGroupCode    :: Integer
                                                                    , inName            := CAST (inGoodsGroupCode AS TVarChar) ::TVarChar
                                                                    , inParentId        := 0         :: Integer
                                                                    , inInfoMoneyId     := 0         :: Integer
                                                                    , inModelEtiketenId := 0         :: Integer
                                                                    , inSession         := inSession :: TVarChar
                                                                     ) AS tmp);
       END IF;
   END IF;

          --���� �� ����� ������
   IF COALESCE (vbGoodsGroupId,0) = 0
   THEN
        RAISE EXCEPTION '������.111������ ������ � ����� = <%> �� �������. ����� <%>', inGoodsGroupCode, inName;
   END IF;

   IF COALESCE (inPartnerCode, 0) <> 0
   THEN
       -- ������� ����� 
       vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ObjectCode = inPartnerCode);
       --���� �� ����� ������
       IF COALESCE (vbPartnerId,0) = 0
       THEN
            RAISE EXCEPTION '������.������� � ����� = <%> �� ������.', inPartnerCode;
       END IF;
   END IF;

   IF COALESCE (inGoodsSize, '') <> ''
   THEN
       -- ������� ����� ������
       vbGoodsSizeId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND TRIM (Object.ValueData) Like TRIM (inGoodsSize));
       --���� �� ������� �������
       IF COALESCE (vbGoodsSizeId,0) = 0
       THEN
            vbGoodsSizeId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_GoodsSize (ioId        := 0         :: Integer
                                                                  , ioCode      := 0         :: Integer
                                                                  , inName      := TRIM (inGoodsSize) ::TVarChar
                                                                  , inComment   := ''        :: TVarChar
                                                                  , inSession   := inSession :: TVarChar
                                                                   ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inGoodsType, '') <> ''
   THEN
       -- ������� ����� 
       vbGoodsTypeId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsType() AND TRIM (Object.ValueData) Like TRIM (inGoodsType));
       --���� �� ������� �������
       IF COALESCE (vbGoodsTypeId,0) = 0
       THEN
            vbGoodsTypeId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_GoodsType (ioId        := 0         :: Integer
                                                                  , ioCode      := 0         :: Integer
                                                                  , inName      := TRIM (inGoodsType) ::TVarChar
                                                                  , inComment   := ''        :: TVarChar
                                                                  , inSession   := inSession :: TVarChar
                                                                   ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inGoodsTag, '') <> ''
   THEN
       -- ������� ����� 
       vbGoodsTagId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsTag() AND TRIM (Object.ValueData) Like TRIM (inGoodsTag));
       --���� �� ������� �������
       IF COALESCE (vbGoodsTagId,0) = 0
       THEN
            vbGoodsTagId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_GoodsTag (ioId        := 0         :: Integer
                                                                 , ioCode      := 0         :: Integer
                                                                 , inName      := TRIM (inGoodsTag) ::TVarChar
                                                                 , inComment   := ''        :: TVarChar
                                                                 , inSession   := inSession :: TVarChar
                                                                  ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inProdColor, '') <> ''
   THEN
       -- ������� ����� 
       vbProdColorId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND TRIM (Object.ValueData) Like TRIM (inProdColor));
       --���� �� ������� �������
       IF COALESCE (vbProdColorId,0) = 0
       THEN
            vbProdColorId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_ProdColor (ioId        := 0         :: Integer
                                                                 , ioCode      := 0         :: Integer
                                                                 , inName      := TRIM (inProdColor) ::TVarChar
                                                                 , inComment   := ''        :: TVarChar
                                                                 , inSession   := inSession :: TVarChar
                                                                  ) AS tmp);
       END IF;
   END IF;
   
   
   -- ������� �����  ���
   --vbTaxKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_TaxKind() AND TRIM (Object.ValueData) Like TRIM (inTaxKind));

   IF COALESCE (inTaxKind, '') <> ''
   THEN
       -- ������� ����� 
       vbTaxKindId := (SELECT ObjectString.ObjectId 
                       FROM ObjectString
                       WHERE ObjectString.DescId = zc_ObjectString_TaxKind_Code()
                         AND ObjectString.ValueData = TRIM (inTaxKind) );
       --���� �� ������� �������
       IF COALESCE (vbTaxKindId,0) = 0
       THEN
            vbTaxKindId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_TaxKind (ioId        := 0         :: Integer
                                                                , ioCode      := 0         :: Integer
                                                                , inCode_str  := TRIM (inTaxKind) ::TVarChar
                                                                , inName      := TRIM (inTaxKind) ::TVarChar
                                                                , inSession   := inSession :: TVarChar
                                                                 ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inDiscountParner, '') <> ''
   THEN
       -- ������� ����� 
       vbDiscountParnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_DiscountParner() AND TRIM (Object.ValueData) Like TRIM (inDiscountParner));
       --���� �� ������� �������
       IF COALESCE (vbDiscountParnerId,0) = 0
       THEN
            vbDiscountParnerId := (SELECT tmp.ioId
                                   FROM gpInsertUpdate_Object_DiscountParner (ioId        := 0         :: Integer
                                                                            , ioCode      := 0         :: Integer
                                                                            , inName      := TRIM (inDiscountParner) ::TVarChar
                                                                            , inComment   := ''        :: TVarChar
                                                                            , inSession   := inSession :: TVarChar
                                                                             ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inModelEtiketen, '') <> ''
   THEN
       -- ������� ����� 
       vbModelEtiketenId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ModelEtiketen() AND TRIM (Object.ValueData) Like TRIM (inModelEtiketen));
       --���� �� ������� �������
       IF COALESCE (vbModelEtiketenId,0) = 0
       THEN
            vbModelEtiketenId := (SELECT tmp.ioId
                                  FROM gpInsertUpdate_Object_ModelEtiketen (ioId        := 0         :: Integer
                                                                          , ioCode      := 0         :: Integer
                                                                          , inName      := TRIM (inModelEtiketen) ::TVarChar
                                                                          , inComment   := ''        :: TVarChar
                                                                          , inSession   := inSession :: TVarChar
                                                                           ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (vbGoodsId,0) = 0
   THEN
       -- �������
       vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                              , inCode             := COALESCE (inObjectCode,0)    :: Integer
                                              , inName             := TRIM (inName)         :: TVarChar
                                              , inArticle          := TRIM (inArticle)      :: TVarChar
                                              , inArticleVergl     := TRIM (inArticleVergl) :: TVarChar
                                              , inEAN              := TRIM (inEAN)          :: TVarChar
                                              , inASIN             := TRIM (inASIN)         :: TVarChar
                                              , inMatchCode        := TRIM (inMatchCode)    :: TVarChar 
                                              , inFeeNumber        := TRIM (inFeeNumber)     :: TVarChar
                                              , inComment          := CASE WHEN TRIM (inComment1) <> '' OR TRIM (inComment2) <> '' THEN (TRIM (inComment1)||' / '||TRIM (inComment2)) ELSE '' END  :: TVarChar
                                              , inisArc            := COALESCE (inisArc, FALSE)    :: Boolean
                                              , inAmountMin        := inMin            :: TFloat
                                              , inAmountRefer      := inRefer          :: TFloat
                                              , inEKPrice          := inEmpfPrice      :: TFloat
                                              , inEmpfPrice        := inEmpfPrice      :: TFloat
                                              , inGoodsGroupId     := vbGoodsGroupId   :: Integer
                                              , inMeasureId        := vbMeasureId      :: Integer
                                              , inGoodsTagId       := vbGoodsTagId     :: Integer
                                              , inGoodsTypeId      := vbGoodsTypeId    :: Integer
                                              , inGoodsSizeId      := vbGoodsSizeId    :: Integer
                                              , inProdColorId      := vbProdColorId    :: Integer
                                              , inPartnerId        := vbPartnerId      :: Integer
                                              , inUnitId           := 0                :: Integer
                                              , inDiscountParnerId := vbDiscountParnerId    :: Integer
                                              , inTaxKindId        := vbTaxKindId      :: Integer
                                              , inSession          := inSession        :: TVarChar
                                              );
   ELSE
       -- ���������
       PERFORM gpInsertUpdate_Object_Goods(ioId               := COALESCE (tmp.Id, vbGoodsId)::  Integer
                                         , inCode             := COALESCE (tmp.Code, inObjectCode)    :: Integer
                                         , inName             := COALESCE (inName, tmp.Name)   :: TVarChar
                                         , inArticle          := CASE WHEN TRIM (inArticle) <> '' THEN TRIM (inArticle) ELSE tmp.Article END :: TVarChar
                                         , inArticleVergl     := CASE WHEN TRIM (inArticleVergl) <> '' THEN TRIM (inArticleVergl) ELSE tmp.ArticleVergl END:: TVarChar
                                         , inEAN              := CASE WHEN TRIM (inEAN) <> '' THEN TRIM (inEAN) ELSE tmp.EAN END:: TVarChar
                                         , inASIN             := CASE WHEN TRIM (inASIN) <> '' THEN TRIM (inASIN) ELSE tmp.ASIN END:: TVarChar
                                         , inMatchCode        := CASE WHEN TRIM (inMatchCode) <> '' THEN TRIM (inMatchCode) ELSE tmp.MatchCode END:: TVarChar 
                                         , inFeeNumber        := CASE WHEN TRIM (inFeeNumber) <> '' THEN TRIM (inFeeNumber) ELSE tmp.FeeNumber END:: TVarChar
                                         , inComment          := CASE WHEN TRIM (inComment1) <> '' OR TRIM (inComment2) <> '' THEN (TRIM (inComment1)||' / '||TRIM (inComment2)) ELSE tmp.Comment END  :: TVarChar
                                         , inisArc            := COALESCE (inisArc, tmp.isArc, FALSE)    :: Boolean
                                         , inAmountMin        := CASE WHEN COALESCE (inMin, 0) <> 0 THEN inMin ELSE tmp.AmountMin END :: TFloat
                                         , inAmountRefer      := CASE WHEN COALESCE (inRefer, 0) <> 0 THEN inRefer ELSE tmp.AmountRefer END :: TFloat
                                         , inEKPrice          := CASE WHEN COALESCE (inEKPrice, 0) <> 0 THEN inEKPrice ELSE tmp.EKPrice END      :: TFloat
                                         , inEmpfPrice        := CASE WHEN COALESCE (inEmpfPrice, 0) <> 0 THEN inEmpfPrice ELSE tmp.EmpfPrice END  :: TFloat
                                         , inGoodsGroupId     := CASE WHEN COALESCE (vbGoodsGroupId, 0) <> 0 THEN vbGoodsGroupId ELSE tmp.GoodsGroupId END  :: Integer
                                         , inMeasureId        := CASE WHEN COALESCE (tmp.MeasureId, 0) <> 0 THEN tmp.MeasureId ELSE vbMeasureId END      :: Integer
                                         , inGoodsTagId       := CASE WHEN COALESCE (vbGoodsTagId, 0) <> 0 THEN vbGoodsTagId ELSE tmp.GoodsTagId END     :: Integer
                                         , inGoodsTypeId      := CASE WHEN COALESCE (vbGoodsTypeId, 0) <> 0 THEN vbGoodsTypeId ELSE tmp.GoodsTypeId END    :: Integer
                                         , inGoodsSizeId      := CASE WHEN COALESCE (vbGoodsSizeId, 0) <> 0 THEN vbGoodsSizeId ELSE tmp.GoodsSizeId END    :: Integer
                                         , inProdColorId      := CASE WHEN COALESCE (vbProdColorId, 0) <> 0 THEN vbProdColorId ELSE tmp.ProdColorId END    :: Integer
                                         , inPartnerId        := CASE WHEN COALESCE (vbPartnerId, 0) <> 0 THEN vbPartnerId ELSE tmp.PartnerId END      :: Integer
                                         , inUnitId           := tmp.UnitId                :: Integer
                                         , inDiscountParnerId := CASE WHEN COALESCE (vbDiscountParnerId, 0) <> 0 THEN vbDiscountParnerId ELSE tmp.DiscountParnerId END :: Integer
                                         , inTaxKindId        := CASE WHEN COALESCE (vbTaxKindId, 0) <> 0 THEN vbTaxKindId ELSE tmp.TaxKindId END :: Integer
                                         , inSession          := inSession        :: TVarChar
                                         )
       FROM gpSelect_Object_Goods(FALSE, inSession) AS tmp
       WHERE tmp.Id = vbGoodsId;
   END IF;

   --- ������
   vbPriceList1Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PriceList() AND Object.ValueData Like ('��������� ����'));
   vbPriceList2Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PriceList() AND Object.ValueData Like ('��������� ���� 2'));
   
   --
   IF COALESCE (inPrice1,0) <> 0
   THEN
   PERFORM gpInsertUpdate_Object_PriceListItem_From_Excel (inOperDate     := CURRENT_DATE   :: TDateTime
                                                         , inPriceListId  := vbPriceList1Id :: Integer
                                                         , inGoodsId      := vbGoodsId      :: Integer
                                                         , inPriceValue   := inPrice1       :: TFloat
                                                         , inSession      := inSession      :: TVarChar  
                                                          );
   END IF;
   --
   IF COALESCE (inPrice2,0) <> 0
   THEN
   PERFORM gpInsertUpdate_Object_PriceListItem_From_Excel (inOperDate     := CURRENT_DATE   :: TDateTime
                                                         , inPriceListId  := vbPriceList2Id :: Integer
                                                         , inGoodsId      := vbGoodsId      :: Integer
                                                         , inPriceValue   := inPrice2       :: TFloat
                                                         , inSession      := inSession      :: TVarChar  
                                                          );   
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods_From_Excel()