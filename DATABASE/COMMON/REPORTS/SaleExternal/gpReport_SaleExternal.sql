-- Function: gpReport_SaleExternal()

DROP FUNCTION IF EXISTS gpReport_SaleExternal (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleExternal(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inRetailId           Integer   ,
    IN inGoodsGroupId       Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , FromName TVarChar, PartnerName_from TVarChar
             , GoodsPropertyName TVarChar
             , AmountSh TFloat
             , AmountKg TFloat
             , PartKg TFloat
             , TotalSumm TFloat
             , TotalSummKg TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inRetailId,0) = 0
     THEN 
          --
          RAISE EXCEPTION 'Ошибка.Торговая сеть не выбрана';
     END IF;
     
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
                        FROM tmpMovement
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_PartnerExternal_Partner
                                                  ON ObjectLink_PartnerExternal_Partner.ObjectId = Object_From.Id
                                                 AND ObjectLink_PartnerExternal_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
                             LEFT JOIN Object AS Object_PartnerFrom ON Object_PartnerFrom.Id = ObjectLink_PartnerExternal_Partner.ChildObjectId

                             LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpMovement.GoodsPropertyId
                       )
   
   , tmpGoods AS (SELECT lfSelect.GoodsId AS GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                  WHERE inGoodsGroupId <> 0
                UNION
                  SELECT Object.Id FROM Object
                  WHERE Object.DescId = zc_Object_Goods() AND Object.IsErased = FALSE
                    AND COALESCE (inGoodsGroupId, 0) = 0
                  )

   , tmpMI AS (SELECT tmpMovement.Id                                AS MovementId

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
                               END)) OVER () AS TotalAmountKg
               FROM tmpMovement
                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                   INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_Measure
                                        ON ObjectLink_Measure.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                         ON ObjectFloat_Weight.ObjectId = ObjectLink_Measure.ObjectId
                                        AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
               GROUP BY tmpMovement.Id
               )

       -- Результат
       SELECT
             Movement.Id                           AS MovementId
           , Movement.InvNumber                    AS InvNumber
           , Movement.OperDate                     AS OperDate
           , Object_Status.ObjectCode              AS StatusCode
           , Object_Status.ValueData               AS StatusName
           , Movement.FromName
           , Movement.PartnerName_from
           , Movement.GoodsPropertyName

           , tmpMI.AmountSh   :: TFloat          AS AmountSh
           , tmpMI.AmountKg   :: TFloat          AS AmountKg

           , CASE WHEN COALESCE (tmpMI.TotalAmountKg,0) <> 0 THEN tmpMI.AmountKg / tmpMI.TotalAmountKg ELSE 0 END :: TFloat AS PartKg
           
           , 0 :: TFloat AS TotalSumm               -- Расчетная сумма продаж, грн (от факта)
           , 0 :: TFloat AS TotalSummKg             -- Раасчетная сумма продаж, кг (от факта)

       FROM tmpMovementAll AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN tmpMI ON tmpMI.MovementId = Movement.Id
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
-- SELECT * FROM gpReport_SaleExternal (inStartDate:= '01.11.2020', inEndDate:= '02.11.2020', inRetailId := 310854 , inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin())