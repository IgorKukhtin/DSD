-- Function: gpInsertUpdate_Object_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinance (Integer, Integer, TVarChar, TVarChar, Integer, TVarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinance (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderFinance(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inComment                 TVarChar  ,    -- ����������
    IN inPaidKindId              Integer   ,    -- ��
    IN inBankAccountId           Integer   ,    -- �/�
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderFinance());
   vbUserId := lpGetUserBySession (inSession); 

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_OrderFinance());

   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_OrderFinance(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderFinance(), vbCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderFinance(), vbCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_OrderFinance_Comment(), ioId, inComment);
   
   -- ��������� ����� � <��>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinance_PaidKind(), ioId, inPaidKindId);

   -- ��������� ����� � <�/�>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinance_BankAccount(), ioId, inBankAccountId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.19         *
 29.07.19         * 
*/

-- ����
--