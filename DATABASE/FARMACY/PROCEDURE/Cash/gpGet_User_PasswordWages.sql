-- Function: gpGet_User_PasswordWages()

DROP FUNCTION IF EXISTS gpGet_User_PasswordWages (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_PasswordWages(
   OUT outOperDate      TVarChar      , -- ���� ���������
   OUT outPasswordWages TVarChar      , -- ���� ���������
    IN inSession        TVarChar        -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    
    outPasswordWages := COALESCE((SELECT ObjectString_PasswordWages.ValueData
                                  FROM ObjectString AS ObjectString_PasswordWages
                                  WHERE ObjectString_PasswordWages.DescId = zc_ObjectString_User_PasswordWages() 
                                    AND ObjectString_PasswordWages.ObjectId = vbUserId), '');
                                    
    outOperDate := outPasswordWages;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.08.19                                                        *
*/
-- select * from gpGet_User_PasswordWages(inSession := '3');