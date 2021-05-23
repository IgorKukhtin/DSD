-- Function: gpInsertUpdate_Object_ProfitLoss()

-- DROP FUNCTION gpInsertUpdate_Object_ProfitLoss();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLoss(
 INOUT ioId                     Integer,    -- ���� ������� <������ ������ � �������� � �������>
    IN inCode                   Integer,    -- ��� ������� 
    IN inName                   TVarChar,   -- �������� ������� 
    IN inProfitLossGroupId      Integer,    -- ������
    IN inProfitLossDirectionId  Integer,    -- ��������� 
    IN inInfoMoneyDestinationId Integer,    -- �������������� ���������
    IN inInfoMoneyId            Integer,    -- �������������� ���������
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_ProfitLoss());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProfitLoss());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProfitLoss());
  
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProfitLoss(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProfitLoss(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ProfitLoss_onComplete(), ioId, FALSE);

   -- ��������� ����� � <������� ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossGroup(), ioId, inProfitLossGroupId);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossDirection(), ioId, inProfitLossDirectionId);
   -- ��������� ����� � <�������������� ���������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   -- ��������� ����� � <�������������� ���������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoney(), ioId, inInfoMoneyId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ProfitLoss(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, tvarchar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.04.14                                        * rem !!! ��� �������� !!!
 31.01.14                                        * add zc_ObjectBoolean_ProfitLoss_onComplete
 08.09.13                                        * !!! ��� �������� !!!
 18.06.13          *   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProfitLoss());             
 18.06.13          *
 05.06.13          
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProfitLoss()
