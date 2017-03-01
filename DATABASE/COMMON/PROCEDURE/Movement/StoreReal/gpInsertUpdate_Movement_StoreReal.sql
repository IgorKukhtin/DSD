-- Function: gpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StoreReal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceListId         Integer   , -- Прайс лист
    IN inPartnerId           Integer   , -- Контрагент
   OUT outPriceWithVAT       Boolean   , -- Цена с НДС (да/нет)
   OUT outVATPercent         TFloat    , -- % НДС
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

      IF COALESCE (inPriceListId, 0) = 0
      THEN
           RAISE EXCEPTION 'Ошибка. Не задан идентификатор прайс-листа.';
      ELSE
           SELECT COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
                , ObjectFloat_VATPercent.ValueData                       AS VATPercent
           INTO outPriceWithVAT
              , outVATPercent
           FROM Object AS Object_PriceList
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                        ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                       AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
                LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                      ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                     AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
           WHERE Object_PriceList.Id = inPriceListId;
      END IF;


      -- Сохранение
      ioId:= lpInsertUpdate_Movement_StoreReal (ioId           := ioId
                                              , inInvNumber    := inInvNumber
                                              , inOperDate     := inOperDate
                                              , inUserId       := vbUserId
                                              , inPriceListId  := inPriceListId
                                              , inPartnerId    := inPartnerId
                                              , inPriceWithVAT := outPriceWithVAT
                                              , inVATPercent   := outVATPercent
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_StoreReal (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inPriceListId:= zc_PriceList_Basis(), inPartnerId:= 0, inSession:= '5')
