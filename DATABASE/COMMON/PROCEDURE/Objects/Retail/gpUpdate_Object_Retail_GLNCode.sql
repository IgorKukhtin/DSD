-- Function: gpUpdate_Object_Retail_GLNCode()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_GLNCode(
 INOUT ioId             Integer   ,     -- ���� ������� <�������� ����> 
    IN inGLNCode        TVarChar  ,     -- ��� GLN
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_GLNCode());
   --vbUserId := inSession;

   -- ��������� ��-�� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.03.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Retail_GLNCode(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')