-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Movement_MovementLoad (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MovementLoad(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, InvNumber TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , UnitId Integer, UnitName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , isAllGoodsConcat Boolean, isNDSinPrice Boolean)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT
             LoadMovement.Id
           , LoadMovement.OperDate	 -- Дата документа
           , LoadMovement.InvNumber	 -- Номер документа
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName
           , Object_Contract.Id          AS ContractId
           , Object_Contract.ValueData   AS ContractName
           , Object_Unit.Id              AS UnitId
           , Object_Unit.ValueData       AS UnitName
           , LoadMovement.TotalCount           
           , LoadMovement.TotalSumm
           , LoadMovement.isAllGoodsConcat           
           , LoadMovement.isNDSinPrice           
           , Object_NdsKind.Id          AS NdsKindId
           , Object_NdsKind.ValueData   AS NdsKindName
       FROM LoadMovement
            LEFT JOIN Object AS Object_NdsKind ON Object_NdsKind.Id = LoadMovement.NDSKindId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = LoadMovement.UnitId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadMovement.JuridicalId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadMovement.ContractId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_MovementLoad (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.11.14                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')