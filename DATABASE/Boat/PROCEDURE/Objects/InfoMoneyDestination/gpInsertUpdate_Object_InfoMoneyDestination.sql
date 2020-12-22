-- Function: gpInsertUpdate_Object_InfoMoneyDestination()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyDestination();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyDestination(
 INOUT ioId          Integer   ,    -- ����  �������������� ��������� - ����������
    IN inCode        Integer   ,    -- ���
    IN inName        TVarChar  ,    -- ������������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   

BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId = zc_Object_InfoMoneyDestination());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoneyDestination());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoneyDestination()); 

   -- !!! �������� ���� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyDestination(), inName,vbUserId);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoneyDestination(), vbCode_max, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyDestination(), vbCode_max, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.04.14                                        * rem !!! ��� �������� !!!
 21.09.13                                        * !!! ��� �������� !!!
 21.06.13          * gpInsertUpdate_Object_InfoMoneyDestination(); vbCode_max
 19.06.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_InfoMoneyDestination()
