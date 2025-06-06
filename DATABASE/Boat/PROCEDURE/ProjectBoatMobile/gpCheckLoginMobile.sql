-- Function: gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar)

-- DROP FUNCTION IF EXISTS gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoginMobile(
    IN inUserLogin    TVarChar, 
    IN inUserPassword TVarChar, 
    IN inSerialNumber TVarChar,  -- �������� ����� ���������� ����������
    IN inModel        TVarChar,  -- 
    IN inVesion       TVarChar,  -- 
    IN inVesionSDK    TVarChar,  -- 
   OUT outMessage     TVarChar,  -- ��������� �� ������, ���� ����
 INOUT ioSession      TVarChar   -- 
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

--if inUserLogin ILIKE '�����' THEN inUserPassword:= 'qsxqsxw1'; end if;
--if inUserLogin ILIKE '������ �.�.' THEN inUserPassword:= 'ckv132709'; end if;

     -- ����������� ������������ + ������ (����� ����� ���������)
     SELECT Object_User.Id, Object_User.Id
          INTO ioSession, vbUserId
     FROM Object AS Object_User
          JOIN ObjectString AS UserPassword
                            ON UserPassword.ValueData = inUserPassword AND inUserPassword <> ''
                           AND UserPassword.DescId = zc_ObjectString_User_Password()
                           AND UserPassword.ObjectId = Object_User.Id
    WHERE Object_User.ValueData = inUserLogin
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();


    -- ��������
    IF NOT FOUND
    THEN
        outMessage:= '������������ ����� ��� ������';

    ELSIF NOT EXISTS (SELECT ObjectLink_UserRole_Role.ChildObjectId
                      FROM ObjectLink AS ObjectLink_UserRole_User
                           JOIN ObjectLink AS ObjectLink_UserRole_Role
                                           ON ObjectLink_UserRole_Role.ObjectId = ObjectLink_UserRole_User.ObjectId
                                          AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role() 
                      WHERE ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                        AND ObjectLink_UserRole_User.ChildObjectId = vbUserId
                     )
             -- ����� ��������� ��/���
             AND NOT EXISTS (SELECT 1
                             FROM ObjectLink AS ObjectLink_User_Member
                                  LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                       ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                      AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId  = ObjectLink_Personal_Member.ObjectId
                                                          AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Personal_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE
                                  INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                        ON ObjectLink_Personal_PersonalServiceList.ObjectId      = ObjectLink_Personal_Member.ObjectId
                                                       AND ObjectLink_Personal_PersonalServiceList.DescId        = zc_ObjectLink_Personal_PersonalServiceList()
                                                       -- ³������ �������
                                                       AND ObjectLink_Personal_PersonalServiceList.ChildObjectId = 301885
                             WHERE ObjectLink_User_Member.ObjectId = vbUserId
                               AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                            )

    THEN
        outMessage:= '������������ �������� �����������, ��� ����, ���������� � ��������������';

    ELSE
        -- ������� ��� ������������ "�����������"
        PERFORM lpInsert_LoginProtocol (inUserLogin  := inUserLogin
                                      , inIP         := inSerialNumber
                                      , inUserId     := vbUserId
                                      , inIsConnect  := TRUE
                                      , inIsProcess  := FALSE
                                      , inIsExit     := FALSE
                                       );

        
       /* IF vbUserId <> zfCalc_UserAdmin() :: Integer
        THEN
            -- �������� ��� ����-��
            -- �� ������ �������� ���

            -- �������������� ��� ����-�� - ��������� �������� <�������� � ��� ����-��>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_ProjectMobile(), vbUserId, inSerialNumber);
            -- ��������� �������� <������ ��� ����-��>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_MobileModel(), vbUserId, inModel);
            -- ��������� �������� <������ ������� ����-��>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_MobileVesion(), vbUserId, inVesion);
            -- ��������� �������� <������ SDK ����-��>
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_MobileVesionSDK(), vbUserId, inVesionSDK);

        END IF;*/

    END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 22.09.17                                                       * �������� �� ������� �����
 17.02.17                                        *
*/

-- ����
-- SELECT * FROM LoginProtocol order by 1 desc
-- SELECT * FROM gpCheckLoginMobile(inUserLogin:= '�������� �.�.', inUserPassword:= 'mld132578', inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');
-- SELECT * FROM gpCheckLoginMobile(inUserLogin:= '�������� �.�.', inUserPassword:= 'mrv130879', inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');
-- SELECT * FROM gpCheckLoginMobile(inUserLogin:= '�����' , inUserPassword:= '�����' , inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');