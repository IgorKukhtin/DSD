-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_Juridical_Basis (Integer);
DROP FUNCTION IF EXISTS gpGet_User_JuridicalBasis (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_JuridicalBasis(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE(JuridicalBasisId integer, JuridicalBasisName TVarChar)
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF zfCalc_User_isIrna (vbUserId) = TRUE
     THEN
         RETURN QUERY
          SELECT Object.Id        AS JuridicalBasisId
               , Object.ValueData AS JuridicalBasisName
          FROM Object 
          WHERE Object.Id = zc_Juridical_Irna();
     ELSE
         RETURN QUERY
          SELECT Object.Id        AS JuridicalBasisId
               , Object.ValueData AS JuridicalBasisName
          FROM Object 
          WHERE Object.Id = zc_Juridical_Basis();
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.10.16         *
*/

-- ����
-- SELECT * FROM gpGet_User_JuridicalBasis (inSession := '5')
