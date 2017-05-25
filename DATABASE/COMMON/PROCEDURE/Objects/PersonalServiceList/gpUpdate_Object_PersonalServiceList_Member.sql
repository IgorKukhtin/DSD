-- Function: gpUpdate_Object_PersonalServiceList_Member()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_Member (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_Member (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_Member(
    IN inId                    Integer   ,     -- ���� ������� <> 
    IN inMemberId              Integer   ,     -- ��� ����(������������) 
    IN inMemberHeadManagerId   Integer   ,     -- ��� ����(�������������� ��������)
    IN inMemberManagerId       Integer   ,     -- ��� ����(��������)
    IN inMemberBookkeeperId    Integer   ,     -- ��� ����(���������)
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_PersonalServiceList_Member());


   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), inId, inMemberId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberHeadManager(), inId, inMemberHeadManagerId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberManager(), inId, inMemberManagerId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberBookkeeper(), inId, inMemberBookkeeperId);
        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_PersonalServiceList_Member (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.12.15         * add MemberHeadManager, MemberManager, MemberBookkeeper
 26.08.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_PersonalServiceList_Member(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')