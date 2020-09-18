-- Function: gpInsert_MI_LossDebt_70000 ()

DROP FUNCTION IF EXISTS gpInsert_MI_LossDebt_70000 (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_MI_LossDebt_70000(
    IN inMovementId            Integer   , -- ключ Документа
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_MI_LossDebt_70000());

     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject_PaidKind.ObjectId,0) AS PaidKindId
  INTO vbOperDate, vbPaidKindId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
     WHERE Movement.Id = inMovementId;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_LossDebt (ioId                   := 0
                                                 , inMovementId           := inMovementId
                                                 , inJuridicalId          := tmp.JuridicalId
                                                 , inPartnerId            := tmp.PartnerId
                                                 , inBranchId             := tmp.BranchId
                                                 , inContainerId          := tmp.ContainerId
                                                 , inAmount               := 0
                                                 , inSumm                 := tmp.Amount
                                                 , inCurrencyPartnerValue := 0
                                                 , inParPartnerValue      := 0
                                                 , inAmountCurrency       := 0
                                                 , inIsCalculated         := TRUE
                                                 , inContractId           := tmp.ContractId
                                                 , inPaidKindId           := tmp.PaidKindId
                                                 , inInfoMoneyId          := tmp.InfoMoneyId
                                                 , inUnitId               := NULL
                                                 , inCurrencyId           := NULL
                                                 , inUserId               := vbUserId
                                                  )
     FROM (WITH 
           tmpInfoMoney AS (SELECT Object_InfoMoney_View.*
                            FROM Object_InfoMoney_View
                            WHERE Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                           )
         , tmpContainer AS (SELECT Container.Id AS ContainerId
                                 , COALESCE (Container.Amount,0) AS Amount
                                 , CLO_InfoMoney.ObjectId AS InfoMoneyId
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                ON CLO_InfoMoney.ContainerId = Container.Id
                                                               AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                               AND CLO_InfoMoney.ObjectId IN (SELECT DISTINCT tmpInfoMoney.InfoMoneyId FROM tmpInfoMoney)
                            )

           SELECT tmp.ContainerId
                , CLO_Juridical.ObjectId AS JuridicalId
                , CLO_Partner.ObjectId   AS PartnerId
                , CLO_PaidKind.ObjectId  AS PaidKindId
                , CLO_Contract.ObjectId  AS ContractId
                , CLO_Branch.ObjectId    AS BranchId
                , tmp.InfoMoneyId
                , SUM (tmp.Amount) AS Amount
           FROM (SELECT tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                      , tmpContainer.ContainerId
                      , tmpContainer.InfoMoneyId
                 FROM tmpContainer
                      INNER JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                      AND MIContainer.OperDate >= vbOperDate
                 GROUP BY tmpContainer.Amount
                        , tmpContainer.ContainerId
                        , tmpContainer.InfoMoneyId
                 HAVING tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount,0)) <> 0
                ) AS tmp
                LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                              ON CLO_Juridical.ContainerId = tmp.ContainerId
                                             AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                LEFT JOIN ContainerLinkObject AS CLO_Partner
                                              ON CLO_Partner.ContainerId = tmp.ContainerId
                                             AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                              ON CLO_PaidKind.ContainerId = tmp.ContainerId
                                             AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                LEFT JOIN ContainerLinkObject AS CLO_Contract
                                              ON CLO_Contract.ContainerId = tmp.ContainerId
                                             AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                LEFT JOIN ContainerLinkObject AS CLO_Branch
                                              ON CLO_Branch.ContainerId = tmp.ContainerId
                                             AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
           WHERE CLO_PaidKind.ObjectId = vbPaidKindId OR vbPaidKindId = 0
           GROUP BY tmp.ContainerId
                  , CLO_Juridical.ObjectId
                  , CLO_Partner.ObjectId
                  , CLO_PaidKind.ObjectId
                  , CLO_Contract.ObjectId
                  , CLO_Branch.ObjectId
                  , tmp.InfoMoneyId
           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.20         *
*/

-- тест
--
