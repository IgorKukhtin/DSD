-- Function: zfCalc_Word_Split

DROP FUNCTION IF EXISTS zfCalc_Word_Split (TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION zfCalc_Word_Split(
    IN inValue TVarChar,
    IN inSep   TVarChar,
    IN inIndex Integer
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbResult TVarChar;
   DECLARE vbIndex Integer;
   DECLARE vbIndex_find Integer;
BEGIN
    vbIndex:= 1;
    vbIndex_find:= 0;

    IF STRPOS (inValue, inSep) > 0
    THEN
        -- �����
        WHILE vbIndex <= LENGTH (inValue) AND vbIndex_find <> inIndex
        LOOP
           IF TRIM (SPLIT_PART (inValue, inSep, vbIndex)) <> ''
           THEN vbIndex_find:= vbIndex_find + 1; -- ����� �� ������ �����
           END IF;

           IF vbIndex_find = inIndex
           THEN vbResult:= TRIM (SPLIT_PART (inValue, inSep, vbIndex)); -- ��� �� ����� ��� ����
           END IF;

            -- ������ ����������
            vbIndex := vbIndex + 1;
        END LOOP;
    ELSEIF TRIM (inValue) <> '' AND inIndex = 1
    THEN
        vbResult:= TRIM (inValue);
    END IF;

    RETURN COALESCE (vbResult, '');

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_Word_Split (TVarChar, TVarChar, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.06.16                                        *
*/

-- ����
-- SELECT * FROM zfCalc_Word_Split (inValue:= '%1% %2%', inSep:= '%', inIndex:= 1)
