-- Function: gpSelect_Movement_TTN_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_TTN_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TTN_Print(
    IN inMovementId        Integer  , -- ключ Документа
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

   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


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
            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId
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
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
     WHERE Movement.Id = inMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

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
       WITH tmpTransport AS (SELECT MovementChildId FROM MovementLinkMovement  WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_TransportGoods())
          , tmpTransportGoods AS (SELECT * 
                                  FROM gpGet_Movement_TransportGoods (inMovementId       := (SELECT MovementChildId FROM tmpTransport)
                                                                    , inMovementId_Sale  := inMovementId
                                                                    , inOperDate         := NULL
                                                                    , inSession          := inSession
                                                                     )
                                  WHERE EXISTS (SELECT MovementChildId FROM tmpTransport)
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

                     FROM (SELECT  MovementItem.ObjectId                         AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                                  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                             ELSE MovementItem.Amount
                                        END
                                        * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )
                                        ) AS AmountPartnerWeight
                           FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                             ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                 LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
           
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                      AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
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

       --          
       SELECT 
             Movement.InvNumber                         AS InvNumber_Sale
           , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpTransportGoods.Id) AS IdBarCode             
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) ELSE Movement.OperDate END :: TDateTime AS OperDate_Sale
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner_Sale
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner_Sale

           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT

           , Object_From.ValueData                      AS FromName
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName

           , OH_JuridicalDetails_To.FullName            AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , (CASE WHEN ObjectString_PostalCode.ValueData  <> '' THEN ObjectString_PostalCode.ValueData || ' '      ELSE '' END
           || CASE WHEN View_Partner_Address.RegionName    <> '' THEN View_Partner_Address.RegionName   || ' обл., ' ELSE '' END
           || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN View_Partner_Address.ProvinceName || ' р-н, '  ELSE '' END
           || ObjectString_ToAddress.ValueData
             ) :: TVarChar            AS PartnerAddress_To

           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From

           , COALESCE (OH_JuridicalDetails_car.FullName, OH_JuridicalDetails_From.FullName)                 :: TVarChar AS JuridicalName_car
           , COALESCE (OH_JuridicalDetails_car.JuridicalAddress, OH_JuridicalDetails_From.JuridicalAddress) :: TVarChar AS JuridicalAddress_car
           , COALESCE (OH_JuridicalDetails_car.OKPO, OH_JuridicalDetails_From.OKPO)                         :: TVarChar AS OKPO_car
           
           , tmpTransportGoods.InvNumber
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate_OperDatePartner.ValueData, tmpTransportGoods.OperDate) ELSE tmpTransportGoods.OperDate END :: TDateTime AS OperDate
           , tmpTransportGoods.InvNumberMark
           , tmpTransportGoods.CarName
           , tmpTransportGoods.CarModelName
           , tmpTransportGoods.CarTrailerName
           , tmpTransportGoods.CarTrailerModelName
           , tmpTransportGoods.PersonalDriverName
           , COALESCE (ObjectString_DriverCertificate_external.ValueData, ObjectString_DriverCertificate.ValueData) :: TVarChar AS DriverCertificate
           , CASE WHEN TRIM (COALESCE (tmpTransportGoods.MemberName1, '')) = '' THEN tmpTransportGoods.PersonalDriverName ELSE tmpTransportGoods.MemberName1 END :: TVarChar AS MemberName1
           , tmpTransportGoods.MemberName2
           , tmpTransportGoods.MemberName3
           , tmpTransportGoods.MemberName4
           , tmpTransportGoods.MemberName5
           , tmpTransportGoods.MemberName6
           , tmpTransportGoods.MemberName7
           , tmpTransportGoods.TotalCountBox
           , tmpTransportGoods.TotalWeightBox
           ,   COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0) + COALESCE (tmpPackage.TotalWeightPackage,0) AS TotalWeight_Brutto
           , ((COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1)    :: TFloat AS TotalWeight_BruttoKg
           , ((COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000) :: TFloat AS TotalWeight_BruttoT
           , TRUNC ((COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000) :: TFloat AS TotalWeight_BruttoT1
           , TRUNC ( ( ROUND( (COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000, 3)
                    - TRUNC ((COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1000)
                     ) * 1000) :: TFloat AS TotalWeight_BruttoT2

           , CASE WHEN 1 =
             TRUNC ( ((COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0)) / 1000
                    - TRUNC ((COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0)) / 1000)
                     ) * 1000)
                  THEN 'тисячна' ELSE 'тисячних' END :: TVarChar AS Info2
          --
          , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOf

        --, tmpCar_param.Length :: TVarChar  AS Length
        --, tmpCar_param.Width  :: TVarChar  AS Width 
        --, tmpCar_param.Height :: TVarChar  AS Height
          , (select tmpCar_param.Length from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS Length
          , (select tmpCar_param.Width  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS Width 
          , (select tmpCar_param.Height from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS Height

          , CASE WHEN COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                    + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                    = 0
                      THEN 0
                      ELSE COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                         + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
            END :: TFloat AS Weight_car

          , CASE WHEN COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                    + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                    = 0
                      THEN 0
                 ELSE 
                      CAST ((((COALESCE (tmpTransportGoods.TotalWeightBox, 0)
                             + COALESCE (MovementFloat_TotalCountKg.ValueData, 0)
                             + COALESCE (tmpPackage.TotalWeightPackage,0)
                              ) / 1)
                      + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                      + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                      ) AS NUMERIC (16,0)) :: TFloat END :: TFloat AS Weight_all

          , ( ( ((COALESCE (tmpTransportGoods.TotalWeightBox, 0) + COALESCE (MovementFloat_TotalCountKg.ValueData, 0) + COALESCE (tmpPackage.TotalWeightPackage,0)) / 1)
                      + (COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId), 0)
                       + COALESCE ((select tmpCar_param.Weight from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId), 0)
                        ))/1000) :: TFloat AS Weight_all_t --в тоннах

          , CASE WHEN tmpCar_param.Year > 0 THEN CAST (tmpCar_param.Year AS Integer) :: TVarChar ELSE '' END ::TVarChar AS Year

        --, tmpCar_param.VIN  ::TVarChar AS VIN
          , (select tmpCar_param.VIN  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS VIN 
 
       -- , tmpCarTrailer_param.Length :: TVarChar  AS Length_tr
       -- , tmpCarTrailer_param.Width  :: TVarChar  AS Width_tr
       -- , tmpCarTrailer_param.Height :: TVarChar  AS Height_tr
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
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

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
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
            LEFT JOIN ObjectString AS ObjectString_PostalCode
                                   ON ObjectString_PostalCode.ObjectId = View_Partner_Address.StreetId
                                  AND ObjectString_PostalCode.DescId = zc_ObjectString_Street_PostalCode()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf                           
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()

-- Contract
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())*/
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                   AS OH_JuridicalDetails_From
                   ON OH_JuridicalDetails_From.JuridicalId = CASE WHEN vbDescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() ELSE COALESCE (View_Contract.JuridicalBasisId, Object_From.Id) END
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id 
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                   AS OH_JuridicalDetails_To
                   ON OH_JuridicalDetails_To.JuridicalId = CASE WHEN vbDescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id) END   -- CASE WHEN zc_Juridical_Basis() --
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                   AS OH_JuridicalDetails_car
                   ON OH_JuridicalDetails_car.JuridicalId = tmpTransportGoods.JuricalId_car
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_car.StartDate
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_car.EndDate

            LEFT JOIN tmpPackage ON 1=1

            LEFT JOIN tmpCar_param ON tmpCar_param.CarId = tmpTransportGoods.CarId AND 1=0
            LEFT JOIN tmpCar_param AS tmpCarTrailer_param ON tmpCarTrailer_param.CarId = tmpTransportGoods.CarTrailerId AND 1=0
       WHERE Movement.Id = inMovementId
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
                      , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                  ELSE MovementItem.Amount
                             END) AS AmountPartner
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
    
                      LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                  ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                 AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                       ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
    
                       LEFT JOIN ObjectFloat AS ObjectFloat_Box_Weight
                                             ON ObjectFloat_Box_Weight.ObjectId = MILinkObject_Box.ObjectId
                                            AND ObjectFloat_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()
    
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.01.20         * 
 03.02.17         *
 08.01.15                                                       *
*/
-- тест
--select * from gpSelect_Movement_TTN_Print(inMovementId := 15691934 ,  inSession := '5');
--FETCH ALL "<unnamed portal 96>";
