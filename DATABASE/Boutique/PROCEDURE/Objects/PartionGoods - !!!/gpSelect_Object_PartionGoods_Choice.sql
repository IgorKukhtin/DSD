-- Function: gpSelect_Object_PartionGoods (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods_Choice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods_Choice(
    IN inUnitId      Integer,       --
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSessiON     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id                   Integer
             , MovementId           Integer
             , InvNumber            TVarChar
             , InvNumberAll         TVarChar
             , PartnerName          TVarChar
             , UnitName             TVarChar
             , OperDate             TDateTime
             , GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar
             , GoodsGroupNameFull   TVarChar
             , CurrencyName         TVarChar
             , Amount               TFloat
             , Remains              TFloat
             , AmountDebt           TFloat
             , RemainsWithDebt      TFloat
             , Value_choice         TFloat
             , OperPrice            TFloat
             , OperPriceList        TFloat
             , OperPriceList_disc   TFloat
             , OperPriceListReal    TFloat
             , CurrencyValue_pl     TFloat
             , BrandName            TVarChar
             , PeriodName           TVarChar
             , PeriodYear           Integer
             , FabrikaName          TVarChar
             , GoodsGroupName       TVarChar
             , MeasureName          TVarChar
             , CompositionName      TVarChar
             , GoodsInfoName        TVarChar
             , LineFabricaName      TVarChar
             , LabelName            TVarChar
             , CompositionGroupName TVarChar
             , GoodsSizeId          Integer
             , GoodsSizeName        TVarChar
             , CurrencyName_pl      TVarChar
             , isErased             Boolean
             , isArc                Boolean
             , DiscountTax          TFloat
             , PartionId            Integer
             , SybaseId             Integer
             , Color_Calc           Integer
              )
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIsOperPrice       Boolean;
   DECLARE vbPeriodYear_start  Integer;
   DECLARE vbCurrencyValue_usd TFloat;
   DECLARE vbParValue_usd      TFloat;
   DECLARE vbCurrencyValue_eur TFloat;
   DECLARE vbParValue_eur      TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());
     vbUserId:= lpGetUserBySessiON (inSession);


     -- проверка может ли смотреть любой магазин, или только свой
     PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);


     -- Получили - показывать ЛИ цену ВХ.
     vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId);
     -- Получили - ...
   --vbPeriodYear_start:= EXTRACT (YEAR FROM CURRENT_DATE) - 5;
     vbPeriodYear_start:= 2002;


     -- Определили курс на Дату документа
     SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
            INTO vbCurrencyValue_eur, vbParValue_eur
     FROM lfSelect_Movement_Currency_byDate (inOperDate      := CURRENT_DATE
                                           , inCurrencyFromId:= zc_Currency_Basis()
                                           , inCurrencyToId  := zc_Currency_EUR()
                                            ) AS tmp;
     -- Определили курс на Дату документа
     SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
            INTO vbCurrencyValue_usd, vbParValue_usd
     FROM lfSelect_Movement_Currency_byDate (inOperDate      := CURRENT_DATE
                                           , inCurrencyFromId:= zc_Currency_Basis()
                                           , inCurrencyToId  := zc_Currency_USD()
                                            ) AS tmp;
     -- Результат
     RETURN QUERY
           WITH tmpWhere AS (SELECT lfSelect.UnitId
                             FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
                             WHERE inUnitId <> 0
                           UNION
                             SELECT Object.Id AS UnitId
                             FROM Object
                             WHERE Object.DescId = zc_Object_Unit()
                               AND COALESCE (inUnitId, 0) = 0
                            )
          , tmpContainer AS (SELECT Container.PartionId     AS PartionId
                                  , Container.ObjectId      AS GoodsId
                                  , Container.WhereObjectId AS UnitId
                                  , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN Container.Amount ELSE 0 END)  AS Amount
                                  , SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN Container.Amount ELSE 0 END)  AS AmountDebt
                             FROM Container
                                  INNER JOIN tmpWhere ON tmpWhere.UnitId = Container.WhereObjectId
                                  LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                ON CLO_Client.ContainerId = Container.Id
                                                               AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                             WHERE Container.DescId        = zc_Container_Count()
                               -- AND Container.WhereObjectId = inUnitId
                               AND (Container.Amount      <> 0 OR inIsShowAll = TRUE)
                             GROUP BY Container.PartionId
                                    , Container.ObjectId
                                    , Container.WhereObjectId
                            )
 , tmpDiscountList AS (SELECT DISTINCT tmpContainer.GoodsId FROM tmpContainer)

 , tmpDiscount AS (SELECT ObjectLink_DiscountPeriodItem_Goods.ChildObjectId         AS GoodsId
                        , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData     AS DiscountTax
                        , ObjectHistoryFloat_DiscountPeriodItem_ValueNext.ValueData AS DiscountTaxNext
                        , (COALESCE (ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData,0)
                         + COALESCE (ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData,0)) AS DiscountTax_all
                   FROM tmpDiscountList
                        INNER JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                                              ON ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = tmpDiscountList.GoodsId
                                             AND ObjectLink_DiscountPeriodItem_Goods.DescId       = zc_ObjectLink_DiscountPeriodItem_Goods()
                        INNER JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
                                              ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                             AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
                                             AND ObjectLink_DiscountPeriodItem_Unit.DescId       = zc_ObjectLink_DiscountPeriodItem_Unit()
                        INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                 ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                -- AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                                                AND ObjectHistory_DiscountPeriodItem.StartDate <= CURRENT_DATE AND ObjectHistory_DiscountPeriodItem.EndDate > CURRENT_DATE
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                     ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                    AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_ValueNext
                                                     ON ObjectHistoryFloat_DiscountPeriodItem_ValueNext.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                    AND ObjectHistoryFloat_DiscountPeriodItem_ValueNext.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_ValueNext()
                  )
   , tmpPriceList AS (SELECT ObjectLink_Unit_PriceList.ObjectId               AS UnitId
                           , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS OperPriceList
                           , COALESCE (ObjectHistoryLink_Currency.ObjectId, OL_Currency.ChildObjectId) AS CurrencyId
                      FROM ObjectLink AS ObjectLink_Unit_PriceList
                           LEFT JOIN ObjectLink AS OL_Currency
                                                ON OL_Currency.ObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                               AND OL_Currency.DescId   = zc_ObjectLink_PriceList_Currency()
                           INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                 ON ObjectLink_PriceListItem_PriceList.ChildObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                                AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                           INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()

                           LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                   ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                  AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                  AND ObjectHistory_PriceListItem.EndDate = zc_DateEnd()
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                        ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                       AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                           LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                                       ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                      AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()

                      WHERE (ObjectLink_Unit_PriceList.ObjectId = inUnitId OR inUnitId = 0)
                        AND ObjectLink_Unit_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
                     )
   -- Последняя цена из Прайс-листа - zc_PriceList_Basis
   , tmpPriceList_Basis AS (SELECT OL_PriceListItem_Goods.ChildObjectId AS GoodsId
                                 , OHF_Value.ValueData                  AS OperPriceList
                                 , COALESCE (ObjectHistoryLink_Currency.ObjectId, OL_Currency.ChildObjectId) AS CurrencyId
                            FROM ObjectLink AS OL_PriceListItem_PriceList
                                 LEFT JOIN ObjectLink AS OL_Currency ON OL_currency.ObjectId = OL_PriceListItem_PriceList.ChildObjectId
                                                     AND OL_Currency.DescId = zc_ObjectLink_PriceList_Currency()
                                                              
                                 INNER JOIN ObjectLink AS OL_PriceListItem_Goods
                                                       ON OL_PriceListItem_Goods.ObjectId = OL_PriceListItem_PriceList.ObjectId
                                                      AND OL_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()
                                 INNER JOIN ObjectHistory AS OH_PriceListItem
                                                          ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                         AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                         AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                                 LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                                              ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                                             AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()

                                 LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                                             ON ObjectHistoryLink_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                            AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                            WHERE OL_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis() -- !!!Базовай Прайс!!!
                              AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                           )

       -- Результат
       SELECT tmpContainer.PartionId              AS Id
            , Movement.Id                         AS MovementId
            , Movement.InvNumber                  AS InvNumber
            , zfCalc_PartionMovementName (0, '', Movement.InvNumber, Movement.OperDate) AS InvNumberAll
            , Object_Partner.ValueData            AS PartnerName
            , Object_Unit.ValueData               AS UnitName
            , Object_PartionGoods.OperDate        AS OperDate
            , Object_PartionGoods.GoodsId         AS GoodsId
            , Object_Goods.ObjectCode             AS GoodsCode
            , Object_Goods.ValueData              AS GoodsName
            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , CASE WHEN vbIsOperPrice = TRUE THEN Object_Currency.ValueData ELSE '' END :: TVarChar AS CurrencyName
            , Object_PartionGoods.Amount          AS Amount
            , tmpContainer.Amount       :: TFloat AS Remains
            , tmpContainer.AmountDebt   :: TFloat AS AmountDebt
            , (tmpContainer.Amount + tmpContainer.AmountDebt) :: TFloat AS RemainsWithDebt

              -- для авто-заполнения в гриде после выбора
            , 1                         :: TFloat AS Value_choice
              -- Цена вх.
            , CASE WHEN vbIsOperPrice = TRUE THEN Object_PartionGoods.OperPrice ELSE 0 END :: TFloat AS OperPrice
              -- Цена в прайсе 
            , CASE WHEN zc_Enum_GlobalConst_isTerry() = FALSE THEN COALESCE (tmpPriceList.OperPriceList, tmpPriceList_Basis.OperPriceList) ELSE Object_PartionGoods.OperPriceList END :: TFloat AS OperPriceList
              -- Цена прайса со скидкой
            , zfCalc_SummChangePercent (1, COALESCE (tmpPriceList.OperPriceList, tmpPriceList_Basis.OperPriceList), tmpDiscount.DiscountTax_all) :: TFloat AS OperPriceList_disc

              -- Цена в прайсе - ГРН
            , CASE WHEN tmpPriceList.CurrencyId = zc_Currency_EUR()
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (CASE WHEN zc_Enum_GlobalConst_isTerry() = FALSE THEN COALESCE (tmpPriceList.OperPriceList, tmpPriceList_Basis.OperPriceList) ELSE Object_PartionGoods.OperPriceList END
                                                                         , vbCurrencyValue_eur, vbParValue_eur)
                                                   )
                   WHEN tmpPriceList.CurrencyId = zc_Currency_USD()
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (CASE WHEN zc_Enum_GlobalConst_isTerry() = FALSE THEN COALESCE (tmpPriceList.OperPriceList, tmpPriceList_Basis.OperPriceList) ELSE Object_PartionGoods.OperPriceList END
                                                                         , vbCurrencyValue_usd, vbParValue_usd)
                                                   )
                   ELSE CASE WHEN zc_Enum_GlobalConst_isTerry() = FALSE THEN COALESCE (tmpPriceList.OperPriceList, tmpPriceList_Basis.OperPriceList) ELSE Object_PartionGoods.OperPriceList END
              END :: TFloat                       AS OperPriceListReal

              -- курс
            , CASE WHEN tmpPriceList.CurrencyId = zc_Currency_EUR()
                        THEN zfCalc_CurrencyFrom (1, vbCurrencyValue_eur, vbParValue_eur)
                   WHEN tmpPriceList.CurrencyId = zc_Currency_USD()
                        THEN zfCalc_CurrencyFrom (1, vbCurrencyValue_usd, vbParValue_usd)
                   ELSE 0
              END :: TFloat                       AS CurrencyValue_pl
            
            , Object_Brand.ValueData              AS BrandName
            , Object_Period.ValueData             AS PeriodName
            , Object_PartionGoods.PeriodYear      AS PeriodYear
            , Object_Fabrika.ValueData            AS FabrikaName
            , Object_GoodsGroup.ValueData         AS GoodsGroupName
            , Object_Measure.ValueData            AS MeasureName
            , Object_Composition.ValueData        AS CompositionName
            , Object_GoodsInfo.ValueData          AS GoodsInfoName
            , Object_LineFabrica.ValueData        AS LineFabricaName
            , Object_Label.ValueData              AS LabelName
            , Object_CompositionGroup.ValueData   AS CompositionGroupName
            , Object_GoodsSize.Id                 AS GoodsSizeId
            , Object_GoodsSize.ValueData          AS GoodsSizeName
            , Object_Currency_pl.ValueData        AS CurrencyName_pl
            , COALESCE (Object_PartionGoods.isErased, Object_PartionGoods_er.isErased) AS isErased
            , COALESCE (Object_PartionGoods.isArc   , Object_PartionGoods_er.isArc)    AS isArc

            , COALESCE (tmpDiscount.DiscountTax, 0)     :: TFloat AS DiscountTax
            , COALESCE (tmpDiscount.DiscountTaxNext, 0) :: TFloat AS DiscountTaxNext

            , tmpContainer.PartionId
            , Object_PartionGoods.SybaseId

            , CASE WHEN tmpContainer.Amount < 0 OR tmpContainer.AmountDebt < 0 THEN zc_Color_Red()
                   WHEN tmpContainer.AmountDebt > 0 THEN zc_Color_Blue()
                   WHEN tmpContainer.Amount     = 0 THEN zc_Color_UnEnabl()
                   ELSE zc_Color_Black()
              END :: Integer                      AS Color_Calc

       FROM tmpContainer
           LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpContainer.PartionId
                                        AND Object_PartionGoods.isErased       = FALSE
                                        -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                        AND Object_PartionGoods.GoodsId        = tmpContainer.GoodsId
           LEFT JOIN Object_PartionGoods AS Object_PartionGoods_er
                                         ON Object_PartionGoods_er.MovementItemId = tmpContainer.PartionId
                                        AND Object_PartionGoods_er.isErased       = TRUE
                                        -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                        AND Object_PartionGoods_er.GoodsId        = tmpContainer.GoodsId
                                        --
                                        AND Object_PartionGoods.MovementItemId IS NULL

           LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpContainer.GoodsId
                                 AND tmpPriceList.UnitId  = tmpContainer.UnitId
           LEFT JOIN tmpPriceList_Basis ON tmpPriceList_Basis.GoodsId = tmpContainer.GoodsId

           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (Object_PartionGoods.PartnerId, Object_PartionGoods_er.PartnerId)
           LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = COALESCE (Object_PartionGoods.UnitId   , Object_PartionGoods_er.UnitId)
           LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = COALESCE (Object_PartionGoods.GoodsId  , Object_PartionGoods_er.GoodsId)

           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                  ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                 AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN Object AS Object_Currency_pl      ON Object_Currency_pl.Id      = COALESCE (tmpPriceList.CurrencyId, zc_Currency_Basis())
           LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
           LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
           LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
           LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId
           LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
           LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
           LEFT JOIN Object AS Object_CompositiON      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
           LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
           LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
           LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
           LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
           LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId

           LEFT JOIN Movement ON Movement.Id = COALESCE (Object_PartionGoods.MovementId, Object_PartionGoods_er.MovementId)

           LEFT JOIN tmpDiscount ON tmpDiscount.GoodsId = tmpContainer.GoodsId

       WHERE tmpContainer.Amount     <> 0 
          OR tmpContainer.AmountDebt <> 0
          OR (Object_PartionGoods.PeriodYear >= vbPeriodYear_start AND inIsShowAll = TRUE)
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
19.07.21          *
24.03.18          *
23.01.18          *
29.06.17          *
21.06.17          *
09.05.17          *
25.04.17          * _Choice
15.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionGoods_Choice (inUnitId:= 1512, inIsShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
