-- Function: gpReport_SoldTable_Commerc_Olap ()

DROP FUNCTION IF EXISTS gpReport_SoldTable_Commerc_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SoldTable_Commerc_Olap (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inBranchId     Integer   , -- ***Филиал
    IN inAreaId       Integer   , -- ***Регион (контрагенты -> юр лица)
    IN inRetailId     Integer   , -- ***Торговая сеть (юр лица)
    IN inJuridicalId  Integer   , --
    IN inPaidKindId   Integer   , --
    IN inTradeMarkId  Integer   , -- *** 
    IN inGoodsGroupId Integer   , -- 
    IN inInfoMoneyId  Integer   , -- Управленческая статья
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_ukr TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar, GoodsKindName_basis TVarChar, MeasureName_basis TVarChar
             , MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar, GoodsGroupAnalystName TVarChar
             , GoodsTagName TVarChar, GoodsGroupStatName TVarChar
             , GoodsPlatformName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar, SectionName TVarChar
             , RetailName TVarChar, RetailReportName TVarChar
             , AreaName TVarChar, PartnerTagName TVarChar, PartnerCategory TFloat
             , Address TVarChar, RegionName TVarChar, CityKindName TVarChar, CityName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar, TypeCommercName  TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar

             , PaidKindId Integer, PaidKindName TVarChar
             , OperDate TDateTime
             , MonthDate   TDateTime
             , Year        Integer
             , WeekNumber  Integer
             
             , PersonalName_1 TVarChar
             , PersonalName_2 TVarChar
             , PersonalName_3 TVarChar
             , PersonalName_4 TVarChar
             , PersonalName_5 TVarChar
             , PersonalName_6 TVarChar
             , PositionName_1 TVarChar
             , PositionName_2 TVarChar
             , PositionName_3 TVarChar
             , PositionName_4 TVarChar
             , PositionName_5 TVarChar
             , PositionName_6 TVarChar
             , UnitName_1     TVarChar
             , UnitName_2     TVarChar
             , UnitName_3     TVarChar
             , UnitName_4     TVarChar
             , UnitName_5     TVarChar
             , UnitName_6     TVarChar
               --
             , PersonalName_1ret TVarChar
             , PersonalName_2ret TVarChar
             , PersonalName_3ret TVarChar
             , PositionName_1ret TVarChar
             , PositionName_2ret TVarChar
             , PositionName_3ret TVarChar
             , UnitName_1ret     TVarChar
             , UnitName_2ret     TVarChar
             , UnitName_3ret     TVarChar

            /* , Promo_Summ TFloat, Sale_Summ TFloat, Sale_SummReal TFloat, Sale_Summ_10250 TFloat
             
             , Sale_Amount_Weight TFloat, Sale_Amount_Sh TFloat
             , Promo_AmountPartner_Weight TFloat, Promo_AmountPartner_Sh TFloat, Sale_AmountPartner_Weight TFloat, Sale_AmountPartner_Sh TFloat, Sale_AmountPartnerR_Weight TFloat, Sale_AmountPartnerR_Sh TFloat
             , Return_Summ TFloat
             , Return_Amount_Weight TFloat, Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat, Return_AmountPartner_Sh TFloat
              */
           
             , Return_AmountPartner_Weight TFloat
             , Return_AmountPartner_Sh     TFloat
             , Return_Summ                 TFloat
             , Sale_AmountPartner_Weight_noPromo TFloat
             , Sale_AmountPartner_Sh_noPromo     TFloat
             , Sale_Summ_NoPromo                 TFloat
             , Promo_AmountPartner_Weight        TFloat
             , Promo_AmountPartner_Sh            TFloat
             , Sale_AmountPartner_Weight_noReturn TFloat
             , Sale_AmountPartner_Sh_noReturn     TFloat
             , Sale_Summ_NoReturn               TFloat
             , Sale_Summ                       TFloat
             , Sale_Summ_10250                 TFloat
             , Promo_Summ                      TFloat
             , Sale_AmountPartner_Weight       TFloat
             , Sale_AmountPartner_Sh           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId_Constraint_Branch Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- определяется уровень доступа
    vbObjectId_Constraint_Branch:= (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId
                                    FROM Object_RoleAccessKeyGuide_View
                                    WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0
                                      -- Отчет продажа/возврат - все филиалы
                                      AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 7376335)
                                   );
    -- !!!меняется параметр!!!
    IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;

    -- для оптимизации
    inJuridicalId:= COALESCE (inJuridicalId, 0);
    inInfoMoneyId:= COALESCE (inInfoMoneyId, 0);
    inPaidKindId := COALESCE (inPaidKindId, 0);
    inBranchId   := COALESCE (inBranchId, 0);

    --
    vbGoodsPropertyId_basis := zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0);


    -- Результат
    RETURN QUERY
    -- собираем все данные
    WITH _tmpGoods AS
          (SELECT lfObject_Goods_byGoodsGroup.GoodsId AS GoodsId
                , COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0)  AS TradeMarkId
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           WHERE (ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId OR COALESCE (inTradeMarkId, 0) = 0)
             AND inGoodsGroupId > 0 -- !!!

          UNION
           SELECT Object_Goods.Id AS GoodsId
                , COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0)  AS TradeMarkId
           FROM Object AS Object_Goods
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           WHERE Object_Goods.DescId = zc_Object_Goods()
             AND Object_Goods.isErased = FALSE
             AND (ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId OR COALESCE (inTradeMarkId, 0) = 0)
             AND COALESCE (inGoodsGroupId, 0) = 0
          )

       , tmpInfoMoney AS (SELECT * FROM Object_InfoMoney_View WHERE InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()) -- !!!Доходы!!!)

      , tmpOperationGroup_all AS
                        (SELECT SoldTable.Id                  AS MovementId
                              , SoldTable.BranchId
                              , SoldTable.JuridicalGroupId    AS JuridicalGroupId
                              , SoldTable.JuridicalId         AS JuridicalId
                              , SoldTable.PartnerId           AS PartnerId
                              , SoldTable.InfoMoneyId
                              , SoldTable.RetailId            AS RetailId
                              , SoldTable.RetailReportId      AS RetailReportId
                              , SoldTable.AreaId              AS AreaId
                              , SoldTable.PartnerTagId        AS PartnerTagId
                              , SoldTable.ContractId          AS ContractId
                              , SoldTable.ContractTagId       AS ContractTagId
                              , SoldTable.ContractTagGroupId  AS ContractTagGroupId
                              , SoldTable.UserId_order        AS UserId_order
                              , SoldTable.UserId_source_order AS UserId_source_order
                              , SoldTable.RouteTTId           AS RouteTTId

                              , SoldTable.GoodsPlatformId       AS GoodsPlatformId
                              , SoldTable.TradeMarkId           AS TradeMarkId
                              , SoldTable.GoodsGroupAnalystId   AS GoodsGroupAnalystId
                              , SoldTable.GoodsGroupId          AS GoodsGroupId
                              , SoldTable.GoodsGroupStatId      AS GoodsGroupStatId
                              , SoldTable.GoodsTagId            AS GoodsTagId
                              , SoldTable.GoodsId               AS GoodsId
                              , SoldTable.GoodsKindId           AS GoodsKindId
                              , SoldTable.MeasureId             AS MeasureId

                              , SoldTable.RegionId              AS RegionId
                              , SoldTable.CityKindId            AS CityKindId
                              , SoldTable.CityId                AS CityId
                              , SoldTable.PaidKindId
                              --, CASE WHEN inIsDate = TRUE THEN SoldTable.OperDate ELSE NULL END ::TDateTime AS OperDate
                              , SoldTable.OperDate  ::TDateTime AS OperDate

                              , SUM (SoldTable.Actions_Summ) AS Promo_Summ
                              , SUM (SoldTable.Sale_Summ)    AS Sale_Summ
                              , SUM (SoldTable.Return_Summ)  AS Return_Summ

                              , SUM (SoldTable.Sale_Summ_10250)   AS Sale_Summ_10250      --акции

                              , SUM (SoldTable.Sale_Amount_Weight)   AS Sale_Amount_Weight
                              , SUM (SoldTable.Sale_Amount_Sh)       AS Sale_Amount_Sh
                              , SUM (SoldTable.Return_Amount_Weight) AS Return_Amount_Weight
                              , SUM (SoldTable.Return_Amount_Sh)     AS Return_Amount_Sh

                              , SUM (SoldTable.Actions_Weight)              AS Promo_AmountPartner_Weight
                              , SUM (SoldTable.Actions_Sh)                  AS Promo_AmountPartner_Sh
                              , SUM (SoldTable.Sale_AmountPartner_Weight)   AS Sale_AmountPartner_Weight
                              , SUM (SoldTable.Sale_AmountPartner_Sh)       AS Sale_AmountPartner_Sh
                              , SUM (SoldTable.Return_AmountPartner_Weight) AS Return_AmountPartner_Weight
                              , SUM (SoldTable.Return_AmountPartner_Sh)     AS Return_AmountPartner_Sh

                              , zfCalc_GoodsPropertyId (SoldTable.ContractId, SoldTable.JuridicalId, SoldTable.PartnerId) AS GoodsPropertyId

                          FROM SoldTable

                         WHERE SoldTable.OperDate BETWEEN inStartDate AND inEndDate
                           AND (SoldTable.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                           AND (SoldTable.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                           AND (SoldTable.PaidKindId  = inPaidKindId  OR inPaidKindId  = 0)
                           AND (SoldTable.BranchId    = inBranchId    OR inBranchId    = 0)
                           AND (SoldTable.AreaId      = inAreaId      OR inAreaId      = 0)
                           AND (SoldTable.RetailId    = inRetailId    OR inRetailId    = 0)
                         GROUP BY SoldTable.Id
                                , SoldTable.BranchId
                                , SoldTable.JuridicalGroupId
                                , SoldTable.JuridicalId
                                , SoldTable.PartnerId
                                , SoldTable.InfoMoneyId
                                , SoldTable.RetailId
                                , SoldTable.RetailReportId
                                , SoldTable.AreaId
                                , SoldTable.PartnerTagId
                                , SoldTable.ContractId         
                                , SoldTable.ContractTagId      
                                , SoldTable.ContractTagGroupId 

                               , SoldTable.GoodsPlatformId
                               , SoldTable.TradeMarkId
                               , SoldTable.GoodsGroupAnalystId
                               , SoldTable.GoodsGroupId
                               , SoldTable.GoodsGroupStatId
                               , SoldTable.GoodsTagId
                               , SoldTable.GoodsId
                               , SoldTable.GoodsKindId
                               , SoldTable.MeasureId
 
                               , SoldTable.RegionId       
                                 
                               , SoldTable.CityKindId     
                               , SoldTable.CityId         
                               , SoldTable.PaidKindId
                               , SoldTable.OperDate
                               , zfCalc_GoodsPropertyId (SoldTable.ContractId, SoldTable.JuridicalId, SoldTable.PartnerId)
                               , SoldTable.UserId_order
                               , SoldTable.UserId_source_order
                               , SoldTable.RouteTTId
                         HAVING SUM (SoldTable.Actions_Summ)   <> 0
                             OR SUM (SoldTable.Sale_Summ)    <> 0
                             OR SUM (SoldTable.Return_Summ)  <> 0
                             OR SUM (SoldTable.Sale_Summ_10250)   <> 0

                             OR SUM (SoldTable.Sale_Amount_Weight)   <> 0
                             OR SUM (SoldTable.Sale_Amount_Sh)       <> 0
                             OR SUM (SoldTable.Return_Amount_Weight) <> 0
                             OR SUM (SoldTable.Return_Amount_Sh)     <> 0

                             OR SUM (SoldTable.Actions_Weight)  <> 0
                             OR SUM (SoldTable.Actions_Sh)      <> 0
                             OR SUM (SoldTable.Sale_AmountPartner_Weight)   <> 0
                             OR SUM (SoldTable.Sale_AmountPartner_Sh)       <> 0
                             OR SUM (SoldTable.Return_AmountPartner_Weight) <> 0
                             OR SUM (SoldTable.Return_AmountPartner_Sh)     <> 0
                        )
     /*  , tmpOperationGroup1 AS
                        (SELECT SoldTable.MovementId
                              , SoldTable.BranchId
                              , SoldTable.JuridicalGroupId
                              , SoldTable.JuridicalId
                              , SoldTable.PartnerId
                              , SoldTable.InfoMoneyId
                              , SoldTable.RetailId           
                              , SoldTable.RetailReportId     
                              , SoldTable.AreaId             
                              , SoldTable.PartnerTagId       
                              , SoldTable.ContractId         
                              , SoldTable.ContractTagId      
                              , SoldTable.ContractTagGroupId 

                              , SoldTable.GoodsPlatformId     
                              , SoldTable.TradeMarkId         
                              , SoldTable.GoodsGroupAnalystId 
                              , SoldTable.GoodsGroupId     
                              , SoldTable.GoodsGroupStatId 
                              , SoldTable.GoodsTagId       
                              , SoldTable.GoodsId          
                              , SoldTable.GoodsKindId      
                              , SoldTable.MeasureId        

                              , SoldTable.RegionId       
                              , SoldTable.CityKindId     
                              , SoldTable.CityId         
                              , SoldTable.PaidKindId
                              , SoldTable.OperDate

                              , SUM (SoldTable.Promo_Summ)   AS Promo_Summ
                              , SUM (SoldTable.Sale_Summ)    AS Sale_Summ
                              , SUM (SoldTable.Return_Summ)  AS Return_Summ

                              , SUM (SoldTable.Sale_Summ_10250)   AS Sale_Summ_10250

                              , SUM (SoldTable.Sale_Amount_Weight)   AS Sale_Amount_Weight
                              , SUM (SoldTable.Sale_Amount_Sh)       AS Sale_Amount_Sh
                              , SUM (SoldTable.Return_Amount_Weight) AS Return_Amount_Weight
                              , SUM (SoldTable.Return_Amount_Sh)     AS Return_Amount_Sh

                              , SUM (SoldTable.Promo_AmountPartner_Weight)  AS Promo_AmountPartner_Weight
                              , SUM (SoldTable.Promo_AmountPartner_Sh)      AS Promo_AmountPartner_Sh
                              , SUM (SoldTable.Sale_AmountPartner_Weight)   AS Sale_AmountPartner_Weight
                              , SUM (SoldTable.Sale_AmountPartner_Sh)       AS Sale_AmountPartner_Sh
                              , SUM (SoldTable.Return_AmountPartner_Weight) AS Return_AmountPartner_Weight
                              , SUM (SoldTable.Return_AmountPartner_Sh)     AS Return_AmountPartner_Sh

                              , SoldTable.GoodsPropertyId

                         FROM tmpOperationGroup_all AS SoldTable
                         GROUP BY SoldTable.MovementId
                                , SoldTable.BranchId
                                , SoldTable.JuridicalGroupId
                                , SoldTable.JuridicalId
                                , SoldTable.PartnerId
                                , SoldTable.InfoMoneyId
                                , SoldTable.RetailId           
                                , SoldTable.RetailReportId     
                                , SoldTable.AreaId             
                                , SoldTable.PartnerTagId       
                                , SoldTable.ContractId         
                                , SoldTable.ContractTagId      
                                , SoldTable.ContractTagGroupId 
  
                                , SoldTable.GoodsPlatformId     
                                , SoldTable.TradeMarkId         
                                , SoldTable.GoodsGroupAnalystId 
                                , SoldTable.GoodsGroupId     
                                , SoldTable.GoodsGroupStatId 
                                , SoldTable.GoodsTagId       
                                , SoldTable.GoodsId          
                                , SoldTable.GoodsKindId      
                                , SoldTable.MeasureId        
  
                                , SoldTable.RegionId
                                , SoldTable.CityKindId     
                                , SoldTable.CityId    
                                , SoldTable.PaidKindId
                                , SoldTable.OperDate
                                , SoldTable.GoodsPropertyId
                         HAVING SUM (SoldTable.Promo_Summ)   <> 0
                             OR SUM (SoldTable.Sale_Summ)    <> 0
                             OR SUM (SoldTable.Return_Summ)  <> 0
                             OR SUM (SoldTable.Sale_Summ_10250)   <> 0

                             OR SUM (SoldTable.Sale_Amount_Weight)   <> 0
                             OR SUM (SoldTable.Sale_Amount_Sh)       <> 0
                             OR SUM (SoldTable.Return_Amount_Weight) <> 0
                             OR SUM (SoldTable.Return_Amount_Sh)     <> 0

                             OR SUM (SoldTable.Promo_AmountPartner_Weight)  <> 0
                             OR SUM (SoldTable.Promo_AmountPartner_Sh)      <> 0
                             OR SUM (SoldTable.Sale_AmountPartner_Weight)   <> 0
                             OR SUM (SoldTable.Sale_AmountPartner_Sh)       <> 0
                             OR SUM (SoldTable.Return_AmountPartner_Weight) <> 0
                             OR SUM (SoldTable.Return_AmountPartner_Sh)     <> 0
                        )
                 */      
       --выбираем уник. ключ для получения данных CommercLocal
       , tmpParams_CommercLocal AS (SELECT DISTINCT 
                                           tmp.UserId_order
                                         , tmp.UserId_source_order
                                         , tmp.RetailId
                                         , tmp.RouteTTId
                                         , tmp.PartnerId
                                    FROM tmpOperationGroup_all AS tmp
                                    )         
       , tmpParams_CommercRetail AS (SELECT DISTINCT 
                                            tmp.UserId_order
                                          , tmp.RetailId
                                          , tmp.ContractTagId
                                     FROM tmpOperationGroup_all AS tmp
                                     )         

       , tmpCommercLocal AS (SELECT tmp.UserId_order
                                  , tmp.UserId_source_order
                                  , tmp.RetailId
                                  , tmp.RouteTTId
                                  , tmp.PartnerId
                                  , STRING_AGG ( tmp.PersonalName_1,';') AS PersonalName_1
                                  , STRING_AGG ( tmp.PersonalName_2,';') AS PersonalName_2
                                  , STRING_AGG ( tmp.PersonalName_3,';') AS PersonalName_3
                                  , STRING_AGG ( tmp.PersonalName_4,';') AS PersonalName_4
                                  , STRING_AGG ( tmp.PersonalName_5,';') AS PersonalName_5
                                  , STRING_AGG ( tmp.PersonalName_6,';') AS PersonalName_6
                                                                        
                                  , STRING_AGG ( tmp.PositionName_1,';') AS PositionName_1
                                  , STRING_AGG ( tmp.PositionName_2,';') AS PositionName_2
                                  , STRING_AGG ( tmp.PositionName_3,';') AS PositionName_3
                                  , STRING_AGG ( tmp.PositionName_4,';') AS PositionName_4
                                  , STRING_AGG ( tmp.PositionName_5,';') AS PositionName_5
                                  , STRING_AGG ( tmp.PositionName_6,';') AS PositionName_6
                                  
                                  , STRING_AGG ( tmp.UnitName_1,';') AS UnitName_1
                                  , STRING_AGG ( tmp.UnitName_2,';') AS UnitName_2
                                  , STRING_AGG ( tmp.UnitName_3,';') AS UnitName_3
                                  , STRING_AGG ( tmp.UnitName_4,';') AS UnitName_4
                                  , STRING_AGG ( tmp.UnitName_5,';') AS UnitName_5
                                  , STRING_AGG ( tmp.UnitName_6,';') AS UnitName_6
                        FROM (SELECT tmp.UserId_order
                                   , tmp.UserId_source_order
                                   , tmp.RetailId
                                   , tmp.RouteTTId
                                   , tmp.PartnerId
                                   , CASE WHEN tmpCommercLocal.Ord = 1 THEN tmpCommercLocal.PersonalName ELSE NULL END AS PersonalName_1
                                   , CASE WHEN tmpCommercLocal.Ord = 2 THEN tmpCommercLocal.PersonalName ELSE NULL END AS PersonalName_2
                                   , CASE WHEN tmpCommercLocal.Ord = 3 THEN tmpCommercLocal.PersonalName ELSE NULL END AS PersonalName_3
                                   , CASE WHEN tmpCommercLocal.Ord = 4 THEN tmpCommercLocal.PersonalName ELSE NULL END AS PersonalName_4
                                   , CASE WHEN tmpCommercLocal.Ord = 5 THEN tmpCommercLocal.PersonalName ELSE NULL END AS PersonalName_5
                                   , CASE WHEN tmpCommercLocal.Ord = 6 THEN tmpCommercLocal.PersonalName ELSE NULL END AS PersonalName_6
                                   
                                   , CASE WHEN tmpCommercLocal.Ord = 1 THEN tmpCommercLocal.PositionName ELSE NULL END AS PositionName_1
                                   , CASE WHEN tmpCommercLocal.Ord = 2 THEN tmpCommercLocal.PositionName ELSE NULL END AS PositionName_2
                                   , CASE WHEN tmpCommercLocal.Ord = 3 THEN tmpCommercLocal.PositionName ELSE NULL END AS PositionName_3
                                   , CASE WHEN tmpCommercLocal.Ord = 4 THEN tmpCommercLocal.PositionName ELSE NULL END AS PositionName_4
                                   , CASE WHEN tmpCommercLocal.Ord = 5 THEN tmpCommercLocal.PositionName ELSE NULL END AS PositionName_5
                                   , CASE WHEN tmpCommercLocal.Ord = 6 THEN tmpCommercLocal.PositionName ELSE NULL END AS PositionName_6
                                   
                                   , CASE WHEN tmpCommercLocal.Ord = 1 THEN tmpCommercLocal.UnitName ELSE NULL END AS UnitName_1
                                   , CASE WHEN tmpCommercLocal.Ord = 2 THEN tmpCommercLocal.UnitName ELSE NULL END AS UnitName_2
                                   , CASE WHEN tmpCommercLocal.Ord = 3 THEN tmpCommercLocal.UnitName ELSE NULL END AS UnitName_3
                                   , CASE WHEN tmpCommercLocal.Ord = 4 THEN tmpCommercLocal.UnitName ELSE NULL END AS UnitName_4
                                   , CASE WHEN tmpCommercLocal.Ord = 5 THEN tmpCommercLocal.UnitName ELSE NULL END AS UnitName_5
                                   , CASE WHEN tmpCommercLocal.Ord = 6 THEN tmpCommercLocal.UnitName ELSE NULL END AS UnitName_6
                              FROM tmpParams_CommercLocal AS tmp
                                   LEFT JOIN lpSelect_Object_CommercLocal_choice  (tmp.UserId_order
                                                                                 , tmp.UserId_source_order
                                                                                 , tmp.RetailId
                                                                                 , tmp.RouteTTId
                                                                                 , tmp.PartnerId
                                                                                 , inSession::TVarChar) AS tmpCommercLocal ON 1 = 1 
                              ) AS tmp
                        GROUP BY tmp.UserId_order
                               , tmp.UserId_source_order
                               , tmp.RetailId
                               , tmp.RouteTTId
                               , tmp.PartnerId
                        )
       , tmpCommercRetail AS (SELECT tmp.UserId_order
                                   , tmp.RetailId
                                   , tmp.ContractTagId
     
                                   , STRING_AGG ( tmp.PersonalName_1ret,';') AS PersonalName_1ret
                                   , STRING_AGG ( tmp.PersonalName_2ret,';') AS PersonalName_2ret
                                   , STRING_AGG ( tmp.PersonalName_3ret,';') AS PersonalName_3ret
                                                          
                                   , STRING_AGG ( tmp.PositionName_1ret,';') AS PositionName_1ret
                                   , STRING_AGG ( tmp.PositionName_2ret,';') AS PositionName_2ret
                                   , STRING_AGG ( tmp.PositionName_3ret,';') AS PositionName_3ret
                                   
                                   , STRING_AGG ( tmp.UnitName_1ret,';') AS UnitName_1ret
                                   , STRING_AGG ( tmp.UnitName_2ret,';') AS UnitName_2ret
                                   , STRING_AGG ( tmp.UnitName_3ret,';') AS UnitName_3ret
                        FROM (SELECT tmp.UserId_order
                                   , tmp.RetailId
                                   , tmp.ContractTagId
                                   , CASE WHEN tmpCommercRetail.Ord = 1 THEN tmpCommercRetail.PersonalName ELSE NULL END AS PersonalName_1ret
                                   , CASE WHEN tmpCommercRetail.Ord = 2 THEN tmpCommercRetail.PersonalName ELSE NULL END AS PersonalName_2ret
                                   , CASE WHEN tmpCommercRetail.Ord = 3 THEN tmpCommercRetail.PersonalName ELSE NULL END AS PersonalName_3ret
                                   
                                   , CASE WHEN tmpCommercRetail.Ord = 1 THEN tmpCommercRetail.PositionName ELSE NULL END AS PositionName_1ret
                                   , CASE WHEN tmpCommercRetail.Ord = 2 THEN tmpCommercRetail.PositionName ELSE NULL END AS PositionName_2ret
                                   , CASE WHEN tmpCommercRetail.Ord = 3 THEN tmpCommercRetail.PositionName ELSE NULL END AS PositionName_3ret
                                   
                                   , CASE WHEN tmpCommercRetail.Ord = 1 THEN tmpCommercRetail.UnitName ELSE NULL END AS UnitName_1ret
                                   , CASE WHEN tmpCommercRetail.Ord = 2 THEN tmpCommercRetail.UnitName ELSE NULL END AS UnitName_2ret
                                   , CASE WHEN tmpCommercRetail.Ord = 3 THEN tmpCommercRetail.UnitName ELSE NULL END AS UnitName_3ret
                              FROM tmpParams_CommercRetail AS tmp
                                   LEFT JOIN lpSelect_Object_CommercRetail_choice  (tmp.UserId_order
                                                                                  , tmp.RetailId
                                                                                  , tmp.ContractTagId
                                                                                  , inSession::TVarChar) AS tmpCommercRetail ON 1 = 1 
                              ) AS tmp
                        GROUP BY tmp.UserId_order
                               , tmp.RetailId
                               , tmp.ContractTagId
                        )

       , tmpOperationGroup AS
                        (SELECT SoldTable.BranchId
                              , SoldTable.JuridicalGroupId
                              , SoldTable.JuridicalId
                              , SoldTable.PartnerId
                              , SoldTable.InfoMoneyId
                              , SoldTable.RetailId           
                              , SoldTable.RetailReportId     
                              , SoldTable.AreaId             
                              , SoldTable.PartnerTagId       
                              , SoldTable.ContractId         
                              , SoldTable.ContractTagId      
                              , SoldTable.ContractTagGroupId 

                              , SoldTable.GoodsPlatformId     
                              , SoldTable.TradeMarkId         
                              , SoldTable.GoodsGroupAnalystId 
                              , SoldTable.GoodsGroupId     
                              , SoldTable.GoodsGroupStatId 
                              , SoldTable.GoodsTagId       
                              , SoldTable.GoodsId          
                              , SoldTable.GoodsKindId      
                              , SoldTable.MeasureId        

                              , SoldTable.RegionId       
                              , SoldTable.CityKindId     
                              , SoldTable.CityId         
                              , SoldTable.PaidKindId
                              , SoldTable.OperDate

                              , SUM (SoldTable.Promo_Summ)   AS Promo_Summ
                              , SUM (SoldTable.Sale_Summ)    AS Sale_Summ
                              , SUM (SoldTable.Return_Summ)  AS Return_Summ

                              , SUM (SoldTable.Sale_Summ_10250)   AS Sale_Summ_10250

                              , SUM (SoldTable.Sale_Amount_Weight)   AS Sale_Amount_Weight
                              , SUM (SoldTable.Sale_Amount_Sh)       AS Sale_Amount_Sh
                              , SUM (SoldTable.Return_Amount_Weight) AS Return_Amount_Weight
                              , SUM (SoldTable.Return_Amount_Sh)     AS Return_Amount_Sh

                              , SUM (SoldTable.Promo_AmountPartner_Weight)  AS Promo_AmountPartner_Weight
                              , SUM (SoldTable.Promo_AmountPartner_Sh)      AS Promo_AmountPartner_Sh
                              , SUM (SoldTable.Sale_AmountPartner_Weight)   AS Sale_AmountPartner_Weight
                              , SUM (SoldTable.Sale_AmountPartner_Sh)       AS Sale_AmountPartner_Sh
                              , SUM (SoldTable.Return_AmountPartner_Weight) AS Return_AmountPartner_Weight
                              , SUM (SoldTable.Return_AmountPartner_Sh)     AS Return_AmountPartner_Sh

                              , SoldTable.GoodsPropertyId
                              
                              , tmpCommercLocal.PersonalName_1
                              , tmpCommercLocal.PersonalName_2
                              , tmpCommercLocal.PersonalName_3
                              , tmpCommercLocal.PersonalName_4
                              , tmpCommercLocal.PersonalName_5
                              , tmpCommercLocal.PersonalName_6
                                                       
                              , tmpCommercLocal.PositionName_1
                              , tmpCommercLocal.PositionName_2
                              , tmpCommercLocal.PositionName_3
                              , tmpCommercLocal.PositionName_4
                              , tmpCommercLocal.PositionName_5
                              , tmpCommercLocal.PositionName_6
                              
                              , tmpCommercLocal.UnitName_1
                              , tmpCommercLocal.UnitName_2
                              , tmpCommercLocal.UnitName_3
                              , tmpCommercLocal.UnitName_4
                              , tmpCommercLocal.UnitName_5
                              , tmpCommercLocal.UnitName_6
 
                              , tmpCommercRetail.PersonalName_1ret
                              , tmpCommercRetail.PersonalName_2ret
                              , tmpCommercRetail.PersonalName_3ret
                                        
                              , tmpCommercRetail.PositionName_1ret
                              , tmpCommercRetail.PositionName_2ret
                              , tmpCommercRetail.PositionName_3ret
                              
                              , tmpCommercRetail.UnitName_1ret
                              , tmpCommercRetail.UnitName_2ret
                              , tmpCommercRetail.UnitName_3ret

                         FROM tmpOperationGroup_all AS SoldTable
                              LEFT JOIN tmpCommercLocal ON tmpCommercLocal.UserId_order = SoldTable.UserId_order
                                                       AND tmpCommercLocal.UserId_source_order= SoldTable.UserId_source_order
                                                       AND tmpCommercLocal.RetailId     = SoldTable.RetailId
                                                       AND tmpCommercLocal.RouteTTId    = SoldTable.RouteTTId
                                                       AND tmpCommercLocal.PartnerId    = SoldTable.PartnerId
                              LEFT JOIN tmpCommercRetail ON tmpCommercRetail.UserId_order = SoldTable.UserId_order
                                                        AND tmpCommercRetail.RetailId     = SoldTable.RetailId
                                                        AND tmpCommercRetail.ContractTagId= SoldTable.ContractTagId
                         GROUP BY SoldTable.BranchId
                                , SoldTable.JuridicalGroupId
                                , SoldTable.JuridicalId
                                , SoldTable.PartnerId
                                , SoldTable.InfoMoneyId
                                , SoldTable.RetailId           
                                , SoldTable.RetailReportId     
                                , SoldTable.AreaId             
                                , SoldTable.PartnerTagId       
                                , SoldTable.ContractId         
                                , SoldTable.ContractTagId      
                                , SoldTable.ContractTagGroupId 
  
                                , SoldTable.GoodsPlatformId     
                                , SoldTable.TradeMarkId         
                                , SoldTable.GoodsGroupAnalystId 
                                , SoldTable.GoodsGroupId     
                                , SoldTable.GoodsGroupStatId 
                                , SoldTable.GoodsTagId       
                                , SoldTable.GoodsId          
                                , SoldTable.GoodsKindId      
                                , SoldTable.MeasureId        
  
                                , SoldTable.RegionId       
                                
                                , SoldTable.CityKindId     
                                , SoldTable.CityId         
                                , SoldTable.PaidKindId
                                , SoldTable.OperDate
                                , SoldTable.GoodsPropertyId

                                , tmpCommercLocal.PersonalName_1
                                , tmpCommercLocal.PersonalName_2
                                , tmpCommercLocal.PersonalName_3
                                , tmpCommercLocal.PersonalName_4
                                , tmpCommercLocal.PersonalName_5
                                , tmpCommercLocal.PersonalName_6
                 
                                , tmpCommercLocal.PositionName_1
                                , tmpCommercLocal.PositionName_2
                                , tmpCommercLocal.PositionName_3
                                , tmpCommercLocal.PositionName_4
                                , tmpCommercLocal.PositionName_5
                                , tmpCommercLocal.PositionName_6

                                , tmpCommercLocal.UnitName_1
                                , tmpCommercLocal.UnitName_2
                                , tmpCommercLocal.UnitName_3
                                , tmpCommercLocal.UnitName_4
                                , tmpCommercLocal.UnitName_5
                                , tmpCommercLocal.UnitName_6

                                , tmpCommercRetail.PersonalName_1ret
                                , tmpCommercRetail.PersonalName_2ret
                                , tmpCommercRetail.PersonalName_3ret
                                          
                                , tmpCommercRetail.PositionName_1ret
                                , tmpCommercRetail.PositionName_2ret
                                , tmpCommercRetail.PositionName_3ret
                                
                                , tmpCommercRetail.UnitName_1ret
                                , tmpCommercRetail.UnitName_2ret
                                , tmpCommercRetail.UnitName_3ret
                        )

, tmpObject_GoodsPropertyValue AS (SELECT tmpGoodsProperty.GoodsPropertyId
                                  , ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                  , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                  , Object_GoodsPropertyValue.ValueData  AS Name
                             FROM (SELECT DISTINCT tmpOperationGroup.GoodsPropertyId FROM tmpOperationGroup WHERE tmpOperationGroup.GoodsPropertyId <> 0
                                  ) AS tmpGoodsProperty
                                  INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                        ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                       AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                  LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                     
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                       ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                      AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                       ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                      AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                             WHERE COALESCE (Object_GoodsPropertyValue.ValueData,'') <> ''
                             )
 , tmpObject_GoodsPropertyValueGroup AS (SELECT tmpObject_GoodsPropertyValue.GoodsPropertyId
                                              , tmpObject_GoodsPropertyValue.GoodsId
                                              , tmpObject_GoodsPropertyValue.Name
                                         FROM (SELECT tmpObject_GoodsPropertyValue.GoodsPropertyId
                                                    , MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId
                                                    , tmpObject_GoodsPropertyValue.GoodsId
                                               FROM tmpObject_GoodsPropertyValue
                                               WHERE tmpObject_GoodsPropertyValue.Name <> ''
                                               GROUP BY tmpObject_GoodsPropertyValue.GoodsPropertyId
                                                      , tmpObject_GoodsPropertyValue.GoodsId
                                              ) AS tmpGoodsProperty_find
                                              LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId = tmpGoodsProperty_find.ObjectId
                                                                                    AND tmpObject_GoodsPropertyValue.GoodsPropertyId = tmpGoodsProperty_find.GoodsPropertyId
                                        )

 , tmpObject_GoodsPropertyValue_basis AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                               , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                                               , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                               , Object_GoodsPropertyValue.ValueData  AS Name
                                          FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
                                               ) AS tmpGoodsProperty
                                               INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                     ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                    AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                               INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                                             -- AND Object_GoodsPropertyValue.ValueData <> ''
                                               LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                    ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                               LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                    ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                          WHERE COALESCE (Object_GoodsPropertyValue.ValueData,'') <> ''
                                          )

        , tmpObject_GoodsPropertyValueGroup_basis AS (SELECT tmpObject_GoodsPropertyValue.GoodsId
                                                           , tmpObject_GoodsPropertyValue.Name
                                                      FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, tmpObject_GoodsPropertyValue.GoodsId FROM tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue WHERE tmpObject_GoodsPropertyValue.Name <> '' GROUP BY tmpObject_GoodsPropertyValue.GoodsId
                                                           ) AS tmpGoodsProperty_find
                                                           LEFT JOIN tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                                                     )
        , tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpOperationGroup.JuridicalId FROM tmpOperationGroup))

  , tmpGoodsByGoodsKindParam AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                       , Object_GoodsByGoodsKind_View.GoodsKindId
                                       , Object_Goods_basis.ObjectCode        AS GoodsCode_basis
                                       , Object_Goods_basis.ValueData         AS GoodsName_basis
                                       , Object_GoodsKind_basis.ValueData     AS GoodsKindName_basis
                                       , Object_Measure.ValueData             AS MeasureName_basis
                                  FROM Object_GoodsByGoodsKind_View
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBasis
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsBasis.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsBasis.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBasis()
                                        LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId

                                        LEFT JOIN Object AS Object_GoodsKind_basis ON Object_GoodsKind_basis.Id = zc_GoodsKind_WorkProgress()

                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods_basis.Id
                                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                                  WHERE COALESCE (ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId, 0) <> 0
                                  )

     -- Результат
     SELECT Object_GoodsGroup.ValueData        AS GoodsGroupName
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.Id                    AS GoodsId
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName 
          , (CASE WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                  WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                  WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                  WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                  ELSE ''
             END) ::TVarChar  AS GoodsName_ukr
          , Object_GoodsKind.Id                AS GoodsKindId
          , Object_GoodsKind.ValueData         AS GoodsKindName
          
          , tmpGoodsByGoodsKindParam.GoodsCode_basis     ::Integer
          , tmpGoodsByGoodsKindParam.GoodsName_basis     ::TVarChar
          , tmpGoodsByGoodsKindParam.GoodsKindName_basis ::TVarChar
          , tmpGoodsByGoodsKindParam.MeasureName_basis   ::TVarChar
          
          , Object_Measure.ValueData           AS MeasureName
          , Object_TradeMark.Id         AS TradeMarkId
          , Object_TradeMark.ValueData         AS TradeMarkName
          , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
          , Object_GoodsTag.ValueData          AS GoodsTagName
          , Object_GoodsGroupStat.ValueData    AS GoodsGroupStatName
          , Object_GoodsPlatform.ValueData     AS GoodsPlatformName

          , Object_Branch.Id            AS BranchId
          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName
          , Object_Juridical.Id         AS JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , Object_Juridical.ValueData  AS JuridicalName
          , ObjectHistory_JuridicalDetails_View.OKPO
          , Object_Section.ValueData    AS SectionName

          , Object_Retail.ValueData       AS RetailName
          , Object_RetailReport.ValueData AS RetailReportName

          , Object_Area.ValueData          AS AreaName
          , Object_PartnerTag.ValueData    AS PartnerTagName
          , ObjectFloat_Category.ValueData ::TFloat AS PartnerCategory
          , ObjectString_Address.ValueData AS Address
          , Object_Region.ValueData        AS RegionName
          , Object_CityKind.ValueData      AS CityKindName
          , Object_City.ValueData          AS CityName

          , Object_Partner.Id         AS PartnerId
          , Object_Partner.ObjectCode AS PartnerCode
          , Object_Partner.ValueData  AS PartnerName
          , Object_TypeCommerc.ValueData      ::TVarChar AS TypeCommercName

          , Object_Contract.Id                AS ContractId
          , Object_Contract.ObjectCode        AS ContractCode
          , Object_Contract.ValueData         AS ContractNumber
          , Object_ContractTag.ValueData      AS ContractTagName
          , Object_ContractTagGroup.ValueData AS ContractTagGroupName

          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyId                     AS InfoMoneyId
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

          , Object_PaidKind.Id        AS PaidKindId
          , Object_PaidKind.ValueData AS PaidKindName
 
          , tmpOperationGroup.OperDate    ::TDateTime
          , DATE_TRUNC ('MONTH', tmpOperationGroup.OperDate)  :: TDateTime AS MonthDate
          , EXTRACT (YEAR FROM tmpOperationGroup.OperDate)    :: Integer AS Year
          , EXTRACT (WEEK FROM tmpOperationGroup.OperDate)    :: Integer AS WeekNumber

          , tmpOperationGroup.PersonalName_1     ::TVarChar
          , tmpOperationGroup.PersonalName_2     ::TVarChar
          , tmpOperationGroup.PersonalName_3     ::TVarChar
          , tmpOperationGroup.PersonalName_4     ::TVarChar
          , tmpOperationGroup.PersonalName_5     ::TVarChar
          , tmpOperationGroup.PersonalName_6     ::TVarChar
          , tmpOperationGroup.PositionName_1     ::TVarChar
          , tmpOperationGroup.PositionName_2     ::TVarChar
          , tmpOperationGroup.PositionName_3     ::TVarChar
          , tmpOperationGroup.PositionName_4     ::TVarChar
          , tmpOperationGroup.PositionName_5     ::TVarChar
          , tmpOperationGroup.PositionName_6     ::TVarChar
          , tmpOperationGroup.UnitName_1         ::TVarChar
          , tmpOperationGroup.UnitName_2         ::TVarChar
          , tmpOperationGroup.UnitName_3         ::TVarChar
          , tmpOperationGroup.UnitName_4         ::TVarChar
          , tmpOperationGroup.UnitName_5         ::TVarChar
          , tmpOperationGroup.UnitName_6         ::TVarChar
          , tmpOperationGroup.PersonalName_1ret  ::TVarChar
          , tmpOperationGroup.PersonalName_2ret  ::TVarChar
          , tmpOperationGroup.PersonalName_3ret  ::TVarChar
          , tmpOperationGroup.PositionName_1ret  ::TVarChar
          , tmpOperationGroup.PositionName_2ret  ::TVarChar
          , tmpOperationGroup.PositionName_3ret  ::TVarChar
          , tmpOperationGroup.UnitName_1ret      ::TVarChar
          , tmpOperationGroup.UnitName_2ret      ::TVarChar
          , tmpOperationGroup.UnitName_3ret      ::TVarChar

          , tmpOperationGroup.Return_AmountPartner_Weight :: TFloat AS Return_AmountPartner_Weight
          , tmpOperationGroup.Return_AmountPartner_Sh     :: TFloat AS Return_AmountPartner_Sh
          , tmpOperationGroup.Return_Summ        :: TFloat  AS Return_Summ
          
          , (COALESCE (tmpOperationGroup.Sale_AmountPartner_Weight,0) - COALESCE (tmpOperationGroup.Promo_AmountPartner_Weight,0))  :: TFloat AS Sale_AmountPartner_Weight_noPromo
          , (COALESCE (tmpOperationGroup.Sale_AmountPartner_Sh,0) - COALESCE (tmpOperationGroup.Promo_AmountPartner_Sh,0))          :: TFloat AS Sale_AmountPartner_Sh_noPromo
          , (COALESCE (tmpOperationGroup.Sale_Summ,0) - COALESCE (tmpOperationGroup.Promo_Summ,0))  ::TFloat AS Sale_Summ_NoPromo
          
          , tmpOperationGroup.Promo_AmountPartner_Weight :: TFloat AS Promo_AmountPartner_Weight
          , tmpOperationGroup.Promo_AmountPartner_Sh     :: TFloat AS Promo_AmountPartner_Sh

          , (COALESCE (tmpOperationGroup.Sale_AmountPartner_Weight,0) - COALESCE (tmpOperationGroup.Return_Amount_Weight,0))  :: TFloat AS Sale_AmountPartner_Weight_noReturn
          , (COALESCE (tmpOperationGroup.Sale_AmountPartner_Sh,0) - COALESCE (tmpOperationGroup.Return_Amount_Sh,0))          :: TFloat AS Sale_AmountPartner_Sh_noReturn
          , (COALESCE (tmpOperationGroup.Sale_Summ,0) - COALESCE (tmpOperationGroup.Return_Summ,0)) ::TFloat AS Sale_Summ_NoReturn

          , tmpOperationGroup.Sale_Summ          :: TFloat  AS Sale_Summ
          , tmpOperationGroup.Sale_Summ_10250    :: TFloat  AS Sale_Summ_10250
          , tmpOperationGroup.Promo_Summ         :: TFloat  AS Promo_Summ

          , tmpOperationGroup.Sale_AmountPartner_Weight  :: TFloat AS Sale_AmountPartner_Weight
          , tmpOperationGroup.Sale_AmountPartner_Sh      :: TFloat AS Sale_AmountPartner_Sh
          
          /*
          , tmpOperationGroup.Return_Amount_Weight :: TFloat AS Return_Amount_Weight
          , tmpOperationGroup.Return_Amount_Sh     :: TFloat AS Return_Amount_Sh
          , tmpOperationGroup.Sale_Amount_Weight   :: TFloat  AS Sale_Amount_Weight
          , tmpOperationGroup.Sale_Amount_Sh       :: TFloat  AS Sale_Amount_Sh 
          */

     FROM tmpOperationGroup
          -- LEFT JOIN _tmp_noDELETE_Partner ON _tmp_noDELETE_Partner.FromId = tmpOperationGroup.PartnerId AND 1 = 0

          LEFT JOIN Object AS Object_Branch    ON Object_Branch.Id    = tmpOperationGroup.BranchId
          LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PaidKind  ON Object_PaidKind.Id  = tmpOperationGroup.PaidKindId

          LEFT JOIN Object AS Object_GoodsPlatform     ON Object_GoodsPlatform.Id     = tmpOperationGroup.GoodsPlatformId
          LEFT JOIN Object AS Object_TradeMark         ON Object_TradeMark.Id         = tmpOperationGroup.TradeMarkId
          LEFT JOIN Object AS Object_GoodsGroupStat    ON Object_GoodsGroupStat.Id    = tmpOperationGroup.GoodsGroupStatId
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = tmpOperationGroup.GoodsGroupAnalystId
          LEFT JOIN Object AS Object_GoodsTag          ON Object_GoodsTag.Id          = tmpOperationGroup.GoodsTagId
          LEFT JOIN Object AS Object_Measure           ON Object_Measure.Id           = tmpOperationGroup.MeasureId

          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpOperationGroup.GoodsGroupId
          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN tmpJuridicalDetails AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

          LEFT JOIN Object AS Object_Partner   ON Object_Partner.Id   = tmpOperationGroup.PartnerId
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Partner.Id
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
          LEFT JOIN ObjectFloat AS ObjectFloat_Category
                                ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                               AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()

          LEFT JOIN Object AS Object_Area ON Object_Area.Id = tmpOperationGroup.AreaId
          LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = tmpOperationGroup.PartnerTagId

          LEFT JOIN Object AS Object_Region       ON Object_Region.Id       = tmpOperationGroup.RegionId
         -- LEFT JOIN Object AS Object_Province     ON Object_Province.Id     = tmpOperationGroup.ProvinceId
          LEFT JOIN Object AS Object_CityKind     ON Object_CityKind.Id     = tmpOperationGroup.CityKindId
          LEFT JOIN Object AS Object_City         ON Object_City.Id         = tmpOperationGroup.CityId

          LEFT JOIN Object AS Object_Retail         ON Object_Retail.Id         = tmpOperationGroup.RetailId
          LEFT JOIN Object AS Object_RetailReport   ON Object_RetailReport.Id   = tmpOperationGroup.RetailReportId
          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = tmpOperationGroup.JuridicalGroupId

          LEFT JOIN Object AS Object_Contract         ON Object_Contract.Id         = tmpOperationGroup.ContractId
          LEFT JOIN Object AS Object_ContractTag      ON Object_ContractTag.Id      = tmpOperationGroup.ContractTagId
          LEFT JOIN Object AS Object_ContractTagGroup ON Object_ContractTagGroup.Id = tmpOperationGroup.ContractTagGroupId

          LEFT JOIN tmpInfoMoney AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId

          LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsPropertyId = tmpOperationGroup.GoodsPropertyId
                                                AND tmpObject_GoodsPropertyValue.GoodsId = tmpOperationGroup.GoodsId
                                                AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpOperationGroup.GoodsKindId 
          LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsPropertyId = tmpOperationGroup.GoodsPropertyId
                                                     AND tmpObject_GoodsPropertyValueGroup.GoodsId =tmpOperationGroup.GoodsId
                                                     AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
          LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpOperationGroup.GoodsId
                                                      AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpOperationGroup.GoodsKindId
          LEFT JOIN tmpObject_GoodsPropertyValueGroup_basis ON tmpObject_GoodsPropertyValueGroup_basis.GoodsId =tmpOperationGroup.GoodsId

          LEFT JOIN tmpGoodsByGoodsKindParam ON tmpGoodsByGoodsKindParam.GoodsId = tmpOperationGroup.GoodsId
                                            AND COALESCE (tmpGoodsByGoodsKindParam.GoodsKindId, 0) = COALESCE (tmpOperationGroup.GoodsKindId,0)


         LEFT JOIN ObjectLink AS ObjectLink_Partner_TypeCommerc
                              ON ObjectLink_Partner_TypeCommerc.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_TypeCommerc.DescId = zc_ObjectLink_Partner_UnitMobile()
         LEFT JOIN Object AS Object_TypeCommerc ON Object_TypeCommerc.Id = ObjectLink_Partner_TypeCommerc.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Section
                              ON ObjectLink_Juridical_Section.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_Section.DescId = zc_ObjectLink_Juridical_Section()
         LEFT JOIN Object AS Object_Section ON Object_Section.Id = ObjectLink_Juridical_Section.ChildObjectId

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.26         *
*/


-- тест
-- SELECT * FROM gpReport_SoldTable_Commerc_Olap (inStartDate:= '01.07.2026', inEndDate:= '06.07.2026', inBranchId:= 0, inAreaId:= 0, inRetailId:= 0, inJuridicalId:= 15020, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 633112 , inInfoMoneyId:= 0, inSession:= zfCalc_UserAdmin()); --zc_Enum_InfoMoney_30101()
