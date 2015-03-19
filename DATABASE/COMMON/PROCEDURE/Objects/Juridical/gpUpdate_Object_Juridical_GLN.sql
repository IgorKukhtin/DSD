-- Function: gpUpdate_Object_Juridical_GLN()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_GLN (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_GLN(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inGoodsPropertyId     Integer   ,  -- �������������� ������� �������
    IN inSession             TVarChar       -- ������� ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_GLN());

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);
   
   -- ��������� ����� � <�������������� ������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Juridical_GLN (Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.03.15         *

*/

-- ����
-- SELECT * FROM gpUpdate_Object_Juridical_GLN