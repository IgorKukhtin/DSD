-- Function: zfConvert_StringToTime

DROP FUNCTION IF EXISTS zfConvert_StringToTime (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToTime (Value TVarChar)
RETURNS TDateTime AS
$BODY$
BEGIN

  RETURN Value :: TDateTime;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN zc_DateStart();
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.22                        *  
*/

-- ����
-- SELECT * FROM zfConvert_StringToTime ('10:00'), zfConvert_StringToDate ('10:00'), zc_DateStart()
