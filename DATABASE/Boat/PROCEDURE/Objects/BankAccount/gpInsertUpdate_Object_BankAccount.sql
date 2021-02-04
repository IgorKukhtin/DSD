-- Function: gpInsertUpdate_Object_BankAccount (Integer, Integer, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccount (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccount(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <> 
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inBankId                   Integer   ,    -- ���� ������� <����> 
    IN inCurrencyId               Integer   ,    -- ���� ������� <������> 
    IN inComment                  TVarChar  ,    -- 
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_BankAccount_seq'); 
   END IF; 
   
   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_BankAccount(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BankAccount(), ioCode, inName);

   -- ��������� ����� � <����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccount_Bank(), ioId, inBankId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccount_Currency(), ioId, inCurrencyId);

   --
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_Comment(), ioId, inComment);


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
 03.02.21         *
*/

-- ����
--