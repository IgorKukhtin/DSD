-- Function: gpSelect_Movement_TransportGoods_EDIN_Sign()

DROP FUNCTION IF EXISTS gpSelect_Movement_TransportGoods_EDIN_Sign (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportGoods_EDIN_Sign(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer

             , isSend_eTTN Boolean
             , UuId TVarChar
             
             , GLN_car TVarChar, GLN_from TVarChar, GLN_Unloading TVarChar, GLN_to TVarChar, GLN_Driver TVarChar
             , KATOTTG_Unloading TVarChar, KATOTTG_Unit TVarChar
             
             , UserSign TVarChar, UserSeal TVarChar, UserKey TVarChar

              )
AS
$BODY$
    DECLARE vbUserId Integer;

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

     -- Результат
     RETURN QUERY 
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
       SELECT tmpTransportGoods.Id
       
           , (COALESCE(MovementString_Uuid.ValueData, '') <> '')::Boolean AS isSend_eTTN
           , MovementString_Uuid.ValueData             AS Uuid
           
           , COALESCE (ObjectString_Juridical_GLNCode_Car.ValueData , 
             CASE WHEN vbMovementDescId <> zc_Movement_ReturnIn() 
                  THEN COALESCE(ObjectString_Unit_GLN_from.ValueData, ObjectString_GLNCode_From.ValueData, ObjectString_Juridical_GLNCode_From.ValueData)  
                  ELSE COALESCE(ObjectString_GLNCode_To.ValueData, ObjectString_Juridical_GLNCode_To.ValueData)  END)        :: TVarChar AS GLN_car
           , COALESCE(ObjectString_GLNCode_From.ValueData, ObjectString_Juridical_GLNCode_From.ValueData) :: TVarChar  AS GLN_from
           , COALESCE(ObjectString_Unit_GLN_to.ValueData, ObjectString_GLNCode_To.ValueData, ObjectString_Juridical_GLNCode_To.ValueData) :: TVarChar AS GLN_Unloading
           --, '9863576637923':: TVarChar  AS GLN_Unloading

           , COALESCE(ObjectString_Unit_GLN_to.ValueData, ObjectString_Juridical_GLNCode_To.ValueData, ObjectString_GLNCode_To.ValueData) :: TVarChar AS GLN_To
           --, '9863577638028':: TVarChar  AS GLN_To


           , COALESCE (ObjectString_DriverGLN_external.ValueData, ObjectString_DriverGLN.ValueData) :: TVarChar AS GLN_Driver
           
           , COALESCE(ObjectString_Unit_KATOTTG_To.ValueData, '') :: TVarChar  AS KATOTTG_Unloading
           
           --, 'UA80000000000093317' :: TVarChar  AS KATOTTG_Unloading

           , COALESCE(ObjectString_Unit_KATOTTG_Unit.ValueData, '') :: TVarChar  AS KATOTTG_Unit
           
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
            LEFT JOIN ObjectString AS ObjectString_DriverGLN
                                   ON ObjectString_DriverGLN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverGLN.DescId = zc_ObjectString_Member_GLN()

            LEFT JOIN ObjectString AS ObjectString_DriverCertificate_external
                                   ON ObjectString_DriverCertificate_external.ObjectId = tmpTransportGoods.PersonalDriverId
                                  AND ObjectString_DriverCertificate_external.DescId   = zc_ObjectString_MemberExternal_DriverCertificate()
            LEFT JOIN ObjectString AS ObjectString_DriverINN_external
                                   ON ObjectString_DriverINN_external.ObjectId = tmpTransportGoods.PersonalDriverId
                                  AND ObjectString_DriverINN_external.DescId   = zc_ObjectString_MemberExternal_INN()
            LEFT JOIN ObjectString AS ObjectString_DriverGLN_external
                                   ON ObjectString_DriverGLN_external.ObjectId = tmpTransportGoods.PersonalDriverId
                                  AND ObjectString_DriverGLN_external.DescId   = zc_ObjectString_MemberExternal_GLN()

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
            LEFT JOIN ObjectString AS ObjectString_Unit_GLN_to
                                   ON ObjectString_Unit_GLN_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_GLN_to.DescId = zc_ObjectString_Unit_GLN()

            LEFT JOIN ObjectString AS ObjectString_Unit_KATOTTG_Unit
                                   ON ObjectString_Unit_KATOTTG_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_KATOTTG_Unit.DescId = zc_ObjectString_Unit_KATOTTG()
            LEFT JOIN ObjectString AS ObjectString_Unit_KATOTTG_to
                                   ON ObjectString_Unit_KATOTTG_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_KATOTTG_to.DescId = zc_ObjectString_Unit_KATOTTG()

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
            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_JuridicalDetails_From.JuridicalAddress) AS ParseAddress_From ON 1 = 1

            LEFT JOIN t2
                   AS OH_JuridicalDetails_To
                   ON OH_JuridicalDetails_To.JuridicalId = vbToId_find
                  AND vbOperDate_find >= OH_JuridicalDetails_To.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_To                           
                                   ON ObjectString_Juridical_GLNCode_To.ObjectId = vbToId_find
                                  AND ObjectString_Juridical_GLNCode_To.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_JuridicalDetails_To.JuridicalAddress) AS ParseAddress_To ON 1 = 1

            LEFT JOIN t3
                   AS OH_JuridicalDetails_car
                   ON OH_JuridicalDetails_car.JuridicalId = vbJuricalId_car
                  AND vbOperDate_find >= OH_JuridicalDetails_car.StartDate
                  AND vbOperDate_find <  OH_JuridicalDetails_car.EndDate

            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_car
                                   ON ObjectString_Juridical_GLNCode_car.ObjectId = vbJuricalId_car
                                  AND ObjectString_Juridical_GLNCode_car.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_JuridicalDetails_car.JuridicalAddress) AS ParseAddress_car ON 1 = 1

            LEFT JOIN tmpOH_Juridical_Basis AS OH_Juridical_Basis ON vbMovementDescId = zc_Movement_ReturnIn()
            
            LEFT JOIN zfSelect_ParseAddress (inAddress := OH_Juridical_Basis.JuridicalAddress) AS ParseAddress_Basis ON 1 = 1

            LEFT JOIN tmpPackage ON 1=1

       WHERE Movement.Id = vbMovementSaleId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.05.23                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportGoods_EDIN_Sign(inMovementId := 22086098 ,  inSession := '14610');
