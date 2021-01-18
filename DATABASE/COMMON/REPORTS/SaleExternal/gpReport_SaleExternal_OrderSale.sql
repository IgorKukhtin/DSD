-- Function: gpReport_SaleExternal_OrderSale()

DROP FUNCTION IF EXISTS gpReport_SaleExternal_OrderSale (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleExternal_OrderSale(
    IN inOperDate           TDateTime , -- месяц прогноза
    IN inRetailId           Integer   ,
    IN inJuridicalId        Integer   ,
    IN inGoodsGroupId       Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (FromName TVarChar
             , PartnerId_from Integer, PartnerName_from TVarChar
             , PartnerRealId Integer, PartnerRealName TVarChar
             , GoodsPropertyName TVarChar
             , AmountKg TFloat, AmountKg_1 TFloat, AmountKg_2 TFloat, AmountKg_3 TFloat, AmountKg_avg TFloat
             , PartKg TFloat
             , TotalSumm_calc TFloat
             , TotalWeight_calc TFloat
             
             , TotalSumm TFloat
             , TotalWeight TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbStartDate_2 TDateTime;
   DECLARE vbStartDate_3 TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inRetailId,0) = 0
     THEN 
          --
          RAISE EXCEPTION 'Ошибка.Торговая сеть не выбрана';
     END IF;

     --определяем период 3 мес для расчета прогноза
     inOperDate  := DATE_TRUNC ('MONTH', inOperDate);  --первое число месяца
     
     vbStartDate := (inOperDate - INTERVAL '3 MONTH') ::TDateTime;
     vbEndDate   := (inOperDate - INTERVAL '1 DAY')   ::TDateTime;
     
     vbStartDate_3 := (inOperDate - INTERVAL '1 MONTH') ::TDateTime;
     vbStartDate_2 := (inOperDate - INTERVAL '2 MONTH') ::TDateTime;


     vbGoodsPropertyId := (SELECT ObjectLink_Retail_GoodsProperty.ChildObjectId
                           FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                           WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetailId --310854 --inRetailId
                             AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
                           );

     RETURN QUERY
     WITH
     -- если по Торговой сети не получили Классификатор ищем по всем
     tmpGoodsProperty AS (SELECT vbGoodsPropertyId AS GoodsPropertyId
                          WHERE COALESCE (vbGoodsPropertyId,0) <> 0
                         UNION
                          SELECT DISTINCT COALESCE (ObjectLink_Partner_GoodsProperty.ChildObjectId
                               , COALESCE (ObjectLink_Contract_GoodsProperty.ChildObjectId
                               , COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId
                               , COALESCE (ObjectLink_Retail_GoodsProperty.ChildObjectId)))) AS GoodsPropertyId
                          FROM 
                              (SELECT ObjectLink_Juridical_Retail.ObjectId AS JuridicalId
                                    , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                                    , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                               FROM ObjectLink AS ObjectLink_Juridical_Retail
                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                        AND ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                         ON ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                        AND ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                               WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId --310854
                               ) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                                                  ON ObjectLink_Partner_GoodsProperty.ObjectId = tmp.PartnerId
                                                 AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
                             LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                  ON ObjectLink_Juridical_GoodsProperty.ObjectId = tmp.JuridicalId
                                                 AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                                  ON ObjectLink_Contract_GoodsProperty.ObjectId = tmp.ContractId
                                                 AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
                             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = tmp.JuridicalId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                             LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                                                  ON ObjectLink_Retail_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                 AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
                          WHERE COALESCE (vbGoodsPropertyId,0) = 0
                          )

   --Данные из документов  OrderSale
   , tmpMovement_OS AS (SELECT tmp.*
                        FROM gpSelect_Movement_OrderSale (inOperDate, inOperDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY', 0, False, inSession) AS tmp
                        )

   --Данные из документов  SaleExternal
   , tmpMovement_SE AS (SELECT Movement.*
                             , MovementLinkObject_GoodsProperty.ObjectId AS GoodsPropertyId
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                                           ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                                          AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                             INNER JOIN tmpGoodsProperty ON tmpGoodsProperty.GoodsPropertyId = MovementLinkObject_GoodsProperty.ObjectId
                        WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                          AND Movement.DescId = zc_Movement_SaleExternal()
                          AND Movement.StatusId <>zc_Enum_Status_Erased()   --= zc_Enum_Status_Complete()
                        )

   , tmpMovementAll_SE AS (SELECT tmpMovement.*
                             , Object_From.Id                 AS FromId
                             , Object_From.ValueData          AS FromName
                             , Object_PartnerFrom.Id          AS PartnerId_from
                             , Object_PartnerFrom.ValueData   AS PartnerName_from
                             , Object_GoodsProperty.ValueData AS GoodsPropertyName
                             , Object_PartnerReal.Id          AS PartnerRealId 
                             , Object_PartnerReal.ValueData   AS PartnerRealName
                             , Object_PartnerReal.DescId      AS PartnerRealDescId
                        FROM tmpMovement_SE AS tmpMovement
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_PartnerExternal_Partner
                                                  ON ObjectLink_PartnerExternal_Partner.ObjectId = Object_From.Id
                                                 AND ObjectLink_PartnerExternal_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
                             LEFT JOIN Object AS Object_PartnerFrom ON Object_PartnerFrom.Id = ObjectLink_PartnerExternal_Partner.ChildObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_PartnerReal
                                                  ON ObjectLink_PartnerReal.ObjectId = Object_From.Id 
                                                 AND ObjectLink_PartnerReal.DescId = zc_ObjectLink_PartnerExternal_PartnerReal()

                             LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                  ON ObjectLink_Retail.ObjectId = Object_From.Id
                                                 AND ObjectLink_Retail.DescId = zc_ObjectLink_PartnerExternal_Retail()
                             --если не указано РЦ считаем и группируем по Торг. сети
                             LEFT JOIN Object AS Object_PartnerReal ON Object_PartnerReal.Id = COALESCE (ObjectLink_PartnerReal.ChildObjectId, ObjectLink_Retail.ChildObjectId)

                             LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpMovement.GoodsPropertyId
                       )
   
   , tmpGoods AS (SELECT lfSelect.GoodsId AS GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                  WHERE inGoodsGroupId <> 0
                UNION
                  SELECT Object.Id FROM Object
                  WHERE Object.DescId = zc_Object_Goods() AND Object.IsErased = FALSE
                    AND COALESCE (inGoodsGroupId, 0) = 0
                  )

   , tmpMI AS (SELECT tmp.MovementId
                    , tmp.AmountKg
                    , tmp.AmountSh
                    , tmp.TotalAmountKg
                    , CASE WHEN COALESCE (tmp.TotalAmountKg,0) <> 0 THEN tmp.AmountKg / tmp.TotalAmountKg *100 ELSE 0 END  AS PartKg
               FROM (
                     SELECT tmpMovementAll.Id                                AS MovementId
      
                          , SUM (CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh()
                                      THEN MovementItem.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                                      ELSE MovementItem.Amount
                                 END) AS AmountKg
      
                          , SUM (CASE WHEN ObjectLink_Measure.ChildObjectId <> zc_Measure_Sh()
                                      THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,1) <> 0 THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1) ELSE 0 END
                                      ELSE MovementItem.Amount
                                 END) AS AmountSh
                          , SUM (SUM(CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh()
                                          THEN MovementItem.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                                          ELSE MovementItem.Amount
                                     END)) OVER (PARTITION BY tmpMovementAll.PartnerRealId) AS TotalAmountKg
                     FROM tmpMovementAll_SE AS tmpMovementAll
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementAll.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                         INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
      
                         LEFT JOIN ObjectLink AS ObjectLink_Measure
                                              ON ObjectLink_Measure.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = ObjectLink_Measure.ObjectId
                                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     GROUP BY tmpMovementAll.Id
                            , tmpMovementAll.PartnerRealId
                     ) AS tmp
               )

   -- прогноз продаж
   -- на РЦ и на контрагентов
   , tmpReport_1 AS (SELECT tmp.PartnerId
                          , SUM (COALESCE (tmp.TotalSumm,0))    AS Sale_Summ
                          , SUM (COALESCE (tmp.TotalCountKg,0)) AS Sale_Weight
                     FROM tmpMovement_OS AS tmp
                     GROUP BY tmp.PartnerId
                    )
                
    -- Итого по торг.сеть - где нет РЦ
   , tmpReport_2 AS (SELECT tmp.RetailId AS PartnerId
                          , SUM (COALESCE (tmp.TotalSumm,0))    AS Sale_Summ
                          , SUM (COALESCE (tmp.TotalCountKg,0)) AS Sale_Weight
                     FROM tmpMovement_OS AS tmp
                     GROUP BY tmp.RetailId
                     )

     -- данные по внешним продажам 
   , tmpData AS (SELECT tmp.FromName
                      , tmp.PartnerId_from
                      , tmp.PartnerName_from
                      , tmp.PartnerRealId
                      , tmp.PartnerRealName
                      , tmp.GoodsPropertyName
                      , tmp.AmountKg_1
                      , tmp.AmountKg_2
                      , tmp.AmountKg_3
                      , tmp.AmountKg                  --- Итого
                      , tmp.AmountKg_avg              --ср в месяц, кг
                      , CASE WHEN COALESCE (tmp.TotalAmountKg_avg,0) <> 0 THEN tmp.AmountKg_avg / tmp.TotalAmountKg_avg *100 ELSE 0 END  AS PartKg -- расчет от среднего
                 FROM (SELECT Movement.FromName
                            , Movement.PartnerId_from
                            , Movement.PartnerName_from
                            , Movement.PartnerRealId
                            , Movement.PartnerRealName
                            , Movement.GoodsPropertyName
                            , SUM (CASE WHEN Movement.OperDate BETWEEN vbStartDate   AND vbStartDate_2 - INTERVAL '1 DAY' THEN tmpMI.AmountKg END) AS AmountKg_1
                            , SUM (CASE WHEN Movement.OperDate BETWEEN vbStartDate_2 AND vbStartDate_3 - INTERVAL '1 DAY' THEN tmpMI.AmountKg END) AS AmountKg_2
                            , SUM (CASE WHEN Movement.OperDate BETWEEN vbStartDate_3 AND vbEndDate                        THEN tmpMI.AmountKg END) AS AmountKg_3
                            , SUM (tmpMI.AmountKg)    AS AmountKg
                            , SUM (tmpMI.AmountKg)/3  AS AmountKg_avg
                            , SUM ((SUM(tmpMI.AmountKg)/3)) OVER (PARTITION BY Movement.PartnerRealId) AS TotalAmountKg_avg
                       FROM tmpMovementAll_SE AS Movement
                            INNER JOIN tmpMI ON tmpMI.MovementId = Movement.Id
                       GROUP BY Movement.FromName
                              , Movement.PartnerId_from
                              , Movement.PartnerName_from
                              , Movement.PartnerRealId
                              , Movement.PartnerRealName
                              , Movement.GoodsPropertyName
                        ) AS tmp
                 )

       -- Результат
       SELECT
             tmpData.FromName
           , tmpData.PartnerId_from
           , tmpData.PartnerName_from
           , tmpData.PartnerRealId
           , tmpData.PartnerRealName
           , tmpData.GoodsPropertyName

           --, tmpData.AmountSh   :: TFloat
           , tmpData.AmountKg     :: TFloat
           , tmpData.AmountKg_1   :: TFloat
           , tmpData.AmountKg_2   :: TFloat
           , tmpData.AmountKg_3   :: TFloat
           , tmpData.AmountKg_avg :: TFloat
           
           , tmpData.PartKg     :: TFloat
           
           , (COALESCE (tmpReport.Sale_Summ, tmpReport_ret.Sale_Summ)     * tmpData.PartKg/100) :: TFloat AS TotalSumm_calc               -- Расчетная сумма продаж, грн (от факта)
           , (COALESCE (tmpReport.Sale_Weight, tmpReport_ret.Sale_Weight) * tmpData.PartKg/100) :: TFloat AS TotalWeight_calc             -- Раасчетная сумма продаж, кг (от факта)
           
           , COALESCE (tmpReport.Sale_Summ, tmpReport_ret.Sale_Summ)     :: TFloat AS TotalSumm
           , COALESCE (tmpReport.Sale_Weight, tmpReport_ret.Sale_Weight) :: TFloat AS TotalWeight
         
       FROM tmpData
            LEFT JOIN tmpReport_1 AS tmpReport ON tmpReport.PartnerId = tmpData.PartnerRealId
            LEFT JOIN tmpReport_2 AS tmpReport_ret ON tmpReport_ret.PartnerId = tmpData.PartnerRealId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
26.11.20          *
*/

-- тест
-- SELECT * FROM gpReport_SaleExternal_OrderSale (inOperDate:= '01.01.2021', inRetailId := 310854 , inJuridicalId := 0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin()) 


/*select * from gpSelect_Object_Retail( inSession := '5')
order by 3;


select DATE_TRUNC ('MONTH',  '01.01.2021'::TDateTime);  --первое число месяца
     
     vbStartDate := select ('01.01.2021'::TDateTime - INTERVAL '3 MONTH') ::TDateTime;
     vbEndDate   := select('01.01.2021'::TDateTime - INTERVAL '1 DAY')   ::TDateTime;
     
     vbStartDate_2 := select('01.01.2021'::TDateTime - INTERVAL '1 MONTH') ::TDateTime;
     vbStartDate_3 := select('01.01.2021'::TDateTime - INTERVAL '2 MONTH') ::TDateTime;


     vbGoodsPropertyId := (SELECT ObjectLink_Retail_GoodsProperty.ChildObjectId
                           FROM ObjectLink AS ObjectLink_Retail_GoodsProperty
                           WHERE ObjectLink_Retail_GoodsProperty.ObjectId = inRetailId --310854 --inRetailId
                             AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
                           );*/