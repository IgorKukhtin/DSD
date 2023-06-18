-- Function: gpSelect_MI_Send_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_Send_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Send_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Article TVarChar
             , Amount TFloat
             , isErased Boolean
             , MovementId_OrderPartner Integer, InvNumber_OrderPartner_Full TVarChar
               -- Данные из партии
             , OperPrice_cost        TFloat
             , EKPrice               TFloat
             , CountForPrice_partion TFloat
             , TotalOperPrice        TFloat

             , OperDate_partion      TDateTime
             , InvNumber_partion     TVarChar
             , PartnerName_partion   TVarChar
             , PartNumber            TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
             -- Существующие Элементы Партий
           , tmpMI AS (SELECT MovementItem.Id
                            , MovementItem.PartionId
                            , MovementItem.ParentId
                            , MovementItem.ObjectId   AS GoodsId
                            , MovementItem.Amount
                            , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                            , MovementItem.isErased
                       FROM tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                      )
       -- Элементы - Заказ клиента - zc_MI_Child
     , tmpMI_order AS (SELECT DISTINCT
                              tmpMI.MovementId_order  AS MovementId_order
                            , MovementItem.ObjectId   AS GoodsId
                              -- заказ Поставщику
                            , MIFloat_MovementId.ValueData :: Integer AS MovementId_order_income

                       FROM (SELECT DISTINCT tmpMI.MovementId_order FROM tmpMI) AS tmpMI
                            JOIN MovementItem ON MovementItem.MovementId = tmpMI.MovementId_order
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = FALSE
                            -- ValueData - MovementId заказ Поставщику
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                      )


     , tmpPartionGoods AS (SELECT Object_PartionGoods.*
                                , MIString_PartNumber.ValueData AS PartNumber
                           FROM Object_PartionGoods
                                LEFT JOIN MovementItemString AS MIString_PartNumber
                                                             ON MIString_PartNumber.MovementItemId = Object_PartionGoods.MovementItemId
                                                            AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                           WHERE Object_PartionGoods.MovementItemId IN (SELECT tmpMI.PartionId FROM tmpMI)
                             AND Object_PartionGoods.isErased = FALSE
                           )
        -- Результат
        SELECT MovementItem.Id
             , MovementItem.ParentId
             , MovementItem.GoodsId            AS GoodsId
             , Object_Goods.ObjectCode         AS GoodsCode
             , Object_Goods.ValueData          AS GoodsName
             , ObjectString_Article.ValueData  AS Article
             , MovementItem.Amount
             , MovementItem.isErased

             , Movement_OrderPartner.Id        AS MovementId_OrderPartner
             , zfCalc_InvNumber_isErased ('', Movement_OrderPartner.InvNumber, Movement_OrderPartner.OperDate, Movement_OrderPartner.StatusId) AS InvNumber_OrderPartner_Full

               -- Цена затрат без НДС
             , tmpPartionGoods.CostPrice ::TFloat AS OperPrice_cost
              -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
             , tmpPartionGoods.EKPrice       ::TFloat
             , tmpPartionGoods.CountForPrice ::TFloat    AS CountForPrice_partion
               --
             , (MovementItem.Amount * (tmpPartionGoods.EKPrice / tmpPartionGoods.CountForPrice)) ::TFloat AS TotalOperPrice
               --
             , Movement_Partion.OperDate      ::TDateTime AS OperDate_partion
             , (zfCalc_InvNumber_isErased (MovementDesc_Partion.ItemName, Movement_Partion.InvNumber, Movement_Partion.OperDate, Movement_Partion.StatusId) || ' (' || MovementItem.PartionId :: TVarChar || ')') :: TVarChar AS InvNumber_partion
             , Object_Partner.ValueData       ::TVarChar  AS PartnerName_partion
             , tmpPartionGoods.PartNumber    ::TVarChar
        FROM tmpMI AS MovementItem
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

             LEFT JOIN tmpMI_order ON tmpMI_order.GoodsId          = MovementItem.GoodsId
                                  AND tmpMI_order.MovementId_order = MovementItem.MovementId_order
             LEFT JOIN Movement AS Movement_OrderPartner ON Movement_OrderPartner.Id = tmpMI_order.MovementId_order_income
             
             LEFT JOIN tmpPartionGoods ON tmpPartionGoods.MovementItemId = MovementItem.PartionId
             LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpPartionGoods.MovementId
             LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpPartionGoods.FromId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.06.21         *
*/

-- тест
-- SELECT * from gpSelect_MI_Send_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
