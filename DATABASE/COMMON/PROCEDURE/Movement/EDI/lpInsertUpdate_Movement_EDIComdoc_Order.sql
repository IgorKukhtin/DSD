-- Function: lpInsertUpdate_Movement_EDIComdoc_Order()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_EDIComdoc_Order (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_EDIComdoc_Order(
    IN inMovementId      Integer   , --
    IN inUserId          Integer   , -- пользователь
    IN inSession         TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbIsFind_InvNumberPartner Boolean;

   DECLARE vbMovementId_Order Integer;
   DECLARE vbInvNumber        TVarChar;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbOperDatePartner  TDateTime;
   DECLARE vbPartnerId        Integer;
   DECLARE vbJuridicalId      Integer;
   DECLARE vbUnitId           Integer;
   DECLARE vbContractId       Integer;
   DECLARE vbPaidKindId       Integer;
   DECLARE vbChangePercent    TFloat;

   DECLARE vbRouteId          Integer;
   DECLARE vbRouteSortingId   Integer;
   DECLARE vbMemberTakeId     Integer;

   DECLARE vbPriceListId      Integer;
   DECLARE vbPriceWithVAT     Boolean;
   DECLARE vbVATPercent       TFloat;

   DECLARE vbGoodsPropertyId  Integer;
   DECLARE vbOKPO             TVarChar;
BEGIN
     -- Определяются параметры
     SELECT TRIM (Movement.InvNumber)             AS InvNumber
          , Movement.OperDate                     AS OperDate
          , Movement.OperDate + (COALESCE (ObjectFloat_Partner_PrepareDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL AS OperDatePartner
          , ObjectString_Partner_GLNCode.ObjectId AS PartnerId
          , CASE WHEN MovementString_GLNCode.ValueData = zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                                                                , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                                                                , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                                                                 ) -- ObjectString_Partner_GLNCodeJuridical.ValueData
                      THEN ObjectLink_Partner_Juridical.ChildObjectId -- здесь условие что GLN код юр.лица в документе и у св-ва д.б. одинаковый
                 /*WHEN MovementString_GLNCode.ValueData = ObjectString_Juridical_GLNCode.ValueData
                      THEN ObjectString_Juridical_GLNCode.ObjectId -- здесь условие что GLN код юр.лица в документе и у св-ва д.б. одинаковый
                 ELSE ObjectString_Juridical_GLNCode.ObjectId -- так убрал ошибку*/
                 ELSE 0 -- ошибка
            END JuridicalId
          , MovementLinkObject_Unit.ObjectId           AS UnitId
          , MovementLinkObject_Contract.ObjectId       AS ContractId
          , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
          , tmpChangePercent.ChangePercent             AS ChangePercent
          , ObjectLink_Partner_Route.ChildObjectId           AS RouteId
          , ObjectLink_Partner_RouteSorting.ChildObjectId    AS RouteSortingId
          , ObjectLink_Partner_MemberTake.ChildObjectId      AS MemberTakeId
          , ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
          , ObjectHistory_JuridicalDetails_View.OKPO         AS OKPO
            INTO vbInvNumber, vbOperDate, vbOperDatePartner, vbPartnerId, vbJuridicalId, vbUnitId, vbContractId, vbPaidKindId, vbChangePercent
               , vbRouteId, vbRouteSortingId, vbMemberTakeId
               , vbGoodsPropertyId, vbOKPO
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

          LEFT JOIN MovementString AS MovementString_GLNCode
                                   ON MovementString_GLNCode.MovementId =  Movement.Id
                                  AND MovementString_GLNCode.DescId = zc_MovementString_GLNCode()
          LEFT JOIN MovementString AS MovementString_GLNPlaceCode
                                   ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                  AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()

          LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                          , ObjectFloat_Value.ValueData AS ChangePercent
                     FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                          INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                 ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                AND ObjectFloat_Value.ValueData <> 0
                          INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                       AND Object_ContractCondition.isErased = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                               ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                     WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                       AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                    ) AS tmpChangePercent ON tmpChangePercent.ContractId = MovementLinkObject_Contract.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()

          LEFT JOIN ObjectString AS ObjectString_Partner_GLNCode
                                 ON ObjectString_Partner_GLNCode.ValueData = MovementString_GLNPlaceCode.ValueData
                                AND ObjectString_Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
--          LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
--                                 ON ObjectString_Partner_GLNCodeJuridical.ValueData = MovementString_GLNPlaceCode.ValueData
--                                AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
          LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                 ON ObjectString_Partner_GLNCodeJuridical.ObjectId = ObjectString_Partner_GLNCode.ObjectId
                                AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()

          LEFT JOIN ObjectFloat AS ObjectFloat_Partner_PrepareDayCount
                                ON ObjectFloat_Partner_PrepareDayCount.ObjectId = ObjectString_Partner_GLNCode.ObjectId
                               AND ObjectFloat_Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = ObjectString_Partner_GLNCode.ObjectId
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = ObjectString_Partner_GLNCode.ObjectId
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = ObjectString_Partner_GLNCode.ObjectId
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = ObjectString_Partner_GLNCode.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                 ON ObjectString_Juridical_GLNCode.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

     WHERE Movement.Id = inMovementId
    ;

     -- Проверка
     IF 1 < (SELECT COUNT (*)
             FROM MovementLinkMovement AS MovementLinkMovement_Order
                  INNER JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                                       AND Movement_Order.StatusId <> zc_Enum_Status_Erased()
             WHERE MovementLinkMovement_Order.MovementChildId = inMovementId
               AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> для значения GLN - место доставки (EDI) = <%> не определен <Контрагент>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId)), (SELECT ValueData FROM MovementString WHERE MovementId = inMovementId AND DescId = zc_MovementString_GLNPlaceCode());
     ELSE
         -- находим отдельно !!!через связь!!!
         vbMovementId_Order:= (SELECT Movement_Order.Id
                               FROM MovementLinkMovement AS MovementLinkMovement_Order
                                    INNER JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                                                         AND Movement_Order.StatusId <> zc_Enum_Status_Erased()
                               WHERE MovementLinkMovement_Order.MovementChildId = inMovementId
                                 AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                              );
     END IF;


     -- находим, если его набирали вручную (т.е. у заявки нет связи с EDI)
     IF COALESCE (vbMovementId_Order, 0) = 0
     OR EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- Поиск документа <Заявка> по значению <Номер заявки у контрагента>
         vbMovementId_Order:= (SELECT Movement.Id
                               FROM MovementString AS MovementString_InvNumberPartner
                                    INNER JOIN Movement ON Movement.Id = MovementString_InvNumberPartner.MovementId
                                                       AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                                       AND Movement.DescId = zc_Movement_OrderExternal()
                                                       AND Movement.OperDate BETWEEN (vbOperDate - (INTERVAL '1 DAY')) AND (vbOperDate + (INTERVAL '1 DAY'))
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                 AND MovementLinkObject_From.ObjectId = vbPartnerId
                                    /*INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject_To.ObjectId = vbUnitId*/
                               WHERE MovementString_InvNumberPartner.ValueData = vbInvNumber
                                 AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                              );
         IF vbMovementId_Order <> 0 
         THEN
             -- взяли параметры у найденной заявки
             vbContractId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId_Order ANd DescId = zc_MovementLinkObject_Contract());
             vbUnitId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId_Order ANd DescId = zc_MovementLinkObject_To());
         ELSE
             -- проверка
             IF EXISTS (SELECT Movement.Id
                        FROM MovementString AS MovementString_InvNumberPartner
                             INNER JOIN Movement ON Movement.Id = MovementString_InvNumberPartner.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                                AND Movement.DescId = zc_Movement_OrderExternal()
                                                AND Movement.OperDate BETWEEN (vbOperDate - (INTERVAL '1 DAY')) AND (vbOperDate + (INTERVAL '1 DAY'))
                        WHERE MovementString_InvNumberPartner.ValueData = vbInvNumber
                          AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                       )
             THEN
                 RAISE EXCEPTION 'Ошибка.Найдена заявка № <%> с другим значением Контрагент <%>.', vbInvNumber, lfGet_Object_ValueData (vbPartnerId);
             END IF;
         END IF;
         -- 
         vbIsFind_InvNumberPartner:= COALESCE (vbMovementId_Order, 0) > 0;
     ELSE
         vbIsFind_InvNumberPartner:= FALSE;
     END IF;


     -- Проверка
     IF COALESCE (vbPartnerId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> для значения GLN - место доставки (EDI) = <%> не определен <Контрагент>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId)), (SELECT ValueData FROM MovementString WHERE MovementId = inMovementId AND DescId = zc_MovementString_GLNPlaceCode());
     END IF;
     -- Проверка
     IF COALESCE (vbJuridicalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> у контрагента <%> для значения GLN - покупатель (EDI) = <%>  не определено <Юридическое лицо>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId)), lfGet_Object_ValueData (vbPartnerId), (SELECT ValueData FROM MovementString WHERE MovementId = inMovementId AND DescId = zc_MovementString_GLNCode());
     END IF;
     -- Проверка
     IF COALESCE (vbContractId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> не установлен <Договор(EDI)>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
     END IF;
     -- Проверка
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> не установлено <Подразделение(EDI)>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
     END IF;
     -- Проверка
     IF COALESCE (vbOKPO, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено ОКПО у юридического лица <%>.', lfGet_Object_ValueData (vbJuridicalId);
     END IF;


     -- эти параметры всегда из Прайс-листа !!!на дату vbOperDatePartner!!!
     SELECT PriceListId, PriceWithVAT, VATPercent
            INTO vbPriceListId, vbPriceWithVAT, vbVATPercent
     FROM lfGet_Object_Partner_PriceList (inPartnerId:= vbPartnerId, inOperDate:= vbOperDatePartner);


     -- только если не нашли по значению <Номер заявки у контрагента> + набирали вручную
     IF vbIsFind_InvNumberPartner = FALSE
     THEN
     -- сохранили <Заявки сторонние>
     vbMovementId_Order:= lpInsertUpdate_Movement_OrderExternal (ioId                  := vbMovementId_Order
                                                               , inInvNumber           := CASE WHEN vbMovementId_Order <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Order) ELSE CAST (NEXTVAL ('movement_orderexternal_seq') AS TVarChar) END :: TVarChar
                                                               , inInvNumberPartner    := vbInvNumber
                                                               , inOperDate            := vbOperDate
                                                               , inOperDatePartner     := vbOperDatePartner
                                                               , inOperDateMark        := vbOperDatePartner
                                                               , inPriceWithVAT        := vbPriceWithVAT
                                                               , inVATPercent          := vbVATPercent
                                                               , inChangePercent       := vbChangePercent
                                                               , inFromId              := vbPartnerId
                                                               , inToId                := vbUnitId
                                                               , inPaidKindId          := vbPaidKindId
                                                               , inContractId          := vbContractId
                                                               , inRouteId             := vbRouteId
                                                               , inRouteSortingId      := vbRouteSortingId
                                                               , inPersonalId          := vbMemberTakeId
                                                               , inPriceListId         := vbPriceListId
                                                               , inUserId              := inUserId
                                                                );

     -- "обнулили" кол-во <Элемент документа>
     /*PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, 0, MovementItem.ParentId)
     FROM MovementItem
          INNER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                      AND MIFloat_AmountSecond.ValueData <> 0
     WHERE MovementItem.MovementId = vbMovementId_Order
       AND MovementItem.DescId =  zc_MI_Master()
       AND MovementItem.isErased = FALSE;*/

     -- "удалили" кол-во <Элемент документа>
     PERFORM lpSetErased_MovementItem (MovementItem.Id, inUserId)
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                      ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                     AND MIFloat_AmountSecond.ValueData <> 0
     WHERE MovementItem.MovementId = vbMovementId_Order
       AND MovementItem.DescId =  zc_MI_Master()
       AND MovementItem.isErased = FALSE
       -- AND MIFloat_AmountSecond.MovementItemId IS NULL
    ;

     -- сохранили строчную часть <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementItem_OrderExternal (ioId                 := tmpMI.MovementItemId
                                                      , inMovementId         := vbMovementId_Order
                                                      , inGoodsId            := tmpMI.GoodsId
                                                      , inAmount             := tmpMI.Amount
                                                      , inAmountSecond       := tmpMI.AmountSecond
                                                      , inGoodsKindId        := tmpMI.GoodsKindId
                                                      , inPrice              := tmpMI.Price
                                                      , ioCountForPrice      := 1
                                                      , inUserId             := inUserId
                                                       )
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmpMI.MovementItemId_EDI, tmpMI.Price)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), tmpMI.MovementItemId_EDI, 1)
     FROM (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                , MAX (tmpMI.MovementItemId_EDI) AS MovementItemId_EDI
                , tmpMI.GoodsId
                , tmpMI.GoodsKindId
                , SUM (tmpMI.Amount)         AS Amount
                , SUM (tmpMI.AmountSecond)   AS AmountSecond
                , tmpMI.Price
           FROM (SELECT 0                                                      AS MovementItemId
                      , MovementItem.Id                                        AS MovementItemId_EDI
                      , MovementItem.ObjectId                                  AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)          AS GoodsKindId
                      , MovementItem.Amount                                    AS Amount
                      , 0                                                      AS AmountSecond
                      , COALESCE (lfObjectHistory_PriceListItem.ValuePrice, 0) AS Price
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDatePartner)
                             AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId

                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId =  zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                UNION ALL
                 SELECT MovementItem.Id                                     AS MovementItemId
                      , 0                                                   AS MovementItemId_EDI
                      , MovementItem.ObjectId                               AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                      , 0                                                   AS Amount
                      , COALESCE (MIFloat_AmountSecond.ValueData, 0)        AS AmountSecond
                      , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                    ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 WHERE MovementItem.MovementId = vbMovementId_Order
                   AND MovementItem.DescId =  zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                ) AS tmpMI
           GROUP BY tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Price
          ) AS tmpMI
     ;
     ELSE
         -- сформировали связь <Расходная накладная> с EDI (если по она уже сформирована по заявке)
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), Movement.Id, inMovementId)
                 -- !!!обновили!! свойство <Номер заявки у контрагента>
               , lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), Movement.Id, vbInvNumber)
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 AND Movement.DescId =zc_Movement_Sale()
         WHERE MovementLinkMovement.MovementChildId = vbMovementId_Order
           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order();

         -- в документе эди сохранили св-ва из заявки
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, vbContractId);
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), inMovementId, vbUnitId);

     END IF; -- if vbIsFind_InvNumberPartner = FALSE


     -- сформировали связь <Заявки сторонние> с EDI
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), vbMovementId_Order, inMovementId);

     -- ФИНИШ - Проводим <Заявки сторонние>
     PERFORM gpComplete_Movement_OrderExternal (inMovementId     := vbMovementId_Order
                                              , inSession        := inSession);

     -- сохранили <ОКПО>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), inMovementId, vbOKPO);
     -- сохранили <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), inMovementId, vbPartnerId);
     -- сохранили <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementId, vbJuridicalId);
     -- сохранили <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);


     -- сохранили протокол
     PERFORM lpInsert_Movement_EDIEvents (inMovementId, 'Завершен перенос данных из EDI в документ (' || (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()) || ').', inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_EDIComdoc_Order (inMovementId:= 0, inUserId:= 2)
