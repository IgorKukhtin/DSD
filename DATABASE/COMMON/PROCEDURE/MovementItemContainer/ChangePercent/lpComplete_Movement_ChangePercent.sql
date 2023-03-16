-- Function: lpComplete_Movement_ChangePercent (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ChangePercent (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ChangePercent(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbOperSumm_Partner          TFloat;
  DECLARE vbOperSumm_Partner_byItem   TFloat;

  DECLARE vbMovementDescId            Integer;
  DECLARE vbOperDate                  TDateTime;
  DECLARE vbPartnerId_to              Integer;
  DECLARE vbFromId                    Integer;
  DECLARE vbToId                      Integer;
  DECLARE vbIsCorporate_To            Boolean;
  DECLARE vbInfoMoneyId_Corporate_To  Integer;
  DECLARE vbContractId_To             Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To            Integer;
  DECLARE vbPaidKindId_To             Integer;
  DECLARE vbJuridicalId_Basis_To      Integer;

  DECLARE vbPriceWithVAT              Boolean;
  DECLARE vbVATPercent                TFloat;
  DECLARE vbDiscountPercent           TFloat;

  DECLARE vbBranchId_Juridical Integer;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- для долга !!!определяется Филиал по Пользователю!!!, иначе всегда на Главном филиале
     vbBranchId_Juridical:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), zc_Branch_Basis());


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и для формирования Аналитик в проводках
     SELECT Movement.DescId
          , Movement.OperDate
          , MovementLinkObject_Partner.ObjectId            AS PartnerId_To
          , COALESCE (MovementLinkObject_From.ObjectId, 0) AS FromId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)   AS ToId
          , CASE WHEN View_Constant_isCorporate_To.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate_To.ValueData, FALSE)
            END AS isCorporate_From
          , COALESCE (ObjectLink_Juridical_InfoMoney_To.ChildObjectId, 0)       AS InfoMoneyId_Corporate_To
          , COALESCE (MovementLinkObject_Contract_To.ObjectId, 0)               AS ContractId_To
          , COALESCE (View_InfoMoney_To.InfoMoneyDestinationId, 0)              AS InfoMoneyDestinationId_To
          , COALESCE (ObjectLink_Contract_InfoMoney_To.ChildObjectId, 0)        AS InfoMoneyId_To
          , COALESCE (MovementLinkObject_PaidKind_To.ObjectId, 0)               AS PaidKindId_To
          , COALESCE (ObjectLink_Contract_JuridicalBasis_To.ChildObjectId, 0)   AS JuridicalId_Basis_To
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)             AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)                    AS VATPercent
          , MovementFloat_ChangePercent.ValueData                               AS DiscountPercent
            INTO vbMovementDescId, vbOperDate
               , vbPartnerId_To, vbFromId, vbToId, vbIsCorporate_To, vbInfoMoneyId_Corporate_To
               , vbContractId_From, vbContractId_To
               , vbInfoMoneyDestinationId_To, vbInfoMoneyId_To
               , vbPaidKindId_To
               , vbJuridicalId_Basis_To
               , vbPriceWithVAT, vbVATPercent, vbDiscountPercent
     FROM Movement

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = inMovementId
                                      AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = inMovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind_To
                                       ON MovementLinkObject_PaidKind_To.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind_To.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_To
                                       ON MovementLinkObject_Contract_To.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract_To.DescId     = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis_To ON ObjectLink_Contract_JuridicalBasis_To.ObjectId = MovementLinkObject_Contract_To.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis_To.DescId = zc_ObjectLink_Contract_JuridicalBasis()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_To
                               ON ObjectLink_Contract_InfoMoney_To.ObjectId = MovementLinkObject_Contract_To.ObjectId
                              AND ObjectLink_Contract_InfoMoney_To.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_To ON View_InfoMoney_To.InfoMoneyId = ObjectLink_Contract_InfoMoney_To.ChildObjectId
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate_To
                                  ON ObjectBoolean_isCorporate_To.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_isCorporate_To.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney_To
                               ON ObjectLink_Juridical_InfoMoney_To.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Juridical_InfoMoney_To.DescId   = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View AS View_Constant_isCorporate_To ON View_Constant_isCorporate_To.InfoMoneyId = ObjectLink_Juridical_InfoMoney_To.ChildObjectId

          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId IN (zc_Movement_ChangePercent())
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
      ;


     -- проверка
     IF vbFromId = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <От кого (юридическое лицо)>.Проведение невозможно.';
     END IF;

     -- проверка
     IF vbToId = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Кому (юридическое лицо)>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbContractId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbInfoMoneyId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлена <УП статья назначения>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbPaidKindId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbJuridicalId_Basis_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , AccountId_From, AccountId_To, ContainerId_From, ContainerId_To
                         , GoodsId, GoodsKindId
                         , OperCount, Price_original, OperSumm_Partner_noDiscount, OperSumm_Partner_Discount, OperSumm_Partner
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId)
        SELECT tmpMI.MovementItemId
             , 0 AS AccountId_From    -- сформируем позже
             , 0 AS AccountId_To      -- сформируем позже
             , 0 AS ContainerId_From  -- сформируем позже
             , 0 AS ContainerId_To    -- сформируем позже
             , tmpMI.GoodsId
             , tmpMI.GoodsKindId
             , tmpMI.OperCount
             , tmpMI.Price_original

              -- промежуточная сумма БЕЗ НДС - с округлением до 2-х знаков
            , tmpMI.OperSumm_Partner AS OperSumm_Partner_noDiscount
            
              -- промежуточная сумма СКИДКИ для суммы БЕЗ НДС - с округлением до 2-х знаков
            , tmpMI.OperSumm_Partner_Discount AS OperSumm_Partner_Discount

              -- конечная сумма СКИДКИ c НДС
            , CAST ((1 + vbVATPercent / 100) * tmpMI.OperSumm_Partner_Discount) AS NUMERIC (16, 2)) AS OperSumm_Partner
              

        FROM (SELECT tmpMI.MovementItemId
                   , tmpMI.GoodsId
                   , tmpMI.GoodsKindId
                   , tmpMI.OperCount
                   , tmpMI.Price_original

                     -- промежуточная сумма БЕЗ НДС - с округлением до 2-х знаков
                   , tmpMI.OperSumm_Partner

                     -- промежуточная - сумма СКИДКИ для суммы БЕЗ НДС - с округлением до 2-х знаков
                   , CASE CAST (tmpMI.OperSumm_Partner * vbDiscountPercent / 100 AS NUMERIC (16, 2)) AS OperSumm_Partner_Discount

                     -- Статьи назначения
                   , COALESCE (ObjectLink_Goods_InfoMoney.ObjectId, 0) AS InfoMoneyId

              FROM (SELECT MovementItem.Id                               AS MovementItemId
                         , MovementItem.ObjectId                         AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
      
                         , MovementItem.Amount                           AS OperCount
                         , COALESCE (MIFloat_Price.ValueData, 0)         AS Price_original
                         , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

                           -- промежуточная сумма БЕЗ НДС - с округлением до 2-х знаков
                         , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent > 0
                                   -- если цены с НДС, тогда находим БЕЗ НДС
                                   THEN CAST (-- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                                              CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                                         THEN MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                                         ELSE MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0)
                                              END AS NUMERIC (16, 2))
                                            / (1 + vbVATPercent/100)
                                             ) AS NUMERIC (16, 2)
             
                                ELSE -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                                     CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                                THEN MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                                ELSE MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0)
                                           END
                                          ) AS NUMERIC (16, 2)
             
                           END AS OperSumm_Partner

      
                    FROM Movement
                         JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
      
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
      
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                     ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                    AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                    WHERE Movement.Id = inMovementId
                      AND Movement.DescId IN (zc_Movement_ChangePercent())
                      AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                   ) AS tmpMI
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
             ) AS tmpMI
        ;

     -- Расчет Итоговой суммы по Контрагенту
     vbOperSumm_Partner:= (SELECT CAST ((1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                            FROM (SELECT SUM (_tmpItem.OperSumm_Partner_Discount) AS tmpOperSumm_Partner
                                  FROM _tmpItem
                                 ) AS tmp
                           );
     -- Расчет Итоговой суммы (по элементам)
     vbOperSumm_Partner_byItem:= (SELECT SUM (OperSumm_Partner) FROM _tmpItem);


     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT _tmpItem.MovementItemId FROM _tmpItem ORDER BY OperSumm_Partner DESC LIMIT 1);

     END IF;


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ChangePercent()
                                , inUserId     := inUserId
                                 );

 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 267275 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_ChangePercent (inMovementId:= 267275, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 267275 , inSession:= '2')