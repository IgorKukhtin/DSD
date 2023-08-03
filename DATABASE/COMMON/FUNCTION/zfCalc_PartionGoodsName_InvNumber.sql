-- Function: zfCalc_PartionGoodsName_InvNumber

DROP FUNCTION IF EXISTS zfCalc_PartionGoodsName_InvNumber (TVarChar, TDateTime, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoodsName_InvNumber(
    IN inInvNumber                 TVarChar,  -- ����������� ����� - ������ ��� + ����
    IN inOperDate                  TDateTime, -- ���� �����������
    IN inPrice                     TFloat,    -- ����
    IN inUnitName_Partion          TVarChar,  -- *�������������(��� ����)
    IN inStorageName               TVarChar,  -- *����� ��������
    IN inGoodsName                 TVarChar   -- *�����
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN (TRIM (CASE WHEN TRIM (inInvNumber) <> '' AND inInvNumber <> '0'  THEN inInvNumber
                        ELSE CASE WHEN inInvNumber <> '' AND inInvNumber <> '0'  THEN '���. � <' || inInvNumber || '>' ELSE '' END
                         || ' ���� : <'|| zfConvert_FloatToString (COALESCE (inPrice, 0)) || '>'
                         || ' �� : <' || zfConvert_DateToString (COALESCE (inOperDate, zc_DateStart())) || '>'
                         || '  <'|| COALESCE (inUnitName_Partion, '') || '>'
                         || CASE WHEN inStorageName <> '' THEN ' ����� ��������� : <'|| COALESCE (inStorageName, '') || '>' ELSE '' END
                   END
                  ) :: TVarChar);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.15                                        *
*/

-- ����
-- SELECT * FROM zfCalc_PartionGoodsName_InvNumber ('1', CURRENT_DATE, 12.3, '', '', '')
