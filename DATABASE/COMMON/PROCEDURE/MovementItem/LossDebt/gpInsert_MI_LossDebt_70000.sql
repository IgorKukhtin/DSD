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
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
            INTO vbOperDate, vbPaidKindId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
     WHERE Movement.Id = inMovementId;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_LossDebt (ioId                   := COALESCE (tmp.MI_Id,0) :: Integer
                                                 , inMovementId           := inMovementId
                                                 , inJuridicalId          := tmp.JuridicalId
                                                 , inPartnerId            := tmp.PartnerId
                                                 , inBranchId             := tmp.BranchId
                                                 , inContainerId          := tmp.ContainerId
                                                 , inAmount               := CASE WHEN COALESCE (tmp.CurrencyId,0) = 0 OR tmp.CurrencyId = zc_Enum_Currency_Basis() THEN -1 * tmp.Amount ELSE 0 END :: TFloat
                                                 , inSumm                 := 0
                                                 , inCurrencyPartnerValue := 0--tmp.CurrencyValue
                                                 , inParPartnerValue      := 0--tmp.ParValue
                                                 , inAmountCurrency       := CASE WHEN COALESCE (tmp.CurrencyId,0) = 0 OR tmp.CurrencyId = zc_Enum_Currency_Basis() THEN 0 ELSE -1 * tmp.Amount END :: TFloat
                                                 , inIsCalculated         := FALSE
                                                 , inContractId           := tmp.ContractId
                                                 , inPaidKindId           := tmp.PaidKindId
                                                 , inInfoMoneyId          := tmp.InfoMoneyId
                                                 , inUnitId               := NULL
                                                 , inCurrencyId           := tmp.CurrencyId
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
                            WHERE Container.DescId = zc_Container_Summ()
                            )

         , tmpContainerCurrency AS (SELECT tmp.ContainerId
                                         , tmp.ParentId
                                         , SUM (tmp.Amount)   AS Amount
                                    FROM (SELECT Container.Id AS ContainerId
                                               , Container.ParentId
                                               , Container.Amount - SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                                          FROM Container
                                               LEFT JOIN MovementItemContainer AS MIContainer
                                                                               ON MIContainer.ContainerId = Container.Id
                                                                              AND MIContainer.OperDate >= vbOperDate
                                          WHERE Container.DescId = zc_Container_SummCurrency()
                                              AND Container.ParentId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                                          GROUP BY Container.Id
                                                 , Container.Amount
                                                 , Container.ParentId
                                          HAVING (Container.Amount - SUM (COALESCE (MIContainer.Amount,0))) <> 0
                                         ) AS tmp
                                    GROUP BY tmp.ContainerId
                                           , tmp.ParentId
                                    HAVING SUM (tmp.Amount) <> 0
                                    )

         , tmpMI AS (SELECT MovementItem.Id
                          , MovementItem.ObjectId                    AS JuridicalId
                          , MIFloat_ContainerId.ValueData :: Integer AS ContainerId
                     FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId 
                                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE)
         
           SELECT COALESCE (Container_Currency.ContainerId, tmp.ContainerId) AS ContainerId
                , CLO_Juridical.ObjectId AS JuridicalId
                , CLO_Partner.ObjectId   AS PartnerId
                , CLO_PaidKind.ObjectId  AS PaidKindId
                , CLO_Contract.ObjectId  AS ContractId
                , CLO_Branch.ObjectId    AS BranchId
                , CLO_Currency.ObjectId  AS CurrencyId
                , tmp.InfoMoneyId
                , COALESCE (tmpMI.Id,0)  AS MI_Id
               -- , tmpCurr.Amount         AS CurrencyValue
               -- , tmpCurr.ParValue       AS ParValue
                , SUM (COALESCE (Container_Currency.Amount, tmp.Amount))  AS Amount
           FROM (SELECT tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                      , tmpContainer.ContainerId
                      , tmpContainer.InfoMoneyId
                 FROM tmpContainer
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                      AND MIContainer.OperDate >= vbOperDate
                 GROUP BY tmpContainer.Amount
                        , tmpContainer.ContainerId
                        , tmpContainer.InfoMoneyId
                 HAVING tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount,0)) <> 0
                ) AS tmp
                INNER JOIN ContainerLinkObject AS CLO_Juridical
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
                LEFT JOIN ContainerLinkObject AS CLO_Currency
                                              ON CLO_Currency.ContainerId = tmp.ContainerId
                                             AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()

                LEFT JOIN tmpContainerCurrency AS Container_Currency
                                               ON Container_Currency.ParentId = tmp.ContainerId

                LEFT JOIN tmpMI ON tmpMI.JuridicalId = CLO_Juridical.ObjectId
                               AND tmpMI.ContainerId = tmp.ContainerId

                /*LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate
                                                           , inCurrencyFromId:= zc_Enum_Currency_Basis()
                                                           , inCurrencyToId:= CLO_Currency.ObjectId
                                                           , inPaidKindId:= CLO_PaidKind.ObjectId
                                                            ) AS tmpCurr ON 1=1
                                                            */

           WHERE CLO_PaidKind.ObjectId = vbPaidKindId OR vbPaidKindId = 0
           GROUP BY COALESCE (Container_Currency.ContainerId, tmp.ContainerId)
                  , CLO_Juridical.ObjectId
                  , CLO_Partner.ObjectId
                  , CLO_PaidKind.ObjectId
                  , CLO_Contract.ObjectId
                  , CLO_Branch.ObjectId
                  , CLO_Currency.ObjectId
                  , tmp.InfoMoneyId
                  , COALESCE (tmpMI.Id,0)
               -- , tmpCurr.Amount
               -- , tmpCurr.ParValue
           HAVING SUM (tmp.Amount) <> 0
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
