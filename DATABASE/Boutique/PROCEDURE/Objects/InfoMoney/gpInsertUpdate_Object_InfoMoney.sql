-- Function: gpInsertUpdate_Object_InfoMoney()
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId                     Integer   ,    -- ���� ������� <������ ����������>
    IN inCode                   Integer   ,    -- ��� ������� <������ ����������>
    IN inName                   TVarChar  ,    -- �������� ������� <������ ����������>
    IN inInfoMoneyGroupId       Integer   ,    -- ������ �� <������ �������������� ����������>
    IN inInfoMoneyDestinationId Integer   ,    -- ������ �� <�������������� ����������>
    IN inisProfitLoss           Boolean   ,    -- ������� �� ������
    IN inSession                TVarChar       -- ������ ������������
)
  RETURNS integer 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer; 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());
   
   -- !!! �������� ���� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inName);

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), vbCode_max);

   -- ��������� ������
   ioId := lpInsertUpdate_Object( ioId, zc_Object_InfoMoney(), vbCode_max, inName);
   -- ��������� ����� � <������ �������������� ����������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyGroup(), ioId, inInfoMoneyGroupId);
   -- ��������� ����� � <�������������� ����������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_ProfitLoss(), ioId, inisProfitLoss);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.15         * add inisProfitLoss
 18.04.14                                        * rem !!! ��� �������� !!!
 21.09.13                                        * !!! ��� �������� !!!
 21.06.13          *  vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());               
 16.06.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_InfoMoney()
