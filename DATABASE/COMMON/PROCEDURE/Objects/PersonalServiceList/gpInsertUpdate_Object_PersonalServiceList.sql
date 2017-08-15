-- Function: gpInsertUpdate_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalServiceList(
 INOUT ioId                    Integer   ,     -- ���� ������� <> 
    IN inCode                  Integer   ,     -- ��� �������  
    IN inName                  TVarChar  ,     -- �������� ������� 
    IN inJuridicalId           Integer   ,     -- ��. ����
    IN inPaidKindId            Integer   ,     -- 
    IN inBranchId              Integer   ,     -- 
    IN inBankId                Integer   ,     -- 
    IN inMemberHeadManagerId   Integer   ,     -- ��� ����(�������������� ��������)
    IN inMemberManagerId       Integer   ,     -- ��� ����(��������)
    IN inMemberBookkeeperId    Integer   ,     -- ��� ����(���������)
    IN inisSecond              Boolean   ,     -- 
   -- IN inMemberId            Integer   ,     -- ��� ����(������������)
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PersonalServiceList());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalServiceList());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PersonalServiceList(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PersonalServiceList(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PersonalServiceList(), vbCode_calc, inName);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Juridical(), ioId, inJuridicalId);

   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_PaidKind(), ioId, inPaidKindId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Branch(), ioId, inBranchId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Bank(), ioId, inBankId);
   
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberHeadManager(), ioId, inMemberHeadManagerId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberManager(), ioId, inMemberManagerId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberBookkeeper(), ioId, inMemberBookkeeperId);

   -- ��������� ��-�� 
   --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), ioId, inMemberId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Second(), ioId, inisSecond);

        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_PersonalServiceList (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.02.17         * add inisSecond
 26.08.15         * add inMemberId
 15.04.15         * add PaidKind, Branch, Bank
 12.09.14         *
*/

-- ����
-- select * from gpInsertUpdate_Object_PersonalServiceList(ioId := 957950 , inCode := 226 , inName := '��������� ���� ��' , inJuridicalId := 131931 , inPaidKindId := 4 , inBranchId := 0 , inBankId := 0 , inMemberHeadManagerId := 0 , inMemberManagerId := 0 , inMemberBookkeeperId := 0 , inisSecond := 'False' ,  inSession := '5');