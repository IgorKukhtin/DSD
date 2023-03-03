-- Function: gpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangePercent (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ChangePercent(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перевод долга (расход)>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inChecked             Boolean   , -- Проверен
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inContractId          Integer   , -- Договор 
    IN inPaidKindId          Integer   , -- Виды форм оплаты 
    IN inPartnerId           Integer   , -- Контрагент
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangePercent());

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_ChangePercent (ioId    := ioId
                                                  , inInvNumber        := inInvNumber
                                                  , inInvNumberPartner := inInvNumberPartner
                                                  , inOperDate         := inOperDate
                                                  , inChecked          := inChecked
                                                  , inPriceWithVAT     := inPriceWithVAT
                                                  , inVATPercent       := inVATPercent
                                                  , inChangePercent    := inChangePercent
                                                  , inFromId           := inFromId
                                                  , inToId             := inToId
                                                  , inPaidKindId       := inPaidKindId
                                                  , inContractId       := inContractId
                                                  , inPartnerId        := inPartnerId
                                                  , inUserId           := vbUserId
                                                   ) AS tmp;

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/

-- тест
--