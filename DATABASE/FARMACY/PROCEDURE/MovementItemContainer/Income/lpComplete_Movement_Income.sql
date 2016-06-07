-- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbNDS TFloat;
BEGIN

     -- !!!Проверка что б второй раз не провели накладную и проводки не задвоились!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


   -- Проводки по суммам документа
   
   INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
   SELECT Movement_Income_View.FromId
        , Movement_Income_View.TotalSumm
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_Income_View.JuridicalId
        , Movement_Income_View.OperDate
     FROM Movement_Income_View
    WHERE Movement_Income_View.Id =  inMovementId;
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Summ()
              , zc_Movement_Income()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId Остатка
                          inParentId        := NULL               , -- Главный Container
                          inObjectId := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL, -- <элемент с/с> - необычная аналитика счета 
                          inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.ObjectId) 
              , AccountId
              , - OperSumm
              , OperDate
           FROM _tmpItem;
                 
           SELECT SUM(OperSumm) INTO vbOperSumm_Partner
             FROM _tmpItem;

    -- Сумма платежа
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_SummIncomeMovementPayment()
              , zc_Movement_Income()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                          inParentId        := NULL               , -- Главный Container
                          inObjectId := lpInsertFind_Object_PartionMovement(inMovementId), -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL) -- <элемент с/с> - необычная аналитика счета) 
              , null
              , OperSumm
              , OperDate
           FROM _tmpItem;

                 
 /*    CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat
                               , MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_Diff Integer, ProfitLossId_Diff Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , AnalyzerId Integer
                               , CurrencyId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
*/
   DELETE FROM _tmpItem;
   INSERT INTO _tmpItem(MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, UnitId)   
   SELECT
          zc_Movement_Income()
        , MovementItem_Income_View.Id
        , MovementItem_Income_View.GoodsId
        , MovementItem_Income_View.Amount
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад 
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_Income_View.JuridicalId
        , Movement_Income_View.BranchDate
        , Movement_Income_View.ToId
     FROM MovementItem_Income_View, Movement_Income_View
    WHERE MovementItem_Income_View.MovementId = Movement_Income_View.Id 
      AND MovementItem_Income_View.IsErased = FALSE
      AND Movement_Income_View.Id =  inMovementId;

    -- А сюда товары
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Count()
              , zc_Movement_Income()  
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Count(), -- DescId Остатка
                          inParentId        := NULL               , -- Главный Container
                          inObjectId := ObjectId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.UnitId,
                          inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                          inObjectId_2        := lpInsertFind_Object_PartionMovementItem(_tmpItem.MovementItemId)) 
              , AccountId
              , OperSumm
              , OperDate
           FROM _tmpItem;
     --Создать переоценку
      PERFORM lpInsertUpdate_Object_Price(inGoodsId := MI.goodsid,
                                          inUnitId := M.toid,
                                          inPrice := MI.pricesale,
										  inDate := M.BranchDate,
                                          inUserId := inUserId)
      FROM Movement_Income_View AS M
        INNER JOIN MovementItem_Income_View AS MI ON MI.MovementId = M.Id
        LEFT OUTER JOIN Object_Price_View AS Object_Price
                                          ON Object_Price.UnitId = M.ToId
                                         AND Object_Price.GoodsId = MI.GoodsId 
      WHERE
        M.Id =  inMovementId
        AND
        COALESCE(MI.PriceSale,0)>0
        AND
        COALESCE(Object_Price.Fix,FALSE) = FALSE;
      -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
    
--     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer
  --                                           , AccountId Integer, AnalyzerId Integer, ObjectId_Analyzer Integer, WhereObjectId_Analyzer Integer, ContainerId_Analyzer Integer
    --                                         , Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

    -- ну и наконец-то суммы
    SELECT
        Movement.PriceWithVAT
       ,Movement.NDS
    INTO
        vbPriceWithVAT
       ,vbNDS
    FROM
        Movement_Income_View AS Movement
    WHERE
        Movement.Id = inMovementId;
        
    INSERT INTO _tmpMIContainer_insert(AnalyzerId, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, AccountId, Amount, OperDate)
         SELECT 
                0
              , zc_Container_Summ()
              , zc_Movement_Income()  
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId Остатка
                          inParentId        := _tmpMIContainer_insert.ContainerId , -- Главный Container
                          inObjectId := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Goods(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.ObjectId,
                          inDescId_2          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_2        := _tmpItem.UnitId) 
              , NULL
              , _tmpItem.AccountId
              , CASE WHEN vbPriceWithVAT 
                       THEN (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat
                ELSE (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat * (1 + vbNDS/100)
                END::NUMERIC(16, 2)     
              
              -- ,  CASE WHEN Movement_Income_View.PriceWithVAT THEN MovementItem_Income_View.AmountSumm
                       -- ELSE MovementItem_Income_View.AmountSumm * (1 + Movement_Income_View.NDS/100)
                  -- END::NUMERIC(16, 2)     
              , _tmpItem.OperDate
           FROM _tmpItem 
                JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.MovementItemId = _tmpItem.MovementItemId
                LEFT OUTER JOIN MovementItem ON MovementItem.Id = _tmpItem.MovementItemId
                LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price();
                --LEFT JOIN MovementItem_Income_View ON MovementItem_Income_View.Id = _tmpItem.MovementItemId;
                --LEFT JOIN Movement_Income_View ON Movement_Income_View.Id = MovementItem_Income_View.MovementId;

     
     SELECT SUM(Amount) INTO vbOperSumm_Partner_byItem FROM _tmpMIContainer_insert WHERE AnalyzerId = 0;
 
     IF (vbOperSumm_Partner <> vbOperSumm_Partner_byItem) THEN
        UPDATE _tmpMIContainer_insert SET 
            Amount = Amount - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
        WHERE MovementItemId IN (SELECT MAX (MovementItemId) 
                                 FROM _tmpMIContainer_insert 
                                 WHERE AnalyzerId = 0 
                                     AND Amount IN (SELECT MAX (Amount) 
                                                    FROM _tmpMIContainer_insert 
                                                    WHERE AnalyzerId = 0)
                                )
            AND AnalyzerId = 0;
      END IF;	

    
     -- !!!5.0.1. формируется свойство <zc_MIFloat_JuridicalPrice - Цена поставщика с учетом НДС (и % корректировки наценки)>  + <zc_MIFloat_PriceWithVAT - Цена поставщика с учетом НДС>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), _tmpItem.MovementItemId, COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS.ValueData, 0) / 100 END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(),    _tmpItem.MovementItemId, COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE  THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS.ValueData, 0) / 100 END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(),  _tmpItem.MovementItemId, COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE  THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS.ValueData, 0) / 100 END
                                                                                                    / CASE WHEN ObjectFloat_Juridical_Percent.ValueData > 0
                                                                                                                THEN 1 + ObjectFloat_Juridical_Percent.ValueData / 100
                                                                                                           ELSE 1
                                                                                                      END)
     FROM _tmpItem
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = inMovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                ON ObjectFloat_Juridical_Percent.ObjectId = MovementLinkObject_From.ObjectId
                               AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = _tmpItem.MovementItemId
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price() 
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = inMovementId
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                       ON MovementLinkObject_NDSKind.MovementId = inMovementId
                                      AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
          LEFT JOIN ObjectFloat AS ObjectFloat_NDS
                                ON ObjectFloat_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                               AND ObjectFloat_NDS.DescId = zc_ObjectFloat_NDSKind_NDS();

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Income()
                                , inUserId     := inUserId
                                 );
                                 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.03.16                                        * 
 11.02.14                        * 
 05.02.14                        * 
