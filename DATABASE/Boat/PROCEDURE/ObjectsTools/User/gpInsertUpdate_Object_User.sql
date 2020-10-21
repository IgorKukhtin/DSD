-- Function: gpInsertUpdate_Object_User()

-- DROP FUNCTION gpInsertUpdate_Object_User();
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId          Integer   ,    -- ���� ������� <������������> 
    IN inCode        Integer   ,    -- 
    IN inUserName    TVarChar  ,    -- ������� �������� ������������ ������� <������������> 
    IN inPassword    TVarChar  ,    -- ������ ������������ 
    --IN inPrinterName TVarChar  ,    -- ������� (������ ��������)
    IN inMemberId    Integer   ,    -- ���. ����
    IN in����Id  Integer   ,    -- ����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN inCode := NEXTVAL ('Object_User_seq'); END IF; 
 
   -- �������� ������������ ��� �������� <������������ ������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_User(), inCode, inUserName);

   -- ��������� ��������  <������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), ioId, inPassword);
   -- ��������� ��������  <�������>
   --PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Printer(), ioId, inPrinterName);

   -- ��������� ��������  <���. ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Member(), ioId, inMemberId);
   -- ��������� ��������  <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Language(), ioId, inLanguageId);

   -- ������� ���������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    �������� �.�.
 30.04.18         * inPrinterName
 15.02.18         *
 06.05.17                                                          *
 05.05.17                                                          *
 12.09.16         *
 07.06.13                                        * lpCheckRight
*/

-- select ObjectCode from Object where DescId = zc_Object_User() group by ObjectCode having count (*) > 1
-- select ValueData from Object where DescId = zc_Object_User() group by ValueData having count (*) > 1

-- ����
-- SELECT * FROM gpInsertUpdate_Object_User (zfCalc_UserAdmin())
