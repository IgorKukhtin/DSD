-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPaymentByDocument(
    IN inOperDate         TDateTime , -- 
    IN inContractDate     TDateTime , -- 
    IN inJuridicalId      INTEGER   ,
    IN inPeriodCount      Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, InvNumber TVarChar)
AS
$BODY$
   DECLARE vbLenght Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Выбираем остаток на дату по юр. лицам в разрезе договоров. 
     -- Так же выбираем продажи и возвраты за период 
  vbLenght := 7;

  RETURN QUERY  
        SELECT 
              Movement.OperDate,
              Movement.InvNumber
         FROM Movement 
        WHERE Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) 
          AND Movement.OperDate BETWEEN (inContractDate -  vbLenght * (inPeriodCount - 1)) 
          AND (inContractDate -  vbLenght * inPeriodCount);
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPayment ('01.01.2014'::TDateTime, '01.02.2013'::TDateTime, 0, inSession:= '2'::TVarChar); 
