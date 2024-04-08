-- Function: gpSelect_Movement_TransportGoods_EDIN()

DROP FUNCTION IF EXISTS gpSelect_Movement_TransportGoods_EDIN (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportGoods_EDIN(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InvNumberMark TVarChar
             , InvNumber_Full TVarChar
             , MovementId_Sale Integer, InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , InvNumberPartner_Sale TVarChar, OperDatePartner_Sale TDateTime
             , RouteName TVarChar
             , CarName TVarChar, CarBrandName TVarChar, CarModelName TVarChar, CarColorName TVarChar, CarTypeName TVarChar
             , CarTrailerName TVarChar, CarTrailerBrandName TVarChar, CarTrailerModelName TVarChar, CarTrailerColorName TVarChar, CarTrailerTypeName TVarChar
             , PersonalDriverName TVarChar
             , CarJuridicalName TVarChar
             , MemberName1 TVarChar
             , MemberName2 TVarChar
             , MemberName3 TVarChar
             , MemberName4 TVarChar
             , MemberName5 TVarChar
             , MemberName6 TVarChar
             , MemberName7 TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindName TVarChar
             , TotalCountSh TFloat, TotalCountKg TFloat, TotalSumm TFloat

             , ReestrKindName TVarChar
             , OperDate_reestr TDateTime, InvNumber_reestr TVarChar
             , StatusCode_reestr Integer, StatusName_reestr TVarChar
             , CarName_reestr TVarChar, CarModelName_reestr TVarChar, CarBrandName_reestr TVarChar
             , PersonalDriverName_reestr TVarChar, MemberName_reestr TVarChar
             , InvNumber_Transport_reestr TVarChar, OperDate_Transport_reestr TDateTime

             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , PersonalDriverName_Transport TVarChar
             , CarName_Transport TVarChar
             , isExternal Boolean
             
             , isSend_eTTN Boolean
             , Uuid TVarChar
             , CommentError TVarChar
             , isSignConsignor_eTTN Boolean
             , isSignCarrier_eTTN Boolean
             
             , PlaceOf TVarChar
             
             , GLN_car TVarChar, GLN_from TVarChar, GLN_Unit TVarChar, GLN_Unloading TVarChar, GLN_to TVarChar, GLN_Driver TVarChar
             , OKPO_car TVarChar, OKPO_From TVarChar, OKPO_To TVarChar
             , PersonalDriverId Integer, PersonalDriverItemName TVarChar,  DriverINN TVarChar, DriverCertificate  TVarChar 
             , KATOTTG_Unloading TVarChar, KATOTTG_Unit TVarChar
             , MemberSignConsignorName TVarChar, SignConsignorDate TDateTime, MemberSignCarrierName TVarChar, SignCarrierDate TDateTime
             , DeliveryInstructionsName TVarChar

             , CityFromName TVarChar
             , CityToName TVarChar
             , Address_Unit TVarChar

             , isWeCar Boolean


              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT Object_RoleAccessKeyDocument_View.AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY Object_RoleAccessKeyDocument_View.AccessKeyId
                         -- UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementString_InvNumberMark.ValueData  AS InvNumberMark
           , zfCalc_InvNumber_isErased (MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate, Movement.StatusId) AS InvNumber_Full

           , Movement_Sale.Id        AS MovementId_Sale
           , zfCalc_InvNumber_isErased_sh (Movement_Sale.InvNumber, Movement_Sale.StatusId) AS InvNumber_Sale
           , Movement_Sale.OperDate  AS OperDate_Sale
           , zfCalc_InvNumber_isErased_sh (MovementString_InvNumberPartner_Sale.ValueData, Movement_Sale.StatusId) AS InvNumberPartner_Sale
           , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale

           , Object_Route.ValueData          AS RouteName
           , Object_Car.ValueData            AS CarName
           , Object_CarModel.ValueData       AS CarBrandName
           , Object_CarType.ValueData        AS CarModelName
           , Object_CarObjectColor.ValueData AS CarColorName
           , Object_CarProperty.ValueData    AS CarTypeName
           
           , Object_CarTrailer.ValueData            AS CarTrailerName
           , Object_CarTrailerModel.ValueData       AS CarTrailerBrandName
           , Object_CarTrailerType.ValueData        AS CarTrailerModelName
           , Object_CarTrailerObjectColor.ValueData AS CarTrailerColorName
           , Object_CarTrailerProperty.ValueData    AS CarTrailerTypeName
            

           , Object_PersonalDriver.ValueData AS PersonalDriverName
           , COALESCE (OH_JuridicalDetails_car.FullName, CASE WHEN Movement_Sale.DescId <> zc_Movement_ReturnIn() 
                                                              THEN OH_JuridicalDetails_From.FullName 
                                                              ELSE OH_JuridicalDetails_To.FullName END):: TVarChar AS CarJuridicalName
              
           , Object_Member1.ValueData AS MemberName1
           , Object_Member2.ValueData AS MemberName2
           , Object_Member3.ValueData AS MemberName3
           , Object_Member4.ValueData AS MemberName4
           , Object_Member5.ValueData AS MemberName5
           , Object_Member6.ValueData AS MemberName6
           , Object_Member7.ValueData AS MemberName7
 
           , Object_From.Id                       AS FromId
           , Object_From.ValueData                AS FromName
           , Object_To.Id                         AS ToId
           , Object_To.ValueData                  AS ToName
           , Object_PaidKind.ValueData            AS PaidKindName
           , MovementFloat_TotalCountSh.ValueData AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData AS TotalCountKg
           , MovementFloat_TotalSumm.ValueData    AS TotalSumm

          --реестр
           , Object_ReestrKind.ValueData                AS ReestrKindName
           , Movement_reestr.OperDate                   AS OperDate_reestr
           , Movement_reestr.InvNumber                  AS InvNumber_reestr
           , Object_Status_reestr.ObjectCode            AS StatusCode_reestr
           , Object_Status_reestr.ValueData             AS StatusName_reestr

           , Object_Car_reestr.ValueData                AS CarName_reestr
           , COALESCE (Object_CarModel_reestr.ValueData,'') ::TVarChar AS CarModelName_reestr
           , COALESCE (Object_CarType_reestr.ValueData, '') ::TVarChar AS CarBrandName_reestr
           , Object_PersonalDriver_reestr.PersonalName  AS PersonalDriverName_reestr
           , Object_Member_reestr.ValueData             AS MemberName_reestr

           , zfCalc_InvNumber_isErased_sh (Movement_Transport_reestr.InvNumber, Movement_Transport_reestr.StatusId) AS InvNumber_Transport_reestr
           , Movement_Transport_reestr.OperDate         AS OperDate_Transport_reestr
           

           , Movement_Transport.Id                     AS MovementId_Transport
           , zfCalc_InvNumber_isErased_sh (Movement_Transport.InvNumber, Movement_Transport.StatusId) AS InvNumber_Transport
           , Movement_Transport.OperDate               AS OperDate_Transport
           , zfCalc_InvNumber_isErased ('', Movement_Transport.InvNumber, Movement_Transport.OperDate, Movement_Transport.StatusId) AS InvNumber_Transport_Full
           , Object_PersonalDriver_Transport.ValueData AS PersonalDriverName_Transport
           , Object_Car_Transport.ValueData            AS CarName_Transport
           
           , CASE WHEN Object_Car.DescId = zc_Object_Car() THEN FALSE ELSE TRUE END ::Boolean AS isExternal --свои (нет) или сторонние авто (Да)
           
           
           , (COALESCE(MovementString_Uuid.ValueData, '') <> '')::Boolean AS isSend_eTTN
           , MovementString_Uuid.ValueData             AS Uuid
           , MovementString_CommentError.ValueData     AS CommentError
           , (COALESCE(Object_MemberSignConsignor.ValueData, '') <> '')::Boolean AS isSignConsignor_eTTN
           , (COALESCE(Object_MemberSignCarrier.ValueData, '') <> '')::Boolean AS isSignCarrier_eTTN

           
           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOf
           
           , COALESCE (ObjectString_Juridical_GLNCode_Car.ValueData , 
             CASE WHEN Movement_Sale.DescId <> zc_Movement_ReturnIn() 
                  THEN COALESCE(ObjectString_Juridical_GLNCode_From.ValueData)  
                  ELSE COALESCE(ObjectString_Juridical_GLNCode_To.ValueData)  END):: TVarChar              AS GLN_car
                  
                  
           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_GLNCode_To.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_GLNCodeCorporate_To.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate_To.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_Juridical_GLNCode_From.ValueData
                                     )  AS GLN_from
                                               
           --, COALESCE(ObjectString_GLNCode_From.ValueData, ObjectString_Juridical_GLNCode_From.ValueData)  AS GLN_from
           , COALESCE(ObjectString_Unit_GLN_from.ValueData, ObjectString_GLNCode_From.ValueData, ObjectString_Juridical_GLNCode_From.ValueData)  AS GLN_Unit
           /*, zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_GLNCode_To.ValueData
                                 , inGLNCodeRetail_partner := ObjectString_GLNCodeRetail_To.ValueData
                                 , inGLNCodeRetail         := ObjectString_Retail_GLNCode_To.ValueData
                                 , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode_To.ValueData
                                  ) AS  GLN_Unloading*/
           , COALESCE(ObjectString_Unit_GLN_to.ValueData, ObjectString_GLNCode_To.ValueData, ObjectString_Juridical_GLNCode_To.ValueData) AS GLN_Unloading
           , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_GLNCode_To.ValueData
                                    , inGLNCodeJuridical_partner := ObjectString_GLNCodeJuridical_To.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode_To.ValueData
                                     ) AS GLN_To
           , COALESCE (ObjectString_DriverGLN_external.ValueData, ObjectString_DriverGLN.ValueData) :: TVarChar AS GLN_Driver
           
           , COALESCE (OH_JuridicalDetails_car.OKPO, CASE WHEN Movement_Sale.DescId <> zc_Movement_ReturnIn() 
                                                          THEN OH_JuridicalDetails_From.OKPO 
                                                          ELSE OH_JuridicalDetails_To.OKPO END):: TVarChar AS OKPO_car
                                                          
           , OH_JuridicalDetails_From.OKPO AS OKPO_From
           , OH_JuridicalDetails_To.OKPO AS OKPO_To
           
           , MovementLinkObject_PersonalDriver.ObjectId                                                         AS PersonalDriverId
           , ObjectDesc_PersonalDriver.ItemName                                                                 AS PersonalDriverItemName
           , COALESCE (ObjectString_DriverINN_external.ValueData, ObjectString_DriverINN.ValueData) :: TVarChar AS DriverINN
           , COALESCE (ObjectString_DriverCertificate_external.ValueData, ObjectString_DriverCertificate.ValueData) :: TVarChar AS DriverCertificate

           
           , COALESCE(ObjectString_Partner_KATOTTG_To.ValueData, ''):: TVarChar    AS KATOTTG_Unloading
           , COALESCE(ObjectString_Unit_KATOTTG_Unit.ValueData, ''):: TVarChar  AS KATOTTG_Unit

           , Object_MemberSignConsignor.ValueData                               AS MemberSignConsignorName
           , MovementDate_SignConsignor.ValueData                               AS SignConsignorDate
           , Object_MemberSignCarrier.ValueData                                 AS MemberSignCarrierName
           , MovementDate_SignCarrier.ValueData                                 AS SignCarrierDate
           
           , CASE WHEN COALESCE (OH_JuridicalDetails_car.OKPO, CASE WHEN Movement_Sale.DescId <> zc_Movement_ReturnIn() 
                                                                    THEN OH_JuridicalDetails_From.OKPO 
                                                                    ELSE OH_JuridicalDetails_To.OKPO END) = OH_JuridicalDetails_From.OKPO
                  THEN 'відрядний тариф'
                  WHEN TRIM(Object_Unit_City.ValueData) ILIKE TRIM(View_Partner_Address.CityName)
                   AND COALESCE(ObjectLink_Unit_City_CityKind.ChildObjectId, 0) = COALESCE(View_Partner_Address.CityKindId, 0)
                   AND COALESCE(ObjectLink_Unit_City_Region.ChildObjectId, 0)   = COALESCE(View_Partner_Address.RegionId, 0)
                  THEN 'внутрішньомістське'
                  ELSE 'міжміське' END::TVarChar                                         AS DeliveryInstructionsName
                  
           , Object_Unit_City.ValueData                                                  AS CityFromName
           , View_Partner_Address.CityName                                               AS CityToName
           , COALESCE (ObjectString_Unit_AddressEDIN_Unit.ValueData, 
                       ObjectString_Unit_Address_from.ValueData, 
                       OH_JuridicalDetails_From.JuridicalAddress)                        AS Address_Unit
                       
           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_GLNCode_To.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_GLNCodeCorporate_To.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate_To.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_Juridical_GLNCode_From.ValueData
                                     ) = 
             COALESCE (ObjectString_Juridical_GLNCode_Car.ValueData , 
             CASE WHEN Movement_Sale.DescId <> zc_Movement_ReturnIn() 
                  THEN COALESCE(ObjectString_Juridical_GLNCode_From.ValueData)  
                  ELSE COALESCE(ObjectString_Juridical_GLNCode_To.ValueData)  END)  AS isWeCar


       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_TransportGoods()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()
            LEFT JOIN MovementString AS MovementString_Uuid
                                     ON MovementString_Uuid.MovementId =  Movement.Id
                                    AND MovementString_Uuid.DescId = zc_MovementString_Uuid()
            LEFT JOIN MovementString AS MovementString_CommentError
                                     ON MovementString_CommentError.MovementId =  Movement.Id
                                    AND MovementString_CommentError.DescId = zc_MovementString_CommentError()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId



            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel                                            -- авто 
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId in (zc_ObjectLink_Car_CarModel(), zc_ObjectLink_CarExternal_CarModel())
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId IN (zc_ObjectLink_Car_CarType(), zc_ObjectLink_CarExternal_CarType())
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_ObjectColor
                                 ON ObjectLink_Car_ObjectColor.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_ObjectColor.DescId IN (zc_ObjectLink_Car_ObjectColor(), zc_ObjectLink_CarExternal_ObjectColor())
            LEFT JOIN Object AS Object_CarObjectColor ON Object_CarObjectColor.Id = ObjectLink_Car_ObjectColor.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarProperty
                                 ON ObjectLink_Car_CarProperty.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarProperty.DescId IN (zc_ObjectLink_Car_CarProperty(), zc_ObjectLink_CarExternal_CarProperty())
            LEFT JOIN Object AS Object_CarProperty ON Object_CarProperty.Id = ObjectLink_Car_CarProperty.ChildObjectId



            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarTrailer
                                         ON MovementLinkObject_CarTrailer.MovementId = Movement.Id
                                        AND MovementLinkObject_CarTrailer.DescId = zc_MovementLinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MovementLinkObject_CarTrailer.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_CarModel                                            -- авто 
                                 ON ObjectLink_CarTrailer_CarModel.ObjectId = Object_CarTrailer.Id
                                AND ObjectLink_CarTrailer_CarModel.DescId in (zc_ObjectLink_Car_CarModel(), zc_ObjectLink_CarExternal_CarModel())
            LEFT JOIN Object AS Object_CarTrailerModel ON Object_CarTrailerModel.Id = ObjectLink_CarTrailer_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarTrailerType
                                 ON ObjectLink_Car_CarTrailerType.ObjectId = Object_CarTrailer.Id
                                AND ObjectLink_Car_CarTrailerType.DescId IN (zc_ObjectLink_Car_CarType(), zc_ObjectLink_CarExternal_CarType())
            LEFT JOIN Object AS Object_CarTrailerType ON Object_CarTrailerType.Id = ObjectLink_Car_CarTrailerType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_ObjectColor
                                 ON ObjectLink_CarTrailer_ObjectColor.ObjectId = Object_CarTrailer.Id
                                AND ObjectLink_CarTrailer_ObjectColor.DescId IN (zc_ObjectLink_Car_ObjectColor(), zc_ObjectLink_CarExternal_ObjectColor())
            LEFT JOIN Object AS Object_CarTrailerObjectColor ON Object_CarTrailerObjectColor.Id = ObjectLink_CarTrailer_ObjectColor.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_CarProperty
                                 ON ObjectLink_CarTrailer_CarProperty.ObjectId = Object_CarTrailer.Id
                                AND ObjectLink_CarTrailer_CarProperty.DescId IN (zc_ObjectLink_Car_CarProperty(), zc_ObjectLink_CarExternal_CarProperty())
            LEFT JOIN Object AS Object_CarTrailerProperty ON Object_CarTrailerProperty.Id = ObjectLink_CarTrailer_CarProperty.ChildObjectId



            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_PersonalDriver ON ObjectDesc_PersonalDriver.id = Object_PersonalDriver.DescId

