-- Function: gpInsertUpdate_Object_InfoMoney()
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId                     Integer   ,    -- ���� ������� <������ ����������>
    IN inCode                   Integer   ,    -- ��� ������� <������ ����������>
    IN inName                   TVarChar  ,    -- �������� ������� <������ ����������>
    IN inInfoMoneyGroupId       Integer   ,    -- ������ �� <������ �������������� ����������>
    IN inInfoMoneyDestinationId Integer   ,    -- ������ �� <�������������� ����������>
    IN inCashFlowId_in          Integer   ,    -- ������ �� <������ ������ ��� ������>
    IN inCashFlowId_out         Integer   ,    -- ������ �� <������ ������ ��� ������>
    IN inisProfitLoss           Boolean   ,    -- ������� �� ������
    IN inSession                TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_calc Integer; 
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId = zc_Object_InfoMoney());

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoney());


   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());
   
   -- !!! �������� ���� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inName);

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), Code_calc);

   -- ��������� ������
   ioId := lpInsertUpdate_Object( ioId, zc_Object_InfoMoney(), Code_calc, inName);
   -- ��������� ����� � <������ �������������� ����������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyGroup(), ioId, inInfoMoneyGroupId);
   -- ��������� ����� � <�������������� ����������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   
   -- ��������� ����� � <������ ������ ��� ������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_in(), ioId, inCashFlowId_in);
   -- ��������� ����� � <������ ������ ��� ������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_out(), ioId, inCashFlowId_out);
         
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_ProfitLoss(), ioId, inisProfitLoss);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.06.20         * CashFlow
 28.08.15         * add inisProfitLoss
 18.04.14                                        * rem !!! ��� �������� !!!
 21.09.13                                        * !!! ��� �������� !!!
 21.06.13          *  Code_calc:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());               
 16.06.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_InfoMoney()
