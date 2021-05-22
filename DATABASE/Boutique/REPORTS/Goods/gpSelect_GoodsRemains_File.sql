-- Function: gpSelect_GoodsRemains_File (Integer, TVarChar)

DROP FUNCTION gpSelect_GoodsRemains_File (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsRemains_File (
    IN inUnitId               Integer   , --подразделение
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob
--           , Num     Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);


     -- магазин PODIUM
     --IF inUnitId = 0 THEN inUnitId:= 6318; END IF;
     --IF inUnitId = 0 THEN inUnitId:= 6319; END IF;


     --данные подразделения
     CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitName TVarChar, PriceListId Integer, CurrencyId_pl Integer, CurrencyName_pl TVarChar, Phone TVarChar) ON COMMIT DROP;
     INSERT INTO _tmpUnit (UnitId, UnitName, PriceListId, CurrencyId_pl, CurrencyName_pl, Phone)
          SELECT Object_Unit.Id                                                              AS UnitId
               , Object_Unit.ValueData                                                       AS UnitName
               , COALESCE (ObjectLink_Unit_PriceList.ChildObjectId, zc_PriceList_Basis())    AS PriceListId
               , COALESCE (ObjectLink_PriceList_Currency.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl
               , Object_Currency.ValueData                                                   AS CurrencyName_pl
               , OS_Unit_Phone.ValueData                                                     AS Phone
          FROM Object AS Object_Unit
               LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                    ON ObjectLink_Unit_PriceList.ObjectId = Object_Unit.Id
                                   AND ObjectLink_Unit_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
               LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency
                                    ON ObjectLink_PriceList_Currency.ObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                   AND ObjectLink_PriceList_Currency.DescId   = zc_ObjectLink_PriceList_Currency()
               LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_PriceList_Currency.ChildObjectId

               LEFT JOIN ObjectString AS OS_Unit_Phone
                                      ON OS_Unit_Phone.ObjectId = Object_Unit.Id
                                     AND OS_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
              WHERE Object_Unit.DescId = zc_Object_Unit()
             ;

/*
+ цена в грн
- цена в грн с учетом сезонной скидки
+ % сезонной скидки
+ цена в валюте
+ курс
*/

     -- таблица остатков
     CREATE TEMP TABLE _tmpData (UnitId Integer, UnitName TVarChar, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, LabelName TVarChar, GoodsInfoName TVarChar
                               , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupId_parent Integer, PartnerName TVarChar
                               , BrandName TVarChar, PeriodName TVarChar, PeriodYear TVarChar, SizeName TVarChar, CurrencyName TVarChar, CurrencyName_curr TVarChar
                               , Amount TFloat, OperPriceList TFloat, OperPriceList_curr TFloat
                               , OperPriceList_grn TFloat, OperPriceList_grn_curr TFloat, OperPriceList_grn_curr_disc TFloat
                               , AmountCurrency TFloat, AmountCurrency_curr TFloat, DiscountTax TFloat
                                ) ON COMMIT DROP;
     INSERT INTO _tmpData (UnitId, UnitName, GoodsId, GoodsCode, GoodsName, LabelName, GoodsInfoName, GoodsGroupId, GoodsGroupName, GoodsGroupId_parent
                         , PartnerName, BrandName, PeriodName, PeriodYear, SizeName, CurrencyName, CurrencyName_curr
                         , Amount, OperPriceList, OperPriceList_curr
                         , OperPriceList_grn, OperPriceList_grn_curr, OperPriceList_grn_curr_disc
                         , AmountCurrency, AmountCurrency_curr, DiscountTax)
       WITH
           -- все цены
           tmpPriceList_all AS (SELECT _tmpUnit.UnitId                                  AS UnitId
                                     , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                     , ObjectHistory_PriceListItem.StartDate            AS StartDate
                                     , ObjectHistoryFloat_PriceListItem_Value.ValueData AS OperPriceList
                                     , COALESCE (ObjectHistoryLink_Currency.ObjectId, _tmpUnit.CurrencyId_pl) AS CurrencyId_pl
                                      -- № п/п
                                    , ROW_NUMBER() OVER (PARTITION BY _tmpUnit.UnitId, ObjectLink_PriceListItem_Goods.ChildObjectId ORDER BY ObjectHistory_PriceListItem.StartDate ASC)  AS Ord_start
                                      -- № п/п
                                    , ROW_NUMBER() OVER (PARTITION BY _tmpUnit.UnitId, ObjectLink_PriceListItem_Goods.ChildObjectId ORDER BY ObjectHistory_PriceListItem.StartDate DESC) AS Ord_end
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
                                    LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                 ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                                    LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                                                ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                               AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                               WHERE zc_Enum_GlobalConst_isTerry() = FALSE
                              )
     -- первая цена из прайса
   , tmpPriceList_fp AS (SELECT tmpPriceList_all.UnitId
                              , tmpPriceList_all.GoodsId
                              , tmpPriceList_all.OperPriceList
                              , tmpPriceList_all.CurrencyId_pl
                         FROM tmpPriceList_all
                         WHERE tmpPriceList_all.Ord_start     = 1 -- первая
                           AND tmpPriceList_all.OperPriceList > 0
                        )
        -- Последняя цена из Прайс-листа
      , tmpPriceList AS (SELECT tmpPriceList_all.UnitId
                              , tmpPriceList_all.GoodsId
                              , tmpPriceList_all.OperPriceList
                              , tmpPriceList_all.CurrencyId_pl
                         FROM tmpPriceList_all
                         WHERE tmpPriceList_all.Ord_end       = 1 -- последняя
                           AND tmpPriceList_all.OperPriceList > 0
                        )
     -- Остатки + Партии
   , tmpContainer_all AS (SELECT Container.WhereObjectId                                   AS UnitId
                               , Container.ObjectId                                        AS GoodsId
                                 -- Кол-во - остаток в магазине
                               , CASE WHEN CLO_Client.ContainerId IS NULL THEN Container.Amount ELSE 0 END AS Remains
                                 -- Кол-во - остаток с учетом долга
                               , COALESCE (Container.Amount, 0)                                            AS RemainsAll
                                 --
                               , ObjectLink_Partner_Period.ChildObjectId AS PeriodId --url
                               , Object_PartionGoods.BrandId                         --url    ---name
                               , Object_PartionGoods.PeriodYear                      --url
                               , Object_PartionGoods.PartnerId                       --url
                               , Object_PartionGoods.GoodsSizeId       -- SizeId
                               , Object_PartionGoods.GoodsGroupId      -- categoryId
                               , Object_PartionGoods.LabelId           -- description
                               , Object_PartionGoods.GoodsInfoId       --
                               , Object_PartionGoods.CurrencyId        -- currencyId ????
                          FROM Container
                               INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                               INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                             AND Object_PartionGoods.GoodsId        = Container.ObjectId
                                                             -- !!! для теста - PREMIATA Весна-Лето 2020
                                                             -- AND Object_PartionGoods.PartnerId      = 25386
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                                    ON ObjectLink_Partner_Period.ObjectId = Object_PartionGoods.PartnerId
                                                   AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
                               -- долг клиента
                               LEFT JOIN ContainerLinkObject AS CLO_Client
                                                             ON CLO_Client.ContainerId = Container.Id
                                                            AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                          WHERE Container.DescId = zc_Container_Count()
                            AND (Container.Amount > 0)
                          /*AND (Object_PartionGoods.PeriodYear > 2020
                                 -- Весна-Лето
                              OR (Object_PartionGoods.PeriodYear = 2020 AND ObjectLink_Partner_Period.ChildObjectId = 1074)
                                )*/
                         -- AND CLO_Client.ContainerId IS NULL
                         -- LIMIT 1
                         )
     -- сезонная скидка
   , tmpDiscountList AS (SELECT DISTINCT tmpContainer_all.UnitId, tmpContainer_all.GoodsId FROM tmpContainer_all)
   , tmpOL1 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpContainer_all.GoodsId FROM tmpContainer_all)
                                           AND ObjectLink.DescId        = zc_ObjectLink_DiscountPeriodItem_Goods()
               )
   , tmpOL2 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpOL1.ObjectId FROM tmpOL1)
                                           AND ObjectLink.DescId   = zc_ObjectLink_DiscountPeriodItem_Unit()
               )
     -- сезонная скидка
   , tmpDiscount AS (SELECT ObjectLink_DiscountPeriodItem_Unit.ChildObjectId      AS UnitId
                          , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId     AS GoodsId
                          , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS DiscountTax
                     FROM tmpDiscountList
                          INNER JOIN tmpOL1 AS ObjectLink_DiscountPeriodItem_Goods
                                                ON ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = tmpDiscountList.GoodsId
                          INNER JOIN tmpOL2 AS ObjectLink_DiscountPeriodItem_Unit
                                                ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                               AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = tmpDiscountList.UnitId
                          INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                   ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                  AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                  -- !!! последняя скидка!!!
                                                  AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                       ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                      AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                    )
     -- Остатки + Партии
   , tmpContainer AS (SELECT tmpContainer_all.UnitId
                           , tmpContainer_all.GoodsId
                             -- Кол-во - остаток в магазине
                           , tmpContainer_all.Remains
                             -- Кол-во - остаток с учетом долга
                           , tmpContainer_all.RemainsAll
                             --
                           , tmpContainer_all.PeriodId --url
                           , tmpContainer_all.BrandId                         --url    ---name
                           , tmpContainer_all.PeriodYear                      --url
                           , tmpContainer_all.PartnerId                       --url
                           , tmpContainer_all.GoodsSizeId       -- SizeId
                           , tmpContainer_all.GoodsGroupId      -- categoryId
                           , tmpContainer_all.LabelId           -- description
                           , tmpContainer_all.GoodsInfoId       -- 
                           , tmpContainer_all.CurrencyId        -- currencyId ????

                             -- currencyId - первая цена
                           , COALESCE (tmpPriceList_fp.CurrencyId_pl, tmpPriceList_fp_unit.CurrencyId_pl, 0) AS CurrencyId_pl
                             -- первая цена
                           , COALESCE (tmpPriceList_fp.OperPriceList, tmpPriceList_fp_unit.OperPriceList, 0) AS OperPriceList

                             -- currencyId - последняя цена
                           , COALESCE (tmpPriceList.CurrencyId_pl, 0) AS CurrencyId_pl_curr
                             -- последняя цена
                           , COALESCE (tmpPriceList.OperPriceList, 0) AS OperPriceList_curr

                            -- % Сезонной скидки !!!для последней цены!!! НА zc_DateEnd
                           , COALESCE (tmpDiscount.DiscountTax, 0)       AS DiscountTax

                      FROM tmpContainer_all
                           -- магазин PODIUM
                           LEFT JOIN (SELECT DISTINCT tmpContainer_all.UnitId, tmpContainer_all.GoodsId
                                      FROM tmpContainer_all
                                      WHERE tmpContainer_all.UnitId = 6318
                                        -- если есть остаток
                                        AND tmpContainer_all.Remains > 0
                                     ) AS tmpContainer_all_podium ON tmpContainer_all_podium.GoodsId = tmpContainer_all.GoodsId
                           -- первая цена - в магазине
                           LEFT JOIN tmpPriceList_fp AS tmpPriceList_fp_unit
                                                     ON tmpPriceList_fp_unit.UnitId  = tmpContainer_all.UnitId
                                                    AND tmpPriceList_fp_unit.GoodsId = tmpContainer_all.GoodsId

                           -- первая цена - всегда в PODIUM
                           LEFT JOIN tmpPriceList_fp ON tmpPriceList_fp.UnitId  = 6318 -- COALESCE (tmpContainer_all_podium.UnitId,  tmpContainer_all.UnitId)
                                                    AND tmpPriceList_fp.GoodsId = tmpContainer_all.GoodsId
                         -- первая цена - если есть остаток в PODIUM, тогда по нему
                         --LEFT JOIN tmpPriceList_fp ON tmpPriceList_fp.UnitId  = COALESCE (tmpContainer_all_podium.UnitId, tmpContainer_all.UnitId)
                         --                         AND tmpPriceList_fp.GoodsId = tmpContainer_all.GoodsId

                           -- последняя цена из Прайс-листа - если есть остаток в PODIUM, тогда по нему
                           LEFT JOIN tmpPriceList ON tmpPriceList.UnitId  = COALESCE (tmpContainer_all_podium.UnitId, tmpContainer_all.UnitId)
                                                 AND tmpPriceList.GoodsId = tmpContainer_all.GoodsId
                           -- сезонная скидка - !!!для последней цены!!!
                           LEFT JOIN tmpDiscount ON tmpDiscount.UnitId  = COALESCE (tmpContainer_all_podium.UnitId, tmpContainer_all.UnitId)
                                                AND tmpDiscount.GoodsId = tmpContainer_all.GoodsId
                     )
      -- курсы
    , tmpCurrency AS (SELECT lfSelect.*
                      FROM Object
                           CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate      := CURRENT_DATE
                                                                       , inCurrencyFromId:= zc_Currency_Basis()
                                                                       , inCurrencyToId  := Object.Id
                                                                        ) AS lfSelect
                      WHERE Object.DescId = zc_Object_Currency()
                     )
     -- Результат
     SELECT tmpContainer.UnitId
          , Object_Unit.ValueData                                   AS UnitName
          , Object_Goods.Id                                         AS GoodsId
          , Object_Goods.ObjectCode                                 AS GoodsCode
          , Object_Goods.ValueData                                  AS GoodsName           -- артикул
          , zfStrToXmlStr (Object_Label.ValueData)      :: TVarChar AS LabelName           -- description
          , zfStrToXmlStr (Object_GoodsInfo.ValueData)  :: TVarChar AS GoodsInfoName       -- 
          , Object_GoodsGroup.Id                                    AS GoodsGroupId        -- categoryId
          , zfStrToXmlStr (Object_GoodsGroup.ValueData) :: TVarChar AS GoodsGroupName      -- categoryId
          , Object_Parent.Id                                        AS GoodsGroupId_parent -- categoryId
          , zfStrToXmlStr (Object_Partner.ValueData)    :: TVarChar AS PartnerName
          , zfStrToXmlStr (Object_Brand.ValueData)      :: TVarChar AS BrandName
          , Object_Period.ValueData                                 AS PeriodName
          , tmpContainer.PeriodYear                                 AS PeriodYear
          , Object_GoodsSize.ValueData                              AS SizeName

          , Object_Currency.ValueData                               AS CurrencyName
          , Object_Currency_curr.ValueData                          AS CurrencyName_curr

          , tmpContainer.Remains                                    AS Amount

            -- первая цена
          , tmpContainer.OperPriceList      AS OperPriceList
            -- последняя цена
          , tmpContainer.OperPriceList_curr AS OperPriceList_curr

            -- первая цена в грн
          , CAST (tmpContainer.OperPriceList
                 * CASE WHEN tmpContainer.CurrencyId_pl = zc_Currency_Basis() THEN 1 ELSE tmpCurrency.Amount / COALESCE (tmpCurrency.ParValue, 1)
                   END AS NUMERIC (16, 0)) AS OperPriceList_grn
            -- последняя цена в грн
          , CAST (tmpContainer.OperPriceList_curr
                 * CASE WHEN tmpContainer.CurrencyId_pl_curr = zc_Currency_Basis() THEN 1 ELSE tmpCurrency_curr.Amount / COALESCE (tmpCurrency_curr.ParValue, 1)
                   END AS NUMERIC (16, 0)) AS OperPriceList_grn_curr

            -- последняя цена в грн с учетом сезонной скидки
          , CAST (tmpContainer.OperPriceList_curr
                 * CASE WHEN tmpContainer.CurrencyId_pl_curr = zc_Currency_Basis() THEN 1 ELSE tmpCurrency_curr.Amount / COALESCE (tmpCurrency_curr.ParValue, 1)
                   END * (1 - tmpContainer.DiscountTax / 100) AS NUMERIC (16, 0)) AS OperPriceList_grn_curr_disc

           -- курс валют - первая цена
          , tmpCurrency.Amount / COALESCE (tmpCurrency.ParValue, 1) AS AmountCurrency
           -- курс валют - последняя цена
          , tmpCurrency_curr.Amount / COALESCE (tmpCurrency_curr.ParValue, 1) AS AmountCurrency_curr

           -- % Сезонной скидки !!!НА!!! zc_DateEnd
          , tmpContainer.DiscountTax

     FROM tmpContainer
          LEFT JOIN Object AS Object_Unit       ON Object_Unit.Id       = tmpContainer.UnitId
          LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id      = tmpContainer.GoodsId
          LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id    = tmpContainer.PartnerId
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpContainer.GoodsGroupId
          LEFT JOIN Object AS Object_Label      ON Object_Label.Id      = tmpContainer.LabelId
          LEFT JOIN Object AS Object_GoodsInfo  ON Object_GoodsInfo.Id  = tmpContainer.GoodsInfoId
          LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpContainer.GoodsSizeId
          LEFT JOIN Object AS Object_Brand      ON Object_Brand.Id      = tmpContainer.BrandId
          LEFT JOIN Object AS Object_Period     ON Object_Period.Id     = tmpContainer.PeriodId

          LEFT JOIN Object AS Object_Currency      ON Object_Currency.Id      = tmpContainer.CurrencyId_pl
          LEFT JOIN Object AS Object_Currency_curr ON Object_Currency_curr.Id = tmpContainer.CurrencyId_pl_curr

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                               ON ObjectLink_GoodsGroup_Parent.ObjectId = tmpContainer.GoodsGroupId
                              AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

          LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyToId = tmpContainer.CurrencyId_pl
          LEFT JOIN tmpCurrency AS tmpCurrency_curr ON tmpCurrency_curr.CurrencyToId = tmpContainer.CurrencyId_pl_curr

          LEFT JOIN tmpDiscount ON tmpDiscount.UnitId  = tmpContainer.UnitId
                               AND tmpDiscount.GoodsId = tmpContainer.GoodsId
     WHERE tmpContainer.Remains > 0
     ;

     -- Таблица для результата
     CREATE TEMP TABLE _Result (Num Serial , RowData TBlob) ON COMMIT DROP;

     -- первые строчки XML
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-8"?>');
     INSERT INTO _Result(RowData) VALUES ('<!DOCTYPE yml_catalog SYSTEM "shops.dtd">');
     INSERT INTO _Result(RowData) VALUES ('<yml_catalog date="'||CURRENT_TIMESTAMP||'">');


     -- данные магазина
     INSERT INTO _Result(RowData) VALUES ('<shop>');
     INSERT INTO _Result(RowData)
     SELECT '<name>' ||_tmpUnit.UnitName||'</name>'
         || '<company>' ||_tmpUnit.UnitName||'</company>'
         ||CASE WHEN COALESCE (_tmpUnit.Phone,'') <>'' THEN '<phone>' ||_tmpUnit.Phone||'</phone>' ELSE '' END
         ||'<currencies>'
           ||'<currency rate="1" id="'||_tmpUnit.CurrencyName_pl||'"/>'
         ||'</currencies>'
     FROM _tmpUnit
     -- магазин PODIUM
     WHERE _tmpUnit.UnitId = 6318
    ;

     -- данные Категорий - Группы товаров
     INSERT INTO _Result(RowData) VALUES ('<categories>');
     INSERT INTO _Result(RowData)
     SELECT '<category id="' || tmp.GoodsGroupId || '"'
         || CASE WHEN COALESCE (tmp.GoodsGroupId_parent,'') <> '' THEN ' parentId="' || tmp.GoodsGroupId_parent || '"' ELSE '' END
         || '>'||tmp.GoodsGroupName||'</category>'
         --||'</categories>'
     FROM (SELECT DISTINCT
                  _tmpData.GoodsGroupId :: TVarChar
                , _tmpData.GoodsGroupName
                , _tmpData.GoodsGroupId_parent :: TVarChar
           FROM _tmpData
          UNION ALL
           SELECT DISTINCT
                  Object_Parent.Id :: TVarChar AS GoodsGroupId
                , Object_Parent.ValueData AS GoodsGroupName
                , ObjectLink_GoodsGroup_Parent.ChildObjectId :: TVarChar AS GoodsGroupId_parent
           FROM _tmpData
                INNER JOIN Object AS Object_Parent ON Object_Parent.Id = _tmpData.GoodsGroupId_parent
                INNER JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                      ON ObjectLink_GoodsGroup_Parent.ObjectId = _tmpData.GoodsGroupId_parent
                                     AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
           ) AS tmp ;
     INSERT INTO _Result(RowData) VALUES ('</categories>');

     -- данные остатков
     INSERT INTO _Result(RowData) VALUES ('<offers>');
     --
     INSERT INTO _Result(RowData)
     SELECT '<offer id="' || COALESCE (tmp.GoodsCode, 0) :: TVarChar || '"'
         || CASE WHEN COALESCE (tmp.Amount, 0) <> 0 THEN ' available="true">' ELSE ' available="false">' END
       --|| '<unitname>'||tmp.UnitName||'</unitname>'
       --|| '<labelname>'||tmp.LabelName||'</labelname>'
         || '<sizename>'|| COALESCE (tmp.SizeName, '') ||'</sizename>'
         --|| '<url>'||tmp.PartnerName||'</url>'
       --|| '<url>http://podium-shop.com/product/premiata_1o/</url>'

             -- первая цена
         || '<price>'|| CASE WHEN tmp.DiscountTax > 0 AND 1=0 THEN COALESCE (tmp.OperPriceList_curr, 0) ELSE COALESCE (tmp.OperPriceList, 0) END :: TVarChar ||'</price>'
             -- первая цена в грн
         || '<priceGrn>'|| CASE WHEN tmp.DiscountTax > 0 AND 1=0 THEN COALESCE (tmp.OperPriceList_grn_curr, 0) ELSE COALESCE (tmp.OperPriceList_grn, 0) END :: TVarChar ||'</priceGrn>'

             -- ***последняя цена
       --|| '<price_next>'|| COALESCE (tmp.OperPriceList_curr, 0) :: TVarChar ||'</price_next>'
             -- ***последняя цена в грн
         || '<priceGrn_next>'|| COALESCE (tmp.OperPriceList_grn_curr, 0) :: TVarChar ||'</priceGrn_next>'

             -- последняя цена в грн с учетом сезонной скидки
         || '<priceGrnDisc>'|| COALESCE (tmp.OperPriceList_grn_curr_disc, 0) :: TVarChar ||'</priceGrnDisc>'

             -- остаток
         || '<amount>'|| (COALESCE (tmp.Amount, 0)) :: TVarChar ||'</amount>'

             -- курс - первая цена
         || '<currencyId>'|| COALESCE (tmp.CurrencyName, '') || '</currencyId>'
         || '<amountCur>'|| COALESCE (tmp.AmountCurrency, 0) :: TVarChar ||'</amountCur>'

             -- курс - последняя цена
         || '<currencyId_next>'|| COALESCE (tmp.CurrencyName_curr, '') || '</currencyId_next>'
         || '<amountCur_next>'|| COALESCE (tmp.AmountCurrency_curr, 0) :: TVarChar ||'</amountCur_next>'

            -- % сез. скидки
         || '<discount>'|| COALESCE (tmp.DiscountTax, 0) :: TVarChar ||'</discount>'

         || '<vat>NO_VAT</vat>'
         || '<categoryId>'|| COALESCE (tmp.GoodsGroupId, 0) :: TVarChar ||'</categoryId>'
         || '<name>'|| COALESCE (tmp.BrandName, '') || '</name>'

         || CASE WHEN inSession = zfCalc_UserAdmin() THEN '<PeriodName>'|| COALESCE (tmp.PeriodName, '') || '</PeriodName>' ELSE '' END
         || CASE WHEN inSession = zfCalc_UserAdmin() THEN '<PeriodYear>'|| COALESCE (tmp.PeriodYear :: TVarChar, '') || '</PeriodYear>' ELSE '' END

         || CASE WHEN inSession = zfCalc_UserAdmin() THEN '<LabelName>'|| COALESCE (tmp.LabelName, '') || '</LabelName>' ELSE '' END
         || CASE WHEN inSession = zfCalc_UserAdmin() THEN '<GoodsInfoName>'|| COALESCE (tmp.GoodsInfoName, '') || '</GoodsInfoName>' ELSE '' END
         || CASE WHEN inSession = zfCalc_UserAdmin() THEN '<UnitName>'|| COALESCE (tmp.unitname, '') || '</UnitName>' ELSE '' END

         || '<description>'
         || '<![CDATA['|| COALESCE (tmp.LabelName, '') || ']]>'
         || '</description>'
         || '</offer>'

     FROM (--если inUnitId = 0 группируем товары вместе
           SELECT CASE WHEN inUnitId <> 0 OR inSession = zfCalc_UserAdmin() THEN _tmpData.UnitName ELSE '' END AS UnitName
                , _tmpData.GoodsCode
                , _tmpData.SizeName
                , _tmpData.GoodsGroupId
                , _tmpData.BrandName
                , _tmpData.PeriodName
                , _tmpData.PeriodYear
                , _tmpData.LabelName
                , _tmpData.GoodsInfoName

                  -- первая цена
                , _tmpData.OperPriceList
                  -- первая цена в грн
                , _tmpData.OperPriceList_grn

                 -- последняя цена
                , _tmpData.OperPriceList_curr
                  -- последняя цена в грн
                , _tmpData.OperPriceList_grn_curr
                  -- последняя цена в грн с учетом сезонной скидки
                , _tmpData.OperPriceList_grn_curr_disc

                 -- курс валют - первая цена
                , _tmpData.CurrencyName
                , _tmpData.AmountCurrency
                  -- курс валют - последняя цена
                , _tmpData.CurrencyName_curr
                , _tmpData.AmountCurrency_curr

                , _tmpData.DiscountTax

                , SUM (_tmpData.Amount) AS Amount

           FROM _tmpData
           WHERE (_tmpData.UnitId = inUnitId OR inUnitId = 0)
           GROUP BY CASE WHEN inUnitId <> 0 OR inSession = zfCalc_UserAdmin() THEN _tmpData.UnitName ELSE '' END
                  , _tmpData.GoodsCode
                  , _tmpData.SizeName
                  , _tmpData.GoodsGroupId
                  , _tmpData.BrandName
                  , _tmpData.PeriodName
                  , _tmpData.PeriodYear
                  , _tmpData.LabelName
                  , _tmpData.GoodsInfoName

                    -- первая цена
                  , _tmpData.OperPriceList
                    -- первая цена в грн
                  , _tmpData.OperPriceList_grn

                   -- последняя цена
                  , _tmpData.OperPriceList_curr
                    -- последняя цена в грн
                  , _tmpData.OperPriceList_grn_curr
                    -- последняя цена в грн с учетом сезонной скидки
                  , _tmpData.OperPriceList_grn_curr_disc

                   -- курс валют - первая цена
                  , _tmpData.CurrencyName
                  , _tmpData.AmountCurrency
                    -- курс валют - последняя цена
                  , _tmpData.CurrencyName_curr
                  , _tmpData.AmountCurrency_curr

                  , _tmpData.DiscountTax
           ) AS tmp
     ORDER BY tmp.GoodsCode :: Integer
     ;

     -- последнии строчки XML
     INSERT INTO _Result(RowData) VALUES ('</offers>');
     INSERT INTO _Result(RowData) VALUES ('</shop>');
     INSERT INTO _Result(RowData) VALUES ('</yml_catalog>');

     -- Результат
     RETURN QUERY
        SELECT _Result.RowData
--           , _Result.Num
        FROM _Result -- WHERE _Result.RowData IS NULL
        ORDER BY _Result.Num
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.20         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsRemains_File (inUnitId:= 0, inSession:= zfCalc_UserAdmin())