--          определяем юр.лицо
            LEFT JOIN ObjectLink AS ObjectLink_Car_Juridical                                                      -- юр.лицо авто
                                 ON ObjectLink_Car_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Juridical.DescId = zc_ObjectLink_Car_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_Juridical                                               -- юр.лицо авто стороннее
                                 ON ObjectLink_CarExternal_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_CarExternal_Juridical.DescId = zc_ObjectLink_CarExternal_Juridical()

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit                                                           -- подразделение авто
                                 ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id                 
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical                                                     -- юр.лицо подразделения авто
                             ON ObjectLink_Unit_Juridical.ObjectId =  ObjectLink_Car_Unit.ChildObjectId    
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract                                                      --  подразделение  Договор (перевыставление затрат)
                                 ON ObjectLink_Unit_Contract.ObjectId = ObjectLink_Car_Unit.ChildObjectId  
                                AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                 ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId 
                                AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

            LEFT JOIN Object AS Object_CarJuridical ON Object_CarJuridical.Id = COALESCE(ObjectLink_Car_Juridical.ChildObjectId, COALESCE(ObjectLink_CarExternal_Juridical.ChildObjectId, COALESCE(ObjectLink_Unit_Juridical.ChildObjectId, COALESCE(ObjectLink_Contract_Juridical.ChildObjectId,0))) )

