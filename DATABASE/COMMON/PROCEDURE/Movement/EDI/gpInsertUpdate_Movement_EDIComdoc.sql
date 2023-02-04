-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIComdoc (TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIComdoc(
    IN inOrderInvNumber      TVarChar  , -- Номер заявки контрагента
    IN inOrderOperDate       TDateTime , -- Дата заявки контрагента
    IN inPartnerInvNumber    TVarChar  , -- Номер накладной у контрагента
    IN inPartnerOperDate     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberTax        TVarChar  , -- Номер налоговой накладной у контрагента (привязка возврата)
    IN inOperDateTax         TDateTime , -- Дата налоговой накладной у контрагента (привязка возврата)
    IN inInvNumberSaleLink   TVarChar  , -- Номер накладной продажи контрагенту (привязка возврата) + добавлен для продажи т.к. могут быть две заявки с одинаковым номером
    IN inOperDateSaleLink    TDateTime , -- Дата накладной продажи контрагенту (привязка возврата)
    IN inOKPO                TVarChar  , --
    IN inJurIdicalName       TVarChar  , --
    IN inDesc                TVarChar  , -- тип документа
    IN inGLNPlace            TVarChar  , -- Код GLN - место доставки
    IN inComDocDate          TDateTime , -- Дата заявки контрагента
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, GoodsPropertyId Integer) -- Классификатор товаров
AS
$BODY$
   DECLARE vbMovementId      Integer;
   DECLARE vbGoodsPropertyId Integer;

   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDIComdoc());
     vbUserId:= lpGetUserBySession (inSession);


     -- Меняем параметр
     inGLNPlace:= TRIM (inGLNPlace);

     -- Меняем параметр
     inDesc:= COALESCE ((SELECT MovementDesc.Code FROM MovementDesc WHERE Id = zc_Movement_Sale() AND inDesc = 'Sale')
                       , COALESCE ((SELECT MovementDesc.Code FROM MovementDesc WHERE Id = zc_Movement_ReturnIn() AND inDesc = 'Return')
                                 , (SELECT MovementDesc.Code FROM MovementDesc WHERE Id IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) AND MovementDesc.Code = inDesc))
                       );

     IF inDesc IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка в параметре.<%>', inDesc;
     END IF;

     -- Поиск документа в журнале EDI
     IF EXISTS (SELECT MovementDesc.Id FROM MovementDesc WHERE MovementDesc.Code = inDesc AND MovementDesc.Id = zc_Movement_Sale())
     THEN
         IF zfConvert_StringToBigInt (inGLNPlace)  = 0
         THEN inGLNPlace:= '';
         END IF;

         -- 1.1
         IF inGLNPlace <> '' AND inOrderInvNumber <> ''
         THEN
              -- !!!так для продажи!!! + !!!по точке доставки!!! + !!!inDesc!!!
              vbMovementId:= (SELECT Movement.Id
                              FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN (inDesc)
                                   INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                             ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                            AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                            AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.InvNumber = inOrderInvNumber
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                              ORDER BY 1
                              LIMIT 1 -- !!!временно, т.к. пока непонятно почему появился > 1, пример - 4437188100 от '28.08.2015'!!!
                             );
              IF COALESCE (vbMovementId, 0) = 0 AND inOrderInvNumber <> ''
              THEN
              -- !!!так для продажи!!! + !!!по точке доставки!!! + !!!zc_Movement_OrderExternal!!!
              vbMovementId:= (SELECT Movement.Id
                              FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN ((SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()))
                                   INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                             ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                            AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                            AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.InvNumber = inOrderInvNumber
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                             );
              END IF;

              IF vbMovementId <> 0
              THEN
                   -- !!!поменяли у документа EDI признак!!!
                   PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()));
              END IF;

         -- 1.2.
         ELSEIF inOrderInvNumber <> ''
         THEN
              IF -- vbUserId <> 5 AND
                 1 < (SELECT COUNT(*)
                      FROM Movement
                           INNER JOIN MovementString AS MovementString_OKPO
                                                     ON MovementString_OKPO.MovementId =  Movement.Id
                                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                    AND MovementString_OKPO.ValueData = inOKPO
                           INNER JOIN MovementString AS MovementString_MovementDesc
                                                     ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                    AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                    AND MovementString_MovementDesc.ValueData IN (inDesc, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()))
                      WHERE Movement.DescId = zc_Movement_EDI()
                        AND Movement.InvNumber = inOrderInvNumber
                        AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     )
              THEN
                   RAISE EXCEPTION 'Ошибка.inOKPO = <%>%inOrderInvNumber=<%>%<%>.'
                                  , inOKPO
                                  , CHR (13), inOrderInvNumber
                                  , CHR (13), inDesc
                                   ;
              END IF;
              -- !!!так для продажи!!! + !!!НЕ важна точка доставки!!!
              vbMovementId:= (SELECT Movement.Id
                              FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN (inDesc, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()))
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.InvNumber = inOrderInvNumber
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                              ORDER BY Movement.Id ASC
                              LIMIT CASE WHEN vbUserId = 5 THEN 100 ELSE 100 END
                             );

              IF vbMovementId <> 0
              THEN
                   -- !!!поменяли у документа EDI признак!!!
                   PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()));
              END IF;


         -- 1.3. inInvNumberSaleLink
         ELSEIF inInvNumberSaleLink <> ''
         THEN
              IF vbUserId = 5 
                 AND 1 < (SELECT COUNT(*)
                          FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN (inDesc, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()))

                                   LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                                                  ON MovementLinkMovement_Sale.MovementChildId = Movement.Id 
                                                                 AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
                                   LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                                                  ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id 
                                                                 AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
                                   INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id = COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId)
                                                                       AND Movement_Sale.InvNumber = inInvNumberSaleLink
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                         )
              THEN
                   RAISE EXCEPTION 'Ошибка.inOKPO = <%>%inInvNumberSaleLink = <%>%<%>.'
                                  , inOKPO
                                  , CHR (13), inInvNumberSaleLink
                                  , CHR (13), inDesc
                                   ;
              END IF;
              -- !!!так для продажи!!! + по Номеру Документа + !!!НЕ важна точка доставки!!!
              vbMovementId:= (SELECT Movement.Id
                              FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN (inDesc, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()))

                                   LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                                                  ON MovementLinkMovement_Sale.MovementChildId = Movement.Id 
                                                                 AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
                                   LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                                                  ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id 
                                                                 AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
                                   INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id = COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId)
                                                                       AND Movement_Sale.InvNumber = inInvNumberSaleLink
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                             );

              IF vbMovementId <> 0
              THEN
                   -- !!!поменяли у документа EDI признак!!!
                   PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()));
              END IF;


         END IF;
     END IF;



     IF EXISTS (SELECT MovementDesc.Id FROM MovementDesc WHERE MovementDesc.Code = inDesc AND MovementDesc.Id = zc_Movement_ReturnIn())
     THEN
         -- !!!так для возврата!!!
         vbMovementId:= (SELECT Movement.Id
                         FROM Movement
                              INNER JOIN MovementString AS MovementString_OKPO
                                                        ON MovementString_OKPO.MovementId =  Movement.Id
                                                       AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                       AND MovementString_OKPO.ValueData = inOKPO
                              INNER JOIN MovementString AS MovementString_InvNumberPartner
                                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_Desc()
                                                       AND MovementString_InvNumberPartner.ValueData = inPartnerInvNumber
                              INNER JOIN MovementString AS MovementString_MovementDesc
                                                        ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                       AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                       AND MovementString_MovementDesc.ValueData = inDesc
                         WHERE Movement.DescId = zc_Movement_EDI()
                           AND Movement.InvNumber = inOrderInvNumber
                           AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                        );
     END IF;


     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION 'test параметр.<%> inOrderInvNumber      = <%>
                                        <%> inOrderOperDate       = <%>
                                        <%> inPartnerInvNumber    = <%>
                                        <%> inPartnerOperDate     = <%>
                                        <%> inInvNumberTax        = <%>
                                        <%> inOperDateTax         = <%>
                                        <%> inInvNumberSaleLink   = <%>
                                        <%> inOperDateSaleLink    = <%>
                                        <%> inOKPO                = <%>
                                        <%> inJurIdicalName       = <%>
                                        <%> inDesc                = <%>
                                        <%> inGLNPlace            = <%>
                                        <%> inComDocDate          = <%>
                                        <%> vbMovementId          = <%>'
                                 , CHR (13), inOrderInvNumber
                                 , CHR (13), inOrderOperDate
                                 , CHR (13), inPartnerInvNumber
                                 , CHR (13), inPartnerOperDate
                                 , CHR (13), inInvNumberTax
                                 , CHR (13), inOperDateTax
                                 , CHR (13), inInvNumberSaleLink
                                 , CHR (13), inOperDateSaleLink
                                 , CHR (13), inOKPO
                                 , CHR (13), inJurIdicalName
                                 , CHR (13), inDesc
                                 , CHR (13), inGLNPlace
                                 , CHR (13), inComDocDate
                                 , CHR (13), vbMovementId
                                  ;
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementId, 0) = 0;

     IF COALESCE (vbMovementId, 0) = 0
     THEN
          -- сохранили <Документ>
          vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
          -- сохранили <ОКПО>
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, inOKPO);

     END IF;

     -- сохранили Код GLN - место доставки
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), vbMovementId, inGLNPlace);

     -- сохранили
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), vbMovementId, inPartnerOperDate);
     -- сохранили
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_COMDOC(), vbMovementId, inComDocDate);

     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), vbMovementId, inPartnerInvNumber);

     -- сохранили
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateTax(), vbMovementId, inOperDateTax);
     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberTax(), vbMovementId, inInvNumberTax);

     -- сохранили Дата накладной продажи контрагенту (привязка возврата)
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSaleLink(), vbMovementId, inOperDateSaleLink);
     -- сохранили  Номер накладной продажи контрагенту (привязка возврата)
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSaleLink(), vbMovementId, TRIM (inInvNumberSaleLink));

     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_JurIdicalName(), vbMovementId, inJurIdicalName);
     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, inDesc);

     -- сохранили расчетные параметры
     vbGoodsPropertyId:= lpUpdate_Movement_EDIComdoc_Params (inMovementId       := vbMovementId
                                                           , inPartnerOperDate  := inPartnerOperDate
                                                           , inPartnerInvNumber := inPartnerInvNumber
                                                           , inOrderInvNumber   := inOrderInvNumber
                                                           , inOKPO             := inOKPO
                                                           , inIsCheck          := FALSE
                                                           , inUserId           := vbUserId);

     -- обнулили <Кол-во у покуп.>, т.к. будем кол-ва суммировать
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId     = zc_MI_Master()
          ;



     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

     -- сохранили протокол
     PERFORM lpInsert_Movement_EDIEvents (vbMovementId, 'Загрузка COMDOC из EDI', vbUserId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, vbIsInsert);

     -- Результат
     RETURN QUERY
     SELECT vbMovementId, vbGoodsPropertyId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.15                         *
 02.04.15                                        * add inGLNPlace
 07.08.14                                        * add calc inDesc
 07.08.14                                        * add inPartnerInvNumber := inPartnerInvNumber
 20.07.14                                        * ALL
 29.05.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= zfCalc_UserAdmin())
