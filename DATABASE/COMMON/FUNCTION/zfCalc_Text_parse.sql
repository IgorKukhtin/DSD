-- Function: zfCalc_Text_parse

DROP FUNCTION IF EXISTS zfCalc_Text_parse (Text);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Text);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Text, Boolean);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Text, Boolean, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_Text_parse(
    IN inTradeMarkId Integer,
    IN inValue       Text,
    IN inIsLength    Boolean,
    IN inIsLimit     Boolean
)
RETURNS Text
AS
$BODY$
   DECLARE vbResult Text;
   DECLARE vbIndex  Integer;
   DECLARE vbLine   Integer;
   DECLARE vbLen    Integer;
   DECLARE vbI      Integer;
   DECLARE vbI_save Integer;

   DECLARE vbLen1  Integer;
   DECLARE vbLen2  Integer;
   DECLARE vbLen3  Integer;
   DECLARE vbLen4  Integer;
   DECLARE vbLen5  Integer;
   DECLARE vbLen6  Integer;
   DECLARE vbLen7  Integer;
   DECLARE vbLen8  Integer;
   DECLARE vbLen9  Integer;
   DECLARE vbLen10 Integer;
   DECLARE vbTmp   Integer;
   
BEGIN

    IF inTradeMarkId = 293382 -- select * from object where Id = 293382
    THEN
         -- ÚÏ —œ≈÷ ÷≈’
         vbLen1  := 40;
         vbLen2  := 45;
         vbLen3  := 45;
         vbLen4  := 48;
         vbLen5  := 48;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF inTradeMarkId = 293383 -- select * from object where Id = 293383
    THEN
         -- ÚÏ ¬¿–“Œ (¬‡ÛÒ)
         vbLen1  := 40;
         vbLen2  := 50;
         vbLen3  := 50;
         vbLen4  := 50;
         vbLen5  := 50;
         vbLen6  := 50;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF inTradeMarkId = 293384 -- select * from object where Id = 293384
    THEN
         -- ÚÏ Õ¿ÿ»  Œ¬¡¿—»
         vbLen1  := 40;
         vbLen2  := 47;
         vbLen3  := 47;
         vbLen4  := 47;
         vbLen5  := 50;
         vbLen6  := 50;
         vbLen7  := 55;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSE
         -- ÚÏ ¿À¿Õ
         vbLen1  := 40;
         vbLen2  := 48;
         vbLen3  := 47;
         vbLen4  := 47;
         vbLen5  := 47;
         vbLen6  := 52;
         vbLen7  := 51;
         vbLen8  := 60;
         vbLen9  := 1000;
         vbLen10 := 1000;

    END IF;


    vbIndex:= 0;
    vbLine:= 1;
    vbResult:= '';

    -- ÒÚ‡Ú
    WHILE vbIndex < LENGTH (inValue) OR (vbLine <= 8 AND inTradeMarkId = 293385 AND inIsLimit = TRUE) -- ÚÏ ¿À¿Õ -- select * from object where Id = 293385
    LOOP
       --
       vbLen:= CASE vbLine
                    WHEN 1  THEN vbLen1
                    WHEN 2  THEN vbLen2
                    WHEN 3  THEN vbLen3
                    WHEN 4  THEN vbLen4
                    WHEN 5  THEN vbLen5
                    WHEN 6  THEN vbLen6
                    WHEN 7  THEN vbLen7
                    WHEN 8  THEN vbLen8
                    WHEN 9  THEN vbLen9
                    WHEN 10 THEN vbLen10
                            ELSE 10000
               END;
               
       vbTmp:= vbLen;

       /*IF SUBSTRING (inValue FROM vbIndex + vbLen - 1 FOR 1) = ' '
       THEN vbLen:= vbLen + 1;
       ELSEIF SUBSTRING (inValue FROM vbIndex + vbLen + 2 FOR 1) = ' '
       THEN vbLen:= vbLen - 1;
       END IF;*/


       vbI:= 1;
       vbI_save:= vbLen;

       WHILE vbI <= vbLen
       LOOP

           IF SUBSTRING (inValue FROM vbIndex + 1 + vbI FOR 1) IN (' ', '.', ',', '-', '/', '(', ')')
           THEN vbI_save:= vbI + 1;
           END IF;

           vbI:= vbI + 1;

       END LOOP;

       IF vbIndex + vbI < LENGTH (inValue)
       THEN vbLen:= vbI_save;
       END IF;

       vbResult:= vbResult
               || CASE WHEN vbLine = 1 THEN '' ELSE CHR (13) END
               || TRIM (SUBSTRING (inValue FROM vbIndex + 1 FOR vbLen))
               || CASE WHEN inIsLength = TRUE THEN ' ' || LENGTH ( TRIM (SUBSTRING (inValue FROM vbIndex + 1 FOR vbLen))) :: TVarChar || '-' || vbLine :: TVarChar ELSE '' END
               -- || CASE WHEN inIsLength = TRUE THEN '*' || (vbIndex + vbLen) :: TVarChar || '*' || LENGTH (inValue) :: TVarChar ELSE '' END
                 ;

       -- ÚÂÔÂ¸ ÒÎÂ‰Û˛˛˘ËÈ
       vbLine:= vbLine + 1;
       vbIndex:= vbIndex + vbLen;

    END LOOP;

    RETURN COALESCE (vbResult, '');

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 10.06.16                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM zfCalc_Text_parse (inTradeMarkId:= 1, inValue:= 'asdsadasdasdasdasdasdasdasdasdasd', inIsLength:= TRUE, inIsLimit:= TRUE)
