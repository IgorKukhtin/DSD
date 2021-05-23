-- Function: gpInsertUpdate_Object_MemberBankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberBankAccount(Integer, TVarChar, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberBankAccount(
 INOUT ioId                    Integer   ,     -- ���� ������� <> 
    IN inName                  TVarChar  ,     -- ����������
    IN inBankAccountId         Integer   ,     -- 
    IN inMemberId              Integer   ,     -- 
    IN inisAll                 Boolean   ,     -- 
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MemberBankAccount());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberBankAccount(), 0, inName);

   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberBankAccount_BankAccount(), ioId, inBankAccountId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberBankAccount_Member(), ioId, inMemberId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_MemberBankAccount_All(), ioId, inisAll);
        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.20         *
*/

-- ����
--