-- Function: lpUpdate_Movement_EDIComdoc_Params()

DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_EDIComdoc_Params(
    IN inMovementId       Integer   , --
    IN inPartnerOperDate  TDateTime , -- Дата накладной у контрагента
    IN inPartnerInvNumber TVarChar  , -- Номер накладной у контрагента
    IN inOrderInvNumber   TVarChar  , -- Номер заявки контрагента
    IN inOKPO             TVarChar  , -- 
    IN inUserId           Integer     -- пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbPartnerId         Integer;
   DECLARE vbGLNPlace          TVarChar;
   DECLARE vbInvNumberSaleLink TVarChar;
   DECLARE vbOperDateSaleLink  TDateTime;

   DECLARE vbMovementId_Master Integer;
   DECLARE vbMovementId_Child  Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbJuridicalId     Integer;
   DECLARE vbPriceWithVAT    Boolean;
   DECLARE vbVATPercent      TFloat;
BEGIN
     -- !!!переписать!!!
     vbPriceWithVAT:= FALSE;
     vbVATPercent  := 20;


     IF (inOKPO <> '')
     THEN
         -- Поиск Юр лица по ОКПО
         vbJuridicalId := (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = inOKPO);

         -- Поиск классификатора товаров
         vbGoodsPropertyId := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);

     END IF;


     -- Поиск GLN точки доставки
     vbGLNPlace:= (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_GLNPlaceCode());
     -- проверка
     IF 1=0 AND COALESCE (vbGLNPlace, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <GLN точки доставки> в документе EDI № <%> от <%> .', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
     END IF;

     -- временно заливаем, для предыдущих документов
     IF COALESCE (vbGLNPlace, '') = ''
     THEN
          -- Поиск GLN точки доставки из документа продажи
          vbGLNPlace:= (SELECT ObjectString.ValueData
                        FROM MovementString AS MovementString_InvNumberOrder
                             INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                     ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                                    AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                    AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                             INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                                AND Movement.DescId = zc_Movement_Sale()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                             INNER JOIN ObjectString ON ObjectString.ObjectId = MovementLinkObject_To.ObjectId
                                                    AND ObjectString.DescId = zc_ObjectString_Partner_GLNCode()
                                                    AND ObjectString.ValueData <> ''
                        WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
                          AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                        GROUP BY ObjectString.ValueData
                       );
          -- сохранили Код GLN - место доставки
          IF vbGLNPlace <> ''
          THEN
              PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), inMovementId, vbGLNPlace);
          END IF;

     END IF;


     -- !!!так для продажи!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         -- только если существует продажа с номером заявки
         IF EXISTS (SELECT Movement.Id
                    FROM MovementString AS MovementString_InvNumberOrder
                         INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                 ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                         INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                            AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                            AND Movement.DescId = zc_Movement_Sale()
                    WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
                      AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                   )
         THEN
             -- Поиск точки доставки
             vbPartnerId:= (SELECT MIN (ObjectString.ObjectId) FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Partner_GLNCode() AND ObjectString.ValueData = vbGLNPlace);
             -- проверка
             IF COALESCE (vbPartnerId, 0) = 0 AND vbGLNPlace <> ''
             THEN
                 RAISE EXCEPTION 'Ошибка.Не найден Контрагент со значением <GLN точки доставки> = <%> в документе EDI № <%> от <%> .', vbGLNPlace, (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
             END IF;
         END IF;

         -- Поиск нужных параметров
         vbInvNumberSaleLink:= (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_InvNumberSaleLink());
         vbOperDateSaleLink:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDateSaleLink());

         -- !!!так по vbInvNumberSaleLink + inGLNPlace, т.е. по номеру нашей накладной + точка доставки!!!
         IF vbInvNumberSaleLink <> ''
         THEN
             -- Поиск документа <Продажа покупателю> и <Налоговая накладная>
             SELECT Movement.Id, Movement_DocumentMaster.Id
                    INTO vbMovementId_Master, vbMovementId_Child
             FROM Movement
                  INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                         AND MovementDate_OperDatePartner.ValueData BETWEEN (vbOperDateSaleLink - (INTERVAL '0 DAY')) AND (vbOperDateSaleLink + (INTERVAL '0 DAY'))
                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND MovementLinkObject_To.ObjectId = vbPartnerId
                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                  INNER JOIN ObjectHistory_JuridicalDetails_View AS ViewHistory_JuridicalDetails
                                                                 ON ViewHistory_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                                AND ViewHistory_JuridicalDetails.OKPO = inOKPO
                  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                 ON MovementLinkMovement_Master.MovementId = Movement.Id
                                                AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                  LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                               AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
             WHERE Movement.InvNumber = vbInvNumberSaleLink
               AND Movement.StatusId = zc_Enum_Status_Complete()
               AND Movement.DescId = zc_Movement_Sale();

             -- Проверка - должны найти
             IF 1 = 0 AND COALESCE (vbMovementId_Master, 0) = 0
             THEN
                  RAISE EXCEPTION 'Ошибка.Не найдена накладная продажи № <%> от <%> для GLN точки доставки = <%> и ОКПО = <%>, в документа EDI № <%> от <%> .', vbInvNumberSaleLink, DATE (vbOperDateSaleLink), vbGLNPlace, inOKPO, (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
             END IF;
             -- Проверка - должны найти
             IF COALESCE (vbMovementId_Child, 0) = 0 AND vbMovementId_Master <> 0
             THEN
                  RAISE EXCEPTION 'Ошибка.Не найдена Налоговая у накладной продажи № <%> от <%> для GLN точки доставки = <%> и ОКПО = <%>, в документа EDI № <%> от <%> .', vbInvNumberSaleLink, DATE (vbOperDateSaleLink), vbGLNPlace, inOKPO, (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
             END IF;

         ELSE
             -- Поиск документа <Продажа покупателю> и <Налоговая накладная>
             SELECT Movement.Id, Movement_DocumentMaster.Id
                    INTO vbMovementId_Master, vbMovementId_Child
             FROM MovementString AS MovementString_InvNumberOrder
                  INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                         AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                  INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                     AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                     AND Movement.DescId = zc_Movement_Sale()

                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND (MovementLinkObject_To.ObjectId = vbPartnerId OR COALESCE (vbPartnerId, 0) = 0)
                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                  INNER JOIN ObjectHistory_JuridicalDetails_View AS ViewHistory_JuridicalDetails
                                                                 ON ViewHistory_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                                AND ViewHistory_JuridicalDetails.OKPO = inOKPO
                  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                 ON MovementLinkMovement_Master.MovementId = Movement.Id
                                                AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                  LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                               AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
             WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
               AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder();

             -- Проверка - номер заказа должен быть только у одной накладной
             IF EXISTS (SELECT Movement.Id
                        FROM MovementString AS MovementString_InvNumberOrder
                             INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                     ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                                    AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                    AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                             INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                                AND Movement.DescId = zc_Movement_Sale()
                                                AND Movement.Id <> vbMovementId_Master
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                          AND (MovementLinkObject_To.ObjectId = vbPartnerId OR COALESCE (vbPartnerId, 0) = 0)
                        WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
                          AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder())
             THEN
                 RAISE EXCEPTION 'Ошибка.№ заявки <%> должен быть установлен только у одной накладной продажи.', inOrderInvNumber;
             END IF;

         END IF;

         -- удалили связь с Продажа покупателю> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Sale() AND MovementChildId = inMovementId;
         -- удалили связь с <Налоговая накладная> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Tax() AND MovementChildId = inMovementId;

         -- совсем заново
         IF vbMovementId_Master <> 0
         THEN
             -- сохранили связь с <Продажа покупателю> !!!только наоборот!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), vbMovementId_Master, inMovementId);
         END IF;
         -- совсем заново
         IF vbMovementId_Child <> 0
         THEN
             -- сохранили связь с <Налоговая накладная> !!!только наоборот!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Tax(), vbMovementId_Child, inMovementId);
         END IF;

         -- удалили связь с <Возврат покупателю> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_MasterEDI() AND MovementChildId = inMovementId;
         -- удалили связь с <Корректировка к налоговой накладной> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_ChildEDI() AND MovementChildId = inMovementId;

     END IF;


     -- !!!так для возврата!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_ReturnIn() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         -- Поиск документа <Возврат покупателю> и <Корректировка к налоговой накладной>
         SELECT Movement.Id, Movement_DocumentMaster.Id
                INTO vbMovementId_Master, vbMovementId_Child
         FROM MovementString AS MovementString_InvNumberPartner
              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberPartner.MovementId
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                     AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
              INNER JOIN Movement ON Movement.Id = MovementString_InvNumberPartner.MovementId
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 AND Movement.DescId = zc_Movement_ReturnIn()

              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
              INNER JOIN ObjectHistory_JuridicalDetails_View AS ViewHistory_JuridicalDetails
                                                             ON ViewHistory_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                            AND ViewHistory_JuridicalDetails.OKPO = inOKPO
              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                             ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                            AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
              LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementId
                                                           AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementString_InvNumberPartner.ValueData = inPartnerInvNumber
           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner();

         -- удалили связь с <Возврат покупателю> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_MasterEDI() AND MovementChildId = inMovementId;
         -- удалили связь с <Корректировка к налоговой накладной> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_ChildEDI() AND MovementChildId = inMovementId;

         -- совсем заново
         IF vbMovementId_Master <> 0
         THEN
             -- сохранили связь с <Возврат покупателю> !!!только наоборот!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_MasterEDI(), vbMovementId_Master, inMovementId);
         END IF;
         -- совсем заново
         IF vbMovementId_Child <> 0
         THEN
             -- сохранили связь с <Корректировка к налоговой накладной> !!!только наоборот!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ChildEDI(), vbMovementId_Child, inMovementId);
         END IF;

         -- удалили связь с <Продажа покупателю> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Sale() AND MovementChildId = inMovementId;
         -- удалили связь с <Налоговая накладная> !!!только наоборот!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Tax() AND MovementChildId = inMovementId;

     END IF;


     -- сохранили <Юр лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementId, vbJuridicalId);
     -- сохранили <классификатор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inMovementId, vbPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, vbVATPercent);

     -- Результат
     RETURN vbGoodsPropertyId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.15                                        * add vbPartnerId
 14.10.14                                        * add совсем заново
 07.08.14                                        * add !!!так для возврата!!!
 31.07.14                                        * add !!!так для продажи!!!
 20.07.14                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_EDIComdoc_Params (inMovementId:= 0, inOrderInvNumber:= '-1', inOKPO:= 1, inUserId:= 2)
