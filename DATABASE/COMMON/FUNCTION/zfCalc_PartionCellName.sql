-- Function: zfCalc_PartionCellName

DROP FUNCTION IF EXISTS zfCalc_PartionCellName (TVarChar, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_PartionCellName(
    IN inPartionCellName  TVarChar  , -- 
    IN inBoxCount         TFloat    , -- 
    IN inLevel_cell       TFloat      -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     IF inPartionCellName <> ''
     THEN
         -- ��������
         IF COALESCE (inBoxCount, 0) = 0 THEN inBoxCount:= 8; END IF;
         -- ���������� ���������
         RETURN (inPartionCellName || CASE WHEN inBoxCount > 0 THEN ' (E2-' || (inBoxCount :: Integer) :: TVarChar || '��.)' ELSE '' END
                                   || CASE WHEN inLevel_cell > 0 THEN ' �-' || (inLevel_cell :: Integer) :: TVarChar || '' ELSE '' END
                );
     ELSE
         -- ���������� ���������
         RETURN '';
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.11.15                                        *
*/

-- ����
-- SELECT * FROM zfCalc_PartionCellName (inPartionCellName:= 'R-9-5-1', inBoxCount:= 0, inLevel_cell:= 3)
