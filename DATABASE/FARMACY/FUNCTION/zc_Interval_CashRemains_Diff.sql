-- Function: zc_Interval_CashRemains_Diff

DROP FUNCTION IF EXISTS zc_Interval_CashRemains_Diff() ;


CREATE OR REPLACE FUNCTION zc_Interval_CashRemains_Diff(
    IN inSession           TVarChar   -- ������ ������������
) 
RETURNS Integer 
AS 
$BODY$
BEGIN 
    RETURN 7 * 60 * 1000;
END; 
$BODY$ 
LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������������ �.�.
 19.05.18         *
*/
