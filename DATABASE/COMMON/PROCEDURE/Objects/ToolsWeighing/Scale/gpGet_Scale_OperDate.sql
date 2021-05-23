-- Function: gpGet_Scale_OperDate (TVarChar)

-- DROP FUNCTION IF EXISTS gpSelect_Scale_OperDate (TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Scale_OperDate (TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Scale_OperDate (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_OperDate (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_OperDate(
    IN inIsCeh       Boolean       --
  , IN inBranchCode  Integer       -- 
  , IN inSession     TVarChar      -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
      SELECT CASE /*WHEN vbUserId = 5 AND inBranchCode = 1
                       THEN CASE WHEN EXTRACT ('HOUR' FROM '25.07.2018 06:38:51' :: TDateTime) >= 0 AND EXTRACT ('HOUR' FROM '25.07.2018 06:38:51' :: TDateTime) < 8
                                      THEN (DATE_TRUNC ('DAY', '25.07.2018 06:38:51' :: TDateTime) - INTERVAL '1 DAY') :: TDateTime
                                 ELSE DATE_TRUNC ('DAY', '25.07.2018 06:38:51' :: TDateTime) :: TDateTime
                            END*/
                  WHEN inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV: Scale + ScaleCeh
                       THEN CASE WHEN EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) >= 0 AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) < 4
                                      THEN (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 DAY') :: TDateTime
                                 ELSE DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) :: TDateTime
                            END
                  WHEN inBranchCode = 1   -- Dnepr: Scale + ScaleCeh
                    OR inBranchCode BETWEEN 101 AND 199 -- Dnepr: UPAK + CEH-GP: ScaleCeh
                       THEN CASE WHEN EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) >= 0 AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) < 8
                                      THEN (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 DAY') :: TDateTime
                                 ELSE DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) :: TDateTime
                            END
                       -- ALL - Branch
                  ELSE DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) :: TDateTime
             END AS OperDate;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_OperDate (Boolean, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.06.15                                        * all
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_OperDate (TRUE, 1, zfCalc_UserAdmin())
-- SELECT * FROM gpGet_Scale_OperDate (FALSE, 1, zfCalc_UserAdmin())
