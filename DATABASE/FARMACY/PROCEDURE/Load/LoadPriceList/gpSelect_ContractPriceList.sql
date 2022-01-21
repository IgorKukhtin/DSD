-- Function: gpSelect_ContractPriceList()

DROP FUNCTION IF EXISTS gpSelect_ContractPriceList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ContractPriceList(
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY 
    SELECT LoadPriceList.Id
         , LoadPriceList.ContractId
         , Object_Contract.ObjectCode
         , Object_Contract.ValueData
         , LoadPriceList.JuridicalId 
         , Object_Juridical.ObjectCode
         , Object_Juridical.ValueData
         , Object_Area.Id 
         , Object_Area.ObjectCode
         , Object_Area.ValueData
    FROM LoadPriceList
    
         JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId 
                                                  
         JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId 

         LEFT JOIN Object AS Object_Area ON Object_Area.Id = LoadPriceList.AreaId 
       
    ORDER BY Object_Contract.ValueData  
    ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.01.22                                                       *
*/


select * from gpSelect_ContractPriceList(inSession := '3');