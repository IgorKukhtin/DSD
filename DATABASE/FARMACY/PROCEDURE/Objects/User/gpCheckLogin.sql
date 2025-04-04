-- Function: gpCheckLogin(TVarChar, TVarChar, TVarChar)

--DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
    IN inUserLogin    TVarChar, 
    IN inUserPassword TVarChar, 
    IN inIP           TVarChar, 
    IN inProjectName  TVarChar, 
 INOUT Session TVarChar
)
RETURNS TVarChar
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN


   SELECT Object_User.Id, Object_User.Id
          INTO Session, vbUserId
     FROM Object AS Object_User
          JOIN ObjectString AS UserPassword
                            ON UserPassword.ValueData = RTRIM(inUserPassword) AND RTRIM(inUserPassword) <> ''
                           AND UserPassword.DescId = zc_ObjectString_User_Password()
                           AND UserPassword.ObjectId = Object_User.Id
    WHERE Object_User.ValueData = RTRIM(inUserLogin)
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();

    IF NOT found 
    THEN
    
      SELECT Object_User.Id, Object_User.Id
             INTO Session, vbUserId
        FROM Object AS Object_User
       WHERE Object_User.ValueData = RTRIM(inUserLogin)
         AND Object_User.isErased = FALSE
         AND Object_User.DescId = zc_Object_User();

      IF NOT found 
      THEN
        RAISE EXCEPTION '������������ ����� ��� ������.';
      ELSE
        IF NOT EXISTS(SELECT 1 
                      FROM ObjectLink_UserRole_View  
                          JOIN ObjectString AS UserPassword
                                            ON UserPassword.ValueData = RTRIM(inUserPassword) AND RTRIM(inUserPassword) <> ''
                                           AND UserPassword.DescId = zc_ObjectString_User_Password()
                                           AND UserPassword.ObjectId = ObjectLink_UserRole_View.UserId
                      WHERE ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
        THEN
          RAISE EXCEPTION '������������ ����� ��� ������.';
        END IF;
      END IF;
    END IF;

    INSERT INTO LoginProtocol (UserId, OperDate, ProtocolData)
       SELECT vbUserId, current_timestamp
            , '<XML>'
           || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
           || '<Field FieldName = "�����" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
           || '<Field FieldName = "���������" FieldValue = "' || zfStrToXmlStr (inProjectName) || '"/>'
           || '</XML>'
            ;
        


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.09.15                                        *
*/

-- ����
-- SELECT * FROM LoginProtocol order by 1 desc
-- SELECT * FROM gpCheckLogin ('������� �.�.', 'rdn132745', '', '')

select * from gpCheckLogin(inUserLogin := '������� ����' , inUserPassword := '�����1234' , inIP := '192.168.92.1' , inProjectName := 'Farmacy' ,  Session := '');