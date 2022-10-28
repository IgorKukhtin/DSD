-- Function:  gpSelect_PhoneNumberVerification

DROP FUNCTION IF EXISTS gpSelect_PhoneNumberVerification (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PhoneNumberVerification (
    IN inPhone   TVarChar ,
   OUT outPhone  TVarChar ,
    IN inSession TVarChar
)
RETURNS TVarChar AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   outPhone := '38'||inPhone;
   
   IF SUBSTRING (outPhone, 1, 2) <> '38' OR length(outPhone) <> 12
   THEN
     RAISE EXCEPTION '������. ����� �������� ������ ���������� � <38> � ���������� ���� 12';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.10.22                                                       *

*/

-- ����
-- 
select * from gpSelect_PhoneNumberVerification ('0505532306', '3');