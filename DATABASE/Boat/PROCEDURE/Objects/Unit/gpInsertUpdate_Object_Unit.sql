-- Function: gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                       Integer   ,    -- ���� ������� <�������������> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <�������������> 
    IN inName                     TVarChar  ,    -- �������� ������� <�������������>
    IN inAddress                  TVarChar  ,    -- �����
    IN inPhone                    TVarChar  ,    -- �������
    IN inComment                  TVarChar  ,    -- ����������
    IN inJuridicalId              Integer   ,    -- ���� ������� <����������� ����> 
    IN inParentId                 Integer   ,    -- ���� ������� <�����> 
    IN inChildId                  Integer   ,    -- ���� ������� <�����>
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:=lfGet_ObjectCode (ioCode, zc_Object_User()); 

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), ioCode, inName);

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Address(), ioId, inAddress);
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Phone(), ioId, inPhone);
   -- ��������� ����������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Comment(), ioId, inComment);
   
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Child(), ioId, inChildId);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.10.20          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit()
