-- Function: zfCalc_Text_parse

DROP FUNCTION IF EXISTS zfCalc_Text_parse (Text);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Text);

CREATE OR REPLACE FUNCTION zfCalc_Text_parse(
    IN inTradeMarkId Integer,
    IN inValue       Text
)
RETURNS Text
AS
$BODY$
   DECLARE vbResult Text;
   DECLARE vbIndex Integer;
   DECLARE vbLine  Integer;
   DECLARE vbLen   Integer;

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
BEGIN
    vbIndex:= 0;
    vbLine:= 1;
    vbResult:= '';


    IF inTradeMarkId = 293382 
    THEN
         -- ÚÏ —œ≈÷ ÷≈’
         vbLen1  := 40;
         vbLen2  := 50;
         vbLen3  := 50;
         vbLen4  := 50;
         vbLen5  := 1000;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF inTradeMarkId = 293383
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

    ELSEIF inTradeMarkId = 293384
    THEN
         -- ÚÏ Õ¿ÿ»  Œ¬¡¿—»
         vbLen1  := 40;
         vbLen2  := 50;
         vbLen3  := 50;
         vbLen4  := 55;
         vbLen5  := 55;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSE
         -- ÚÏ ¿À¿Õ
         vbLen1  := 40;
         vbLen2  := 45;
         vbLen3  := 45;
         vbLen4  := 50;
         vbLen5  := 55;
         vbLen6  := 55;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    END IF;

        -- ÒÚ‡Ú
        WHILE vbIndex <= LENGTH (inValue)
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

           IF SUBSTRING (inValue FROM vbIndex + vbLen - 1 FOR 1) = ' '
           THEN vbLen:= vbLen + 1;
           ELSEIF SUBSTRING (inValue FROM vbIndex + vbLen + 2 FOR 1) = ' '
           THEN vbLen:= vbLen - 1;
           END IF;

           vbResult:= vbResult
                   || CASE WHEN vbLine = 1 THEN '' ELSE CHR (13) END
                   || SUBSTRING (inValue FROM vbIndex + 1 FOR vbLen);

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
-- SELECT * FROM zfCalc_Text_parse (inTradeMarkId:= 1, inValue:= 'asdsadasdasdasdasdasdasdasdasdasd')
