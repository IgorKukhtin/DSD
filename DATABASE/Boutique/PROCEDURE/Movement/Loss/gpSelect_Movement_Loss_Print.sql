-- Function: gpSelect_Movement_Loss_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Loss_Print (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_Loss_Print(
    IN inMovementId        Integer  ,  -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPaidKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Loss_Print());
     vbUserId:= inSession;

      --
    OPEN Cursor1 FOR

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm
           , MovementFloat_TotalSummPriceList.ValueData  AS TotalSummPriceList

           , CAST (COALESCE (MovementFloat_CurrencyValue.ValueData, 0) AS TFloat)  AS CurrencyValue
           , MovementFloat_ParValue.ValueData   AS ParValue
        
           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName
           , Object_CurrencyDocument.ValueData           AS CurrencyDocumentName
           , MovementString_Comment.ValueData            AS Comment
         
       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId = zc_MovementFloat_TotalSummPriceList()

            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId
     
      WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Loss();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , MovementItem.isErased
                       FROM MovementItem 
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                       where  MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = false
                       )

       -- результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData AS MeasureName

           , Object_Partner.ValueData       AS PartnerName
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.ValueData     AS GoodsSizeName 

           , tmpMI.Amount
           , tmpMI.CountForPrice  :: TFloat
           , tmpMI.OperPrice      :: TFloat
           , tmpMI.OperPriceList  :: TFloat

           , zfCalc_SummIn (tmpMI.Amount, tmpMI.OperPrice, tmpMI.CountForPrice) AS TotalSumm
           , zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList)           AS TotalSummPriceList
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = Object_PartionGoods.PartnerId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
       ORDER BY Object_Goods.ObjectCode
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 21.07.17         *
 28.04.17                                                          *
 05.06.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Loss_Print (inMovementId := 432692, inSession:= '5');
