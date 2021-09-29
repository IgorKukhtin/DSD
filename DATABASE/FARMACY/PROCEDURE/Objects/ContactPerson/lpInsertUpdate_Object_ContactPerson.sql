-- Function: gpInsertUpdate_Object_ContactPerson  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContactPerson (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContactPerson (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContactPerson (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

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
    IN inAreaId                   Integer   ,    --
    IN inUnitId                   Integer   ,    -- 
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer; 
   DECLARE vbObjectId Integer;
   DECLARE vbCalc TFloat;
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

   vbCalc := 0;
   IF COALESCE (inObjectId_Partner, 0) <> 0 THEN vbCalc := vbCalc + 1; END IF;
   IF COALESCE (inObjectId_Juridical, 0) <> 0 THEN vbCalc := vbCalc + 1; END IF;
   IF COALESCE (inObjectId_Contract, 0) <> 0 THEN vbCalc := vbCalc + 1; END IF;
   IF COALESCE (inObjectId_Unit, 0) <> 0 THEN vbCalc := vbCalc + 1; END IF;

   -- ��������
    -- 16.01.2019  ����� ���� ������� ������� ��� ����� ��  <����������� ����> ��� <�������> ��� <����������>
   IF vbCalc > 1 --COALESCE (vbObjectId, 0) = 0 
   THEN 
       RAISE EXCEPTION '������.������ ���� ������ ������ ���� <������ ��������>: <����������� ����> ��� <�������> ��� <����������>.'; 
   END IF;
   
   -- 
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
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_Area(), ioId, inAreaId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContactPerson_Unit(), ioId, inUnitId);

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
--select * from gpInsertUpdate_Object_ContactPerson(ioId := 9877621 , inCode := 155 , inName := '����'::TVarChar , inPhone := '222222'::TVarChar , inMail := '22222222' ::TVarChar, inComment := '����' ::TVarChar, inObjectId_Partner := 0 , inObjectId_Juridical := 0 , inObjectId_Contract := 0 , inObjectId_Unit := 0 , inContactPersonKindId := 0 , inEmailId := 0 , inRetailId := 0 , inAreaId := 0 ,  inSession := '3'::TVarChar);