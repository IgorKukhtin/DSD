DROP FUNCTION IF EXISTS zfConvert_FIO ( TVarChar, Tfloat);

CREATE OR REPLACE FUNCTION zfConvert_FIO(
     TextFIO      TVarChar,    -- сессия пользователя
     ParamFIO        Tfloat
)
RETURNS  TVarChar AS
$BODY$
   DECLARE vb1 Integer;
   DECLARE vb2 Integer;
BEGIN
     
      vb1 :=  position(' ' in TextFIO);
      vb2 :=  vb1 + position(' ' in (substring( TextFIO from vb1+1 for char_length(TextFIO) ) ));

 
  IF ParamFIO = 1    -- сначала инициалы потом фамилия
  THEN
   RETURN
      substring( TextFIO from vb1+1 for 1) || '.' || substring( TextFIO from vb2+1 for 1) || '. ' || substring( TextFIO from 1 for vb1-1) :: TVarChar ;
      
  END IF;
  IF ParamFIO = 2    -- сначала фамилия потом инициалы 
  THEN
   RETURN
      substring( TextFIO from 1 for vb1-1)|| ' ' || substring( TextFIO from vb1+1 for 1) || '.' || substring( TextFIO from vb2+1 for 1) || '. '   :: TVarChar ;
  END IF;
  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.11.15         *
*/
-- Тест
--     SELECT zfConvert_FIO('Фелонюк Инна Владимировна')