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
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), inCode, inValueData);

   -- ���������
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ToolsWeighing_NameUser(), ioId, inNameUser);

   -- ��������� ���������
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ToolsWeighing_NameUser(), OS_ToolsWeighing_Name_find.ObjectId, inNameUser)
   FROM ObjectString AS OS_ToolsWeighing_Name
        INNER JOIN ObjectString AS OS_ToolsWeighing_Name_find
                                ON OS_ToolsWeighing_Name_find.ValueData = OS_ToolsWeighing_Name.ValueData
                               AND OS_ToolsWeighing_Name_find.DescId = zc_ObjectString_ToolsWeighing_Name()
                               AND OS_ToolsWeighing_Name_find.ObjectId <> OS_ToolsWeighing_Name.ObjectId
   WHERE OS_ToolsWeighing_Name.ObjectId = ioId
     AND OS_ToolsWeighing_Name.DescId = zc_ObjectString_ToolsWeighing_Name();


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   -- ��������� �������� - ���������
   PERFORM lpInsert_ObjectProtocol (OS_ToolsWeighing_Name_find.ObjectId, vbUserId)
   FROM ObjectString AS OS_ToolsWeighing_Name
        INNER JOIN ObjectString AS OS_ToolsWeighing_Name_find
                                ON OS_ToolsWeighing_Name_find.ValueData = OS_ToolsWeighing_Name.ValueData
                               AND OS_ToolsWeighing_Name_find.DescId    = zc_ObjectString_ToolsWeighing_Name()
                               AND OS_ToolsWeighing_Name_find.ObjectId <> OS_ToolsWeighing_Name.ObjectId
   WHERE OS_ToolsWeighing_Name.ObjectId = ioId
     AND OS_ToolsWeighing_Name.DescId = zc_ObjectString_ToolsWeighing_Name();


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
