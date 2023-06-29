-- Function: gpInsertUpdate_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorItems(
 INOUT ioId                     Integer   ,    -- ���� ������� <�����>
    IN inCode                   Integer   ,    -- ��� �������
    IN inProductId              Integer   ,
    IN inGoodsId                Integer   ,
    IN inProdColorPatternId     Integer   ,
    IN inMaterialOptionsId      Integer   ,
    IN inMovementId_OrderClient Integer   ,
    IN inComment                TVarChar  ,
    IN inIsEnabled              Boolean   ,
 INOUT ioIsProdOptions          Boolean   ,    -- �������� ��� �����
    IN inSession                TVarChar       -- ������ ������������
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
   -- ��������
   IF COALESCE (inMovementId_OrderClient, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� <����� �������> �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdColorItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- ��������
   IF inIsEnabled = TRUE
      AND COALESCE (inMaterialOptionsId, 0) = 0
      -- ���� ���� � ������
      AND EXISTS (SELECT 1
                  FROM Object AS Object_ProdOptions
                       -- ��������� �����
                       INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                             ON ObjectLink_MaterialOptions.ObjectId      = Object_ProdOptions.Id
                                            AND ObjectLink_MaterialOptions.DescId        = zc_ObjectLink_ProdOptions_MaterialOptions()
                                            AND ObjectLink_MaterialOptions.ChildObjectId > 0
                       -- ������ � ����� ����������
                       INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                             ON ObjectLink_ProdColorPattern.ObjectId      = Object_ProdOptions.Id
                                            AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                            AND ObjectLink_ProdColorPattern.ChildObjectId = inProdColorPatternId
                  WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                    AND Object_ProdOptions.isErased = FALSE
                 )
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� <��������� �����> �� ����������.'
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
                                                 , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
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

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_MaterialOptions(), ioId, inMaterialOptionsId);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdColorItems_OrderClient(), ioId, inMovementId_OrderClient);

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
