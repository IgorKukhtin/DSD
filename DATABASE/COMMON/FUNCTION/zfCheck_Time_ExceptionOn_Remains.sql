-- Function: zfCheck_Time_ExceptionOn_Remains

DROP FUNCTION IF EXISTS zfCheck_Time_ExceptionOn_Remains ();

CREATE OR REPLACE FUNCTION zfCheck_Time_ExceptionOn_Remains()
RETURNS Boolean
AS
$BODY$
   DECLARE vbBarCode TVarChar;
   DECLARE vbPos Integer;
   DECLARE vbSum Integer;
BEGIN

    IF -- время с 9:00 до 17:00
     --EXTRACT (HOUR FROM DATE_TRUNC ('HOUR', CURRENT_TIMESTAMP)) BETWEEN 9 AND 16
       EXTRACT (HOUR FROM DATE_TRUNC ('HOUR', CURRENT_TIMESTAMP)) BETWEEN 9 AND 17
       -- с Пн по Птн
       AND EXTRACT (DOW FROM CURRENT_DATE) BETWEEN 1 AND 5
       AND 1=0
    THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.02.22                                        *
*/

-- тест
-- SELECT * FROM zfCheck_Time_ExceptionOn_Remains()
