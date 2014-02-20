-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpGetJuridicalCollation (TVarChar);

CREATE OR REPLACE FUNCTION gpGetJuridicalCollation(
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MainJuridicalId Integer, MainJuridicalName TVarChar)
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
     vbUserId := lpGetUserBySession(inSession);

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
     RETURN QUERY  
     SELECT  
          Object_Juridical.Id
        , Object_Juridical.valuedata
     FROM Object AS Object_Juridical 
          
    WHERE Object_Juridical.Id IN (SELECT to_number(lpGet_DefaultValue('zc_Object_Juridical', 1), '000000'));
                                  
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetJuridicalCollation (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.14                         *  
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
