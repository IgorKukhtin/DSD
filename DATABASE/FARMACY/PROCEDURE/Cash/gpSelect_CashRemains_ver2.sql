-- Function: gpSelect_CashRemains_ver2()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_ver2(
    IN inMovementId    Integer,    -- Текущая накладная
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId_main Integer, GoodsGroupName TVarChar, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, PriceSP TFloat, PriceSaleSP TFloat, DiffSP1 TFloat, DiffSP2 TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer, NDS TFloat,
               isFirst boolean, isSecond boolean, Color_calc Integer,
               isPromo boolean,
               isSP boolean,
               MinExpirationDate TDateTime,
               Color_ExpirationDate Integer,
               ConditionsKeepName TVarChar,
               AmountIncome TFloat, PriceSaleIncome TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
-- if inSession = '3' then return; end if;

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

    -- Объявили новую сессию кассового места / обновили дату последнего обращения
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );

    --Очистили содержимое снапшета сессии
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;

    -- Данные
    WITH tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT tmpCLO.ObjectId FROM tmpCLO))
       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , GoodsRemains AS
    (SELECT Container.ObjectId
          , SUM (Container.Amount) AS Remains
          , MIN (COALESCE (tmpExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- Срок годности
     FROM tmpContainer AS Container
          -- находим партию
          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
          /*
          -- находим партию
          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                        ON ContainerLinkObject_MovementItem.Containerid =  Container.Id
                                       AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
          -- элемент прихода
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

          LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()*/
        GROUP BY Container.ObjectId
      )

  , RESERVE
    AS
    (
        SELECT
            MovementItem_Reserve.GoodsId,
            SUM (MovementItem_Reserve.Amount)::TFloat as Amount
        FROM
            gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
        WHERE
            MovementItem_Reserve.MovementId <> inMovementId
        Group By
            MovementItem_Reserve.GoodsId
    )



    --залили снапшот
    INSERT INTO CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved,MinExpirationDate)
    SELECT
        inCashSessionId                             AS CashSession
       ,GoodsRemains.ObjectId                       AS GoodsId
       ,COALESCE(Object_Price_View.Price,0)         AS Price
       ,(GoodsRemains.Remains
            - COALESCE(Reserve.Amount,0))::TFloat   AS Remains
       ,Object_Price_View.MCSValue                  AS MCSValue
       ,Reserve.Amount::TFloat                      AS Reserved
       ,GoodsRemains.MinExpirationDate              AS MinExpirationDate

    FROM
        GoodsRemains
        LEFT OUTER JOIN Object_Price_View ON GoodsRemains.ObjectId = Object_Price_View.GoodsId
                                         AND Object_Price_View.UnitId = vbUnitId
        LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId;

    RETURN QUERY
      -- Маркетинговый контракт
    WITH  GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                       )
                -- товар в пути - непроведенные приходы сегодня
                , tmpIncome AS (SELECT MI_Income.ObjectId                      AS GoodsId
                                     , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome
                                     , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale
                                FROM Movement AS Movement_Income
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = vbUnitId

                                     LEFT JOIN MovementItem AS MI_Income
                                                            ON MI_Income.MovementId = Movement_Income.Id
                                                           AND MI_Income.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                                   AND date_trunc('day', Movement_Income.OperDate) = CURRENT_DATE
                                 GROUP BY MI_Income.ObjectId
                                        , MovementLinkObject_To.ObjectId
                              )
        -- Результат
        SELECT
            Goods.Id,
            ObjectLink_Main.ChildObjectId AS GoodsId_main,
            Object_GoodsGroup.ValueData  AS GoodsGroupName,
            Goods.ValueData,
            Goods.ObjectCode,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.Price,

            CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (CashSessionSnapShot.Price - COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0)) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (CashSessionSnapShot.Price - COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0)) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                 
            END :: TFloat AS PriceSP,  -- Цена со скидкой для СП

            CASE WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения
                      
                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения + цена доплаты "округлили в меньшую"

                 ELSE COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)           -- иначе всегда цена возмещения
                    + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- плюс цена доплаты "округлили в меньшую"

            END :: TFloat AS PriceSaleSP,  -- Цена без скидки для СП
            
            -- временно для проверки1
           (CASE WHEN COALESCE (ObjectBoolean_Goods_SP.ValueData, FALSE) = FALSE THEN 0 ELSE
            COALESCE (CashSessionSnapShot.Price, 0)
          - CASE WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения
                      
                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения + цена доплаты "округлили в меньшую"

                 ELSE COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)           -- иначе всегда цена возмещения
                    + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- плюс цена доплаты "округлили в меньшую"

            END
            END) :: TFloat AS DiffSP1,
                 
            -- временно для проверки2
           (CASE WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения
                      
                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения + цена доплаты "округлили в меньшую"

                 ELSE COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)           -- иначе всегда цена возмещения
                    + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- плюс цена доплаты "округлили в меньшую"

            END
          - CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (CashSessionSnapShot.Price - COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0)) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (CashSessionSnapShot.Price - COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0)) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                 
            END
           ) :: TFloat AS DiffSP2,            

            NULLIF (CashSessionSnapShot.Reserved, 0) :: TFloat AS Reserved,
            CashSessionSnapShot.MCSValue,
            Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId,
            ObjectFloat_NDSKind_NDS.ValueData AS NDS,
            COALESCE(ObjectBoolean_First.ValueData, False)          AS isFirst,
            COALESCE(ObjectBoolean_Second.ValueData, False)         AS isSecond,
            CASE WHEN COALESCE(ObjectBoolean_Second.ValueData, False) = TRUE THEN 16440317 WHEN COALESCE(ObjectBoolean_First.ValueData, False) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc,
            CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo,
            COALESCE (ObjectBoolean_Goods_SP.ValueData, FALSE) :: Boolean  AS isSP,
            CashSessionSnapShot.MinExpirationDate,
            CASE WHEN CashSessionSnapShot.MinExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Blue() ELSE zc_Color_Black() END AS Color_ExpirationDate,                --vbAVGDateEnd
            COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName,

            COALESCE(tmpIncome.AmountIncome,0)            :: TFloat   AS AmountIncome,
            CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE(tmpIncome.SummSale,0) / COALESCE(tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome
         FROM
            CashSessionSnapShot
            JOIN OBJECT AS Goods ON Goods.Id = CashSessionSnapShot.ObjectId
            LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                       ON Link_Goods_AlternativeGroup.ObjectId = Goods.Id
                                      AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = Goods.Id
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT OUTER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = Goods.Id
                                   AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                    ON ObjectBoolean_Second.ObjectId = Goods.Id
                                   AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Goods.Id
            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = Goods.Id

            -- получается GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Goods.Id
                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            -- Соц Проект
            LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP
                                     ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId
                                    AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
            -- Розмір відшкодування за упаковку (Соц. проект) - (15)
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                  ON ObjectFloat_Goods_PriceSP.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()
            -- Сума доплати за упаковку, грн (Соц. проект) - 16)
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PaymentSP
                                  ON ObjectFloat_Goods_PaymentSP.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectFloat_Goods_PaymentSP.DescId = zc_ObjectFloat_Goods_PaymentSP()

            -- условия хранения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
            --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
        ORDER BY
            Goods.Id;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 25.01.16         *
 24.01.17         * add ConditionsKeepName
 06.09.16         *
 12.04.16         *
 02.11.15                                                                       *NDS
 10.09.15                                                                       *CashSessionSnapShot
 22.08.15                                                                       *разделение вип и отложеных
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '308120')
-- SELECT * FROM gpSelect_CashRemains_ver2(inMovementId := 0 , inCashSessionId := '{1590AD6F-681A-4B34-992A-87AEABB4D33F}' ,  inSession := '3');
