-- Function: gpInsertUpdate_Object_User_Lite()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User_Lite (Integer, TVarChar, TVarChar, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User_Lite(
 INOUT ioId                 Integer   ,    -- ���� ������� <������������> 
    IN inUserName           TVarChar  ,    -- ������� �������� ������������ ������� <������������> 
    IN inPassword           TVarChar  ,    -- ������ ������������ 
    IN inMemberId           Integer   ,    -- ���. ����
    IN inisNewUser          Boolean   ,    -- ����� ���������
    IN inSession            TVarChar       -- ������ ������������
)
  RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode_calc Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession::Integer;

   -- �������� ������������ ��� �������� <������������ ������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName);

   -- �������� ����� ���
   IF ioId <> 0  THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc:= lfGet_ObjectCode (vbCode_calc, zc_Object_Member());

   IF COALESCE (ioId, 0) = 0
   THEN
     inisNewUser := TRUE;
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), vbCode_calc, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_Member(), ioId, inMemberId);

   -- �������� <����� ���������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_NewUser(), ioId, inisNewUser);

   -- ������� ���������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.04.22                                                       *
*/


-- ����
-- SELECT * FROM gpInsertUpdate_Object_User_Lite ('2')