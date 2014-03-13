-- Function: gpInsertUpdate_Object_ToolsWeighing()

DROP FUNCTION IF EXISTS gpUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_ToolsWeighing(
 INOUT ioId                  Integer   ,
    IN inCode                Integer  ,
    IN inNameUser	         TVarChar  ,
    IN inValueData           TVarChar  ,
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());
   vbUserId := inSession;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), inCode, inValueData);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ToolsWeighing_NameUser(), ioId, inNameUser);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.03.14                                                         *

*/

-- ����
-- SELECT * FROM gpUpdate_Object_ToolsWeighing()
