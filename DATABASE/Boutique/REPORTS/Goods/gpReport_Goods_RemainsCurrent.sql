-- Function:  gpReport_Goods_RemainsCurrent()

DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_RemainsCurrent(
    IN inUnitId           Integer  ,  -- Подразделение / группа
    IN inBrandId          Integer  ,  -- Торговая марка
    IN inPartnerId        Integer  ,  -- Поставщик
    IN inPeriodId         Integer  ,  -- Сезон
    IN inStartYear        Integer  ,  -- Год с ...
    IN inEndYear          Integer  ,  -- Год по ...
    IN inUserId           Integer  ,  -- Id пользователя сессии GoodsPrint
    IN inGoodsPrintId     Integer  ,  -- № п/п сессии GoodsPrint
    IN inIsPartion        Boolean  ,  -- показать <Документ партия №> (Да/Нет)
    IN inIsPartner        Boolean  ,  -- показать Поставщика (Да/Нет)
    IN inIsSize           Boolean  ,  -- показать Размеры детально (Да/Нет)
    IN inIsYear           Boolean  ,  -- ограничение Год ТМ (Да/Нет) (выбор партий)
    IN inIsRemains        Boolean  ,  -- Показать с остатком = 0
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (PartionId            Integer
             , MovementId_Partion   Integer
             , InvNumber_Partion    TVarChar
             , InvNumberAll_Partion TVarChar
             , OperDate_Partion     TDateTime
             , DescName_Partion     TVarChar
             , UnitId               Integer
             , UnitName             TVarChar
             , UnitName_in          TVarChar
             , PartnerName          TVarChar
             , BrandName            TVarChar
             , FabrikaName          TVarChar
             , PeriodName           TVarChar
             , PeriodYear           Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsNameFull TVarChar
             , GoodsGroupNameFull TVarChar, NameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar
             , JuridicalName        TVarChar
             , CompositionGroupName TVarChar
             , CompositionName      TVarChar
             , GoodsInfoName        TVarChar
             , LineFabricaName      TVarChar
             , LabelName            TVarChar
             , GoodsSizeId          Integer
             , GoodsSizeName        TVarChar
             , GoodsSizeName_real   TVarChar
             , CurrencyName         TVarChar

             , CurrencyValue           TFloat -- Курс    !!!НА!!! CURRENT_DATE
             , ParValue                TFloat -- Номинал !!!НА!!! CURRENT_DATE
             , CurrencyValue_doc       TFloat -- Курс    !!!ДОКУМЕНТА
             , ParValue_doc            TFloat -- Номинал !!!ДОКУМЕНТА

             , Amount_in               TFloat -- Итого кол-во Приход от поставщика
             , OperPrice               TFloat -- Цена вх. в валюте
             , CountForPrice           TFloat -- Кол. в цене вх. в валюте
             , OperPrice_grn           TFloat -- *Цена вх. в ГРН по курсу на тек дату
             , OperPrice_grn_doc       TFloat -- *Цена вх. в ГРН по курсу документа

             , OperPriceList_orig      TFloat -- Цена по прайсу
             , OperPriceList           TFloat -- Цена по прайсу в ГРН по курсу на тек дату
             , OperPriceList_doc       TFloat -- Цена по прайсу в ГРН по курсу документа  
             , OperPriceList_curr      TFloat -- *Цена по прайсу в валюте по курсу на тек дату
             , OperPriceList_curr_doc  TFloat -- *Цена по прайсу в валюте по курсу документа  
             , PriceJur                TFloat -- Цена вх. без ск. в валюте (информативно)
             , OperPriceList_first     TFloat -- первая цена по прайсу (информативно)
             
             , OperPriceList_disc           TFloat -- Цена по прайсу в ГРН по курсу на тек дату c учетом Сезонной скидки
             , OperPriceList_doc_disc       TFloat -- Цена по прайсу в ГРН по курсу документа c учетом Сезонной скидки
             , OperPriceList_curr_disc      TFloat -- *Цена по прайсу в валюте по курсу на тек дату c учетом Сезонной скидки
             , OperPriceList_curr_doc_disc  TFloat -- *Цена по прайсу в валюте по курсу документа c учетом Сезонной скидки

             , Remains                 TFloat -- Кол-во - остаток в магазине
             , RemainsDebt             TFloat -- Кол-во - долги по магазину
             , RemainsAll              TFloat -- Итого остаток кол-во с учетом долга
             , SummDebt                TFloat -- Сумма ГРН - долги по магазину
             , SummDebt_profit         TFloat -- Сумма ГРН - Прибыль будущих периодов в долгах по магазину

             , TotalSumm               TFloat -- Сумма по входным ценам в валюте - остаток итого с учетом долга
             , TotalSummBalance        TFloat -- Сумма по входным ценам в ГРН - остаток итого с учетом долга по курсу на тек дату
             , TotalSummBalance_doc    TFloat -- Сумма по входным ценам в ГРН - остаток итого с учетом долга по курсу документа  
             , TotalSummPriceList      TFloat -- Сумма по прайсу в ГРН - остаток итого с учетом долга
             , TotalSummPriceList_curr TFloat -- *Сумма по прайсу в валюте - остаток итого с учетом долга по курсу на тек дату
             , TotalSummPriceList_curr_doc TFloat -- *Сумма по прайсу в валюте - остаток итого с учетом долга по курсу документа  
             , TotalSummPriceJur       TFloat -- Сумма вх. без скидки в валюте (информативно)
             , PriceTax                TFloat -- % наценки по курсу на тек дату
             , PriceTax_doc            TFloat -- % наценки по курсу документа  
             , DiscountTax             TFloat -- % Сезонной скидки !!!НА!!! zc_DateEnd
             , Amount_GoodsPrint       TFloat -- Кол-во для печати ценников

             , PriceListId_Basis    Integer  --
             , PriceListName_Basis  TVarChar --
             , UpdateDate_Price     TDateTime
             , isOlap Boolean
             , Comment_in           TVarChar
             , ChangePercent_in     TFloat

             , CurrencyName_pl TVarChar
              )
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbIsOperPrice Boolean;
   DECLARE vbPriceListName_Basis TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- проверка может ли смотреть любой магазин, или только свой
    IF vbUserId <> 1078646 OR inUnitId NOT IN (1552, 1078645)
    THEN
        PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);
    END IF;


    -- Получили - показывать ЛИ цену ВХ.
    vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId) OR vbUserId = 1078646;

    -- для возможности изменениея цен добавояем прайс лист Базис
    vbPriceListName_Basis := (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_PriceList_Basis()) ::TVarChar;

    -- !!!замена!!!
    IF inIsPartion = TRUE THEN
       inIsPartner:= TRUE;
       -- inIsSize   := TRUE;
    END IF;
    -- !!!замена!!!
    inIsYear:= TRUE;
    -- !!!замена!!!
    IF inIsYear = TRUE AND COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;

    -- список подразделений
    CREATE TEMP TABLE _tmpUnit (UnitId Integer, PriceListId Integer, CurrencyId_pl Integer) ON COMMIT DROP;
    IF COALESCE (inUnitId, 0) <> 0
    THEN
        --
        INSERT INTO _tmpUnit (UnitId, PriceListId, CurrencyId_pl)
          SELECT lfSelect.UnitId
               , COALESCE (ObjectLink_Unit_PriceList.ChildObjectId, zc_PriceList_Basis()) AS PriceListId
               , COALESCE (ObjectLink_PriceList_Currency.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl
          FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
               LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                    ON ObjectLink_Unit_PriceList.ObjectId = lfSelect.UnitId
                                   AND ObjectLink_Unit_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
               LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency
                                    ON ObjectLink_PriceList_Currency.ObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                   AND ObjectLink_PriceList_Currency.DescId   = zc_ObjectLink_PriceList_Currency()
         ;
    ELSE
        --
        INSERT INTO _tmpUnit (UnitId, PriceListId, CurrencyId_pl)
          SELECT Object_Unit.Id
               , COALESCE (ObjectLink_Unit_PriceList.ChildObjectId, zc_PriceList_Basis()) AS PriceListId
               , COALESCE (ObjectLink_PriceList_Currency.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl
          FROM Object AS Object_Unit
               LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                    ON ObjectLink_Unit_PriceList.ObjectId = Object_Unit.Id
                                   AND ObjectLink_Unit_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
               LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency
                                    ON ObjectLink_PriceList_Currency.ObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                   AND ObjectLink_PriceList_Currency.DescId   = zc_ObjectLink_PriceList_Currency()
          WHERE Object_Unit.DescId = zc_Object_Unit()
         ;
    END IF;

    -- Результат
    RETURN QUERY
    WITH
     tmpReportOLAP AS (SELECT DISTINCT Object_PartionGoods.MovementItemId AS PartionId
                            , Object_PartionGoods.GoodsId
                       FROM Object
                            INNER JOIN ObjectLink AS ObjectLink_User
                                                  ON ObjectLink_User.ObjectId      = Object.Id
                                                 AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                 AND ObjectLink_User.ChildObjectId = vbUserId

                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ObjectId = Object.Id
                                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReportOLAP_Object()

                            -- привязываем по партии и товару, для партии определяем какой товар, для товара определяем партии
                            INNER JOIN Object_PartionGoods ON ObjectLink_Object.ChildObjectId = CASE WHEN Object.ObjectCode = 3 THEN Object_PartionGoods.MovementItemId ELSE Object_PartionGoods.GoodsId END

                       WHERE Object.DescId = zc_Object_ReportOLAP()
                         AND Object.ObjectCode IN (2, 3)
                         AND Object.isErased = FALSE
                       )
     -- выбираем из прайслистов первую и последнюю цены 
   , tmpPriceList AS (SELECT tmp.UnitId
                           , tmp.GoodsId
                           , tmp.CurrencyId_pl
                           , MAX (CASE WHEN tmp.EndDate = zc_DateEnd() THEN tmp.OperPriceList ELSE 0 END)    AS OperPriceList
                           , MAX (CASE WHEN tmp.StartDate = tmp.FirstDate THEN tmp.OperPriceList ELSE 0 END) AS OperPriceList_first
                      FROM (SELECT _tmpUnit.UnitId                                  AS UnitId
                                 , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                 , ObjectHistoryFloat_PriceListItem_Value.ValueData AS OperPriceList
                                 , COALESCE (ObjectHistoryLink_Currency.ObjectId, _tmpUnit.CurrencyId_pl) AS CurrencyId_pl
                                 , ObjectHistory_PriceListItem.StartDate
                                 , ObjectHistory_PriceListItem.EndDate
                                 , MIN (ObjectHistory_PriceListItem.StartDate) OVER (PARTITION BY _tmpUnit.UnitId, ObjectLink_PriceListItem_Goods.ChildObjectId) AS FirstDate
                            FROM _tmpUnit
                                 INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                       ON ObjectLink_PriceListItem_PriceList.ChildObjectId = _tmpUnit.PriceListId
                                                      AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                 INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                       ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                      AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()
      
                                 LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                         ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                        AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                        -- Последняя цена
                                                        --AND ObjectHistory_PriceListItem.EndDate  = zc_DateEnd()
                                 LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                              ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                             AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
      
                                 LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                                             ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                            AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                            WHERE zc_Enum_GlobalConst_isTerry() = FALSE
                           ) AS tmp
                      WHERE tmp.EndDate = zc_DateEnd()
                         OR tmp.StartDate = tmp.FirstDate
                      GROUP BY tmp.UnitId
                           , tmp.GoodsId
                           , tmp.CurrencyId_pl
                      )
                       
     -- Остатки + Партии
   , tmpContainer AS (SELECT Container.WhereObjectId                                   AS UnitId
                           , Container.PartionId                                       AS PartionId
                           , Container.ObjectId                                        AS GoodsId
                           , CASE WHEN CLO_Client.ContainerId IS NULL THEN Container.Amount ELSE 0 END AS Remains
                           , CASE WHEN CLO_Client.ContainerId > 0     THEN Container.Amount ELSE 0 END AS RemainsDebt
                           , COALESCE (Container.Amount, 0)                                            AS RemainsAll
                           , COALESCE (Container_SummDebt.Amount, 0)                                   AS SummDebt
                           , COALESCE (Container_SummDebt_profit.Amount, 0)                            AS SummDebt_profit

                           , ObjectLink_Partner_Period.ChildObjectId AS PeriodId
                           , Object_PartionGoods.BrandId
                           , Object_PartionGoods.PartnerId
                           , Object_PartionGoods.PeriodYear

                           , Object_PartionGoods.GoodsSizeId
                           , Object_PartionGoods.MeasureId
                           , Object_PartionGoods.GoodsGroupId
                           , Object_PartionGoods.CompositionId
                           , Object_PartionGoods.CompositionGroupId
                           , Object_PartionGoods.GoodsInfoId
                           , Object_PartionGoods.LineFabricaId
                           , Object_PartionGoods.LabelId
                           , Object_PartionGoods.JuridicalId
                           , Object_PartionGoods.CurrencyId

                           , Object_PartionGoods.MovementId
                             -- Если есть права видеть Цену вх.
                           , CASE WHEN vbIsOperPrice = TRUE THEN Object_PartionGoods.OperPrice ELSE 0 END AS OperPrice
                           , Object_PartionGoods.CountForPrice

                           , COALESCE (tmpPriceList.OperPriceList, Object_PartionGoods.OperPriceList) AS OperPriceList
                           , tmpPriceList.OperPriceList_first                                         AS OperPriceList_first
                           , COALESCE (tmpPriceList.CurrencyId_pl, zc_Currency_Basis())               AS CurrencyId_pl
                           
                           -- , CASE WHEN Container.WhereObjectId = Object_PartionGoods.UnitId THEN Object_PartionGoods.Amount ELSE 0 END AS Amount_in
                           , Object_PartionGoods.Amount     AS Amount_in
                           , Object_PartionGoods.UnitId     AS UnitId_in
                             --  № п/п - только для = 1 возьмем Amount_in
                           , ROW_NUMBER() OVER (PARTITION BY Container.PartionId ORDER BY CASE WHEN Container.WhereObjectId = Object_PartionGoods.UnitId THEN 0 ELSE 1 END ASC) AS Ord

                      FROM Container
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                         AND Object_PartionGoods.GoodsId        = Container.ObjectId
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                                ON ObjectLink_Partner_Period.ObjectId = Object_PartionGoods.PartnerId
                                               AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                           -- Дебиторы + покупатели + Товары
                           LEFT JOIN Container AS Container_SummDebt
                                               ON Container_SummDebt.ParentId = Container.Id
                                              AND Container_SummDebt.ObjectId = zc_Enum_Account_20101()
                                              AND Container_SummDebt.DescId   = zc_Container_Summ()
                                              -- AND 1=0
                           -- Дебиторы + покупатели + Прибыль будущих периодов
                           LEFT JOIN Container AS Container_SummDebt_profit
                                               ON Container_SummDebt_profit.ParentId = Container.Id
                                              AND Container_SummDebt_profit.ObjectId = zc_Enum_Account_20102()
                                              AND Container_SummDebt_profit.DescId   = zc_Container_Summ()
                                              -- AND 1=0

                           -- цена из Прайс-листа
                           LEFT JOIN tmpPriceList ON tmpPriceList.UnitId  = Container.WhereObjectId
                                                 AND tmpPriceList.GoodsId = Container.ObjectId

                      WHERE Container.DescId = zc_Container_Count()
                        -- AND Container.WhereObjectId = inUnitId
                        AND (Container.Amount <> 0 OR Container_SummDebt.Amount <> 0 OR Container_SummDebt_profit.Amount <> 0
                          OR inPartnerId <> 0 -- OR (inIsYear = TRUE AND inStartYear = inEndYear) -- OR inBrandId <> 0 -- OR (inIsYear = TRUE AND inStartYear >0)
                          -- OR inBrandId   <> 0
                          OR inIsRemains = TRUE
                            )
                        AND (ObjectLink_Partner_Period.ChildObjectId = inPeriodId   OR inPeriodId  = 0)
                        AND (Object_PartionGoods.BrandId             = inBrandId    OR inBrandId   = 0)
                        AND (Object_PartionGoods.PartnerId           = inPartnerId  OR inPartnerId = 0)
                        AND ((Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear) OR inIsYear = FALSE)
                     )

       , tmpData_All AS (SELECT tmpContainer.UnitId
                              , tmpContainer.GoodsId
                              , CASE WHEN inisPartion = TRUE AND inIsSize = TRUE THEN tmpContainer.PartionId ELSE 0 END AS PartionId
                              , CASE WHEN inisPartion = TRUE THEN tmpContainer.MovementId       ELSE 0  END AS MovementId_Partion
                              , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE '' END AS DescName_Partion
                              , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE '' END AS InvNumber_Partion
                              , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE zc_DateStart() END AS OperDate_Partion
                              , CASE WHEN inisPartner = TRUE THEN tmpContainer.PartnerId        ELSE 0  END AS PartnerId
                              --, CASE WHEN inisSize    = TRUE THEN tmpContainer.GoodsSizeId      ELSE 0  END AS GoodsSizeId
                              , tmpContainer.GoodsSizeId

                              , tmpContainer.BrandId
                              , tmpContainer.PeriodId
                              , tmpContainer.PeriodYear
                              , ObjectLink_Partner_Fabrika.ChildObjectId AS FabrikaId

                              , tmpContainer.MeasureId
                              , tmpContainer.GoodsGroupId
                              , tmpContainer.CompositionId
                              , tmpContainer.CompositionGroupId
                              , tmpContainer.GoodsInfoId
                              , tmpContainer.LineFabricaId
                              , tmpContainer.LabelId
                              , tmpContainer.JuridicalId
                              , tmpContainer.CurrencyId
                              , tmpContainer.CurrencyId_pl
                              , tmpContainer.OperPriceList
                              , tmpContainer.OperPriceList_first
                              , tmpContainer.UnitId_in

                                --  только для Ord = 1
                              , SUM (CASE WHEN tmpContainer.Ord = 1 THEN tmpContainer.Amount_in ELSE 0 END) AS Amount_in
                              , SUM (CASE WHEN tmpContainer.Ord = 1 THEN zfCalc_SummIn (tmpContainer.Amount_in, tmpContainer.OperPrice, tmpContainer.CountForPrice) ELSE 0 END) AS TotalSummPrice_in
                              , SUM (CASE WHEN tmpContainer.Ord = 1 THEN zfCalc_SummIn (tmpContainer.Amount_in, COALESCE (MIFloat_PriceJur.ValueData, 0), tmpContainer.CountForPrice) ELSE 0 END) AS TotalSummPriceJur

                              , SUM (tmpContainer.Remains)         AS Remains
                              , SUM (tmpContainer.RemainsDebt)     AS RemainsDebt
                              , SUM (tmpContainer.RemainsAll)      AS RemainsAll
                              , SUM (tmpContainer.SummDebt)        AS SummDebt
                              , SUM (tmpContainer.SummDebt_profit) AS SummDebt_profit


                              , SUM (zfCalc_SummIn        (tmpContainer.RemainsAll, tmpContainer.OperPrice, tmpContainer.CountForPrice)) AS TotalSummPrice
                              , SUM (zfCalc_SummPriceList (tmpContainer.RemainsAll, tmpContainer.OperPriceList))                         AS TotalSummPriceList

                              , SUM (CASE WHEN COALESCE (tmpReportOLAP.PartionId, 0) <> 0 THEN 1 ELSE 0 END) AS byOlap

                              , MS_Comment.ValueData                        AS Comment_in
                              , COALESCE (MF_ChangePercent.ValueData, 0)    AS ChangePercent_in
                              , COALESCE (MF_CurrencyValue.ValueData, 0)    AS CurrencyValue
                              , COALESCE (MF_ParValue.ValueData, 0)         AS ParValue

                         FROM tmpContainer
                              LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpContainer.MovementId
                              LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId
                              LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                                   ON ObjectLink_Partner_Fabrika.ObjectId = tmpContainer.PartnerId
                                                  AND ObjectLink_Partner_Fabrika.DescId   = zc_ObjectLink_Partner_Fabrika()

                              LEFT JOIN tmpReportOLAP ON tmpReportOLAP.PartionId = tmpContainer.PartionId
                                                     AND tmpReportOLAP.GoodsId   = tmpContainer.GoodsId

                              LEFT JOIN MovementItemFloat AS MIFloat_PriceJur
                                                          ON MIFloat_PriceJur.MovementItemId = tmpContainer.PartionId
                                                         AND MIFloat_PriceJur.DescId         = zc_MIFloat_PriceJur()
                                                         --AND inisPartion = TRUE
                                                         AND vbIsOperPrice = TRUE
                              LEFT JOIN MovementString AS MS_Comment
                                                       ON MS_Comment.MovementId = tmpContainer.MovementId
                                                      AND MS_Comment.DescId = zc_MovementString_Comment()
                                                      AND inisPartion = TRUE
                              LEFT JOIN MovementFloat AS MF_ChangePercent
                                                      ON MF_ChangePercent.MovementId = tmpContainer.MovementId
                                                     AND MF_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
                                                     AND inisPartion                 = TRUE
                              LEFT JOIN MovementFloat AS MF_ParValue
                                                      ON MF_ParValue.MovementId = tmpContainer.MovementId
                                                     AND MF_ParValue.DescId     = zc_MovementFloat_ParValue()
                                                     AND inisPartion            = TRUE
                              LEFT JOIN MovementFloat AS MF_CurrencyValue
                                                      ON MF_CurrencyValue.MovementId = tmpContainer.MovementId
                                                     AND MF_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
                                                     AND inisPartion                 = TRUE

                              -- LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_PartionGoods.GoodsId
                         GROUP BY tmpContainer.UnitId
                                , tmpContainer.GoodsId
                                , CASE WHEN inisPartion = TRUE AND inIsSize = TRUE THEN tmpContainer.PartionId        ELSE 0 END
                                , CASE WHEN inisPartion = TRUE THEN tmpContainer.MovementId       ELSE 0  END
                                , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE '' END
                                , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE '' END
                                , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE zc_DateStart() END
                                , CASE WHEN inisPartner = TRUE THEN tmpContainer.PartnerId        ELSE 0  END
                                , tmpContainer.GoodsSizeId

                                , tmpContainer.BrandId
                                , tmpContainer.PeriodId
                                , tmpContainer.PeriodYear
                                , ObjectLink_Partner_Fabrika.ChildObjectId

                                , tmpContainer.MeasureId
                                , tmpContainer.GoodsGroupId
                                , tmpContainer.CompositionId
                                , tmpContainer.CompositionGroupId
                                , tmpContainer.GoodsInfoId
                                , tmpContainer.LineFabricaId
                                , tmpContainer.LabelId
                                , tmpContainer.JuridicalId
                                , tmpContainer.CurrencyId
                                , tmpContainer.CurrencyId_pl
                                , tmpContainer.PeriodYear
                                , tmpContainer.OperPriceList
                                , tmpContainer.OperPriceList_first
                                , tmpContainer.UnitId_in
                                , MS_Comment.ValueData
                                , MF_ChangePercent.ValueData
                                , MF_CurrencyValue.ValueData
                                , MF_ParValue.ValueData
                  )
       , tmpCurrency AS (SELECT lfSelect.*
                         FROM Object
                              CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate      := CURRENT_DATE
                                                                          , inCurrencyFromId:= zc_Currency_Basis()
                                                                          , inCurrencyToId  := Object.Id
                                                                           ) AS lfSelect
                         WHERE Object.DescId = zc_Object_Currency()
                           AND Object.Id     <> zc_Currency_Basis()
                           AND vbIsOperPrice = TRUE
                        )

       , tmpData AS (SELECT tmpData_All.UnitId
                          , tmpData_All.GoodsId
                          , tmpData_All.PartionId
                          , tmpData_All.MovementId_Partion
                          , tmpData_All.DescName_Partion
                          , tmpData_All.InvNumber_Partion
                          , tmpData_All.OperDate_Partion
                          , tmpData_All.PartnerId
                          , CASE WHEN inIsSize = TRUE THEN Object_GoodsSize.Id ELSE 0 END         AS GoodsSizeId
                          , CASE WHEN inIsSize = TRUE THEN Object_GoodsSize.ValueData ELSE '' END AS GoodsSizeName_real
                          , STRING_AGG (Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData) AS GoodsSizeName

                          , tmpData_All.BrandId
                          , tmpData_All.PeriodId
                          , tmpData_All.PeriodYear
                          , tmpData_All.FabrikaId
                          , tmpData_All.MeasureId
                          , tmpData_All.GoodsGroupId
                          , tmpData_All.CompositionId
                          , tmpData_All.CompositionGroupId
                          , tmpData_All.GoodsInfoId
                          , tmpData_All.LineFabricaId
                          , tmpData_All.LabelId
                          , tmpData_All.JuridicalId
                          , tmpData_All.CurrencyId
                          , tmpData_All.CurrencyId_pl
                          
                            -- Цена прайс
                          , tmpData_All.OperPriceList       AS OperPriceList_orig
                           -- первая цена товара (инф.) 
                          , tmpData_All.OperPriceList_first AS OperPriceList_first
                          
                            -- Цена прайс - переводим в ГРН, по курсу "сегодня"
                          , tmpData_All.OperPriceList * (CASE WHEN tmpData_All.CurrencyId_pl = zc_Currency_GRN() THEN 1 WHEN tmpCurrency.Amount   <> 0 THEN tmpCurrency.Amount   ELSE 1 END
                                                       / CASE WHEN tmpData_All.CurrencyId_pl = zc_Currency_GRN() THEN 1 WHEN tmpCurrency.ParValue <> 0 THEN tmpCurrency.ParValue ELSE 1 END
                                                        ) AS OperPriceList

                            -- Цена прайс - переводим в валюте,
                          , tmpData_All.OperPriceList / (CASE WHEN tmpData_All.CurrencyId_pl <> zc_Currency_GRN() THEN 1 WHEN tmpCurrency.Amount   <> 0 THEN tmpCurrency.Amount   ELSE 1 END
                                                       / CASE WHEN tmpData_All.CurrencyId_pl <> zc_Currency_GRN() THEN 1 WHEN tmpCurrency.ParValue <> 0 THEN tmpCurrency.ParValue ELSE 1 END
                                                        ) AS OperPriceList_curr

                            -- Цена прайс - переводим в ГРН, по курсу док. Приход
                          , tmpData_All.OperPriceList * (CASE WHEN tmpData_All.CurrencyId_pl = zc_Currency_GRN() THEN 1 WHEN tmpData_All.CurrencyValue <> 0 THEN tmpData_All.CurrencyValue ELSE 1 END
                                                       / CASE WHEN tmpData_All.CurrencyId_pl = zc_Currency_GRN() THEN 1 WHEN tmpData_All.ParValue <> 0 THEN tmpData_All.ParValue ELSE 1 END
                                                        ) AS OperPriceList_doc
                          , tmpData_All.OperPriceList / (CASE WHEN tmpData_All.CurrencyId_pl <> zc_Currency_GRN() THEN 1 WHEN tmpData_All.CurrencyValue <> 0 THEN tmpData_All.CurrencyValue ELSE 1 END
                                                       / CASE WHEN tmpData_All.CurrencyId_pl <> zc_Currency_GRN() THEN 1 WHEN tmpData_All.ParValue <> 0 THEN tmpData_All.ParValue ELSE 1 END
                                                        ) AS OperPriceList_doc_curr

                          , tmpData_All.UnitId_in

                          , tmpData_All.Comment_in
                          , tmpData_All.ChangePercent_in

                          , tmpCurrency.Amount           :: TFloat  AS CurrencyValue
                          , tmpCurrency.ParValue         :: TFloat  AS ParValue
                          , tmpData_All.CurrencyValue    :: TFloat  AS CurrencyValue_doc
                          , tmpData_All.ParValue         :: TFloat  AS ParValue_doc

                          , SUM (tmpData_All.Amount_in)         AS Amount_in
                          , SUM (tmpData_All.TotalSummPrice_in) AS TotalSummPrice_in
                          , SUM (tmpData_All.TotalSummPriceJur) AS TotalSummPriceJur

                          , SUM (tmpData_All.Remains)         AS Remains
                          , SUM (tmpData_All.RemainsDebt)     AS RemainsDebt
                          , SUM (tmpData_All.RemainsAll)      AS RemainsAll
                          , SUM (tmpData_All.SummDebt)        AS SummDebt
                          , SUM (tmpData_All.SummDebt_profit) AS SummDebt_profit

                          , SUM (tmpData_All.TotalSummPrice)     AS TotalSummPrice
                          , SUM (tmpData_All.TotalSummPriceList) AS TotalSummPriceList

                          , SUM (tmpData_All.byOlap) AS byOlap

                     FROM tmpData_All
                          LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyToId = tmpData_All.CurrencyId
                          LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmpData_All.GoodsSizeId
                     GROUP BY tmpData_All.UnitId
                            , tmpData_All.GoodsId
                            , tmpData_All.PartionId
                            , tmpData_All.MovementId_Partion
                            , tmpData_All.DescName_Partion
                            , tmpData_All.InvNumber_Partion
                            , tmpData_All.OperDate_Partion
                            , tmpData_All.PartnerId
                            , CASE WHEN inIsSize = TRUE THEN Object_GoodsSize.Id ELSE 0 END
                            , CASE WHEN inIsSize = TRUE THEN Object_GoodsSize.ValueData ELSE '' END
                            , tmpData_All.BrandId
                            , tmpData_All.PeriodId
                            , tmpData_All.PeriodYear
                            , tmpData_All.FabrikaId
                            , tmpData_All.MeasureId
                            , tmpData_All.GoodsGroupId
                            , tmpData_All.CompositionId
                            , tmpData_All.CompositionGroupId
                            , tmpData_All.GoodsInfoId
                            , tmpData_All.LineFabricaId
                            , tmpData_All.LabelId
                            , tmpData_All.JuridicalId
                            , tmpData_All.CurrencyId
                            , tmpData_All.CurrencyId_pl
                            , tmpData_All.OperPriceList
                            , tmpData_All.OperPriceList_first
                            , tmpData_All.UnitId_in
                            , tmpData_All.Comment_in
                            , tmpData_All.ChangePercent_in
                            , tmpCurrency.Amount
                            , tmpCurrency.ParValue
                            , tmpData_All.CurrencyValue
                            , tmpData_All.ParValue
              )


 , tmpDiscountList AS (SELECT DISTINCT tmpData.UnitId, tmpData.GoodsId FROM tmpData)

          , tmpOL1 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                                                  AND ObjectLink.DescId        = zc_ObjectLink_DiscountPeriodItem_Goods()
                      )
          , tmpOL2 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpOL1.ObjectId FROM tmpOL1)
                                                  AND ObjectLink.DescId   = zc_ObjectLink_DiscountPeriodItem_Unit()
                      )

 , tmpDiscount AS (SELECT ObjectLink_DiscountPeriodItem_Unit.ChildObjectId      AS UnitId
                        , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId     AS GoodsId
                        , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS DiscountTax
                   FROM tmpDiscountList
                        INNER JOIN tmpOL1 AS ObjectLink_DiscountPeriodItem_Goods
                                              ON ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = tmpDiscountList.GoodsId
                                             -- AND ObjectLink_DiscountPeriodItem_Goods.DescId       = zc_ObjectLink_DiscountPeriodItem_Goods()
                        INNER JOIN tmpOL2 AS ObjectLink_DiscountPeriodItem_Unit
                                              ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                             AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = tmpDiscountList.UnitId
                                             -- AND ObjectLink_DiscountPeriodItem_Unit.DescId       = zc_ObjectLink_DiscountPeriodItem_Unit()
                        INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                 ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                     ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                    AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                  )
 , tmpGoodsPrint AS (SELECT Object_GoodsPrint.UnitId
                          , CASE WHEN inisPartion = TRUE THEN Object_GoodsPrint.PartionId ELSE 0 END AS PartionId
                          , Object_PartionGoods.GoodsId
                          , SUM (Object_GoodsPrint.Amount) AS Amount
                     FROM (SELECT Object_GoodsPrint.InsertDate
                                , ROW_NUMBER() OVER (PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate) AS ord
                           FROM Object_GoodsPrint
                           WHERE Object_GoodsPrint.UserId = inUserId
                             AND inGoodsPrintId > 0
                           GROUP BY Object_GoodsPrint.UserId
                                  , Object_GoodsPrint.InsertDate
                                  , Object_GoodsPrint.UnitId
                                  , Object_GoodsPrint.isReprice
                          ) AS tmp
                          LEFT JOIN Object_GoodsPrint ON Object_GoodsPrint.InsertDate = tmp.InsertDate
                                                     AND Object_GoodsPrint.UserId     = inUserId
                          LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Object_GoodsPrint.PartionId

                     WHERE tmp.Ord = inGoodsPrintId -- № п/п сессии GoodsPrint
                     GROUP BY Object_GoodsPrint.UnitId
                            , CASE WHEN inisPartion = TRUE THEN Object_GoodsPrint.PartionId ELSE 0 END
                            , Object_PartionGoods.GoodsId
                    )

       , tmpPriceInfo AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                               , MAX (ObjectDate_Protocol_Update.ValueData )      AS UpdateDate
                          FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                               LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                    ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                   AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                               LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                                    ON ObjectDate_Protocol_Update.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId --tmpPrice.PriceListItemObjectId
                                                   AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
                          WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                            AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis() --  inPriceListId
                          GROUP BY ObjectLink_PriceListItem_Goods.ChildObjectId
                         )

        -- Результат
        SELECT
             tmpData.PartionId                      AS PartionId
           , tmpData.MovementId_Partion             AS MovementId_Partion
           , tmpData.InvNumber_Partion :: TVarChar  AS InvNumber_Partion
           , zfCalc_PartionMovementName (0, '', tmpData.InvNumber_Partion, tmpData.OperDate_Partion) AS InvNumberAll_Partion
           , CASE WHEN tmpData.OperDate_Partion = zc_DateStart() THEN NULL ELSE tmpData.OperDate_Partion END  :: TDateTime AS OperDate_Partion
           , tmpData.DescName_Partion  :: TVarChar  AS DescName_Partion

           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_Unit_in.ValueData       AS UnitName_in
           , Object_Partner.ValueData       AS PartnerName
           , Object_Brand.ValueData         AS BrandName
           , Object_Fabrika.ValueData       AS FabrikaName
           , Object_Period.ValueData        AS PeriodName
           , tmpData.PeriodYear

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , (COALESCE (ObjectString_GoodsGroupFull.ValueData, '') ||' - '||Object_Label.ValueData||' - '||Object_Goods.ObjectCode||' - ' || Object_Goods.ValueData) ::TVarChar  AS GoodsNameFull
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , (COALESCE (ObjectString_GoodsGroupFull.ValueData, '') || ' - ' || COALESCE (Object_GoodsInfo.ValueData, '')) :: TVarChar AS NameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , Object_Juridical.ValueData     AS JuridicalName

           , CASE WHEN inSession = zfCalc_UserAdmin()
                       THEN CASE WHEN ObjectString_GoodsGroupFull.ValueData ILIKE '% муж %'
                                   OR ObjectString_GoodsGroupFull.ValueData ILIKE '% муж'
                                   OR ObjectString_GoodsGroupFull.ValueData ILIKE '% мальч %'
                                   OR ObjectString_GoodsGroupFull.ValueData ILIKE '% мальч'
                                      THEN 'М'
                                 WHEN ObjectString_GoodsGroupFull.ValueData ILIKE '% жен %'
                                   OR ObjectString_GoodsGroupFull.ValueData ILIKE '% жен'
                                   OR ObjectString_GoodsGroupFull.ValueData ILIKE '% дев%'
                                   OR ObjectString_GoodsGroupFull.ValueData ILIKE '% дев'
                                      THEN 'Ж'
                                 ELSE ''
                            END
                  ELSE Object_CompositionGroup.ValueData
             END :: TVarChar                AS CompositionGroupName

           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , CASE WHEN inSession = zfCalc_UserAdmin()
                       THEN zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.ObjectCode :: Integer)
                         || zfCalc_SummBarCode (zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.ObjectCode)) :: TVarChar
                  ELSE Object_LineFabrica.ValueData
             END :: TVarChar                AS LineFabricaName

           , Object_Label.ValueData         AS LabelName

           , tmpData.GoodsSizeId            AS GoodsSizeId
           , tmpData.GoodsSizeName      ::TVarChar AS GoodsSizeName
           , tmpData.GoodsSizeName_real ::TVarChar AS GoodsSizeName_real
           , CASE WHEN vbIsOperPrice = TRUE THEN Object_Currency.ValueData ELSE '' END :: TVarChar AS CurrencyName

           , tmpData.CurrencyValue     :: TFloat AS CurrencyValue
           , tmpData.ParValue          :: TFloat AS ParValue
           , tmpData.CurrencyValue_doc :: TFloat AS CurrencyValue_doc
           , tmpData.ParValue_doc      :: TFloat AS ParValue_doc

             -- Итого кол-во Приход от поставщика
           , tmpData.Amount_in    :: TFloat AS Amount_in
             -- Цена вх. в валюте
           , CASE WHEN tmpData.RemainsAll <> 0 THEN tmpData.TotalSummPrice    / tmpData.RemainsAll
                  WHEN tmpData.Amount_in  <> 0 THEN tmpData.TotalSummPrice_in / tmpData.Amount_in
                  ELSE 0
             END :: TFloat AS OperPrice
           , 1   :: TFloat AS CountForPrice

             -- *Цена вх. в ГРН на тек.дату
           , CASE WHEN tmpData.RemainsAll <> 0 THEN tmpData.TotalSummPrice    / tmpData.RemainsAll
                                                  * CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.CurrencyValue <> 0 THEN tmpData.CurrencyValue ELSE 1 END
                                                  / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue <> 0      THEN tmpData.ParValue      ELSE 1 END
                  WHEN tmpData.Amount_in  <> 0 THEN tmpData.TotalSummPrice_in / tmpData.Amount_in
                                                  * CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.CurrencyValue <> 0 THEN tmpData.CurrencyValue ELSE 0 END
                                                  / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue <> 0      THEN tmpData.ParValue      ELSE 1 END
                  ELSE 0
             END :: TFloat AS OperPrice_grn

             -- *Цена вх. в ГРН по курсу документа
           , CASE WHEN tmpData.RemainsAll <> 0 THEN tmpData.TotalSummPrice    / tmpData.RemainsAll
                                                  * CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.CurrencyValue_doc <> 0 THEN tmpData.CurrencyValue_doc ELSE 1 END
                                                  / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue_doc <> 0      THEN tmpData.ParValue_doc      ELSE 1 END
                  WHEN tmpData.Amount_in  <> 0 THEN tmpData.TotalSummPrice_in / tmpData.Amount_in
                                                  * CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.CurrencyValue_doc <> 0 THEN tmpData.CurrencyValue_doc ELSE 0 END
                                                  / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue_doc <> 0      THEN tmpData.ParValue_doc      ELSE 1 END
                  ELSE 0
             END :: TFloat AS OperPrice_grn_doc

             -- Цена по прайсу
           , tmpData.OperPriceList_orig  :: TFloat
           
             -- Цена по прайсу в ГРН  тек.курс
           , CAST (tmpData.OperPriceList AS NUMERIC (16, 0)) :: TFloat
             -- Цена по прайсу в ГРН курс.документа
           , CAST (tmpData.OperPriceList_doc AS NUMERIC (16, 0)) :: TFloat
           
             -- *Цена по прайсу в валюте по курсу на тек.дату
           , CAST (tmpData.OperPriceList_curr AS NUMERIC (16, 0)) :: TFloat AS OperPriceList_curr
                   
             -- *Цена по прайсу в валюте по курсу документа
           , CAST (tmpData.OperPriceList_doc_curr AS NUMERIC (16, 0)) :: TFloat AS OperPriceList_curr_doc

             -- Цена вх. без ск. в валюте (информативно)
           , CASE WHEN tmpData.Amount_in  <> 0 THEN tmpData.TotalSummPriceJur / tmpData.Amount_in
                  ELSE 0
             END :: TFloat AS PriceJur

             -- первая цена товара (инф.)
           , tmpData.OperPriceList_first :: TFloat

             --c учетом сезонной скидки
             -- Цена по прайсу в ГРН  тек.курс
           , CAST (tmpData.OperPriceList * (1 - COALESCE (tmpDiscount.DiscountTax,0) /100) AS NUMERIC (16, 0))     :: TFloat AS OperPriceList_disc
             -- Цена по прайсу в ГРН курс.документа
           , CAST (tmpData.OperPriceList_doc * (1 - COALESCE (tmpDiscount.DiscountTax,0) /100) AS NUMERIC (16, 0)) :: TFloat AS OperPriceList_doc_disc
           
             -- *Цена по прайсу в валюте по курсу на тек.дату
           , CAST (tmpData.OperPriceList_curr 
                          * (1 - COALESCE (tmpDiscount.DiscountTax,0) /100)    
                   AS NUMERIC (16, 0)) :: TFloat AS OperPriceList_curr_disc
                   
             -- *Цена по прайсу в валюте по курсу документа
           , CAST (tmpData.OperPriceList_doc_curr
                          * (1 - COALESCE (tmpDiscount.DiscountTax,0) /100)
                   AS NUMERIC (16, 0)) :: TFloat AS OperPriceList_curr_doc_disc
           /***********************/

             -- Кол-во - остаток в магазине
           , tmpData.Remains                 :: TFloat AS Remains
             -- Кол-во - долги по магазину
           , tmpData.RemainsDebt             :: TFloat AS RemainsDebt
             -- Итого остаток кол-во с учетом долга
           , tmpData.RemainsAll              :: TFloat AS RemainsAll

             -- Сумма ГРН - долги по магазину
           , tmpData.SummDebt                :: TFloat AS SummDebt
             -- Сумма ГРН - Прибыль будущих периодов в долгах по магазину
           , tmpData.SummDebt_profit         :: TFloat AS SummDebt_profit

             -- Сумма по входным ценам в валюте - остаток итого с учетом долга
           , tmpData.TotalSummPrice          :: TFloat AS TotalSumm

             -- Сумма по входным ценам в ГРН - остаток итого с учетом долга  по курсу на тек.дату
           , CAST (tmpData.TotalSummPrice * tmpData.CurrencyValue / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END AS NUMERIC (16, 2)) :: TFloat AS TotalSummBalance
             -- Сумма по входным ценам в ГРН - остаток итого с учетом долга по курсу документа
           , CAST (tmpData.TotalSummPrice * tmpData.CurrencyValue_doc / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue_doc <> 0 THEN tmpData.ParValue_doc ELSE 1 END AS NUMERIC (16, 2)) :: TFloat AS TotalSummBalance_doc

             -- Сумма по прайсу - остаток итого с учетом долга
           --, tmpData.TotalSummPriceList      :: TFloat AS TotalSummPriceList
           , CAST (tmpData.TotalSummPriceList * CASE WHEN tmpData.CurrencyId_pl = zc_Currency_GRN() THEN 1 WHEN tmpData.CurrencyValue <> 0 THEN tmpData.CurrencyValue ELSE 1 END
                                              / CASE WHEN tmpData.CurrencyId_pl = zc_Currency_GRN() THEN 1 WHEN tmpData.ParValue <> 0      THEN tmpData.ParValue      ELSE 1 END
                   AS NUMERIC (16, 0)) :: TFloat AS TotalSummPriceList


             -- *Сумма по прайсу в валюте - остаток итого с учетом долга по курсу на тек.дату
           , CAST (tmpData.TotalSummPriceList / CASE WHEN tmpData.CurrencyId_pl <> zc_Currency_GRN() THEN 1 WHEN tmpData.CurrencyValue <> 0 THEN tmpData.CurrencyValue ELSE 1 END
                                              / CASE WHEN tmpData.CurrencyId_pl <> zc_Currency_GRN() THEN 1 WHEN tmpData.ParValue <> 0      THEN tmpData.ParValue      ELSE 1 END
                   AS NUMERIC (16, 0)) :: TFloat AS TotalSummPriceList_curr

             -- *Сумма по прайсу в валюте - остаток итого с учетом долга по курсу документа
           , CAST (tmpData.TotalSummPriceList / CASE WHEN tmpData.CurrencyId <> zc_Currency_GRN() THEN 1 WHEN tmpData.CurrencyValue_doc <> 0 THEN tmpData.CurrencyValue_doc ELSE 1 END
                                              / CASE WHEN tmpData.CurrencyId <> zc_Currency_GRN() THEN 1 WHEN tmpData.ParValue_doc <> 0      THEN tmpData.ParValue_doc      ELSE 1 END
                   AS NUMERIC (16, 0)) :: TFloat AS TotalSummPriceList_curr_doc

             -- Сумма вх. без скидки в валюте (информативно)
           , tmpData.TotalSummPriceJur       :: TFloat AS TotalSummPriceJur

             -- % наценки по курсу на тек.дату
           , CAST (CASE WHEN (tmpData.TotalSummPrice_in * tmpData.CurrencyValue / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END)
                              <> 0
                        THEN (100 * tmpData.Amount_in * tmpData.OperPriceList
                            / (tmpData.TotalSummPrice_in * tmpData.CurrencyValue / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END)
                              - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax

             -- % наценки по курсу документа
           , CAST (CASE WHEN (tmpData.TotalSummPrice_in * tmpData.CurrencyValue_doc / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue_doc <> 0 THEN tmpData.ParValue_doc ELSE 1 END)
                              <> 0
                        THEN (100 * tmpData.Amount_in * tmpData.OperPriceList_doc
                            / (tmpData.TotalSummPrice_in * tmpData.CurrencyValue_doc / CASE WHEN tmpData.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpData.ParValue_doc <> 0 THEN tmpData.ParValue_doc ELSE 1 END)
                              - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax_doc

             -- % Сезонной скидки !!!НА!!! zc_DateEnd
           , tmpDiscount.DiscountTax         :: TFloat AS DiscountTax
             -- Кол-во для печати ценников
           , tmpGoodsPrint.Amount            :: TFloat AS Amount_GoodsPrint

           , zc_PriceList_Basis()  AS PriceListId_Basis
           , vbPriceListName_Basis AS PriceListName_Basis
           , COALESCE (tmpPriceInfo.UpdateDate, NULL) :: TDateTime AS UpdateDate_Price

           , CASE WHEN COALESCE (tmpData.byOlap, 0) > 0 THEN TRUE ELSE FALSE END :: Boolean AS isOlap

           , tmpData.Comment_in       :: TVarChar
           , tmpData.ChangePercent_in :: TFloat

           , Object_Currency_pl.ValueData AS CurrencyName_pl

        FROM tmpData
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_in ON Object_Unit_in.Id = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpData.GoodsId
            LEFT JOIN Object AS Object_Currency_pl ON Object_Currency_pl.Id = tmpData.CurrencyId_pl

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpData.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            --LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = tmpData.JuridicalId
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId

            LEFT JOIN Object AS Object_Brand   ON Object_Brand.Id   = tmpData.BrandId
            LEFT JOIN Object AS Object_Fabrika ON Object_Fabrika.Id = tmpData.FabrikaId
            LEFT JOIN Object AS Object_Period  ON Object_Period.Id  = tmpData.PeriodId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpDiscount ON tmpDiscount.UnitId  = tmpData.UnitId
                                 AND tmpDiscount.GoodsId = tmpData.GoodsId

            LEFT JOIN tmpGoodsPrint ON tmpGoodsPrint.UnitId    = tmpData.UnitId
                                   AND tmpGoodsPrint.PartionId = tmpData.PartionId
                                   AND tmpGoodsPrint.GoodsId   = tmpData.GoodsId

            LEFT JOIN tmpPriceInfo ON tmpPriceInfo.GoodsId = tmpData.GoodsId
           ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 03.03.20         *
 03.07.18         *
 15.03.18         * add RemainsAll
 19.02.18         *
 22.06.17         *
*/
/*
drop index idx_objectlink_objectid_childobjectid_descid
drop index idx_objectlink_childobjectid_descid
drop index idx_objecthistory_objectid_enddate_descid
CREATE UNIQUE INDEX idx_objectlink_objectid_childobjectid_descid
  ON public.objectlink
  USING btree
  (ObjectId, childobjectid, descid);
CREATE INDEX idx_objectlink_childobjectid_descid
  ON public.objectlink
  USING btree
  (childobjectid, descid);
CREATE UNIQUE INDEX idx_objecthistory_objectid_enddate_descid
  ON public.objecthistory
  USING btree
  (objectid, enddate, descid);
*/

-- тест
-- SELECT * FROM gpReport_Goods_RemainsCurrent (inUnitId:= 1531, inBrandId:= 0, inPartnerId:= 0, inPeriodId:= 0, inStartYear:= 0, inEndYear:= 0, inUserId:= 0, inGoodsPrintId:= 0, inisPartion:= FALSE, inisPartner:= FALSE, inisSize:= TRUE, inIsYear:= FALSE, inIsRemains:= FALSE, inSession:= zfCalc_UserAdmin())
-- select * from gpReport_Goods_RemainsCurrent(inUnitId := 0 , inBrandId := 0 , inPartnerId := 0 , inPeriodId := 0 , inStartYear := 0 , inEndYear := 0 , inUserId := 2 , inGoodsPrintId := 0 , inIsPartion := 'True' , inIsPartner := 'False' , inIsSize := 'False' , inIsYear := 'False' , inIsRemains := 'False' ,  inSession := '2');
