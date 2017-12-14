-- Function: zfCalc_CountDigit

DROP FUNCTION IF EXISTS zfCalc_CountDigit (Text);

CREATE OR REPLACE FUNCTION zfCalc_CountDigit (IN inValue Text)
RETURNS Integer
AS
$BODY$
   DECLARE i Integer;
   DECLARE vbRetV Integer;
BEGIN
     
     --
     vbRetV:= 0;

     --
     i:= 1;
     --
     WHILE i <= LENGTH (inValue)
     LOOP
         IF SUBSTRING (inValue FROM i FOR 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
         THEN vbRetV:= vbRetV + 1;
         END IF;

         -- òåïåðü ñëåäóþùèé
         i:= i + 1;

     END LOOP;

     -- Ðåçóëüòàò - ñêîëüêî öèôð â ñòðîêå
     RETURN vbRetV;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 14.12.17                                        *
*/

-- òåñò
-- SELECT zfCalc_CountDigit ('1212aaa1212wde')
