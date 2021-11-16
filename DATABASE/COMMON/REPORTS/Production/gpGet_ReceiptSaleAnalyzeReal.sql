-- Function: gpGet_ReceiptSaleAnalyzeReal()

DROP FUNCTION IF EXISTS gpGet_ReceiptSaleAnalyzeReal (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ReceiptSaleAnalyzeReal(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE(JuridicalId integer, JuridicalName TVarChar, isExclude Boolean)
AS
$BODY$
BEGIN

     RETURN QUERY
      SELECT Object.Id        AS JuridicalId
           , Object.ValueData AS JuridicalName
           , TRUE ::Boolean   AS isExclude
      FROM Object 
      WHERE Object.Id = 15512;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_User_JuridicalBasis (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.11.21         *
*/

-- ����
-- SELECT * FROM gpGet_ReceiptSaleAnalyzeReal (inSession := '2')
