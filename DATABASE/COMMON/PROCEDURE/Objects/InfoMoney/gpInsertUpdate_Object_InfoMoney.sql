-- Function: gpInsertUpdate_Object_InfoMoney()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoney();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId                     Integer   ,    -- ���� ������� <������ ����������>
    IN inCode                   Integer   ,    -- ��� ������� <������ ����������>
    IN inName                   TVarChar  ,    -- �������� ������� <������ ����������>
    IN inInfoMoneyGroupId       Integer   ,    -- ������ �� <������ �������������� ����������>
    IN inInfoMoneyDestinationId Integer   ,    -- ������ �� <�������������� ����������>
    IN inSession                TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_calc Integer; 
BEGIN
   -- !!! ��� �������� !!!
   ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId = zc_Object_InfoMoney());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoney());
   UserId := inSession;

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
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);


END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.09.13                                        * !!! ��� �������� !!!
 21.06.13          *  Code_calc:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());               
 16.06.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Contract()
