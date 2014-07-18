-- Function: gpInsertUpdate_Movement_LoadPriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice               TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inPackCount           Integer   ,  
    IN inProducerName        TVarChar  , 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbLoadPriceListId Integer;
   DECLARE vbLoadPriceListItemsId Integer;
BEGIN

  SELECT Id INTO vbLoadPriceListId 
    FROM LoadPriceList
   WHERE JuridicalId = inJuridicalId AND OperDate = Current_Date;

  IF COALESCE(vbLoadPriceListId, 0) = 0 THEN
     INSERT INTO LoadPriceList (JuridicalId, OperDate)
             VALUES(inJuridicalId, Current_Date);
  END IF;

  SELECT Id INTO vbLoadPriceListItemsId 
    FROM LoadPriceListItem 
   WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode;

  IF COALESCE(vbLoadPriceListItemsId, 0) = 0 THEN
     INSERT INTO LoadPriceListItem (LoadPriceListId, GoodsCode, GoodsName, GoodsNDS, Price, ExpirationDate, PackCount, ProducerName)
             VALUES(vbLoadPriceListId, inGoodsCode, inGoodsName, inGoodsNDS, inPrice, inExpirationDate, inPackCount, inProducerName);
  ELSE
     UPDATE LoadPriceListItem SET GoodsName = inGoodsName, GoodsNDS = inGoodsNDS, Price = inPrice, 
                                  ExpirationDate = inExpirationDate, PackCount = inPackCount, ProducerName = inProducerName
      WHERE Id = vbLoadPriceListItemsId;
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.07.14                        *


*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PriceList (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
