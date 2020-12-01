-- Function: gpInsertUpdate_Object_ReceiptProdModel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModel(Integer, Integer, TVarChar, Integer, Boolean, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptProdModel(
 INOUT ioId               Integer   ,    -- ���� ������� <�����>
    IN inCode             Integer   ,    -- ��� ������� 
    IN inName             TVarChar  ,    -- �������� �������
    IN inModelId          Integer   ,
    IN inisMain           Boolean   , 
    IN inUserCode         TVarChar  ,    -- ���������������� ���
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbBrandName TVarChar;
   DECLARE vbModelName TVarChar;
   DECLARE vbModelCode TVarChar;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptProdModel());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_ReceiptProdModel()); 

   SELECT Brand.ValueData AS BrandName
        , Model.ValueData AS ModelName
        , Model.ObjectCode :: TVarChar AS Code
  INTO vbBrandName, vbModelName, vbModelCode
   FROM ObjectLink
        INNER JOIN Object AS Brand ON Brand.Id = ObjectLink.ChildObjectId
        INNER JOIN Object AS Model ON Model.Id = ObjectLink.ObjectId
   WHERE ObjectLink.DescId = zc_ObjectLink_ProdModel_Brand() AND ObjectLink.ObjectId = inModelId;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptProdModel(), inCode, COALESCE (vbBrandName,'')||'-'||COALESCE (vbModelName,'')||'-'||COALESCE (inComment,'')||'-'||COALESCE (inUserCode, vbModelCode,''));

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptProdModel_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptProdModel_Code(), ioId, COALESCE (inUserCode, vbModelCode,''));

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ReceiptProdModel_Main(), ioId, inisMain);
      
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModel_Model(), ioId, inModelId);

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

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptProdModel()
