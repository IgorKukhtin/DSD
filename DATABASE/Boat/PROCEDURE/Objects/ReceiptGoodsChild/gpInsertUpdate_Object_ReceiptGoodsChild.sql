-- Function: gpInsertUpdate_Object_ReceiptGoodsChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoodsChild(
 INOUT ioId                  Integer   ,    -- ���� ������� <>
    IN inComment             TVarChar  ,    -- �������� �������
    IN inReceiptGoodsId      Integer   ,
    IN inObjectId            Integer   ,
    IN inProdColorPatternId  Integer   ,
 INOUT ioValue               TFloat    ,
 INOUT ioValue_service       TFloat    ,
    IN inIsEnabled           Boolean   ,
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoodsChild());
   vbUserId:= lpGetUserBySession (inSession);


   -- ������
   IF ioValue = 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       ioValue:= ioValue_service;
   ELSE
       ioValue_service:= 0;
   END IF;



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
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_Value(), ioId, ioValue);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods(), ioId, inReceiptGoodsId);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), ioId, inObjectId);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern(), ioId, inProdColorPatternId);

       -- ������
       IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
       THEN
           ioValue_service:= ioValue;
           ioValue:= 0;
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
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoodsChild()
