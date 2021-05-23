-- Function: gpInsertUpdate_Object_Account (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Account (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Account (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account(
 INOUT ioId                     Integer,    -- ���� ������� <����>
    IN inCode                   Integer,    -- ��� ������� <����>
    IN inName                   TVarChar,   -- �������� ������� <����>
    IN inAccountGroupId         Integer,    -- ������ ������
    IN inAccountDirectionId     Integer,    -- ��������� ����� (�����)
    IN inInfoMoneyDestinationId Integer,    -- ��������� ����� (����������)
    IN inInfoMoneyId            Integer,    -- �������������� ���������
    IN inIsPrintDetail          Boolean,    -- �������� ����������� ��� ������
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbAccountKindId Integer;
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode:=lfGet_ObjectCode (inCode, zc_Object_Account()); 

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Account(), vbCode);

   -- ���������� �������� <���� ������>
   IF EXISTS (SELECT Object_AccountGroup.Id
              FROM Object AS Object_AccountGroup
                   LEFT JOIN Object AS Object_AccountGroup_70000 ON Object_AccountGroup_70000.Id = zc_Enum_AccountGroup_70000()
              WHERE Object_AccountGroup.Id = inAccountGroupId
                AND Object_AccountGroup.ObjectCode < Object_AccountGroup_70000.ObjectCode)
   THEN
       vbAccountKindId:= zc_Enum_AccountKind_Active();
   ELSE
       vbAccountKindId:= zc_Enum_AccountKind_Passive();
   END IF ;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Account(), vbCode, inName);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Account_onComplete(), ioId, FALSE);

   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountGroup(), ioId, inAccountGroupId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountDirection(), ioId, inAccountDirectionId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoney(), ioId, inInfoMoneyId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountKind(), ioId, vbAccountKindId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Account_PrintDetail(), ioId, inIsPrintDetail);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.01.19         * inIsPrintDetail
 18.04.14                                        * rem !!! ��� �������� !!!
 31.01.14                                        * add zc_ObjectBoolean_Account_onComplete
 25.08.13                                        * !!! ��� �������� !!!
 08.07.13                                        * vbAccountKindId
 05.07.13          * + inIAccountKindId
 02.07.13                                        * change CodePage
 17.06.13          *
*/
