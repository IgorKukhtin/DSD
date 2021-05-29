-- Function: lfGet_Object_Partner_PriceList_onDate_get (Integer, Integer, TDateTime)

 DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_onDate_get (Integer, Integer, Integer, TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION lfGet_Object_Partner_PriceList_onDate_get(
    IN inContractId      Integer, 
    IN inPartnerId       Integer,
    IN inMovementDescId  Integer,
    IN inOperDate_order  TDateTime,
    IN inOperDatePartner TDateTime,
    IN inIsPrior         Boolean
)
RETURNS Integer
AS
$BODY$
  DECLARE vbPriceListId Integer;
BEGIN
      SELECT PriceListId
             INTO vbPriceListId
      FROM lfGet_Object_Partner_PriceList_onDate (inContractId:= inContractId, inPartnerId:= inPartnerId, inMovementDescId:= inMovementDescId, inOperDate_order:= inOperDate_order, inOperDatePartner:= inOperDatePartner, inDayPrior_PriceReturn:= 14, inIsPrior:= inIsPrior);

      RETURN vbPriceListId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.15                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_Partner_PriceList_onDate_get (inContractId:= 347332, inPartnerId:= 348917, inMovementDescId:= zc_Movement_Sale(), inOperDate_order:= '05.05.2015', inOperDatePartner:= NULL, inIsPrior:= NULL)
