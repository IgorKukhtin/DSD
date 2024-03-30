-- Function: gpInsertUpdate_Object_ReceiptGoodsChild()
   
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, NUMERIC (16, 8), NUMERIC (16, 8), TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TFloat, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoodsChild(
 INOUT ioId                  Integer   ,    -- ���� ������� <>
    IN inComment             TVarChar  ,    -- �������� �������
    IN inNPP                 Integer   ,
    IN inNPP_service         Integer   ,
    IN inReceiptGoodsId      Integer   ,
    IN inObjectId            Integer   ,
    IN inProdColorPatternId  Integer   ,
    IN inMaterialOptionsId   Integer   ,
    IN inReceiptLevelId_top  Integer   ,
    IN inReceiptLevelId      Integer   ,
    IN inGoodsChildId        Integer   ,
    IN inGoodsChildId_top    Integer   ,
   OUT outGoodsChildName     TVarChar  ,
 INOUT ioValue               TVarChar  ,
 INOUT ioValue_service       TVarChar  ,
 INOUT ioForCount            TFloat    ,
    IN inIsEnabled           Boolean   ,
   OUT outReceiptLevelName   TVarChar  ,
   OUT outDescName           TVarChar  ,
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbValue         NUMERIC (16, 8); 
   DECLARE vbValue_service NUMERIC (16, 8);
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoodsChild());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������
   vbValue        := zfConvert_StringToFloat (REPLACE (ioValue,         ',' , '.'));
   vbValue_service:= zfConvert_StringToFloat (REPLACE (ioValue_service, ',' , '.'));
   
   -- ������ ioValue ���� ������ 4-� ������, ����� ForCount = 1000 � � ioValue ����������� ioValue * 1000
   IF (vbValue <> vbValue :: TFloat) 
   THEN
       ioForCount:= 1000; 
       vbValue   := (vbValue * 1000) :: TFloat;
   ELSEIF COALESCE (ioForCount, 0) = 0
   THEN
       ioForCount:= 1; 
   END IF;

   -- ������
   IF vbValue = 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       vbValue:= vbValue_service :: TFloat;
   ELSE
       vbValue_service:= 0;
   END IF;                        
  --  RAISE EXCEPTION '%', ioValue;


   -- ��������
   IF COALESCE (inReceiptGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.ReceiptGoodsId �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptGoodsChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;
                  
   -- ��������
   IF COALESCE (inObjectId, 0) = 0 AND COALESCE (inProdColorPatternId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptGoodsChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- ������
   IF COALESCE (inReceiptLevelId, 0) = 0 AND inReceiptLevelId_top > 0
   THEN
       inReceiptLevelId := inReceiptLevelId_top;
   END IF;
   -- ������� � ����
   outReceiptLevelName :=  (SELECT Object.ValueData FROM Object WHERE Object.Id = inReceiptLevelId);

   -- ������
   IF COALESCE (ioId, 0) = 0
   THEN
       inIsEnabled:= TRUE;
   END IF;

   -- ������
   IF COALESCE (inGoodsChildId, 0) = 0 AND inGoodsChildId_top > 0
   THEN
       inGoodsChildId:= inGoodsChildId_top;
   END IF;
   -- ������� � ����
   outGoodsChildName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = inGoodsChildId);

   -- ������� � ����
   outDescName:= (SELECT ObjectDesc.ItemName FROM Object JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId WHERE Object.Id = inGoodsChildId);


   IF inIsEnabled = FALSE
   THEN
       -- ��������
       IF COALESCE (ioId, 0) = 0
       THEN
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� �� ����� ���� ������.'
                                                 , inProcedureName := 'gpInsertUpdate_Object_ReceiptGoodsChild'
                                                 , inUserId        := vbUserId);
       END IF;

       -- �������
       PERFORM lpUpdate_Object_isErased (inObjectId:= ioId, inIsErased:= TRUE, inUserId:= vbUserId);

   ELSE
       -- ���������� ������� ��������/�������������
       vbIsInsert:= COALESCE (ioId, 0) = 0;

       -- ��������� <������>
       ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptGoodsChild(), 0, inComment);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_Value(), ioId, vbValue);

       -- ��������� �������� <>
       IF COALESCE (ioForCount, 0) <= 0 THEN ioForCount:= 1; END IF;
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_ForCount(), ioId, ioForCount);
       
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_NPP_service(), ioId, inNPP_service :: TFloat);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods(), ioId, inReceiptGoodsId);

       -- ��������� �������� <>
       IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inProdColorPatternId AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_ProdColorPattern_Goods())
       THEN
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), ioId, inObjectId);
       ELSE
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), ioId, inObjectId);
       END IF;
       

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern(), ioId, inProdColorPatternId);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_MaterialOptions(), ioId, inMaterialOptionsId);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel(), ioId, inReceiptLevelId);
       
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_GoodsChild(), ioId, inGoodsChildId);

       -- ������
       IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
       THEN
           vbValue_service:= vbValue;
           vbValue:= 0;
       END IF;

   END IF;


   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- ��������� �������� <���� ����>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (����)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);

   END IF;

   IF inNPP > 0
   THEN
       -- ��� ��� ��-��
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_NPP(), ioId, inNPP :: TFloat);
   END IF;


   -- ���������� � ����
   ioValue        := CAST (vbValue         / CASE WHEN ioForCount > 0 THEN ioForCount ELSE 1 END AS TVarChar);
   ioValue_service:= CAST (vbValue_service AS TVarChar);


   IF inIsEnabled = TRUE
   THEN
       -- ��������� ��������
       PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.06.22         * inMaterialOptionsId
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoodsChild()