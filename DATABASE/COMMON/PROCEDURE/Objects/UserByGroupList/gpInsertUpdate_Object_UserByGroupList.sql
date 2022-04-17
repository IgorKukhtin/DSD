-- Function: gpInsertUpdate_Object_UserByGroupList  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UserByGroupList (Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserByGroupList(
 INOUT ioId                Integer   ,    -- ���� ������� <> 
    IN inUserId            Integer   ,    --   
    IN inUserByGroupId     Integer   ,    --   
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_UserByGroupList());

   -- ��������
   IF COALESCE (inUserByGroupId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.����������� �� �����������.';
   END IF;   

   IF COALESCE (inUserId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.������������ �� ����������.';
   END IF;

   -- �������� ������������
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_UserByGroupList_User
                   INNER JOIN ObjectLink AS ObjectLink_UserByGroupList_UserByGroup
                                         ON ObjectLink_UserByGroupList_UserByGroup.ObjectId = ObjectLink_UserByGroupList_User.ObjectId
                                        AND ObjectLink_UserByGroupList_UserByGroup.DescId = zc_ObjectLink_UserByGroupList_UserByGroup()
                                        AND ObjectLink_UserByGroupList_UserByGroup.ChildObjectId = inUserByGroupId
              WHERE ObjectLink_UserByGroupList_User.DescId = zc_ObjectLink_UserByGroupList_User()
                AND ObjectLink_UserByGroupList_User.ChildObjectId = inUserId
                AND ObjectLink_UserByGroupList_User.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION '������.%����� <%> � <%> ��� ���� � �����������.%������������ ���������.', CHR(13), lfGet_Object_ValueData (inUserId), lfGet_Object_ValueData (inUserByGroupId), CHR(13);
   END IF;   


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_UserByGroupList(), 0, '');

   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserByGroupList_User(), ioId, inUserId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserByGroupList_UserByGroup(), ioId, inUserByGroupId);


   -- ��������� STRING_AGG
   PERFORM lpInsertUpdate_Object (inUserByGroupId, zc_Object_UserByGroup()
                                , (SELECT Object.ObjectCode FROM Object WHERE Object.Id = inUserByGroupId)
                                , (SELECT STRING_AGG (tmp.UserName, ';')
                                   FROM (SELECT Object_User.ValueData AS UserName
                                         FROM ObjectLink AS ObjectLink_UserByGroupList_UserByGroup
                                              JOIN Object AS Object_UserByGroupList ON Object_UserByGroupList.Id       = ObjectLink_UserByGroupList_UserByGroup.ObjectId
                                                                                   AND Object_UserByGroupList.isErased = FALSE
                                              JOIN ObjectLink AS ObjectLink_UserByGroupList_User
                                                              ON ObjectLink_UserByGroupList_User.ObjectId = ObjectLink_UserByGroupList_UserByGroup.ObjectId
                                                             AND ObjectLink_UserByGroupList_User.DescId   = zc_ObjectLink_UserByGroupList_User()
                                              JOIN Object AS Object_User ON Object_User.Id       = ObjectLink_UserByGroupList_User.ChildObjectId
                                         WHERE ObjectLink_UserByGroupList_UserByGroup.ChildObjectId = inUserByGroupId
                                           AND ObjectLink_UserByGroupList_UserByGroup.DescId        = zc_ObjectLink_UserByGroupList_UserByGroup()
                                         ORDER BY Object_User.ValueData
                                        ) AS tmp
                                  )
                                 );
 

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.04.22         *

*/

-- ����
--