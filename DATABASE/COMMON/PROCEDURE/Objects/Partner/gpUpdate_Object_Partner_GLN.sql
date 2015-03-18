-- Function: gpUpdate_Object_Partner_Order()


DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_GLN (Integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_GLN(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inGLNCodeJuridical    TVarChar  ,    -- ��� GLN - ����������
    IN inGLNCodeRetail       TVarChar  ,    -- ��� GLN - ����������
    IN inGLNCodeCorporate    TVarChar  ,    -- ��� GLN - ���������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_GLN());

   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);

   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeJuridical(), ioId, inGLNCodeJuridical);
   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeRetail(), ioId, inGLNCodeRetail);   
   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeCorporate(), ioId, inGLNCodeCorporate);   


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.03.15         *

*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_GLN()
