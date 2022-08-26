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

        
        IF vbUserId <> zfCalc_UserAdmin() :: Integer
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

            IF NOT EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile() AND ObjectBoolean.ObjectId = vbUserId)
            THEN
                -- ������ ���� ������������ - ��� �������� �����
                PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_ProjectMobile(), vbUserId, TRUE);
            END IF;

            -- ���� ��� ����� ��������� ����������
            IF NOT EXISTS (SELECT 1 FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_User_BillNumberMobile() AND ObjectFloat.ObjectId = vbUserId AND ObjectFloat.ValueData > 0)
            THEN
                -- ������ � ����� ������������ - ���� ��������� ���������� = ������ �������� + 1 � ������� �� 10 000
                PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_User_BillNumberMobile(), vbUserId
                                                  , (1 + COALESCE ((SELECT MAX (ObjectFloat.ValueData) / 10000 FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_User_BillNumberMobile()), 0))
                                                    * 10000
                                                   );
            END IF;

        END IF;

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
-- SELECT * FROM gpCheckLoginMobile(inUserLogin:= '������� �.�.', inUserPassword:= 'rdn132745', inSerialNumber:= '', inModel:= '', inVesion:= '', inVesionSDK:= '', ioSession:= '');
