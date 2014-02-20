-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalBalance(
    IN inOperDate         TDateTime , -- 
    IN inJuridicalId      Integer,    -- Юридическое лицо  
   OUT StartBalance       TFloat, 
   OUT OurFirm            TVarChar,
    IN inSession          TVarChar    -- сессия пользователя
)
AS
$BODY$
  
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  SELECT SUM(Amount) INTO StartBalance
    FROM  (SELECT  Container.Amount - SUM(MIContainer.Amount) AS Amount
             FROM ContainerLinkObject AS CLO_Juridical 
                  JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                  JOIN MovementItemContainer AS MIContainer 
                    ON MIContainer.Containerid = Container.Id
                   AND MIContainer.OperDate > inOperDate
            WHERE CLO_Juridical.ObjectId = inJuridicalId 
            GROUP BY Container.Amount, Container.Id) AS Balance;
            
   OurFirm  := '"ООО" Алан';        
                                  
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalBalance (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
