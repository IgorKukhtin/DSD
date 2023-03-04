-- Function: gpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangePercent (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangePercent (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


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
    IN inDocumentTaxKindId   Integer   , 
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbToId Integer;
   DECLARE vbContractId Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangePercent());

     --выбираем прошлые данные для сравнения
     SELECT MovementLinkObject_Contract.ObjectId AS ContractId
          , MovementLinkObject_To.ObjectId       AS ToId
     INTO vbContractId, vbToId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
     WHERE Movement.Id = COALESCE (ioId,0);
     
     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_ChangePercent (ioId                := ioId
                                                 , inInvNumber         := inInvNumber
                                                 , inInvNumberPartner  := inInvNumberPartner
                                                 , inOperDate          := inOperDate
                                                 , inChecked           := inChecked
                                                 , inPriceWithVAT      := inPriceWithVAT
                                                 , inVATPercent        := inVATPercent
                                                 , inChangePercent     := inChangePercent
                                                 , inFromId            := inFromId
                                                 , inToId              := inToId
                                                 , inPaidKindId        := inPaidKindId
                                                 , inContractId        := inContractId
                                                 , inPartnerId         := inPartnerId
                                                 , inDocumentTaxKindId := inDocumentTaxKindId
                                                 , inComment           := inComment
                                                 , inUserId            := vbUserId
                                                  ) AS tmp;

     --проверка, если новый документ или изменили договор/Юр.лицо перезаписывает строки
     IF COALESCE(vbToId,0) <> inToId OR COALESCE (vbContractId,0) <> inContractId
     THEN
         --
         PERFORM lpInsertUpdate_MI_ChangePercent_byTax (ioId, vbUserId);
     END IF;

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