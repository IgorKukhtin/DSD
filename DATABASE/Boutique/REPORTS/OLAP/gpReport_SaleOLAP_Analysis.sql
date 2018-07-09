-- Function:  gpReport_SaleOLAP_Analysis()

DROP FUNCTION IF EXISTS gpReport_SaleOLAP_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleOLAP_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleOLAP_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleOLAP_Analysis (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inPartnerId        Integer  ,  -- Покупатель
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inStartYear        Integer  ,
    IN inEndYear          Integer  ,
    IN inGoodsGroupId     Integer  , -- группа товаров
    IN inIsPeriodAll      Boolean  , -- ограничение за Весь период (Да/Нет) (движение по Документам)
    IN inIsYear           Boolean  , -- ограничение Год ТМ (Да/Нет) (выбор партий)
    IN inIsMark           Boolean  , -- показать только отмеченные товары(Да/Нет)
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor 
/*TABLE (BrandName             VarChar (100)
             , PeriodName            VarChar (25)
             , PeriodYear            Integer
             , PartnerId             Integer
             , PartnerName           VarChar (100)

             , GoodsGroupName        TVarChar
             , LabelName             VarChar (100)
             , CompositionName       VarChar (50) -- TVarChar -- +

             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             VarChar (100)
             , GoodsInfoName         VarChar (100) -- TVarChar -- +
             , LineFabricaName       VarChar (50)  -- TVarChar -- +

             , GoodsSizeId           Integer
             , GoodsSizeName         VarChar (50)

             , GroupsName1           VarChar (50)
             , GroupsName2           VarChar (50)
             , GroupsName3           VarChar (50)
             , GroupsName4           VarChar (50)

               -- Приход, и здесь вычитаем если было Списание или Возврат Поставщику
             , Income_Amount         TFloat
               -- Остаток - без учета "долга"
             , Remains_Amount        TFloat
               -- Кол-во продажа - с учетом "долга"
             , Sale_Amount           TFloat
              )*/
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE _tmpOLAP (BrandName TVarChar
                              , GoodsGroupName TVarChar
                              , LabelName TVarChar
                              , LineFabricaName TVarChar
                              , CompositionName TVarChar
                              , GoodsId Integer
                              , GoodsCode  Integer
                              , GoodsName TVarChar
                              , GoodsInfoName TVarChar
                              , GoodsSizeId Integer
                              , GoodsSizeName TVarChar
                              , GroupsName1 TVarChar
                              , GroupsName2 TVarChar
                              , GroupsName3 TVarChar
                              , GroupsName4 TVarChar
                              , Income_Amount TFloat
                              , Remains_Amount TFloat
                              , Sale_Amount TFloat
                              , Income_Summ            TFloat    -- Приход в вал
                              , Result_Summ_curr       TFloat    -- продажа в вал
                              , Result_SummCost_curr   TFloat    -- с/с в вал
                              , Remains_Summ           TFloat    -- остаток в вал
                              , Result_Summ_prof_curr  TFloat    -- прибыль в вал.
                              , Result_Summ_10200_curr TFloat    -- скидка в вал
                              ) ON COMMIT DROP;
    INSERT INTO _tmpOLAP (BrandName
                        , GoodsGroupName
                        , LabelName
                        , LineFabricaName
                        , CompositionName
                        , GoodsId 
                        , GoodsCode
                        , GoodsName
                        , GoodsInfoName
                        , GoodsSizeId
                        , GoodsSizeName
                        , GroupsName1
                        , GroupsName2
                        , GroupsName3
                        , GroupsName4
                        , Income_Amount
                        , Remains_Amount
                        , Sale_Amount
                        , Income_Summ
                        , Result_Summ_curr
                        , Result_SummCost_curr
                        , Remains_Summ
                        , Result_Summ_prof_curr
                        , Result_Summ_10200_curr
                        )
        WITH tmpGoods AS (SELECT tmp.GoodsId
                          FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS tmp
                          WHERE COALESCE (inGoodsGroupId, 0) <> 0
                          )

             SELECT tmpOlap.BrandName
                  , tmpOlap.GoodsGroupName
                  , tmpOlap.LabelName
                  , tmpOlap.LineFabricaName
                  , tmpOlap.CompositionName
                  , tmpOlap.GoodsId
                  , tmpOlap.GoodsCode
                  , tmpOlap.GoodsName
                  , tmpOlap.GoodsInfoName
                  , tmpOlap.GoodsSizeId
                  , tmpOlap.GoodsSizeName
                  , tmpOlap.GroupsName1
                  , tmpOlap.GroupsName2
                  , tmpOlap.GroupsName3
                  , tmpOlap.GroupsName4
                  -- Приход, 
                  , SUM (tmpOlap.Income_Amount) AS Income_Amount
                  -- Остаток - без учета "долга"
                  , SUM (tmpOlap.Remains_Amount) AS Remains_Amount
                  -- Кол-во продажа - с учетом "долга"            
                  , SUM (tmpOlap.Result_Amount) AS Sale_Amount    -- Кол. Итог - с учетом "долга" 
                  --
                  , SUM (tmpOlap.Income_Summ)            AS Income_Summ     
                  , SUM (tmpOlap.Result_Summ_curr)       AS Result_Summ_curr     
                  , SUM (tmpOlap.Result_SummCost_curr)   AS Result_SummCost_curr
                  , SUM (tmpOlap.Remains_Summ)           AS Remains_Summ
                  , SUM (tmpOlap.Result_Summ_prof_curr)  AS Result_Summ_prof_curr
                  , SUM (tmpOlap.Result_Summ_10200_curr) AS Result_Summ_10200_curr

             FROM gpReport_SaleOLAP (inStartDate:= inStartDate, inEndDate:= inEndDate, inUnitId:= inUnitId, inPartnerId:= inPartnerId
                                   , inBrandId:= inBrandId, inPeriodId:= inPeriodId, inStartYear:= inStartYear, inEndYear:= inEndYear
                                   , inIsYear:= inIsYear, inIsPeriodAll:= inIsPeriodAll, inIsGoods:= TRUE, inIsSize:= TRUE
                                   , inIsClient_doc:= FALSE, inIsOperDate_doc:= FALSE, inIsDay_doc:= FALSE, inIsOperPrice:= FALSE
                                   , inIsDiscount:= FALSE, inIsMark:= inIsMark, inSession:= inSession) AS tmpOlap
                  LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpOlap.GoodsId
             WHERE (tmpGoods.GoodsId IS NULL AND inGoodsGroupId = 0)
                OR (tmpGoods.GoodsId IS NOT NULL AND inGoodsGroupId <> 0)
             GROUP BY tmpOlap.BrandName
                    , tmpOlap.GoodsGroupName
                    , tmpOlap.LabelName
                    , tmpOlap.LineFabricaName
                    , tmpOlap.CompositionName
                    , tmpOlap.GoodsId
                    , tmpOlap.GoodsCode
                    , tmpOlap.GoodsName
                    , tmpOlap.GoodsInfoName
                    , tmpOlap.GoodsSizeId
                    , tmpOlap.GoodsSizeName
                    , tmpOlap.GroupsName1
                    , tmpOlap.GroupsName2
                    , tmpOlap.GroupsName3
                    , tmpOlap.GroupsName4
             HAVING SUM (tmpOlap.Income_Amount) <> 0
                 OR SUM (tmpOlap.Remains_Amount) <> 0
                 OR SUM (tmpOlap.Sale_Amount) <> 0
                 OR SUM (tmpOlap.Income_Summ) <> 0
                 OR SUM (tmpOlap.Result_Summ_curr) <> 0
                 OR SUM (tmpOlap.Result_SummCost_curr) <> 0
                 OR SUM (tmpOlap.Remains_Summ) <> 0
                 OR SUM (tmpOlap.Result_Summ_prof_curr) <> 0
                 OR SUM (tmpOlap.Result_Summ_10200_curr) <> 0
             ;

    -- таблица размеров, нумеруем и выводим отдельно только 70 шт
    CREATE TEMP TABLE _tmpSize (SizeId Integer, SizeName TVarChar, Ord Integer) ON COMMIT DROP;
    INSERT INTO _tmpSize (SizeId, SizeName, Ord)
         SELECT tmp.SizeId
              , tmp.SizeName
              , ROW_NUMBER() OVER (ORDER BY tmp.SizeName asc) AS Ord
         FROM (SELECT tmpOlap.GoodsSizeId     AS SizeId
                    , tmpOlap.GoodsSizeName   AS SizeName
               FROM _tmpOLAP AS tmpOLAP
               GROUP BY tmpOlap.GoodsSizeId
                      , tmpOlap.GoodsSizeName
               ) AS tmp;

     /*
     select zfCalc_Word_Split (inValue:= tt.SizeName, inSep:= ';', inIndex:= ) ::TFloat AS Value1
     select STRING_AGG (DISTINCT tmpSize.SizeName,  '; ') AS SizeName
     */
            
    -- Результат 1 размеры
    OPEN Cursor1 FOR
         WITH
         tmpData AS (SELECT tmpOlap.BrandName
                          , tmpOlap.GoodsGroupName
                          , tmpOlap.LabelName
                          , tmpOlap.LineFabricaName
                          , tmpOlap.CompositionName
                          , tmpOlap.GoodsId
                          , tmpOlap.GoodsCode
                          , tmpOlap.GoodsName
                          , tmpOlap.GoodsInfoName
                          , tmpOlap.GroupsName1
                          , tmpOlap.GroupsName2
                          , tmpOlap.GroupsName3
                          , tmpOlap.GroupsName4
                          , CASE WHEN tmpSize.Ord = 1 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount1
                          , CASE WHEN tmpSize.Ord = 1 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount1
                          , CASE WHEN tmpSize.Ord = 1 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount1

                          , CASE WHEN tmpSize.Ord = 2 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount2
                          , CASE WHEN tmpSize.Ord = 2 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount2
                          , CASE WHEN tmpSize.Ord = 2 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount2

                          , CASE WHEN tmpSize.Ord = 3 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount3
                          , CASE WHEN tmpSize.Ord = 3 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount3
                          , CASE WHEN tmpSize.Ord = 3 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount3

                          , CASE WHEN tmpSize.Ord = 4 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount4
                          , CASE WHEN tmpSize.Ord = 4 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount4
                          , CASE WHEN tmpSize.Ord = 4 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount4

                          , CASE WHEN tmpSize.Ord = 5 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount5
                          , CASE WHEN tmpSize.Ord = 5 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount5
                          , CASE WHEN tmpSize.Ord = 5 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount5

                          , CASE WHEN tmpSize.Ord = 6 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount6
                          , CASE WHEN tmpSize.Ord = 6 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount6
                          , CASE WHEN tmpSize.Ord = 6 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount6

                          , CASE WHEN tmpSize.Ord = 7 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount7
                          , CASE WHEN tmpSize.Ord = 7 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount7
                          , CASE WHEN tmpSize.Ord = 7 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount7

                          , CASE WHEN tmpSize.Ord = 8 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount8
                          , CASE WHEN tmpSize.Ord = 8 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount8
                          , CASE WHEN tmpSize.Ord = 8 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount8

                          , CASE WHEN tmpSize.Ord = 9 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount9
                          , CASE WHEN tmpSize.Ord = 9 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount9
                          , CASE WHEN tmpSize.Ord = 9 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount9

                          , CASE WHEN tmpSize.Ord = 10 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount10
                          , CASE WHEN tmpSize.Ord = 10 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount10
                          , CASE WHEN tmpSize.Ord = 10 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount10

                          , CASE WHEN tmpSize.Ord = 11 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount11
                          , CASE WHEN tmpSize.Ord = 11 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount11
                          , CASE WHEN tmpSize.Ord = 11 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount11

                          , CASE WHEN tmpSize.Ord = 12 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount12
                          , CASE WHEN tmpSize.Ord = 12 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount12
                          , CASE WHEN tmpSize.Ord = 12 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount12

                          , CASE WHEN tmpSize.Ord = 13 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount13
                          , CASE WHEN tmpSize.Ord = 13 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount13
                          , CASE WHEN tmpSize.Ord = 13 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount13

                          , CASE WHEN tmpSize.Ord = 14 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount14
                          , CASE WHEN tmpSize.Ord = 14 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount14
                          , CASE WHEN tmpSize.Ord = 14 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount14

                          , CASE WHEN tmpSize.Ord = 15 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount15
                          , CASE WHEN tmpSize.Ord = 15 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount15
                          , CASE WHEN tmpSize.Ord = 15 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount15

                          , CASE WHEN tmpSize.Ord = 16 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount16
                          , CASE WHEN tmpSize.Ord = 16 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount16
                          , CASE WHEN tmpSize.Ord = 16 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount16

                          , CASE WHEN tmpSize.Ord = 17 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount17
                          , CASE WHEN tmpSize.Ord = 17 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount17
                          , CASE WHEN tmpSize.Ord = 17 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount17

                          , CASE WHEN tmpSize.Ord = 18 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount18
                          , CASE WHEN tmpSize.Ord = 18 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount18
                          , CASE WHEN tmpSize.Ord = 18 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount18

                          , CASE WHEN tmpSize.Ord = 19 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount19
                          , CASE WHEN tmpSize.Ord = 19 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount19
                          , CASE WHEN tmpSize.Ord = 19 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount19

                          , CASE WHEN tmpSize.Ord = 20 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount20
                          , CASE WHEN tmpSize.Ord = 20 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount20
                          , CASE WHEN tmpSize.Ord = 20 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount20

                          , CASE WHEN tmpSize.Ord = 21 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount21
                          , CASE WHEN tmpSize.Ord = 21 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount21
                          , CASE WHEN tmpSize.Ord = 21 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount21

                          , CASE WHEN tmpSize.Ord = 22 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount22
                          , CASE WHEN tmpSize.Ord = 22 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount22
                          , CASE WHEN tmpSize.Ord = 22 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount22

                          , CASE WHEN tmpSize.Ord = 23 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount23
                          , CASE WHEN tmpSize.Ord = 23 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount23
                          , CASE WHEN tmpSize.Ord = 23 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount23

                          , CASE WHEN tmpSize.Ord = 24 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount24
                          , CASE WHEN tmpSize.Ord = 24 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount24
                          , CASE WHEN tmpSize.Ord = 24 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount24

                          , CASE WHEN tmpSize.Ord = 25 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount25
                          , CASE WHEN tmpSize.Ord = 25 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount25
                          , CASE WHEN tmpSize.Ord = 25 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount25

                          , CASE WHEN tmpSize.Ord = 26 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount26
                          , CASE WHEN tmpSize.Ord = 26 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount26
                          , CASE WHEN tmpSize.Ord = 26 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount26

                          , CASE WHEN tmpSize.Ord = 27 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount27
                          , CASE WHEN tmpSize.Ord = 27 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount27
                          , CASE WHEN tmpSize.Ord = 27 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount27

                          , CASE WHEN tmpSize.Ord = 28 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount28
                          , CASE WHEN tmpSize.Ord = 28 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount28
                          , CASE WHEN tmpSize.Ord = 28 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount28

                          , CASE WHEN tmpSize.Ord = 29 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount29
                          , CASE WHEN tmpSize.Ord = 29 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount29
                          , CASE WHEN tmpSize.Ord = 29 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount29

                          , CASE WHEN tmpSize.Ord = 30 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount30
                          , CASE WHEN tmpSize.Ord = 30 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount30
                          , CASE WHEN tmpSize.Ord = 30 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount30

                          , CASE WHEN tmpSize.Ord = 31 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount31
                          , CASE WHEN tmpSize.Ord = 31 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount31
                          , CASE WHEN tmpSize.Ord = 31 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount31

                          , CASE WHEN tmpSize.Ord = 32 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount32
                          , CASE WHEN tmpSize.Ord = 32 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount32
                          , CASE WHEN tmpSize.Ord = 32 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount32

                          , CASE WHEN tmpSize.Ord = 33 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount33
                          , CASE WHEN tmpSize.Ord = 33 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount33
                          , CASE WHEN tmpSize.Ord = 33 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount33

                          , CASE WHEN tmpSize.Ord = 34 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount34
                          , CASE WHEN tmpSize.Ord = 34 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount34
                          , CASE WHEN tmpSize.Ord = 34 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount34

                          , CASE WHEN tmpSize.Ord = 35 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount35
                          , CASE WHEN tmpSize.Ord = 35 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount35
                          , CASE WHEN tmpSize.Ord = 35 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount35

                          , CASE WHEN tmpSize.Ord = 36 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount36
                          , CASE WHEN tmpSize.Ord = 36 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount36
                          , CASE WHEN tmpSize.Ord = 36 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount36

                          , CASE WHEN tmpSize.Ord = 37 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount37
                          , CASE WHEN tmpSize.Ord = 37 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount37
                          , CASE WHEN tmpSize.Ord = 37 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount37

                          , CASE WHEN tmpSize.Ord = 38 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount38
                          , CASE WHEN tmpSize.Ord = 38 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount38
                          , CASE WHEN tmpSize.Ord = 38 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount38

                          , CASE WHEN tmpSize.Ord = 39 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount39
                          , CASE WHEN tmpSize.Ord = 39 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount39
                          , CASE WHEN tmpSize.Ord = 39 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount39

                          , CASE WHEN tmpSize.Ord = 40 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount40
                          , CASE WHEN tmpSize.Ord = 40 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount40
                          , CASE WHEN tmpSize.Ord = 40 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount40

                          , CASE WHEN tmpSize.Ord = 41 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount41
                          , CASE WHEN tmpSize.Ord = 41 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount41
                          , CASE WHEN tmpSize.Ord = 41 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount41

                          , CASE WHEN tmpSize.Ord = 42 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount42
                          , CASE WHEN tmpSize.Ord = 42 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount42
                          , CASE WHEN tmpSize.Ord = 42 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount42

                          , CASE WHEN tmpSize.Ord = 43 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount43
                          , CASE WHEN tmpSize.Ord = 43 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount43
                          , CASE WHEN tmpSize.Ord = 43 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount43

                          , CASE WHEN tmpSize.Ord = 44 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount44
                          , CASE WHEN tmpSize.Ord = 44 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount44
                          , CASE WHEN tmpSize.Ord = 44 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount44

                          , CASE WHEN tmpSize.Ord = 45 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount45
                          , CASE WHEN tmpSize.Ord = 45 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount45
                          , CASE WHEN tmpSize.Ord = 45 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount45

                          , CASE WHEN tmpSize.Ord = 46 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount46
                          , CASE WHEN tmpSize.Ord = 46 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount46
                          , CASE WHEN tmpSize.Ord = 46 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount46

                          , CASE WHEN tmpSize.Ord = 47 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount47
                          , CASE WHEN tmpSize.Ord = 47 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount47
                          , CASE WHEN tmpSize.Ord = 47 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount47

                          , CASE WHEN tmpSize.Ord = 48 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount48
                          , CASE WHEN tmpSize.Ord = 48 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount48
                          , CASE WHEN tmpSize.Ord = 48 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount48

                          , CASE WHEN tmpSize.Ord = 49 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount49
                          , CASE WHEN tmpSize.Ord = 49 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount49
                          , CASE WHEN tmpSize.Ord = 49 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount49

                          , CASE WHEN tmpSize.Ord = 50 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount50
                          , CASE WHEN tmpSize.Ord = 50 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount50
                          , CASE WHEN tmpSize.Ord = 50 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount50

                          , CASE WHEN tmpSize.Ord = 51 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount51
                          , CASE WHEN tmpSize.Ord = 51 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount51
                          , CASE WHEN tmpSize.Ord = 51 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount51

                          , CASE WHEN tmpSize.Ord = 52 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount52
                          , CASE WHEN tmpSize.Ord = 52 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount52
                          , CASE WHEN tmpSize.Ord = 52 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount52

                          , CASE WHEN tmpSize.Ord = 53 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount53
                          , CASE WHEN tmpSize.Ord = 53 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount53
                          , CASE WHEN tmpSize.Ord = 53 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount53

                          , CASE WHEN tmpSize.Ord = 54 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount54
                          , CASE WHEN tmpSize.Ord = 54 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount54
                          , CASE WHEN tmpSize.Ord = 54 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount54

                          , CASE WHEN tmpSize.Ord = 55 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount55
                          , CASE WHEN tmpSize.Ord = 55 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount55
                          , CASE WHEN tmpSize.Ord = 55 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount55

                          , CASE WHEN tmpSize.Ord = 56 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount56
                          , CASE WHEN tmpSize.Ord = 56 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount56
                          , CASE WHEN tmpSize.Ord = 56 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount56

                          , CASE WHEN tmpSize.Ord = 57 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount57
                          , CASE WHEN tmpSize.Ord = 57 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount57
                          , CASE WHEN tmpSize.Ord = 57 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount57

                          , CASE WHEN tmpSize.Ord = 58 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount58
                          , CASE WHEN tmpSize.Ord = 58 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount58
                          , CASE WHEN tmpSize.Ord = 58 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount58

                          , CASE WHEN tmpSize.Ord = 59 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount59
                          , CASE WHEN tmpSize.Ord = 59 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount59
                          , CASE WHEN tmpSize.Ord = 59 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount59

                          , CASE WHEN tmpSize.Ord = 60 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount60
                          , CASE WHEN tmpSize.Ord = 60 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount60
                          , CASE WHEN tmpSize.Ord = 60 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount60

                          , CASE WHEN tmpSize.Ord = 61 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount61
                          , CASE WHEN tmpSize.Ord = 61 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount61
                          , CASE WHEN tmpSize.Ord = 61 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount61

                          , CASE WHEN tmpSize.Ord = 62 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount62
                          , CASE WHEN tmpSize.Ord = 62 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount62
                          , CASE WHEN tmpSize.Ord = 62 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount62

                          , CASE WHEN tmpSize.Ord = 63 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount63
                          , CASE WHEN tmpSize.Ord = 63 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount63
                          , CASE WHEN tmpSize.Ord = 63 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount63

                          , CASE WHEN tmpSize.Ord = 64 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount64
                          , CASE WHEN tmpSize.Ord = 64 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount64
                          , CASE WHEN tmpSize.Ord = 64 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount64

                          , CASE WHEN tmpSize.Ord = 65 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount65
                          , CASE WHEN tmpSize.Ord = 65 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount65
                          , CASE WHEN tmpSize.Ord = 65 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount65

                          , CASE WHEN tmpSize.Ord = 66 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount66
                          , CASE WHEN tmpSize.Ord = 66 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount66
                          , CASE WHEN tmpSize.Ord = 66 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount66

                          , CASE WHEN tmpSize.Ord = 67 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount67
                          , CASE WHEN tmpSize.Ord = 67 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount67
                          , CASE WHEN tmpSize.Ord = 67 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount67

                          , CASE WHEN tmpSize.Ord = 68 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount68
                          , CASE WHEN tmpSize.Ord = 68 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount68
                          , CASE WHEN tmpSize.Ord = 68 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount68

                          , CASE WHEN tmpSize.Ord = 69 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount69
                          , CASE WHEN tmpSize.Ord = 69 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount69
                          , CASE WHEN tmpSize.Ord = 69 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount69

                          , CASE WHEN tmpSize.Ord = 70 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount70
                          , CASE WHEN tmpSize.Ord = 70 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount70
                          , CASE WHEN tmpSize.Ord = 70 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount70

                          , CASE WHEN tmpSize.Ord > 70 THEN tmpOlap.Income_Amount  ELSE 0 END AS Income_Amount0
                          , CASE WHEN tmpSize.Ord > 70 THEN tmpOlap.Sale_Amount    ELSE 0 END AS Sale_Amount0
                          , CASE WHEN tmpSize.Ord > 70 THEN tmpOlap.Remains_Amount ELSE 0 END AS Remains_Amount0
                          
                          , COALESCE (tmpOlap.Income_Amount, 0)          AS Income_Amount
                          , COALESCE (tmpOlap.Sale_Amount, 0)            AS Sale_Amount
                          , COALESCE (tmpOlap.Remains_Amount, 0)         AS Remains_Amount

                          --
                          , COALESCE (tmpOlap.Income_Summ, 0)            AS Income_Summ     
                          , COALESCE (tmpOlap.Result_Summ_curr, 0)       AS Result_Summ_curr     
                          , COALESCE (tmpOlap.Result_SummCost_curr, 0)   AS Result_SummCost_curr
                          , COALESCE (tmpOlap.Remains_Summ, 0)           AS Remains_Summ
                          , COALESCE (tmpOlap.Result_Summ_prof_curr, 0)  AS Result_Summ_prof_curr
                          , COALESCE (tmpOlap.Result_Summ_10200_curr, 0) AS Result_Summ_10200_curr

                     FROM _tmpOLAP AS tmpOLAP
                           JOIN _tmpSize AS tmpSize ON tmpSize.SizeId = tmpOLAP.GoodsSizeId
                     ) 

         -- результат
         SELECT tmpData.BrandName
                          , tmpData.GoodsGroupName
                          , tmpData.LabelName
                          , tmpData.LineFabricaName
                          , tmpData.CompositionName
                          , tmpData.GoodsId
                          , tmpData.GoodsCode
                          , tmpData.GoodsName
                          , tmpData.GoodsInfoName
                          , tmpData.GroupsName1
                          , tmpData.GroupsName2
                          , tmpData.GroupsName3
                          , tmpData.GroupsName4
                          , SUM( tmpData.Income_Amount1 ) AS Income_Amount1
                          , SUM( tmpData.Sale_Amount1   ) AS Sale_Amount1
                          , SUM( tmpData.Remains_Amount1) AS Remains_Amount1
                                                        
                          , SUM( tmpData.Income_Amount2 ) AS Income_Amount2
                          , SUM( tmpData.Sale_Amount2   ) AS Sale_Amount2
                          , SUM( tmpData.Remains_Amount2) AS Remains_Amount2
                                                        
                          , SUM( tmpData.Income_Amount3 ) AS Income_Amount3
                          , SUM( tmpData.Sale_Amount3   ) AS Sale_Amount3
                          , SUM( tmpData.Remains_Amount3) AS Remains_Amount3
                                                        
                          , SUM( tmpData.Income_Amount4 ) AS Income_Amount4
                          , SUM( tmpData.Sale_Amount4   ) AS Sale_Amount4
                          , SUM( tmpData.Remains_Amount4) AS Remains_Amount4
                                                        
                          , SUM( tmpData.Income_Amount5 ) AS Income_Amount5
                          , SUM( tmpData.Sale_Amount5   ) AS Sale_Amount5
                          , SUM( tmpData.Remains_Amount5) AS Remains_Amount5
                                                        
                          , SUM( tmpData.Income_Amount6 ) AS Income_Amount6
                          , SUM( tmpData.Sale_Amount6   ) AS Sale_Amount6
                          , SUM( tmpData.Remains_Amount6) AS Remains_Amount6
                                                        
                          , SUM( tmpData.Income_Amount7 ) AS Income_Amount7
                          , SUM( tmpData.Sale_Amount7   ) AS Sale_Amount7
                          , SUM( tmpData.Remains_Amount7) AS Remains_Amount7
                                                        
                          , SUM( tmpData.Income_Amount8 ) AS Income_Amount8
                          , SUM( tmpData.Sale_Amount8   ) AS Sale_Amount8
                          , SUM( tmpData.Remains_Amount8) AS Remains_Amount8
                                                        
                          , SUM( tmpData.Income_Amount9 ) AS Income_Amount9
                          , SUM( tmpData.Sale_Amount9   ) AS Sale_Amount9
                          , SUM( tmpData.Remains_Amount9) AS Remains_Amount9
                                                        
                          , SUM( tmpData.Income_Amount10 ) AS Income_Amount10
                          , SUM( tmpData.Sale_Amount10   ) AS Sale_Amount10
                          , SUM( tmpData.Remains_Amount10) AS Remains_Amount10
                                                         
                          , SUM( tmpData.Income_Amount11 ) AS Income_Amount11
                          , SUM( tmpData.Sale_Amount11   ) AS Sale_Amount11
                          , SUM( tmpData.Remains_Amount11) AS Remains_Amount11
                                                         
                          , SUM( tmpData.Income_Amount12 ) AS Income_Amount12
                          , SUM( tmpData.Sale_Amount12   ) AS Sale_Amount12
                          , SUM( tmpData.Remains_Amount12) AS Remains_Amount12
                                                         
                          , SUM( tmpData.Income_Amount13 ) AS Income_Amount13
                          , SUM( tmpData.Sale_Amount13   ) AS Sale_Amount13
                          , SUM( tmpData.Remains_Amount13) AS Remains_Amount13
                                                         
                          , SUM( tmpData.Income_Amount14 ) AS Income_Amount14
                          , SUM( tmpData.Sale_Amount14   ) AS Sale_Amount14
                          , SUM( tmpData.Remains_Amount14) AS Remains_Amount14
                                                         
                          , SUM( tmpData.Income_Amount15 ) AS Income_Amount15
                          , SUM( tmpData.Sale_Amount15   ) AS Sale_Amount15
                          , SUM( tmpData.Remains_Amount15) AS Remains_Amount15
                                                         
                          , SUM( tmpData.Income_Amount16 ) AS Income_Amount16
                          , SUM( tmpData.Sale_Amount16   ) AS Sale_Amount16
                          , SUM( tmpData.Remains_Amount16) AS Remains_Amount16
                                                         
                          , SUM( tmpData.Income_Amount17 ) AS Income_Amount17
                          , SUM( tmpData.Sale_Amount17   ) AS Sale_Amount17
                          , SUM( tmpData.Remains_Amount17) AS Remains_Amount17
                                                         
                          , SUM( tmpData.Income_Amount18 ) AS Income_Amount18
                          , SUM( tmpData.Sale_Amount18   ) AS Sale_Amount18
                          , SUM( tmpData.Remains_Amount18) AS Remains_Amount18
                                                         
                          , SUM( tmpData.Income_Amount19 ) AS Income_Amount19
                          , SUM( tmpData.Sale_Amount19   ) AS Sale_Amount19
                          , SUM( tmpData.Remains_Amount19) AS Remains_Amount19
                                                         
                          , SUM( tmpData.Income_Amount20 ) AS Income_Amount20
                          , SUM( tmpData.Sale_Amount20   ) AS Sale_Amount20
                          , SUM( tmpData.Remains_Amount20) AS Remains_Amount20
                                                         
                          , SUM( tmpData.Income_Amount21 ) AS Income_Amount21
                          , SUM( tmpData.Sale_Amount21   ) AS Sale_Amount21
                          , SUM( tmpData.Remains_Amount21) AS Remains_Amount21
                                                         
                          , SUM( tmpData.Income_Amount22 ) AS Income_Amount22
                          , SUM( tmpData.Sale_Amount22   ) AS Sale_Amount22
                          , SUM( tmpData.Remains_Amount22) AS Remains_Amount22
                                                         
                          , SUM( tmpData.Income_Amount23 ) AS Income_Amount23
                          , SUM( tmpData.Sale_Amount23   ) AS Sale_Amount23
                          , SUM( tmpData.Remains_Amount23) AS Remains_Amount23
                                                         
                          , SUM( tmpData.Income_Amount24 ) AS Income_Amount24
                          , SUM( tmpData.Sale_Amount24   ) AS Sale_Amount24
                          , SUM( tmpData.Remains_Amount24) AS Remains_Amount24
                                                         
                          , SUM( tmpData.Income_Amount25 ) AS Income_Amount25
                          , SUM( tmpData.Sale_Amount25   ) AS Sale_Amount25
                          , SUM( tmpData.Remains_Amount25) AS Remains_Amount25
                                                         
                          , SUM( tmpData.Income_Amount26 ) AS Income_Amount26
                          , SUM( tmpData.Sale_Amount26   ) AS Sale_Amount26
                          , SUM( tmpData.Remains_Amount26) AS Remains_Amount26
                                                         
                          , SUM( tmpData.Income_Amount27 ) AS Income_Amount27
                          , SUM( tmpData.Sale_Amount27   ) AS Sale_Amount27
                          , SUM( tmpData.Remains_Amount27) AS Remains_Amount27
                                                         
                          , SUM( tmpData.Income_Amount28 ) AS Income_Amount28
                          , SUM( tmpData.Sale_Amount28   ) AS Sale_Amount28
                          , SUM( tmpData.Remains_Amount28) AS Remains_Amount28
                                                         
                          , SUM( tmpData.Income_Amount29 ) AS Income_Amount29
                          , SUM( tmpData.Sale_Amount29   ) AS Sale_Amount29
                          , SUM( tmpData.Remains_Amount29) AS Remains_Amount29
                                                         
                          , SUM( tmpData.Income_Amount30 ) AS Income_Amount30
                          , SUM( tmpData.Sale_Amount30   ) AS Sale_Amount30
                          , SUM( tmpData.Remains_Amount30) AS Remains_Amount30
                                                         
                          , SUM( tmpData.Income_Amount31 ) AS Income_Amount31
                          , SUM( tmpData.Sale_Amount31   ) AS Sale_Amount31
                          , SUM( tmpData.Remains_Amount31) AS Remains_Amount31
                                                         
                          , SUM( tmpData.Income_Amount32 ) AS Income_Amount32
                          , SUM( tmpData.Sale_Amount32   ) AS Sale_Amount32
                          , SUM( tmpData.Remains_Amount32) AS Remains_Amount32
                                                         
                          , SUM( tmpData.Income_Amount33 ) AS Income_Amount33
                          , SUM( tmpData.Sale_Amount33   ) AS Sale_Amount33
                          , SUM( tmpData.Remains_Amount33) AS Remains_Amount33
                                                         
                          , SUM( tmpData.Income_Amount34 ) AS Income_Amount34
                          , SUM( tmpData.Sale_Amount34   ) AS Sale_Amount34
                          , SUM( tmpData.Remains_Amount34) AS Remains_Amount34
                                                         
                          , SUM( tmpData.Income_Amount35 ) AS Income_Amount35
                          , SUM( tmpData.Sale_Amount35   ) AS Sale_Amount35
                          , SUM( tmpData.Remains_Amount35) AS Remains_Amount35
                                                         
                          , SUM( tmpData.Income_Amount36 ) AS Income_Amount36
                          , SUM( tmpData.Sale_Amount36   ) AS Sale_Amount36
                          , SUM( tmpData.Remains_Amount36) AS Remains_Amount36
                                                         
                          , SUM( tmpData.Income_Amount37 ) AS Income_Amount37
                          , SUM( tmpData.Sale_Amount37   ) AS Sale_Amount37
                          , SUM( tmpData.Remains_Amount37) AS Remains_Amount37
                                                         
                          , SUM( tmpData.Income_Amount38 ) AS Income_Amount38
                          , SUM( tmpData.Sale_Amount38   ) AS Sale_Amount38
                          , SUM( tmpData.Remains_Amount38) AS Remains_Amount38
                                                         
                          , SUM( tmpData.Income_Amount39 ) AS Income_Amount39
                          , SUM( tmpData.Sale_Amount39   ) AS Sale_Amount39
                          , SUM( tmpData.Remains_Amount39) AS Remains_Amount39
                                                         
                          , SUM( tmpData.Income_Amount40 ) AS Income_Amount40
                          , SUM( tmpData.Sale_Amount40   ) AS Sale_Amount40
                          , SUM( tmpData.Remains_Amount40) AS Remains_Amount40
                                                         
                          , SUM( tmpData.Income_Amount41 ) AS Income_Amount41
                          , SUM( tmpData.Sale_Amount41   ) AS Sale_Amount41
                          , SUM( tmpData.Remains_Amount41) AS Remains_Amount41
                                                         
                          , SUM( tmpData.Income_Amount42 ) AS Income_Amount42
                          , SUM( tmpData.Sale_Amount42   ) AS Sale_Amount42
                          , SUM( tmpData.Remains_Amount42) AS Remains_Amount42
                                                         
                          , SUM( tmpData.Income_Amount43 ) AS Income_Amount43
                          , SUM( tmpData.Sale_Amount43   ) AS Sale_Amount43
                          , SUM( tmpData.Remains_Amount43) AS Remains_Amount43
                                                         
                          , SUM( tmpData.Income_Amount44 ) AS Income_Amount44
                          , SUM( tmpData.Sale_Amount44   ) AS Sale_Amount44
                          , SUM( tmpData.Remains_Amount44) AS Remains_Amount44
                                                         
                          , SUM( tmpData.Income_Amount45 ) AS Income_Amount45
                          , SUM( tmpData.Sale_Amount45   ) AS Sale_Amount45
                          , SUM( tmpData.Remains_Amount45) AS Remains_Amount45
                                                         
                          , SUM( tmpData.Income_Amount46 ) AS Income_Amount46
                          , SUM( tmpData.Sale_Amount46   ) AS Sale_Amount46
                          , SUM( tmpData.Remains_Amount46) AS Remains_Amount46
                                                         
                          , SUM( tmpData.Income_Amount47 ) AS Income_Amount47
                          , SUM( tmpData.Sale_Amount47   ) AS Sale_Amount47
                          , SUM( tmpData.Remains_Amount47) AS Remains_Amount47
                                                         
                          , SUM( tmpData.Income_Amount48 ) AS Income_Amount48
                          , SUM( tmpData.Sale_Amount48   ) AS Sale_Amount48
                          , SUM( tmpData.Remains_Amount48) AS Remains_Amount48
                                                         
                          , SUM( tmpData.Income_Amount49 ) AS Income_Amount49
                          , SUM( tmpData.Sale_Amount49   ) AS Sale_Amount49
                          , SUM( tmpData.Remains_Amount49) AS Remains_Amount49
                                                         
                          , SUM( tmpData.Income_Amount50 ) AS Income_Amount50
                          , SUM( tmpData.Sale_Amount50   ) AS Sale_Amount50
                          , SUM( tmpData.Remains_Amount50) AS Remains_Amount50
                                                         
                          , SUM( tmpData.Income_Amount51 ) AS Income_Amount51
                          , SUM( tmpData.Sale_Amount51   ) AS Sale_Amount51
                          , SUM( tmpData.Remains_Amount51) AS Remains_Amount51
                                                         
                          , SUM( tmpData.Income_Amount52 ) AS Income_Amount52
                          , SUM( tmpData.Sale_Amount52   ) AS Sale_Amount52
                          , SUM( tmpData.Remains_Amount52) AS Remains_Amount52
                                                         
                          , SUM( tmpData.Income_Amount53 ) AS Income_Amount53
                          , SUM( tmpData.Sale_Amount53   ) AS Sale_Amount53
                          , SUM( tmpData.Remains_Amount53) AS Remains_Amount53
                                                         
                          , SUM( tmpData.Income_Amount54 ) AS Income_Amount54
                          , SUM( tmpData.Sale_Amount54   ) AS Sale_Amount54
                          , SUM( tmpData.Remains_Amount54) AS Remains_Amount54
                                                         
                          , SUM( tmpData.Income_Amount55 ) AS Income_Amount55
                          , SUM( tmpData.Sale_Amount55   ) AS Sale_Amount55
                          , SUM( tmpData.Remains_Amount55) AS Remains_Amount55
                                                         
                          , SUM( tmpData.Income_Amount56 ) AS Income_Amount56
                          , SUM( tmpData.Sale_Amount56   ) AS Sale_Amount56
                          , SUM( tmpData.Remains_Amount56) AS Remains_Amount56
                                                         
                          , SUM( tmpData.Income_Amount57 ) AS Income_Amount57
                          , SUM( tmpData.Sale_Amount57   ) AS Sale_Amount57
                          , SUM( tmpData.Remains_Amount57) AS Remains_Amount57
                                                         
                          , SUM( tmpData.Income_Amount58 ) AS Income_Amount58
                          , SUM( tmpData.Sale_Amount58   ) AS Sale_Amount58
                          , SUM( tmpData.Remains_Amount58) AS Remains_Amount58
                                                         
                          , SUM( tmpData.Income_Amount59 ) AS Income_Amount59
                          , SUM( tmpData.Sale_Amount59   ) AS Sale_Amount59
                          , SUM( tmpData.Remains_Amount59) AS Remains_Amount59
                                                         
                          , SUM( tmpData.Income_Amount60 ) AS Income_Amount60
                          , SUM( tmpData.Sale_Amount60   ) AS Sale_Amount60
                          , SUM( tmpData.Remains_Amount60) AS Remains_Amount60
                                                         
                          , SUM( tmpData.Income_Amount61 ) AS Income_Amount61
                          , SUM( tmpData.Sale_Amount61   ) AS Sale_Amount61
                          , SUM( tmpData.Remains_Amount61) AS Remains_Amount61
                                                         
                          , SUM( tmpData.Income_Amount62 ) AS Income_Amount62
                          , SUM( tmpData.Sale_Amount62   ) AS Sale_Amount62
                          , SUM( tmpData.Remains_Amount62) AS Remains_Amount62
                                                         
                          , SUM( tmpData.Income_Amount63 ) AS Income_Amount63
                          , SUM( tmpData.Sale_Amount63   ) AS Sale_Amount63
                          , SUM( tmpData.Remains_Amount63) AS Remains_Amount63
                                                         
                          , SUM( tmpData.Income_Amount64 ) AS Income_Amount64
                          , SUM( tmpData.Sale_Amount64   ) AS Sale_Amount64
                          , SUM( tmpData.Remains_Amount64) AS Remains_Amount64
                                                         
                          , SUM( tmpData.Income_Amount65 ) AS Income_Amount65
                          , SUM( tmpData.Sale_Amount65   ) AS Sale_Amount65
                          , SUM( tmpData.Remains_Amount65) AS Remains_Amount65
                                                         
                          , SUM( tmpData.Income_Amount66 ) AS Income_Amount66
                          , SUM( tmpData.Sale_Amount66   ) AS Sale_Amount66
                          , SUM( tmpData.Remains_Amount66) AS Remains_Amount66
                                                         
                          , SUM( tmpData.Income_Amount67 ) AS Income_Amount67
                          , SUM( tmpData.Sale_Amount67   ) AS Sale_Amount67
                          , SUM( tmpData.Remains_Amount67) AS Remains_Amount67
                                                         
                          , SUM( tmpData.Income_Amount68 ) AS Income_Amount68
                          , SUM( tmpData.Sale_Amount68   ) AS Sale_Amount68
                          , SUM( tmpData.Remains_Amount68) AS Remains_Amount68
                                                         
                          , SUM( tmpData.Income_Amount69 ) AS Income_Amount69
                          , SUM( tmpData.Sale_Amount69   ) AS Sale_Amount69
                          , SUM( tmpData.Remains_Amount69) AS Remains_Amount69
                                                         
                          , SUM( tmpData.Income_Amount70 ) AS Income_Amount70
                          , SUM( tmpData.Sale_Amount70   ) AS Sale_Amount70
                          , SUM( tmpData.Remains_Amount70) AS Remains_Amount70
                                                         
                          , SUM( tmpData.Income_Amount0  ) AS Income_Amount0
                          , SUM( tmpData.Sale_Amount0    ) AS Sale_Amount0
                          , SUM( tmpData.Remains_Amount0 ) AS Remains_Amount0

                          , SUM( tmpData.Income_Amount  ) AS Income_Amount
                          , SUM( tmpData.Sale_Amount    ) AS Sale_Amount
                          , SUM( tmpData.Remains_Amount ) AS Remains_Amount

                          --
                          , SUM (tmpData.Income_Summ)            AS Income_Summ     
                          , SUM (tmpData.Result_Summ_curr)       AS Result_Summ_curr     
                          , SUM (tmpData.Result_SummCost_curr)   AS Result_SummCost_curr
                          , SUM (tmpData.Remains_Summ)           AS Remains_Summ
                          , SUM (tmpData.Result_Summ_prof_curr)  AS Result_Summ_prof_curr
                          , SUM (tmpData.Result_Summ_10200_curr) AS Result_Summ_10200_curr
                          --
                          , CAST (CASE WHEN SUM(tmpData.Income_Amount) <> 0 THEN SUM( tmpData.Sale_Amount) / SUM( tmpData.Income_Amount) * 100 ELSE 0 END AS NUMERIC (16,0)) :: TFloat AS Persent_Sale

                          , 15395562          :: Integer  AS Color_Grey            --нежно серый -- 
--                          , zc_Color_White()  :: Integer  AS Color_White 
                          , ROW_NUMBER() OVER (ORDER BY tmpData.LabelName, tmpData.GoodsCode, tmpData.GoodsName)                                               :: integer AS Ord1 
                          , ROW_NUMBER() OVER (ORDER BY tmpData.GroupsName3, tmpData.LabelName, tmpData.GoodsCode, tmpData.GoodsName)                          :: integer AS Ord2 
                          , ROW_NUMBER() OVER (ORDER BY tmpData.LineFabricaName, tmpData.GroupsName3, tmpData.LabelName, tmpData.GoodsCode, tmpData.GoodsName) :: integer AS Ord3 
                     FROM tmpData
                     GROUP BY tmpData.BrandName
                            , tmpData.GoodsGroupName
                            , tmpData.LabelName
                            , tmpData.LineFabricaName
                            , tmpData.CompositionName
                            , tmpData.GoodsId
                            , tmpData.GoodsCode
                            , tmpData.GoodsName
                            , tmpData.GoodsInfoName
                            , tmpData.GroupsName1
                            , tmpData.GroupsName2
                            , tmpData.GroupsName3
                            , tmpData.GroupsName4
                      ;
    RETURN NEXT Cursor1;

    -- Результат 2 данные
    OPEN Cursor2 FOR
        WITH
         tmpSize AS (SELECT CASE WHEN tmpSize.Ord =  1 THEN tmpSize.SizeName  ELSE '' END AS SizeName1
                          , CASE WHEN tmpSize.Ord =  2 THEN tmpSize.SizeName  ELSE '' END AS SizeName2
                          , CASE WHEN tmpSize.Ord =  3 THEN tmpSize.SizeName  ELSE '' END AS SizeName3
                          , CASE WHEN tmpSize.Ord =  4 THEN tmpSize.SizeName  ELSE '' END AS SizeName4
                          , CASE WHEN tmpSize.Ord =  5 THEN tmpSize.SizeName  ELSE '' END AS SizeName5
                          , CASE WHEN tmpSize.Ord =  6 THEN tmpSize.SizeName  ELSE '' END AS SizeName6
                          , CASE WHEN tmpSize.Ord =  7 THEN tmpSize.SizeName  ELSE '' END AS SizeName7
                          , CASE WHEN tmpSize.Ord =  8 THEN tmpSize.SizeName  ELSE '' END AS SizeName8
                          , CASE WHEN tmpSize.Ord =  9 THEN tmpSize.SizeName  ELSE '' END AS SizeName9
                          , CASE WHEN tmpSize.Ord = 10 THEN tmpSize.SizeName  ELSE '' END AS SizeName10
                          , CASE WHEN tmpSize.Ord = 11 THEN tmpSize.SizeName  ELSE '' END AS SizeName11
                          , CASE WHEN tmpSize.Ord = 12 THEN tmpSize.SizeName  ELSE '' END AS SizeName12
                          , CASE WHEN tmpSize.Ord = 13 THEN tmpSize.SizeName  ELSE '' END AS SizeName13
                          , CASE WHEN tmpSize.Ord = 14 THEN tmpSize.SizeName  ELSE '' END AS SizeName14
                          , CASE WHEN tmpSize.Ord = 15 THEN tmpSize.SizeName  ELSE '' END AS SizeName15
                          , CASE WHEN tmpSize.Ord = 16 THEN tmpSize.SizeName  ELSE '' END AS SizeName16
                          , CASE WHEN tmpSize.Ord = 17 THEN tmpSize.SizeName  ELSE '' END AS SizeName17
                          , CASE WHEN tmpSize.Ord = 18 THEN tmpSize.SizeName  ELSE '' END AS SizeName18
                          , CASE WHEN tmpSize.Ord = 19 THEN tmpSize.SizeName  ELSE '' END AS SizeName19
                          , CASE WHEN tmpSize.Ord = 20 THEN tmpSize.SizeName  ELSE '' END AS SizeName20
                          , CASE WHEN tmpSize.Ord = 21 THEN tmpSize.SizeName  ELSE '' END AS SizeName21
                          , CASE WHEN tmpSize.Ord = 22 THEN tmpSize.SizeName  ELSE '' END AS SizeName22
                          , CASE WHEN tmpSize.Ord = 23 THEN tmpSize.SizeName  ELSE '' END AS SizeName23
                          , CASE WHEN tmpSize.Ord = 24 THEN tmpSize.SizeName  ELSE '' END AS SizeName24
                          , CASE WHEN tmpSize.Ord = 25 THEN tmpSize.SizeName  ELSE '' END AS SizeName25
                          , CASE WHEN tmpSize.Ord = 26 THEN tmpSize.SizeName  ELSE '' END AS SizeName26
                          , CASE WHEN tmpSize.Ord = 27 THEN tmpSize.SizeName  ELSE '' END AS SizeName27
                          , CASE WHEN tmpSize.Ord = 28 THEN tmpSize.SizeName  ELSE '' END AS SizeName28
                          , CASE WHEN tmpSize.Ord = 29 THEN tmpSize.SizeName  ELSE '' END AS SizeName29
                          , CASE WHEN tmpSize.Ord = 30 THEN tmpSize.SizeName  ELSE '' END AS SizeName30
                          , CASE WHEN tmpSize.Ord = 31 THEN tmpSize.SizeName  ELSE '' END AS SizeName31
                          , CASE WHEN tmpSize.Ord = 32 THEN tmpSize.SizeName  ELSE '' END AS SizeName32
                          , CASE WHEN tmpSize.Ord = 33 THEN tmpSize.SizeName  ELSE '' END AS SizeName33
                          , CASE WHEN tmpSize.Ord = 34 THEN tmpSize.SizeName  ELSE '' END AS SizeName34
                          , CASE WHEN tmpSize.Ord = 35 THEN tmpSize.SizeName  ELSE '' END AS SizeName35
                          , CASE WHEN tmpSize.Ord = 36 THEN tmpSize.SizeName  ELSE '' END AS SizeName36
                          , CASE WHEN tmpSize.Ord = 37 THEN tmpSize.SizeName  ELSE '' END AS SizeName37
                          , CASE WHEN tmpSize.Ord = 38 THEN tmpSize.SizeName  ELSE '' END AS SizeName38
                          , CASE WHEN tmpSize.Ord = 39 THEN tmpSize.SizeName  ELSE '' END AS SizeName39
                          , CASE WHEN tmpSize.Ord = 40 THEN tmpSize.SizeName  ELSE '' END AS SizeName40
                          , CASE WHEN tmpSize.Ord = 41 THEN tmpSize.SizeName  ELSE '' END AS SizeName41
                          , CASE WHEN tmpSize.Ord = 42 THEN tmpSize.SizeName  ELSE '' END AS SizeName42
                          , CASE WHEN tmpSize.Ord = 43 THEN tmpSize.SizeName  ELSE '' END AS SizeName43
                          , CASE WHEN tmpSize.Ord = 44 THEN tmpSize.SizeName  ELSE '' END AS SizeName44
                          , CASE WHEN tmpSize.Ord = 45 THEN tmpSize.SizeName  ELSE '' END AS SizeName45
                          , CASE WHEN tmpSize.Ord = 46 THEN tmpSize.SizeName  ELSE '' END AS SizeName46
                          , CASE WHEN tmpSize.Ord = 47 THEN tmpSize.SizeName  ELSE '' END AS SizeName47
                          , CASE WHEN tmpSize.Ord = 48 THEN tmpSize.SizeName  ELSE '' END AS SizeName48
                          , CASE WHEN tmpSize.Ord = 49 THEN tmpSize.SizeName  ELSE '' END AS SizeName49
                          , CASE WHEN tmpSize.Ord = 50 THEN tmpSize.SizeName  ELSE '' END AS SizeName50
                          , CASE WHEN tmpSize.Ord = 51 THEN tmpSize.SizeName  ELSE '' END AS SizeName51
                          , CASE WHEN tmpSize.Ord = 52 THEN tmpSize.SizeName  ELSE '' END AS SizeName52
                          , CASE WHEN tmpSize.Ord = 53 THEN tmpSize.SizeName  ELSE '' END AS SizeName53
                          , CASE WHEN tmpSize.Ord = 54 THEN tmpSize.SizeName  ELSE '' END AS SizeName54
                          , CASE WHEN tmpSize.Ord = 55 THEN tmpSize.SizeName  ELSE '' END AS SizeName55
                          , CASE WHEN tmpSize.Ord = 56 THEN tmpSize.SizeName  ELSE '' END AS SizeName56
                          , CASE WHEN tmpSize.Ord = 57 THEN tmpSize.SizeName  ELSE '' END AS SizeName57
                          , CASE WHEN tmpSize.Ord = 58 THEN tmpSize.SizeName  ELSE '' END AS SizeName58
                          , CASE WHEN tmpSize.Ord = 59 THEN tmpSize.SizeName  ELSE '' END AS SizeName59
                          , CASE WHEN tmpSize.Ord = 60 THEN tmpSize.SizeName  ELSE '' END AS SizeName60
                          , CASE WHEN tmpSize.Ord = 61 THEN tmpSize.SizeName  ELSE '' END AS SizeName61
                          , CASE WHEN tmpSize.Ord = 62 THEN tmpSize.SizeName  ELSE '' END AS SizeName62
                          , CASE WHEN tmpSize.Ord = 63 THEN tmpSize.SizeName  ELSE '' END AS SizeName63
                          , CASE WHEN tmpSize.Ord = 64 THEN tmpSize.SizeName  ELSE '' END AS SizeName64
                          , CASE WHEN tmpSize.Ord = 65 THEN tmpSize.SizeName  ELSE '' END AS SizeName65
                          , CASE WHEN tmpSize.Ord = 66 THEN tmpSize.SizeName  ELSE '' END AS SizeName66
                          , CASE WHEN tmpSize.Ord = 67 THEN tmpSize.SizeName  ELSE '' END AS SizeName67
                          , CASE WHEN tmpSize.Ord = 68 THEN tmpSize.SizeName  ELSE '' END AS SizeName68
                          , CASE WHEN tmpSize.Ord = 69 THEN tmpSize.SizeName  ELSE '' END AS SizeName69
                          , CASE WHEN tmpSize.Ord = 70 THEN tmpSize.SizeName  ELSE '' END AS SizeName70
                     FROM _tmpSize AS tmpSize
                     )

          --результат
          SELECT MAX (tmpSize.SizeName1) AS SizeName1
               , MAX (tmpSize.SizeName2) AS SizeName2
               , MAX (tmpSize.SizeName3) AS SizeName3
               , MAX (tmpSize.SizeName4) AS SizeName4
               , MAX (tmpSize.SizeName5) AS SizeName5
               , MAX (tmpSize.SizeName6) AS SizeName6
               , MAX (tmpSize.SizeName7) AS SizeName7
               , MAX (tmpSize.SizeName8) AS SizeName8
               , MAX (tmpSize.SizeName9) AS SizeName9
               , MAX (tmpSize.SizeName10) AS SizeName10
               , MAX (tmpSize.SizeName11) AS SizeName11
               , MAX (tmpSize.SizeName12) AS SizeName12
               , MAX (tmpSize.SizeName13) AS SizeName13
               , MAX (tmpSize.SizeName14) AS SizeName14
               , MAX (tmpSize.SizeName15) AS SizeName15
               , MAX (tmpSize.SizeName16) AS SizeName16
               , MAX (tmpSize.SizeName17) AS SizeName17
               , MAX (tmpSize.SizeName18) AS SizeName18
               , MAX (tmpSize.SizeName19) AS SizeName19
               , MAX (tmpSize.SizeName20) AS SizeName20
               , MAX (tmpSize.SizeName21) AS SizeName21
               , MAX (tmpSize.SizeName22) AS SizeName22
               , MAX (tmpSize.SizeName23) AS SizeName23
               , MAX (tmpSize.SizeName24) AS SizeName24
               , MAX (tmpSize.SizeName25) AS SizeName25
               , MAX (tmpSize.SizeName26) AS SizeName26
               , MAX (tmpSize.SizeName27) AS SizeName27
               , MAX (tmpSize.SizeName28) AS SizeName28
               , MAX (tmpSize.SizeName29) AS SizeName29
               , MAX (tmpSize.SizeName30) AS SizeName30
               , MAX (tmpSize.SizeName31) AS SizeName31
               , MAX (tmpSize.SizeName32) AS SizeName32
               , MAX (tmpSize.SizeName33) AS SizeName33
               , MAX (tmpSize.SizeName34) AS SizeName34
               , MAX (tmpSize.SizeName35) AS SizeName35
               , MAX (tmpSize.SizeName36) AS SizeName36
               , MAX (tmpSize.SizeName37) AS SizeName37
               , MAX (tmpSize.SizeName38) AS SizeName38
               , MAX (tmpSize.SizeName39) AS SizeName39
               , MAX (tmpSize.SizeName40) AS SizeName40
               , MAX (tmpSize.SizeName41) AS SizeName41
               , MAX (tmpSize.SizeName42) AS SizeName42
               , MAX (tmpSize.SizeName43) AS SizeName43
               , MAX (tmpSize.SizeName44) AS SizeName44
               , MAX (tmpSize.SizeName45) AS SizeName45
               , MAX (tmpSize.SizeName46) AS SizeName46
               , MAX (tmpSize.SizeName47) AS SizeName47
               , MAX (tmpSize.SizeName48) AS SizeName48
               , MAX (tmpSize.SizeName49) AS SizeName49
               , MAX (tmpSize.SizeName50) AS SizeName50
               , MAX (tmpSize.SizeName51) AS SizeName51
               , MAX (tmpSize.SizeName52) AS SizeName52
               , MAX (tmpSize.SizeName53) AS SizeName53
               , MAX (tmpSize.SizeName54) AS SizeName54
               , MAX (tmpSize.SizeName55) AS SizeName55
               , MAX (tmpSize.SizeName56) AS SizeName56
               , MAX (tmpSize.SizeName57) AS SizeName57
               , MAX (tmpSize.SizeName58) AS SizeName58
               , MAX (tmpSize.SizeName59) AS SizeName59
               , MAX (tmpSize.SizeName60) AS SizeName60
               , MAX (tmpSize.SizeName61) AS SizeName61
               , MAX (tmpSize.SizeName62) AS SizeName62
               , MAX (tmpSize.SizeName63) AS SizeName63
               , MAX (tmpSize.SizeName64) AS SizeName64
               , MAX (tmpSize.SizeName65) AS SizeName65
               , MAX (tmpSize.SizeName66) AS SizeName66
               , MAX (tmpSize.SizeName67) AS SizeName67
               , MAX (tmpSize.SizeName68) AS SizeName68
               , MAX (tmpSize.SizeName69) AS SizeName69
               , MAX (tmpSize.SizeName70) AS SizeName70
            FROM tmpSize
            ;

    RETURN NEXT Cursor2;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.18         *
*/

-- тест
--select * from gpReport_SaleOLAP_Analysis(inStartDate := ('01.03.2018')::TDateTime , inEndDate := ('30.04.2018')::TDateTime , inUnitId := 0 , inPartnerId := 0 , inBrandId := 860 , inPeriodId := 0 , inStartYear := 2018 , inEndYear := 0 , inIsMark := 'False' ,  inSession := '8');
--FETCH ALL "<unnamed portal 48>";