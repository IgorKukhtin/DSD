-- FunctiON: gpGet_Period (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Period (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Period(
    IN inSessiON           TVarChar   -- ������ ������������
)
RETURNS TABLE (StartDate TDateTime
             , EndDate TDateTime
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
         SELECT CURRENT_DATE::TDateTime          AS StartDate
              , CURRENT_DATE::TDateTime          AS EndDate
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.16         *
*/

-- ����
-- SELECT * FROM gpGet_Period (inSessiON:= '5'::TVarChar)
