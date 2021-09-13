-- Function: gpInsertUpdate_Object_User()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId                 Integer   ,    -- ���� ������� <������������> 
    IN inCode               Integer   ,    -- 
    IN inUserName           TVarChar  ,    -- ������� �������� ������������ ������� <������������> 
    IN inPassword           TVarChar  ,    -- ������ ������������ 
    IN inSign               TVarChar  ,    -- ����������� �������
    IN inSeal               TVarChar  ,    -- ����������� ������
    IN inKey                TVarChar  ,    -- ���������� ���� 
    IN inProjectMobile      TVarChar  ,    -- �������� � ��� ����-��
    IN inisProjectMobile    Boolean   ,    -- ������� - ��� �������� �����
    IN inisSite             Boolean   ,    -- ������� - ��� �����
    IN inMemberId           Integer   ,    -- ���. ����
    IN inPasswordWages      TVarChar  ,    -- ������ ������������ 
    IN inisWorkingMultiple  Boolean   ,    -- ������ �� ���������� �������
    IN inSession            TVarChar       -- ������ ������������
)
  RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- �������� ������������ ��� �������� <������������ ������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_User(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), inCode, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Sign(), ioId, inSign);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Seal(), ioId, inSeal);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Key(), ioId, inKey);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_ProjectMobile(), ioId, inProjectMobile);

   -- �������� <��� �����>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_Site(), ioId, inisSite);
       
   -- �������� <������ �� ���������� �������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_WorkingMultiple(), ioId, inisWorkingMultiple);
       
   IF inisProjectMobile = TRUE
   THEN
       -- ������ ������
       PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_ProjectMobile(), ioId, inisProjectMobile);
   ELSEIF EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile())
   THEN
       -- ����� ������
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_ProjectMobile(), ioId, inisProjectMobile);
   -- ����� - ��������� NULL
   END IF;

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_Member(), ioId, inMemberId);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_PasswordWages(), ioId, inPasswordWages);


   -- ������� ���������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.08.19                                                       *
 06.11.17         * inisSite
 21.04.17         *
 12.09.16         *
 07.06.13                                        * lpCheckRight
*/

-- select ObjectCode from Object where DescId = zc_Object_User() group by ObjectCode having count (*) > 1
-- select ValueData from Object where DescId = zc_Object_User() group by ValueData having count (*) > 1

-- ����
-- SELECT * FROM gpInsertUpdate_Object_User ('2')
