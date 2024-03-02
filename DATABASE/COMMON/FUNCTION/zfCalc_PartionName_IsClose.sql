-- Function: zfCalc_PartionCell_IsClose

DROP FUNCTION IF EXISTS zfCalc_PartionCell_IsClose (TVarChar, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_PartionCell_IsClose(
    IN inPartionCellName  TVarChar,
    IN inIsClose          Boolean
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN (CASE WHEN inIsClose = TRUE THEN '����� - ' ELSE '' END
          || COALESCE (inPartionCellName, '')
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.03.24                                        *
*/

-- ����
-- SELECT * FROM zfCalc_PartionCell_IsClose ('PartionCellName', TRUE)
