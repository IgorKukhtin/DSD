-- Function: gpReport_SaleExternal_Goods()

DROP FUNCTION IF EXISTS gpReport_SaleExternal_Goods (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleExternal_Goods(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inRetailId           Integer   ,
    IN inJuridicalId        Integer   ,
    IN inGoodsGroupId       Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , RetailName TVarChar, FromName TVarChar
             , PartnerId_from Integer, PartnerName_from TVarChar
             , PartnerRealId Integer, PartnerRealName TVarChar
             , GoodsPropertyName TVarChar 
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, GroupStatName TVarChar, GoodsGroupAnalystName TVarChar            
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar

             , AmountSh TFloat
             , AmountKg TFloat
             , TotalAmountKg TFloat
             , PartKg TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     /*IF COALESCE (inRetailId,0) = 0
     THEN 
          --
          RAISE EXCEPTION 'Ошибка.Торговая сеть не выбрана';
     END IF;
       */
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
                               AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)--310854
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

   , tmpMovement AS (SELECT Movement.*
                          , MovementLinkObject_GoodsProperty.ObjectId AS GoodsPropertyId
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                                        ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                                       AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                          INNER JOIN tmpGoodsProperty ON tmpGoodsProperty.GoodsPropertyId = MovementLinkObject_GoodsProperty.ObjectId
                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                       AND Movement.DescId = zc_Movement_SaleExternal()
                       AND Movement.StatusId <>zc_Enum_Status_Erased()   --= zc_Enum_Status_Complete()
                     )
                     
   , tmpMovementAll AS (SELECT tmpMovement.*
                             , Object_From.Id                 AS FromId
                             , Object_From.ValueData          AS FromName
                             , Object_PartnerFrom.Id          AS PartnerId_from
                             , Object_PartnerFrom.ValueData   AS PartnerName_from
                             , Object_GoodsProperty.ValueData AS GoodsPropertyName
                             , Object_PartnerReal.Id          AS PartnerRealId 
                             , Object_PartnerReal.ValueData   AS PartnerRealName
                             , Object_PartnerReal.DescId      AS PartnerRealDescId
                             , Object_Retail.ValueData        AS RetailName
                        FROM tmpMovement
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
                             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId
                             --если не указано РЦ считаем и группируем по Торг. сети
                             LEFT JOIN Object AS Object_PartnerReal ON Object_PartnerReal.Id = COALESCE (ObjectLink_PartnerReal.ChildObjectId, ObjectLink_Retail.ChildObjectId)

                             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = Object_PartnerReal.Id
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                             LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpMovement.GoodsPropertyId
                        WHERE ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0
                       )
   
   , tmpGoods AS (SELECT lfSelect.GoodsId AS GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                  WHERE inGoodsGroupId <> 0
                UNION
                  SELECT Object.Id FROM Object
                  WHERE Object.DescId = zc_Object_Goods() AND Object.IsErased = FALSE
                    AND COALESCE (inGoodsGroupId, 0) = 0
                  )

   , tmpMI AS (SELECT tmp.MovementId
                    , tmp.GoodsId
                    , tmp.GoodsKindId
                    , tmp.AmountKg
                    , tmp.AmountSh
                    , tmp.TotalAmountKg
                    , CASE WHEN COALESCE (tmp.TotalAmountKg,0) <> 0 THEN tmp.AmountKg / tmp.TotalAmountKg *100 ELSE 0 END  AS PartKg
               FROM (
                     SELECT tmpMovementAll.Id                             AS MovementId
                          , MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , SUM (CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh()
                                      THEN MovementItem.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                                      ELSE MovementItem.Amount
                                 END) AS AmountKg
      
                          , SUM (CASE WHEN ObjectLink_Measure.ChildObjectId <> zc_Measure_Sh()
                                      THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,1) <> 0 THEN MovementItem.Amount / COALESCE (ObjectFloat_Weight.ValueData,1) ELSE MovementItem.Amount END
                                      ELSE MovementItem.Amount
                                 END) AS AmountSh

                          , SUM (SUM(CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh()
                                          THEN MovementItem.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                                          ELSE MovementItem.Amount
                                     END)) OVER (PARTITION BY tmpMovementAll.PartnerRealId) AS TotalAmountKg
                     FROM tmpMovementAll
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementAll.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                         INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                         LEFT JOIN ObjectLink AS ObjectLink_Measure
                                              ON ObjectLink_Measure.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = ObjectLink_Measure.ObjectId
                                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     GROUP BY tmpMovementAll.Id
                            , tmpMovementAll.PartnerRealId
                            , MovementItem.ObjectId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                     ) AS tmp
               )

   -- данные по внешним продажам 
   , tmpData AS (SELECT Movement.Id                 AS MovementId
                      , Movement.InvNumber          AS InvNumber
                      , Movement.OperDate           AS OperDate
                      , Object_Status.ObjectCode    AS StatusCode
                      , Object_Status.ValueData     AS StatusName
                      , Movement.RetailName
                      , Movement.FromName
                      , Movement.PartnerId_from
                      , Movement.PartnerName_from
                      , Movement.PartnerRealId
                      , Movement.PartnerRealName
                      , Movement.GoodsPropertyName
                      , tmpMI.GoodsId
                      , tmpMI.GoodsKindId
                      , tmpMI.AmountSh       AS AmountSh
                      , tmpMI.AmountKg       AS AmountKg
                      , tmpMI.TotalAmountKg  AS TotalAmountKg
                      , tmpMI.PartKg         AS PartKg
                 FROM tmpMovementAll AS Movement
                      LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                      INNER JOIN tmpMI ON tmpMI.MovementId = Movement.Id
                 )

       -- Результат
       SELECT
             tmpData.MovementId
           , tmpData.InvNumber
           , tmpData.OperDate
           , tmpData.StatusCode
           , tmpData.StatusName 
           , tmpData.RetailName
           , tmpData.FromName
           , tmpData.PartnerId_from
           , tmpData.PartnerName_from
           , tmpData.PartnerRealId
           , tmpData.PartnerRealName
           , tmpData.GoodsPropertyName

           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_GoodsGroupStat.ValueData             AS GroupStatName
           , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
            
           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData       AS MeasureName

           , tmpData.AmountSh   :: TFloat
           , tmpData.AmountKg   :: TFloat
           , tmpData.TotalAmountKg :: TFloat
           , tmpData.PartKg     :: TFloat
           
       FROM tmpData
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                 ON ObjectLink_Goods_GoodsGroupStat.ObjectId = tmpData.GoodsId
                                AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
            LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                 ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmpData.GoodsId
                                AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
            LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

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
--  select * from gpReport_SaleExternal_Goods(inStartDate := ('01.08.2022')::TDateTime , inEndDate := ('31.08.2022')::TDateTime , inRetailId := 0/*310828 */ /*310854 */, inJuridicalId := 15158  /*862910*/ , inGoodsGroupId := 1832 ,  inSession := '5')--
