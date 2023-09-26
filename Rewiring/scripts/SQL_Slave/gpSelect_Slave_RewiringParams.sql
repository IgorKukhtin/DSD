-- Function: _replica.gpSelect_Slave_RewiringParams()

  DROP FUNCTION IF EXISTS _replica.gpSelect_Slave_RewiringParams (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Slave_RewiringParams (
  IN inSession   TVarChar
)
RETURNS TABLE (
  GroupId       Integer,
  isSale        Boolean,
  GroupName     TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользовател€ на вызов процедуры
   vbUserId:= inSession::Integer;

   -- –езультат
   RETURN QUERY 
     SELECT 0 AS GroupId, False AS isSale, 'ф.ƒнепр без продажа/возврат'::TVarChar AS TVarChar
     UNION ALL
     SELECT 1 AS GroupId, True AS isSale, 'филиал  иев'::TVarChar AS TVarChar
     UNION ALL
     SELECT 2 AS GroupId, True AS isSale, 'филиал ќдесса'::TVarChar AS TVarChar
     UNION ALL
     SELECT 3 AS GroupId, True AS isSale, 'остальные филиалы'::TVarChar AS TVarChar
     UNION ALL
     SELECT 4 AS GroupId, True AS isSale, 'ф.ƒнепр только продажа/возврат'::TVarChar AS TVarChar;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- SELECT * FROM _replica.gpSelect_Slave_RewiringParams (zfCalc_UserAdmin());