-- Function: zfCheck_BarCode

DROP FUNCTION IF EXISTS zfCheck_BarCode (Integer,  Boolean);

CREATE OR REPLACE FUNCTION zfCheck_BarCode(
    IN inBarCode     TVarChar,
    IN iShownError   Boolean
)
RETURNS Boolean AS
$BODY$
   DECLARE vbBarCode TVarChar;
   DECLARE vbPos Integer;
   DECLARE vbSum Integer;
BEGIN

    IF COALESCE (inBarCode, '') = ''
    THEN
      IF iShownError = TRUE
      THEN
        RAISE EXCEPTION 'Не заполнено значение штрих-кода';
      END IF;
      RETURN FALSE;
    END IF;

    IF length(inBarCode) > 13
    THEN
      IF iShownError = TRUE
      THEN
        RAISE EXCEPTION 'Длина штрих-кода должна быть не более 13 символов';
      END IF;
      RETURN FALSE;
    END IF;

    IF (inBarCode ~ '^[0-9]+$') = False
    THEN
      IF iShownError = TRUE
      THEN
        RAISE EXCEPTION 'Штрих-кода должна должен содержать только цифры.';
      END IF;
      RETURN FALSE;
    END IF;

    vbBarCode := inBarCode;
    WHILE Length(vbBarCode) < 13 LOOP
       vbBarCode := '0' || vbBarCode;
    END LOOP;

    vbPos := 1;
    vbSum := 0;

    WHILE vbPos < Length(vbBarCode) LOOP
       IF vbPos % 2 = 1 
       THEN
         vbSum := vbSum + SUBSTRING(vbBarCode, vbPos, 1)::Integer;
       ELSE 
         vbSum := vbSum + SUBSTRING(vbBarCode, vbPos, 1)::Integer * 3;             
       END IF;             
       vbPos := vbPos + 1;
    END LOOP;
          
    IF SUBSTRING(vbBarCode, Length(vbBarCode), 1)::Integer <> (CASE WHEN vbSum % 10 = 0 THEN 0 ELSE 10 - (vbSum % 10) END)
    THEN
      IF iShownError = TRUE
      THEN
        RAISE EXCEPTION 'Ошибка контрольной суммы штрих-кода.';
      END IF;
      RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$BODY$
LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfFormat_BarCode (TVarChar, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 16.06.19                                                                      *
*/

-- тест
-- SELECT * FROM zfCheck_BarCode ('4823012801313', True)