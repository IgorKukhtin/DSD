-- Function: gpUpdate_Object_Retail_GLNCode()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_GLNCode(
 INOUT ioId                Integer   ,  -- ���� ������� <�������� ����> 
    IN inGLNCode           TVarChar  ,  -- ��� GLN - ����������
    IN inGLNCodeCorporate  TVarChar  ,  -- ��� GLN - ��������� 
    IN inGoodsPropertyId   Integer   ,  -- �������������� ������� �������
    IN inSession           TVarChar     -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_GLNCode());

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
ALTER FUNCTION gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.03.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Retail_GLNCode(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')