*/

/*
select tmp.*
     , case when tmp.Price_OutVAT_calc <> tmp.Price_OutVAT
                 then lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(),   tmp.MovementItemId, tmp.Price_OutVAT_calc)
            else null
       end

     , case when tmp.Price_calc <> tmp.Price
                 then lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(),   tmp.MovementItemId, tmp.Price_calc)
            else null
       end

     , case when tmp.PriceJur_calc <> tmp.PriceJur
                 then lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(),  tmp.MovementItemId, tmp.PriceJur_calc)
            else null
       end
from (
select Movement.*
, MovementItem.Id as MovementItemId
, MovementItemFloat0.ValueData as Price_original

, coalesce (MIF_PriceWithOutVAT.ValueData, 0) as Price_OutVAT
, cast (COALESCE (MovementItemFloat0.ValueData, 0) / CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END as Numeric (16, 4)) AS Price_OutVAT_calc

, cast (COALESCE (MovementItemFloat0.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END as Numeric (16, 4)) AS Price_calc
, COALESCE (MovementItemFloat2.ValueData, 0) as Price

, cast (COALESCE (MovementItemFloat0.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END
 / case when ObjectFloat_Juridical_Percent.ValueData > 0
                 then (1 + ObjectFloat_Juridical_Percent.ValueData/100)
            else 1
       end
  as Numeric (16, 4)) AS PriceJur_calc
, COALESCE (MovementItemFloat.ValueData, 0) as PriceJur

from Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                ON ObjectFloat_Juridical_Percent.ObjectId = MovementLinkObject_From.ObjectId
                               AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

     inner join MovementItem on MovementItem.MovementId = Movement.Id

     inner join MovementItemFloat as MovementItemFloat0
                                  on MovementItemFloat0.MovementItemId = MovementItem.Id
                                 and MovementItemFloat0.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = Movement.Id
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_NDS_Income
                                                    ON ObjectFloat_NDS_Income.ObjectId = MovementLinkObject_NDSKind_Income.ObjectId
                                                   AND ObjectFloat_NDS_Income.DescId = zc_ObjectFloat_NDSKind_NDS()


     left join MovementItemFloat on MovementItemFloat.MovementItemId = MovementItem.Id
                                and MovementItemFloat.DescId = zc_MIFloat_JuridicalPrice()

     left join MovementItemFloat as MovementItemFloat2
                                 on MovementItemFloat2.MovementItemId = MovementItem.Id
                                and MovementItemFloat2.DescId = zc_MIFloat_PriceWithVAT()
     left join MovementItemFloat as MIF_PriceWithOutVAT
                                 on MIF_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                and MIF_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
     
where  Movement.StatusId = zc_Enum_Status_Complete()
   and Movement.DescId = zc_Movement_Income()
   and Movement.OperDate between '01.03.2016' and '01.04.2016'
   and (coalesce (MIF_PriceWithOutVAT.ValueData, 0) 
     <> cast (COALESCE (MovementItemFloat0.ValueData, 0) / CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END as Numeric (16, 4))

or  cast (COALESCE (MovementItemFloat0.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END as Numeric (16, 4)) 
        <>  COALESCE (MovementItemFloat2.ValueData, 0) 

or  cast (COALESCE (MovementItemFloat0.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END
 / case when ObjectFloat_Juridical_Percent.ValueData > 0
                 then (1 + ObjectFloat_Juridical_Percent.ValueData/100)
            else 1
       end as Numeric (16, 4)) 
  
 <>  COALESCE (MovementItemFloat.ValueData, 0) 
)
) as tmp
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_Income (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())

