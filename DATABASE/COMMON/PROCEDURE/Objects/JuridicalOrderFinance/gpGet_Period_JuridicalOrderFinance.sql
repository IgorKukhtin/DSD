-- FunctiON: gpGet_Period_JuridicalOrderFinance (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Period_JuridicalOrderFinance (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Period_JuridicalOrderFinance(
    IN inSessiON           TVarChar   -- ������ ������������
)
RETURNS TABLE (StartDate TDateTime
             , EndDate TDateTime
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
         SELECT (CURRENT_DATE ::TDateTime - INTERVAL '1 MONTH') ::TDateTime AS StartDate
              , (CURRENT_DATE ::TDateTime - INTERVAL '1 DAY')   ::TDateTime AS EndDate
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.11.20         *
*/

-- ����
-- SELECT * FROM gpGet_Period_JuridicalOrderFinance (inSessiON:= '5'::TVarChar)
