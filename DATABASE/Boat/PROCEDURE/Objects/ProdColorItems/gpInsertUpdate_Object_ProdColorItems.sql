-- Function: gpInsertUpdate_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorItems(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorItems(
 INOUT ioId               Integer   ,    -- ���� ������� <�����>
    IN inCode             Integer   ,    -- ��� ������� 
    IN inName             TVarChar  ,    -- �������� �������
    IN inProductId        Integer   ,
    IN inProdColorGroupId Integer   ,
    IN inProdColorId      Integer   ,
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdColorItems());
   vbUserId:= lpGetUserBySession (inSession);

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1, ��� ������ ����� ������� � 1
   IF COALESCE (ioId,0) = 0
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
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdColorItems(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdColorItems(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColorItems_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_Product(), ioId, inProductId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_ProdColorGroup(), ioId, inProdColorGroupId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorItems_ProdColor(), ioId, inProdColorId);

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
-- SELECT * FROM gpInsertUpdate_Object_ProdColorItems()
