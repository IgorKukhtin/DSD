  -- Function: gpUpdate_Clear_DefaultUnit()

  DROP FUNCTION IF EXISTS gpUpdate_Clear_DefaultUnit (Integer, TVarChar);


  CREATE OR REPLACE FUNCTION gpUpdate_Clear_DefaultUnit(
      IN inUserID      Integer   ,    -- ���� ������� <������������> 
      IN inSession     TVarChar       -- ������ ������������
  )
    RETURNS Void 
  AS
  $BODY$
    DECLARE vbUserId Integer;
  BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
     vbUserId := inSession;

     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
       RAISE EXCEPTION '��������� ������ ���������� ��������������';
     END IF;

     update DefaultValue set DefaultValue = 0 where ID =
                               (SELECT DefaultValue.ID
                                FROM DefaultValue
                                     INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                                     INNER JOIN (SELECT RoleId, 2 AS OrderId FROM ObjectLink_UserRole_View WHERE UserId = inUserID
                                                 UNION
                                                 SELECT inUserID AS RoleId, 1 AS OrderId
                                                ) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
                                WHERE DefaultKeys.Key ='zc_Object_Unit'
                                ORDER BY UserRole.OrderId
                                LIMIT 1);
                                
  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;
    
  /*
   ������� ����������: ����, �����
                 ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
   04.07.19                                                       *
  */

  -- ����
  -- SELECT * FROM gpUpdate_Clear_DefaultUnit (0, '3')