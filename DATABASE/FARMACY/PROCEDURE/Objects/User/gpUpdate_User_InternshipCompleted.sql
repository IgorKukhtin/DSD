-- Function: gpUpdate_User_InternshipCompleted()

DROP FUNCTION IF EXISTS gpUpdate_User_InternshipCompleted (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_InternshipCompleted(
    IN inUserId                    Integer   ,    -- ���������
    IN inIsInternshipCompleted     Boolean   ,    -- ���������� ���������
    IN inSession                   TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inisInternshipCompleted, FALSE) <>
      COALESCE((SELECT ObjectBoolean.ValueData 
                FROM ObjectBoolean 
                WHERE ObjectBoolean.ObjectId = inUserId 
                  AND ObjectBoolean.DescId = zc_ObjectBoolean_User_InternshipCompleted()), FALSE)
   THEN

     IF inIsInternshipCompleted = False AND 
        NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
       RAISE EXCEPTION '��������� <���������� ���������>. ��������� ������ ���������� ��������������';
     END IF;     

       -- �������� <���������� ���������>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_InternshipCompleted(), inUserId, inIsInternshipCompleted);

     IF inIsInternshipCompleted = TRUE
     THEN
       -- �������� <���� ������������� ����������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_InternshipCompleted(), inUserId, CURRENT_DATE);
     END IF;     

     -- ������� ���������
     PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);
     
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.22                                                       *
*/