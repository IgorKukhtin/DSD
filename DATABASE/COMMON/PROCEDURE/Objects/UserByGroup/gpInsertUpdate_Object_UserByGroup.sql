-- Function: gpInsertUpdate_Object_UserByGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UserByGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserByGroup(
 INOUT ioId	                 Integer   ,   	-- ���� ������� <������ �� ���>
    IN inCode                Integer   ,    -- ��� ������� <������ �� ���>
    IN inName                TVarChar  ,    -- �������� ������� <������ �� ���>
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbCode Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   UserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_UserByGroup());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_UserByGroup()); 
   
   -- �������� ������������ ��� �������� <�������� ������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_UserByGroup(), inName);
   -- �������� ���� ������������ ��� �������� <��� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_UserByGroup(), vbCode);

   -- ��������� ������
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserByGroup(), vbCode, inName);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.04.22         *
*/

-- ����
--