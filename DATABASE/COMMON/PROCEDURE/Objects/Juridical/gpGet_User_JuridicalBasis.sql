-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_User_JuridicalBasis (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_JuridicalBasis(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE(JuridicalBasisId integer, JuridicalBasisName TVarChar)
AS
$BODY$
BEGIN

     RETURN QUERY
      SELECT Object.Id        AS JuridicalBasisId
           , Object.ValueData AS JuridicalBasisName
      FROM Object 
      WHERE Object.Id = zc_Juridical_Basis();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_User_JuridicalBasis (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.10.16         *
*/

-- ����
-- SELECT * FROM gpGet_User_JuridicalBasis (inSession := '2')
