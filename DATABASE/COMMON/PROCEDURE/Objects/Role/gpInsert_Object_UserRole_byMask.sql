-- Function: gpInsert_Object_UserRole_byMask (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_UserRole_byMask (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_UserRole_byMask(
    IN inUserId         Integer   ,     -- ������������
    IN inUserId_mask    Integer   ,     -- ������������
    IN inSession        TVarChar        -- ������ ������������
)
RETURNS VOID
  AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

  -- ���������� ������ �� ���� ������� ��� � ���. ������������ (inUserId), � � ����������  (inUserId_mask) ����
  PERFORM gpInsertUpdate_Object_UserRole (ioId      := 0
                                        , inUserId  := inUserId
                                        , inRoleId  := tt1.RoleId
                                        , inSession := inSession
                                        )
  FROM 
       (SELECT ObjectLink_UserRole_Role.ChildObjectId AS RoleId
        FROM ObjectLink AS ObjectLink_UserRole_Role
             JOIN ObjectLink AS ObjectLink_UserRole_User
                             ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                            AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
        WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
          AND ObjectLink_UserRole_User.ChildObjectId = inUserId_mask
        ) AS tt1   
    LEFT JOIN (SELECT ObjectLink_UserRole_Role.ChildObjectId AS RoleId
               FROM ObjectLink AS ObjectLink_UserRole_Role
                    JOIN ObjectLink AS ObjectLink_UserRole_User
                                    ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                   AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
               WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                 AND ObjectLink_UserRole_User.ChildObjectId = inUserId
               ) AS tt2 ON tt2.RoleId = tt1.RoleId
  WHERE  tt2.RoleId is null;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.11.22         *
*/

-- ����
--