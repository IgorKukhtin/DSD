-- Function: gpSelect_MovementItem_CheckLoadCash()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckLoadCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckLoadCash(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , PriceSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             , isErased Boolean
             , List_UID TVarChar
             , Remains TFloat
             , Color_calc Integer
             , Color_ExpirationDate Integer
             , AccommodationName TVarChar
             , Multiplicity TFloat
             , DoesNotShare Boolean
             , IdSP TVarChar
             , CountSP TFloat
             , PriceRetSP TFloat
             , PaymentSP TFloat
             , PartionDateKindId Integer
             , PartionDateKindName TVarChar
             , PricePartionDate TFloat
             , PartionDateDiscount TFloat
             , AmountMonth TFloat
             , PriceDiscount TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

     SELECT MovementLinkObject_Unit.ObjectId
     INTO vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;

     RETURN QUERY
     WITH
     tmpMI AS (SELECT MovementItem.*
               FROM MovementItem_Check_View AS MovementItem
               WHERE MovementItem.MovementId = inMovementId
               )

   , tmpMovSendPartion AS (SELECT
                                  Movement.Id                               AS Id
                                , MovementFloat_ChangePercent.ValueData     AS ChangePercent
                                , MovementFloat_ChangePercentMin.ValueData  AS ChangePercentMin
                           FROM Movement

                                LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                        ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                       AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                                        ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                                       AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                           WHERE Movement.DescId = zc_Movement_SendPartionDate()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND MovementLinkObject_Unit.ObjectId = vbUnitId
                           ORDER BY Movement.OperDate
                           LIMIT 1
                          )
   , tmpMovItemSendPartion AS (SELECT
                                      MovementItem.ObjectId    AS GoodsId
                                    , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                    , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin

                               FROM MovementItem

                                    LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                               AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                    LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                                ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                               AND MIFloat_ChangePercentMin.DescId = zc_MIFloat_ChangePercentMin()

                               WHERE MovementItem.MovementId = (select tmpMovSendPartion.Id from tmpMovSendPartion)
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND (MIFloat_ChangePercent.ValueData is not Null OR MIFloat_ChangePercentMin.ValueData is not Null)
                               )

       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.NDS
           , MovementItem.PriceSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent
           , MovementItem.AmountOrder
           , MovementItem.isErased
           , MovementItem.List_UID
           , MovementItem.Amount
           , zc_Color_White()                                                    AS Color_calc
           , zc_Color_Black()                                                    AS Color_ExpirationDate
           , Null::TVArChar                                                      AS AccommodationName
           , Null::TFloat                                                        AS Multiplicity
           , COALESCE (ObjectBoolean_DoesNotShare.ValueData, FALSE)              AS DoesNotShare
           , Null::TVArChar                                                      AS IdSP
           , Null::TFloat                                                        AS CountSP
           , Null::TFloat                                                        AS PriceRetSP
           , Null::TFloat                                                        AS PaymentSP
           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , MIFloat_MovementItem.ValueData                                      AS PricePartionDate
           , Null::TFloat                                                        AS PartionDateDiscount
           , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFLoat                 AS AmountMonth
           , COALESCE(MIFloat_MovementItem.ValueData, MovementItem.PriceSale)    AS PriceDiscount
       FROM tmpMI AS MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_PricePartionDate()
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

            -- Не делить медикамент на кассах
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DoesNotShare
                                    ON ObjectBoolean_DoesNotShare.ObjectId = MovementItem.GoodsId
                                   AND ObjectBoolean_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()
            --Типы срок/не срок
            LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                             ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                            AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
      ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckLoadCash (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 25.04.19                                                                                   *
 */

-- тест
-- select * from gpSelect_MovementItem_CheckLoadCash(inMovementId := 3959328 ,  inSession := '3');