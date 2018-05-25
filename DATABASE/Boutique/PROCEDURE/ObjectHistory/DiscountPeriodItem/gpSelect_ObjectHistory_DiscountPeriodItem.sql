-- Function: gpSelect_ObjectHistory_DiscountPeriodItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriodItem (Integer, Integer, Integer, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriodItem (Integer, Integer, Integer, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_DiscountPeriodItem(
    IN inUnitId             Integer   , -- �������������
    IN inBrandId            Integer   , -- �������� �����
    IN inPeriodId           Integer   , -- �����
    IN inOperDate           TDateTime , -- ���� ��������
    IN inStartYear          Integer   , -- ��� �
    IN inEndYear            Integer   , -- ��� ��
    IN inIsSize             Boolean   , -- �������� ������� ��������(��/���)
    IN inShowAll            Boolean   , --
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE  (  Id Integer , ObjectId Integer
                , StartDate TDateTime, EndDate TDateTime
                , ValueDiscount TFloat
                , InsertName TVarChar, UpdateName TVarChar
                , InsertDate TDateTime, UpdateDate TDateTime

                , PartnerName          TVarChar
                , UnitName_in          TVarChar
                , InvNumber_Partion    TVarChar
                , OperDate_Partion     TDateTime
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                , isErased Boolean
                , GroupNameFull        TVarChar
                , CurrencyName         TVarChar
                , OperPrice            TFloat
                , OperPriceList        TFloat
                , Remains              TFloat
                , AmountDebt           TFloat
                , RemainsAll           TFloat
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
                , GoodsSizeName        TVarChar
               )
AS
$BODY$
BEGIN

    -- !!!������!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;


    -- �������� ������
     RETURN QUERY
     WITH 
      tmpPartionGoods AS (SELECT Object_PartionGoods.MovementId
                               , Object_PartionGoods.MovementItemId  AS PartionId
                               , Object_PartionGoods.GoodsId
                               , Object_PartiONGoods.PartnerId
                               , Object_PartionGoods.UnitId
                               , Object_PartionGoods.OperDate
                               , Object_PartionGoods.CurrencyId
                               , Object_PartionGoods.OperPrice
                               , Object_PartionGoods.OperPriceList
                               , Object_PartionGoods.BrandId
                               , Object_PartionGoods.PeriodId
                               , Object_PartionGoods.PeriodYear
                               , Object_PartionGoods.FabrikaId
                               , Object_PartionGoods.GoodsGroupId
                               , Object_PartionGoods.MeasureId
                               , Object_PartionGoods.CompositionId
                               , Object_PartionGoods.GoodsInfoId
                               , Object_PartionGoods.LineFabricaId
                               , Object_PartionGoods.LabelId
                               , Object_PartionGoods.GoodsSizeId
                          FROM Object_PartionGoods
                          WHERE Object_PartionGoods.isErased    = FALSE
                            AND (Object_PartionGoods.BrandId    = inBrandId  OR inBrandId  = 0)
                            AND (Object_PartionGoods.PeriodId   = inPeriodId OR inPeriodId = 0)
                            AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                         )

      -- �������
    , tmpContainer AS (SELECT Container.PartionId     AS PartionId
                            , Container.ObjectId      AS GoodsId
                            , Container.WhereObjectId AS UnitId
                            , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS Amount
                            , SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS AmountDebt
                       FROM Container
                            LEFT JOIN ContainerLinkObject AS CLO_Client
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                       WHERE Container.DescId        = zc_Container_Count()
                        AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                       GROUP BY Container.PartionId
                              , Container.ObjectId
                              , Container.WhereObjectId
                      )

    , tmpGoods AS (SELECT tmpPartionGoods.MovementId
                        , tmpPartionGoods.GoodsId
                        , tmpPartionGoods.OperDate
                        , tmpPartionGoods.UnitId
                        , tmpPartionGoods.PartnerId
                        , tmpPartionGoods.CurrencyId
                        , tmpPartionGoods.OperPrice
                        , tmpPartionGoods.OperPriceList
                        , tmpPartionGoods.BrandId
                        , tmpPartionGoods.PeriodId
                        , tmpPartionGoods.PeriodYear
                        , tmpPartionGoods.FabrikaId
                        , tmpPartionGoods.GoodsGroupId
                        , tmpPartionGoods.MeasureId
                        , tmpPartionGoods.CompositionId
                        , tmpPartionGoods.GoodsInfoId
                        , tmpPartionGoods.LineFabricaId
                        , tmpPartionGoods.LabelId
                        , CASE WHEN inIsSize  = TRUE THEN Object_GoodsSize.Id ELSE 0 END GoodsSizeId
                        , STRING_AGG (Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData)  AS GoodsSizeName
                        
                        , SUM (COALESCE (tmpContainer.Amount, 0))        AS Remains
                        , SUM (COALESCE (tmpContainer.AmountDebt, 0))    AS AmountDebt
                   FROM tmpPartionGoods
                        LEFT JOIN tmpContainer ON tmpContainer.GoodsId   = tmpPartionGoods.GoodsId
                                              AND tmpContainer.PartionId = tmpPartionGoods.PartionId
                                              -- AND tmpContainer.UnitId    = tmpPartionGoods.UnitId
                        LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = tmpPartionGoods.GoodsSizeId
                   GROUP BY tmpPartionGoods.MovementId
                          , tmpPartionGoods.GoodsId
                          , tmpPartionGoods.OperDate
                          , tmpPartionGoods.UnitId
                          , tmpPartionGoods.PartnerId
                          , tmpPartionGoods.CurrencyId
                          , tmpPartionGoods.OperPrice
                          , tmpPartionGoods.OperPriceList
                          , tmpPartionGoods.BrandId
                          , tmpPartionGoods.PeriodId
                          , tmpPartionGoods.PeriodYear
                          , tmpPartionGoods.FabrikaId
                          , tmpPartionGoods.GoodsGroupId
                          , tmpPartionGoods.MeasureId
                          , tmpPartionGoods.CompositionId
                          , tmpPartionGoods.GoodsInfoId
                          , tmpPartionGoods.LineFabricaId
                          , tmpPartionGoods.LabelId
                          , CASE WHEN inIsSize  = TRUE THEN Object_GoodsSize.Id ELSE 0 END
                   HAVING SUM (COALESCE (tmpContainer.Amount, 0)) <> 0 
                       OR SUM (COALESCE (tmpContainer.AmountDebt, 0)) <> 0
                       OR inShowAll = TRUE
                   )
                   
    , tmpList AS (SELECT DISTINCT tmpGoods.GoodsId 
                  FROM tmpGoods
                  )
    
    , tmpDiscount AS (SELECT ObjectHistory_DiscountPeriodItem.Id        AS Id
                           , ObjectHistory_DiscountPeriodItem.ObjectId  AS ObjectId
                           , ObjectLink_Goods.ChildObjectId             AS GoodsId

                           , ObjectHistory_DiscountPeriodItem.StartDate
                           , ObjectHistory_DiscountPeriodItem.EndDate
                           , ObjectHistoryFloat_Value.ValueData        AS ValueDiscount

                      FROM ObjectLink AS ObjectLink_Unit
                           LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                ON ObjectLink_Goods.ObjectId = ObjectLink_Unit.ObjectId
                                               AND ObjectLink_Goods.DescId   = zc_ObjectLink_DiscountPeriodItem_Goods()
                           INNER JOIN tmpList ON tmpList.GoodsId = ObjectLink_Goods.ChildObjectId

                           LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                   ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_Unit.ObjectId
                                                  AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                  AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                        ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                       AND ObjectHistoryFloat_Value.DescId          = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

                      WHERE ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountPeriodItem_Unit()
                        AND ObjectLink_Unit.ChildObjectId = inUnitId
                        AND (ObjectHistoryFloat_Value.ValueData <> 0
                          OR ObjectHistory_DiscountPeriodItem.StartDate > zc_DateStart()
                            )
                     )

       -- ���������
       SELECT
             tmpDiscount.Id
           , tmpDiscount.ObjectId

           , CASE WHEN tmpDiscount.StartDate = zc_DateStart() OR tmpDiscount.StartDate < '01.01.1980' THEN NULL ELSE tmpDiscount.StartDate END :: TDateTime AS StartDate
           , CASE WHEN tmpDiscount.EndDate   = zc_DateEnd() THEN NULL ELSE tmpDiscount.EndDate END :: TDateTime AS EndDate

           , COALESCE(tmpDiscount.ValueDiscount, NULL) :: TFloat  AS ValueDiscount

           , Object_Insert.ValueData              AS InsertName
           , Object_Update.ValueData              AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , Object_Partner.ValueData            AS PartnerName
           , Object_Unit_in.ValueData            AS UnitName_in
           , Movement.InvNumber                  AS InvNumber_Partion
           , tmpPartionGoods.OperDate            AS OperDate_Partion

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_Goods.isErased               AS Goods_isErased
           , Object_GroupNameFull.ValueData      As GroupNameFull
           , Object_Currency.ValueData           AS CurrencyName
           , tmpPartionGoods.OperPrice     :: TFloat
           , tmpPartionGoods.OperPriceList :: TFloat

           , tmpPartionGoods.Remains         :: TFloat
           , tmpPartionGoods.AmountDebt      :: TFloat
           , (COALESCE (tmpPartionGoods.Remains, 0) + COALESCE (tmpPartionGoods.AmountDebt, 0)) :: TFloat  AS RemainsAll

           , Object_Brand.ValueData              AS BrandName
           , Object_Period.ValueData             AS PeriodName
           , tmpPartionGoods.PeriodYear          AS PeriodYear
           , Object_Fabrika.ValueData            AS FabrikaName
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName
           , Object_Composition.ValueData        AS CompositionName
           , Object_GoodsInfo.ValueData          AS GoodsInfoName
           , Object_LineFabrica.ValueData        AS LineFabricaName
           , Object_Label.ValueData              AS LabelName
           --, Object_GoodsSize.ValueData          AS GoodsSizeName
           , tmpPartionGoods.GoodsSizeName ::TVarChar
         
       FROM tmpGoods AS tmpPartionGoods
            LEFT JOIN tmpDiscount ON tmpDiscount.GoodsId= tmpPartionGoods.GoodsId

            LEFT JOIN Movement ON Movement.Id= tmpPartionGoods.MovementId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpPartionGoods.GoodsId
            
            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = tmpPartionGoods.PartnerId
            LEFT JOIN Object AS Object_Unit_in     ON Object_Unit_in.Id     = tmpPartionGoods.UnitId
            LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = tmpPartionGoods.CurrencyId
            LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = tmpPartionGoods.BrandId
            LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = tmpPartionGoods.PeriodId
            LEFT JOIN Object AS Object_Fabrika     ON Object_Fabrika.Id     = tmpPartionGoods.FabrikaId
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = tmpPartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = tmpPartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = tmpPartionGoods.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = tmpPartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = tmpPartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = tmpPartionGoods.LabelId
            --LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = tmpPartionGoods.GoodsSizeId

            LEFT JOIN ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                 ON ObjectDate_Protocol_Insert.ObjectId = tmpDiscount.ObjectId
                                AND ObjectDate_Protocol_Insert.DescId   = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = tmpDiscount.ObjectId
                                AND ObjectDate_Protocol_Update.DescId   = zc_ObjectDate_Protocol_Update()

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = tmpDiscount.ObjectId
                                AND ObjectLink_Insert.DescId   = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = tmpDiscount.ObjectId
                                AND ObjectLink_Update.DescId   = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.05.18         *
 15.03.18         *
 23.02.18         *
 01.07.17         *
 28.04.17         * ������ + ��-�� ������
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- ����
-- select * from gpSelect_ObjectHistory_DiscountPeriodItem(inUnitId := 1601 , inBrandId := 0 , inPeriodId := 1624 , inOperDate := ('24.05.2018')::TDateTime , inStartYear := 2013 , inEndYear := 2015 , inIsSize := 'False', inShowAll := 'False' ,  inSession := '8');