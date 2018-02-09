-- Function:  gpReport_SalesOLAP()

-- DROP VIEW IF EXISTS SoldTable;
DROP FUNCTION IF EXISTS gpReport_SaleOLAP (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleOLAP (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleOLAP (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inPartnerId        Integer  ,  -- Покупатель
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inYearStart        Integer  ,
    IN inYearEnd          Integer  ,
    IN inIsYear           Boolean  , -- ограничение Год ТМ (Да/Нет) (выбор партий)
    IN inIsPeriodAll      Boolean  , -- ограничение за Весь период (Да/Нет) (движение по Документам)
    IN inIsGoods          Boolean  , -- показать Товары (Да/Нет)
    IN inIsSize           Boolean  , -- показать Размеры (Да/Нет)
    IN inIsClient_doc     Boolean  , -- показать Покупателя (Да/Нет)
    IN inIsOperDate_doc   Boolean  , -- показать Год / Месяц (Да/Нет) (движение по Документам)
    IN inIsDay_doc        Boolean  , -- показать День недели (Да/Нет) (движение по Документам)
    IN inIsOperPrice      Boolean  , -- показать Цена вх. в вал. (Да/Нет)
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS TABLE (BrandName          TVarChar
             , PeriodName         TVarChar
             , PeriodYear         Integer
             , PartnerId          Integer
             , PartnerName        TVarChar

             -- , GoodsGroupName_all TVarChar
             , GoodsGroupName     TVarChar
             , LabelName          TVarChar
             -- , CompositionGroupName  TVarChar
             -- , CompositionName       TVarChar

             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             -- , GoodsInfoName      TVarChar
             -- , LineFabricaName    TVarChar
             -- , FabrikaName        TVarChar
             , GoodsSizeId        Integer
             , GoodsSizeName      VarChar (25)

             -- , OperDate           TDateTime
             , PeriodName_doc     VarChar (25)
             , PeriodYear_doc     Integer
             , MonthName_doc      VarChar (25)
             , DayName_doc        VarChar (3)
             , UnitName           TVarChar
             , ClientName         TVarChar

             , UnitName_In        TVarChar
             , CurrencyName       TVarChar

             , OperPrice          TFloat
             , Income_Amount      TFloat

             , Debt_Amount        TFloat
             , Sale_Amount        TFloat
             , Sale_Summ          TFloat
             , Sale_SummCost      TFloat
             , Sale_Summ_10100    TFloat
             , Sale_Summ_10201    TFloat
             , Sale_Summ_10202    TFloat
             , Sale_Summ_10203    TFloat
             , Sale_Summ_10204    TFloat
             , Sale_Summ_10200    TFloat
             , Return_Amount      TFloat
             , Return_Summ        TFloat
             , Return_SummCost    TFloat
             , Return_Summ_10200  TFloat
             , Result_Amount      TFloat
             , Result_Summ        TFloat
             , Result_SummCost    TFloat
             , Result_Summ_10200  TFloat
             
             , GroupsName4        TVarChar
             , GroupsName3        TVarChar
             , GroupsName2        TVarChar
             , GroupsName1        TVarChar
  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
      WITH tmpContainer AS (SELECT Container.Id         AS ContainerId
                                 , Container.PartionId  AS PartionId
                                 , CLO_Client.ObjectId  AS ClientId
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Client
                                                                ON CLO_Client.ContainerId = Container.Id
                                                               AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                            WHERE Container.DescId   = zc_Container_Count()
                           )
         , tmpData_all AS (SELECT Object_PartionGoods.MovementItemId AS PartionId
                                , Object_PartionGoods.BrandId
                                , Object_PartionGoods.PeriodId
                                , Object_PartionGoods.PeriodYear
                                , Object_PartionGoods.PartnerId

                                , Object_PartionGoods.GoodsGroupId
                                , Object_PartionGoods.LabelId
                                , Object_PartionGoods.CompositionGroupId
                                -- , Object_PartionGoods.CompositionId

                                , Object_PartionGoods.GoodsId
                                -- , Object_PartionGoods.GoodsInfoId
                                , Object_PartionGoods.LineFabricaId
                                , Object_PartionGoods.GoodsSizeId

                                , COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) :: Integer AS UnitId
                                , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', MIConatiner.OperDate) ELSE NULL :: TDateTime END AS OperDate_doc
                                , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM MIConatiner.OperDate)    ELSE NULL :: Integer   END AS DayId_doc
                                , CASE WHEN inIsClient_doc   = TRUE THEN tmpContainer.ClientId                      ELSE NULL :: Integer   END AS ClientId

                                , Object_PartionGoods.UnitId     AS UnitId_in
                                , Object_PartionGoods.CurrencyId AS CurrencyId
                                , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE NULL :: TFloat END AS OperPrice
                                  -- Кол-во Приход от поставщика - только для UnitId
                                , Object_PartionGoods.Amount AS Income_Amount

                                , SUM (COALESCE (MIConatiner.Amount, 0)) :: TFloat AS Debt_Amount
                                , SUM (CASE WHEN MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Amount
                                , 0 :: TFloat AS Sale_Summ

                                , 0 :: TFloat AS Sale_SummCost
                                , 0 :: TFloat AS Sale_Summ_10100
                                , 0 :: TFloat AS Sale_Summ_10201
                                , 0 :: TFloat AS Sale_Summ_10202
                                , 0 :: TFloat AS Sale_Summ_10203
                                , 0 :: TFloat AS Sale_Summ_10204
                                , 0 :: TFloat AS Sale_Summ_10200

                                , SUM (CASE WHEN MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Return_Amount
                                , 0 :: TFloat AS Return_Summ
                                , 0 :: TFloat AS Return_SummCost
                                , 0 :: TFloat AS Return_Summ_10200

                                , SUM (CASE WHEN MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END
                                     - CASE WHEN MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END
                                       ) :: TFloat AS Result_Amount
                                , 0 :: TFloat AS Result_Summ
                                , 0 :: TFloat AS Result_SummCost
                                , 0 :: TFloat AS Result_Summ_10200

                                  --  № п/п
                                , ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord

                           FROM Object_PartionGoods
                                LEFT JOIN tmpContainer ON tmpContainer.PartionId = Object_PartionGoods.MovementItemId
                                LEFT JOIN MovementItemContainer AS MIConatiner
                                                                ON MIConatiner.ContainerId    = tmpContainer.ContainerId
                                                               AND (MIConatiner.OperDate BETWEEN inStartDate AND inEndDate
                                                                 OR inIsPeriodAll = TRUE
                                                                   )
                           WHERE (Object_PartionGoods.PartnerId  = inPartnerId        OR inPartnerId   = 0)
                             AND (Object_PartionGoods.BrandId    = inBrandId          OR inBrandId     = 0)
                             AND (Object_PartionGoods.PeriodId   = inPeriodId         OR inPeriodId    = 0)
                             AND ((Object_PartionGoods.PeriodYear BETWEEN inYearStart AND inYearEnd) OR inIsYear = FALSE)
                             AND (MIConatiner.ContainerId        > 0                  OR inIsPeriodAll = TRUE)

                           GROUP BY Object_PartionGoods.MovementItemId
                                  , Object_PartionGoods.BrandId
                                  , Object_PartionGoods.PeriodId
                                  , Object_PartionGoods.PeriodYear
                                  , Object_PartionGoods.PartnerId

                                  , Object_PartionGoods.GoodsGroupId
                                  , Object_PartionGoods.LabelId
                                  , Object_PartionGoods.CompositionGroupId
                                  , Object_PartionGoods.CompositionId

                                  , Object_PartionGoods.GoodsId
                                  , Object_PartionGoods.GoodsInfoId
                                  , Object_PartionGoods.LineFabricaId
                                  , Object_PartionGoods.GoodsSizeId

                                  , MIConatiner.ObjectExtId_Analyzer
                                  , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', MIConatiner.OperDate) ELSE NULL :: TDateTime END
                                  , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM MIConatiner.OperDate)    ELSE NULL :: Integer   END
                                  , CASE WHEN inIsClient_doc   = TRUE THEN tmpContainer.ClientId                      ELSE NULL :: Integer   END

                                  , Object_PartionGoods.UnitId
                                  , Object_PartionGoods.CurrencyId
                                  , Object_PartionGoods.Amount
                                  , Object_PartionGoods.OperPrice
                                  , Object_PartionGoods.CountForPrice

                          )
       , tmpData AS (SELECT tmpData_all.BrandId
                          , tmpData_all.PeriodId
                          , tmpData_all.PeriodYear
                          , tmpData_all.PartnerId

                          , tmpData_all.GoodsGroupId
                          , tmpData_all.LabelId
                          , tmpData_all.CompositionGroupId
                          -- , tmpData_all.CompositionId

                          , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsId     ELSE 0 END AS GoodsId
                          -- , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsInfoId ELSE 0 END AS GoodsInfoId
                          , tmpData_all.LineFabricaId
                          , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId ELSE 0 END AS GoodsSizeId

                          , tmpData_all.OperDate_doc
                          , tmpData_all.DayId_doc
                          , tmpData_all.UnitId
                          , tmpData_all.ClientId

                          , tmpData_all.UnitId_in
                          , tmpData_all.CurrencyId

                          , tmpData_all.OperPrice
                          , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Amount ELSE 0 END) AS Income_Amount

                          , SUM (tmpData_all.Debt_Amount)         AS Debt_Amount
                          , SUM (tmpData_all.Sale_Amount)         AS Sale_Amount
                          , SUM (tmpData_all.Sale_Summ)           AS Sale_Summ
                          , SUM (tmpData_all.Sale_SummCost)       AS Sale_SummCost
                          , SUM (tmpData_all.Sale_Summ_10100)     AS Sale_Summ_10100
                          , SUM (tmpData_all.Sale_Summ_10201)     AS Sale_Summ_10201
                          , SUM (tmpData_all.Sale_Summ_10202)     AS Sale_Summ_10202
                          , SUM (tmpData_all.Sale_Summ_10203)     AS Sale_Summ_10203
                          , SUM (tmpData_all.Sale_Summ_10204)     AS Sale_Summ_10204
                          , SUM (tmpData_all.Sale_Summ_10200)     AS Sale_Summ_10200
                          , SUM (tmpData_all.Return_Amount)       AS Return_Amount
                          , SUM (tmpData_all.Return_Summ)         AS Return_Summ
                          , SUM (tmpData_all.Return_SummCost)     AS Return_SummCost
                          , SUM (tmpData_all.Return_Summ_10200)   AS Return_Summ_10200
                          , SUM (tmpData_all.Result_Amount)       AS Result_Amount
                          , SUM (tmpData_all.Result_Summ)         AS Result_Summ
                          , SUM (tmpData_all.Result_SummCost)     AS Result_SummCost
                          , SUM (tmpData_all.Result_Summ_10200)   AS Result_Summ_10200

                          , ObjectLink_Parent0.ChildObjectId AS GroupId1
                          , ObjectLink_Parent1.ChildObjectId AS GroupId1_parent

                          , ObjectLink_Parent1.ChildObjectId AS GroupId2
                          , ObjectLink_Parent2.ChildObjectId AS GroupId2_parent

                          , ObjectLink_Parent2.ChildObjectId AS GroupId3
                          , ObjectLink_Parent3.ChildObjectId AS GroupId3_parent

                          , ObjectLink_Parent3.ChildObjectId AS GroupId4
                          , ObjectLink_Parent4.ChildObjectId AS GroupId4_parent

                          , ObjectLink_Parent4.ChildObjectId AS GroupId5
                          , ObjectLink_Parent5.ChildObjectId AS GroupId5_parent

                          , ObjectLink_Parent5.ChildObjectId AS GroupId6
                          , ObjectLink_Parent6.ChildObjectId AS GroupId6_parent

                          , ObjectLink_Parent6.ChildObjectId AS GroupId7
                          , ObjectLink_Parent7.ChildObjectId AS GroupId7_parent

                          , ObjectLink_Parent7.ChildObjectId AS GroupId8
                          , ObjectLink_Parent8.ChildObjectId AS GroupId8_parent

                     FROM tmpData_all AS tmpData_all
                          LEFT JOIN ObjectLink AS ObjectLink_Parent0
                                               ON ObjectLink_Parent0.ObjectId = tmpData_all.GoodsId
                                              AND ObjectLink_Parent0.DescId   = zc_ObjectLink_Goods_GoodsGroup()
              
                          LEFT JOIN ObjectLink AS ObjectLink_Parent1
                                               ON ObjectLink_Parent1.ObjectId = ObjectLink_Parent0.ChildObjectId
                                              AND ObjectLink_Parent1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent2
                                               ON ObjectLink_Parent2.ObjectId = ObjectLink_Parent1.ChildObjectId
                                              AND ObjectLink_Parent2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent3
                                               ON ObjectLink_Parent3.ObjectId = ObjectLink_Parent2.ChildObjectId
                                              AND ObjectLink_Parent3.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent4
                                               ON ObjectLink_Parent4.ObjectId = ObjectLink_Parent3.ChildObjectId
                                              AND ObjectLink_Parent4.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent5
                                               ON ObjectLink_Parent5.ObjectId = ObjectLink_Parent4.ChildObjectId
                                              AND ObjectLink_Parent5.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent6
                                               ON ObjectLink_Parent6.ObjectId = ObjectLink_Parent5.ChildObjectId
                                              AND ObjectLink_Parent6.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent7
                                               ON ObjectLink_Parent7.ObjectId = ObjectLink_Parent6.ChildObjectId
                                              AND ObjectLink_Parent7.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent8
                                               ON ObjectLink_Parent8.ObjectId = ObjectLink_Parent7.ChildObjectId
                                              AND ObjectLink_Parent8.DescId   = zc_ObjectLink_GoodsGroup_Parent()

                     GROUP BY tmpData_all.BrandId
                            , tmpData_all.PeriodId
                            , tmpData_all.PeriodYear
                            , tmpData_all.PartnerId

                            , tmpData_all.GoodsGroupId
                            , tmpData_all.LabelId
                            , tmpData_all.CompositionGroupId
                            -- , tmpData_all.CompositionId

                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsId     ELSE 0 END
                            -- , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsInfoId ELSE 0 END
                            , tmpData_all.LineFabricaId
                            , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId ELSE 0 END

                            , tmpData_all.OperDate_doc
                            , tmpData_all.DayId_doc
                            , tmpData_all.UnitId
                            , tmpData_all.ClientId

                            , tmpData_all.UnitId_in
                            , tmpData_all.CurrencyId
                            , tmpData_all.OperPrice

                            , ObjectLink_Parent0.ChildObjectId
                            , ObjectLink_Parent1.ChildObjectId
                            , ObjectLink_Parent1.ChildObjectId
                            , ObjectLink_Parent2.ChildObjectId
                            , ObjectLink_Parent2.ChildObjectId
                            , ObjectLink_Parent3.ChildObjectId
                            , ObjectLink_Parent3.ChildObjectId
                            , ObjectLink_Parent4.ChildObjectId
                            , ObjectLink_Parent4.ChildObjectId
                            , ObjectLink_Parent5.ChildObjectId
                            , ObjectLink_Parent5.ChildObjectId
                            , ObjectLink_Parent6.ChildObjectId
                            , ObjectLink_Parent6.ChildObjectId
                            , ObjectLink_Parent7.ChildObjectId
                            , ObjectLink_Parent7.ChildObjectId
                            , ObjectLink_Parent8.ChildObjectId
                     )

        -- результат
        SELECT Object_Brand.ValueData             AS BrandName
             , Object_Period.ValueData            AS PeriodName
             , tmpData.PeriodYear      :: Integer AS PeriodYear
             , Object_Partner.Id                  AS PartnerId
             , Object_Partner.ValueData           AS PartnerName

             -- , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupName_all
             , Object_GoodsGroup.ValueData        AS GoodsGroupName
             , Object_Label.ValueData             AS LabelName
             -- , Object_CompositionGroup.ValueData  AS CompositionGroupName
             -- , Object_Composition.ValueData       AS CompositionName

             , Object_Goods.Id                    AS GoodsId
             , Object_Goods.ObjectCode            AS GoodsCode
             , Object_Goods.ValueData             AS GoodsName
             -- , Object_GoodsInfo.ValueData         AS GoodsInfoName
             -- , Object_LineFabrica.ValueData       AS LineFabricaName
             -- , Object_Fabrika.ValueData           AS FabrikaName
             , Object_GoodsSize.Id                AS GoodsSizeId
             , Object_GoodsSize.ValueData    :: VarChar (25) AS GoodsSizeName

             -- , tmpData.OperDate_doc                     :: TDateTime    AS OperDate
             , zfCalc_MonthYearName (tmpData.OperDate_doc) :: VarChar (25) AS PeriodName_doc
             , EXTRACT (YEAR FROM tmpData.OperDate_doc)    :: Integer      AS PeriodYear_doc
             , zfCalc_MonthName (tmpData.OperDate_doc)     :: VarChar (25) AS MonthName_doc
             , CASE tmpData.DayId_doc
                    WHEN 1 THEN '1Пн'
                    WHEN 2 THEN '2Вт'
                    WHEN 3 THEN '3Ср'
                    WHEN 4 THEN '4Чт'
                    WHEN 5 THEN '5Пт'
                    WHEN 6 THEN '6Сб'
                    WHEN 0 THEN '7Вс'
                    ELSE '???'
               END :: VarChar (3) AS DayName_doc

             , Object_Unit.ValueData              AS UnitName
             , Object_Client.ValueData            AS ClientName

             , Object_Unit_In.ValueData           AS UnitName_In
             , Object_Currency.ValueData          AS CurrencyName

             , tmpData.OperPrice          :: TFloat
             , tmpData.Income_Amount      :: TFloat

             , tmpData.Debt_Amount        :: TFloat
             , tmpData.Sale_Amount        :: TFloat
             , tmpData.Sale_Summ          :: TFloat

             , tmpData.Sale_SummCost      :: TFloat
             , tmpData.Sale_Summ_10100    :: TFloat
             , tmpData.Sale_Summ_10201    :: TFloat
             , tmpData.Sale_Summ_10202    :: TFloat
             , tmpData.Sale_Summ_10203    :: TFloat
             , tmpData.Sale_Summ_10204    :: TFloat
             , tmpData.Sale_Summ_10200    :: TFloat

             , tmpData.Return_Amount      :: TFloat
             , tmpData.Return_Summ        :: TFloat
             , tmpData.Return_SummCost    :: TFloat
             , tmpData.Return_Summ_10200  :: TFloat

             , tmpData.Result_Amount      :: TFloat
             , tmpData.Result_Summ        :: TFloat
             , tmpData.Result_SummCost    :: TFloat
             , tmpData.Result_Summ_10200  :: TFloat
             
               -- 0 - Вторая Группа СНИЗУ
             , Object_GoodsGroup1.ValueData AS GroupsName4

               -- 1 - Самый Верхней уровень
             , CASE WHEN tmpData.GroupId1_parent IS NULL
                         THEN Object_GoodsGroup1.ValueData
                    WHEN tmpData.GroupId2_parent IS NULL
                         THEN Object_GoodsGroup2.ValueData
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN Object_GoodsGroup3.ValueData
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN Object_GoodsGroup4.ValueData
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN Object_GoodsGroup5.ValueData
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN Object_GoodsGroup6.ValueData
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN Object_GoodsGroup7.ValueData
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN Object_GoodsGroup8.ValueData
               END :: TVarChar AS GroupsName3

               -- 2 - Следующий ПОСЛЕ П.1. + !!!для "Детское" - еще Следующий!!!
             , CASE WHEN tmpData.GroupId3_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup3.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup6.ValueData
                                   ELSE Object_GoodsGroup7.ValueData
                              END
               END :: TVarChar AS GroupsName2

               -- 3 - Следующий ПОСЛЕ П.2. + !!!для "Детское" - еще Следующий!!!
             , CASE WHEN tmpData.GroupId3_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup1.ValueData
                              END
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup3.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
               END :: TVarChar AS GroupsName1

        FROM tmpData
            LEFT JOIN Object AS Object_Client   ON Object_Client.Id   = tmpData.ClientId
            LEFT JOIN Object AS Object_Partner  ON Object_Partner.Id  = tmpData.PartnerId
            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_In  ON Object_Unit_In.Id  = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpData.CurrencyId

            -- LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
            --                        ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
            --                       AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            -- LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = NULL -- tmpData.CompositionId
            -- LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            -- LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = NULL -- tmpData.GoodsInfoId
            -- LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = NULL -- tmpData.FabrikaId

            LEFT JOIN Object AS Object_GoodsGroup1 ON Object_GoodsGroup1.Id = tmpData.GroupId1
            LEFT JOIN Object AS Object_GoodsGroup2 ON Object_GoodsGroup2.Id = tmpData.GroupId2
            LEFT JOIN Object AS Object_GoodsGroup3 ON Object_GoodsGroup3.Id = tmpData.GroupId3
            LEFT JOIN Object AS Object_GoodsGroup4 ON Object_GoodsGroup4.Id = tmpData.GroupId4
            LEFT JOIN Object AS Object_GoodsGroup5 ON Object_GoodsGroup5.Id = tmpData.GroupId5
            LEFT JOIN Object AS Object_GoodsGroup6 ON Object_GoodsGroup6.Id = tmpData.GroupId6
            LEFT JOIN Object AS Object_GoodsGroup7 ON Object_GoodsGroup7.Id = tmpData.GroupId7
            LEFT JOIN Object AS Object_GoodsGroup8 ON Object_GoodsGroup8.Id = tmpData.GroupId8
           ;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.02.18         *
*/

-- тест
-- SELECT * FROM gpReport_SaleOLAP (inStartDate:= '01.03.2017', inEndDate:= '31.03.2017', inPartnerId:= 2628, inBrandId:= 0, inPeriodId:= 0, inYearStart:= 2017, inYearEnd:= 2017, inIsYear:= TRUE, inIsPeriodAll:= TRUE, inIsGoods:= FALSE, inIsSize:= FALSE, inIsClient_doc:= FALSE, inIsOperDate_doc:= FALSE, inIsDay_doc:= FALSE, inIsOperPrice:= FALSE, inSession:= zfCalc_UserAdmin());
