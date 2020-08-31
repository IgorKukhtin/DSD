-- Function: gpSelect_GoodsRemains_File(Integer, tvarchar)

-- DROP FUNCTION gpSelect_GoodsRemains_File (Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsRemains_File(
    IN inUnitId               Integer   , --�������������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);

     --������ �������������
     CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitName TVarChar, PriceListId Integer, CurrencyId_pl Integer, CurrencyName_pl TVarChar, Phone TVarChar) ON COMMIT DROP;
     INSERT INTO _tmpUnit (UnitId, UnitName, PriceListId, CurrencyId_pl, CurrencyName_pl, Phone)
          SELECT Object_Unit.Id
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
              WHERE Object_Unit.Id = inUnitId;

     -- ������� ��������
     CREATE TEMP TABLE _tmpData (UnitId Integer, GoodsId Integer, GoodsCode TVarChar, GoodsName TVarChar, LabelName TVarChar
                               , GoodsGroupCode TVarChar, GoodsGroupName TVarChar, ParentCode TVarChar, PartnerName TVarChar
                               , BrandName TVarChar, PeriodName TVarChar, PeriodYear TVarChar, SizeName TVarChar, CurrencyName TVarChar, Amount TFloat, OperPriceList TFloat) ON COMMIT DROP;
   
     INSERT INTO _tmpData (UnitId, GoodsId, GoodsCode, GoodsName, LabelName, GoodsGroupCode, GoodsGroupName, ParentCode
                         , PartnerName, BrandName, PeriodName, PeriodYear, SizeName, CurrencyName, Amount, OperPriceList)
     WITH
     -- ��������� ���� �� �����-�����
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
                                                  -- ��������� ����
                                                  AND ObjectHistory_PriceListItem.EndDate  = zc_DateEnd()
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                        ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                       AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                           LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                                       ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                      AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                      WHERE zc_Enum_GlobalConst_isTerry() = FALSE
                     )
     -- ������� + ������
   , tmpContainer AS (SELECT Container.WhereObjectId                                   AS UnitId
                           , Container.ObjectId                                        AS GoodsId    -- Id ��� ������
                           , CASE WHEN CLO_Client.ContainerId IS NULL THEN Container.Amount ELSE 0 END AS Remains    -- ���-�� - ������� � ��������  --Amount
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
                           , COALESCE (tmpPriceList.CurrencyId_pl, zc_Currency_Basis())               AS CurrencyId_pl   ---currencyId
                      FROM Container
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                         AND Object_PartionGoods.GoodsId        = Container.ObjectId
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                                ON ObjectLink_Partner_Period.ObjectId = Object_PartionGoods.PartnerId
                                               AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                           -- ���� �� �����-�����
                           LEFT JOIN tmpPriceList ON tmpPriceList.UnitId  = Container.WhereObjectId
                                                 AND tmpPriceList.GoodsId = Container.ObjectId

                      WHERE Container.DescId = zc_Container_Count()
                        AND Container.WhereObjectId = inUnitId
                        AND (Container.Amount <> 0)
                     -- LIMIT 1
                      /*  AND (ObjectLink_Partner_Period.ChildObjectId = inPeriodId   OR inPeriodId  = 0)
                        AND (Object_PartionGoods.BrandId             = inBrandId    OR inBrandId   = 0)
                        AND (Object_PartionGoods.PartnerId           = inPartnerId  OR inPartnerId = 0)
                        AND ((Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear) OR inIsYear = FALSE)
                      */
                     )
     SELECT tmpContainer.UnitId
          , Object_Goods.Id                AS GoodsId
          , Object_Goods.ObjectCode        AS GoodsCode
          , Object_Goods.ValueData         AS GoodsName       -- �������
          , Object_Label.ValueData         AS LabelName       -- description
          , Object_GoodsGroup.ObjectCode   AS GoodsGroupCode  -- categoryId
          , Object_GoodsGroup.ValueData    AS GoodsGroupName  -- categoryId
          , Object_Parent.ObjectCode       AS ParentCode      -- categoryId
          , Object_Partner.ValueData       AS PartnerName
          , Object_Brand.ValueData         AS BrandName
          , Object_Period.ValueData        AS PeriodName
          , tmpContainer.PeriodYear        AS PeriodYear
          , Object_GoodsSize.ValueData     AS SizeName
          , Object_Currency.ValueData      AS CurrencyName
          , tmpContainer.Remains           AS Amount
          , tmpContainer.OperPriceList
          
     FROM tmpContainer
          LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id      = tmpContainer.GoodsId
          LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id    = tmpContainer.PartnerId
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpContainer.GoodsGroupId
          LEFT JOIN Object AS Object_Label      ON Object_Label.Id      = tmpContainer.LabelId
          LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpContainer.GoodsSizeId
          LEFT JOIN Object AS Object_Brand      ON Object_Brand.Id      = tmpContainer.BrandId
          LEFT JOIN Object AS Object_Period     ON Object_Period.Id     = tmpContainer.PeriodId
          LEFT JOIN Object AS Object_Currency   ON Object_Currency.Id   = tmpContainer.CurrencyId_pl

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                               ON ObjectLink_Unit_Parent.ObjectId = tmpContainer.GoodsGroupId
                              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
     ;

     -- ������� ��� ����������
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;

     -- ������ ������� XML
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-8"?>');
     INSERT INTO _Result(RowData) VALUES ('<!DOCTYPE yml_catalog SYSTEM "shops.dtd">');
     INSERT INTO _Result(RowData) VALUES ('<yml_catalog date="'||CURRENT_TIMESTAMP||'">');

     -- ������ ��������
     INSERT INTO _Result(RowData) VALUES ('<shop>');
     INSERT INTO _Result(RowData)
     SELECT '<name>' ||_tmpUnit.UnitName||'</name>'
         || '<company>' ||_tmpUnit.UnitName||'</company>'
         ||CASE WHEN COALESCE (_tmpUnit.Phone,'') <>'' THEN '<phone>' ||_tmpUnit.Phone||'</phone>' ELSE '' END
         ||'<currencies>' 
           ||'<currency rate="1" id="'||_tmpUnit.CurrencyName_pl||'"/>'
         ||'</currencies>' 
     FROM _tmpUnit;

     -- ������ ��������� - ������ �������
     INSERT INTO _Result(RowData) VALUES ('<categories>');
     INSERT INTO _Result(RowData)
     SELECT '<category id="' ||tmp.GoodsGroupCode
         || CASE WHEN COALESCE (tmp.ParentCode,'') <> '' THEN '" parentId="'||tmp.ParentCode ELSE '' END
         || '">'||tmp.GoodsGroupName||'</category>'
         --||'</categories>'
     FROM (SELECT DISTINCT 
                  _tmpData.GoodsGroupCode
                , _tmpData.GoodsGroupName
                , _tmpData.ParentCode::TVarChar
           FROM _tmpData
           ) AS tmp ;
     INSERT INTO _Result(RowData) VALUES ('</categories>');

     -- ������ ��������
     INSERT INTO _Result(RowData) VALUES ('<offers>');
     INSERT INTO _Result(RowData)
     SELECT '<offer id="' ||tmp.GoodsName
         || CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN '" available="true">' ELSE '" available="false">' END
         --|| '<url>'||tmp.PartnerName||'</url>' 
         || '<url>http://podium-shop.com/product/premiata_1o/</url>'
         || '<price>'||tmp.OperPriceList||'</price>'
         || '<amount>'||tmp.Amount||'</amount>'
         || '<currencyId>'||tmp.CurrencyName||'</currencyId>'
         || '<vat>NO_VAT</vat>'
         || '<categoryId>'||tmp.GoodsGroupCode||'</categoryId>'
         || '<name>'||tmp.BrandName||'</name>'
         || '<description>'
         || '<![CDATA['||tmp.LabelName||']]>'
         || '</description>'
         || '</offer>'
     FROM _tmpData AS tmp ;
 
     --��������� ������� XML
     INSERT INTO _Result(RowData) VALUES ('</offers>');
     INSERT INTO _Result(RowData) VALUES ('</shop>');
     INSERT INTO _Result(RowData) VALUES ('</yml_catalog>');


     -- ���������
     RETURN QUERY
        SELECT _Result.RowData FROM _Result;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.07.20         *
*/

-- ����
-- SELECT * FROM gpSelect_GoodsRemains_File (inUnitId:= 6318, inSession:= zfCalc_UserAdmin())