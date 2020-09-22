-- Function: zfConvert_FloatToString

DROP FUNCTION IF EXISTS zfConvert_FloatToString (TFloat);

CREATE OR REPLACE FUNCTION zfConvert_FloatToString (Value TFloat)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbRetV TVarChar;
BEGIN
     vbRetV:= TRIM (TO_CHAR (Value, '999 999 999 999 999.9999') || '_');
     vbRetV:= REPLACE (vbRetV, '0_', '_');
     vbRetV:= REPLACE (vbRetV, '0_', '_');
     vbRetV:= REPLACE (vbRetV, '0_', '_');
     vbRetV:= REPLACE (vbRetV, '0_', '_');
     vbRetV:= REPLACE (vbRetV, '._', '_');
     vbRetV:= REPLACE (vbRetV, '_', '');

     IF Value > 0 AND SUBSTRING (vbRetV FROM 1 FOR 1) = '.' THEN vbRetV:= '0' || vbRetV; END IF;
     IF Value < 0 AND SUBSTRING (vbRetV FROM 2 FOR 1) = '.' THEN vbRetV:= '-0' || REPLACE (vbRetV, '-', ''); END IF;
     IF vbRetV = '' THEN vbRetV:= '0'; END IF;

     RETURN vbRetV;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_FloatToString (TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 30.11.15                                        *
*/

-- òåñò
-- SELECT zfConvert_FloatToString (12345.678), zfConvert_FloatToString (-12345.67), zfConvert_FloatToString (-0.5), zfConvert_FloatToString (0.5), zfConvert_FloatToString (0)
