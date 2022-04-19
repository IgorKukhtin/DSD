-- Function: gpSelect_ShowPUSH_ChechSetErased(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_NewUser(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_NewUser(
    IN inUserID       integer,          -- ������������
   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

  outShowMessage := False;
  outText := '';

  IF COALESCE (inUserID, 0) <> 0
  THEN
    outShowMessage := True;
    outPUSHType := zc_TypePUSH_Information();
    
    SELECT '���������� ��� ������ ����������:'||CHR(13)||CHR(13)||
           '�����  - '||Object_User.ValueData||CHR(13)||CHR(13)||
           '������ - '||ObjectString_UserPassword.ValueData
    INTO outText
    FROM Object AS Object_User
         LEFT JOIN ObjectString AS ObjectString_UserPassword 
                ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Password() 
               AND ObjectString_UserPassword.ObjectId = Object_User.Id
    WHERE Object_User.Id = inUserID;    
  END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.04.23                                                       *

*/

-- 
SELECT * FROM gpSelect_ShowPUSH_NewUser(3, '3')