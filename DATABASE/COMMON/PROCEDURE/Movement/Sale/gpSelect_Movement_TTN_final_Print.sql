-- Function: gpSelect_Movement_TTN_final_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_TTN_final_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TTN_final_Print(
    IN inMovementId        Integer  , -- ключ Документа   продажа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    
    DECLARE vbJuricalId_car Integer;
    DECLARE vbOperDate_find TDateTime;
    DECLARE vbFromId_find Integer;
    DECLARE vbToId_find Integer;
    DECLARE vbJuridicalId_zamovn Integer;

    DECLARE vbOperDate_Begin1 TDateTime;
    DECLARE vbMovementDescId  Integer;
    DECLARE vbMovementId_TG   Integer;
    DECLARE vbMovementId_Sale Integer;
    
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     --все ТТН для итоговой печати
     CREATE TEMP TABLE _tmpMovement (MovementId_TG Integer, InvNumber_GT TVarChar, MovementId_sale Integer, InvNumber_sale TVarChar, OperDate_sale TDateTime, Ord Integer) ON COMMIT DROP;
     INSERT INTO _tmpMovement (MovementId_TG, InvNumber_GT, MovementId_sale, InvNumber_sale, OperDate_sale, Ord)
        WITH     
        --Находим ТТН ДЛЯ продажи
        tmpTG AS (SELECT MovementChildId AS Id FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_TransportGoods())
        -- путевой  из ТТН
      , tmpTransport AS (SELECT MLM.MovementChildId AS MovementId 
                         FROM MovementLinkMovement AS MLM
                         WHERE MLM.MovementId IN (SELECT DISTINCT tmpTG.Id FROM tmpTG) 
                           AND MLM.DescId = zc_MovementLinkMovement_Transport()
                         )
        -- все ТТН по путевому
       SELECT MLM.MovementId       AS MovementId_TG 
            , Movement.InvNumber   AS InvNumber_GT
            , MLM_Sale.MovementId  AS MovementId_sale
            , Movement_sale.InvNumber AS InvNumber_Sale
            , Movement_sale.OperDate  AS OperDate_Sale
            , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, MLM.MovementId) AS Ord
       FROM MovementLinkMovement AS MLM
            LEFT JOIN Movement ON Movement.Id = MLM.MovementId
            LEFT JOIN MovementLinkMovement AS MLM_Sale
                                           ON MLM_Sale.MovementChildId = MLM.MovementId
                                          AND MLM_Sale.DescId = zc_MovementLinkMovement_TransportGoods()
            INNER JOIN Movement AS Movement_sale
                                ON Movement_sale.Id = MLM_Sale.MovementId
                               AND Movement_sale.StatusId = zc_Enum_Status_Complete()
       WHERE MLM.MovementChildId IN (SELECT DISTINCT tmpTransport.MovementId FROM tmpTransport) 
         AND MLM.DescId = zc_MovementLinkMovement_Transport()
       ;

     --мин ТТН  и с ним Продажа - для печати что всегда одинако пичаталось
     vbMovementId_TG := (SELECT _tmpMovement.MovementId_TG FROM _tmpMovement WHERE _tmpMovement.Ord = 1);
     vbMovementId_Sale:=(SELECT _tmpMovement.MovementId_Sale FROM _tmpMovement WHERE _tmpMovement.Ord = 1);

     vbJuricalId_car:= 
      (WITH tmpTransportGoods AS (SELECT * 
                                  FROM gpGet_Movement_TransportGoods (inMovementId       := vbMovementId_TG
                                                                    , inMovementId_Sale  := inMovementId
                                                                    , inOperDate         := NULL
                                                                    , inSession          := inSession
                                                                     )
                                  WHERE COALESCE (vbMovementId_TG,0) <> 0
                                 )
       SELECT tmpTransportGoods.JuricalId_car FROM tmpTransportGoods
      );

     vbMovementDescId := (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);
     
     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END    AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END     AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)     AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDate_find

          , CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() 
                 WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (ObjectLink_Partner_Juridical_From.ChildObjectId, Object_From.Id)
                 ELSE COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
            END AS FromId_find
            

          , CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() 
                 WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (View_Contract.JuridicalBasisId, Object_To.Id)
                 ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
            END AS ToId_find

          , CASE WHEN Movement.DescId = zc_Movement_Sale() AND Object_Route.ValueData ILIKE 'самов%' THEN COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                 ELSE 0
            END AS JuridicalId_zamovn

            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId
               , vbOperDate_find
               , vbFromId_find
               , vbToId_find
               , vbJuridicalId_zamovn
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
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical_From
                               ON ObjectLink_Partner_Juridical_From.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical_From.DescId = zc_ObjectLink_Partner_Juridical()

          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId     = zc_MovementLinkMovement_Order()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId -- MovementLinkObject_Contract.ObjectId

     WHERE Movement.Id = inMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

