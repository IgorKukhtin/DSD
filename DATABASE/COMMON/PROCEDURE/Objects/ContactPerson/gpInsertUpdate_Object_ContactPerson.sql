-- Function: gpInsertUpdate_Object_ContactPerson  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContactPerson (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContactPerson (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContactPerson(
 INOUT ioId                       Integer   ,    -- ���� ������� < �����/��������> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inPhone                    TVarChar  ,    -- 
    IN inMail                     TVarChar  ,    --
    IN inComment                  TVarChar  ,    --
    IN inObjectId                 Integer   ,    --   
    IN inContactPersonKindId      Integer   ,    --
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContactPerson());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContactPerson()); 
   
   -- �������� ���� ������������ ��� �������� <������������ > + <Object> + <ContactPersonKind>
--   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContactPerson(), inName);
--   IF COALESCE((SELECT ), 0) = ioId THEN
--      RAISE EXCEPTION '';
--   END IF;
   -- �������� ���� ������������ ��� �������� <��� > + <Object> 
--   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContactPerson(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContactPerson(), vbCode_calc, inName);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Phone(), ioId, inPhone);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Mail(), ioId, inMail);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_Object(), ioId, inObjectId);

  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_ContactPersonKind(), ioId, inContactPersonKindId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.06.14                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ContactPerson()
