-- Function: gpUpdate_Object_PersonalServiceList_Member()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_Member(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_Member(
    IN inId             Integer   ,     -- ���� ������� <> 
    IN inMemberId       Integer   ,     -- ��� ����(������������)
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight(inSession, zc_Enum_Process_PersonalServiceList());
   vbUserId := inSession;
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), inId, inMemberId);
        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_PersonalServiceList_Member (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.08.15         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PersonalServiceList(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')