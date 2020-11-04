-- FunctiON: gpGet_Period_JuridicalOrderFinance (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Period_JuridicalOrderFinance (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Period_JuridicalOrderFinance(
    IN inSessiON           TVarChar   -- сессия пользователя
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.20         *
*/

-- тест
-- SELECT * FROM gpGet_Period_JuridicalOrderFinance (inSessiON:= '5'::TVarChar)
