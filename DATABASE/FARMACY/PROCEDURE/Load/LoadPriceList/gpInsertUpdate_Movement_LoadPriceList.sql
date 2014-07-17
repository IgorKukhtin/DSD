-- Function: gpInsertUpdate_Movement_LoadPriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice               TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbLoadPriceListId Integer;
BEGIN

  SELECT Id INTO vbLoadPriceListId 
    FROM LoadPriceList
   WHERE JuridicalId = inJuridicalId AND OperDate = Current_Date;

  IF COALESCE(vbLoadPriceListId, 0) = 0 THEN
     INSERT INTO LoadPriceList (JuridicalId, OperDate)
             VALUES(inJuridicalId, Current_Date);
  END IF;

/*CREATE TABLE LoadPriceList
(
  Id            serial    NOT NULL PRIMARY KEY,
  OperDate	TDateTime, -- Дата документа
  JuridicalId	Integer , -- Юридические лица
  isAllGoodsConcat Boolean, -- Все ли товары имеют связь

CREATE TABLE LoadPriceListItem
(
  Id              serial        NOT NULL PRIMARY KEY,
  GoodsCode       TVarChar , -- Код товара поставщика
  GoodsName	  TVarChar , -- Наименование товара поставщика
  GoodsNDS	  TVarChar, -- НДС товара
  GoodsId         Integer  , -- Товары
  LoadPriceListId Integer  , -- Ссылка на прайс-лист
  Price           TFloat   , -- Цена
  ExpirationDate  TDateTime, -- Срок годности

        INSERT INTO Sale1C (UnitId, VidDoc, InvNumber, OperDate, ClientCode, ClientName, GoodsCode,   
                            GoodsName, OperCount, OperPrice, Tax, 
                            Suma, PDV, SumaPDV, ClientINN, ClientOKPO, InvNalog)
             VALUES(inUnitId, inVidDoc, inInvNumber, inOperDate, inClientCode, inClientName, inGoodsCode,   
                    inGoodsName, inOperCount, inOperPrice, inTax, 
                    inSuma, inPDV, inSumaPDV, inClientINN, inClientOKPO, inInvNalog);
*/
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
