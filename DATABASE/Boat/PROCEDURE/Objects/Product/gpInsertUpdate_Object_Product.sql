-- Function: gpInsertUpdate_Object_Product()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Product(
 INOUT ioId                    Integer   ,    -- ���� ������� <�����>
    IN inCode                  Integer   ,    -- ��� �������
    IN inName                  TVarChar  ,    -- �������� �������
    IN inBrandId               Integer   ,
    IN inModelId               Integer   ,
    IN inEngineId              Integer   ,
    IN inIsBasicConf           Boolean   ,    -- �������� ������� ������������
    IN inIsProdColorPattern    Boolean   ,    -- ������������� �������� ��� Items Boat Structure
    IN inHours                 TFloat    ,
    IN inDateStart             TDateTime ,
    IN inDateBegin             TDateTime ,
    IN inDateSale              TDateTime ,
    IN inArticle               TVarChar  ,
    IN inCIN                   TVarChar  ,
    IN inEngineNum             TVarChar  ,
    IN inComment               TVarChar  ,
    IN inSession               TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
 --DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   -- vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Product());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- !!! �������� !!!
   IF CEIL (inCode / 2) * 2 = inCode THEN inDateSale:= NULL; END IF;


   -- �������� - ������ ���� ���
   IF COALESCE (inCode, 0) = 0 THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ��������� <Interne Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                            );
   END IF;
   -- �������� - ������ ���� �������
   IF COALESCE (inArticle, '') = '' THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ��������� <Artikel Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                            );
   END IF;
   -- ��������
   IF COALESCE (inModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ���������� <Model>' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), inCode, vbUserId);

   -- ������
   inName:= SUBSTRING (COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBrandId), ''), 1, 2)
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inModelId), '')
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inEngineId), '')
             || ' ' || inCIN
             ;

   -- �������� ���� ������������ ��� �������� <������������ >
 --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Product(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Product(), inCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Product_BasicConf(), ioId, inIsBasicConf);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Product_Hours(), ioId, inHours);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateStart(), ioId, inDateStart);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), ioId, inDateBegin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateSale(), ioId, inDateSale);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_CIN(), ioId, inCIN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), ioId, inEngineNum);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Product_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Brand(), ioId, inBrandId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Model(), ioId, inModelId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Engine(), ioId, inEngineId);


   -- ������ ��� ��������
   IF inIsProdColorPattern = TRUE AND (vbIsInsert = TRUE OR NOT EXISTS (SELECT 1
                                                                        FROM ObjectLink AS ObjectLink_Product
                                                                             INNER JOIN Object AS Object_ProdColorItems
                                                                                               ON Object_ProdColorItems.Id       = ObjectLink_Product.ObjectId
                                                                                              AND Object_ProdColorItems.isErased = FALSE
                                                                        WHERE ObjectLink_Product.ChildObjectId = ioId
                                                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                                                       ))
   THEN
       -- �������� ��� Items Boat Structure
       PERFORM gpInsertUpdate_Object_ProdColorItems (ioId                  := 0
                                                   , inCode                := 0
                                                   , inProductId           := ioId
                                                   , inGoodsId             := tmp.GoodsId
                                                   , inProdColorPatternId  := tmp.ProdColorPatternId
                                                   , inComment             := ''
                                                   , inIsEnabled           := TRUE
                                                   , ioIsProdOptions       := FALSE
                                                   , inSession             := inSession
                                                    )
       FROM gpSelect_Object_ProdColorItems (inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
       WHERE tmp.ProductId = ioId;

   END IF;



   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Product()
