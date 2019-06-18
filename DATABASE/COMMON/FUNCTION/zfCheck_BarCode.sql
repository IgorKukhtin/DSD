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
        RAISE EXCEPTION '�� ��������� �������� �����-����';
      END IF;
      RETURN FALSE;
    END IF;

    IF length(inBarCode) > 13
    THEN
      IF iShownError = TRUE
      THEN
        RAISE EXCEPTION '����� �����-���� ������ ���� �� ����� 13 ��������';
      END IF;
      RETURN FALSE;
    END IF;

    IF (inBarCode ~ '^[0-9]+$') = False
    THEN
      IF iShownError = TRUE
      THEN
        RAISE EXCEPTION '�����-���� ������ ������ ��������� ������ �����.';
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
        RAISE EXCEPTION '������ ����������� ����� �����-����.';
      END IF;
      RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$BODY$
LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfFormat_BarCode (TVarChar, Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 16.06.19                                                                      *
*/

-- ����
-- SELECT * FROM zfCheck_BarCode ('4823012801313', True)