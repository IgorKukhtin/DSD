-- Function: zfConvert_FIO ()

DROP FUNCTION IF EXISTS zfCalc_Position (TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION zfCalc_Position(
     inValue        Text,    -- сессия пользователя
     inPos          TVarChar,
     inStartPos     Integer 
)
RETURNS Integer
AS
$BODY$
BEGIN
  IF TRIM (COALESCE (inValue, '')) = '' THEN  RETURN (0); END IF;

  RETURN
      POSITION ( inPos IN SUBSTRING(inValue, inStartPos, 255)::TVarChar) :: integer;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.20         *
*/

-- тест
-- SELECT zfCalc_Position('Фелонюк Инна Владимировна', 'Ин', 4)