--   RAISE EXCEPTION 'Ошибка.<%>', vbJuricalId_car;

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
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



     --
    OPEN Cursor1 FOR
       WITH tmpTransportGoods AS (SELECT tmp.* 
                                  FROM gpGet_Movement_TransportGoods (inMovementId       := vbMovementId_TG
                                                                    , inMovementId_Sale  := vbMovementId_Sale
                                                                    , inOperDate         := NULL
                                                                    , inSession          := inSession
                                                                     ) AS tmp
                                  WHERE COALESCE (vbMovementId_TG, 0) <> 0
                                 )

     , tmpPackage AS (SELECT  
                           -- Вес Упаковок (пакетов)
                            (SUM( (CASE WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) > 0
                                     THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                                          CAST (tmpMI.AmountPartnerWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) ) AS NUMERIC (16, 0))
                                        * -- вес 1-ого пакета
                                          COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                                     ELSE 0
                                END ) ) ) :: TFloat AS TotalWeightPackage

                     FROM (WITH
                           tmpMI AS (SELECT MovementItem.*
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId IN (SELECT DISTINCT _tmpMovement.MovementId_Sale FROM _tmpMovement)
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                                     )
                         , tmpMILO_GoodsKind AS (SELECT  MovementItemLinkObject.*
                                                 FROM MovementItemLinkObject
                                                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                                )

                         , tmpMIFloat_AmountPartner AS (SELECT  MovementItemFloat.*
                                                        FROM MovementItemFloat
                                                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI) 
                                                          AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                                                       )

                           SELECT  MovementItem.ObjectId                         AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                        * (CASE WHEN  ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )
                                        ) AS AmountPartnerWeight
                           FROM tmpMI AS MovementItem
                                 LEFT JOIN tmpMIFloat_AmountPartner AS MIFloat_AmountPartner
                                                             ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                 --LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
           
                                 LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                      AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                -- LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                           GROUP BY MovementItem.ObjectId
                                  , MILinkObject_GoodsKind.ObjectId
                           ) AS tmpMI
                     -- Товар и Вид товара
                     LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpMI.GoodsId
                                                           AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMI.GoodsKindId
                     -- вес 1-ого пакета
                     LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                           ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                                          AND ObjectFloat_WeightPackage.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
                     -- вес в упаковке: "чистый" вес + вес 1-ого пакета
                     LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                           ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                          AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
                     )

     , tmpCar_all AS (SELECT DISTINCT tmpTransportGoods.CarId AS CarId FROM tmpTransportGoods UNION SELECT tmpTransportGoods.CarTrailerId AS CarId FROM tmpTransportGoods)
     , tmpObjectFloat_car AS (SELECT *
                              FROM ObjectFloat
                              WHERE ObjectFloat.ObjectId IN (SELECT DISTINCT tmpCar_all.CarId FROM tmpCar_all)
                             )
     , tmpObjectString_car AS (SELECT *
                              FROM ObjectString
                              WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpCar_all.CarId FROM tmpCar_all)
                             )

     , tmpCar_param AS (SELECT tmp.CarId
                             , CASE WHEN COALESCE (ObjectFloat_Length.ValueData,0) = 0 THEN '' ELSE CAST (ObjectFloat_Length.ValueData AS NUMERIC (16,0)) ::TVarChar END :: TVarChar  AS Length
                             , CASE WHEN COALESCE (ObjectFloat_Width.ValueData,0) = 0 THEN '' ELSE CAST (ObjectFloat_Width.ValueData AS NUMERIC (16,0))   ::TVarChar END :: TVarChar  AS Width 
                             , CASE WHEN COALESCE (ObjectFloat_Height.ValueData,0) = 0 THEN '' ELSE CAST (ObjectFloat_Height.ValueData AS NUMERIC (16,0)) ::TVarChar END :: TVarChar  AS Height
                             , COALESCE (ObjectFloat_Weight.ValueData, 0) AS Weight
                             , COALESCE (ObjectFloat_Year.ValueData, 0)   AS Year
                             , ObjectString_VIN.ValueData                 AS VIN
                        FROM tmpCar_all AS tmp
                             ---
                             LEFT JOIN tmpObjectFloat_car AS ObjectFloat_Length
                                                   ON ObjectFloat_Length.ObjectId = tmp.CarId
                                                  AND ObjectFloat_Length.DescId IN (zc_ObjectFloat_Car_Length(),zc_ObjectFloat_CarExternal_Length())
                             LEFT JOIN tmpObjectFloat_car AS ObjectFloat_Width
                                                   ON ObjectFloat_Width.ObjectId = tmp.CarId
                                                  AND ObjectFloat_Width.DescId IN (zc_ObjectFloat_Car_Width(),zc_ObjectFloat_CarExternal_Width())
                             LEFT JOIN tmpObjectFloat_car AS ObjectFloat_Height
                                                   ON ObjectFloat_Height.ObjectId = tmp.CarId
                                                  AND ObjectFloat_Height.DescId IN (zc_ObjectFloat_Car_Height(), zc_ObjectFloat_CarExternal_Height())
                             LEFT JOIN tmpObjectFloat_car AS ObjectFloat_Weight
                                                   ON ObjectFloat_Weight.ObjectId = tmp.CarId
                                                  AND ObjectFloat_Weight.DescId IN (zc_ObjectFloat_Car_Weight(), zc_ObjectFloat_CarExternal_Weight())
                             LEFT JOIN tmpObjectFloat_car AS ObjectFloat_Year
                                                   ON ObjectFloat_Year.ObjectId = tmp.CarId
                                                  AND ObjectFloat_Year.DescId IN (zc_ObjectFloat_Car_Year(), zc_ObjectFloat_CarExternal_Year())
                             LEFT JOIN tmpObjectString_car AS ObjectString_VIN
                                                    ON ObjectString_VIN.ObjectId = tmp.CarId
                                                   AND ObjectString_VIN.DescId IN (zc_ObjectString_Car_VIN(), zc_ObjectString_CarExternal_VIN())
                        )

            , t1 AS (SELECT *
                     FROM ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                          WHERE OH_JuridicalDetails_From.JuridicalId = vbFromId_find
                          AND vbOperDate_find >= OH_JuridicalDetails_From.StartDate
                          AND vbOperDate_find <  OH_JuridicalDetails_From.EndDate
                  )

            , t2 AS (SELECT *
                     FROM ObjectHistory_JuridicalDetails_ViewByDate
                   AS OH_JuridicalDetails_To
                   WHERE  OH_JuridicalDetails_To.JuridicalId = vbToId_find
                  AND vbOperDate_find >= OH_JuridicalDetails_To.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_To.EndDate
                  )

            , t3 AS (SELECT *
                     FROM ObjectHistory_JuridicalDetails_ViewByDate
                   AS OH_JuridicalDetails_car
                   WHERE OH_JuridicalDetails_car.JuridicalId = vbJuricalId_car
                  AND vbOperDate_find >= OH_JuridicalDetails_car.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_car.EndDate
                  )
            , t4 AS (SELECT *
                     FROM ObjectHistory_JuridicalDetails_ViewByDate
                   AS OH_JuridicalDetails_car
                   WHERE OH_JuridicalDetails_car.JuridicalId = vbJuridicalId_zamovn
                  AND vbOperDate_find >= OH_JuridicalDetails_car.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_car.EndDate
                  )

            , tmpOH_Juridical_Basis AS (SELECT *
                                        FROM ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails
                                        WHERE OH_JuridicalDetails.JuridicalId = zc_Juridical_Basis()
                                       AND vbOperDate_find >= OH_JuridicalDetails.StartDate
                                       AND vbOperDate_find <  OH_JuridicalDetails.EndDate
                                       ) 
       --итого по продажам                                              
     , tmpSale_Total AS (WITH
                         tmpMovementFloat AS (SELECT MovementFloat.*
                                              FROM MovementFloat
                                              WHERE MovementFloat.MovementId IN (SELECT DISTINCT _tmpMovement.MovementId_Sale FROM _tmpMovement) 
                                                AND MovementFloat.DescId IN (zc_MovementFloat_TotalCountKg()
                                                                           , zc_MovementFloat_TotalCountSh()
                                                                           , zc_MovementFloat_TotalSumm()
                                                                           , zc_MovementFloat_TotalSummMVAT()
                                                                           , zc_MovementFloat_TotalSummPVAT())
                                             )

                         SELECT SUM (COALESCE (MovementFloat_TotalCountKg.ValueData,0))       AS TotalCountKg
                              , SUM (COALESCE (MovementFloat_TotalCountSh.ValueData,0))       AS TotalCountSh
                              , SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0))          AS TotalSumm 
                              , SUM (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0))  AS TotalSummVAT
                         FROM _tmpMovement
                              LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                                      ON MovementFloat_TotalCountKg.MovementId =  _tmpMovement.MovementId_Sale
                                                     AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                              LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                                      ON MovementFloat_TotalCountSh.MovementId =  _tmpMovement.MovementId_Sale
                                                     AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
                              LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId =  _tmpMovement.MovementId_Sale
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                              LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                                      ON MovementFloat_TotalSummMVAT.MovementId =  _tmpMovement.MovementId_Sale
                                                     AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                              LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                                      ON MovementFloat_TotalSummPVAT.MovementId =  _tmpMovement.MovementId_Sale
                                                     AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                        )
     --итого по ТТН
     , tmpTG_Total AS (SELECT 0  AS TotalCountBox         --в gpGet_Movement_TransportGoods = 0   если будут значения, то здессь нужна сумма
                            , 0  AS TotalWeightBox
                       )

       --
        --          
       SELECT 
             ''::TVarChar /* Movement.InvNumber*/                         AS InvNumber_Sale  
            --(SELECT STRING_AGG (DISTINCT _tmpMovement.InvNumber_Sale, ';' ) FROM _tmpMovement) AS InvNumber_Sale  
           , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpTransportGoods.Id) AS IdBarCode             
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) ELSE Movement.OperDate END :: TDateTime AS OperDate_Sale
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner_Sale
           --, COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)  AS OperDatePartner_Sale
           , ''::TVarChar AS OperDatePartner_Sale

           , tmpSale_Total.TotalCountKg       AS TotalCountKg
           , tmpSale_Total.TotalCountSh       AS TotalCountSh
           , tmpSale_Total.TotalSumm          AS TotalSumm
           , CAST (tmpSale_Total.TotalSummVAT AS TFloat) AS TotalSummVAT

           , Object_From.ValueData AS FromName
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName

           , CASE WHEN vbJuridicalId_zamovn > 0
                       THEN OH_JuridicalDetails_zamovn.FullName
                  WHEN vbMovementDescId <> zc_Movement_ReturnIn()
                       THEN OH_JuridicalDetails_From.FullName
                  ELSE OH_JuridicalDetails_To.FullName
             END AS JuridicalName_Basis             --Замовник Алан 
             
            -- дублируем Алан для итоговой
           /*, (CASE WHEN Object_To.Id IN (11216101) --AND vbUserId = 5
                        THEN '' -- inToId := 3470472 , inPartnerId := 11216101

                   ELSE OH_JuridicalDetails_To.FullName
              END
           || CASE WHEN Object_To.Id IN (11216101) --AND vbUserId = 5
                        -- Укрзалізниця АТ - Условное обозначение
                        THEN ObjectString_BranchJur.ValueData
                        
                   ELSE ''
              END
             ) :: TVarChar AS JuridicalName_To
          
           , CASE WHEN vbDescId = zc_Movement_SendOnPrice() AND ObjectString_Unit_Address_to.ValueData <> '' AND ObjectString_Unit_Address_to.ValueData NOT ILIKE '% - O - %'
                    THEN ObjectString_Unit_Address_to.ValueData
                   ELSE OH_JuridicalDetails_To.JuridicalAddress
              END      :: TVarChar AS JuridicalAddress_To

           , OH_JuridicalDetails_To.OKPO AS OKPO_To
           */  
           , OH_JuridicalDetails_From.FullName AS JuridicalName_To
           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn()
               THEN
                 CASE WHEN vbDescId = zc_Movement_SendOnPrice() AND ObjectString_Unit_Address_from.ValueData <> '' AND ObjectString_Unit_Address_from.ValueData NOT ILIKE '% - O - %'
                           THEN ObjectString_Unit_Address_from.ValueData
                      ELSE OH_JuridicalDetails_From.JuridicalAddress
                 END 
               ELSE   
                 (CASE WHEN vbDescId = zc_Movement_SendOnPrice() AND ObjectString_Unit_Address_from.ValueData <> '' AND ObjectString_Unit_Address_from.ValueData NOT ILIKE '% - O - %'
                           THEN ObjectString_Unit_Address_from.ValueData
                      ELSE CASE WHEN ObjectString_PostalCodeFrom.ValueData  <> '' THEN ObjectString_PostalCodeFrom.ValueData || ' '      ELSE '' END
                        || CASE WHEN View_Partner_AddressFrom.RegionName    <> '' THEN View_Partner_AddressFrom.RegionName   || ' обл., ' ELSE '' END
                        || CASE WHEN View_Partner_AddressFrom.ProvinceName  <> '' THEN View_Partner_AddressFrom.ProvinceName || ' р-н, '  ELSE '' END
                        || ObjectString_FromAddress.ValueData
                  END
                )
             END  :: TVarChar AS JuridicalAddress_To
           , OH_JuridicalDetails_From.OKPO AS OKPO_To
           

           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn()
               THEN
                 (CASE WHEN vbDescId = zc_Movement_SendOnPrice() AND ObjectString_Unit_Address_to.ValueData <> '' AND ObjectString_Unit_Address_to.ValueData NOT ILIKE '% - O - %'
                           THEN ObjectString_Unit_Address_to.ValueData
                      ELSE CASE WHEN ObjectString_PostalCode.ValueData  <> '' THEN ObjectString_PostalCode.ValueData || ' '      ELSE '' END
                        || CASE WHEN View_Partner_Address.RegionName    <> '' THEN View_Partner_Address.RegionName   || ' обл., ' ELSE '' END
                        || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN View_Partner_Address.ProvinceName || ' р-н, '  ELSE '' END
                        || ObjectString_ToAddress.ValueData
                  END
                ) 
               ELSE 
                 OH_Juridical_Basis.JuridicalAddress
             END   :: TVarChar            AS PartnerAddress_To

           , OH_JuridicalDetails_From.FullName AS JuridicalName_From

           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn()
               THEN
                 CASE WHEN vbDescId = zc_Movement_SendOnPrice() AND ObjectString_Unit_Address_from.ValueData <> '' AND ObjectString_Unit_Address_from.ValueData NOT ILIKE '% - O - %'
                           THEN ObjectString_Unit_Address_from.ValueData
                      ELSE OH_JuridicalDetails_From.JuridicalAddress
                 END 
               ELSE   
                 (CASE WHEN vbDescId = zc_Movement_SendOnPrice() AND ObjectString_Unit_Address_from.ValueData <> '' AND ObjectString_Unit_Address_from.ValueData NOT ILIKE '% - O - %'
                           THEN ObjectString_Unit_Address_from.ValueData
                      ELSE CASE WHEN ObjectString_PostalCodeFrom.ValueData  <> '' THEN ObjectString_PostalCodeFrom.ValueData || ' '      ELSE '' END
                        || CASE WHEN View_Partner_AddressFrom.RegionName    <> '' THEN View_Partner_AddressFrom.RegionName   || ' обл., ' ELSE '' END
                        || CASE WHEN View_Partner_AddressFrom.ProvinceName  <> '' THEN View_Partner_AddressFrom.ProvinceName || ' р-н, '  ELSE '' END
                        || ObjectString_FromAddress.ValueData
                  END
                )
             END  :: TVarChar AS JuridicalAddress_From

           , OH_JuridicalDetails_From.OKPO AS OKPO_From

           , COALESCE (OH_JuridicalDetails_car.FullName, CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN OH_JuridicalDetails_From.FullName ELSE OH_JuridicalDetails_To.FullName END)                       :: TVarChar AS JuridicalName_car
           , COALESCE (OH_JuridicalDetails_car.JuridicalAddress, CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN OH_JuridicalDetails_From.JuridicalAddress ELSE OH_JuridicalDetails_To.JuridicalAddress END) :: TVarChar AS JuridicalAddress_car
           , COALESCE (OH_JuridicalDetails_car.OKPO, CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN OH_JuridicalDetails_From.OKPO ELSE OH_JuridicalDetails_To.OKPO END)                                     :: TVarChar AS OKPO_car
           
           , tmpTransportGoods.InvNumber
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate_OperDatePartner.ValueData, tmpTransportGoods.OperDate) ELSE tmpTransportGoods.OperDate END :: TDateTime AS OperDate
           , tmpTransportGoods.InvNumberMark
           , tmpTransportGoods.CarName
           , tmpTransportGoods.CarModelName
           , CASE WHEN COALESCE (tmpTransportGoods.CarTrailerName, '') = '' THEN 'немає' ELSE tmpTransportGoods.CarTrailerName END ::TVarChar AS CarTrailerName
           , tmpTransportGoods.CarTrailerModelName
           , tmpTransportGoods.PersonalDriverName
           , COALESCE (ObjectString_DriverCertificate_external.ValueData, ObjectString_DriverCertificate.ValueData) :: TVarChar AS DriverCertificate
           , CASE WHEN TRIM (COALESCE (tmpTransportGoods.MemberName1, '')) = '' THEN tmpTransportGoods.PersonalDriverName ELSE tmpTransportGoods.MemberName1 END :: TVarChar AS MemberName1
           , tmpTransportGoods.MemberName2
           , tmpTransportGoods.MemberName3
           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN 'Комірник ' ||tmpTransportGoods.MemberName4 ELSE tmpTransportGoods.MemberName7 END AS MemberName4  -- 4 и 7 меняем местами для возврата
           , tmpTransportGoods.MemberName5
           , tmpTransportGoods.MemberName6
           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN tmpTransportGoods.MemberName7 ELSE 'Комірник ' ||tmpTransportGoods.MemberName4 END AS MemberName7
           , tmpTG_Total.TotalCountBox
           , tmpTG_Total.TotalWeightBox
           ,   COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0) + COALESCE (tmpPackage.TotalWeightPackage,0) AS TotalWeight_Brutto
           , ((COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1)    :: TFloat AS TotalWeight_BruttoKg
           , ((COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000) :: TFloat AS TotalWeight_BruttoT
           , TRUNC ((COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000) :: TFloat AS TotalWeight_BruttoT1
           , TRUNC ( ( ROUND( (COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000, 3)
                    - TRUNC ((COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000)
                     ) * 1000) :: TFloat AS TotalWeight_BruttoT2

           , CASE WHEN 1 =
             TRUNC ( ((COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0)) / 1000
                    - TRUNC ((COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0)) / 1000)
                     ) * 1000)
                  THEN 'тисячна' ELSE 'тисячних' END :: TVarChar AS Info2
          --
          , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOf
          , (select tmpCar_param.Length  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS Length
          , (select tmpCar_param.Width  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS Width 
          , (select tmpCar_param.Height from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS Height
          --вага авто в кг
          , CASE WHEN COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                    + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                    = 0
                      THEN 0
                      ELSE COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                         + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
            END :: TFloat AS Weight_car
          --вага авто в тоннах
          , ((CASE WHEN COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                    + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                    = 0
                      THEN 0
                      ELSE COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                         + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
            END)/ 1000) :: TFloat AS Weight_car_t
          --загальна вага в кг  
          , CASE WHEN COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                    + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                    = 0
                      THEN 0
                 ELSE 
                      CAST ((((COALESCE (tmpTG_Total.TotalWeightBox, 0)
                             + COALESCE (tmpSale_Total.TotalCountKg, 0)
                             + COALESCE (tmpPackage.TotalWeightPackage,0)
                              ) / 1)
                      + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                      + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                      ) AS NUMERIC (16,0)) :: TFloat END :: TFloat AS Weight_all
           --загальна вага в тоннах
          , ( ( ((COALESCE (tmpTG_Total.TotalWeightBox, 0) + COALESCE (tmpSale_Total.TotalCountKg, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1)
                      + (COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                       + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                        ))/1000) :: TFloat AS Weight_all_t --в тоннах

          , CASE WHEN (select tmpCar_param.Year from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) > 0
                     THEN  (select tmpCar_param.Year :: Integer from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar ELSE '' END ::TVarChar AS Year

          , (select tmpCar_param.VIN  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS VIN 
 
          , (select tmpCar_param.Length from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId) :: TVarChar  AS Length_tr
          , (select tmpCar_param.Width  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId) :: TVarChar  AS Width_tr
          , (select tmpCar_param.Height from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId) :: TVarChar  AS Height_tr 
          
       FROM Movement
            LEFT JOIN tmpTransportGoods ON tmpTransportGoods.MovementId_Sale = Movement.Id

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = tmpTransportGoods.PersonalDriverId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                   ON ObjectString_DriverCertificate.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()
            LEFT JOIN ObjectString AS ObjectString_DriverCertificate_external
                                   ON ObjectString_DriverCertificate_external.ObjectId = tmpTransportGoods.PersonalDriverId
                                  AND ObjectString_DriverCertificate_external.DescId   = zc_ObjectString_MemberExternal_DriverCertificate()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From() 
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()      --для итоговой Вантажоодержувач тоже Алан
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Unit_Address_from
                                   ON ObjectString_Unit_Address_from.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_Address_from.DescId = zc_ObjectString_Unit_Address()
                                --and 1=0
            LEFT JOIN ObjectString AS ObjectString_Unit_Address_to
                                   ON ObjectString_Unit_Address_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_Address_to.DescId = zc_ObjectString_Unit_Address()
                                --and 1=0

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
            LEFT JOIN ObjectString AS ObjectString_PostalCode
                                   ON ObjectString_PostalCode.ObjectId = View_Partner_Address.StreetId
                                  AND ObjectString_PostalCode.DescId = zc_ObjectString_Street_PostalCode()

            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = Object_From.Id
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_AddressFrom ON View_Partner_AddressFrom.PartnerId = Object_From.Id
            
            LEFT JOIN ObjectString AS ObjectString_PostalCodeFrom
                                   ON ObjectString_PostalCodeFrom.ObjectId = View_Partner_AddressFrom.StreetId
                                  AND ObjectString_PostalCodeFrom.DescId = zc_ObjectString_Street_PostalCode()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN Object_From.Id ELSE Object_To.Id END
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf                           
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()

            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = 11216101 -- MovementLinkObject_To.ObjectId
                                  AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            -- Название юр.лица для филиала
            LEFT JOIN ObjectString AS ObjectString_BranchJur
                                   ON ObjectString_BranchJur.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_BranchJur.DescId = zc_ObjectString_Partner_BranchJur()

-- Contract
            LEFT JOIN t1
                   AS OH_JuridicalDetails_From
                   ON OH_JuridicalDetails_From.JuridicalId = vbFromId_find
                  AND vbOperDate_find >= OH_JuridicalDetails_From.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN t2
                   AS OH_JuridicalDetails_To
                   ON OH_JuridicalDetails_To.JuridicalId = vbToId_find      --для итоговой Вантажоодержувач тоже Алан
                  AND vbOperDate_find >= OH_JuridicalDetails_To.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN t3
                   AS OH_JuridicalDetails_car
                   ON OH_JuridicalDetails_car.JuridicalId = vbJuricalId_car
                  AND vbOperDate_find >= OH_JuridicalDetails_car.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_car.EndDate

            LEFT JOIN t4
                   AS OH_JuridicalDetails_zamovn
                   ON OH_JuridicalDetails_zamovn.JuridicalId = vbJuridicalId_zamovn
                  AND vbOperDate_find >= OH_JuridicalDetails_zamovn.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_zamovn.EndDate

            LEFT JOIN tmpOH_Juridical_Basis AS OH_Juridical_Basis ON vbMovementDescId = zc_Movement_ReturnIn()

            LEFT JOIN tmpPackage ON 1=1
            LEFT JOIN tmpSale_Total ON 1 = 1
            LEFT JOIN tmpTG_Total ON 1=1

       WHERE Movement.Id = vbMovementId_Sale
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       -- список Названия покупателя для товаров + GoodsKindId
  WITH tmpObject_GoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                             , Object_GoodsPropertyValue.ValueData  AS Name

                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId, 0)  AS GoodsBoxId
                                             , COALESCE (ObjectFloat_Weight.ValueData, 0)                          AS GoodsBox_Weight
                                        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                             ) AS tmpGoodsProperty
                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                             
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                   ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                                                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                       )
       -- список Названия для товаров (нужны если не найдем по GoodsKindId)
     , tmpObject_GoodsPropertyValueGroup AS (SELECT tmpObject_GoodsPropertyValue.GoodsId
                                                  , tmpObject_GoodsPropertyValue.Name
                                             FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Name <> '' GROUP BY GoodsId
                                                  ) AS tmpGoodsProperty_find
                                                  LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                                            )

     , tmpMIAll AS (SELECT MovementItem.*
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT _tmpMovement.MovementId_Sale FROM _tmpMovement)
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                    )
     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIAll.Id FROM tmpMIAll)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                            )
     , tmpMILO_Box AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIAll.Id FROM tmpMIAll)
                         AND MovementItemLinkObject.DescId = zc_MILinkObject_Box()
                      )
    
     , tmpMIFloat AS (SELECT  MovementItemFloat.*
                                    FROM MovementItemFloat
                                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIAll.Id FROM tmpMIAll) 
                                      AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                                     , zc_MIFloat_AmountPartner()
                                                                     , zc_MIFloat_CountForPrice()
                                                                     , zc_MIFloat_BoxCount()
                                                                     )
                                   )

     , tmpMI AS (SELECT MovementItem.ObjectId                         AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                  THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                             WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                  THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                             ELSE COALESCE (MIFloat_Price.ValueData, 0)
                        END                                 AS Price
                      , MIFloat_CountForPrice.ValueData     AS CountForPrice
                      , SUM (COALESCE (MIFloat_BoxCount.ValueData, 0))                                                  AS BoxCount
                      , SUM (COALESCE (MIFloat_BoxCount.ValueData, 0) * COALESCE (ObjectFloat_Box_Weight.ValueData, 0)) AS Box_Weight
                      , SUM (MovementItem.Amount)           AS Amount
                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                 FROM tmpMIAll AS MovementItem
                      LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                  -- AND MIFloat_Price.ValueData <> 0
                      LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                     -- LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
    
                      LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
    
                      LEFT JOIN tmpMIFloat AS MIFloat_BoxCount
                                                  ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                 AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                      LEFT JOIN tmpMILO_Box AS MILinkObject_Box
                                            ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                       LEFT JOIN ObjectFloat AS ObjectFloat_Box_Weight
                                             ON ObjectFloat_Box_Weight.ObjectId = MILinkObject_Box.ObjectId
                                            AND ObjectFloat_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()
    
                      LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 GROUP BY MovementItem.ObjectId
                        , MILinkObject_GoodsKind.ObjectId
                        , MIFloat_Price.ValueData
                        , MIFloat_CountForPrice.ValueData
                )
      -- Результат
      SELECT Object_Goods.ObjectCode         AS GoodsCode
           , (CASE WHEN COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) <> '' THEN COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) ELSE Object_Goods.ValueData END
           || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
             ) :: TVarChar AS GoodsName
           , (CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE Object_GoodsKind.ValueData END) :: TVarChar AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice
           , tmpMI.BoxCount                  AS BoxCount
           , tmpMI.Box_Weight                AS Box_Weight

             -- сумма по ценам док-та
           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

             -- расчет цены с НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT

             -- расчет суммы без НДС, до 2 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
