-- Function: gpGet_Movement_by_LoadPriceList()

DROP FUNCTION IF EXISTS gpGet_Movement_by_LoadPriceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_by_LoadPriceList(
   OUT outId           Integer ,   -- 
    IN inJuridicalId   Integer ,   -- 
    IN inContractId    Integer ,   -- 
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

 outId:= COALESCE ((SELECT tmp.Id
                    FROM (SELECT max(Movement.OperDate), max(Movement.Id) AS Id
                          FROM Movement 
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                      AND MovementLinkObject_Juridical.ObjectId = inJuridicalId --183353
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                      AND MovementLinkObject_Contract.ObjectId = inContractId --183421
                          WHERE Movement.DescId = zc_Movement_PriceList()
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                          LIMIT 1) AS tmp
                   ), 0);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 22.08.16         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_by_LoadPriceList (59610, 183275, '3')
