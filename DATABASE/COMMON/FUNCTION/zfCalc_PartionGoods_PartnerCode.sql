-- Function: zfCalc_PartionGoods_PartnerCode

DROP FUNCTION IF EXISTS zfCalc_PartionGoods_PartnerCode (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoods_PartnerCode(
    IN inPartionGoods TVarChar  -- 
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ���������
     RETURN (CASE WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 4)) IS NOT NULL
                       THEN zfConvert_StringToNumber (split_part (TRIM (inPartionGoods), '-', 3))
                  WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 3)) IS NOT NULL
                       THEN zfConvert_StringToNumber (split_part (TRIM (inPartionGoods), '-', 2))
                  ELSE NULL
             END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.06.19                                        *
*/

-- ����
-- SELECT * FROM Object WHERE ObjectCode in (zfCalc_PartionGoods_PartnerCode ('��-4218-235870-14.06.2019'),  zfCalc_PartionGoods_PartnerCode ('')) AND DescId = zc_Object_Partner()
