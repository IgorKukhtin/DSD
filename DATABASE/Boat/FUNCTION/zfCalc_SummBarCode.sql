-- Function: zfCalc_SummBarCode

DROP FUNCTION IF EXISTS zfCalc_SummBarCode (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_SummBarCode(
    IN inBarCode     TVarChar
)
RETURNS Integer
AS
$BODY$
   DECLARE vbSumm Integer;
BEGIN

    IF LENGTH (inBarCode) < 12
    THEN
        RETURN 0;
    ELSE
        -- �����
        vbSumm:= zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 1  FOR 1)) :: Integer
               + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 3  FOR 1)) :: Integer
               + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 5  FOR 1)) :: Integer
               + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 7  FOR 1)) :: Integer
               + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 9  FOR 1)) :: Integer
               + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 11 FOR 1)) :: Integer
               + 3 * (zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 2  FOR 1)) :: Integer
                    + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 4  FOR 1)) :: Integer
                    + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 6  FOR 1)) :: Integer
                    + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 8  FOR 1)) :: Integer
                    + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 10 FOR 1)) :: Integer
                    + zfConvert_StringToFloat (SUBSTRING (inBarCode FROM 12 FOR 1)) :: Integer
                     );
        -- ������� �� ������� y/x
        vbSumm:=  MOD (vbSumm, 10);
        -- 
        IF vbSumm <> 0 THEN vbSumm:= 10 - vbSumm; END IF;
        
        -- ���������
        RETURN COALESCE (vbSumm, 0);

    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.06.19                                        *
*/

-- ����
-- SELECT * FROM zfCalc_SummBarCode ('123456789012');
