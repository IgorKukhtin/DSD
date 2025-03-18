-- Function: lpInsertUpdate_Movement_EDIComdoc_Order()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_EDIComdoc_Order (Integer, Integer, TVarChar);
 DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_EDIComdoc_Order (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_EDIComdoc_Order(
    IN inMovementId      Integer   , --
    IN inUserId          Integer   , -- пользователь
    IN inOperDate_StartBegin_0  TDateTime   , -- 
   OUT outMessageText    Text      ,
    IN inSession         TVarChar    -- сессия пользователя
)                              
RETURNS Text
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsFind_InvNumberPartner Boolean;

   DECLARE vbMovementId_Order Integer;
   DECLARE vbInvNumber        TVarChar;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbOperDatePartner  TDateTime;
   DECLARE vbOperDate_pl      TDateTime;
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

   DECLARE vbIsFindPartnerContract Boolean;
   DECLARE vbGoodsPropertyId  Integer;
   DECLARE vbOKPO             TVarChar;
   DECLARE vbGLNCodeJuridical TVarChar;
   DECLARE vbGLNCodeJuridical1 TVarChar;
   DECLARE vbGLNCodeJuridical2 TVarChar;
   DECLARE vbGLNCodeJuridical3 TVarChar;

   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     -- Определяются параметры (отдельно)
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- Определяются параметры (отдельно)
     vbContractId:= (SELECT MovementLinkObject_Contract.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_Contract
                     WHERE MovementLinkObject_Contract.MovementId = inMovementId
                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                    );
     -- Определяются параметры (отдельно)
     vbIsFindPartnerContract:= EXISTS (SELECT 1
                                       FROM ObjectLink AS ObjectLink_ContractPartner_Contract
                                            INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                                  ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                                 AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                                                 AND ObjectLink_ContractPartner_Contract.ChildObjectId > 0
                                            INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Contract.ObjectId
                                                                                       AND Object_ContractPartner.isErased = FALSE
                                       WHERE ObjectLink_ContractPartner_Contract.ChildObjectId = vbContractId
                                         AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                      );

     -- Определяются параметры
     WITH tmpObject_ContractCondition_PercentView AS (SELECT * FROM Object_ContractCondition_PercentView WHERE Object_ContractCondition_PercentView.ContractId = vbContractId AND vbOperDate BETWEEN Object_ContractCondition_PercentView.StartDate AND Object_ContractCondition_PercentView.EndDate)
     -- 
     SELECT TRIM (Movement.InvNumber)             AS InvNumber
          , Movement.OperDate                     AS OperDate
          , COALESCE (MD_OperDatePartner.ValueData
                    , Movement.OperDate + (COALESCE (ObjectFloat_Partner_PrepareDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL
                     ) AS OperDatePartner
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
          , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
          , tmpChangePercent.ChangePercent             AS ChangePercent
          , ObjectLink_Partner_Route.ChildObjectId           AS RouteId
          , ObjectLink_Partner_RouteSorting.ChildObjectId    AS RouteSortingId
          , ObjectLink_Partner_MemberTake.ChildObjectId      AS MemberTakeId
          -- , ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (vbContractId, ObjectLink_Partner_Juridical.ChildObjectId, ObjectString_Partner_GLNCode.ObjectId) AS GoodsPropertyId
          , ObjectHistory_JuridicalDetails_View.OKPO         AS OKPO
          , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                   , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                   , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                    ) AS GLNCodeJuridical
          , ObjectString_Partner_GLNCode.ValueData
          , ObjectString_Partner_GLNCodeJuridical.ValueData
          , ObjectString_Juridical_GLNCode.ValueData
            INTO vbInvNumber, vbOperDate, vbOperDatePartner, vbPartnerId, vbJuridicalId, vbUnitId, vbPaidKindId, vbChangePercent
               , vbRouteId, vbRouteSortingId, vbMemberTakeId
               , vbGoodsPropertyId, vbOKPO
               , vbGLNCodeJuridical, vbGLNCodeJuridical1, vbGLNCodeJuridical2, vbGLNCodeJuridical3
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

          LEFT JOIN MovementDate AS MD_OperDatePartner
                                 ON MD_OperDatePartner.MovementId = Movement.Id
                                AND MD_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementString AS MovementString_GLNCode
                                   ON MovementString_GLNCode.MovementId =  Movement.Id
                                  AND MovementString_GLNCode.DescId = zc_MovementString_GLNCode()
          LEFT JOIN MovementString AS MovementString_GLNPlaceCode
                                   ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                  AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
          -- (-)% Скидки (+)% Наценки                                  
          LEFT JOIN /*(SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
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
                          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                               ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
                          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                               ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()
                     WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                       AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                       AND vbOperDate BETWEEN COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart()) AND COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())
                    )*/ tmpObject_ContractCondition_PercentView AS tmpChangePercent ON tmpChangePercent.ContractId = vbContractId
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = vbContractId
                              AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                              
          LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = vbContractId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

          LEFT JOIN ObjectString AS ObjectString_Partner_GLNCode
                                 ON ObjectString_Partner_GLNCode.ValueData = MovementString_GLNPlaceCode.ValueData
                                AND ObjectString_Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
                                AND (ObjectString_Partner_GLNCode.ObjectId IN (SELECT ObjectLink_ContractPartner_Partner.ChildObjectId
                                                                              FROM ObjectLink AS ObjectLink_ContractPartner_Contract
                                                                                   INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Contract.ObjectId
                                                                                                                              AND Object_ContractPartner.isErased = FALSE
                                                                                   INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                                                                         ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                                                                        AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                                                              WHERE ObjectLink_ContractPartner_Contract.ChildObjectId = vbContractId
                                                                                AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                                                             )
                                 OR vbIsFindPartnerContract = FALSE)
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
                             AND ObjectLink_Partner_Route.DescId = CASE WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() THEN zc_ObjectLink_Partner_Route30201() ELSE zc_ObjectLink_Partner_Route() END
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

          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
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

     -- !!!для теста-временно!!!     
     IF inUserId = 5 THEN vbMovementId_Order:= 0; END IF;


     -- проверка
     IF COALESCE (vbPartnerId, 0) = 0
     THEN
         IF vbIsFindPartnerContract = TRUE
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден Контрагент со значением <GLN точки доставки> = <%> в привязке к Договору № = <%>(%) для документа EDI № <%> от <%> .'
                           , (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_GLNPlaceCode())
                           , (SELECT Object.ValueData FROM Object WHERE Object.Id = vbContractId)
                           , (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbContractId)
                           , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                           , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId));
         ELSE
             RAISE EXCEPTION 'Ошибка.Не найден Контрагент со значением <GLN точки доставки> = <%> в документе EDI № <%> от <%> .', (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_GLNPlaceCode()), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
         END IF;
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

         -- !!!для теста-временно!!!     
         IF inUserId = 5 THEN vbMovementId_Order:= 0; END IF;

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
                              -- добавил условия, т.е. этой проверки теперь нет
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                           AND MovementLinkObject_From.ObjectId = vbPartnerId
                        WHERE MovementString_InvNumberPartner.ValueData = vbInvNumber
                          AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                       )
                -- !!!для теста-временно!!!     
                AND inUserId <> 5
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
         RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> у контрагента <%> для значения GLN - покупатель (EDI) = <%>  не определено <Юридическое лицо> <%> 1.<%> 2.<%> 3.<%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId)), lfGet_Object_ValueData (vbPartnerId), (SELECT ValueData FROM MovementString WHERE MovementId = inMovementId AND DescId = zc_MovementString_GLNCode()), vbGLNCodeJuridical, vbGLNCodeJuridical1, vbGLNCodeJuridical2, vbGLNCodeJuridical3;
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
     IF COALESCE (vbOKPO, '') = '' AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено ОКПО у юридического лица <%>.', lfGet_Object_ValueData (vbJuridicalId);
     END IF;
     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     =  zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND COALESCE (MovementItem.ObjectId, 0) = 0
               )
        AND vbUnitId NOT IN (8459, 133049) -- Розподільчий комплекс + Склад реализации мясо
     THEN
         RAISE EXCEPTION 'Ошибка.Не определен Товар для%Код GLN = <%>%Товар (EDI) = <%>.%Классификатор = <%>'
                       , CHR (13)
                       , (SELECT MIS_GLNCode.ValueData
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemString AS MIS_GLNCode
                                                            ON MIS_GLNCode.MovementItemId = MovementItem.Id
                                                           AND MIS_GLNCode.DescId         = zc_MIString_GLNCode()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     =  zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                            AND COALESCE (MovementItem.ObjectId, 0) = 0
                          ORDER BY MovementItem.Id
                          LIMIT 1
                         )
                       , CHR (13)
                       , (SELECT MIS_GoodsName.ValueData
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemString AS MIS_GoodsName
                                                            ON MIS_GoodsName.MovementItemId = MovementItem.Id
                                                           AND MIS_GoodsName.DescId         = zc_MIString_GoodsName()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     =  zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                            AND COALESCE (MovementItem.ObjectId, 0) = 0
                          ORDER BY MovementItem.Id
                          LIMIT 1
                         )
                       , CHR (13)
                       , lfGet_Object_ValueData (vbGoodsPropertyId)
                        ;
     END IF;


     -- эти параметры всегда из Прайс-листа !!!на дату vbOperDate!!!
     SELECT PriceListId, PriceWithVAT, VATPercent, OperDate
            INTO vbPriceListId, vbPriceWithVAT, vbVATPercent, vbOperDate_pl
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := vbContractId
                                               , inPartnerId      := vbPartnerId
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := vbOperDate
                                               , inOperDatePartner:= NULL
                                               , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                               , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                               , inOperDatePartner_order:= vbOperDatePartner
                                                ) AS tmp;


     -- только если не нашли по значению <Номер заявки у контрагента> + набирали вручную
     IF vbIsFind_InvNumberPartner = FALSE
     THEN
         -- сохранили <Заявки сторонние>
         vbMovementId_Order:= (SELECT tmp.ioId
                               FROM lpInsertUpdate_Movement_OrderExternal (ioId              := vbMovementId_Order
                                                                         , inInvNumber       := CASE WHEN vbMovementId_Order <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Order) ELSE CAST (NEXTVAL ('movement_orderexternal_seq') AS TVarChar) END :: TVarChar
                                                                         , inInvNumberPartner:= vbInvNumber
                                                                         , inOperDate        := vbOperDate
                                                                         , inOperDatePartner := vbOperDatePartner
                                                                         , inOperDateMark    := vbOperDatePartner
                                                                         , inPriceWithVAT    := vbPriceWithVAT
                                                                         , inVATPercent      := vbVATPercent
                                                                         , ioChangePercent   := vbChangePercent
                                                                         , inFromId          := vbPartnerId
                                                                         , inToId            := vbUnitId
                                                                         , inPaidKindId      := vbPaidKindId
                                                                         , inContractId      := vbContractId
                                                                         , inRouteId         := vbRouteId
                                                                         , inRouteSortingId  := vbRouteSortingId
                                                                         , inPersonalId      := COALESCE ((SELECT ObjectLink_Partner_MemberTake.ChildObjectId
                                                                                                               FROM ObjectLink AS ObjectLink_Partner_MemberTake
                                                                                                               WHERE ObjectLink_Partner_MemberTake.ObjectId = vbPartnerId
                                                                                                                 AND ObjectLink_Partner_MemberTake.DescId
                                                            = CASE EXTRACT (DOW FROM vbOperDatePartner + (((--COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()),  0)
                                                                                                            COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0)
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
                                                                                                              ), vbMemberTakeId)
                                                                         , inPriceListId         := vbPriceListId
                                                                         , inPartnerId           := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId_Order AND DescId = zc_MovementLinkObject_Partner()), 0)
                                                                         , inisPrintComment      := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_Order AND DescId = zc_MovementBoolean_PrintComment()), FALSE) ::Boolean
                                                                         , inUserId              := inUserId
                                                                          ) AS tmp);
    
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
    
           -- таблица -  Цены из прайса
          CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
             INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
                 SELECT lfSelect.GoodsId     AS GoodsId
                      , lfSelect.GoodsKindId AS GoodsKindId
                      , lfSelect.ValuePrice  AS ValuePrice
                 FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate_pl) AS lfSelect;
    
         -- сохранили строчную часть <Заявки сторонние>
         PERFORM lpInsertUpdate_MovementItem_OrderExternal_EDI (ioId                 := tmpMI.MovementItemId
                                                              , inMovementItemId_EDI := tmpMI.MovementItemId_EDI
                                                              , inMovementId         := vbMovementId_Order
                                                              , inGoodsId            := tmpMI.GoodsId
                                                              , inAmount             := tmpMI.Amount
                                                              , inAmountSecond       := tmpMI.AmountSecond
                                                              , inGoodsKindId        := tmpMI.GoodsKindId
                                                              , inPrice              := tmpMI.Price
                                                              , inCountForPrice      := 1
                                                              , inUserId             := inUserId
                                                               )
               -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmpMI.MovementItemId_EDI, tmpMI.Price)
               -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), tmpMI.MovementItemId_EDI, 1)
         FROM (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                    , MAX (tmpMI.MovementItemId_EDI) AS MovementItemId_EDI
                    , tmpMI.GoodsId
                    , tmpMI.GoodsKindId
                    , SUM (tmpMI.Amount)         AS Amount
                    , SUM (tmpMI.AmountSecond)   AS AmountSecond
                    , MAX (tmpMI.Price)          AS Price
               FROM (SELECT 0                                                      AS MovementItemId
                          , MovementItem.Id                                        AS MovementItemId_EDI
                          , MovementItem.ObjectId                                  AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)          AS GoodsKindId
                          , MovementItem.Amount                                    AS Amount
                          , 0                                                      AS AmountSecond
                          , COALESCE (tmpPriceList_kind.ValuePrice, tmpPriceList.ValuePrice, 0) :: TFloat AS Price
                          , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                               ORDER BY MovementItem.Amount DESC)  AS Ord
                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          /*LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate_pl)
                                 AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId*/
    
                          LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = MovementItem.ObjectId
                                                AND tmpPriceList.GoodsKindId IS NULL
                          LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                                 ON tmpPriceList_kind.GoodsId = MovementItem.ObjectId
                                                AND COALESCE (tmpPriceList_kind.GoodsKindId, 0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
    
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     =  zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                    UNION ALL
                     SELECT MovementItem.Id                                     AS MovementItemId
                          , 0                                                   AS MovementItemId_EDI
                          , MovementItem.ObjectId                               AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                          , 0                                                   AS Amount
                          , COALESCE (MIFloat_AmountSecond.ValueData, 0)        AS AmountSecond
                          , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                          , 1 AS Ord
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
               WHERE tmpMI.Ord = 1
               GROUP BY tmpMI.GoodsId
                      , tmpMI.GoodsKindId
                      -- , tmpMI.Price
               ORDER BY 2, 1
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

     IF vbIsFind_InvNumberPartner = FALSE
     THEN
         -- ФИНИШ - Проводим <Заявки сторонние>
         SELECT tmp.outMessageText INTO outMessageText
         FROM gpComplete_Movement_OrderExternal (inMovementId     := vbMovementId_Order
                                               , inSession        := inSession) AS tmp;
     END IF;

     -- сохранили <ОКПО>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), inMovementId, vbOKPO);
     -- сохранили <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), inMovementId, vbPartnerId);
     -- сохранили <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementId, vbJuridicalId);
     -- сохранили <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);


     -- сохранили протокол
     PERFORM lpInsert_Movement_EDIEvents (inMovementId, 'Завершен перенос данных из EDI в документ ('
                                                     || (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal())
                                                     || ').'
                                                     || '('
                                                     || (EXTRACT (EPOCH FROM (CLOCK_TIMESTAMP() - inOperDate_StartBegin_0) :: INTERVAL) :: Integer) :: TVarChar
                                                     || ' sec)'
                                                     || '('
                                                     || (EXTRACT (EPOCH FROM (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: INTERVAL) :: Integer) :: TVarChar
                                                     || ' sec)'
                                                      , inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.21         * inisPrintComment
 11.12.19         * tmpPriceList 
 19.10.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_EDIComdoc_Order (inMovementId:= 0, inUserId:= zfCalc_UserAdmin())
