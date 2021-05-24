-- Function: gpSelect_Movement_SendOnPrice_Print()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice_Print (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendOnPrice_Print(
    IN inMovementId        Integer  , -- ключ Документа
    --IN inReportType        Integer  , -- 0=out 1=in
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
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbBranchId Integer;

    DECLARE vbOperSumm_MVATIn TFloat;
    DECLARE vbOperSumm_PVATIn TFloat;
    DECLARE vbTotalCountKgIn  TFloat;
    DECLARE vbTotalCountShIn  TFloat;

    DECLARE vbOperSumm_MVATOut TFloat;
    DECLARE vbOperSumm_PVATOut TFloat;
    DECLARE vbTotalCountKgOut  TFloat;
    DECLARE vbTotalCountShOut  TFloat;

    DECLARE vbWeighingCount   Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SendOnPrice_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- кол-во Взвешиваний
     vbWeighingCount:= (SELECT COUNT(*)
                        FROM Movement
                        WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END    AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END     AS ExtraChargesPercent
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)
          , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0)
            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbPaidKindId, vbBranchId
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

     -- !!!МЕНЯЕТСЯ параметр!!!
 --    IF vbBranchId IN (0, zc_Branch_Basis())
 --    THEN inReportType :=  1; -- !!!т.е. количество пришло!!!
 --    ELSE inReportType :=  COALESCE (inReportType, 0);
 --    END IF;


    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() -- AND inSession <> '5'
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
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;


    IF 1=1 -- inReportType = 0 -- !!!out!!!
    THEN
        -- Расчет Сумм
        SELECT CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены без НДС или %НДС=0
                         THEN OperSummIn
                    WHEN vbPriceWithVAT AND 1=1
                         -- если цены c НДС
                         THEN CAST ( (OperSummIn) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                    WHEN vbPriceWithVAT
                         -- если цены c НДС (Вариант может быть если первичен расчет НДС =1/6 )
                         THEN OperSummIn - CAST ( (OperSummIn) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
               END AS OperSumm_MVATIn
               -- Сумма с НДС
             , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены с НДС
                         THEN (OperSummIn)
                    WHEN vbVATPercent > 0
                         -- если цены без НДС
                         THEN CAST ( (1 + vbVATPercent / 100) * (OperSummIn) AS NUMERIC (16, 2))
               END AS OperSumm_PVATIn
             , TotalCountKgIn
             , TotalCountShIn
-- out
             , CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены без НДС или %НДС=0
                         THEN OperSummOut
                    WHEN vbPriceWithVAT AND 1=1
                         -- если цены c НДС
                         THEN CAST ( (OperSummOut) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                    WHEN vbPriceWithVAT
                         -- если цены c НДС (Вариант может быть если первичен расчет НДС =1/6 )
                         THEN OperSummOut - CAST ( (OperSummOut) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
               END AS OperSumm_MVATOut
               -- Сумма с НДС
             , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены с НДС
                         THEN (OperSummOut)
                    WHEN vbVATPercent > 0
                         -- если цены без НДС
                         THEN CAST ( (1 + vbVATPercent / 100) * (OperSummOut) AS NUMERIC (16, 2))
               END AS OperSumm_PVATOut
             , TotalCountKgOut
             , TotalCountShOut

               INTO vbOperSumm_MVATIn, vbOperSumm_PVATIn, vbTotalCountKgIn, vbTotalCountShIn
                  , vbOperSumm_MVATOut, vbOperSumm_PVATOut, vbTotalCountKgOut, vbTotalCountShOut


        FROM
       (SELECT -- In
                         SUM (CASE WHEN tmpMI.CountForPrice <> 0
                              THEN CAST (tmpMI.AmountIn * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                              ELSE CAST (tmpMI.AmountIn * tmpMI.Price AS NUMERIC (16, 2))
                         END) AS OperSummIn

                         -- ШТ
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.AmountIn
                              ELSE 0
                         END) AS TotalCountShIn
                         -- ВЕС
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.AmountIn * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.AmountIn
                              ELSE 0
                         END) AS TotalCountKgIn
              -- Out
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                              THEN CAST (tmpMI.AmountOut * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.AmountOut * tmpMI.Price AS NUMERIC (16, 2))
                            END) AS OperSummOut

                         -- ШТ
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.AmountOut
                              ELSE 0
                         END) AS TotalCountShOut
                         -- ВЕС
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.AmountOut * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.AmountOut
                              ELSE 0
                         END) AS TotalCountKgOut

        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END                                                AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0)      AS CountForPrice
                   , SUM (MovementItem.Amount)                          AS AmountOut
                   , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0)) AS AmountIn

              FROM MovementItem
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                   INNER JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData

             ) AS tmpMI
                       LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
        ) AS tmpMI;
    END IF;


     --
    OPEN Cursor1 FOR
       SELECT
             Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                         AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)     AS OperDatePartner
           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent

           , MovementFloat_TotalCount.ValueData         AS TotalCountOut
           , MovementFloat_TotalCountPartner.ValueData  AS TotalCountIn

           , vbTotalCountKgOut                          AS TotalCountKgOut
           , vbTotalCountKgIn                           AS TotalCountKgIn

           , vbTotalCountShOut                          AS TotalCountShOut
           , vbTotalCountShIn                           AS TotalCountShIn

           , vbOperSumm_MVATOut                         AS TotalSummMVATOut
           , vbOperSumm_MVATIn                          AS TotalSummMVATIn

           , vbOperSumm_PVATOut                         AS TotalSummPVATOut
           , vbOperSumm_PVATIn                          AS TotalSummPVATIn

           , vbOperSumm_PVATOut - vbOperSumm_MVATOut    AS SummVATOut
           , vbOperSumm_PVATIn  - vbOperSumm_MVATIn     AS SummVATIn

           , vbOperSumm_PVATOut                         AS TotalSummOut
           , vbOperSumm_PVATIn                          AS TotalSummIn

           , Object_From.ValueData             	        AS FromName
           , Object_To.ValueData                        AS ToName
           , Object_PaidKind.ValueData         	        AS PaidKindName

           , Object_RouteSorting.ValueData 	        AS RouteSortingName

           , '' :: TVarChar                             AS StoreKeeper -- кладовщик
           , '' :: TVarChar                             AS Through     -- через кого

           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From

           , Object_Retail_order.ValueData                 AS RetailName_order
           , Object_Partner_order.ValueData                AS PartnerName_order
           , TRIM (COALESCE (MovementString_Comment_order.ValueData, '')) :: TVarChar AS Comment_order

           --, inReportType AS ReportType

             -- кол-во Взвешиваний
           , vbWeighingCount AS WeighingCount

           --Основание для перемещения
           , COALESCE (Object_SubjectDoc.ValueData,'') ::TVarChar AS SubjectDocName

       FROM Movement

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = ObjectLink_Unit_Juridical.ChildObjectId
                                                               AND Movement.OperDate >= OH_JuridicalDetails_From.StartDate
                                                               AND Movement.OperDate <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_order
                                         ON MovementLinkObject_Partner_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Partner_order.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner_order ON Object_Partner_order.Id = MovementLinkObject_Partner_order.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail_order
                                         ON MovementLinkObject_Retail_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Retail_order.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail_order ON Object_Retail_order.Id = MovementLinkObject_Retail_order.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment_order
                                     ON MovementString_Comment_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                    AND MovementString_Comment_order.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       SELECT
             zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode
           , Object_Goods.ObjectCode         AS GoodsCode
           , (Object_Goods.ValueData || ' ' || Object_GoodsKind.ValueData) :: TVarChar AS GoodsName
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , Object_Unit.ValueData           AS UnitName
           , Object_Unit.ObjectCode          AS UnitCode

           , tmpMI.AmountOut
           , tmpMI.AmountIn
             
           , (tmpMI.AmountOut - tmpMI.AmountIn) AS AmountDiff
           
           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice

           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountOut * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountOut * tmpMI.Price AS NUMERIC (16, 2))
                  END                       AS AmountOutSumm
                  
           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountIn * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountIn * tmpMI.Price AS NUMERIC (16, 2))
                  END                       AS AmountInSumm

           , (CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountOut * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountOut * tmpMI.Price AS NUMERIC (16, 2))
                  END ) -
             (CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountIn * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountIn * tmpMI.Price AS NUMERIC (16, 2))
                  END)                       AS AmountSummDiff

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

             -- расчет цены с НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST (tmpMI.Price + tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT

           , CAST (tmpMI.AmountIn * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2))       AS AmountInSummNoVAT

           , CAST (tmpMI.AmountOut * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2))       AS AmountOutSummNoVAT


           , CAST (tmpMI.AmountIn * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3))       AS AmountInSummWVAT

           , CAST (tmpMI.AmountOut * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3))       AS AmountOutSummWVAT

           , CAST ((tmpMI.AmountIn * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat)     AS AmountIn_Weight
           , CAST ((tmpMI.AmountOut * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat)    AS AmountOut_Weight

           , CAST ((tmpMI.AmountOut * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) - 
             CAST ((tmpMI.AmountIn * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat)     AS Amount_WeightDiff
           
           , CAST ((tmpMI.AmountIn * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END )) AS TFloat)     AS AmountIn_sh
           , CAST ((tmpMI.AmountOut * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END )) AS TFloat)    AS AmountOut_sh
           
           , CAST ((tmpMI.AmountIn * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END )) AS TFloat)  -
             CAST ((tmpMI.AmountOut * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END )) AS TFloat)    AS AmountDiffsh


       FROM (SELECT MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , COALESCE (MILinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId)      AS UnitId
                  , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END                                                 AS Price
                  , MIFloat_CountForPrice.ValueData                     AS CountForPrice
                  -- , SUM (CASE WHEN vbBranchId = zc_Branch_Basis() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE MovementItem.Amount END) AS AmountOut
                  , SUM (MovementItem.Amount) AS AmountOut
                  , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountIn--Partner
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              -- AND MIFloat_Price.ValueData <> 0
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
        
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                  

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
                    , COALESCE (MILinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId)

            ) AS tmpMI


            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN ObjectString AS OS_Measure_InternalCode
                                   ON OS_Measure_InternalCode.ObjectId = Object_Measure.Id
                                  AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id
            
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
       WHERE (tmpMI.AmountOut <> 0 ) OR (tmpMI.AmountIn <> 0)
       
       --WHERE (tmpMI.AmountOut <> 0 AND inReportType = 0)
       --   OR (tmpMI.AmountIn <> 0 AND inReportType = 1)

       ORDER BY  Object_Unit.ValueData , Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_SendOnPrice_Print (Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.20         * SubjectDocName
 29.10.15         * del inReportType
 04.06.15         * add unitId
 05.03.15                                        * all
 10.02.15                                                       *
 19.11.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SendOnPrice_Print (inMovementId:= 570596, inSession:= '5');
