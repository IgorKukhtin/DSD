-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_User_JuridicalBasis (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_JuridicalBasis(
    IN inSession       TVarChar    -- сессия пользователя
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.10.16         *
*/

-- тест
-- SELECT * FROM gpGet_User_JuridicalBasis (inSession := '2')
