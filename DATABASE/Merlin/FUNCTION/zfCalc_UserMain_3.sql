-- Function: zfCalc_UserMain_3

DROP FUNCTION IF EXISTS zfCalc_UserMain_3();

CREATE OR REPLACE FUNCTION zfCalc_UserMain_3()
RETURNS Integer
AS
$BODY$
BEGIN
     
     RETURN (SELECT MIN (Object.Id)
             FROM Object
                  JOIN ObjectBoolean AS OB_User_Sign
                                     ON OB_User_Sign.ObjectId  = Object.Id
                                    AND OB_User_Sign.DescId    = zc_ObjectBoolean_User_Sign()
                                    AND OB_User_Sign.ValueData = TRUE
             WHERE Object.DescId = zc_Object_User()
               AND Object.Id > zfCalc_UserMain_2()
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.01.22                                        *
*/

-- ����
-- SELECT * FROM Object WHERE Id = zfCalc_UserMain_3()