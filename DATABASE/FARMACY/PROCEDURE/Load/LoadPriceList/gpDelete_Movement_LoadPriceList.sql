
DROP FUNCTION IF EXISTS gpDelete_Movement_LoadPriceList 
          (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Movement_LoadPriceList(
    IN inPriceListId         Integer   , 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
	
  DELETE FROM LoadPriceListItem WHERE LoadPriceListId = inPriceListId;

  DELETE FROM LoadPriceList WHERE Id = inPriceListId;
   
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.02.15                        *   
*/
