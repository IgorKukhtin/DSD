-- Function: gpSelect_Movement_Income_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print (Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_Print(
    IN inMovementId        Integer  , -- ключ Документа
  --  IN inReportType        Integer  , -- 0=out 1=in
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbChangePercentTo TFloat;
    DECLARE vbPaidKindId Integer;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsProcess_BranchIn Boolean;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());


     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
     THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
       -- RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;



      --
    OPEN Cursor1 FOR
      WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId 
                       )

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

           , CAST (COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0) AS TFloat)  AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData   AS ParPartnerValue


           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName
           , Object_CurrencyDocument.ValueData           AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData            AS CurrencyPartnerName
           , Object_Currency_PriceList.ValueData         AS CurrencyriceListName
           , MovementString_Comment.ValueData            AS Comment
         
       FROM  Movement
           
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

            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId
            --
            LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                 ON ObjectLink_Unit_PriceList.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Unit_PriceList.DescId = zc_ObjectLink_Unit_PriceList()
            LEFT JOIN ObjectLink AS Object_PriceList_Currency
                                 ON Object_PriceList_Currency.ObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                AND Object_PriceList_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency_PriceList ON Object_Currency_PriceList.Id = Object_PriceList_Currency.ChildObjectId
      WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Income();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , MovementItem.isErased
                       FROM 
                             MovementItem 
                                             
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
       -- Результат
       , tmpData AS (SELECT tmpMI.Id
                          , tmpMI.PartionId
                          , Object_Goods.Id          AS GoodsId
                          , Object_Goods.ObjectCode  AS GoodsCode
                          , Object_Goods.ValueData   AS GoodsName
                          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                          , Object_Measure.ValueData AS MeasureName
                          , Object_Juridical.ValueData as JuridicalName
                          , Object_CompositionGroup.ValueData   AS CompositionGroupName
                          , Object_Composition.ValueData   AS CompositionName
                          , Object_GoodsInfo.ValueData     AS GoodsInfoName
                          , Object_LineFabrica.ValueData   AS LineFabricaName
                          , Object_Label.ValueData         AS LabelName
                          , Object_GoodsSize.ValueData     AS GoodsSizeName
               
                          , tmpMI.Amount
               
                          , tmpMI.OperPrice      ::TFloat
                          , tmpMI.CountForPrice  ::TFloat
                          , tmpMI.OperPriceList  ::TFloat
               
                          , zfCalc_SummIn (tmpMI.Amount, tmpMI.OperPrice, tmpMI.CountForPrice) AS TotalSumm
                          , zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList)           AS TotalSummPriceList
                          , tmpMI.isErased
               
                      FROM tmpMI
               
                           LEFT JOIN Object_PartionGoods               ON Object_PartionGoods.MovementItemId = tmpMI.PartionId
               
                           LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id       = tmpMI.GoodsId
                           LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id     = Object_PartionGoods.MeasureId
                           LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id = Object_PartionGoods.CompositionId
                           LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
               
                           LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                           LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                           LEFT JOIN Object AS Object_Label            ON Object_Label.Id       = Object_PartionGoods.LabelId
                           LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                           LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id   = Object_PartionGoods.JuridicalId
               
                           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                                 AND ObjectString_Goods_GoodsGroupFull.DescId   =  zc_ObjectString_Goods_GroupNameFull()
                      WHERE tmpMI.Amount <> 0
                      )
                      
       SELECT tmpData.Id
            , tmpData.PartionId
            , tmpData.GoodsId
            , tmpData.GoodsCode
            , tmpData.GoodsName
            , tmpData.GoodsGroupNameFull
            , tmpData.MeasureName
            , tmpData.JuridicalName
            , tmpData.CompositionGroupName
            , tmpData.CompositionName
            , tmpData.GoodsInfoName
            , tmpData.LineFabricaName
            , tmpData.LabelName
            , tmpData.GoodsSizeName
            , tmpData.Amount             ::TFloat
            , tmpData.OperPrice          ::TFloat
            , tmpData.CountForPrice      ::TFloat
            , tmpData.OperPriceList      ::TFloat
            , tmpData.TotalSumm          ::TFloat
            , tmpData.TotalSummPriceList ::TFloat
            , tmpData.isErased
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
            , tmpData.JuridicalName
            , tmpData.CompositionGroupName
            , tmpData.CompositionName
            , tmpData.GoodsInfoName
            , tmpData.LineFabricaName
            , tmpData.LabelName
            , STRING_AGG ('[' ||tmpData.GoodsSizeName ||'] '||zfConvert_FloatToString (tmpData.Amount), '; ') AS GoodsSizeName
            , SUM (tmpData.Amount) ::TFloat AS Amount
            , tmpData.OperPrice          ::TFloat
            , tmpData.CountForPrice      ::TFloat
            , tmpData.OperPriceList      ::TFloat
            , SUM (tmpData.TotalSumm)          ::TFloat AS TotalSumm
            , SUM (tmpData.TotalSummPriceList) ::TFloat AS TotalSummPriceList
            , tmpData.isErased
       FROM tmpData
       WHERE zc_Enum_GlobalConst_isTerry() = FALSE -- для Подиум
       GROUP BY tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsName
              , tmpData.GoodsGroupNameFull
              , tmpData.MeasureName
              , tmpData.JuridicalName
              , tmpData.CompositionGroupName
              , tmpData.CompositionName
              , tmpData.GoodsInfoName
              , tmpData.LineFabricaName
              , LabelName
              , tmpData.OperPrice
              , tmpData.CountForPrice
              , tmpData.OperPriceList
              , tmpData.isErased

       ORDER BY 5       --GoodsName                

       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Income_Print (Integer,  TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.06.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income_Print (inMovementId:= 432692, inSession:= zfCalc_UserAdmin());
