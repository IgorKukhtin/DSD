-- Function: gpSelect_Movement_Send_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send_Print (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_Print(
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send_Print());
     vbUserId:= inSession;

      --
    OPEN Cursor1 FOR
    WITH tmpMI AS (SELECT SUM (zfCalc_SummPriceList (MovementItem.Amount, COALESCE (MIFloat_OperPriceListTo.ValueData, 0))) AS TotalSummPriceListTo
                    FROM MovementItem 
                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListTo
                                                     ON MIFloat_OperPriceListTo.MovementItemId = MovementItem.Id
                                                    AND MIFloat_OperPriceListTo.DescId = zc_MIFloat_OperPriceListTo()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     > 0
                    )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalSummPriceList.ValueData  AS TotalSummPriceList
           , tmpMI.TotalSummPriceListTo :: TFloat        AS TotalSummPriceListTo
        
           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName

           , MovementString_Comment.ValueData            AS Comment
           , Object_Currency_PriceListTo.ValueData       AS CurrencyriceListName_to
           , Object_Currency_PriceListFrom.ValueData     AS CurrencyriceListName_from
         
       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId = zc_MovementFloat_TotalSummPriceList()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                 ON ObjectLink_Unit_PriceList.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Unit_PriceList.DescId = zc_ObjectLink_Unit_PriceList()
            LEFT JOIN ObjectLink AS Object_PriceList_Currency
                                 ON Object_PriceList_Currency.ObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                AND Object_PriceList_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency_PriceListTo ON Object_Currency_PriceListTo.Id = Object_PriceList_Currency.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceListFrom
                                 ON ObjectLink_Unit_PriceListFrom.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Unit_PriceListFrom.DescId = zc_ObjectLink_Unit_PriceList()
            LEFT JOIN ObjectLink AS Object_PriceList_CurrencyFrom
                                 ON Object_PriceList_CurrencyFrom.ObjectId = ObjectLink_Unit_PriceListFrom.ChildObjectId
                                AND Object_PriceList_CurrencyFrom.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency_PriceListFrom ON Object_Currency_PriceListFrom.Id = Object_PriceList_CurrencyFrom.ChildObjectId
            
            LEFT JOIN tmpMI ON 1=1

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Send();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , COALESCE (MIFloat_OperPriceListTo.ValueData, 0) AS OperPriceListTo
                           , MovementItem.isErased
                       FROM MovementItem 
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListTo
                                                        ON MIFloat_OperPriceListTo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceListTo.DescId = zc_MIFloat_OperPriceListTo()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                         AND MovementItem.Amount     > 0
                       )

       -- результат
     , tmpData AS (SELECT tmpMI.Id
                        , tmpMI.PartionId
                        , Object_Goods.Id                AS GoodsId
                        , Object_Goods.ObjectCode        AS GoodsCode
                        , Object_Goods.ValueData         AS GoodsName
                        , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                        , Object_Measure.ValueData       AS MeasureName

                        , Object_Partner.ValueData       AS PartnerName
                        , Object_Composition.ValueData   AS CompositionName
                        , Object_GoodsInfo.ValueData     AS GoodsInfoName
                        , Object_LineFabrica.ValueData   AS LineFabricaName
                        , Object_Label.ValueData         AS LabelName
                        , Object_GoodsSize.ValueData     AS GoodsSizeName 
                        , Object_Currency.ValueData      AS CurrencyName

                        , tmpMI.Amount
                        , Object_PartionGoods.OperPrice      ::TFloat
                        , tmpMI.OperPriceList                ::TFloat
                        , tmpMI.OperPriceListTo              ::TFloat
                        , zfCalc_SummIn (tmpMI.Amount, Object_PartionGoods.OperPrice, Object_PartionGoods.CountForPrice) AS TotalSumm
                        , zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList)                                       AS TotalSummPriceList
                        , zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceListTo)                                     AS TotalSummPriceListTo

                    FROM tmpMI
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
                         LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 
             
                         LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
                         LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
                         LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
                         LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
                         LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
                         LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
                         LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
                         LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
                         LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = Object_PartionGoods.PartnerId
                        
                         LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                               AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                  )
       SELECT tmpData.Id
            , tmpData.PartionId
            , tmpData.GoodsId
            , tmpData.GoodsCode
            , tmpData.GoodsName
            , tmpData.GoodsGroupNameFull
            , tmpData.MeasureName
            , tmpData.PartnerName
            , tmpData.CompositionName
            , tmpData.GoodsInfoName
            , tmpData.LineFabricaName
            , tmpData.LabelName
            , tmpData.CurrencyName
            , tmpData.GoodsSizeName
            , tmpData.Amount               ::TFloat
            , tmpData.OperPrice            ::TFloat
            , tmpData.OperPriceList        ::TFloat
            , tmpData.OperPriceListTo      ::TFloat
            , tmpData.TotalSumm            ::TFloat
            , tmpData.TotalSummPriceList   ::TFloat
            , tmpData.TotalSummPriceListTo ::TFloat
       FROM tmpData
       WHERE zc_Enum_GlobalConst_isTerry() = TRUE
     UNION
       SELECT 0 AS Id
            , 0 AS PartionId
            , tmpData.GoodsId
            , tmpData.GoodsCode
            , tmpData.GoodsName
            , tmpData.GoodsGroupNameFull
            , tmpData.MeasureName
            , tmpData.PartnerName
            , tmpData.CompositionName
            , tmpData.GoodsInfoName
            , tmpData.LineFabricaName
            , tmpData.LabelName
            , tmpData.CurrencyName
            , STRING_AGG ('[' ||tmpData.GoodsSizeName ||'] '||zfConvert_FloatToString (tmpData.Amount), '; ') AS GoodsSizeName
            , SUM (tmpData.Amount)               ::TFloat AS Amount
            , tmpData.OperPrice                  ::TFloat
            , tmpData.OperPriceList              ::TFloat
            , tmpData.OperPriceListTo            ::TFloat
            , SUM (tmpData.TotalSumm)            ::TFloat AS TotalSumm
            , SUM (tmpData.TotalSummPriceList)   ::TFloat AS TotalSummPriceList
            , SUM (tmpData.TotalSummPriceListTo) ::TFloat AS TotalSummPriceListTo

       FROM tmpData
       WHERE zc_Enum_GlobalConst_isTerry() = FALSE -- для Подиум
       GROUP BY tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsName
              , tmpData.GoodsGroupNameFull
              , tmpData.MeasureName
              , tmpData.PartnerName
              , tmpData.CompositionName
              , tmpData.GoodsInfoName
              , tmpData.LineFabricaName
              , tmpData.LabelName
              , tmpData.CurrencyName
              , tmpData.OperPrice
              , tmpData.OperPriceList
              , tmpData.OperPriceListTo
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Send_Print (Integer,  TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 06.03.18         *
 27.04.17                                                          *
 05.06.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send_Print (inMovementId := 432692, inSession:= '5');
