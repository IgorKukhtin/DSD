-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , Integer, TDateTime, TFloat, TVarChar);
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                     Integer   , -- ���� ������� <�����>
    IN inCode                   Integer   , -- ��� ������� <�����>
    IN inName                   TVarChar  , -- �������� ������� <�����>
    IN inArticle                TVarChar,
    IN inArticleVergl           TVarChar,
    IN inEAN                    TVarChar,
    IN inASIN                   TVarChar,
    IN inMatchCode              TVarChar,
    IN inFeeNumber              TVarChar,
    IN inComment                TVarChar,
    IN inIsArc                  Boolean,
    IN inFeet                   TFloat,
    IN inMetres                 TFloat,            
    IN inAmountMin              TFloat,
    IN inAmountRefer            TFloat,
    IN inEKPrice                TFloat,
    IN inEmpfPrice              TFloat,
    IN inGoodsGroupId           Integer,
    IN inMeasureId              Integer,
    IN inGoodsTagId             Integer,
    IN inGoodsTypeId            Integer,
    IN inGoodsSizeId            Integer,
    IN inProdColorId            Integer,
    IN inPartnerId              Integer,
    IN inUnitId                 Integer,
    IN inDiscountPartnerId      Integer,
    IN inTaxKindId              Integer,
    IN inEngineId               Integer, 
    IN inPriceListId            Integer   ,      
    IN inStartDate_price        TDateTime ,
    IN inOperPriceList          TFloat,  
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGroupNameFull TVarChar;
   DECLARE vbIsInsert Boolean;
   DECLARE vbInfoMoneyId Integer;

   DECLARE vbObjectName TVarChar;
   DECLARE vbFieldName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   --IF inComment NOT IN ('Korpus-SCconsole', 'Hypalon', 'Kreslo') THEN RAISE EXCEPTION 'Test.%inName = <%>%inArticle = <%>%inComment = <%>%inProdColorId = <%>', CHR (13), inName, CHR (13), inArticle, CHR (13), inComment, CHR (13), lfGet_Object_ValueData_sh (inProdColorId); END IF;

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   --
   IF inCode = -1
   THEN
       inCode:= (SELECT COALESCE (MIN (Object.ObjectCode), 0) - 1 FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode < 0);

   ELSEIF COALESCE (ioId, 0) = 0 AND inCode = -1
   THEN
       inCode:= (SELECT COALESCE (MIN (Object.ObjectCode), 0) - 1 FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode < 0);

   ELSEIF COALESCE (ioId, 0) = 0
   THEN
       -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
       inCode:= lfGet_ObjectCode (inCode, zc_Object_Goods());

   ELSEIF COALESCE (inCode, 0) = 0
   THEN
       -- ����� ���
       inCode:= (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   END IF;


   -- �������� ������������ <���>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), inCode, vbUserId); END IF;

   -- !!! �������� ������������ <ArticleNr>
   IF inArticle <> ''
   THEN
       -- PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Article(), inArticle, vbUserId);
       --
       IF EXISTS (SELECT 1 FROM ObjectString AS OS JOIN Object ON Object.Id = ObjectId AND Object.isErased = FALSE WHERE OS.DescId = zc_ObjectString_Article() AND OS.ValueData = inArticle AND OS.ObjectId <> COALESCE (ioId, 0))
       THEN
           --
           SELECT ObjectDesc.ItemName, ObjectStringDesc.ItemName
                  INTO vbObjectName, vbFieldName
           FROM ObjectString
                LEFT JOIN Object           ON Object.Id          = ObjectString.ObjectId
                LEFT JOIN ObjectDesc       ON ObjectDesc.Id       = Object.DescId
                LEFT JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
           WHERE ObjectString.DescId = zc_ObjectString_Article() AND ObjectString.ValueData = inArticle AND ObjectString.ObjectId <> COALESCE (ioId, 0);
    
           --
           RAISE EXCEPTION '�������� <%> �� ���������%���� <%> ��� ���� <%>%� ����������� <%>.(%)', inArticle, CHR (13), lfGet_Object_ValueData_sh (inProdColorId), vbFieldName, CHR (13), vbObjectName, ioId;

       END IF;

   END IF;


   -- �������� <Kreslo>
   /*IF TRIM (COALESCE (inComment, '')) ILIKE 'Kreslo'
   THEN
       --RAISE EXCEPTION '������.�������� <��������> ������ ���� �����������.';
       RAISE EXCEPTION '������.��� �������� <Kreslo> ����� �������� = <%> Code = <%> Article = <%> EAN = <%> Group = <%>'
                     , inName, inCode, inArticle, inEAN, lfGet_Object_ValueData_sh (inGoodsGroupId)
                      ;
   END IF;*/

   -- �������� <inName>
   IF TRIM (COALESCE (inName, '')) = ''
   THEN
       --RAISE EXCEPTION '������.�������� <��������> ������ ���� �����������.';
       RAISE EXCEPTION '������.�������� <��������> ������ ���� �����������. Code = <%> Article = <%> EAN = <%> Group = <%> Comment = <%>'
                     , inCode, inArticle, inEAN, lfGet_Object_ValueData_sh (inGoodsGroupId), inComment
                      ;
   END IF;

   -- �������� <GoodsGroupId>
   IF COALESCE (inGoodsGroupId, 0) = 0
   THEN
       --RAISE EXCEPTION '������.�������� <������ �������> ������ ���� �����������.';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� <������ �������> ������ ���� �����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_Goods'
                                             , inUserId        := vbUserId);
   END IF;

   -- �� ��������� ������ ��� ����������� <�� ������ ����������>
   vbInfoMoneyId:= lfGet_Object_GoodsGroup_InfomoneyId (inGoodsGroupId);
   -- �������� <InfoMoneyId>
   /*IF COALESCE (vbInfoMoneyId, 0) = 0
   THEN
       --RAISE EXCEPTION '������.�������� <�� ������ ����������> �� ������� ��� ������ <%>.', lfGet_Object_ValueData (inGoodsGroupId);
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� <�� ������ ����������> �� ������� ��� ������ <%>.'  :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Goods'           :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := lfGet_Object_ValueData (inGoodsGroupId) :: TVarChar
                                             );
   END IF;
   */

   -- �� ��������� ������ ��� ����������� <������� ������>
   --inGoodsTagId:= lfGet_Object_GoodsGroup_GoodsTagId (inGoodsGroupId);

   -- �������� �������� <������ �������� ������>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), inCode, inName, NULL);

   -- ��������� �������� <������ �������� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
   -- ��������� �������� <>
   IF inFeeNumber <> ''
   THEN
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_FeeNumber(), ioId, TRIM (inFeeNumber));
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ArticleVergl(), ioId, inArticleVergl);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_EAN(), ioId, inEAN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ASIN(), ioId, inASIN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MatchCode(), ioId, inMatchCode);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Min(), ioId, inAmountMin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Refer(), ioId, inAmountRefer);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_EKPrice(), ioId, inEKPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_EmpfPrice(), ioId, inEmpfPrice);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Feet(), ioId, inFeet);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Metres(), ioId, inMetres);


   -- ��������� ����� � <������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� ���� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ioId, inGoodsTagId);
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsType(), ioId, inGoodsTypeId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsSize(), ioId, inGoodsSizeId);
   -- ��������� ����� � <>
   --IF inProdColorId > 0 THEN
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), ioId, inProdColorId);
   --END IF;
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Partner(), ioId, inPartnerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Unit(), ioId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_DiscountPartner(), ioId, inDiscountPartnerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TaxKind(), ioId, inTaxKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Engine(), ioId, inEngineId);

   -- ��������� ����� � ***<�� ������ ����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, vbInfoMoneyId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Arc(), ioId, inIsArc);
   -- ��������� �������� <>
   --PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_PartnerDate(), ioId, inPartnerDate);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- ��������� �������� <���� ���������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (���������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   END IF;


   --��������� ����
   PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := NULL                  -- ��� ������ ������ Id
                                                         , inPriceListId:= COALESCE (inPriceListId, zc_PriceList_Basis()) ::Integer  -- !!!������� �����!!!
                                                         , inGoodsId    := ioId               :: Integer
                                                         , inOperDate   := inStartDate_price  :: TDateTime
                                                         , ioPriceNoVAT := inOperPriceList    :: TFloat
                                                         , ioPriceWVAT  := 0                  :: TFloat
                                                         , inIsLast     := TRUE               :: Boolean
                                                         , inSession    := inSession          :: TVarChar
                                                          ) AS tmp;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.04.22         *
 11.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
