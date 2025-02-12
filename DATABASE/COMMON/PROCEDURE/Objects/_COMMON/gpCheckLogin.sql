-- Function: gpCheckLogin(TVarChar, TVarChar, TVarChar)

-- DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpCheckLogin (TVarChar, TVarChar, TVarChar, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
    IN inUserLogin      TVarChar,
    IN inUserPassword   TVarChar,
    IN inIP             TVarChar,
 INOUT ioIsGoogleOTP    Boolean,
 INOUT ioGoogleSecret   TVarChar,
 INOUT Session          TVarChar
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsCreate Boolean;
BEGIN

     -- ���������� ������������ + ������ (����� ����� ���������)
    SELECT CASE WHEN Object_User.Id = 5
                THEN FALSE
                WHEN Object_User.Id = 5 OR 1=0
                THEN -- ����� ��� �������� ������ ������ 25 HOUR, �������� ����.
                     CASE WHEN COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP
                            OR COALESCE (ObjectDate_User_GUID.ValueData, zc_DateStart()) > CURRENT_TIMESTAMP + INTERVAL '25 HOUR'
                               THEN TRUE
                               ELSE FALSE
                          END
                ELSE FALSE
           END AS isCreate
         , Object_User.Id
         , CASE WHEN Object_User.Id IN (5) AND inIP = '192.168.0.102' AND 1=0 THEN TRUE
                WHEN inIP = '192.168.0.103' AND 1=0 THEN FALSE
                WHEN 1=1 THEN COALESCE(ObjectBoolean_ProjectAuthent.ValueData, FALSE)
                WHEN 1=1 THEN FALSE
                WHEN Object_User.Id IN (5, 14610) THEN COALESCE(ObjectBoolean_ProjectAuthent.ValueData, FALSE)
                WHEN Object_User.ObjectCode IN (2596, 2790, 20, 19, 2727) THEN COALESCE(ObjectBoolean_ProjectAuthent.ValueData, FALSE)
                ELSE FALSE
           END AS isGoogleOTP
         , COALESCE(ObjectString_GoogleSecret.ValueData, '')

           INTO vbIsCreate, vbUserId, ioIsGoogleOTP, ioGoogleSecret

    FROM Object AS Object_User
         JOIN ObjectString AS UserPassword
                           ON UserPassword.ValueData = inUserPassword AND inUserPassword <> ''
                          AND UserPassword.DescId = zc_ObjectString_User_Password()
                          AND UserPassword.ObjectId = Object_User.Id
         LEFT JOIN ObjectDate AS ObjectDate_User_GUID
                              ON ObjectDate_User_GUID.ObjectId = Object_User.Id
                             AND ObjectDate_User_GUID.DescId   = zc_ObjectDate_User_GUID()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_ProjectAuthent
                                 ON ObjectBoolean_ProjectAuthent.ObjectId = Object_User.Id
                                AND ObjectBoolean_ProjectAuthent.DescId   = zc_ObjectBoolean_User_ProjectAuthent()
         LEFT JOIN ObjectString AS ObjectString_GoogleSecret
                                ON ObjectString_GoogleSecret.ObjectId = Object_User.Id
                               AND ObjectString_GoogleSecret.DescId   = zc_ObjectString_User_SMS()

    WHERE Object_User.ValueData = inUserLogin
      AND Object_User.isErased = FALSE
      AND Object_User.DescId = zc_Object_User();


    -- ��������
    IF NOT FOUND THEN
       RAISE EXCEPTION '������������ ����� ��� ������.';
    ELSE
    
        --
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.12.22                                                       *              
 02.09.15                                        *
*/

-- ����
-- SELECT * FROM LoginProtocol order by 1 desc
-- SELECT * FROM gpCheckLogin(inUserLogin := '�����' , inUserPassword := 'qsxqsxw1' , inIP := '192.168.43.29' , ioIsGoogleOTP := 'False' , ioGoogleSecret := '' ,  Session := '');
