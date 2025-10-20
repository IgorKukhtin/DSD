-- Function: zfCalc_Summ_PromoSchema_m_n

DROP FUNCTION IF EXISTS zfCalc_Summ_PromoSchema_m_n (NUMERIC (16,8));

CREATE OR REPLACE FUNCTION zfCalc_Summ_PromoSchema_m_n(
    IN inValue NUMERIC (16,8)
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbSumm Integer;
BEGIN

     RETURN CAST (inValue AS NUMERIC (16,2)) :: TFloat;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.09.25                                        *
*/

-- ����
-- SELECT * FROM zfCalc_Summ_PromoSchema_m_n (123);
