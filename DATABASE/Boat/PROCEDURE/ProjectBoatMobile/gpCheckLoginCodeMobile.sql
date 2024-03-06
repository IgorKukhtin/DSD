-- Function: gpCheckLoginCodeMobile (Integer, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpCheckLoginCodeMobile (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoginCodeMobile(
    IN inUserId        Integer, 
    IN inSerialNumber  TVarChar,  -- �������� ����� ���������� ����������
    IN inModel         TVarChar,  -- 
    IN inVesion        TVarChar,  -- 
    IN inVesionSDK     TVarChar,  -- 
   OUT outMessage      TVarChar,  -- ��������� �� ������, ���� ����
   OUT outUserLogin    TVarChar,  -- ��������� �� ������, ���� ����
   OUT outUserPassword TVarChar,  -- ��������� �� ������, ���� ����
 INOUT ioSession       TVarChar   -- 
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

--if inUserLogin ILIKE '�����' THEN inUserPassword:= 'qsxqsxw1'; end if;
--if inUserLogin ILIKE '������ �.�.' THEN inUserPassword:= 'ckv132709'; end if;

     -- ����������� ������������ + ������ (����� ����� ���������)
     SELECT Object_User.Id, Object_User.Id, Object_User.ValueData, UserPassword.ValueData
          INTO ioSession, vbUserId, outUserLogin, outUserPassword
     FROM Object AS Object_User
          JOIN ObjectString AS UserPassword
                            ON UserPassword.DescId = zc_ObjectString_User_Password()
                           AND UserPassword.ObjectId = Object_User.Id
    WHERE Object_User.Id = inUserId
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();


    -- ��������
    IF NOT FOUND
    THEN
        outMessage:= '������������ ��� ����������';

    ELSIF NOT EXISTS (SELECT ObjectLink_UserRole_Role.ChildObjectId
                      FROM ObjectLink AS ObjectLink_UserRole_User
                           JOIN ObjectLink AS ObjectLink_UserRole_Role
                                           ON ObjectLink_UserRole_Role.ObjectId = ObjectLink_UserRole_User.ObjectId
                                          AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role() 
                      WHERE ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                        AND ObjectLink_UserRole_User.ChildObjectId = vbUserId
                     )
    THEN
        outMessage:= '������������ �������� �����������, ��� ����, ���������� � ��������������';

    ELSE
        -- ������� ��� ������������ "�����������"
        PERFORM lpInsert_LoginProtocol (inUserLogin  := outUserLogin
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

        END IF; */

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
-- SELECT * FROM gpCheckLoginCodeMobile(inUserId:= zfCalc_UserAdmin()::Integer, inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');

