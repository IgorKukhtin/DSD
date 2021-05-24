-- Function: gpInsertUpdate_Object_ReplServer()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReplServer(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReplServer(
 INOUT ioId              Integer   ,    -- ���� ������� <>
    IN inCode            Integer   ,    -- ��� ������� 
    IN inName            TVarChar  ,    -- �������� ������� 
    IN inHost            TVarChar  ,    -- 
    IN inUser            TVarChar  ,    -- 
    IN inPassword        TVarChar  ,    --
    IN inPort            TVarChar  ,    -- 
    IN inDataBase        TVarChar  ,    -- 
    IN inSession         TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReplServer());
   vbUserId:= lpGetUserBySession (inSession);

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ReplServer()); 

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReplServer(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReplServer(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_Host(), ioId, inHost);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_User(), ioId, inUser);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_Password(), ioId, inPassword);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_Port(), ioId, inPort);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_DataBase(), ioId, inDataBase);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.06.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReplServer()
