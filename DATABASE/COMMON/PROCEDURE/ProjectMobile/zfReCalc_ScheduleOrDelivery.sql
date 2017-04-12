DROP FUNCTION IF EXISTS zfReCalc_ScheduleOrDelivery (TVarChar, TVarChar, Boolean);

CREATE OR REPLACE FUNCTION zfReCalc_ScheduleOrDelivery (
    IN inSchedule   TVarChar, 
    IN inDelivery   TVarChar, 
    IN inisDelivery Boolean
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbSchedule TVarChar; 
   DECLARE vbDelivery TVarChar; 
   DECLARE vbisDelivery Boolean;
BEGIN
      vbisDelivery:= COALESCE (inisDelivery, false)::Boolean;

      IF (inSchedule IS NULL) AND (inDelivery IS NULL)
      THEN
           vbSchedule:= 't;t;t;t;t;t;t';
           vbDelivery:= vbSchedule;
      ELSIF (inSchedule IS NOT NULL) AND (inDelivery IS NULL)
      THEN
           vbSchedule:= REPLACE (REPLACE (LOWER (inSchedule), 'true', 't'), 'false', 'f')::TVarChar;
           IF CHAR_LENGTH (vbSchedule) > 12
           THEN
                vbDelivery:= SUBSTRING (vbSchedule FROM 13 FOR 1) || ';' || SUBSTRING (vbSchedule FROM 1 FOR 11);
           ELSIF (CHAR_LENGTH (vbSchedule) > 0) AND (CHAR_LENGTH (vbSchedule) < 12)
           THEN 
                vbDelivery:= 'f;' || SUBSTRING (vbSchedule FROM 1 FOR CHAR_LENGTH (vbSchedule));
           ELSE
                vbDelivery:= 'f;f;f;f;f;f;f'; 
           END IF; 
      ELSIF (inSchedule IS NULL) AND (inDelivery IS NOT NULL)
      THEN
           vbSchedule:= 't;t;t;t;t;t;t';
           vbDelivery:= REPLACE (REPLACE (LOWER (inDelivery), 'true', 't'), 'false', 'f')::TVarChar;
      ELSE
           vbSchedule:= REPLACE (REPLACE (LOWER (inSchedule), 'true', 't'), 'false', 'f')::TVarChar;
           vbDelivery:= REPLACE (REPLACE (LOWER (inDelivery), 'true', 't'), 'false', 'f')::TVarChar;
      END IF;

      IF vbisDelivery
      THEN
           RETURN vbDelivery;
      ELSE
           RETURN vbSchedule;
      END IF; 
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.  ßðîøåíêî Ð.Ô.
 12.04.17                                                        *   
*/

-- òåñò
/* 
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= NULL, inDelivery:= NULL, inisDelivery:= false)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= '', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f;t;f', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f;t;f', inDelivery:= NULL, inisDelivery:= false)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= NULL, inDelivery:= 't;f;t;true;false;t;f', inisDelivery:= true)
*/