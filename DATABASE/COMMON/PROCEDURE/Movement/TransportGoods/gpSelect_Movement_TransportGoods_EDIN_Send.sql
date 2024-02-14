-- Function: gpSelect_Movement_TransportGoods_EDIN_Send()

DROP FUNCTION IF EXISTS gpSelect_Movement_TransportGoods_EDIN_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportGoods_EDIN_Send(
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
    
    DECLARE vbJuricalId_car Integer;
    DECLARE vbOperDate_find TDateTime;
    DECLARE vbFromId_find Integer;
    DECLARE vbToId_find Integer;

    DECLARE vbOperDate_Begin1 TDateTime;
    DECLARE vbMovementSaleId Integer;
    DECLARE vbMovementDescId Integer;
    
    DECLARE vbUserSign TVarChar;
    DECLARE vbUserSeal TVarChar;
    DECLARE vbUserKey  TVarChar;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- определяется
     SELECT -- UserSign
            CASE WHEN vbUserId <> 5
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\Петренко Є.С\24447183_3110604434_SU231123104254.ZS2'
                 WHEN vbUserId = 5 AND 1=1
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\Петренко Є.С\24447183_3110604434_SU231123104254.ZS2'
                 WHEN ObjectString_UserSign.ValueData <> '' THEN ObjectString_UserSign.ValueData
                 ELSE '24447183_3110604434_SU231123104254.ZS2'
            END AS UserSign

            -- UserSeal
          , CASE WHEN vbUserId <> 5
                    --THEN 'g:\Спільні диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                 WHEN vbUserId = 5 AND 1=1
                    --THEN 'g:\Спільні диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                 WHEN ObjectString_UserSeal.ValueData <> '' THEN ObjectString_UserSeal.ValueData
                 ELSE '24447183_U221220114928.ZS2'
            END AS UserSeal

            -- UserKey
          , CASE WHEN vbUserId <> 5
                    --THEN 'g:\Спільні диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                 WHEN vbUserId = 5 AND 1=1
                    --THEN 'g:\Спільні диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                 WHEN ObjectString_UserKey.ValueData <> '' THEN ObjectString_UserKey.ValueData
                 ELSE '24447183_U221220114928.ZS2'
            END AS UserKey

            INTO vbUserSign, vbUserSeal, vbUserKey

     FROM Object AS Object_User
          LEFT JOIN ObjectString AS ObjectString_UserSign
                                 ON ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
                                AND ObjectString_UserSign.ObjectId = Object_User.Id
          LEFT JOIN ObjectString AS ObjectString_UserSeal
                                 ON ObjectString_UserSeal.DescId = zc_ObjectString_User_Seal() 
                                AND ObjectString_UserSeal.ObjectId = Object_User.Id
          LEFT JOIN ObjectString AS ObjectString_UserKey 
                                 ON ObjectString_UserKey.DescId = zc_ObjectString_User_Key() 
                                AND ObjectString_UserKey.ObjectId = Object_User.Id
     WHERE Object_User.Id = vbUserId;
     
     
     vbMovementSaleId := COALESCE((SELECT MovementId FROM MovementLinkMovement  
                                   WHERE MovementChildId = inMovementId 
                                     AND DescId = zc_MovementLinkMovement_TransportGoods()), 0);

     vbMovementDescId := COALESCE((SELECT Movement.DescId FROM Movement WHERE Movement.Id = vbMovementSaleId), 0);
     
     IF COALESCE (vbMovementDescId, 0) <> zc_Movement_Sale()
     THEN
       RAISE EXCEPTION 'Ошибка. Отправлять разрешено только ТТН по продаже покупателю. ';     
     END IF;
     
     vbJuricalId_car:= 
      (WITH tmpTransportGoods AS (SELECT * 
                                  FROM gpGet_Movement_TransportGoods (inMovementId       := inMovementId
                                                                    , inMovementId_Sale  := vbMovementSaleId
                                                                    , inOperDate         := NULL
                                                                    , inSession          := inSession
                                                                     )
                                 )
       SELECT tmpTransportGoods.JuricalId_car FROM tmpTransportGoods
      );

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

            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId
               , vbOperDate_find
               , vbFromId_find
               , vbToId_find
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


            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()


            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId -- MovementLinkObject_Contract.ObjectId

     WHERE Movement.Id = vbMovementSaleId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

   -- RAISE EXCEPTION 'Ошибка.<%>', vbJuricalId_car;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', 
                   (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), 
                   (SELECT InvNumber FROM Movement WHERE Id = vbMovementSaleId), 
                   (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementSaleId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', 
                   (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), 
                   (SELECT InvNumber FROM Movement WHERE Id = vbMovementSaleId), 
                   (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementSaleId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



     --
    OPEN Cursor1 FOR
       WITH tmpTransportGoods AS (SELECT * 
                                  FROM gpGet_Movement_TransportGoods (inMovementId       := inMovementId
                                                                    , inMovementId_Sale  := vbMovementSaleId
                                                                    , inOperDate         := NULL
                                                                    , inSession          := inSession
                                                                     )
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

                           WHERE MovementItem.MovementId = vbMovementSaleId
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

            , tmpOH_Juridical_Basis AS (SELECT *
                                        FROM ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails
                                        WHERE OH_JuridicalDetails.JuridicalId = zc_Juridical_Basis()
                                       AND vbOperDate_find >= OH_JuridicalDetails.StartDate
                                       AND vbOperDate_find <  OH_JuridicalDetails.EndDate
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

           , Object_From.ValueData AS FromName
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName

           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN OH_JuridicalDetails_From.FullName ELSE OH_JuridicalDetails_To.FullName END AS JuridicalName_Basis             --Замовник Алан

           , OH_JuridicalDetails_To.FullName   AS JuridicalName_To
           
           --, 'Новус Україна ТОВ'::tvarchar  AS JuridicalName_To
          
           , CASE WHEN vbDescId = zc_Movement_SendOnPrice() AND ObjectString_Unit_Address_to.ValueData <> '' AND ObjectString_Unit_Address_to.ValueData NOT ILIKE '% - O - %'
                    THEN ObjectString_Unit_Address_to.ValueData
                   ELSE OH_JuridicalDetails_To.JuridicalAddress
              END      :: TVarChar AS JuridicalAddress_To
              
           --, 'Україна, 04208, м. Київ, проспект Правди, 47'::tvarchar   AS JuridicalAddress_To

           , OH_JuridicalDetails_To.OKPO AS OKPO_To
           
           --, '36003603'::tvarchar AS OKPO_To

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
                 COALESCE(ObjectString_Unit_AddressEDIN_To.ValueData, OH_Juridical_Basis.JuridicalAddress)
             END   :: TVarChar            AS PartnerAddress_Unloading
             
           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn()
                  THEN View_Partner_Address.CityName END            AS PartnerCity_Unloading

           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn()
                  THEN View_Partner_Address.CityName END            AS PartnerCity_Unloading
             
           -- , 'Україна, #, м. Київ, пр. Академіка Палладіна,7-А' :: TVarChar            AS PartnerAddress_Unloading
             
           , CASE WHEN COALESCE (View_Partner_Address.PartnerId, 0) <> 0 
                  THEN TRIM (ObjectString_PostalCode.ValueData) 
                  ELSE ParseAddress_To.PostcodeCode END :: TVarChar                 AS PostcodeCode_To  
                  
           --, '04208':: TVarChar                 AS PostcodeCode_To 

           , CASE WHEN COALESCE (View_Partner_Address.PartnerId, 0) <> 0 
                  THEN TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = View_Partner_Address.CityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
                               || ' ' || COALESCE (View_Partner_Address.CityName, ''))
                  ELSE ParseAddress_To.CityName END :: TVarChar                 AS CityName_To  
                  
           --, 'м. Київ':: TVarChar                 AS CityName_To  
              
           , CASE WHEN COALESCE (View_Partner_Address.PartnerId, 0) <> 0 
                  THEN TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = View_Partner_Address.StreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
                           || ' ' || COALESCE (View_Partner_Address.StreetName, '')
                           || CASE WHEN COALESCE (ObjectString_HouseNumber.ValueData, '') <> ''
                                        THEN ' буд.' || COALESCE (ObjectString_HouseNumber.ValueData, '')
                                   ELSE ''
                              END
                           || CASE WHEN COALESCE (ObjectString_CaseNumber.ValueData, '') <> ''
                                        THEN ' корп.' || COALESCE (ObjectString_CaseNumber.ValueData, '')
                                   ELSE ''
                              END
                           || CASE WHEN COALESCE (ObjectString_RoomNumber.ValueData, '') <> ''
                                        THEN ' кв.' || COALESCE (ObjectString_RoomNumber.ValueData, '')
                                   ELSE ''
                              END)
                  ELSE ParseAddress_To.StreetName END :: TVarChar                 AS StreetName_To
                  
           --, 'проспект Правди, 47' :: TVarChar                 AS StreetName_To  
                       
           , CASE WHEN COALESCE (View_Partner_Address.PartnerId, 0) <> 0 
                  THEN TRIM (CASE WHEN View_Partner_Address.RegionName <> '' 
                                  THEN View_Partner_Address.RegionName   || ' обл. ' ELSE '' END
                               || CASE WHEN View_Partner_Address.ProvinceName  <> '' 
                                       THEN CASE WHEN View_Partner_Address.RegionName <> '' THEN ', ' ELSE '' END 
                                                   || View_Partner_Address.ProvinceName || ' р-н '  ELSE '' END)
                  ELSE ParseAddress_To.CountrySubDivisionName END :: TVarChar                 AS CountrySubDivisionName_To  
             
           /*, zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_GLNCode_To.ValueData
                                 , inGLNCodeRetail_partner := ObjectString_GLNCodeRetail_To.ValueData
                                 , inGLNCodeRetail         := ObjectString_Retail_GLNCode_To.ValueData
                                 , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode_To.ValueData
                                  ) AS  GLN_Unloading
                                                       */               
           , COALESCE(ObjectString_Unit_GLN_to.ValueData, ObjectString_GLNCode_To.ValueData, ObjectString_Juridical_GLNCode_To.ValueData) AS GLN_Unloading
           --, '9863576637923':: TVarChar  AS GLN_Unloading


           , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_GLNCode_To.ValueData
                                    , inGLNCodeJuridical_partner := ObjectString_GLNCodeJuridical_To.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode_To.ValueData
                                     ) AS GLN_To
                                     
           --, COALESCE(ObjectString_Unit_GLN_to.ValueData, ObjectString_Juridical_GLNCode_To.ValueData, ObjectString_GLNCode_To.ValueData) AS GLN_To
           --, '9863577638028':: TVarChar  AS GLN_To

           , COALESCE(ObjectString_Partner_KATOTTG_to.ValueData, '')  AS KATOTTG_Unloading
           
           --, 'UA80000000000093317' :: TVarChar  AS KATOTTG_Unloading
             
           , OH_JuridicalDetails_From.FullName AS JuridicalName_From

           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn()
                  THEN
                    OH_JuridicalDetails_From.JuridicalAddress
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

           , CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                  THEN TRIM (ObjectString_PostalCodeFrom.ValueData) 
                  ELSE ParseAddress_From.PostcodeCode END :: TVarChar        AS PostcodeCode_From  

           , CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                  THEN TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = View_Partner_AddressFrom.CityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
                               || ' ' || COALESCE (View_Partner_AddressFrom.CityName, ''))
                  ELSE ParseAddress_From.CityName END :: TVarChar        AS CityName_From  
              
           , CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                  THEN TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = View_Partner_AddressFrom.StreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
                               || ' ' || COALESCE (View_Partner_AddressFrom.StreetName, '')
                               || CASE WHEN COALESCE (ObjectString_HouseNumberFrom.ValueData, '') <> ''
                                            THEN ' буд.' || COALESCE (ObjectString_HouseNumberFrom.ValueData, '')
                                       ELSE ''
                                  END
                               || CASE WHEN COALESCE (ObjectString_CaseNumberFrom.ValueData, '') <> ''
                                            THEN ' корп.' || COALESCE (ObjectString_CaseNumberFrom.ValueData, '')
                                       ELSE ''
                                  END
                               || CASE WHEN COALESCE (ObjectString_RoomNumberFrom.ValueData, '') <> ''
                                            THEN ' кв.' || COALESCE (ObjectString_RoomNumberFrom.ValueData, '')
                                       ELSE ''
                                  END)
                  ELSE ParseAddress_From.StreetName END :: TVarChar        AS StreetName_From  
                       
           , CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                  THEN TRIM (CASE WHEN View_Partner_AddressFrom.RegionName <> '' 
                        THEN View_Partner_AddressFrom.RegionName   || ' обл. ' ELSE '' END
                               || CASE WHEN View_Partner_AddressFrom.ProvinceName  <> '' 
                                       THEN CASE WHEN View_Partner_AddressFrom.RegionName <> '' THEN ', ' ELSE '' END ||
                                                   View_Partner_AddressFrom.ProvinceName || ' р-н '  ELSE '' END)
                  ELSE ParseAddress_From.CountrySubDivisionName END :: TVarChar        AS CountrySubDivisionName_From  

           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_GLNCode_To.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_GLNCodeCorporate_To.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate_To.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_Juridical_GLNCode_From.ValueData
                                     )  AS GLN_from
                          
           --, COALESCE(ObjectString_GLNCode_From.ValueData, ObjectString_Juridical_GLNCode_From.ValueData)  AS GLN_from
           
           
           , COALESCE (ObjectString_Unit_AddressEDIN_Unit.ValueData, ObjectString_Unit_Address_from.ValueData, OH_JuridicalDetails_From.JuridicalAddress) AS Address_Unit
           
           , COALESCE(ObjectString_Unit_GLN_from.ValueData, ObjectString_GLNCode_From.ValueData, ObjectString_Juridical_GLNCode_From.ValueData)  AS GLN_Unit
           --, '9864232631453'::TVarChar AS GLN_Unit

           , Object_From.ValueData AS Name_Unit
           , COALESCE(ObjectString_Unit_KATOTTG_Unit.ValueData, '')  AS KATOTTG_Unit
           
           --, 'UA51100270010076757'::TVarChar AS KATOTTG_Unit

           , OH_JuridicalDetails_From.OKPO AS OKPO_From

           , COALESCE (OH_JuridicalDetails_car.FullName, CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() 
                                                              THEN OH_JuridicalDetails_From.FullName 
                                                              ELSE OH_JuridicalDetails_To.FullName END)                       :: TVarChar AS JuridicalName_car
           , COALESCE (OH_JuridicalDetails_car.JuridicalAddress, CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() 
                                                                      THEN OH_JuridicalDetails_From.JuridicalAddress 
                                                                      ELSE OH_JuridicalDetails_To.JuridicalAddress END) :: TVarChar AS JuridicalAddress_car
           , COALESCE (OH_JuridicalDetails_car.OKPO, CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() 
                                                          THEN OH_JuridicalDetails_From.OKPO 
                                                          ELSE OH_JuridicalDetails_To.OKPO END):: TVarChar AS OKPO_car
           
           , CASE WHEN COALESCE(OH_JuridicalDetails_car.JuridicalId, 0) = 0
                  THEN CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                            THEN TRIM (ObjectString_PostalCodeFrom.ValueData) 
                            ELSE ParseAddress_From.PostcodeCode END
                  ELSE ParseAddress_car.PostcodeCode END :: TVarChar  AS PostcodeCode_car                  

           , CASE WHEN COALESCE(OH_JuridicalDetails_car.JuridicalId, 0) = 0
                  THEN CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                            THEN TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = View_Partner_AddressFrom.CityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
                                         || ' ' || COALESCE (View_Partner_AddressFrom.CityName, ''))
                            ELSE ParseAddress_From.CityName END
                  ELSE ParseAddress_car.CityName END :: TVarChar  AS CityName_car
              
           , CASE WHEN COALESCE(OH_JuridicalDetails_car.JuridicalId, 0) = 0
                  THEN CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                            THEN TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = View_Partner_AddressFrom.StreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
                                         || ' ' || COALESCE (View_Partner_AddressFrom.StreetName, '')
                                         || CASE WHEN COALESCE (ObjectString_HouseNumberFrom.ValueData, '') <> ''
                                                      THEN ' буд.' || COALESCE (ObjectString_HouseNumberFrom.ValueData, '')
                                                 ELSE ''
                                            END
                                         || CASE WHEN COALESCE (ObjectString_CaseNumberFrom.ValueData, '') <> ''
                                                      THEN ' корп.' || COALESCE (ObjectString_CaseNumberFrom.ValueData, '')
                                                 ELSE ''
                                            END
                                         || CASE WHEN COALESCE (ObjectString_RoomNumberFrom.ValueData, '') <> ''
                                                      THEN ' кв.' || COALESCE (ObjectString_RoomNumberFrom.ValueData, '')
                                                 ELSE ''
                                            END)
                            ELSE ParseAddress_From.StreetName END
                  ELSE ParseAddress_car.StreetName END :: TVarChar  AS StreetName_car
                       
           , CASE WHEN COALESCE(OH_JuridicalDetails_car.JuridicalId, 0) = 0
                  THEN CASE WHEN COALESCE (View_Partner_AddressFrom.PartnerId, 0) <> 0 
                            THEN TRIM (CASE WHEN View_Partner_AddressFrom.RegionName <> '' 
                                  THEN View_Partner_AddressFrom.RegionName   || ' обл. ' ELSE '' END
                                         || CASE WHEN View_Partner_AddressFrom.ProvinceName  <> '' 
                                                 THEN CASE WHEN View_Partner_AddressFrom.RegionName <> '' THEN ', ' ELSE '' END ||
                                                             View_Partner_AddressFrom.ProvinceName || ' р-н '  ELSE '' END)
                            ELSE ParseAddress_From.CountrySubDivisionName END
                  ELSE ParseAddress_car.CountrySubDivisionName END :: TVarChar  AS CountrySubDivisionName_car

           , COALESCE (ObjectString_Juridical_GLNCode_Car.ValueData , 
             CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() 
                  THEN COALESCE(ObjectString_Juridical_GLNCode_From.ValueData)  
                  ELSE COALESCE(ObjectString_Juridical_GLNCode_To.ValueData)  END):: TVarChar AS GLN_car
           
           , tmpTransportGoods.InvNumber
           , COALESCE(MovementString_Uuid.ValueData, '')::TVarChar AS UuId
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate_OperDatePartner.ValueData, tmpTransportGoods.OperDate) ELSE tmpTransportGoods.OperDate END :: TDateTime AS OperDate
           , tmpTransportGoods.InvNumberMark

           , REPLACE(REPLACE(tmpTransportGoods.CarName, ' ', ''), '-', '')::TVarChar        AS CarName
           , Object_CarModel.ValueData       AS CarBrandName
           , Object_CarType.ValueData        AS CarModelName
           , Object_CarObjectColor.ValueData AS CarColorName
           , Object_CarProperty.ValueData    AS CarTypeName


           , REPLACE(REPLACE(tmpTransportGoods.CarTrailerName, ' ', ''), '-', '')::TVarChar AS CarTrailerName
           , Object_CarTrailerModel.ValueData       AS CarTrailerBrandName
           , Object_CarTrailerType.ValueData        AS CarTrailerModelName
           , Object_CarTrailerObjectColor.ValueData AS CarTrailerColorName
           , Object_CarTrailerProperty.ValueData    AS CarTrailerTypeName

           , tmpTransportGoods.PersonalDriverName
           , Upper(REPLACE(COALESCE (ObjectString_DriverCertificate_external.ValueData, ObjectString_DriverCertificate.ValueData), ' ', '')) :: TVarChar AS DriverCertificate
           , COALESCE (ObjectString_DriverINN_external.ValueData, ObjectString_DriverINN.ValueData) :: TVarChar AS DriverINN
           , ''::TVarChar                                 AS DriverTelephone
           , ''::TVarChar                                 AS DriverMobileTelephone
           , ''::TVarChar                                 AS DriverEmailURI

           , COALESCE (ObjectString_DriverGLN_external.ValueData, ObjectString_DriverGLN.ValueData) :: TVarChar AS GLN_Driver
           
           , CASE WHEN TRIM (COALESCE (tmpTransportGoods.MemberName1, '')) = '' THEN tmpTransportGoods.PersonalDriverName ELSE tmpTransportGoods.MemberName1 END :: TVarChar AS MemberName1
           , tmpTransportGoods.MemberName2
           , tmpTransportGoods.MemberName3
           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN tmpTransportGoods.MemberName4 ELSE tmpTransportGoods.MemberName7 END AS MemberName4  -- 4 и 7 меняем местами для возврата
           , tmpTransportGoods.MemberName5
           , tmpTransportGoods.MemberName6
           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN tmpTransportGoods.MemberName7 ELSE tmpTransportGoods.MemberName4 END AS MemberName7
           
           , ''::TVarChar                                 AS NotifiedPersonName
           , ''::TVarChar                                 AS NotifiedPersonINN
           , ''::TVarChar                                 AS NotifiedPersonTelephone
           , ''::TVarChar                                 AS NotifiedPersonMobileTelephone
           , ''::TVarChar                                 AS NotifiedPersonEmailURI

           , 'Петренко Євгеній Сергійович'::TVarChar      AS ConsignorPersonName
           , '3110604434'::TVarChar                       AS ConsignorPersonINN
           , ''::TVarChar                                 AS ConsignorPersonTelephone
           , '380673344579'::TVarChar                     AS ConsignorPersonMobileTelephone
           , ''::TVarChar                                 AS ConsignorPersonEmailURI

           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN tmpTransportGoods.MemberName7 ELSE tmpTransportGoods.MemberName4 END AS ConsigneePersonName
           , ''::TVarChar                                 AS ConsigneePersonINN
           , ''::TVarChar                                 AS ConsigneePersonTelephone
           , ''::TVarChar                                 AS ConsigneePersonMobileTelephone
           , ''::TVarChar                                 AS ConsigneePersonEmailURI
           
           , ''::TVarChar                                 AS NotifiedPersonName
           , ''::TVarChar                                 AS NotifiedPersonINN
           , ''::TVarChar                                 AS NotifiedPersonTelephone
           , ''::TVarChar                                 AS NotifiedPersonMobileTelephone
           , ''::TVarChar                                 AS NotifiedPersonEmailURI

           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN tmpTransportGoods.MemberName7 ELSE tmpTransportGoods.MemberName4 END AS DeliveryCN_PersonName
           , ''::TVarChar                                 AS DeliveryCN_PersonINN
           , ''::TVarChar                                 AS DeliveryCN_PersonTelephone
           , ''::TVarChar                                 AS DeliveryCN_PersonMobileTelephone
           , ''::TVarChar                                 AS DeliveryCN_PersonEmailURI
           
           , CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN tmpTransportGoods.MemberName4 ELSE tmpTransportGoods.MemberName7 END AS PickUpCZ_PersonName
           , ''::TVarChar                                 AS PickUpCZ_PersonINN
           , ''::TVarChar                                 AS PickUpCZ_PersonTelephone
           , ''::TVarChar                                 AS PickUpCZ_PersonMobileTelephone
           , ''::TVarChar                                 AS PickUpCZ_PersonEmailURI

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
          , 'Місце складання документу'  :: TVarChar   AS PlaceOf
          , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOfDescription
          /*, CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN Split_Part(COALESCE (ObjectString_PlaceOf.ValueData, ''), ',', 1)
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOfDescription*/

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

          , CASE WHEN (select tmpCar_param.Year from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) > 0
                     THEN  (select tmpCar_param.Year :: Integer from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar ELSE '' END ::TVarChar AS Year

        --, tmpCar_param.VIN  ::TVarChar AS VIN
          , (select tmpCar_param.VIN  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarId) :: TVarChar  AS VIN 
 
       -- , tmpCarTrailer_param.Length :: TVarChar  AS Length_tr
       -- , tmpCarTrailer_param.Width  :: TVarChar  AS Width_tr
       -- , tmpCarTrailer_param.Height :: TVarChar  AS Height_tr
          , (select tmpCar_param.Length from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId) :: TVarChar  AS Length_tr
          , (select tmpCar_param.Width  from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId) :: TVarChar  AS Width_tr
          , (select tmpCar_param.Height from tmpCar_param where tmpCar_param.CarId = tmpTransportGoods.CarTrailerId) :: TVarChar  AS Height_tr
          
          , CASE WHEN COALESCE (OH_JuridicalDetails_car.OKPO, CASE WHEN COALESCE (vbMovementDescId, 0) <> zc_Movement_ReturnIn() 
                                                                   THEN OH_JuridicalDetails_From.OKPO 
                                                                   ELSE OH_JuridicalDetails_To.OKPO END) = OH_JuridicalDetails_From.OKPO
                 THEN 'відрядний тариф'
                 WHEN TRIM(Object_Unit_City.ValueData) ILIKE TRIM(View_Partner_Address.CityName)
                   AND COALESCE(ObjectLink_Unit_City_CityKind.ChildObjectId, 0) = COALESCE(View_Partner_Address.CityKindId, 0)
                   AND COALESCE(ObjectLink_Unit_City_Region.ChildObjectId, 0)   = COALESCE(View_Partner_Address.RegionId, 0)
                 THEN 'внутрішньомістське'
                 ELSE 'міжміське' END::TVarChar                                         AS DeliveryInstructionsName
                 
          , vbUserSign AS UserSign
          , vbUserSeal AS UserSeal
          , vbUserKey  AS UserKey
          
       FROM Movement
            LEFT JOIN tmpTransportGoods ON tmpTransportGoods.MovementId_Sale = Movement.Id
            LEFT JOIN MovementString AS MovementString_Uuid
                                     ON MovementString_Uuid.MovementId =  tmpTransportGoods.Id
                                    AND MovementString_Uuid.DescId = zc_MovementString_Uuid()

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = tmpTransportGoods.PersonalDriverId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                   ON ObjectString_DriverCertificate.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()
            LEFT JOIN ObjectString AS ObjectString_DriverINN
                                   ON ObjectString_DriverINN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverINN.DescId = zc_ObjectString_Member_INN()
                                  AND COALESCE(ObjectString_DriverINN.ValueData) <> ''
            LEFT JOIN ObjectString AS ObjectString_DriverGLN
                                   ON ObjectString_DriverGLN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverGLN.DescId = zc_ObjectString_Member_GLN()
                                  AND COALESCE(ObjectString_DriverGLN.ValueData) <> ''

            LEFT JOIN ObjectString AS ObjectString_DriverCertificate_external
                                   ON ObjectString_DriverCertificate_external.ObjectId = tmpTransportGoods.PersonalDriverId
                                  AND ObjectString_DriverCertificate_external.DescId   = zc_ObjectString_MemberExternal_DriverCertificate()
            LEFT JOIN ObjectString AS ObjectString_DriverINN_external
                                   ON ObjectString_DriverINN_external.ObjectId = tmpTransportGoods.PersonalDriverId
                                  AND ObjectString_DriverINN_external.DescId   = zc_ObjectString_MemberExternal_INN()
            LEFT JOIN ObjectString AS ObjectString_DriverGLN_external
                                   ON ObjectString_DriverGLN_external.ObjectId = tmpTransportGoods.PersonalDriverId
                                  AND ObjectString_DriverGLN_external.DescId   = zc_ObjectString_MemberExternal_GLN()
                                  AND COALESCE(ObjectString_DriverGLN_external.ValueData) <> ''
                                  

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel                                            -- авто 
                                 ON ObjectLink_Car_CarModel.ObjectId = tmpTransportGoods.CarId
                                AND ObjectLink_Car_CarModel.DescId in (zc_ObjectLink_Car_CarModel(), zc_ObjectLink_CarExternal_CarModel())
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = tmpTransportGoods.CarId
                                AND ObjectLink_Car_CarType.DescId IN (zc_ObjectLink_Car_CarType(), zc_ObjectLink_CarExternal_CarType())
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_ObjectColor
                                 ON ObjectLink_Car_ObjectColor.ObjectId = tmpTransportGoods.CarId
                                AND ObjectLink_Car_ObjectColor.DescId IN (zc_ObjectLink_Car_ObjectColor(), zc_ObjectLink_CarExternal_ObjectColor())
            LEFT JOIN Object AS Object_CarObjectColor ON Object_CarObjectColor.Id = ObjectLink_Car_ObjectColor.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarProperty
                                 ON ObjectLink_Car_CarProperty.ObjectId = tmpTransportGoods.CarId
                                AND ObjectLink_Car_CarProperty.DescId IN (zc_ObjectLink_Car_CarProperty(), zc_ObjectLink_CarExternal_CarProperty())
            LEFT JOIN Object AS Object_CarProperty ON Object_CarProperty.Id = ObjectLink_Car_CarProperty.ChildObjectId

                                  
            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_CarModel                                            -- авто 
                                 ON ObjectLink_CarTrailer_CarModel.ObjectId = tmpTransportGoods.CarTrailerId
                                AND ObjectLink_CarTrailer_CarModel.DescId in (zc_ObjectLink_Car_CarModel(), zc_ObjectLink_CarExternal_CarModel())
            LEFT JOIN Object AS Object_CarTrailerModel ON Object_CarTrailerModel.Id = ObjectLink_CarTrailer_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarTrailerType
                                 ON ObjectLink_Car_CarTrailerType.ObjectId = tmpTransportGoods.CarTrailerId
                                AND ObjectLink_Car_CarTrailerType.DescId IN (zc_ObjectLink_Car_CarType(), zc_ObjectLink_CarExternal_CarType())
            LEFT JOIN Object AS Object_CarTrailerType ON Object_CarTrailerType.Id = ObjectLink_Car_CarTrailerType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_ObjectColor
                                 ON ObjectLink_CarTrailer_ObjectColor.ObjectId = tmpTransportGoods.CarTrailerId
                                AND ObjectLink_CarTrailer_ObjectColor.DescId IN (zc_ObjectLink_Car_ObjectColor(), zc_ObjectLink_CarExternal_ObjectColor())
            LEFT JOIN Object AS Object_CarTrailerObjectColor ON Object_CarTrailerObjectColor.Id = ObjectLink_CarTrailer_ObjectColor.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_CarProperty
                                 ON ObjectLink_CarTrailer_CarProperty.ObjectId = tmpTransportGoods.CarTrailerId
                                AND ObjectLink_CarTrailer_CarProperty.DescId IN (zc_ObjectLink_Car_CarProperty(), zc_ObjectLink_CarExternal_CarProperty())
            LEFT JOIN Object AS Object_CarTrailerProperty ON Object_CarTrailerProperty.Id = ObjectLink_CarTrailer_CarProperty.ChildObjectId
                                  

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

            LEFT JOIN ObjectString AS ObjectString_Unit_Address_from
                                   ON ObjectString_Unit_Address_from.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_Address_from.DescId = zc_ObjectString_Unit_Address()
                                --and 1=0
            LEFT JOIN ObjectString AS ObjectString_Unit_Address_to
                                   ON ObjectString_Unit_Address_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_Address_to.DescId = zc_ObjectString_Unit_Address()
                                --and 1=0
                                                                

            LEFT JOIN ObjectString AS ObjectString_Unit_GLN_from
                                   ON ObjectString_Unit_GLN_from.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_GLN_from.DescId = zc_ObjectString_Unit_GLN()
                                  AND COALESCE(ObjectString_Unit_GLN_from.ValueData) <> ''
            LEFT JOIN ObjectString AS ObjectString_Unit_GLN_to
                                   ON ObjectString_Unit_GLN_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_GLN_to.DescId = zc_ObjectString_Unit_GLN()
                                  AND COALESCE(ObjectString_Unit_GLN_to.ValueData) <> ''

            LEFT JOIN ObjectString AS ObjectString_Unit_KATOTTG_Unit
                                   ON ObjectString_Unit_KATOTTG_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_KATOTTG_Unit.DescId = zc_ObjectString_Unit_KATOTTG()
            LEFT JOIN ObjectString AS ObjectString_Partner_KATOTTG_to
                                   ON ObjectString_Partner_KATOTTG_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Partner_KATOTTG_to.DescId = zc_ObjectString_Partner_KATOTTG()

            LEFT JOIN ObjectString AS ObjectString_Unit_AddressEDIN_Unit
                                   ON ObjectString_Unit_AddressEDIN_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_AddressEDIN_Unit.DescId = zc_ObjectString_Unit_AddressEDIN()
                                  AND COALESCE(ObjectString_Unit_AddressEDIN_Unit.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_Unit_AddressEDIN_To
                                   ON ObjectString_Unit_AddressEDIN_To.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_AddressEDIN_To.DescId = zc_ObjectString_Unit_AddressEDIN()
                                  AND COALESCE(ObjectString_Unit_AddressEDIN_To.ValueData, '') <> ''

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)


            LEFT JOIN ObjectString AS ObjectString_PostalCode
                                   ON ObjectString_PostalCode.ObjectId = View_Partner_Address.StreetId
                                  AND ObjectString_PostalCode.DescId = zc_ObjectString_Street_PostalCode()

            LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                   ON ObjectString_HouseNumber.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()

            LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                   ON ObjectString_CaseNumber.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()

            LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                   ON ObjectString_RoomNumber.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()



            LEFT JOIN ObjectString AS ObjectString_GLNCode_To
                                   ON ObjectString_GLNCode_To.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_GLNCode_To.DescId = zc_ObjectString_Partner_GLNCode()
                                  AND COALESCE(ObjectString_GLNCode_To.ValueData) <> ''
            LEFT JOIN ObjectString AS ObjectString_GLNCodeJuridical_To
                                   ON ObjectString_GLNCodeJuridical_To.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_GLNCodeJuridical_To.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
                                  AND COALESCE(ObjectString_GLNCodeJuridical_To.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_GLNCodeCorporate_To
                                   ON ObjectString_GLNCodeCorporate_To.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_GLNCodeCorporate_To.DescId = zc_ObjectString_Partner_GLNCodeCorporate()
                                  AND COALESCE(ObjectString_GLNCodeJuridical_To.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_GLNCodeRetail_To
                                   ON ObjectString_GLNCodeRetail_To.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_GLNCodeRetail_To.DescId = zc_ObjectString_Partner_GLNCodeRetail()
                                  AND COALESCE(ObjectString_GLNCodeRetail_To.ValueData, '') <> ''

            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = Object_From.Id
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_AddressFrom ON View_Partner_AddressFrom.PartnerId = Object_From.Id

            LEFT JOIN ObjectString AS ObjectString_PostalCodeFrom
                                   ON ObjectString_PostalCodeFrom.ObjectId = View_Partner_AddressFrom.StreetId
                                  AND ObjectString_PostalCodeFrom.DescId = zc_ObjectString_Street_PostalCode()

            LEFT JOIN ObjectString AS ObjectString_HouseNumberFrom
                                   ON ObjectString_HouseNumberFrom.ObjectId = View_Partner_AddressFrom.PartnerId
                                  AND ObjectString_HouseNumberFrom.DescId = zc_ObjectString_Partner_HouseNumber()

            LEFT JOIN ObjectString AS ObjectString_CaseNumberFrom
                                   ON ObjectString_CaseNumberFrom.ObjectId = View_Partner_AddressFrom.PartnerId
                                  AND ObjectString_CaseNumberFrom.DescId = zc_ObjectString_Partner_CaseNumber()

            LEFT JOIN ObjectString AS ObjectString_RoomNumberFrom
                                   ON ObjectString_RoomNumberFrom.ObjectId = View_Partner_AddressFrom.PartnerId
                                  AND ObjectString_RoomNumberFrom.DescId = zc_ObjectString_Partner_RoomNumber()

            LEFT JOIN ObjectString AS ObjectString_GLNCode_From
                                   ON ObjectString_GLNCode_From.ObjectId = View_Partner_AddressFrom.PartnerId
                                  AND ObjectString_GLNCode_From.DescId = zc_ObjectString_Partner_GLNCode()
                                  AND COALESCE(ObjectString_GLNCode_From.ValueData) <> ''


            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN Object_From.Id ELSE Object_To.Id END
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf                           
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()

-- Contract
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())*/
            -- LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId

            LEFT JOIN t1
                   AS OH_JuridicalDetails_From
                   ON OH_JuridicalDetails_From.JuridicalId = vbFromId_find
                  AND vbOperDate_find >= OH_JuridicalDetails_From.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_From.EndDate                  
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_From                           
                                   ON ObjectString_Juridical_GLNCode_From.ObjectId = vbFromId_find
                                  AND ObjectString_Juridical_GLNCode_From.DescId = zc_ObjectString_Juridical_GLNCode()
                                  AND COALESCE(ObjectString_Juridical_GLNCode_From.ValueData) <> ''
            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_JuridicalDetails_From.JuridicalAddress) AS ParseAddress_From ON 1 = 1

            LEFT JOIN t2
                   AS OH_JuridicalDetails_To
                   ON OH_JuridicalDetails_To.JuridicalId = vbToId_find
                  AND vbOperDate_find >= OH_JuridicalDetails_To.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_To                           
                                   ON ObjectString_Juridical_GLNCode_To.ObjectId = vbToId_find
                                  AND ObjectString_Juridical_GLNCode_To.DescId = zc_ObjectString_Juridical_GLNCode()
                                  AND COALESCE(ObjectString_Juridical_GLNCode_To.ValueData) <> ''
            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_JuridicalDetails_To.JuridicalAddress) AS ParseAddress_To ON 1 = 1

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail_To
                                 ON ObjectLink_Juridical_Retail_To.ObjectId = ObjectString_Juridical_GLNCode_To.ObjectId
                                AND ObjectLink_Juridical_Retail_To.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode_To
                                   ON ObjectString_Retail_GLNCode_To.ObjectId = ObjectLink_Juridical_Retail_To.ChildObjectId
                                  AND ObjectString_Retail_GLNCode_To.DescId = zc_ObjectString_Retail_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate_To
                                   ON ObjectString_Retail_GLNCodeCorporate_To.ObjectId = ObjectLink_Juridical_Retail_To.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate_To.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN t3
                   AS OH_JuridicalDetails_car
                   ON OH_JuridicalDetails_car.JuridicalId = vbJuricalId_car
                  AND vbOperDate_find >= OH_JuridicalDetails_car.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_car.EndDate

            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_car
                                   ON ObjectString_Juridical_GLNCode_car.ObjectId = vbJuricalId_car
                                  AND ObjectString_Juridical_GLNCode_car.DescId = zc_ObjectString_Juridical_GLNCode()
                                  AND COALESCE(ObjectString_Juridical_GLNCode_car.ValueData) <> ''

            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_JuridicalDetails_car.JuridicalAddress) AS ParseAddress_car ON 1 = 1

            LEFT JOIN tmpOH_Juridical_Basis AS OH_Juridical_Basis ON vbMovementDescId = zc_Movement_ReturnIn()
            
            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_Juridical_Basis.JuridicalAddress) AS ParseAddress_Basis ON 1 = 1

            LEFT JOIN tmpPackage ON 1=1
            
            LEFT JOIN ObjectLink AS ObjectLink_Unit_City
                                 ON ObjectLink_Unit_City.ObjectId = CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() THEN Object_From.Id ELSE Object_To.Id END
                                AND ObjectLink_Unit_City.DescId = zc_ObjectLink_Unit_City()
            LEFT JOIN Object AS Object_Unit_City ON Object_Unit_City.Id = ObjectLink_Unit_City.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_City_CityKind
                                 ON ObjectLink_Unit_City_CityKind.ObjectId = Object_Unit_City.Id
                                AND ObjectLink_Unit_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_City_Region
                                 ON ObjectLink_Unit_City_Region.ObjectId = Object_Unit_City.Id
                                AND ObjectLink_Unit_City_Region.DescId = zc_ObjectLink_City_Region()


       WHERE Movement.Id = vbMovementSaleId
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
                 WHERE MovementItem.MovementId = vbMovementSaleId
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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.05.23                                                       *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_TransportGoods_EDIN_Send(inMovementId := 22086098 ,  inSession := '14610');

select * from gpSelect_Movement_TransportGoods_EDIN_Send(inMovementId := 27297491 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');