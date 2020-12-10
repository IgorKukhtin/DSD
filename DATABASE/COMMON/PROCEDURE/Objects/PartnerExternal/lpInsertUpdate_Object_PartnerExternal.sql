-- Function: gpInsertUpdate_Object_PartnerExternal  ()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartnerExternal (Integer, Integer, TVarChar, TVarChar, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartnerExternal (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartnerExternal (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartnerExternal(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inObjectCode               TVarChar  ,    -- 
    IN inPartnerId                Integer   ,    --
    IN inPartnerRealId            Integer   ,    --
    IN inContractId               Integer   ,    --
    IN inRetailId                 Integer   ,    --
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer; 
BEGIN

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PartnerExternal()); 
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PartnerExternal(), vbCode_calc, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_PartnerExternal_ObjectCode(), ioId, inObjectCode);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_PartnerReal(), ioId, inPartnerRealId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Partner(), ioId, inPartnerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Retail(), ioId, inRetailId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.12.20         * add inPartnerRealId
 30.10.20         *
*/

-- ����
-- 