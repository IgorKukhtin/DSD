-- Function: zfExtract_FileName (TDateTime)

DROP FUNCTION IF EXISTS zfExtract_FileName (TVarChar);

CREATE OR REPLACE FUNCTION zfExtract_FileName (inFullFileName TVarChar)
RETURNS TVarChar AS
$BODY$
BEGIN

  WHILE Position('\' in inFullFileName) > 0
  LOOP
      inFullFileName := substring(inFullFileName,Position('\' in inFullFileName) + 1, length(inFullFileName));
  END LOOP;  


  RETURN inFullFileName;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthYearNameUkr (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.12.21                                                       *
*/

-- ����
-- 
SELECT zfExtract_FileName ('d:\DSD\DATABASE\FARMACY\PROCEDURE\MovementItem\Pretension\gpSelect_MovementItem_ChechPretension.sql')
