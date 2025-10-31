 -- Function: gpInsertUpdate_Object_PersonalServiceList_Member_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList_Member_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalServiceList_Member_Load(
    IN inPersonalServiceListCode  Integer ,
    IN inPersonalServiceListName  TVarChar,
    IN inMemberName_1             TVarChar, -- 
    IN inMemberName_2             TVarChar,
    IN inMemberName_3             TVarChar,
    IN inMemberName_4             TVarChar,
    IN inMemberName_5             TVarChar,
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
           vbPersonalServiceListId Integer;
           vbMemberId_1 Integer;
           vbMemberId_2 Integer;
           vbMemberId_3 Integer;
           vbMemberId_4 Integer;
           vbMemberId_5 Integer;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ �������������  - ����������!!!
     IF COALESCE (inPersonalServiceListCode, 0) = 0 THEN
        RETURN; -- !!!�����!!!
     END IF;

     -- !!!����� �� ���������!!!
     vbPersonalServiceListId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = inPersonalServiceListCode
                                  AND Object.DescId     = zc_Object_PersonalServiceList()
                               );

      -- ��������
     IF COALESCE (vbPersonalServiceListId, 0) = 0 THEN
       -- RETURN;
        RAISE EXCEPTION '������.�� ������� ��������� (<%>) <%> .', inPersonalServiceListCode, inPersonalServiceListName;
     END IF;

     IF COALESCE (inMemberName_1,'') <> ''
     THEN
         -- !!!����� �� ��� ����!!!
         vbMemberId_1:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_1))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_1,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ���.���� <%> .', inMemberName_1;
         END IF;
         
         -- ��������� ��-�� 
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), vbPersonalServiceListId, vbMemberId_1);       
     END IF;

     IF COALESCE (inMemberName_2,'') <> ''
     THEN
         -- !!!����� �� ��� ����!!!
         vbMemberId_2:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_2))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_2,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ���.���� <%> .', inMemberName_2;
         END IF;
         
         --��������
         IF vbMemberId_2 = vbMemberId_1
         THEN
             RETURN;
         END IF;

         --���� ��� ����������� � MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_2

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- ��������� ��-�� 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_2
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;

     --
     IF COALESCE (inMemberName_3,'') <> ''
     THEN
         -- !!!����� �� ��� ����!!!
         vbMemberId_3:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_3))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_3,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ���.���� <%> .', inMemberName_3;
         END IF;
         
         --��������
         IF (vbMemberId_3 = vbMemberId_1) OR (vbMemberId_3 = vbMemberId_2)
         THEN
             RETURN;
         END IF;

         --���� ��� ����������� � MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_3

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- ��������� ��-�� 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_3
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;

     IF COALESCE (inMemberName_4,'') <> ''
     THEN
         -- !!!����� �� ��� ����!!!
         vbMemberId_4:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_4))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_4,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ���.���� <%> .', inMemberName_4;
         END IF;
         
         --��������
         IF (vbMemberId_4 = vbMemberId_1) OR (vbMemberId_4 = vbMemberId_2) OR (vbMemberId_4 = vbMemberId_3)
         THEN
             RETURN;
         END IF;

         --���� ��� ����������� � MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_4

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- ��������� ��-�� 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_4
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;
     
     IF COALESCE (inMemberName_5,'') <> ''
     THEN
         -- !!!����� �� ��� ����!!!
         vbMemberId_5:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_5))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_5,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ���.���� <%> .', inMemberName_5;
         END IF;
         
         --��������
         IF (vbMemberId_5 = vbMemberId_1) OR (vbMemberId_5 = vbMemberId_2) OR (vbMemberId_5 = vbMemberId_3) OR (vbMemberId_5 = vbMemberId_4)
         THEN
             RETURN;
         END IF;

         --���� ��� ����������� � MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_5

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- ��������� ��-�� 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_5
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;
  
     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION '����. ��. <%> / <%>', vbPersonalServiceListId, vbMemberId_1; 
     END IF;   

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbPersonalServiceListId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.10.25         *
*/

-- ����
--
