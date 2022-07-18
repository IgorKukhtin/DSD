-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);*/

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);
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
    IN inisArc                  Boolean,
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
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGroupNameFull TVarChar;
   DECLARE vbIsInsert Boolean;
   DECLARE vbInfoMoneyId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   --
   IF COALESCE (ioId, 0) = 0
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
       PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Article(), inArticle, vbUserId);
   END IF;


   -- �������� <inName>
   IF TRIM (COALESCE (inName, '')) = ''
   THEN
       --RAISE EXCEPTION '������.�������� <��������> ������ ���� �����������.';
       RAISE EXCEPTION '% <%> <%>'
                     , lfMessageTraslate (inMessage       := '������.�������� <��������> ������ ���� �����������.'
                                        , inProcedureName := 'gpInsertUpdate_Object_Goods'
                                        , inUserId        := vbUserId
                                         )
                     , inArticle, inEAN
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
   IF inProdColorId > 0 THEN
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), ioId, inProdColorId);
   END IF;
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
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Arc(), ioId, inisArc);
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
