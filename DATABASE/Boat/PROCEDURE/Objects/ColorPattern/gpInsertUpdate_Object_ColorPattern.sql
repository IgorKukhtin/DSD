-- Function: gpInsertUpdate_Object_ColorPattern()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ColorPattern(Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ColorPattern(
 INOUT ioId               Integer   ,    -- ���� ������� <�����>
    IN inCode             Integer   ,    -- ��� ������� 
    IN inName             TVarChar  ,    -- �������� �������
    IN inModelId          Integer   ,
    IN inUserCode         TVarChar  ,    -- ���������������� ���
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbModelName TVarChar;
   DECLARE vbModelCode TVarChar;
   DECLARE vbBrandName TVarChar;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_ColorPattern()); 

   SELECT Model.ValueData              AS ModelName
        , Model.ObjectCode :: TVarChar AS Code
        , Object_Brand.ValueData       AS BrandName
  INTO vbModelName, vbModelCode, vbBrandName
   FROM Object AS Model
        LEFT JOIN ObjectLink AS ObjectLink_Brand
                             ON ObjectLink_Brand.ObjectId = Model.Id
                            AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
        LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
   WHERE Model.DescId = zc_Object_ProdModel() AND Model.Id = inModelId;

   inUserCode := (CASE WHEN COALESCE (inUserCode,'') <>'' THEN inUserCode ELSE COALESCE (vbModelCode,'') END) :: TVarChar;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ColorPattern(), inCode, COALESCE (vbBrandName,'')||'-'||COALESCE (vbModelName,'')||'-'||COALESCE (inComment,'')||'-'||COALESCE (inUserCode,''));

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ColorPattern_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ColorPattern_Code(), ioId, COALESCE (inUserCode, vbModelCode,''));

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ColorPattern_Model(), ioId, inModelId);

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
 11.12.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ColorPattern()
