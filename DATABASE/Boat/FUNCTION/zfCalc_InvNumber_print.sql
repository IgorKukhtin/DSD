-- Function: zfCalc_InvNumber_print (TVarChar, TVarChar, TDateTime, Integer)

DROP FUNCTION IF EXISTS zfCalc_InvNumber_print (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_InvNumber_print (inInvNumber TVarChar)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN REPEAT ('0', 8 - LENGTH (COALESCE (inInvNumber, ''))) || COALESCE (inInvNumber, '')
     ;

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
-- SELECT zfCalc_InvNumber_print ('123')
