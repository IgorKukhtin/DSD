-- Коэффициент для прихода от поставщика

DROP FUNCTION IF EXISTS gpGet_GlobalConst_IncomeKoeff( TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GlobalConst_IncomeKoeff(
   OUT outIncomeKoeff   TFloat, 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TFloat 
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpGetUserBySession (inSession);
     
     OutIncomeKoeff := (SELECT zc_Enum_GlobalConst_IncomeKoeff()) ::TFloat;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 28.03.18         *
*/

-- тест
-- SELECT * FROM gpGet_GlobalConst_IncomeKoeff ('2')
