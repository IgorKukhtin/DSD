-- Function: zfCalc_PartionGoodsName_Asset

DROP FUNCTION IF EXISTS zfCalc_PartionGoodsName_Asset (Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoodsName_Asset(
    IN inMovementId                Integer,   -- ������ - ��������
    IN inInvNumber                 TVarChar,  -- ����������� ����� - ������ ��� + ����
    IN inOperDate                  TDateTime, -- ���� ����� � ������������
    IN inUnitName                  TVarChar,  -- *������������� �������������
    IN inStorageName               TVarChar,  -- *����� ��������
    IN inGoodsName                 TVarChar   -- *�������� �������� ��� �����
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN (TRIM (CASE WHEN inInvNumber <> '' AND inInvNumber <> '0'  THEN '�� ���.� <' || inInvNumber || '>' ELSE '�� � <' || COALESCE ((SELECT InvNumber FROM Movement WHERE Id = inMovementId), '') || '> �� <' || COALESCE (zfConvert_DateToString (((SELECT OperDate FROM Movement WHERE Id = inMovementId))), '') || '>'  END
                || CASE WHEN COALESCE (inOperDate, zc_DateStart()) NOT IN (zc_DateStart(), zc_DateEnd()) THEN ' ���� � �����. : <' || zfConvert_DateToString (COALESCE (inOperDate, zc_DateStart())) || '>' ELSE '' END
                || CASE WHEN inUnitName    <> '' THEN ' ����. ������������� : <' || COALESCE (inUnitName, '')    || '>' ELSE '' END
                || CASE WHEN inStorageName <> '' THEN ' ����� ��������� : <'     || COALESCE (inStorageName, '') || '>' ELSE '' END
                  ));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.08.17                                        *
*/

-- ����
-- SELECT * FROM zfCalc_PartionGoodsName_Asset (1, '1', CURRENT_DATE, '', '', '')
