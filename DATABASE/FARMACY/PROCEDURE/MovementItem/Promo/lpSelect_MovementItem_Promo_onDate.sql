--- Function: lpSelect_MovementItem_Promo_onDate()


DROP FUNCTION IF EXISTS lpSelect_MovementItem_Promo_onDate (TDateTime);

CREATE OR REPLACE FUNCTION lpSelect_MovementItem_Promo_onDate(
    IN inOperDate    TDateTime     -- 
)
RETURNS TABLE (MovementId Integer, JuridicalId Integer, GoodsId Integer, ChangePercent TFloat
              )
AS
$BODY$
BEGIN
           -- Результат
           RETURN QUERY
                   SELECT tmp.MovementId
                        , tmp.JuridicalId
                        , tmp.GoodsId        -- здесь товар "сети"
                        , tmp.ChangePercent :: TFloat AS ChangePercent
                   FROM (SELECT Movement.Id           AS MovementId
                              , MI_Juridical.ObjectId AS JuridicalId
                              , MI_Goods.ObjectId     AS GoodsId
                              , COALESCE (MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent
                              , ROW_NUMBER() OVER (PARTITION BY MI_Juridical.ObjectId, MI_Goods.ObjectId ORDER BY MI_Juridical.ObjectId, MI_Goods.ObjectId, MovementDate_EndPromo.ValueData DESC, Movement.Id DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                     AND MovementDate_StartPromo.ValueData <= inOperDate
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                     AND MovementDate_EndPromo.ValueData >= inOperDate
                              LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                      ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                     AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                              LEFT JOIN MovementItem AS MI_Juridical ON MI_Juridical.MovementId = Movement.Id
                                                                    AND MI_Juridical.DescId = zc_MI_Child()
                                                                    AND MI_Juridical.isErased = FALSE

                         WHERE Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_Promo()
                        ) AS tmp
                   WHERE tmp.Ord = 1 -- т.е. выбираем "последний"
                  ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 12.04.17         *
 28.04.16                                        *
*/

-- SELECT * FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE);