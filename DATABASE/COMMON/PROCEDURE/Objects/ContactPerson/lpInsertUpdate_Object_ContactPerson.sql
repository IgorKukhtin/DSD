-- Function: gpInsertUpdate_Object_ContactPerson  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContactPerson (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_ContactPerson(
 INOUT ioId                       Integer   ,    -- ���� ������� < �����/��������> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inPhone                    TVarChar  ,    -- 
    IN inMail                     TVarChar  ,    --
    IN inComment                  TVarChar  ,    --
    IN inObjectId_Partner         Integer   ,    --   
    IN inObjectId_Juridical       Integer   ,    --   
    IN inObjectId_Contract        Integer   ,    --   
    IN inObjectId_Unit            Integer   ,    -- 
    IN inContactPersonKindId      Integer   ,    --
    IN inEmailId                  Integer   ,    --
    IN inRetailId                 Integer   ,    --
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer; 
   DECLARE vbObjectId Integer;   
BEGIN

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

   IF COALESCE (inObjectId_Partner, 0) <> 0 AND (COALESCE (inObjectId_Juridical, 0) = 0 AND COALESCE (inObjectId_Contract, 0) = 0 AND COALESCE (inObjectId_Unit, 0) = 0) 
   THEN
	vbObjectId = COALESCE (inObjectId_Partner, 0);
   END IF;

   IF COALESCE (inObjectId_Juridical, 0) <> 0 AND (COALESCE (inObjectId_Partner, 0) = 0 AND COALESCE (inObjectId_Contract, 0) = 0 AND COALESCE (inObjectId_Unit, 0) = 0) 
   THEN
	vbObjectId = COALESCE (inObjectId_Juridical, 0);
   END IF;

   IF COALESCE (inObjectId_Contract, 0) <> 0 AND (COALESCE (inObjectId_Partner, 0) = 0 AND COALESCE (inObjectId_Juridical, 0) = 0 AND COALESCE (inObjectId_Unit, 0) = 0) 
   THEN
	vbObjectId = COALESCE (inObjectId_Contract, 0);
   END IF;

   IF COALESCE (inObjectId_Unit, 0) <> 0 AND (COALESCE (inObjectId_Partner, 0) = 0 AND COALESCE (inObjectId_Juridical, 0) = 0 AND COALESCE (inObjectId_Contract, 0) = 0) 
   THEN
	vbObjectId = COALESCE (inObjectId_Unit, 0);
   END IF;


   IF COALESCE (vbObjectId, 0) = 0 THEN RAISE EXCEPTION '������.������ ���� ������ ���� <������ ��������>: <����������� ����> ��� <�������> ��� <����������>.'; END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContactPerson(), vbCode_calc, inName);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Phone(), ioId, inPhone);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Mail(), ioId, inMail);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_Object(), ioId, vbObjectId);

  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_ContactPersonKind(), ioId, inContactPersonKindId);
  -- ��������� ����� � <>
  PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_Email(), ioId, inEmailId);
   
  -- ��������� ����� � <>
  PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_Retail(), ioId, inRetailId);



   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.06.17                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_ContactPerson(ioId := 0 , inCode := 1 , inName := '�����' , inPhone := '4444' , Mail := '���@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inContractId := 0 , inContactPersonKindId := 153272 ,  inSession := '5');
