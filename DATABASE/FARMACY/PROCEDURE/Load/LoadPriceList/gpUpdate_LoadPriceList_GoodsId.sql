-- Function: gpInsertUpdate_Movement_LoadPriceList()

DROP FUNCTION IF EXISTS gpUpdate_LoadPriceList_GoodsId (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_LoadPriceList_GoodsId(
    IN inPriceListItemId     Integer   , -- Ссылка на элемент прайса
    IN inGoodsId             Integer   , -- Ссылка на товар
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN

     UPDATE LoadPriceListItem SET GoodsId = inGoodsId
      WHERE Id = inPriceListItemId;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.07.14                        *


*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PriceList (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
