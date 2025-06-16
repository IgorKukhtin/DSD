-- Function: gpInsertUpdate_Movement_Tax()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
 INOUT ioInvNumberPartner    TVarChar  , -- Номер налогового документа
    IN inInvNumberBranch     TVarChar  , -- Номер филиала
    IN inOperDate            TDateTime , -- Дата документа
    IN inChecked             Boolean   , -- Проверен
    IN inDocument            Boolean   , -- Есть ли подписанный документ
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС 
    IN inCorrSumm             TFloat   , -- Корректировка суммы покупателя для выравнивания округлений
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPartnerId           Integer   , -- Контрагент
    IN inContractId          Integer   , -- Договора
    IN inDocumentTaxKindId   Integer   , -- Тип формирования налогового документа
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCorrSumm TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());


     -- сохранили <Документ>
     SELECT tmp.ioId
          , tmp.ioInvNumber
          , tmp.ioInvNumberPartner
            INTO ioId, ioInvNumber, ioInvNumberPartner
     FROM lpInsertUpdate_Movement_Tax (ioId, ioInvNumber, ioInvNumberPartner, inInvNumberBranch, inOperDate
                                     , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                     , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, vbUserId
                                      ) AS tmp;

     -- создаем "виртуальный элемент"
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
       AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.isErased = FALSE) -- AND ObjectId = inDocumentTaxKindId
     THEN
         PERFORM lpInsertUpdate_MovementItem_Tax (ioId                 := 0
                                                , inMovementId         := ioId
                                                , inGoodsId            := 2117  -- inDocumentTaxKindId
                                                , inAmount             := 0
                                                , inPrice              := 0
                                                , ioCountForPrice      := 1
                                                , inGoodsKindId        := zc_GoodsKind_Basis() -- NULL
                                                , inUserId             := vbUserId
                                                 );

     END IF;

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment); 
     

     -- проверка
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
    AND COALESCE (inCorrSumm, 0) <> COALESCE ((SELECT SUM (COALESCE (MF.ValueData, 0))
                                               FROM MovementLinkMovement AS MLM
                                                    -- Док. Продажа
                                                    INNER JOIN Movement ON Movement.Id       = MLM.MovementId
                                                                       -- Не удален
                                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                    INNER JOIN MovementFloat AS MF 
                                                                             ON MF.MovementId = MLM.MovementId
                                                                            AND MF.DescId     = zc_MovementFloat_CorrSumm()
                                               WHERE MLM.MovementChildId = ioId
                                                 AND MLM.DescId          = zc_MovementLinkMovement_Master()
                                             ), 0)

     THEN
         RAISE EXCEPTION 'Ошибка.В Налоговом документе № <%> от <%>%сумма корректировки = <%>%не может отличаться от суммы корректировки = <%>%в документе Продажа.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = ioId)
                       , CHR (13)
                       , zfConvert_FloatToString (inCorrSumm)
                       , CHR (13)
                       , zfConvert_FloatToString ((SELECT SUM (COALESCE (MF.ValueData, 0))
                                                   FROM MovementLinkMovement AS MLM
                                                        -- Док Продажа
                                                        INNER JOIN Movement ON Movement.Id       = MLM.MovementId
                                                                           -- Не удален
                                                                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                        INNER JOIN MovementFloat AS MF 
                                                                                 ON MF.MovementId = MLM.MovementId
                                                                                AND MF.DescId     = zc_MovementFloat_CorrSumm()
                                                   WHERE MLM.MovementChildId = ioId
                                                     AND MLM.DescId          = zc_MovementLinkMovement_Master()
                                                 ))
                       , CHR (13)
                        ;
     END IF;


     -- какое было значение, чтоб потом проверить изменилось ли значение
     vbCorrSumm:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_CorrSumm());

     -- если надо сохранить + протокол
     IF COALESCE (vbCorrSumm,0) <> COALESCE (inCorrSumm,0)
     THEN
         -- Проверка
         IF ABS (inCorrSumm) > 10
         THEN
             RAISE EXCEPTION 'Ошибка.В Налоговом документе сумма корректировки не может быть больше 10 грн.';
         END IF;

         -- сохранили свойство <Корректировка суммы покупателя для выравнивания округлений>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CorrSumm(), ioId, inCorrSumm);
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.06.25         * CorrSumm
 10.07.14                                        * add zc_Enum_DocumentTaxKind_Prepay
 02.05.14                                        * add io...
 24.04.14                                                       * add ioInvNumberBranch
 30.03.14                                        * add ioInvNumberPartner
 16.03.14                                        * add inPartnerId
 11.02.14                                                         *  - registred
 09.02.14                                                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Tax (ioId:= 0, ioInvNumber:= '-1',ioInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inSession:= '2')
