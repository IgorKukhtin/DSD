-- Function: gpInsert_Object_MemberPersonalServiceListOne()

DROP FUNCTION IF EXISTS gpInsert_Object_MemberPersonalServiceListOne (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_Object_MemberPersonalServiceListOne(
    IN inMemberId                      Integer   ,     -- ���������� ����
    IN inPersonalServiceListId         Integer   ,     --
    IN inSession                       TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberPersonalServiceList());


   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<���.����> �� �������.';
   END IF;

   IF COALESCE (inPersonalServiceListId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<��������� ����������> �� �������.';
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

              WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                AND COALESCE (ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId, 0) = inPersonalServiceListId
                AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = inMemberId
              )
   THEN
       RETURN;
   END IF;
   

   -- ��������� ��� ��������� , ����� ��� ��� ��� ����
   PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                        ,  inPersonalServiceListId  := inPersonalServiceListId
                                                        ,  inMemberId               := inMemberId
                                                        ,  ioIsAll                  := FALSE   :: Boolean
                                                        ,  inComment                := ''      :: TVarChar
                                                        ,  inSession                := inSession
                                                          );


   IF vbUserId = 9457 THEN RAISE EXCEPTION '����. �k.'; END IF;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.07.25         *
*/

-- ����
-- 