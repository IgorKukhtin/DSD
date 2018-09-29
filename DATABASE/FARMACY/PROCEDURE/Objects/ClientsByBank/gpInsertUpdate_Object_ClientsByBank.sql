-- Function: gpInsertUpdate_Object_ClientsByBank  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ClientsByBank (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ClientsByBank(
 INOUT ioId                       Integer   ,    -- ���� ������� < �����/��������> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inOKPO                     TVarChar  ,
    IN inINN                      TVarChar  ,
    IN inPhone                    TVarChar  ,
    IN inContactPerson            TVarChar  ,
    IN inRegAddress               TVarChar  ,
    IN inSendingAddress           TVarChar  ,
    IN inAccounting               TVarChar  ,
    IN inPhoneAccountancy         TVarChar  ,
    IN inComment                  TVarChar  ,
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ClientsByBank()); 
   
   -- �������� ���� ������������ ��� �������� <������������ > + <Object> + <ClientsByBankKind>
--   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ClientsByBank(), inName);
--   IF COALESCE((SELECT ), 0) = ioId THEN
--      RAISE EXCEPTION '';
--   END IF;
   -- �������� ���� ������������ ��� �������� <��� > + <Object> 
--   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ClientsByBank(), vbCode_calc);

   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ClientsByBank(), vbCode_calc, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_OKPO(), ioId, inOKPO);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_INN(), ioId, inINN);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_Phone(), ioId, inPhone);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_ContactPerson(), ioId, inContactPerson);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_RegAddress(), ioId, inRegAddress);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_SendingAddress(), ioId, inSendingAddress);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_Accounting(), ioId, inAccounting);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_PhoneAccountancy(), ioId, inPhoneAccountancy);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������ �.�.
 28.09.18         * 
*/

-- ����
-- 