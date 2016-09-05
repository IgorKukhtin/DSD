-- Function: zfCalc_WordNumber_Split

DROP FUNCTION IF EXISTS zfCalc_WordNumber_Split (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_WordNumber_Split(
    IN inValue TVarChar,
    IN inSep   TVarChar,
    IN inWord  TVarChar
)
RETURNS Integer
AS
$BODY$
   DECLARE vbResult     Integer;
   DECLARE vbIndex      Integer;
   DECLARE vbIndex_find Integer;
BEGIN
    vbIndex:= 1;
    vbResult:= 0;
    vbIndex_find:= 0;

    IF STRPOS (inValue, inWord) > 0
    THEN
        -- �����
        WHILE vbIndex <= LENGTH (inValue) AND vbResult = 0
        LOOP
           IF TRIM (SPLIT_PART (inValue, inSep, vbIndex)) <> ''
           THEN vbIndex_find:= vbIndex_find + 1; -- ����� �� ������ �����
           END IF;

           IF TRIM (SPLIT_PART (inValue, inSep, vbIndex)) = TRIM (inWord)
           THEN vbResult:= vbIndex_find; -- ��� �� ����� ��� ����
           END IF;

            -- ������ ����������
            vbIndex := vbIndex + 1;
        END LOOP;
    END IF;

    RETURN vbResult;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_WordNumber_Split (TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.06.16                                        *
*/

-- ����
-- SELECT * FROM zfCalc_Word_Split       (inValue:= '%1% %2%', inSep:= '%', inIndex:= 1)
-- SELECT * FROM zfCalc_WordNumber_Split (inValue:= '%1% %2%', inSep:= '%', inWord:= '1')
