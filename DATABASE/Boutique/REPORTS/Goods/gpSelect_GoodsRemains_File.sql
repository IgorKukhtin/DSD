-- Function: gpSelect_GoodsRemains_File (Integer, TVarChar)

DROP FUNCTION gpSelect_GoodsRemains_File (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsRemains_File(
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
                AND (Object_Unit.Id = inUnitId OR inUnitId = 0)
             ;

/*
+ цена в грн
- цена в грн с учетом сезонной скидки
+ % сезонной скидки
+ цена в валюте
+ курс
*/

     -- таблица остатков
     CREATE TEMP TABLE _tmpData (UnitId Integer, UnitName TVarChar, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, LabelName TVarChar
                               , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupId_parent Integer, PartnerName TVarChar
                               , BrandName TVarChar, PeriodName TVarChar, PeriodYear TVarChar, SizeName TVarChar, CurrencyName TVarChar
                               , Amount TFloat, OperPriceList TFloat
                               , OperPriceList_grn TFloat, OperPriceList_grn_disc TFloat, AmountCurrency TFloat, DiscountTax TFloat) ON COMMIT DROP;

     INSERT INTO _tmpData (UnitId, UnitName, GoodsId, GoodsCode, GoodsName, LabelName, GoodsGroupId, GoodsGroupName, GoodsGroupId_parent
                         , PartnerName, BrandName, PeriodName, PeriodYear, SizeName, CurrencyName, Amount, OperPriceList
                         , OperPriceList_grn, OperPriceList_grn_disc, AmountCurrency, DiscountTax)
     WITH
     -- Последняя цена из Прайс-листа
     tmpPriceList AS (SELECT _tmpUnit.UnitId                                  AS UnitId
                           , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS OperPriceList
                           , COALESCE (ObjectHistoryLink_Currency.ObjectId, _tmpUnit.CurrencyId_pl) AS CurrencyId_pl
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
                                                  AND ObjectHistory_PriceListItem.EndDate  = zc_DateEnd()
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                        ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                       AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                           LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                                       ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                      AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                      WHERE zc_Enum_GlobalConst_isTerry() = FALSE
                     )
     -- Остатки + Партии - PREMIATA Весна-Лето 2020
   , tmpContainer AS (SELECT Container.WhereObjectId                                   AS UnitId
                           , Container.ObjectId                                        AS GoodsId    -- Id код товара
                           , CASE WHEN CLO_Client.ContainerId IS NULL THEN Container.Amount ELSE 0 END AS Remains    -- Кол-во - остаток в магазине  --Amount
                           , COALESCE (Container.Amount, 0)                                            AS RemainsAll
                           , ObjectLink_Partner_Period.ChildObjectId AS PeriodId --url
                           , Object_PartionGoods.BrandId                         --url    ---name
                           , Object_PartionGoods.PeriodYear                      --url
                           , Object_PartionGoods.PartnerId                       --url
                           , Object_PartionGoods.GoodsSizeId       -- SizeId
                           , Object_PartionGoods.GoodsGroupId      -- categoryId
                           , Object_PartionGoods.LabelId           --description
                           , Object_PartionGoods.CurrencyId        --currencyId ????
                           , COALESCE (tmpPriceList.OperPriceList, Object_PartionGoods.OperPriceList) AS OperPriceList   --price
                           , Object_PartionGoods.OperPriceList                                        AS OperPriceList_partion
                           , COALESCE (tmpPriceList.CurrencyId_pl, zc_Currency_Basis())               AS CurrencyId_pl   ---currencyId
                      FROM Container
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                         AND Object_PartionGoods.GoodsId        = Container.ObjectId
                                                         -- !!! PREMIATA Весна-Лето 2020
                                                         --AND Object_PartionGoods.PartnerId      = 25386
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                                ON ObjectLink_Partner_Period.ObjectId = Object_PartionGoods.PartnerId
                                               AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                           -- цена из Прайс-листа
                           LEFT JOIN tmpPriceList ON tmpPriceList.UnitId  = Container.WhereObjectId
                                                 AND tmpPriceList.GoodsId = Container.ObjectId

                      WHERE Container.DescId = zc_Container_Count()
                        AND (Container.Amount > 0)
                     -- AND CLO_Client.ContainerId IS NULL
                     -- LIMIT 1
                      /*  AND (ObjectLink_Partner_Period.ChildObjectId = inPeriodId   OR inPeriodId  = 0)
                        AND (Object_PartionGoods.BrandId             = inBrandId    OR inBrandId   = 0)
                        AND (Object_PartionGoods.PartnerId           = inPartnerId  OR inPartnerId = 0)
                        AND ((Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear) OR inIsYear = FALSE)
                      */
                     )

    , tmpCurrency AS (SELECT lfSelect.*
                      FROM Object
                           CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate      := CURRENT_DATE
                                                                       , inCurrencyFromId:= zc_Currency_Basis()
                                                                       , inCurrencyToId  := Object.Id
                                                                        ) AS lfSelect
                      WHERE Object.DescId = zc_Object_Currency()
                     )

    --- сезонная скидка
   , tmpDiscountList AS (SELECT DISTINCT tmpContainer.UnitId, tmpContainer.GoodsId FROM tmpContainer)

   , tmpOL1 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpContainer.GoodsId FROM tmpContainer)
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
                          INNER JOIN tmpOL2 AS ObjectLink_DiscountPeriodItem_Unit
                                                ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                               AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = tmpDiscountList.UnitId
                          INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                   ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                  AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                  AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                       ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                      AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                    )


     SELECT tmpContainer.UnitId
          , Object_Unit.ValueData                                   AS UnitName
          , Object_Goods.Id                                         AS GoodsId
          , Object_Goods.ObjectCode                                 AS GoodsCode
          , Object_Goods.ValueData                                  AS GoodsName           -- артикул
          , zfStrToXmlStr (Object_Label.ValueData)      :: TVarChar AS LabelName           -- description
          , Object_GoodsGroup.Id                                    AS GoodsGroupId        -- categoryId
          , zfStrToXmlStr (Object_GoodsGroup.ValueData) :: TVarChar AS GoodsGroupName      -- categoryId
          , Object_Parent.Id                                        AS GoodsGroupId_parent -- categoryId
          , zfStrToXmlStr (Object_Partner.ValueData)    :: TVarChar AS PartnerName
          , zfStrToXmlStr (Object_Brand.ValueData)      :: TVarChar AS BrandName
          , Object_Period.ValueData                                 AS PeriodName
          , tmpContainer.PeriodYear                                 AS PeriodYear
          , Object_GoodsSize.ValueData                              AS SizeName
          , Object_Currency.ValueData                               AS CurrencyName
          , tmpContainer.Remains                                    AS Amount
            -- цена - если % сез. скидки = 0 берем цену из партии, а ценой со скидкой будет текущая
          , CASE WHEN COALESCE (tmpDiscount.DiscountTax, 0) <> 0 THEN tmpContainer.OperPriceList ELSE tmpContainer.OperPriceList_partion END AS OperPriceList
           -- цена в грн
          , CASE WHEN COALESCE (tmpDiscount.DiscountTax, 0) <> 0 THEN tmpContainer.OperPriceList ELSE tmpContainer.OperPriceList_partion END
                 * CASE WHEN tmpContainer.CurrencyId_pl = zc_Currency_Basis() THEN 1 ELSE tmpCurrency.Amount / COALESCE (tmpCurrency.ParValue, 1) END AS OperPriceList_grn
          -- цены в грн с учетом сезонной скидки
          , CAST (tmpContainer.OperPriceList * CASE WHEN tmpContainer.CurrencyId_pl = zc_Currency_Basis() THEN 1 ELSE tmpCurrency.Amount / COALESCE (tmpCurrency.ParValue,1) END
               * (1 - COALESCE (tmpDiscount.DiscountTax, 0) / 100) AS NUMERIC (16, 0)) :: TFloat AS OperPriceList_grn_disc
           -- курс валюты
          , tmpCurrency.Amount / COALESCE (tmpCurrency.ParValue, 1) AS AmountCurrency
           -- % Сезонной скидки !!!НА!!! zc_DateEnd
          , COALESCE (tmpDiscount.DiscountTax, 0)         :: TFloat AS DiscountTax

     FROM tmpContainer
          LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id      = tmpContainer.GoodsId
          LEFT JOIN Object AS Object_Unit       ON Object_Unit.Id       = tmpContainer.UnitId
          LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id    = tmpContainer.PartnerId
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpContainer.GoodsGroupId
          LEFT JOIN Object AS Object_Label      ON Object_Label.Id      = tmpContainer.LabelId
          LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpContainer.GoodsSizeId
          LEFT JOIN Object AS Object_Brand      ON Object_Brand.Id      = tmpContainer.BrandId
          LEFT JOIN Object AS Object_Period     ON Object_Period.Id     = tmpContainer.PeriodId
          LEFT JOIN Object AS Object_Currency   ON Object_Currency.Id   = tmpContainer.CurrencyId_pl

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                               ON ObjectLink_GoodsGroup_Parent.ObjectId = tmpContainer.GoodsGroupId
                              AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

          LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyToId = tmpContainer.CurrencyId_pl

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
     INSERT INTO _Result(RowData)
     SELECT '<offer id="' || COALESCE (tmp.GoodsCode, 0) :: TVarChar || '"'
         || CASE WHEN COALESCE (tmp.Amount, 0) <> 0 THEN ' available="true">' ELSE ' available="false">' END
         || '<unitname>'||tmp.UnitName||'</unitname>'
       --|| '<labelname>'||tmp.LabelName||'</labelname>'
         || '<sizename>'|| COALESCE (tmp.SizeName, '') ||'</sizename>'
         --|| '<url>'||tmp.PartnerName||'</url>'
       --|| '<url>http://podium-shop.com/product/premiata_1o/</url>'
         || '<price>'|| COALESCE (tmp.OperPriceList, 0) :: TVarChar ||'</price>'                           -- цена в валюте
         || '<priceGrn>'|| COALESCE (tmp.OperPriceList_grn, 0) :: TVarChar ||'</priceGrn>'                 -- цена в грн
         || '<priceGrnDisc>'|| COALESCE (tmp.OperPriceList_grn_disc, 0) :: TVarChar ||'</priceGrnDisc>'    -- цена в грн с уч. скидки
         || '<amount>'|| COALESCE (tmp.Amount, 0) :: TVarChar ||'</amount>'                                -- остаток
         || '<currencyId>'|| COALESCE (tmp.CurrencyName, '') || '</currencyId>'
         || '<amountCur>'|| COALESCE (tmp.AmountCurrency, 0) :: TVarChar ||'</amountCur>'                  -- курс
         || '<discount>'|| COALESCE (tmp.DiscountTax, 0) :: TVarChar ||'</discount>'                       -- % сез. скидки
         || '<vat>NO_VAT</vat>'
         || '<categoryId>'|| COALESCE (tmp.GoodsGroupId, 0) :: TVarChar ||'</categoryId>'
         || '<name>'|| COALESCE (tmp.BrandName, '') || '</name>'
         || '<description>'
         || '<![CDATA['|| COALESCE (tmp.LabelName, '') || ']]>'
         || '</description>'
         || '</offer>'
     FROM _tmpData AS tmp
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
-- SELECT * FROM gpSelect_GoodsRemains_File (inUnitId:= 6318, inSession:= zfCalc_UserAdmin())
