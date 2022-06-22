-- Function: gpInsertUpdate_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions(Integer, Integer, TVarChar, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions(Integer, Integer, TVarChar, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions(Integer, Integer, TVarChar, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptions(
 INOUT ioId           Integer   ,    -- ���� ������� <�������� �����>
    IN inCode         Integer   ,    -- ��� ������� 
    IN inName         TVarChar  ,    -- �������� ������� 
    IN inSalePrice    TFloat    ,
    IN inComment      TVarChar  ,
    IN inGoodsId      Integer   ,
    IN inModelId      Integer   ,
    IN inTaxKindId    Integer   ,
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdOptions());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProdOptions()); 

   -- �������� ������������ ��� �������� <�������� >
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdOptions(), inName, vbUserId);

   -- �������� - � ����� ����� ����� ������ ���������� �������� <�������������>
   IF inGoodsId > 0
      AND EXISTS (SELECT 1 FROM ObjectLink AS ObjectLink_ProdColorPattern_ProdOptions
                  WHERE ObjectLink_ProdColorPattern_ProdOptions.ChildObjectId = ioId
                    AND ObjectLink_ProdColorPattern_ProdOptions.DescId        = zc_ObjectLink_ProdColorPattern_ProdOptions()
                 )
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.��� ��������� ����� ������ ���������� �������� <�������������>.�.�. �������� ���������� � <Boat Structure>.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptions'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdOptions(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdOptions_Comment(), ioId, inComment);

   -- � ����� ����� ����� ���� = 0
   IF inGoodsId > 0
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptions_SalePrice(), ioId, 0);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptions_SalePrice(), ioId, inSalePrice);
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_TaxKind(), ioId, inTaxKindId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_Model(), ioId, inModelId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_Goods(), ioId, inGoodsId);


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
 27.12.20         *
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdOptions()
