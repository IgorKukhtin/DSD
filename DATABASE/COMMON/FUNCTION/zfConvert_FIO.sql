-- Function: zfConvert_FIO ()

DROP FUNCTION IF EXISTS zfConvert_FIO (TVarChar, TFloat);
DROP FUNCTION IF EXISTS zfConvert_FIO (TVarChar, Integer, Boolean);

CREATE OR REPLACE FUNCTION zfConvert_FIO(
     TextFIO      TVarChar,    -- сессия пользователя
     ParamFIO     Integer ,
     isIFIN       Boolean -- DEFAULT FALSE
)
RETURNS  TVarChar
AS
$BODY$
   DECLARE vb1 Integer;
   DECLARE vb2 Integer;
BEGIN
      IF TRIM (COALESCE (TextFIO, '')) = '' THEN  RETURN(''); END IF;

      vb1 :=  position(' ' in TextFIO);

      vb2 :=  vb1 + position(' ' in (substring( TextFIO from vb1+1 for char_length(TextFIO) ) ));

 IF (vb1 = 0 )
 THEN 
  RETURN
      substring( TextFIO from 1 for char_length(TextFIO) ) :: TVarChar ;
  END IF;

  IF (ParamFIO = 1) and (vb1 <> 0)    -- сначала инициалы потом фамилия
  THEN
      RETURN
            (substring (TextFIO from vb1+1 for 1) || CASE WHEN isIFIN = TRUE THEN '. ' ELSE '.' END
          || substring( TextFIO from vb2+1 for 1) || '. '
          || substring( TextFIO from 1 for vb1-1)
            ) :: TVarChar;
      
  END IF;
  IF (ParamFIO = 2) and (vb1 <> 0)    -- сначала фамилия потом инициалы 
  THEN
      RETURN
            (substring( TextFIO from 1 for vb1-1)|| ' '
          || substring( TextFIO from vb1+1 for 1) || '.'
          || substring( TextFIO from vb2+1 for 1) || '.'
            ) :: TVarChar;
  END IF;
  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.11.15         *
*/

-- тест
-- SELECT zfConvert_FIO('Фелонюк Инна Владимировна', 1, TRUE), zfConvert_FIO('Фелонюк Инна Владимировна', 2, TRUE)
