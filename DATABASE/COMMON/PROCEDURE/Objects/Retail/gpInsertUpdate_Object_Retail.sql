-- Function: gpInsertUpdate_Object_Retail()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Retail(
 INOUT ioId                Integer   ,     -- ���� ������� <�������� ����> 
    IN inCode              Integer   ,     -- ��� �������  
    IN inName              TVarChar  ,     -- �������� ������� 
    IN inGLNCode           TVarChar  ,     -- ��� GLN - ����������
    IN inGLNCodeCorporate  TVarChar  ,     -- ��� GLN - ��������� 
    IN inGoodsPropertyId   Integer   ,    -- �������������� ������� �������
    IN inSession           TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Retail());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Retail());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Retail(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Retail(), vbCode_calc);
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Retail(), vbCode_calc, inName);
   
   -- ��������� ��-�� <��� GLN - ����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
   -- ��������� ��-�� <��� GLN - ���������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCodeCorporate(), ioId, inGLNCodeCorporate);
   
   -- ��������� ����� � <�������������� ������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_GoodsProperty(), ioId, inGoodsPropertyId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Retail (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.02.15         * add inGoodsPropertyId
 10.11.14         * add GLNCode
 23.05.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Retail(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')