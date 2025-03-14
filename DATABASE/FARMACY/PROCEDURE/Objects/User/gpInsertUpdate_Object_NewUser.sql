-- Function: gpInsertUpdate_Object_NewUser()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_NewUser (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_NewUser(
 INOUT ioId                     Integer ,      -- Id
    IN inName                   TVarChar,      -- ���
    IN inNameUkr                TVarChar,      -- ��� �� ���������� �����
    IN inPhone                  TVarChar,      -- ������ ��������
    IN inPositionId             Integer ,      -- ���������
    IN inUnitId                 Integer ,      -- �������������
    IN inLogin                  TVarChar,      -- ����� 
    IN inPassword               TVarChar,      -- ������ 
    IN inisInternshipCompleted  Boolean ,    -- ���������� ���������
    IN inisSite                 Boolean   ,    -- ������� - ��� �����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMember Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 1633980))
   THEN
     RAISE EXCEPTION '�������� ������ ������������ ��� ���������.';
   END IF;
   
   inName := TRIM(inName);     
   inNameUkr := TRIM(inNameUkr);     
   inLogin := TRIM(inLogin);     
   inPassword := TRIM(inPassword);     
   WHILE POSITION ('  ' in inName) > 0 LOOP
     inName := REPLACE (inName, '  ', ' ');
   END LOOP;
   
   IF EXISTS (SELECT 1
              FROM Object AS Object_User
              WHERE Object_User.DescId = zc_Object_User()
                AND upper(TRIM(Object_User.ValueData)) = upper(inLogin))
   THEN
     RAISE EXCEPTION '����� <%> ��� �����.', inLogin;
   END IF;  
   
   IF COALESCE (inName, '') = ''
   THEN
     RAISE EXCEPTION '�� ��������� <���>.';
   END IF;

   IF COALESCE (inNameUkr, '') = ''
   THEN
     RAISE EXCEPTION '�� ��������� <��� �� ���������� �����>.';
   END IF;

   IF COALESCE (inPhone, '') = ''
   THEN
     RAISE EXCEPTION '�� �������� <����� ��������>.';
   END IF;

   IF NOT EXISTS (SELECT 1
                  FROM Object AS Object_Position
                  WHERE Object_Position.DescId = zc_Object_Position()
                    AND Object_Position.ObjectCode in (1, 2)
                    AND Object_Position.Id = inPositionId)
   THEN
     RAISE EXCEPTION '��������� ����� ���� <%> ��� <%>.'
           , (SELECT Object_Position.ValueData
                  FROM Object AS Object_Position
                  WHERE Object_Position.DescId = zc_Object_Position()
                    AND Object_Position.ObjectCode = 1)
           , (SELECT Object_Position.ValueData
                  FROM Object AS Object_Position
                  WHERE Object_Position.DescId = zc_Object_Position()
                    AND Object_Position.ObjectCode = 2);
   END IF;
  
   IF NOT EXISTS (SELECT 1
                  FROM Object AS Object_Unit
                  WHERE Object_Unit.DescId = zc_Object_Unit()
                    AND Object_Unit.Id = inUnitId)
   THEN
     RAISE EXCEPTION '�� ������� <�������������>.';
   END IF;

   IF COALESCE (inLogin, '') = ''
   THEN
     RAISE EXCEPTION '�� �������� <�����>.';
   END IF;

   IF COALESCE (inPassword, '') = ''
   THEN
     RAISE EXCEPTION '�� �������� <������>.';
   END IF;
   
   vbMember := gpInsertUpdate_Object_Member_Lite(ioId            := 0
                                               , inName          := inName
                                               , inNameUkr       := inNameUkr
                                               , inPhone         := inPhone
                                               , inPositionID    := inPositionId
                                               , inUnitID        := inUnitId
                                               , inSession       := inSession);
                                               
   if inPositionId = (SELECT Object_Position.Id  FROM Object AS Object_Position
                      WHERE Object_Position.DescId = zc_Object_Position()
                        AND Object_Position.ObjectCode = 1)
   THEN
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Education(), vbMember, 1658917);   
   END IF;
                                               
   ioId := gpInsertUpdate_Object_User_Lite(ioId                    := 0
                                         , inUserName              := inLogin
                                         , inPassword              := inPassword
                                         , inMemberId              := vbMember
                                         , inisNewUser             := True
                                         , inisInternshipCompleted := inisInternshipCompleted
                                         , inisSite                := inisSite
                                         , inSession               := inSession);
                                         
   PERFORM gpInsertUpdate_Object_UserRole(ioId	     := 0
                                        , inUserId   := ioId
                                        , inRoleId   := 59588
                                        , inSession  := inSession);

   PERFORM gpInsertUpdate_Object_UserRole(ioId	     := 0
                                        , inUserId   := ioId
                                        , inRoleId   := zc_Enum_Role_CashierPharmacy()
                                        , inSession  := inSession);

   -- �������� ������������ - ������
   PERFORM gpInsertUpdate_DefaultValue (ioId           := DefaultValue.Id
                                      , inDefaultKeyId := DefaultKeys.Id
                                      , inUserKey      := ioId
                                      , inDefaultValue := inUnitId :: TVarChar
                                      , inSession      := zfCalc_UserAdmin()
                                       )
   FROM DefaultKeys
        LEFT JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                              AND DefaultValue.UserKeyId    = ioId
   WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit');
        
   -- !!!�������� ��� �����!!!
   IF inSession = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%>', ioId, vbMember, inSession, lpGet_DefaultValue('zc_Object_Unit', ioId);
   END IF;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_NewUser (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.04.22                                                       *
*/

-- ����
-- select * from gpInsertUpdate_Object_NewUser(ioId := 0 , inName := '������ ���� ��������' , inPhone := '067 553-20-77' , inPositionId := 1672498 , inUnitId := 183289 , inLogin := '������ ����' , inPassword := '123456' ,  inSession := zfCalc_UserAdmin());