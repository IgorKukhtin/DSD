-- Function: lpReport_OrderReturnTare_SaleByTransport()

DROP FUNCTION IF EXISTS lpReport_OrderReturnTare_SaleByTransport (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpReport_OrderReturnTare_SaleByTransport (Integer, Integer);

CREATE OR REPLACE FUNCTION lpReport_OrderReturnTare_SaleByTransport(
    IN inMovementId_Transport  Integer,   -- 
    IN inUserId                Integer   -- сессия пользователя
)
RETURNS TABLE(MovementId_Sale Integer
            , PartnerId       Integer
            , GoodsId         Integer
            , Amount          TFloat
)
AS
$BODY$
BEGIN

    -- Результат
    RETURN QUERY
    WITH
           --документ реестр по путевому
           tmpReestr AS (SELECT Movement.*
                              , MovementItem.Id AS MI_Id
                              , MovementFloat_MovementItemId.MovementId AS MovementId_Sale
                         FROM MovementLinkMovement AS MovementLinkMovement_Transport
                              INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Transport.MovementId  -- реестр  21907135
                                     AND Movement.DescId = zc_Movement_Reestr()
                                     AND Movement.StatusId <> zc_Enum_Status_Erased() --= zc_Enum_Status_UnComplete()
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                              --док продажи
                              INNER JOIN MovementFloat AS MovementFloat_MovementItemId
                                                       ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id
                                                      AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()

                         WHERE MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                           AND MovementLinkMovement_Transport.MovementChildId = inMovementId_Transport  --путевой
                         )

         --получаем оборотную тару
         , tmpInfoMoneyDestination_20500 AS (SELECT Object_InfoMoney_View.*
                                             FROM Object_InfoMoney_View
                                             WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500()
                                             )
         --оборотная тара
         , tmpGoods AS (SELECT ObjectLink.ObjectId AS GoodsId
                        FROM ObjectLink
                        WHERE ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney()
                          AND ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpInfoMoneyDestination_20500.InfoMoneyId FROM tmpInfoMoneyDestination_20500)
                        )

         , tmpMI_SaleALL AS (SELECT MovementItem.ObjectId   AS GoodsId
                                  , MovementItem.MovementId AS MovementId_Sale
                                  , MovementItem.Amount
                             FROM MovementItem 
                             WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpReestr.MovementId_Sale FROM tmpReestr)
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.isErased = FALSE
                             )

         , tmpMLO_To AS (SELECT MovementLinkObject.*
                         FROM MovementLinkObject
                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMI_SaleALL.MovementId_Sale FROM tmpMI_SaleALL)
                           AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                         )

           SELECT tmpMI_SaleALL.MovementId_Sale
                , MovementLinkObject_To.ObjectId AS PartnerId
                , tmpMI_SaleALL.GoodsId
                , SUM (tmpMI_SaleALL.Amount) ::TFloat AS Amount
           FROM tmpMI_SaleALL
                LEFT JOIN tmpMLO_To AS MovementLinkObject_To
                                    ON MovementLinkObject_To.MovementId = tmpMI_SaleALL.MovementId_Sale
                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpMI_SaleALL.GoodsId
           GROUP BY tmpMI_SaleALL.MovementId_Sale
                  , MovementLinkObject_To.ObjectId
                  , tmpMI_SaleALL.GoodsId

           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.01.22         *
*/

-- тест
-- SELECT * FROM lpReport_OrderReturnTare_SaleByTransport (inMovementId_Transport := 21590051, inSession:='5'::TVarChar);

--select * from gpGet_Movement_OrderReturnTare(inMovementId := 21903364 , inOperDate := ('07.01.2022')::TDateTime ,  inSession := '9457');