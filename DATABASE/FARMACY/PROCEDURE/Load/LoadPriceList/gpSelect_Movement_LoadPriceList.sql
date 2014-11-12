-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Movement_LoadPriceList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LoadPriceList(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , isAllGoodsConcat Boolean, NDSinPrice Boolean, isMoved Boolean)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT
             LoadPriceList.Id
           , LoadPriceList.OperDate	 -- Дата документа
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName
           , Object_Contract.Id          AS ContractId
           , Object_Contract.ValueData   AS ContractName
           , LoadPriceList.isAllGoodsConcat           
           , LoadPriceList.NDSinPrice           
           , LoadPriceList.isMoved
       FROM LoadPriceList
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_LoadPriceList (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.07.14                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')