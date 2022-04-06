-- Function: zfCalc_InvNumber_isErased_sh (TVarChar, Integer)

DROP FUNCTION IF EXISTS zfCalc_InvNumber_isErased_sh (TVarChar, TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION zfCalc_InvNumber_isErased_sh (inDescName TVarChar, inInvNumber TVarChar, inOperDate TDateTime, inStatusId Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN (TRIM (CASE WHEN inStatusId = zc_Enum_Status_UnComplete() THEN zc_InvNumber_Status_UnComlete()
                         WHEN inStatusId = zc_Enum_Status_Erased()     THEN zc_InvNumber_Status_Erased()
                         ELSE ''
                    END
                 ||' '
                 || inInvNumber)
             );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.05.21                                        *
*/

-- ����
-- SELECT zfCalc_InvNumber_isErased_sh ('', '123', CURRENT_DATE, zc_Enum_Status_UnComplete()), zfCalc_InvNumber_isErased_sh ('', '123', CURRENT_DATE, zc_Enum_Status_Erased())
