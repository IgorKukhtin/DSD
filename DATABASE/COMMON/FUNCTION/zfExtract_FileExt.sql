-- Function: zfExtract_FileExt (TDateTime)

DROP FUNCTION IF EXISTS zfExtract_FileExt (TVarChar);

CREATE OR REPLACE FUNCTION zfExtract_FileExt (inFullFileName TVarChar)
RETURNS TVarChar AS
$BODY$
BEGIN

  WHILE Position('\' in inFullFileName) > 0
  LOOP
      inFullFileName := substring(inFullFileName,Position('\' in inFullFileName) + 1, length(inFullFileName));
  END LOOP;  
  
  IF Position('.' in inFullFileName) > 0
  THEN
      inFullFileName := substring(inFullFileName,Position('.' in inFullFileName), length(inFullFileName));
  ELSE
      inFullFileName := '';
  END IF;

  RETURN inFullFileName;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthYearNameUkr (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.12.21                                                       *
*/

-- тест
-- 
SELECT zfExtract_FileExt ('d:\DSD\DATABASE\FARMACY\PROCEDURE\MovementItem\Pretension\gpSelect_MovementItem_ChechPretension.sql')