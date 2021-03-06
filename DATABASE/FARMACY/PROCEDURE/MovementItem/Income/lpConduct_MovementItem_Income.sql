-- Function: lpConduct_MovementItem_Income (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lpConduct_MovementItem_Income (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpConduct_MovementItem_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementItemId    Integer  , -- строка документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbNDS TFloat;
   DECLARE vbObjectId        Integer;
   DECLARE vbJuridicalId     Integer;
   DECLARE vbToId            Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbContainerId_Partner Integer;
BEGIN

     vbUserId := lpGetUserBySession (inSession);

     -- поиск <Торговой сети>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- !!!Проверка что б второй раз не провели накладную и проводки не задвоились!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;


     IF EXISTS(SELECT ValueData FROM MovementItemBoolean WHERE DescId = zc_MIBoolean_Conduct()
                                                           AND MovementItemId = inMovementItemId
                                                           AND ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Строка документа удалена.';
     END IF;

     IF EXISTS(SELECT MovementItem.Id FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.Id = inMovementItemId
                       AND MovementItem.isErased <> FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка.Строка документа уже проведена.';
     END IF;


    -- Определить
    vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);
    -- Определить
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId = inMovementId
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_To());

     SELECT MLO_From.ObjectId  AS JuridicalId
          , MLO_To.ObjectId    AS ToId
            INTO vbJuridicalId, vbToId
     FROM MovementLinkObject AS MLO_From
          LEFT JOIN MovementLinkObject AS MLO_To
                                       ON MLO_To.MovementId = inMovementId
                                      AND MLO_To.DescId = zc_MovementLinkObject_To()
     WHERE MLO_From.MovementId = inMovementId
       AND MLO_From.DescId = zc_MovementLinkObject_From();

     -- Проверили что установлены все связи
     PERFORM lpCheckComplete_Movement_Income (inMovementId);

     -- Тут устанавливаем связь между товарами покупателей и главным товаром
     PERFORM gpInsertUpdate_Object_LinkGoods(0                                 -- ключ объекта <Условия договора>
                                           , DD.GoodsMainId
                                           , DD.PartnerGoodsId
                                           , inSession
                                             )
     FROM (WITH tmpMI AS (SELECT DISTINCT
                                 MovementItem.ObjectId       AS GoodsId
                               , MILinkObject_Goods.ObjectId AS PartnerGoodsId
                          FROM MovementItem
                               INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                 ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                                                AND MILinkObject_Goods.ObjectId       > 0
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.Id = inMovementItemId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.IsErased   = FALSE
                         )
       , tmpGoodsMain AS (SELECT DISTINCT
                                tmpMI.GoodsId
                              , tmpMI.PartnerGoodsId
                              , ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
                         FROM tmpMI
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                    ON ObjectLink_LinkGoods_Goods.ChildObjectId = tmpMI.GoodsId
                                                   AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                    ON ObjectLink_LinkGoods_GoodsMain.ObjectId  = ObjectLink_LinkGoods_Goods.ObjectId
                                                   AND ObjectLink_LinkGoods_GoodsMain.DescId    = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                    ON ObjectLink_Goods_Object.ObjectId      = tmpMI.GoodsId
                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                        )
       , tmpGoodsJuridical AS (SELECT DISTINCT
                                tmpGoodsMain.GoodsId
                              , ObjectLink_LinkGoods_GoodsMain.ObjectId  AS Id
                         FROM tmpGoodsMain
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                    ON ObjectLink_LinkGoods_GoodsMain.ChildObjectId  = tmpGoodsMain.GoodsMainId
                                                   AND ObjectLink_LinkGoods_GoodsMain.DescId         = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                    ON ObjectLink_LinkGoods_Goods.ObjectId      = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                   AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                                   AND ObjectLink_LinkGoods_Goods.ChildObjectId = tmpGoodsMain.PartnerGoodsId
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                    ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbJuridicalId
                        )
         -- резульат
         SELECT DISTINCT tmpGoodsMain.GoodsMainId -- Главный товар
                       , tmpMI.PartnerGoodsId     -- товар из группы
         FROM tmpMI
              LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpMI.GoodsId
              LEFT JOIN tmpGoodsJuridical ON tmpGoodsJuridical.GoodsId = tmpMI.GoodsId
           WHERE tmpGoodsJuridical.Id IS NULL
          ) AS DD;

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;

     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


   -- данные по "приход кол-во" - !!!дата аптеки!!!
   INSERT INTO _tmpItem (MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, UnitId, Price, ObjectIntId_analyzer)
      WITH -- только приход
           tmpMI AS (SELECT MovementItem.Id                           AS MovementItemId
                          , MovementItem.ObjectId                     AS GoodsId
                          , MIFloat_AmountManual.ValueData            AS Amount
                          , MovementLinkObject_Juridical.ObjectId     AS JuridicalId_Basis
                          , MovementDate_Branch.ValueData             AS OperDate_Branch
                          , COALESCE (MIFloat_PriceSale.ValueData, 0) AS Price
                     FROM MovementItem
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                       ON MovementLinkObject_Juridical.MovementId = MovementItem.MovementId
                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                          LEFT JOIN MovementDate AS MovementDate_Branch
                                                 ON MovementDate_Branch.MovementId = MovementItem.MovementId
                                                AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                      ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.Id = inMovementItemId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.IsErased   = FALSE
                    )
     -- поиск товаров через товары по всем сетям
   , tmpMIGoods AS (SELECT DISTINCT
                           tmpMI.GoodsId
                         , ObjectLink_Child_R.ChildObjectId AS GoodsId_all
                    FROM tmpMI
                         INNER JOIN ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId -- здесь товар"сети"
                                              AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                         INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                 AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                   AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                         -- Товары из ВСЕХ сетей
                         INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                    AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                    WHERE ObjectLink_Child_R.ChildObjectId <> 0
                   )
        -- Товары из Маркетинговых контрактов
      , tmpPromo AS (SELECT MI_Goods.Id        AS MovementItemId
                          , tmpMIGoods.GoodsId        -- здесь товар "сети"
                          , ROW_NUMBER() OVER (PARTITION BY tmpMIGoods.GoodsId ORDER BY Movement.OperDate DESC) AS Ord
                     FROM Movement
                          INNER JOIN MovementDate AS MovementDate_StartPromo
                                                  ON MovementDate_StartPromo.MovementId = Movement.Id
                                                 AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                 AND MovementDate_StartPromo.ValueData <= vbOperDate
                          INNER JOIN MovementDate AS MovementDate_EndPromo
                                                  ON MovementDate_EndPromo.MovementId = Movement.Id
                                                 AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                 AND MovementDate_EndPromo.ValueData >= vbOperDate
                          INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                             AND MI_Goods.DescId = zc_MI_Master()
                                                             AND MI_Goods.isErased = FALSE
                          INNER JOIN tmpMIGoods ON tmpMIGoods.GoodsId_all = MI_Goods.ObjectId
                     WHERE Movement.StatusId = zc_Enum_Status_Complete()
                       AND Movement.DescId = zc_Movement_Promo()
                    )

      -- результат
      SELECT zc_Movement_Income()
           , tmpMI.MovementItemId
           , tmpMI.GoodsId AS ObjectId
           , tmpMI.Amount
           , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000()         -- Запасы
                                        , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- Cклад
                                        , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                        , inInfoMoneyId            := NULL
                                        , inUserId                 := vbUserId)
           , tmpMI.JuridicalId_Basis
           , tmpMI.OperDate_Branch -- !!!дата аптеки!!!
           , vbUnitId AS UnitId
           , tmpMI.Price
           , tmpPromo.MovementItemId AS ObjectIntId_analyzer
       FROM tmpMI
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId = tmpMI.GoodsId AND tmpPromo.Ord = 1;

    -- Результат - проводки по кол-во "Остатки"
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_analyzer
                                       )
         SELECT zc_MIContainer_Count()
              , zc_Movement_Income()
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId   := zc_Container_Count(), -- DescId Остатка
                          inParentId          := NULL               , -- Главный Container
                          inObjectId          := ObjectId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId        := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId      := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.UnitId,
                          inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                          inObjectId_2        := lpInsertFind_Object_PartionMovementItem (_tmpItem.MovementItemId))
              , AccountId
              , OperSumm
              , OperDate   -- !!!дата аптеки!!!
              , ObjectId AS ObjectId_analyzer
              , vbUnitId AS WhereObjectId_analyzer
              , ObjectIntId_analyzer -- Элемент документа маркетинг
           FROM _tmpItem;


     -- Создать переоценку
     PERFORM lpInsertUpdate_Object_Price (inGoodsId := tmp.GoodsId
                                        , inUnitId  := vbUnitId
                                        , inPrice   := tmp.PriceSale
                                        , inDate    := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_Branch())
                                        , inUserId  := vbUserId)
     FROM (WITH tmpMI AS (SELECT _tmpItem.ObjectId AS GoodsId, _tmpItem.Price AS PriceSale FROM _tmpItem)
           , tmpPrice AS (SELECT tmpMI.GoodsId
                               , COALESCE (ObjectBoolean_Fix.ValueData, FALSE) AS isFix
                               , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                          FROM tmpMI
                               INNER JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ChildObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                               INNER JOIN ObjectLink AS ObjectLink_Unit
                                                     ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                    AND ObjectLink_Unit.ChildObjectId = vbUnitId
                                                    AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Fix
                                                       ON ObjectBoolean_Fix.ObjectId  = ObjectLink_Goods.ObjectId
                                                      AND ObjectBoolean_Fix.DescId    = zc_ObjectBoolean_Price_Fix()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                     ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                    AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                          WHERE tmpMI.PriceSale > 0
                         )
          -- результат
          SELECT tmpMI.GoodsId, tmpMI.PriceSale
          FROM tmpMI
               LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpMI.GoodsId
          WHERE tmpMI.PriceSale <> COALESCE (tmpPrice.Price, 0)
            AND COALESCE (tmpPrice.isFix, FALSE) = FALSE
            AND tmpMI.PriceSale > 0
         ) AS tmp;


    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


    -- ну и наконец-то суммы
    SELECT Movement.PriceWithVAT, Movement.NDS
           INTO vbPriceWithVAT, vbNDS
    FROM Movement_Income_View AS Movement
    WHERE Movement.Id = inMovementId;


    -- Результат - проводки по сумме "Остатки"
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_analyzer
                                       )
         SELECT zc_MIContainer_Summ()
              , zc_Movement_Income()
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId   := zc_Container_Summ(), -- DescId Остатка
                          inParentId          := _tmpMIContainer_insert.ContainerId , -- Главный Container
                          inObjectId          := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId        := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId      := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Goods(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.ObjectId,
                          inDescId_2          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_2        := _tmpItem.UnitId)
              , NULL AS ParentId
              , _tmpItem.AccountId
              , CASE WHEN vbPriceWithVAT = TRUE
                          THEN (((COALESCE (_tmpItem.OperSumm, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat
                     ELSE (((COALESCE (_tmpItem.OperSumm, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat * (1 + vbNDS/100)
                END :: NUMERIC(16, 2) AS Amount
              , _tmpItem.OperDate   -- !!!дата аптеки!!!

              , _tmpMIContainer_insert.ObjectId_analyzer
              , _tmpMIContainer_insert.WhereObjectId_analyzer
              , _tmpMIContainer_insert.ObjectIntId_analyzer -- Элемент документа маркетинг

           FROM _tmpItem
                JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.MovementItemId = _tmpItem.MovementItemId
                LEFT OUTER JOIN MovementItem ON MovementItem.Id = _tmpItem.MovementItemId
                LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price();



     -- !!!5.0.1. формируется свойство <zc_MIFloat_JuridicalPrice - Цена поставщика с учетом НДС (и % корректировки наценки)>  + <zc_MIFloat_PriceWithVAT - Цена поставщика с учетом НДС>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), _tmpItem.MovementItemId, COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS.ValueData, 0) / 100 END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(),    _tmpItem.MovementItemId, COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE  THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS.ValueData, 0) / 100 END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(),  _tmpItem.MovementItemId, COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE  THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS.ValueData, 0) / 100 END
                                                                                                    / CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData,0) > 0
                                                                                                                THEN 1 + ObjectFloat_Contract_Percent.ValueData / 100
                                                                                                           ELSE CASE WHEN COALESCE (ObjectFloat_Juridical_Percent.ValueData,0) > 0
                                                                                                                          THEN 1 + ObjectFloat_Juridical_Percent.ValueData / 100
                                                                                                                     ELSE 1
                                                                                                                END
                                                                                                      END)
     FROM _tmpItem
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = inMovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                ON ObjectFloat_Juridical_Percent.ObjectId = MovementLinkObject_From.ObjectId
                               AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = inMovementId
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                ON ObjectFloat_Contract_Percent.ObjectId = MovementLinkObject_Contract.ObjectId
                               AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

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


     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpMIContainer_insert GROUP BY DescId, MovementItemId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'Ошибка при формировании проводок, <%> <%>', lfGet_Object_ValueData ((SELECT ObjectId_analyzer FROM _tmpMIContainer_insert WHERE MovementItemId IN ((SELECT MovementItemId FROM _tmpMIContainer_insert GROUP BY DescId, MovementItemId HAVING COUNT(*) > 1 ORDER BY MovementItemId LIMIT 1))  ORDER BY MovementItemId LIMIT 1))
                                                                    , (SELECT MovementItemId FROM _tmpMIContainer_insert GROUP BY DescId, MovementItemId HAVING COUNT(*) > 1 ORDER BY MovementItemId LIMIT 1)
                                                                     ;
     END IF;

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус строки документа
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Conduct(), inMovementItemId, TRUE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 24.06.18         *
*/


-- тест
-- SELECT * FROM lpConduct_MovementItem_Income (inMovementId:= 103, inMovementItemId := 0, inSession:= zfCalc_UserAdmin())

