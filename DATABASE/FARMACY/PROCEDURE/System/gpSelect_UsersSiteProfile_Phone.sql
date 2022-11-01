-- Function:  gpSelect_UsersSiteProfile_Phone

DROP FUNCTION IF EXISTS gpSelect_UsersSiteProfile_Phone (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_UsersSiteProfile_Phone (
    IN inPhone   TVarChar,
   OUT outPhone  TVarChar,
    IN inSession TVarChar
)
RETURNS TVarChar AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   outPhone := '+38'||'('||SUBSTRING(inPhone, 1, 3)||') '||SUBSTRING(inPhone, 4, 3)||'-'||SUBSTRING(inPhone, 7, 4);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.04.18                                                       *

*/

-- ����
-- 

select * from gpSelect_UsersSiteProfile_Phone(inPhone := '0971392480' ,  inSession := '3');