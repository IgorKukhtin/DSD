-- Function: zfCalc_PartionGoodsName_InvNumber

DROP FUNCTION IF EXISTS zfCalc_PartionGoodsName_InvNumber (TVarChar, TDateTime, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoodsName_InvNumber(
    IN inInvNumber                 TVarChar,  -- 
    IN inOperDate                  TDateTime, -- 
    IN inPrice                     TFloat,    -- ����
    IN inUnitName_Partion          TVarChar,  -- *�������������(��� ����)
    IN inStorageName               TVarChar,  -- *����� ��������
    IN inGoodsName                 TVarChar   -- *�����
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN (TRIM (CASE WHEN inInvNumber <> '' THEN '� <' || inInvNumber || '>' ELSE '' END
                || CASE WHEN inOperDate <> zc_DateStart() THEN ' <' || DATE (inOperDate) :: TVarChar || '>' ELSE '' END
                || ' ���� : <'|| COALESCE (inPrice, 0) :: TVarChar || '>'
                || ' �� : <'|| COALESCE (inUnitName_Partion, '') || '>'
                || CASE WHEN inStorageName <> '' THEN ' ����� ��������� : <'|| COALESCE (inStorageName, '') || '>' ELSE '' END
                  ));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_PartionGoodsName_InvNumber (TVarChar, TDateTime, TFloat, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.15                                        *
*/

-- ����
-- SELECT * FROM zfCalc_PartionGoodsName_InvNumber ('1', CURRENT_DATE, 12.3, '', '', '')