--
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member1
                                         ON MovementLinkObject_Member1.MovementId = Movement.Id
                                        AND MovementLinkObject_Member1.DescId = zc_MovementLinkObject_Member1()
            LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = MovementLinkObject_Member1.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member2
                                         ON MovementLinkObject_Member2.MovementId = Movement.Id
                                        AND MovementLinkObject_Member2.DescId = zc_MovementLinkObject_Member2()
            LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = MovementLinkObject_Member2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member3
                                         ON MovementLinkObject_Member3.MovementId = Movement.Id
                                        AND MovementLinkObject_Member3.DescId = zc_MovementLinkObject_Member3()
            LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = MovementLinkObject_Member3.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member4
                                         ON MovementLinkObject_Member4.MovementId = Movement.Id
                                        AND MovementLinkObject_Member4.DescId = zc_MovementLinkObject_Member4()
            LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = MovementLinkObject_Member4.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member5
                                         ON MovementLinkObject_Member5.MovementId = Movement.Id
                                        AND MovementLinkObject_Member5.DescId = zc_MovementLinkObject_Member5()
            LEFT JOIN Object AS Object_Member5 ON Object_Member5.Id = MovementLinkObject_Member5.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member6
                                         ON MovementLinkObject_Member6.MovementId = Movement.Id
                                        AND MovementLinkObject_Member6.DescId = zc_MovementLinkObject_Member6()
            LEFT JOIN Object AS Object_Member6 ON Object_Member6.Id = MovementLinkObject_Member6.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member7
                                         ON MovementLinkObject_Member7.MovementId = Movement.Id
                                        AND MovementLinkObject_Member7.DescId = zc_MovementLinkObject_Member7()
            LEFT JOIN Object AS Object_Member7 ON Object_Member7.Id = MovementLinkObject_Member7.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN MovementItem AS MI_Transport
                                   ON MI_Transport.MovementId = Movement_Transport.Id
                                  AND MI_Transport.DescId = zc_MI_Master()
                                  AND MI_Transport.isErased = FALSE
                                  AND Movement_Transport.DescId = zc_Movement_TransportService()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver_Transport
                                         ON MovementLinkObject_PersonalDriver_Transport.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver_Transport.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver_Transport ON Object_PersonalDriver_Transport.Id = MovementLinkObject_PersonalDriver_Transport.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car_Transport
                                         ON MovementLinkObject_Car_Transport.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car_Transport.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car_Transport ON Object_Car_Transport.Id = MovementLinkObject_Car_Transport.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                             --AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Sale
                                     ON MovementString_InvNumberPartner_Sale.MovementId =  MovementLinkMovement_TransportGoods.MovementId
                                    AND MovementString_InvNumberPartner_Sale.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Sale
                                   ON MovementDate_OperDatePartner_Sale.MovementId =  MovementLinkMovement_TransportGoods.MovementId
                                  AND MovementDate_OperDatePartner_Sale.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            -- реестр
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                   AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_reestr 
                                   ON MI_reestr.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                  AND MI_reestr.isErased = FALSE
            LEFT JOIN Movement AS Movement_reestr ON Movement_reestr.Id = MI_reestr.MovementId
            LEFT JOIN Object AS Object_Status_reestr ON Object_Status_reestr.Id = Movement_reestr.StatusId
            
            LEFT JOIN MovementLinkObject AS MLO_Car_reestr
                                         ON MLO_Car_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_Car_reestr.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car_reestr ON Object_Car_reestr.Id = MLO_Car_reestr.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel_reestr ON ObjectLink_Car_CarModel_reestr.ObjectId = Object_Car_reestr.Id
                                                                  AND ObjectLink_Car_CarModel_reestr.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel_reestr ON Object_CarModel_reestr.Id = ObjectLink_Car_CarModel_reestr.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType_reestr
                                 ON ObjectLink_Car_CarType_reestr.ObjectId = Object_Car_reestr.Id
                                AND ObjectLink_Car_CarType_reestr.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType_reestr ON Object_CarType_reestr.Id = ObjectLink_Car_CarType_reestr.ChildObjectId

            LEFT JOIN MovementLinkObject AS MLO_PersonalDriver_reestr
                                         ON MLO_PersonalDriver_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_PersonalDriver_reestr.DescId     = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS Object_PersonalDriver_reestr ON Object_PersonalDriver_reestr.PersonalId = MLO_PersonalDriver_reestr.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Member_reestr
                                         ON MLO_Member_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_Member_reestr.DescId     = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member_reestr ON Object_Member_reestr.Id = MLO_Member_reestr.ObjectId
            -- инфа из П/л (реестр)
            LEFT JOIN MovementLinkMovement AS MLM_Transport_reestr
                                           ON MLM_Transport_reestr.MovementId = Movement_reestr.Id
                                          AND MLM_Transport_reestr.DescId     = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport_reestr ON Movement_Transport_reestr.Id = MLM_Transport_reestr.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_car
                                   ON ObjectString_Juridical_GLNCode_car.ObjectId = MI_Transport.ObjectId
                                  AND ObjectString_Juridical_GLNCode_car.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN Object_Partner_Address_View AS View_Partner_AddressFrom ON View_Partner_AddressFrom.PartnerId = Object_From.Id
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
            

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical_From
                                 ON ObjectLink_Partner_Juridical_From.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical_From.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId 
            

            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_From                           
                                   ON ObjectString_Juridical_GLNCode_From.ObjectId = 
                                      CASE WHEN Movement_Sale.DescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() 
                                           WHEN Movement_Sale.DescId = zc_Movement_ReturnIn() THEN COALESCE (ObjectLink_Partner_Juridical_From.ChildObjectId, Object_From.Id)
                                           ELSE COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
                                      END
                                  AND ObjectString_Juridical_GLNCode_From.DescId = zc_ObjectString_Juridical_GLNCode()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode_To                           
                       ON ObjectString_Juridical_GLNCode_To.ObjectId = 
                                  CASE WHEN Movement_Sale.DescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() 
                                       WHEN Movement_Sale.DescId = zc_Movement_ReturnIn() THEN COALESCE (View_Contract.JuridicalBasisId, Object_To.Id)
                                       ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                  END
                      AND ObjectString_Juridical_GLNCode_To.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail_To
                                 ON ObjectLink_Juridical_Retail_To.ObjectId = ObjectString_Juridical_GLNCode_To.ObjectId
                                AND ObjectLink_Juridical_Retail_To.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode_To
                                   ON ObjectString_Retail_GLNCode_To.ObjectId = ObjectLink_Juridical_Retail_To.ChildObjectId
                                  AND ObjectString_Retail_GLNCode_To.DescId = zc_ObjectString_Retail_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate_To
                                   ON ObjectString_Retail_GLNCodeCorporate_To.ObjectId = ObjectLink_Juridical_Retail_To.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate_To.DescId = zc_ObjectString_Retail_GLNCodeCorporate()


            LEFT JOIN ObjectString AS ObjectString_GLNCode_From
                                   ON ObjectString_GLNCode_From.ObjectId = View_Partner_AddressFrom.PartnerId
                                  AND ObjectString_GLNCode_From.DescId = zc_ObjectString_Partner_GLNCode()
                                  AND COALESCE(ObjectString_GLNCode_From.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_GLNCode_To
                                   ON ObjectString_GLNCode_To.ObjectId = View_Partner_Address.PartnerId
                                  AND ObjectString_GLNCode_To.DescId = zc_ObjectString_Partner_GLNCode()
                                  AND COALESCE(ObjectString_GLNCode_To.ValueData, '') <> ''
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

                                  
            LEFT JOIN ObjectString AS ObjectString_Unit_GLN_from
                                   ON ObjectString_Unit_GLN_from.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_GLN_from.DescId = zc_ObjectString_Unit_GLN()
                                  AND COALESCE(ObjectString_Unit_GLN_from.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_Unit_GLN_to
                                   ON ObjectString_Unit_GLN_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_GLN_to.DescId = zc_ObjectString_Unit_GLN()
                                  AND COALESCE(ObjectString_Unit_GLN_to.ValueData, '') <> ''

            LEFT JOIN ObjectString AS ObjectString_Unit_KATOTTG_Unit
                                   ON ObjectString_Unit_KATOTTG_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_KATOTTG_Unit.DescId = zc_ObjectString_Unit_KATOTTG()
            LEFT JOIN ObjectString AS ObjectString_Unit_AddressEDIN_Unit
                                   ON ObjectString_Unit_AddressEDIN_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_AddressEDIN_Unit.DescId = zc_ObjectString_Unit_AddressEDIN()
                                  AND COALESCE(ObjectString_Unit_AddressEDIN_Unit.ValueData, '') <> ''

            LEFT JOIN ObjectString AS ObjectString_Partner_KATOTTG_to
                                   ON ObjectString_Partner_KATOTTG_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Partner_KATOTTG_to.DescId = zc_ObjectString_Partner_KATOTTG()
            LEFT JOIN ObjectString AS ObjectString_Unit_AddressEDIN_To
                                   ON ObjectString_Unit_AddressEDIN_To.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_AddressEDIN_To.DescId = zc_ObjectString_Unit_AddressEDIN()
                                  AND COALESCE(ObjectString_Unit_AddressEDIN_To.ValueData, '') <> ''
                                  
            LEFT JOIN ObjectString AS ObjectString_DriverINN_external
                                   ON ObjectString_DriverINN_external.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                  AND ObjectString_DriverINN_external.DescId   = zc_ObjectString_MemberExternal_INN()
                                  AND COALESCE(ObjectString_DriverINN_external.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_DriverGLN_external
                                   ON ObjectString_DriverGLN_external.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                  AND ObjectString_DriverGLN_external.DescId   = zc_ObjectString_MemberExternal_GLN()
                                  AND COALESCE(ObjectString_DriverGLN_external.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_DriverCertificate_external
                                   ON ObjectString_DriverCertificate_external.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                  AND ObjectString_DriverCertificate_external.DescId   = zc_ObjectString_MemberExternal_DriverCertificate()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

            LEFT JOIN ObjectString AS ObjectString_DriverINN
                                   ON ObjectString_DriverINN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverINN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectString AS ObjectString_DriverGLN
                                   ON ObjectString_DriverGLN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverGLN.DescId = zc_ObjectString_Member_GLN()
                                  AND COALESCE(ObjectString_DriverGLN.ValueData, '') <> ''
            LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                   ON ObjectString_DriverCertificate.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = CASE WHEN Movement_Sale.DescId <> zc_Movement_ReturnIn() 
                                                                           THEN Object_From.Id ELSE Object_To.Id END
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf                           
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Unit_City
                                 ON ObjectLink_Unit_City.ObjectId = CASE WHEN Movement_Sale.DescId <> zc_Movement_ReturnIn() THEN Object_From.Id ELSE Object_To.Id END
                                AND ObjectLink_Unit_City.DescId = zc_ObjectLink_Unit_City()
            LEFT JOIN Object AS Object_Unit_City ON Object_Unit_City.Id = ObjectLink_Unit_City.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_City_CityKind
                                 ON ObjectLink_Unit_City_CityKind.ObjectId = Object_Unit_City.Id
                                AND ObjectLink_Unit_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_City_Region
                                 ON ObjectLink_Unit_City_Region.ObjectId = Object_Unit_City.Id
                                AND ObjectLink_Unit_City_Region.DescId = zc_ObjectLink_City_Region()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSignConsignor
                                         ON MovementLinkObject_MemberSignConsignor.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSignConsignor.DescId = zc_MovementLinkObject_MemberSignConsignor()
            LEFT JOIN Object AS Object_MemberSignConsignor ON Object_MemberSignConsignor.Id = MovementLinkObject_MemberSignConsignor.ObjectId
            LEFT JOIN MovementDate AS MovementDate_SignConsignor
                                   ON MovementDate_SignConsignor.MovementId =  Movement.Id
                                  AND MovementDate_SignConsignor.DescId = zc_MovementDate_SignConsignor()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSignCarrier
                                         ON MovementLinkObject_MemberSignCarrier.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSignCarrier.DescId = zc_MovementLinkObject_MemberSignCarrier()
            LEFT JOIN Object AS Object_MemberSignCarrier ON Object_MemberSignCarrier.Id = MovementLinkObject_MemberSignCarrier.ObjectId
            LEFT JOIN MovementDate AS MovementDate_SignCarrier
                                   ON MovementDate_SignCarrier.MovementId =  Movement.Id
                                  AND MovementDate_SignCarrier.DescId = zc_MovementDate_SignCarrier()
                                  

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                           ON OH_JuridicalDetails_From.JuridicalId  = 
                                      CASE WHEN Movement_Sale.DescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() 
                                           WHEN Movement_Sale.DescId = zc_Movement_ReturnIn() THEN COALESCE (ObjectLink_Partner_Juridical_From.ChildObjectId, Object_From.Id)
                                           ELSE COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
                                      END
                          AND Movement.OperDate >= OH_JuridicalDetails_From.StartDate
                          AND Movement.OperDate <  OH_JuridicalDetails_From.EndDate
                  

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                   ON OH_JuridicalDetails_To.JuridicalId = 
                                  CASE WHEN Movement_Sale.DescId = zc_Movement_SendOnPrice() THEN zc_Juridical_Basis() 
                                       WHEN Movement_Sale.DescId = zc_Movement_ReturnIn() THEN COALESCE (View_Contract.JuridicalBasisId, Object_To.Id)
                                       ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                  END
                  AND Movement.OperDate >= OH_JuridicalDetails_To.StartDate
                  AND Movement.OperDate <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_car
                   ON OH_JuridicalDetails_car.JuridicalId = MI_Transport.ObjectId
                  AND Movement.OperDate >= OH_JuridicalDetails_car.StartDate
                  AND Movement.OperDate <  OH_JuridicalDetails_car.EndDate     
                  
            LEFT JOIN ObjectString AS ObjectString_Unit_Address_from
                                   ON ObjectString_Unit_Address_from.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_Unit_Address_from.DescId = zc_ObjectString_Unit_Address()
                                --and 1=0
            LEFT JOIN ObjectString AS ObjectString_Unit_Address_to
                                   ON ObjectString_Unit_Address_to.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_Address_to.DescId = zc_ObjectString_Unit_Address()
                                --and 1=0
                                             
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_TransportGoods (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Шаблий О.В.
 06.07.23                                                                   *
 05.10.16         * add inJuridicalBasisId
 28.03.15                                        *
*/

-- тест
--  select * from gpSelect_Movement_TransportGoods_EDIN(instartdate := ('06.11.2023')::TDateTime , inenddate := ('13.11.2023')::TDateTime , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');