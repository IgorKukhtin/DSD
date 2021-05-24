-- Function: gpCheckLogin(TVarChar, TVarChar, TVarChar)

 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar);
 DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
    IN inUserLogin    TVarChar,
    IN inUserPassword TVarChar,
    IN inIP           TVarChar,
 INOUT Session TVarChar
)
RETURNS TVarChar
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsCreate Boolean;
BEGIN

     -- ���������� ������������ + ������ (����� ����� ���������)
    SELECT CASE WHEN Object_User.Id = 5
                THEN FALSE
                WHEN Object_User.Id = 5 OR 1=0
                THEN CASE WHEN COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP
                            OR COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) > CURRENT_TIMESTAMP + INTERVAL '25 HOUR'
                               THEN TRUE
                               ELSE FALSE
                          END
                ELSE FALSE
           END
         , Object_User.Id
           INTO vbIsCreate, vbUserId
    FROM Object AS Object_User
         JOIN ObjectString AS UserPassword
                           ON UserPassword.ValueData = inUserPassword AND inUserPassword <> ''
                          AND UserPassword.DescId = zc_ObjectString_User_Password()
                          AND UserPassword.ObjectId = Object_User.Id
         LEFT JOIN ObjectDate AS ObjectDate_User_GUID
                              ON ObjectDate_User_GUID.ObjectId = Object_User.Id
                             AND ObjectDate_User_GUID.DescId   = zc_ObjectDate_User_GUID()

    WHERE Object_User.ValueData = inUserLogin
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();


    -- ��������
    IF NOT FOUND THEN
       RAISE EXCEPTION '������������ ����� ��� ������.';
    ELSE

        IF vbUserId = 5 OR 1=0
        THEN IF vbIsCreate = TRUE
             THEN
                 --
                 Session:= gen_random_uuid();
                 -- Session:= 'c83ab7a4-94d8-47d3-9ede-3f71902b4ced';
                 --
                 IF EXISTS (SELECT 1
                            FROM ObjectLink_UserRole_View
                                 JOIN Object ON Object.Id        = ObjectLink_UserRole_View.RoleId
                                            AND (Object.ValueData ILIKE '�������'
                                            --OR Object.ValueData ILIKE '��������'
                                                )
                            WHERE ObjectLink_UserRole_View.UserId = vbUserId
                           )
                 THEN
                     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_GUID(), vbUserId, CURRENT_TIMESTAMP + INTERVAL '24 HOUR');
                 ELSE
                     IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 7 AND 20
                     THEN
                         -- ?����� �� 21:00
                         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_GUID(), vbUserId, CURRENT_TIMESTAMP + INTERVAL '12 HOUR');
                     ELSE
                         -- �������� � �������� 12
                         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_GUID(), vbUserId, CURRENT_TIMESTAMP + INTERVAL '12 HOUR');
                     END IF;
                 END IF;
                 --
                 PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_GUID(), vbUserId, Session);

             ELSE
                 Session:= (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbUserId AND OS.DescId = zc_ObjectString_User_GUID());
             END IF;

        ELSE
            Session:= vbUserId :: TVarChar;
        END IF;

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
-- SELECT * FROM gpCheckLogin ('������� �.�.', 'rdn132745', '', '')