--------------------
           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / 1000
                 + COALESCE (tmpMI.Box_Weight, 0) / 1000
                   ) AS TFloat) AS TotalWeight_BruttoT_old

--------------------
           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / 1000
                 + (COALESCE (tmpMI.BoxCount, 0) * COALESCE (tmpObject_GoodsPropertyValue.GoodsBox_Weight, 0) )/ 1000
                 + -- плюс Вес Упаковок (пакетов)
                   CASE WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) > 0
                        THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                             CAST (tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) ) AS NUMERIC (16, 0))
                           * -- вес 1-ого пакета
                             COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                        ELSE 0
                   END /1000
                   ) AS TFloat) AS TotalWeight_BruttoT
--------------------
           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / 1
                 + COALESCE (tmpMI.Box_Weight, 0) / 1
                   ) AS TFloat) AS TotalWeight_BruttoKg

            --температурный режим - 0-6
           , 'від 0 до 6' ::TVarChar AS Temperatura_Text

           , ObjectString_QualityINN.ValueData   :: TVarChar AS QualityINN
           , Object_GoodsGroupProperty.ValueData :: TVarChar AS GoodsGroupPropertyName
       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId     = Object_Goods.Id
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = Object_Goods.Id
                                                       AND tmpObject_GoodsPropertyValue.GoodsId      IS NULL

          -- Товар и Вид товара
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpMI.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMI.GoodsKindId
          -- вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightPackage.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
          -- вес в упаковке: "чистый" вес + вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()

          --  для получения ИНН тварини 
          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                          ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                         AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_30200())

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                               ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = tmpMI.GoodsId
                              AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                              AND COALESCE (View_InfoMoney.InfoMoneyId,0) <> 0                                                                
                              --пока отключаем до заполнения справочников
                              AND 1 = 0
          LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId   

          LEFT JOIN ObjectString AS ObjectString_QualityINN
                                 ON ObjectString_QualityINN.ObjectId = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
                                And ObjectString_QualityINN.DescId = zc_ObjectString_GoodsGroupProperty_QualityINN()
          --
       WHERE tmpMI.AmountPartner <> 0
         AND tmpMI.Price <> 0
       ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
      ;

    RETURN NEXT Cursor2;
/*
     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_Movement_TTN_Print'
               -- ProtocolData
             , inMovementId  :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.25         *
 21.11.24         * 
*/
-- тест
--  SELECT * FROM gpSelect_Movement_TTN_final_Print (inMovementId := 29797865  ,  inSession := '5'); --FETCH ALL "<unnamed portal 96>";
