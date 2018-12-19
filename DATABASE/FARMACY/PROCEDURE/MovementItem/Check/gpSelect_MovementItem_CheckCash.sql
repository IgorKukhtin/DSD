-- Function: gpSelect_MovementItem_CheckCash()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckCash (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckCash(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , IntenalSPName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             -- , DiscountCardId Integer
             -- , DiscountCardName TVarChar
             , List_UID TVarChar
             , isErased Boolean
             , isSp Boolean
             , Remains TFloat
             , Color_calc integer
             , Color_ExpirationDate integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbSPKindId Integer;
  DECLARE vbMovementId_SP Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

     -- определяется подразделение
     SELECT MovementLinkObject_Unit.ObjectId
          , MovementLinkObject_SPKind.ObjectId
     INTO vbUnitId, vbSPKindId
     FROM MovementLinkObject AS MovementLinkObject_Unit
          LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                       ON MovementLinkObject_SPKind.MovementId = inMovementId
                                      AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

     vbMovementId_SP := (SELECT Movement.Id
                         FROM Movement
                              LEFT JOIN MovementString AS MovementString_InvNumberSP
                                     ON MovementString_InvNumberSP.MovementId = Movement.Id
                                    AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                              LEFT JOIN MovementString AS MovementString_MedicSP
                                     ON MovementString_MedicSP.MovementId = Movement.Id
                                    AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                              LEFT JOIN MovementString AS MovementString_Ambulance
                                     ON MovementString_Ambulance.MovementId = Movement.Id
                                    AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                         ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_Check()
                            AND ( COALESCE(MovementString_InvNumberSP.ValueData,'') <> ''
                               OR COALESCE(MovementString_MedicSP.ValueData,'') <> ''
                               OR COALESCE(MovementString_Ambulance.ValueData,'') <> ''
                               OR COALESCE(MovementLinkObject_PartnerMedical.ObjectId,0) <> 0)
                          );

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
            WITH
                tmpRemains AS(SELECT Container.ObjectId                  AS GoodsId
                                   , SUM(Container.Amount)::TFloat       AS Amount
                              FROM Container
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ObjectId
                              HAVING SUM(Container.Amount)<>0
                              )
              , MovementItem_Check AS (SELECT
                                               MovementItem.Id
                                             , MovementItem.ParentId
                                             , MovementItem.GoodsId
                                             , MovementItem.GoodsCode
                                             , MovementItem.GoodsName
                                             , Object_IntenalSP.ValueData AS IntenalSPName
                                             , MovementItem.Amount
                                             , MovementItem.Price
                                             , MovementItem.AmountSumm
                                             , MovementItem.NDS
                                             , MovementItem.PriceSale
                                             , (MovementItem.PriceSale * MovementItem.Amount) :: TFloat AS SummSale
                                             , MovementItem.ChangePercent
                                             , MovementItem.SummChangePercent
                                             , MovementItem.AmountOrder
                                             , MovementItem.List_UID
                                             , MovementItem.isErased
                                             , CASE WHEN COALESCE (vbMovementId_SP,0) = 0 THEN False ELSE TRUE END AS isSp
                                             , tmpRemains.Amount::TFloat                                           AS Remains
                                             , zc_Color_White()                                                    AS Color_calc
                                             , zc_Color_Black()                                                    AS Color_ExpirationDate
                                         FROM MovementItem_Check_View AS MovementItem
                                              -- получаем GoodsMainId
                                              LEFT JOIN  ObjectLink AS ObjectLink_Child
                                                                    ON ObjectLink_Child.ChildObjectId = MovementItem.GoodsId
                                                                   AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                              LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                                    ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                              LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                                                   ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId
                                                                  AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
                                              LEFT JOIN MovementItemBoolean AS MIBoolean_SP
                                                                            ON MIBoolean_SP.MovementItemId = MovementItem.Id
                                                                           AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
                                              LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
                                              LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.GoodsId
                                         WHERE MovementItem.MovementId = inMovementId)

              , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                       , ROUND(Price_Value.ValueData, 2) ::TFloat AS Price
                  FROM ObjectLink AS ObjectLink_Price_Unit
                       LEFT JOIN ObjectFloat AS Price_Value
                              ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                             AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                       LEFT JOIN ObjectLink AS Price_Goods
                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                   WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                     AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                  )

            SELECT COALESCE(MovementItem_Check.Id,0)                     AS Id
                 , MovementItem_Check.ParentId
                 , Object_Goods.Id                                       AS GoodsId
                 , Object_Goods.ObjectCode                               AS GoodsCode
                 , Object_Goods.ValueData                                AS GoodsName
                 , MovementItem_Check.IntenalSPName                      AS IntenalSPName
                 , MovementItem_Check.Amount
                 , COALESCE(MovementItem_Check.Price, tmpPrice.Price)    AS  Price
                 , MovementItem_Check.AmountSumm
                 , MovementItem_Check.NDS
                 , COALESCE(MovementItem_Check.PriceSale, tmpPrice.Price) AS PriceSale
                 , MovementItem_Check.SummSale                            AS SummSale
                 , CASE WHEN vbSPKindId = zc_Enum_SPKind_1303() THEN COALESCE (MovementItem_Check.ChangePercent, 100) ELSE MovementItem_Check.ChangePercent END :: TFloat AS ChangePercent
                 , MovementItem_Check.SummChangePercent
                 , MovementItem_Check.AmountOrder
                 , MovementItem_Check.List_UID
                 , COALESCE(MovementItem_Check.IsErased,FALSE)           AS isErased
                 , CASE WHEN COALESCE (vbMovementId_SP,0) = 0 THEN False ELSE TRUE END AS isSp
                 , tmpRemains.Amount::TFloat                                           AS Remains
                 , zc_Color_White()                                                    AS Color_calc
                 , zc_Color_Black()                                                    AS Color_ExpirationDate
            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Check ON tmpRemains.GoodsId = MovementItem_Check.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Check.GoodsId,tmpRemains.GoodsId)
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId =  COALESCE(MovementItem_Check.GoodsId,tmpRemains.GoodsId)
            WHERE Object_Goods.isErased = FALSE
               OR MovementItem_Check.id is not null;
    ELSE
     RETURN QUERY
            WITH
                tmpRemains AS(SELECT Container.ObjectId                  AS GoodsId
                                   , SUM(Container.Amount)::TFloat       AS Amount
                              FROM Container
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ObjectId
                              HAVING SUM(Container.Amount)<>0
                              )

       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , Object_IntenalSP.ValueData AS IntenalSPName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.NDS
           , MovementItem.PriceSale
           , (MovementItem.PriceSale * MovementItem.Amount) :: TFloat AS SummSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent
           , MovementItem.AmountOrder
           , MovementItem.List_UID
           , MovementItem.isErased
           , CASE WHEN COALESCE (vbMovementId_SP,0) = 0 THEN False ELSE TRUE END AS isSp
           , tmpRemains.Amount::TFloat                                           AS Remains
           , zc_Color_White()                                                    AS Color_calc
           , zc_Color_Black()                                                    AS Color_ExpirationDate
       FROM MovementItem_Check_View AS MovementItem
            -- получаем GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child
                                  ON ObjectLink_Child.ChildObjectId = MovementItem.GoodsId
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main
                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
            LEFT JOIN MovementItemBoolean AS MIBoolean_SP
                                          ON MIBoolean_SP.MovementItemId = MovementItem.Id
                                         AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.GoodsId
       WHERE MovementItem.MovementId = inMovementId
         AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckCash (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 19.12.18                                                                    *
*/

-- тест
-- select * from gpSelect_MovementItem_CheckCash(10582660 ,  True, True, '3');