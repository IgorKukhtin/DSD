-- Function:  gpReport_PriceCorrectionSystem()

DROP FUNCTION IF EXISTS gpReport_PriceCorrectionSystem (TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_PriceCorrectionSystem(
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  GoodsId            Integer,
  GoodsCode          Integer,
  GoodsName          TVarChar,
  PricePrev          TFloat,
  PriceCurr          TFloat,
  Procent            TFloat,
  PriceCorrectionDay Integer,
  Color_Calc         Integer
)
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
  vbUserId:= lpGetUserBySession (inSession);


  -- Результат
  RETURN QUERY
    
    
  WITH tmpCashSettings AS (SELECT ObjectFloat_CashSettings_PriceCorrectionDay.ValueData::Integer           AS PriceCorrectionDay
                           FROM Object AS Object_CashSettings
                                LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceCorrectionDay
                                                      ON ObjectFloat_CashSettings_PriceCorrectionDay.ObjectId = Object_CashSettings.Id 
                                                     AND ObjectFloat_CashSettings_PriceCorrectionDay.DescId = zc_ObjectFloat_CashSettings_PriceCorrectionDay()
                           WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                           LIMIT 1),
       tmpMovementAll AS (SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId  AS UnitId 
                               , Movement.OperDate >= CURRENT_DATE - ((tmpCashSettings.PriceCorrectionDay + 1)::TVarChar||' DAY')::INTERVAL AS isCurrPeriod
                          FROM  Movement
                                                            
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                             
                                LEFT JOIN tmpCashSettings ON 1 = 1
                                
                          WHERE Movement.DescId = zc_Movement_Check()
                            AND Movement.StatusId = zc_Enum_Status_Complete()  
                            AND Movement.OperDate >= CURRENT_DATE - ((tmpCashSettings.PriceCorrectionDay * 2 + 1)::TVarChar||' DAY')::INTERVAL
                            AND Movement.OperDate < CURRENT_DATE
                          ),
       tmpMovement AS (SELECT *
                       FROM tmpMovementAll AS Movement
                            INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = Movement.UnitId
                                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                 AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                                                          
                      ),
       tmpMI AS (SELECT MovementItem.ObjectId
                      , SUM(CASE WHEN Movement.isCurrPeriod = False THEN MovementItem.Amount  END) / 
                        tmpCashSettings.PriceCorrectionDay    AS PricePrev
                      , SUM(CASE WHEN Movement.isCurrPeriod = True THEN MovementItem.Amount  END) / 
                        tmpCashSettings.PriceCorrectionDay      AS PriceCurr
                 FROM tmpMovement AS Movement
                                       
                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId = zc_MI_Master()
                                             AND MovementItem.isErased = FALSE
                                             AND MovementItem.Amount > 0
                                            
                      LEFT JOIN tmpCashSettings ON 1 = 1

                 GROUP BY MovementItem.ObjectId
                        , tmpCashSettings.PriceCorrectionDay
                 )
                           
  SELECT MovementItem.ObjectId            AS GoodsId
       , Object_Goods_Main.ObjectCode     AS GoodsCode
       , Object_Goods_Main.Name           AS GoodsName
       , MovementItem.PricePrev::TFloat
       , MovementItem.PriceCurr::TFloat
       , ((COALESCE(MovementItem.PriceCurr, 0) - COALESCE(MovementItem.PricePrev, 0)) / 
         ((COALESCE(MovementItem.PricePrev, 0) + COALESCE(MovementItem.PriceCurr, 0)) / 2) * 100)::TFloat  AS Procent
       , tmpCashSettings.PriceCorrectionDay
       , CASE WHEN COALESCE(MovementItem.PriceCurr, 0) = COALESCE(MovementItem.PricePrev, 0) THEN zc_Color_White() 
               WHEN COALESCE(MovementItem.PriceCurr, 0) > COALESCE(MovementItem.PricePrev, 0) THEN zc_Color_Yelow() 
               ELSE 11394815 END                                                                            AS Color_Calc
  FROM tmpMI AS MovementItem
  
       LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
       LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

       LEFT JOIN tmpCashSettings ON 1 = 1
       
  WHERE COALESCE(MovementItem.PricePrev, 0) <> 0 
    AND COALESCE(MovementItem.PriceCurr, 0) <> 0
  ORDER BY Object_Goods_Main.Name;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 10.09.21                                                      *
*/

-- тест
-- 
select * from gpReport_PriceCorrectionSystem(inSession := '3');  