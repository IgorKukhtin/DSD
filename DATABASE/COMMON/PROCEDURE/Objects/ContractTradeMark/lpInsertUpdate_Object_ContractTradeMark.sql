-- Function: gpInsertUpdate_Object_ContractTradeMark  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContractTradeMark (Integer,Integer,Integer,Integer,Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_ContractTradeMark(
 INOUT ioId                Integer   ,    -- ���� ������� <> 
    IN inCode              Integer   ,    -- ��� ������� <>
    IN inContractId        Integer   ,    --   
    IN inTradeMarkId       Integer   ,    -- 
    IN inUserId            Integer       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractTradeMark()); 
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractTradeMark(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractTradeMark(), vbCode_calc, '');

   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractTradeMark_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractTradeMark_TradeMark(), ioId, inTradeMarkId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.11.20         *
*/

-- ����
--