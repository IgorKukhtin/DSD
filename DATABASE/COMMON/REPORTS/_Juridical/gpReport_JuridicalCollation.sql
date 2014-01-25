-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inJuridicalId      Integer,    -- Юридическое лицо  
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementSumm TFloat, Debet TFloat, Kredit TFloat, OperDate TDateTime, InvNumber TVarChar, MovementId Integer, ItemName TVarChar)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  RETURN QUERY  
  SELECT 
          Operation.MovementSumm::TFloat,
          (CASE WHEN Operation.MovementSumm > 0 THEN Operation.MovementSumm ELSE 0 END)::TFloat AS Debet,
          (CASE WHEN Operation.MovementSumm > 0 THEN 0 ELSE - Operation.MovementSumm END)::TFloat AS Kredit,
          Movement.OperDate,
          Movement.InvNumber, 
          Movement.Id AS MovementId, 
          MovementDesc.ItemName
    FROM (SELECT MIContainer.MovementId, SUM(MIContainer.Amount) AS MovementSumm
      FROM ContainerLinkObject AS CLO_Juridical 
      JOIN MovementItemContainer AS MIContainer 
        ON MIContainer.Containerid = CLO_Juridical.ContainerId
       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
     WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0 
  GROUP BY MIContainer.MovementId
    HAVING SUM(MIContainer.Amount) <> 0) AS Operation
      JOIN Movement ON Movement.Id = Operation.MovementId
      JOIN MovementDesc ON Movement.DescId = MovementDesc.Id;
                                  
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.01.14                        * 
 15.01.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
