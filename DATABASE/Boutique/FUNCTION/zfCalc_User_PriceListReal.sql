-- Function: zfCalc_User_PriceListReal

DROP FUNCTION IF EXISTS zfCalc_User_PriceListReal ();

CREATE OR REPLACE FUNCTION zfCalc_User_PriceListReal(
    IN inUserId Integer -- ����
)
RETURNS Boolean
AS
$BODY$
BEGIN
     
     RETURN (inUserId IN (23902/*, 2*/));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.05.20                                        * - !!!��� ������!!!
*/

-- ����
-- SELECT * FROM zfCalc_User_PriceListReal (1)
