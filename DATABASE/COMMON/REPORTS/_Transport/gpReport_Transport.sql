-- Function: gpReport_Transport()

DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Transport(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inCarId         Integer,    -- машина
     
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE ( OperDate TDateTime
             , RouteId Integer, RouteCode Integer, RouteName TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar

             , StartOdometre TFloat, EndOdometre TFloat, Amount TFloat, StartFuel TFloat, ReFuel TFloat, TotalFuel TFloat 
             , AmountCold TFloat, AmountColdFact TFloat, AmountRate TFloat, EndFuel TFloat
             
             , InvNumberPersonalSendCash TVarChar
             , SummCashIn TFloat, SummCashOut TFloat, SummCashDiff TFloat
             , invNumberIncome TVarChar
             , PriceFuel TFloat, FreightWeight TFloat
             )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());

     -- таблица - 
RETURN QUERY 
       SELECT cast ('01.01.2013' as TDateTime) 
            , cast (1 as integer) as  RouteId, cast (1 as integer) as RouteCode, cast ('Маршрут' as TVarChar) as RouteName
            , cast (1 as integer) as PersonalDriverId, cast (1 as integer) as PersonalDriverCode, cast('Водитель 111' as TVarChar) as PersonalDriverName
            , cast (120 as Tfloat), cast (150 as Tfloat), cast (140 as Tfloat), cast (130 as Tfloat)
            , cast (400 as Tfloat), cast (500 as Tfloat), cast (450 as Tfloat), cast (480 as Tfloat) 
            , cast (450 as Tfloat), cast (480 as Tfloat) 
            , cast ('InvNumberPersonalSendCash' as TVarChar) asInvNumberPersonalSendCash
            , cast (120 as Tfloat), cast (120 as Tfloat), cast (120 as Tfloat)
            , cast ('invNumberIncome' as TVarChar)
            , cast (120 as Tfloat), cast (120 as Tfloat)
  ;   

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Transport (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.13         *
*/

-- тест
--SELECT * FROM gpReport_Transport (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inCarId:= null, inSession:= '2'); 