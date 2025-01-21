-- Function: gpInsertUpdate_Object_MemberPersonalServiceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberPersonalServiceList (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberPersonalServiceList(
 INOUT ioId                            Integer   ,     -- ���� ������� <>
    IN inPersonalServiceListId         Integer   ,     -- 
    IN inMemberId                      Integer   ,     -- ���������� ����
 INOUT ioIsAll                         Boolean   , 
    IN inComment                       TVarChar  ,     -- ����������
    IN inSession                       TVarChar        -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSheetWorkTime());

   IF COALESCE (ioId,0) = -1
   THEN
        RAISE EXCEPTION '������.������� �� ��������.';
   END IF;

   -- ��������
   IF COALESCE (inPersonalServiceListId, 0) = 0 AND COALESCE (ioIsAll, FALSE) = FALSE
   THEN
      RAISE EXCEPTION '������.<��������� ����������> �� �������.';
   END IF;
   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<���.����> �� �������.';
   END IF;
   
   --������, ���� ������� ��������� ������ ���� = False
   IF COALESCE (inPersonalServiceListId, 0) <> 0
   THEN 
       ioIsAll := False;
   END IF;
   
   -- ��������� �� ������������ PersonalServiceList + Member3
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberPersonalServiceList
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                        ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                       AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
        
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                        ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                       AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_All
                                           ON ObjectBoolean_All.ObjectId = Object_MemberPersonalServiceList.Id
                                          AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberPersonalServiceList_All()

              WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                AND (COALESCE (ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId, 0) = inPersonalServiceListId OR ioIsAll = TRUE)
                AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = inMemberId
                AND COALESCE (ObjectBoolean_All.ValueData, False) = ioIsAll
                AND Object_MemberPersonalServiceList.Id <> ioId
              )
   THEN
       RAISE EXCEPTION '������.������ �� ���������';
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberPersonalServiceList(), 0, '');
  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList(), ioId, inPersonalServiceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPersonalServiceList_Member(), ioId, inMemberId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MemberPersonalServiceList_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_MemberPersonalServiceList_All(), ioId, ioIsAll);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 05.07.18         *
*/

-- ����
-- 