-- Function: gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpCheckLoginMobile (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoginMobile(
    IN inUserLogin    TVarChar, 
    IN inUserPassword TVarChar, 
    IN inSerialNumber TVarChar,  -- �������� ����� ���������� ����������
   OUT outMessage     TVarChar,  -- ��������� �� ������, ���� ����
 INOUT ioSession      TVarChar   -- 
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- ���������� ������������ + ������ (����� ����� ���������)
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
       -- RAISE EXCEPTION '������������ ����� ��� ������';
    ELSE
        -- ������� ��� ������������ "�����������"
        PERFORM lpInsert_LoginProtocol (inUserLogin  := inUserLogin
                                      , inIP         := inSerialNumber
                                      , inUserId     := vbUserId
                                      , inIsConnect  := TRUE
                                      , inIsProcess  := FALSE
                                      , inIsExit     := FALSE
                                       );

        -- �������� ��� ����-��
        -- �� ������ �������� ���
        
        -- �������������� ��� ����-�� - ��������� �������� <�������� � ��� ����-�� >
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_ProjectMobile(), vbUserId, inSerialNumber);

        -- ������ ���� ������������ - ��� �������� �����
        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_ProjectMobile(), vbUserId, TRUE);

    END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.17                                        *
*/

-- ����
-- SELECT * FROM LoginProtocol order by 1 desc
