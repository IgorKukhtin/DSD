--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , Integer, Integer, Integer
                                                              , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , Boolean
                                                              , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                              , TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , Integer, Integer, Integer
                                                              , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                              , TVarChar
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
    IN inDiscountPartner  TVarChar,
    IN inComment1        TVarChar,
    IN inComment2        TVarChar,
    IN inModelEtiketen   TVarChar,
    IN inIsArc           TVarChar,
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
   DECLARE vbDiscountPartnerId Integer;
   DECLARE vbPriceList1Id Integer;
   DECLARE vbPriceList2Id Integer;
   DECLARE vbMeasureId Integer;
   DECLARE vbModelEtiketenId Integer;
   DECLARE vbIsArc           Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
   vbUserId:= lpGetUserBySession (inSession);

/*
       IF inObjectCode = 1850
       THEN
         RAISE EXCEPTION '������. inArticle = <%>   Name = <%>   ObjectCode = <%>.', inArticle, inName, inObjectCode;
       ELSE if inObjectCode in (1851,
1044,
1045,
1020,
3121,
1018,
12938)
then
    RAISE EXCEPTION '������. inArticle = <%>   Name = <%>   ObjectCode = <%>.', inArticle, inName, inObjectCode;
else RETURN;

       END IF;
       END IF;
*/

   -- ��������
   IF COALESCE (TRIM (inName), '') = '' OR inObjectCode <= 0 THEN RETURN; END IF;


 --RAISE EXCEPTION 'inisArc    % ', inisArc;
   IF TRIM (inisArc) ILIKE 'J'
   THEN vbIsArc:= TRUE;
   ELSE
       vbIsArc:= FALSE;
   END IF;


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

   -- ������� ����� �������
   IF COALESCE (inName, '') <> '' AND inObjectCode > 0
   THEN
       -- �� ����
       vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inObjectCode);
       
   ELSE
       IF COALESCE (vbGoodsId, 0) = 0
       THEN
         --RAISE EXCEPTION '������.��� ������ ��� Article = <%>   Name = <%>   ObjectCode = <%>.', inArticle, inName, inObjectCode;
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.��� ������ ��� Article = <%>   Name = <%>   ObjectCode = <%>.' :: TVarChar
                                                 , inProcedureName := 'gpInsertUpdate_Object_Goods_From_Excel' :: TVarChar
                                                 , inUserId        := vbUserId
                                                 , inParam1        := inArticle    :: TVarChar
                                                 , inParam2        := inName       :: TVarChar
                                                 , inParam3        := inObjectCode :: TVarChar
                                                 );
       END IF;

       RAISE EXCEPTION '������.???';

   END IF;



   IF COALESCE (inGoodsGroupCode, 0) <> 0
   THEN
       -- ������� ����� ������ �������������
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
        --RAISE EXCEPTION '������.������ ������ � ����� = <%> �� �������. ����� <%>', inGoodsGroupCode, inName;
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ������ � ����� = <%> �� �������. ����� (<%>)<%>' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_Goods_From_Excel' :: TVarChar
                                              , inUserId        := vbUserId
                                              , inParam1        := inGoodsGroupCode    :: TVarChar
                                              , inParam2        := inObjectCode :: TVarChar
                                              , inParam3        := inName       :: TVarChar
                                              );
   END IF;

   /*IF COALESCE (inPartnerCode, 0) <> 0
   THEN
       -- ������� ����� 
       vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ObjectCode = inPartnerCode);
       --���� �� ����� ������
       IF COALESCE (vbPartnerId,0) = 0
       THEN
            --RAISE EXCEPTION '������.������� � ����� = <%> �� ������.', inPartnerCode;
            RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� � ����� = <%> �� ������.' :: TVarChar
                                                  , inProcedureName := 'gpInsertUpdate_Object_Goods_From_Excel' :: TVarChar
                                                  , inUserId        := vbUserId
                                                  , inParam1        := inPartnerCode    :: TVarChar
                                                  );
       END IF;
   END IF;*/

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

   -- ��� ��������-2
   IF COALESCE (inGoodsTag, '') <> '' AND 0=1
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
                              FROM gpInsertUpdate_Object_ProdColor_Load (ioId        := 0         :: Integer
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
                                                                , inInfo      := '' ::TVarChar
                                                                , inComment   := '' ::TVarChar
                                                                , inSession   := inSession :: TVarChar
                                                                 ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inDiscountPartner, '') <> ''
   THEN
       -- ������� ����� 
       vbDiscountPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_DiscountPartner() AND TRIM (Object.ValueData) Like TRIM (inDiscountPartner));
       --���� �� ������� �������
       IF COALESCE (vbDiscountPartnerId,0) = 0
       THEN
            vbDiscountPartnerId := (SELECT tmp.ioId
                                   FROM gpInsertUpdate_Object_DiscountPartner (ioId        := 0         :: Integer
                                                                            , ioCode      := 0         :: Integer
                                                                            , inName      := TRIM (inDiscountPartner) ::TVarChar
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
                                              , inName             := (TRIM (inName)  || ' ' || TRIM (inGoodsTag))       :: TVarChar
                                              , inArticle          := TRIM (inArticle)      :: TVarChar
                                              , inArticleVergl     := TRIM (inArticleVergl) :: TVarChar
                                              , inEAN              := TRIM (inEAN)          :: TVarChar
                                              , inASIN             := TRIM (inASIN)         :: TVarChar
                                              , inMatchCode        := TRIM (inMatchCode)    :: TVarChar 
                                              , inFeeNumber        := TRIM (inFeeNumber)     :: TVarChar
                                              , inComment          := CASE WHEN TRIM (inComment1) <> '' OR TRIM (inComment2) <> '' THEN (TRIM (inComment1)||' / '||TRIM (inComment2)) ELSE '' END  :: TVarChar
                                              , inIsArc            := vbIsArc
                                              , inAmountMin        := inMin            :: TFloat
                                              , inAmountRefer      := inRefer          :: TFloat
                                              , inEKPrice          := inEmpfPrice      :: TFloat
                                              , inEmpfPrice        := inEmpfPrice      :: TFloat
                                              , inGoodsGroupId     := vbGoodsGroupId   :: Integer
                                              , inMeasureId        := vbMeasureId      :: Integer
                                              , inGoodsTagId       := 0 -- vbGoodsTagId     :: Integer
                                              , inGoodsTypeId      := vbGoodsTypeId    :: Integer
                                              , inGoodsSizeId      := vbGoodsSizeId    :: Integer
                                              , inProdColorId      := vbProdColorId    :: Integer
                                              , inPartnerId        := vbPartnerId      :: Integer
                                              , inUnitId           := 0                :: Integer
                                              , inDiscountPartnerId := vbDiscountPartnerId    :: Integer
                                              , inTaxKindId        := vbTaxKindId      :: Integer
                                              , inEngineId         := NULL
                                              , inSession          := inSession        :: TVarChar
                                              );
   ELSE
       -- ���������
       PERFORM gpInsertUpdate_Object_Goods(ioId               := COALESCE (tmp.Id, vbGoodsId)::  Integer
                                         , inCode             := COALESCE (tmp.Code, inObjectCode)    :: Integer
                                         , inName             := COALESCE (TRIM (inName)  || ' ' || TRIM (inGoodsTag), tmp.Name)   :: TVarChar
                                         , inArticle          := CASE WHEN TRIM (inArticle) <> '' THEN TRIM (inArticle) ELSE tmp.Article END :: TVarChar
                                         , inArticleVergl     := CASE WHEN TRIM (inArticleVergl) <> '' THEN TRIM (inArticleVergl) ELSE tmp.ArticleVergl END:: TVarChar
                                         , inEAN              := CASE WHEN TRIM (inEAN) <> '' THEN TRIM (inEAN) ELSE tmp.EAN END:: TVarChar
                                         , inASIN             := CASE WHEN TRIM (inASIN) <> '' THEN TRIM (inASIN) ELSE tmp.ASIN END:: TVarChar
                                         , inMatchCode        := CASE WHEN TRIM (inMatchCode) <> '' THEN TRIM (inMatchCode) ELSE tmp.MatchCode END:: TVarChar 
                                         , inFeeNumber        := CASE WHEN TRIM (inFeeNumber) <> '' THEN TRIM (inFeeNumber) ELSE tmp.FeeNumber END:: TVarChar
                                         , inComment          := CASE WHEN TRIM (inComment1) <> '' OR TRIM (inComment2) <> '' THEN (TRIM (inComment1)||' / '||TRIM (inComment2)) ELSE tmp.Comment END  :: TVarChar
                                         , inisArc            := COALESCE (vbIsArc, tmp.isArc, FALSE)    :: Boolean
                                         , inAmountMin        := CASE WHEN COALESCE (inMin, 0) <> 0 THEN inMin ELSE tmp.AmountMin END :: TFloat
                                         , inAmountRefer      := CASE WHEN COALESCE (inRefer, 0) <> 0 THEN inRefer ELSE tmp.AmountRefer END :: TFloat
                                         , inEKPrice          := CASE WHEN COALESCE (inEKPrice, 0) <> 0 THEN inEKPrice ELSE tmp.EKPrice END      :: TFloat
                                         , inEmpfPrice        := CASE WHEN COALESCE (inEmpfPrice, 0) <> 0 THEN inEmpfPrice ELSE tmp.EmpfPrice END  :: TFloat
                                         , inGoodsGroupId     := CASE WHEN COALESCE (vbGoodsGroupId, 0) <> 0 THEN vbGoodsGroupId ELSE tmp.GoodsGroupId END  :: Integer
                                         , inMeasureId        := CASE WHEN COALESCE (tmp.MeasureId, 0) <> 0 THEN tmp.MeasureId ELSE vbMeasureId END      :: Integer
                                         , inGoodsTagId       := tmp.GoodsTagId
                                         , inGoodsTypeId      := CASE WHEN COALESCE (vbGoodsTypeId, 0) <> 0 THEN vbGoodsTypeId ELSE tmp.GoodsTypeId END    :: Integer
                                         , inGoodsSizeId      := CASE WHEN COALESCE (vbGoodsSizeId, 0) <> 0 THEN vbGoodsSizeId ELSE tmp.GoodsSizeId END    :: Integer
                                         , inProdColorId      := CASE WHEN COALESCE (vbProdColorId, 0) <> 0 THEN vbProdColorId ELSE tmp.ProdColorId END    :: Integer
                                         , inPartnerId        := CASE WHEN COALESCE (vbPartnerId, 0) <> 0 THEN vbPartnerId ELSE tmp.PartnerId END      :: Integer
                                         , inUnitId           := tmp.UnitId                :: Integer
                                         , inDiscountPartnerId := CASE WHEN COALESCE (vbDiscountPartnerId, 0) <> 0 THEN vbDiscountPartnerId ELSE tmp.DiscountPartnerId END :: Integer
                                         , inTaxKindId        := CASE WHEN COALESCE (vbTaxKindId, 0) <> 0 THEN vbTaxKindId ELSE tmp.TaxKindId END :: Integer
                                         , inEngineId         := tmp.EngineId
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.09.22                                                       *
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods_From_Excel()