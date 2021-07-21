-- 

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SmsSettings (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SmsSettings(
 INOUT ioId              Integer,       -- ���� ������� <>
    IN inCode            Integer,       -- �������� <��� >
    IN inName            TVarChar,      -- 
    IN inLogin           TVarChar,      --
    IN inMessage         TVarChar,      --
    IN inPassword        TVarChar,      --
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SmsSettings());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_SmsSettings()); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_SmsSettings(), inCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SmsSettings_Login(), ioId, inLogin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SmsSettings_Message(), ioId, inMessage);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SmsSettings_Password(), ioId, inPassword);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_SmsSettings()