-- Function:  gpSelect_Farmak_CRMWare()

DROP FUNCTION IF EXISTS gpSelect_Farmak_CRMWare (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Farmak_CRMWare (
  inMakerId Integer,
  inSession TVarChar
)
RETURNS TABLE (
   GoodsId integer,
   WareId integer,
   MorionCode integer,
   BarCode TVarChar,
   WareName TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   WITH
    tmpGoodsPromo AS (SELECT MI_Goods.ObjectId                  AS GoodsID
                      FROM Movement

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                         ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                        AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()

                           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                  AND MI_Goods.DescId = zc_MI_Master()
                                                  AND MI_Goods.isErased = FALSE

                           INNER JOIN MovementDate AS MovementDate_StartPromo
                                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                           INNER JOIN MovementDate AS MovementDate_EndPromo
                                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                      WHERE Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId = zc_Movement_Promo()
                        AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
                        AND MovementDate_EndPromo.ValueData >= CURRENT_DATE
                        AND MovementLinkObject_Maker.ObjectId = inMakerId),
    tmpGoodsBarCode AS (SELECT Object_Goods_BarCode.GoodsMainId
                             , Object_Goods_BarCode.BarCode
                             , ROW_NUMBER() OVER (PARTITION BY Object_Goods_BarCode.GoodsMainId  ORDER BY Object_Goods_BarCode.Id Desc) AS Ord

                        FROM Object_Goods_BarCode)



    SELECT
           tmpGoodsPromo.GoodsId        AS GoodsId 
         , Object_Goods_Main.ObjectCode AS WareId
         , Object_Goods_Main.MorionCode AS MorionCode
         , tmpGoodsBarCode.BarCode      AS BarCode
         , Object_Goods_Main.Name       AS WareName
    FROM tmpGoodsPromo

        INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpGoodsPromo.GoodsId
        INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
        
        LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id
                                 AND tmpGoodsBarCode.Ord = 1

    ORDER BY Object_Goods_Main.ObjectCode;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.03.21        *
*/

-- тест
-- select * from gpSelect_Farmak_CRMWare (13648288 , '3')
