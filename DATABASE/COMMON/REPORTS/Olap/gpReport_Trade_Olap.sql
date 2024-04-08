-- Function: gpReport_Trade_Olap()

DROP FUNCTION IF EXISTS gpReport_Trade_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Trade_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inJuridicalId        Integer   , -- юр.лицо
    IN inPartnerId          Integer   , -- контагент
    IN inPersonalId         Integer   , --физ лицо супервайзер
    IN inPersonalTradeId    Integer   , --физ лицо Торговый
    IN inRetailId           Integer   , -- торг. сеть
    IN inGoodsId            Integer   ,
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , OperDatePartner TDateTime
             , MonthDate TDateTime
             , DayOfWeekName_Full  TVarChar
             , OperDate_inf TVarChar
             , ContractName TVarChar
             , JuridicalName TVarChar
             , PartnerName TVarChar
             , RetailName TVarChar
             , PersonalName       TVarChar
             , PersonalTradeName  TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , TradeMarkName TVarChar
             , AmountSale_Sh      TFloat
             , AmountSale_weight  TFloat
             , AmountOrder_Sh     TFloat
             , AmountOrder_weight TFloat
             , AmountStore_Sh     TFloat
             , AmountStore_weight TFloat
             )   
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
          WITH
            tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId      AS PersonalId
                                 , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                            FROM ObjectLink AS ObjectLink_Personal_Member
                            WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND ObjectLink_Personal_Member.ChildObjectId = inPersonalId
                              AND COALESCE (inPersonalId,0) <> 0
                            )
          , tmpPersonalTrade AS (SELECT ObjectLink_Personal_Member.ObjectId      AS PersonalId
                                      , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                 FROM ObjectLink AS ObjectLink_Personal_Member
                                 WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                   AND ObjectLink_Personal_Member.ChildObjectId = inPersonalTradeId
                                   AND COALESCE (inPersonalTradeId,0) <> 0
                                 )
                                    -- ((tmpPersonal_byMember.PersonalId IS NOT NULL AND inPaidKindId = zc_Enum_PaidKind_SecondForm()) OR inMemberId = 0)
                                    
          -- по торговой сети выбираем юр лица
          , tmpJuridical AS (SELECT ObjectLink_Juridical_Retail.ObjectId AS JuridicalId
                                  , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                             FROM ObjectLink AS ObjectLink_Juridical_Retail
                             WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                               AND (ObjectLink_Juridical_Retail.ObjectId = inJuridicalId OR inJuridicalId = 0)
            --AND ObjectLink_Juridical_Retail.ObjectId = 878283
                          )
          --выбираем контагентов ограничиваем входными параметрами
          , tmpPartner AS (SELECT ObjectLink_Partner_Juridical.ObjectId    AS PartnerId
                              , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                              , tmpJuridical.RetailId
                         FROM ObjectLink AS ObjectLink_Partner_Juridical
                              INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                         WHERE ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           AND (ObjectLink_Partner_Juridical.ObjectId = inPartnerId OR inPartnerId = 0) --878284
                           AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                          -- AND (ObjectLink_Partner_Juridical.ChildObjectId = 878283 OR 878283 = 0)
                        )

          , tmpSale AS (SELECT Movement.OperDate                                    AS OperDate
                             , MIContainer.OperDate                                 AS OperDatePartner
                             , tmpPartner.JuridicalId
                             , tmpPartner.PartnerId  
                             , tmpPartner.RetailId
                             , MovementLinkObject_Contract.ObjectId                 AS ContractId                          
                             , MIContainer.ObjectId_Analyzer                        AS GoodsId
                             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)       AS GoodsKindId

                             , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()
                                          AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                          AND MIContainer.ContainerId_Analyzer <> 0
                                              THEN -1 * MIContainer.Amount
                                         ELSE 0
                                    END) AS CountSaleReal

                        FROM MovementItemContainer AS MIContainer
                            INNER JOIN tmpPartner ON tmpPartner.PartnerId = MIContainer.ObjectextId_Analyzer

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                         ON MovementLinkObject_Contract.MovementId = MIContainer.MovementId
                                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                            LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId

                        WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                          AND MIContainer.MovementDescId = zc_Movement_Sale()
                          AND MIContainer.DescId = zc_Container_Count()
                          AND (MIContainer.ObjectId_Analyzer = inGoodsId OR inGoodsId = 0)
                        GROUP BY MIContainer.MovementId
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.OperDate
                               , Movement.OperDate
                               --, MovementDate_OperDatePartner.ValueData
                               , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                               , tmpPartner.JuridicalId
                               , tmpPartner.PartnerId
                               , tmpPartner.RetailId
                               , MovementLinkObject_Contract.ObjectId
                        HAVING SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()
                                          AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                          AND MIContainer.ContainerId_Analyzer <> 0
                                              THEN -1 * MIContainer.Amount
                                         ELSE 0
                                    END) <> 0
                        )
          --заказы покупателей
          , tmpOrder AS (SELECT Movement.OperDate                           AS OperDate
                              , MovementDate_OperDatePartner.ValueData      AS OperDatePartner
                              , tmpPartner.JuridicalId                      AS JuridicalId
                              , tmpPartner.RetailId                         AS RetailId
                              , MovementLinkObject_From.ObjectId            AS PartnerId
                              , MovementLinkObject_Contract.ObjectId        AS ContractId
                              , MovementItem.ObjectId                       AS GoodsId
                              , MILinkObject_GoodsKind.ObjectId             AS GoodsKindId                --, zc_GoodsKind_Basis()
                              , SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0)) AS Amount
                       FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            -- ограничиваем контрагентов
                           INNER JOIN tmpPartner ON tmpPartner.PartnerId = MovementLinkObject_From.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                      
                           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                
                           LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                    ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                   AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                                                  AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                         AND Movement.DescId = zc_Movement_OrderExternal()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       GROUP BY Movement.OperDate
                              , MovementDate_OperDatePartner.ValueData
                              , MovementString_InvNumberPartner.ValueData
                              , tmpPartner.JuridicalId
                              , tmpPartner.RetailId
                              , MovementLinkObject_From.ObjectId
                              , MovementLinkObject_Contract.ObjectId
                              , MovementItem.ObjectId
                              , MILinkObject_GoodsKind.ObjectId
                       HAVING SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0)) <> 0
                       )
            --документы факт. остатков
          , tmpStoreRealDoc AS (SELECT tmp.PartnerId, tmp.JuridicalId, tmp.RetailId, tmp.MovementId, tmp.OperDate, tmp.InvNumber, tmp.MemberId, tmp.MemberName
                                FROM (SELECT MovementLinkObject_Partner.ObjectId AS PartnerId
                                           , tmpPartner.JuridicalId
                                           , tmpPartner.RetailId
                                           , Object_Member.Id        AS MemberId
                                           , Object_Member.ValueData AS MemberName
                                           , Movement_StoreReal.Id   AS MovementId
                                           , Movement_StoreReal.OperDate
                                           , Movement_StoreReal.InvNumber
                                           , ROW_NUMBER () OVER (PARTITION BY MovementLinkObject_Partner.ObjectId ORDER BY Movement_StoreReal.OperDate DESC) AS RowNum
                                      FROM Movement AS Movement_StoreReal
                                           JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                   ON MovementLinkObject_Partner.MovementId = Movement_StoreReal.Id
                                                                  AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                           JOIN tmpPartner ON tmpPartner.PartnerId = MovementLinkObject_Partner.ObjectId
                                           --трговый
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                                         ON MovementLinkObject_Insert.MovementId = Movement_StoreReal.Id
                                                                        AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
                                           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = MovementLinkObject_Insert.ObjectId
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

                                      WHERE Movement_StoreReal.DescId = zc_Movement_StoreReal()
                                        AND Movement_StoreReal.StatusId = zc_Enum_Status_Complete()
                                        AND Movement_StoreReal.OperDate BETWEEN inStartDate AND inEndDate
                                     ) AS tmp
                                WHERE tmp.RowNum = 1
                               )
          , tmpStoreReal AS (SELECT tmpStoreRealDoc.OperDate
                                  , tmpStoreRealDoc.PartnerId
                                  , tmpStoreRealDoc.JuridicalId
                                  , tmpStoreRealDoc.RetailId
                                  , tmpStoreRealDoc.MemberId
                                  , tmpStoreRealDoc.MemberName
                                  , MovementItem.ObjectId                  AS GoodsId
                                  , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId
                                  , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                             FROM tmpStoreRealDoc
                                  JOIN MovementItem ON MovementItem.MovementId = tmpStoreRealDoc.MovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             GROUP BY tmpStoreRealDoc.OperDate
                                    , tmpStoreRealDoc.PartnerId
                                    , tmpStoreRealDoc.JuridicalId
                                    , tmpStoreRealDoc.RetailId
                                    , MovementItem.ObjectId
                                    , MILinkObject_GoodsKind.ObjectId
                                    , tmpStoreRealDoc.MemberId
                                    , tmpStoreRealDoc.MemberName
                             )
                             
          , tmpData_All AS (SELECT tmp.OperDate
                                 , tmp.OperDatePartner
                                 , tmp.ContractId
                                 , tmp.PartnerId
                                 , tmp.JuridicalId
                                 , tmp.RetailId
                                 , tmp.GoodsId
                                 , tmp.GoodsKindId
                                 , tmp.CountSaleReal AS AmountSale
                                 , 0 AS AmountOrder
                            FROM tmpSale AS tmp
                           UNION ALL
                            SELECT tmp.OperDate
                                 , tmp.OperDatePartner
                                 , tmp.ContractId
                                 , tmp.PartnerId
                                 , tmp.JuridicalId
                                 , tmp.RetailId
                                 , tmp.GoodsId
                                 , tmp.GoodsKindId
                                 , 0 AS AmountSale
                                 , tmp.Amount AS AmountOrder
                            FROM tmpOrder AS tmp
                            )

          , tmpDataAll AS (SELECT COALESCE (tmp.OperDate, tmpStoreReal.OperDate)       AS OperDate
                                , COALESCE (tmp.OperDatePartner, tmpStoreReal.OperDate) AS OperDatePartner
                                , COALESCE (tmp.ContractId, 0)                         AS ContractId
                                , COALESCE (tmpStoreReal.MemberId,0)                   AS MemberId
                                , COALESCE (tmpStoreReal.MemberName,'')                AS MemberName
                                , COALESCE (tmp.PartnerId, tmpStoreReal.PartnerId)     AS PartnerId
                                , COALESCE (tmp.JuridicalId, tmpStoreReal.JuridicalId) AS JuridicalId
                                , COALESCE (tmp.RetailId, tmpStoreReal.RetailId)       AS RetailId
                                , COALESCE (tmp.GoodsId, tmpStoreReal.GoodsId)         AS GoodsId
                                , COALESCE (tmp.GoodsKindId, tmpStoreReal.GoodsKindId) AS GoodsKindId
                                , COALESCE (tmp.AmountSale,0)                          AS AmountSale
                                , COALESCE (tmp.AmountOrder,0)                         AS AmountOrder
                                , COALESCE (tmpStoreReal.Amount,0)                     AS AmountStore
                           FROM tmpData_All AS tmp
                               FULL JOIN tmpStoreReal ON tmpStoreReal.JuridicalId = tmp.JuridicalId
                                                     AND tmpStoreReal.PartnerId = tmp.PartnerId
                                                     AND tmpStoreReal.RetailId = tmp.RetailId
                                                     AND tmpStoreReal.GoodsId = tmp.GoodsId
                                                     AND COALESCE (tmpStoreReal.GoodsKindId,0) = COALESCE (tmp.GoodsKindId,0)
                                                     AND tmp.OperDate = tmpStoreReal.OperDate
                           )


          -- 5)ФИО сотрудник (супервайзер) 6) ФИО сотрудник (ТП)  из договора
          , tmpContract AS (SELECT tmp.ContractId
                                 , Object_Personal.Id                     AS PersonalId
                                 , Object_Personal.ValueData              AS PersonalName
                                 , Object_PersonalTrade.Id                AS PersonalTradeId
                                 , Object_PersonalTrade.ValueData         AS PersonalTradeName
                            FROM (SELECT DISTINCT tmpDataAll.ContractId FROM tmpDataAll) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                     ON ObjectLink_Contract_Personal.ObjectId = tmp.ContractId
                                                    AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                 LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId
                      
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                      ON ObjectLink_Contract_PersonalTrade.ObjectId = tmp.ContractId
                                                     AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                 LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Contract_PersonalTrade.ChildObjectId
                            )
          -- ограничиваем данные 5)ФИО сотрудник (супервайзер) 6) ФИО сотрудник (ТП)
          , tmpData AS (SELECT tmpDataAll.*
                             , tmpContract.PersonalName
                             , COALESCE (tmpContract.PersonalTradeName, tmpDataAll.MemberName) AS PersonalTradeName
                        FROM tmpDataAll
                             LEFT JOIN tmpContract ON tmpContract.ContractId = tmpDataAll.ContractId
                             LEFT JOIN tmpPersonal ON tmpPersonal.PersonalId = tmpContract.PersonalId
                             LEFT JOIN tmpPersonalTrade ON ( (tmpPersonalTrade.PersonalId = tmpContract.PersonalTradeId AND COALESCE (tmpDataAll.MemberId,0) = 0)
                                                          OR (tmpPersonalTrade.MemberId = tmpDataAll.MemberId AND COALESCE (tmpDataAll.MemberId,0) <> 0)
                                                           )
                        WHERE (tmpPersonal.PersonalId IS NOT NULL OR inPersonalId = 0)
                          AND (tmpPersonalTrade.PersonalId IS NOT NULL OR inPersonalTradeId = 0)

                         /*(tmpContract.PersonalId = inPersonalId OR inPersonalId = 0)
                          AND (tmpContract.PersonalTradeId = inPersonalTradeId OR inPersonalTradeId = 0)*/
                        )

         , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
                                  , Object_GoodsGroup.ValueData                  AS GoodsGroupName
                                  , ObjectLink_Goods_Measure.ChildObjectId       AS MeasureId
                                  , ObjectFloat_Weight.ValueData                 AS Weight
                                  , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull
                                  , Object_TradeMark.ValueData                   AS TradeMarkName
                             FROM (SELECT DISTINCT tmpData.GoodsId
                                   FROM tmpData
                                   ) AS tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                                       AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                                  LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                         ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                        AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                       ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                  LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                            )
     , tmpListData AS (SELECT tmp.OperDate
                            , ROW_NUMBER()OVER (ORDER BY tmp.OperDate) AS Num_day
                            , tmpWeekDay.DayOfWeekName
                       FROM (SELECT DISTINCT tmpData.OperDatePartner AS OperDate FROM tmpData
                         UNION
                             SELECT DISTINCT tmpData.OperDate AS OperDate FROM tmpData
                             ) AS tmp
                             LEFT JOIN zfCalc_DayOfWeekName (tmp.OperDate) AS tmpWeekDay ON 1=1
                       ) 

      -- Результат 
      SELECT tmpData.OperDate
           , tmpData.OperDatePartner
           , DATE_TRUNC ('Month', tmpData.OperDate) ::TDateTime AS MonthDate
           , tmpWeekDay.DayOfWeekName_Full    ::TVarChar AS DayOfWeekName_Full
--           , tmpWeekDay.DayOfWeekName         ::TVarChar AS DayOfWeekName
           , (tmpListData.Num_day||'. '||zfConvert_DateToString (tmpData.OperDatePartner)||' ('||tmpListData.DayOfWeekName||')') ::TVarChar AS OperDate_inf
           , Object_Contract.ValueData        AS ContractName
           , Object_Juridical.ValueData       AS JuridicalName
           , Object_Partner.ValueData         AS PartnerName
           , Object_Retail.ValueData          AS RetailName
           , tmpData.PersonalName      ::TVarChar
           , tmpData.PersonalTradeName ::TVarChar
           , tmpGoodsParam.GoodsGroupNameFull
           , tmpGoodsParam.GoodsGroupName     AS GoodsGroupName 
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName  
           , Object_GoodsKind.ValueData       AS GoodsKindName
           , tmpGoodsParam.TradeMarkName

           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData.AmountSale ELSE 0 END                                    :: TFloat AS AmountSale_Sh
           , (tmpData.AmountSale * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))   :: TFloat AS AmountSale_weight
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData.AmountOrder ELSE 0 END                                   :: TFloat AS AmountOrder_Sh
           , (tmpData.AmountOrder * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountOrder_weight
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData.AmountStore ELSE 0 END                                   :: TFloat AS AmountStore_Sh
           , (tmpData.AmountStore * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountStore_weight
        FROM tmpData
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpData.RetailId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
       
             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = Object_Goods.Id
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpGoodsParam.MeasureId
             LEFT JOIN zfCalc_DayOfWeekName (tmpData.OperDatePartner) AS tmpWeekDay ON 1=1
             LEFT JOIN tmpListData ON tmpListData.OperDate = tmpData.OperDatePartner
        ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.11.21         *
*/

-- тест-
--  SELECT * FROM gpReport_Trade_Olap (inStartDate:= '01.06.2020', inEndDate:= '01.06.2020', inJuridicalId:= 878283, inPartnerId:= 0, inPersonalId:= 0, inPersonalTradeId:= 0, inRetailId:= 0, inGoodsId:=0, inSession:= zfCalc_UserAdmin()) limit 1;

/*
    IN inJuridicalId        Integer   , -- юр.лицо
    IN           Integer   , -- контагент
    IN          Integer   ,
    IN     Integer   ,
    IN            Integer   , -- торг. сеть
    IN inGoodsId            Integer   ,


 новый отчет-олап в "Мобильный агент" - Анализ по ТТ - параметры 
 1) Юридическое лицо        2) периода        3) Товар  4) Контрагент      
 5)ФИО сотрудник (супервайзер)        6) ФИО сотрудник (ТП)        
 7)Торговая сеть 
 
 выводим данные по дням все в весе и кол-во шт 
 - отгрузка + заявки + остатки на тт(StoreReal) + товар + вид товара + Юридическое лицо + Контрагент + ФИО сотрудник (супервайзер) + ФИО сотрудник (ТП) + Торговая сеть
*/