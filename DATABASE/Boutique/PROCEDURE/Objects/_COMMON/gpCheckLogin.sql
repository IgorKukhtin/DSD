-- Function: gpCheckLogin(TVarChar, TVarChar, TVarChar)

 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar);
 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
    IN inUserLogin    TVarChar, 
    IN inUserPassword TVarChar, 
    IN inIP           TVarChar, 
    INOUT Session     TVarChar
)
RETURNS TVarChar
  AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- ���������� ������������ + ������ (����� ����� ���������)
     SELECT Object_User.Id, Object_User.Id
          INTO Session, vbUserId
     FROM Object AS Object_User
          JOIN ObjectString AS UserPassword
                            ON UserPassword.ValueData = inUserPassword AND inUserPassword <> ''
                           AND UserPassword.DescId = zc_ObjectString_User_Password()
                           AND UserPassword.ObjectId = Object_User.Id
    WHERE Object_User.ValueData = inUserLogin
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();


    -- ��������
    IF NOT FOUND THEN
       RAISE EXCEPTION '������������ ����� ��� ������';
    ELSE
        -- ������� ��� ������������ "�����������"
        PERFORM lpInsert_LoginProtocol (inUserLogin  := inUserLogin
                                      , inIP         := inIP
                                      , inUserId     := vbUserId
                                      , inIsConnect  := TRUE
                                      , inIsProcess  := FALSE
                                      , inIsExit     := FALSE
                                       );

    END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.09.15                                        *
*/

-- ����
-- SELECT * FROM LoginProtocol order by 1 desc
