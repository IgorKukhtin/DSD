-- Function: gpGet_User_IsAdmin (TVarChar)

DROP FUNCTION IF EXISTS gpGet_User_IsRole (Boolean, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_IsRole(
    IN inisAdmin     Boolean  ,     -- ���� �������������
    IN inUserRole    TBlob    ,     -- ������ �����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS BOOLEAN AS
$BODY$
   DECLARE vbUserId integer;
   DECLARE vbIndex Integer;
BEGIN
    vbUserId:= lpGetUserBySession (inSession);

    IF inisAdmin = TRUE
    THEN
      IF EXISTS(Select * from gpSelect_Object_UserRole(inSession) Where UserId = vbUserId AND Id = zc_Enum_Role_Admin())
      THEN
          RETURN True;
      END IF;
    END IF;

    -- ������ ����
    vbIndex := 1;
    WHILE TRIM(SPLIT_PART (inUserRole, ',', vbIndex)) <> '' LOOP
        -- ���������
        IF EXISTS(Select * from gpSelect_Object_UserRole(inSession) Where UserId = vbUserId AND Id IN
                  (Select Object_Role.Id FROM Object AS Object_Role 
                   WHERE Object_Role.DescId = zc_Object_Role()
                     AND Object_Role.isErased = FALSE
                     AND Object_Role.ValueData ILIKE TRIM(SPLIT_PART (inUserRole, ',', vbIndex))))
        THEN
            RETURN True;
        END IF;
        -- ������ ����������
        vbIndex := vbIndex + 1;
    END LOOP;    
    
    RETURN False;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_User_IsAdmin (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.05.23                                                       *
*/
-- 
SELECT * FROM gpGet_User_IsRole (False, '��������������', '11097050')
