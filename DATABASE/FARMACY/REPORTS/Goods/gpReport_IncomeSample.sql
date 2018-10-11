 -- Function: gpReport_IncomeSample()

DROP FUNCTION IF EXISTS gpReport_IncomeSample (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeSample(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- на торг.сеть
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inisUnitList       Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime
             , InvNumber TVarChar
             , FromName  TVarChar
             , ToName  TVarChar
             , OurJuridicalName  TVarChar
             , GoodsCode  Integer
             , GoodsName  TVarChar
             , GoodsGroupName  TVarChar
             , Amount TFloat
             , PriceWithVAT TFloat
             , SummaWithVAT TFloat
             , PriceSample TFloat
             , SummSample TFloat
             , PriceSale TFloat
             , SummSale TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;
    
    -- список подразделений
    INSERT INTO tmpUnit (UnitId)
                SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0 
                  AND inisUnitList = FALSE
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                  AND inisUnitList = FALSE
               UNION
                SELECT ObjectBoolean_Report.ObjectId          AS UnitId
                FROM ObjectBoolean AS ObjectBoolean_Report
                WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                  AND ObjectBoolean_Report.ValueData = TRUE
                  AND inisUnitList = TRUE;
            
    -- Результат
    RETURN QUERY
    WITH 
     tmpMovement AS (SELECT Movement.*
                          , MovementLinkObject_To.ObjectId          AS ToId
                          , MovementLinkObject_From.ObjectId        AS FromId
                          , MovementLinkObject_Juridical.ObjectId   AS JuridicalId
                          , MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
                          , ObjectFloat_NDSKind_NDS.ValueData       AS NDS
                     FROM Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
 
                          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                       ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                                      AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                     WHERE Movement.DescId = zc_Movement_Income()
                     AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                     )

   , tmpMI_Sample AS (SELECT MovementItem.*
                           , COALESCE(MIFloat_PriceSample.ValueData,0)                    ::TFloat     AS PriceSample
                      FROM tmpMovement AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN MovementItemFloat AS MIFloat_PriceSample
                                                        ON MIFloat_PriceSample.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()
                                                       AND COALESCE (MIFloat_PriceSample.ValueData, 0) <> 0
                      )
   , tmpMIFloat_PriceSale AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Sample.Id FROM tmpMI_Sample)
                                AND MovementItemFloat.DescId = zc_MIFloat_PriceSale()
                             )

   , tmpMIFloat_Price AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Sample.Id FROM tmpMI_Sample)
                            AND MovementItemFloat.DescId = zc_MIFloat_Price()
                         )

      SELECT Movement.OperDate
           , Movement.InvNumber

           , Object_From.ValueData                          AS FromName
           , Object_To.ValueData                            AS ToName
           , Object_Juridical.ValueData                     AS OurJuridicalName

           , Object_Goods.ObjectCode           :: Integer   AS GoodsCode
           , Object_Goods.ValueData                         AS GoodsName
           , Object_GoodsGroup.ValueData                    AS GoodsGroupName

           , MovementItem.Amount                            AS Amount

           , CASE WHEN Movement.PriceWithVAT THEN MIFloat_Price.ValueData ELSE (MIFloat_Price.ValueData * (1 + Movement.NDS/100))::TFloat END AS PriceWithVAT
           , (COALESCE (MovementItem.Amount, 0) * (CASE WHEN Movement.PriceWithVAT THEN MIFloat_Price.ValueData ELSE (MIFloat_Price.ValueData * (1 + Movement.NDS/100)) END )  ::NUMERIC (16, 2)) ::TFloat AS SummaWithVAT
           
           , COALESCE(MovementItem.PriceSample,0)                    ::TFloat     AS PriceSample
           , (((COALESCE (MovementItem.Amount, 0)) * COALESCE(MovementItem.PriceSample,0))::NUMERIC (16, 2))::TFloat AS SummSample
      
           , COALESCE(MIFloat_PriceSale.ValueData,0)                    ::TFloat     AS PriceSale
           , (((COALESCE (MovementItem.Amount, 0)) * COALESCE(MIFloat_PriceSale.ValueData,0))::NUMERIC (16, 2))::TFloat AS SummSale
       
      FROM tmpMI_Sample AS MovementItem 
           LEFT JOIN tmpMovement AS Movement ON Movement.Id = MovementItem.MovementId

           LEFT JOIN tmpMIFloat_Price AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                               --- AND MIFloat_Price.DescId = zc_MIFloat_Price()
           LEFT JOIN tmpMIFloat_PriceSale AS MIFloat_PriceSale
                                          ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                        -- AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
 
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = MovementItem.ObjectId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId
            LEFT JOIN Object AS Object_To ON Object_To.Id = Movement.ToId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement.JuridicalId
     ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.18         *
*/

-- тест
--
-- select * from gpReport_IncomeSample(inStartDate := ('01.10.2018')::TDateTime, inEndDate := ('10.10.2018')::TDateTime,  inUnitId := 0 , inRetailId := 0, inJuridicalId := 0, inisUnitList := 'False' ,  inSession := '3');

