-- Function: gpSelect_MovementItem_Check_FL()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check_FL (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check_FL(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer,    -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitName TVarChar
             , Bayer TVarChar
             , BayerPhone TVarChar
             , MedicSPName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , NDS TFloat
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- определяем Торговую сеть входящего подразделения
     vbRetailId:= CASE WHEN vbUserId IN (3, 183242, 375661) -- Админ + Люба + Юра
                          OR vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (393039)) -- Старший менеджер
                       THEN vbObjectId
                  ELSE
                  (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   )
                   END;

     -- Результат
     RETURN QUERY
     SELECT
             Object_Unit.ValueData                              AS UnitName
           , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)           AS Bayer
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)     AS BayerPhone
           , MovementString_MedicSP.ValueData                   AS MedicSPName
           , MovementItem.ObjectId                              AS GoodsId
           , Object_Goods.goodscodeInt                          AS GoodsCode
           , Object_Goods.goodsname                             AS GoodsName
           , Object_Goods.NDS                                   AS NDS
           , Sum(MovementItem.Amount)::TFloat                   AS Amount
           , COALESCE (MIFloat_Price.ValueData, 0)::TFloat      AS Price
           , (((COALESCE (Sum(MovementItem.Amount), 0)) * COALESCE (MIFloat_Price.ValueData, 0))::NUMERIC (16, 2))::TFloat AS AmountSumm
     FROM Movement

        LEFT JOIN MovementString AS MovementString_Bayer
                                  ON MovementString_Bayer.MovementId = Movement.Id
                                 AND MovementString_Bayer.DescId = zc_MovementString_Bayer()

        LEFT JOIN MovementString AS MovementString_BayerPhone
                                 ON MovementString_BayerPhone.MovementId = Movement.Id
                                AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                     ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                    AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
        LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
        LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                               ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                              AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

        LEFT JOIN MovementString AS MovementString_MedicSP
                                 ON MovementString_MedicSP.MovementId = Movement.Id
                                AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        INNER JOIN MovementItem AS MovementItem
                                ON MovementItem.MovementId = Movement.Id
                               AND MovementItem.isErased   = FALSE

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId



     WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
       AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
       AND Movement.DescId = zc_Movement_Check()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND MovementLinkObject_Unit.ObjectId = inUnitId
       AND vbRetailId = vbObjectId
       AND (COALESCE(MovementString_Bayer.ValueData, '') <> '' OR COALESCE(MovementString_MedicSP.ValueData, '') <> '')
     GROUP BY  Object_Unit.ValueData
           , COALESCE(Object_BuyerForSite.ValueData, MovementString_Bayer.ValueData)
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, MovementString_BayerPhone.ValueData)
           , MovementString_MedicSP.ValueData
           , MovementItem.ObjectId
           , Object_Goods.goodscodeInt
           , Object_Goods.goodsname
           , Object_Goods.NDS 
           , MIFloat_Price.ValueData
     ORDER BY Object_Unit.ValueData
           , COALESCE(Object_BuyerForSite.ValueData, MovementString_Bayer.ValueData)
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, MovementString_BayerPhone.ValueData)
           , MovementString_MedicSP.ValueData
           , Object_Goods.goodsname
           , Object_Goods.NDS ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_Check_FL (TDateTime, TDateTime, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 21.04.21         * add BuyerForSite
 12.05.18         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Check_FL (inStartDate:= '01.08.2017', inEndDate:= '01.08.2017', inUnitId:= 183292, inSession:= '3')