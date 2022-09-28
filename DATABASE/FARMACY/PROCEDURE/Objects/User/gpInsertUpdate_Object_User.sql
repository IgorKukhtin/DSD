-- Function: gpInsertUpdate_Object_User()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId                     Integer   ,    -- ���� ������� <������������> 
    IN inCode                   Integer   ,    -- 
    IN inUserName               TVarChar  ,    -- ������� �������� ������������ ������� <������������> 
    IN inPassword               TVarChar  ,    -- ������ ������������ 
    IN inSign                   TVarChar  ,    -- ����������� �������
    IN inSeal                   TVarChar  ,    -- ����������� ������
    IN inKey                    TVarChar  ,    -- ���������� ���� 
    IN inProjectMobile          TVarChar  ,    -- �������� � ��� ����-��
    IN inisProjectMobile        Boolean   ,    -- ������� - ��� �������� �����
    IN inisSite                 Boolean   ,    -- ������� - ��� �����
    IN inMemberId               Integer   ,    -- ���. ����
    IN inPasswordWages          TVarChar  ,    -- ������ ������������ 
    IN inisWorkingMultiple      Boolean   ,    -- ������ �� ���������� �������
    IN inisNewUser              Boolean   ,    -- ����� ���������
    IN inisDismissedUser        Boolean   ,    -- ��������� ���������
    IN inisInternshipCompleted  Boolean   ,    -- ���������� ���������
    IN inSession                TVarChar       -- ������ ������������
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

   IF COALESCE (ioId, 0) = 0
   THEN
     inisNewUser := TRUE;
     inisDismissedUser := FALSE;
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), inCode, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Sign(), ioId, inSign);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Seal(), ioId, inSeal);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Key(), ioId, inKey);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_ProjectMobile(), ioId, inProjectMobile);

   IF COALESCE (inisSite, FALSE) = TRUE AND COALESCE (inisNewUser, FALSE) = TRUE AND
      NOT EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId 
                                                AND ObjectBoolean.DescId = zc_ObjectBoolean_User_Site() 
                                                AND ObjectBoolean.ValueData = TRUE)
   THEN
     inisNewUser := FALSE;
   END IF;

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

   -- �������� <����� ���������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_NewUser(), ioId, inisNewUser);
   -- �������� <��������� ���������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_DismissedUser(), ioId, inisDismissedUser);

   IF COALESCE (inisInternshipCompleted, FALSE) <>
      COALESCE((SELECT ObjectBoolean.ValueData 
                FROM ObjectBoolean 
                WHERE ObjectBoolean.ObjectId = ioId 
                  AND ObjectBoolean.DescId = zc_ObjectBoolean_User_InternshipCompleted()), FALSE)
   THEN
     -- �������� <���������� ���������>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_InternshipCompleted(), ioId, inisInternshipCompleted);
     
     if COALESCE (inisInternshipCompleted, FALSE) = TRUE
     THEN
       -- �������� <������������� ����������>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_User_InternshipConfirmation(), ioId, 0);
       -- �������� <���� ������������� ����������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_InternshipCompleted(), ioId, CURRENT_DATE);
     ELSE
       IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       THEN
         RAISE EXCEPTION '�������� <���������� ���������>. ��������� ������ ���������� ��������������';
       END IF;     
     END IF;
   END IF;


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