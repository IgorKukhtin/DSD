-- Function: gpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StoreReal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
 INOUT ioPriceListId         Integer   , -- Прайс лист
    IN inPartnerId           Integer   , -- Контрагент
   OUT outPriceWithVAT       Boolean   , -- Цена с НДС (да/нет)
   OUT outVATPercent         TFloat    , -- % НДС
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

  -- 2. эти параметры всегда из Прайс-листа
  IF COALESCE (ioPriceListId, 0) = 0
     OR 1=1 -- !!!всегда расчет!!!
  THEN
      -- !!!замена!!!
      SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
             INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
      FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                , inPartnerId      := inFromId
                                                , inMovementDescId := zc_Movement_Sale() -- !!!не ошибка!!!
                                                , inOperDate_order := inOperDate
                                                , inOperDatePartner:= NULL
                                                , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                                , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                                 ) AS tmp;
      -- !!!замена!!!
      -- !!!на дату outOperDatePartner!!!
      -- SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
      --        INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
      -- FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inFromId, inOperDate:= outOperDatePartner) AS tmp;
  ELSE
      SELECT Object_PriceList.ValueData                             AS PriceListName
           , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
           , ObjectFloat_VATPercent.ValueData                       AS VATPercent
             INTO outPriceListName, outPriceWithVAT, outVATPercent
      FROM Object AS Object_PriceList
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                   ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                  AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
           LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                 ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
      WHERE Object_PriceList.Id = ioPriceListId;
  END IF;


  -- определение Экспедитора по дню недели или тот же самый
  ioPersonalId:= COALESCE ((SELECT ObjectLink_Partner_MemberTake.ChildObjectId
                            FROM ObjectLink AS ObjectLink_Partner_MemberTake
                            WHERE ObjectLink_Partner_MemberTake.ObjectId = inFromId
                              AND ObjectLink_Partner_MemberTake.DescId = CASE EXTRACT (DOW FROM inOperDate
                                                                                              + (((COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inFromId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()),  0)
                                                                                                 + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inFromId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0)
                                                                                                  ) :: TVarChar || ' DAY') :: INTERVAL)
                                                                                       )
                                                    WHEN 1 THEN zc_ObjectLink_Partner_MemberTake1()
                                                    WHEN 2 THEN zc_ObjectLink_Partner_MemberTake2()
                                                    WHEN 3 THEN zc_ObjectLink_Partner_MemberTake3()
                                                    WHEN 4 THEN zc_ObjectLink_Partner_MemberTake4()
                                                    WHEN 5 THEN zc_ObjectLink_Partner_MemberTake5()
                                                    WHEN 6 THEN zc_ObjectLink_Partner_MemberTake6()
                                                    WHEN 0 THEN zc_ObjectLink_Partner_MemberTake7()
                                                 END
                           ), ioPersonalId);
  -- название всегда по ioPersonalId
  outPersonalName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioPersonalId);


  -- Сохранение
  ioId:= lpInsertUpdate_Movement_StoreReal (ioId                  := ioId
                                              , inInvNumber           := inInvNumber
                                              , inInvNumberPartner    := inInvNumberPartner
                                              , inOperDate            := inOperDate
                                              , inOperDatePartner     := outOperDatePartner
                                              , inOperDateMark        := inOperDateMark
                                              , inPriceWithVAT        := outPriceWithVAT
                                              , inVATPercent          := outVATPercent
                                              , inChangePercent       := inChangePercent
                                              , inFromId              := inFromId
                                              , inToId                := inToId
                                              , inPaidKindId          := inPaidKindId
                                              , inContractId          := inContractId
                                              , inRouteId             := inRouteId
                                              , inRouteSortingId      := inRouteSortingId
                                              , inPersonalId          := ioPersonalId
                                              , inPriceListId         := ioPriceListId
                                              , inPartnerId           := inPartnerId
                                              , inUserId              := vbUserId
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
-- SELECT * FROM gpInsertUpdate_Movement_StoreReal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
