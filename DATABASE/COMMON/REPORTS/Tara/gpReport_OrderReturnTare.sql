-- Function: gpReport_OrderReturnTare()

DROP FUNCTION IF EXISTS gpReport_OrderReturnTare (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderReturnTare(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inisDetail       Boolean  , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescName TVarChar
            , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
            , InvNumber_Transport_Full TVarChar
            , GoodsId            Integer   -- ИД товара
            , GoodsCode          Integer   -- Код Товара
            , GoodsName          TVarChar  -- Товар
            , GoodsGroupName     TVarChar  -- Наименование группы товара
            , GoodsGroupNameFull TVarChar
            , Amount             TFloat    -- 
            , Amount_in          TFloat
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
           --документы продаж из реестра по путевому
           tmpMovement AS (SELECT Movement.*
                                  FROM Movement
                                  WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                    AND Movement.DescId = zc_Movement_OrderReturnTare()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  )
           --
         , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.*
                                       FROM MovementLinkMovement
                                       WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
                                         AND MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                       )
         , tmpMI AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.isErased = FALSE
                     )
         , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                         FROM MovementItemLinkObject
                                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                            AND MovementItemLinkObject.DescId = zc_MILinkObject_Partner()
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

         -- Данные из док. возврата 
         , tmpMIReturnIn AS (SELECT Movement.ParentId
                                  , MovementItem.ObjectId            AS GoodsId
                                  , MovementLinkObject_From.ObjectId AS PartnerId
                                  , SUM (MovementItem.Amount)        AS Amount
                           FROM Movement  
                                INNER JOIN Movement AS Movement_Parent
                                                    ON Movement_Parent.Id = Movement.ParentId
                                                   AND Movement_Parent.DescId = zc_Movement_OrderReturnTare()
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.DescId = zc_Movement_ReturnIn()
                           GROUP BY MovementItem.ObjectId
                                  , MovementLinkObject_From.ObjectId
                                  , Movement.ParentId
                           )
           --
           SELECT CASE WHEN inisDetail = TRUE THEN tmpMovement.Id ELSE 0 END                       AS MovementId
                , CASE WHEN inisDetail = TRUE THEN tmpMovement.OperDate ELSE NULL END ::TDateTime  AS OperDate
                , CASE WHEN inisDetail = TRUE THEN tmpMovement.InvNumber ELSE '' END  ::TVarChar   AS InvNumber
                , CASE WHEN inisDetail = TRUE THEN MovementDesc.ItemName ELSE '' END  ::TVarChar   AS MovementDescName
                , CASE WHEN inisDetail = TRUE THEN Object_Partner.Id ELSE 0 END                    AS PartnerId
                , CASE WHEN inisDetail = TRUE THEN Object_Partner.ObjectCode ELSE 0 END            AS PartnerCode
                , CASE WHEN inisDetail = TRUE THEN Object_Partner.ValueData ELSE '' END ::TVarChar AS PartnerName
                , CASE WHEN inisDetail = TRUE THEN zfCalc_PartionMovementName (Movement_Transport.DescId, MovementDesc_transport.ItemName, Movement_Transport.InvNumber, Movement_Transport.OperDate) ELSE '' END ::TVarChar AS InvNumber_Transport_Full

                , Object_Goods.Id              AS GoodsId         --ИД товара
                , Object_Goods.ObjectCode      AS GoodsCode       --Код Товара
                , Object_Goods.ValueData       AS GoodsName       --Товар
                , Object_GoodsGroup.ValueData  AS GoodsGroupName  --Наименование группы товара
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

                , SUM (MovementItem.Amount)  ::TFloat AS Amount
                , SUM (tmpMIReturnIn.Amount) ::TFloat AS Amount_in
           FROM tmpMovement
                LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovement.DescId
                LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Transport
                                                  ON MovementLinkMovement_Transport.MovementId = tmpMovement.Id
                LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
                LEFT JOIN MovementDesc AS MovementDesc_transport ON MovementDesc_transport.Id = Movement_Transport.DescId

                LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovement.Id

                LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Partner
                                                    ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                LEFT JOIN tmpMIReturnIn ON tmpMIReturnIn.GoodsId = MovementItem.ObjectId
                                       AND tmpMIReturnIn.PartnerId = MILinkObject_Partner.ObjectId
                                       AND tmpMIReturnIn.ParentId = tmpMovement.Id
                
           GROUP BY CASE WHEN inisDetail = TRUE THEN tmpMovement.Id ELSE 0 END
                  , CASE WHEN inisDetail = TRUE THEN tmpMovement.OperDate ELSE NULL END
                  , CASE WHEN inisDetail = TRUE THEN tmpMovement.InvNumber ELSE '' END
                  , CASE WHEN inisDetail = TRUE THEN MovementDesc.ItemName ELSE '' END
                  , CASE WHEN inisDetail = TRUE THEN Object_Partner.Id ELSE 0 END
                  , CASE WHEN inisDetail = TRUE THEN Object_Partner.ObjectCode ELSE 0 END
                  , CASE WHEN inisDetail = TRUE THEN Object_Partner.ValueData ELSE '' END
                  , Object_Goods.Id
                  , Object_Goods.ObjectCode
                  , Object_Goods.ValueData
                  , Object_GoodsGroup.ValueData
                  , ObjectString_Goods_GoodsGroupFull.ValueData
                  , CASE WHEN inisDetail = TRUE THEN zfCalc_PartionMovementName (Movement_Transport.DescId, MovementDesc_transport.ItemName, Movement_Transport.InvNumber, Movement_Transport.OperDate) ELSE '' END

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
-- SELECT * FROM gpReport_OrderReturnTare (inStartDate := '01.01.2022'::TDatetime,inEndDate:='08.01.2022'::TDatetime, inisDetail:= false, inSession:='5'::TVarChar);
