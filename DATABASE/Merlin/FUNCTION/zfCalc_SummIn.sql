-- Function: ������� ����� �� ������� �����  - ���������� �� 2 ������

DROP FUNCTION IF EXISTS zfCalc_SummIn (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummIn(
    IN inAmount        TFloat, -- ���-��
    IN inOperPrice     TFloat, -- ���� �������
    IN inCountForPrice TFloat  -- ���� �� ����������
)
RETURNS TFloat
AS
$BODY$
BEGIN

    -- ���������� �� 2 ������
    RETURN CAST (COALESCE (inAmount, 0) * COALESCE (inOperPrice, 0) / CASE WHEN inCountForPrice > 0 THEN inCountForPrice ELSE 1 END
                 AS NUMERIC (16, 2));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.17                                        *
*/

-- ����
-- SELECT * FROM zfCalc_SummIn (inAmount:= 2, inOperPrice:= 3, inCountForPrice:= 1)
