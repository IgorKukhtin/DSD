-- Function: gpInsertUpdate_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorItems(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                Integer   ,    -- ��� ������� 
    IN inProductId           Integer   ,
    IN inGoodsId             Integer   ,
    IN inProdColorPatternId  Integer   ,
    IN inComment             TVarChar  ,
    IN inIsEnabled           Boolean   , 
 INOUT ioIsProdOptions       Boolean   ,    -- �������� ��� �����
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdColorItems());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������
   IF COALESCE (inProductId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.ProductId �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdColorItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- ��������
   IF COALESCE (inProdColorPatternId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdColorItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;


   IF inIsEnabled = FALSE
   THEN
       -- ��������
       IF COALESCE (ioId, 0) = 0
       THEN
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� �� ����� ���� ������.'
                                                 , inProcedureName := 'gpInsertUpdate_Object_ProdColorItems'
                                                 , inUserId        := vbUserId);
       END IF;

       -- �������
       PERFORM lpUpdate_Object_isErased (inObjectId:= ioId, inIsErased:= TRUE, inUserId:= vbUserId);

   ELSE
       -- ���������� ������� ��������/�������������
       vbIsInsert:= COALESCE (ioId, 0) = 0;
    
        -- ���� ��� �� ����������, ���������� ��� ��� ���������+1, ��� ������ ����� ������� � 1
       IF COALESCE (ioId,0) = 0 AND inCode = 0
       THEN
           vbCode_calc:= COALESCE ((SELECT MAX (Object_ProdColorItems.ObjectCode) AS ObjectCode
                                    FROM Object AS Object_ProdColorItems
                                         INNER JOIN ObjectLink AS ObjectLink_Product
                                                               ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                              AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()
                                                              AND ObjectLink_Product.ChildObjectId = inProductId AND COALESCE (inProductId,0) <> 0
                                    WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems())
                                   , 0) + 1; 
       ELSE 
            vbCode_calc:= inCode;
       END IF;
       
       -- �������� ���� ������������ ��� �������� <������������ >
       --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdColorItems(), inName, vbUserId);
    
       -- ��������� <������>
       ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdColorItems(), vbCode_calc, '');
    
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColorItems_Comment(), ioId, inComment);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ProdColorItems_ProdOptions(), ioId, ioIsProdOptions);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_Product(), ioId, inProductId);
    
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_Goods(), ioId, inGoodsId);
    
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_ProdColorPattern(), ioId, inProdColorPatternId);

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
 07.12.20         *
 09.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdColorItems()
