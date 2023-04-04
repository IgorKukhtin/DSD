-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , TotalSummPrimeCost TFloat
             , UnitId Integer
             , UnitName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , PaidKindId Integer
             , PaidKindName TVarChar
             , Comment TVarChar

             , OperDateSP TDateTime
             , PartnerMedicalId Integer
             , PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
             , MedicSPId   Integer
             , MedicSPName TVarChar
             , MemberSPId   Integer
             , MemberSPName TVarChar
             , Address_MemberSP TVarChar
             , INN_MemberSP TVarChar
             , Passport_MemberSP TVarChar
             , GroupMemberSPId Integer
             , GroupMemberSPName TVarChar
             , InsuranceCompaniesId Integer
             , InsuranceCompaniesName TVarChar
             , MemberICId Integer
             , MemberICName TVarChar
             , InsuranceCardNumber TVarChar
             , SPKindId   Integer
             , SPKindName TVarChar
             , isDeferred Boolean
             , isNP Boolean
             , MedicSPForm TVarChar 
             , ChangePercent TFloat
             , CashRegisterName TVarChar, ZReport Integer, FiscalCheckNumber TVarChar, TotalSummPayAdd TFloat
             )
AS
$BODY$
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    -- Для этих точек при создании накладной продажи  автоматом было прописано их подразделение, соотв. Мед.учреждение, Вид соцпроекта»- постановление 1303, «Форма оплаты» - БН.
    -- 1 - АП_2 ул_Бр.Трофимовых (Большая Диевская)_111 КЗДЦПМСП_5 (Шапиро ИА) (183289) и только с Комунальний заклад "ДЦПМСД №5" (3751525)
    -- 2 - Аптека_3 ул_Коммунаровская (Ю. Кондратюка)_1   (Шапиро ИА)          (183294) и только с Комунальний заклад "ДЦПМСД №5" (3751525)
    -- 3 - Аптека_2 шоссе_Донецкое_3 (АСНБ-4)                                  (377605) и только с Комунальний заклад "ДЦПМСД №11"(4212299)

    -- определяем подразделение ()
    vbUnitId := COALESCE ((SELECT tmp.UnitId FROM gpGet_UserUnit(inSession) AS tmp), 0);
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime                          AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              	             AS StatusName
          , 0::TFloat                                        AS TotalCount
          , 0::TFloat                                        AS TotalSumm
          , 0::TFloat                                        AS TotalSummPrimeCost
          , COALESCE (Object_Unit.Id, NULL)       ::Integer  AS UnitId
          , COALESCE (Object_Unit.ValueData, NULL)::TVarChar AS UnitName
          , NULL::Integer                                    AS JuridicalId
          , NULL::TVarChar                                   AS JuridicalName
          , COALESCE (Object_PaidKind.Id, NULL)        ::Integer  AS PaidKindId
          , COALESCE (Object_PaidKind.ValueData, NULL) ::TVarChar AS PaidKindName
          , NULL::TVarChar                                   AS Comment

          , (CURRENT_DATE + interval '1 day')                ::TDateTime AS OperDateSP
          , COALESCE (Object_PartnerMedical.Id, NULL)        ::Integer   AS PartnerMedicalId
          , COALESCE (Object_PartnerMedical.ValueData, NULL) ::TVarChar  AS PartnerMedicalName
          , NULL::TVarChar                                   AS InvNumberSP
          , NULL::Integer                                    AS MedicSPId
          , NULL::TVarChar                                   AS MedicSPName
          , NULL::Integer                                    AS MemberSPId
          , NULL::TVarChar                                   AS MemberSPName
          , NULL  :: TVarChar                                AS Address_MemberSP
          , NULL  :: TVarChar                                AS INN_MemberSP
          , NULL  :: TVarChar                                AS Passport_MemberSP

          , NULL::Integer                                    AS GroupMemberSPId
          , NULL::TVarChar                                   AS GroupMemberSPName

          , NULL::Integer                                    AS InsuranceCompaniesId
          , NULL::TVarChar                                   AS InsuranceCompaniesName
          , NULL::Integer                                    AS MemberICId
          , NULL::TVarChar                                   AS MemberICName
          , NULL::TVarChar                                   AS InsuranceCardNumber

          , COALESCE (Object_SPKind.Id, NULL)        ::Integer   AS SPKindId
          , COALESCE (Object_SPKind.ValueData, NULL) ::TVarChar  AS SPKindName 
          , FALSE::Boolean                                       AS isDeferred
          , CASE WHEN inSession IN ('8720522', '374175', '19085095') THEN TRUE ELSE FALSE END::Boolean AS isNP
          , 'TMedicSP_ObjectForm' ::TVarChar                     AS MedicSPForm
          , NULL::TFloat                                         AS ChangePercent
          , ''::TVarChar                                     AS CashRegisterName
          , Null::Integer                                    AS ZReport
          , ''::TVarChar                                     AS FiscalCheckNumber
          , Null::TFloat                                     AS TotalSummPayAdd

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId
            
            LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                                 ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id 
                                AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
                                AND inSession NOT IN ('374175', '19085095')
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId

            LEFT JOIN Object AS Object_SPKind   ON Object_SPKind.Id   = zc_Enum_SPKind_1303()        AND COALESCE (Object_PartnerMedical.Id, 0) <> 0 AND inSession  NOT IN ('374175', '19085095')
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() AND COALESCE (Object_PartnerMedical.Id, 0) <> 0 AND inSession  NOT IN ('374175', '19085095')

          /*LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = CASE WHEN vbUnitId IN (183289, 183294, 377605) THEN vbUnitId ELSE 0 END    --, 183292
            LEFT JOIN Object AS Object_SPKind   ON Object_SPKind.Id   = CASE WHEN vbUnitId IN (183289, 183294, 377605) THEN zc_Enum_SPKind_1303() ELSE 0 END
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CASE WHEN vbUnitId IN (183289, 183294, 377605) THEN zc_Enum_PaidKind_FirstForm() ELSE 0 END
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = CASE WHEN vbUnitId IN (183289, 183294) THEN 3751525  --3690583 /*тест*/  --
                                                                                         WHEN vbUnitId = 377605 THEN 4212299
                                                                                         ELSE 0
                                                                                    END*/
        
        ;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.StatusCode
          , Movement_Sale.StatusName
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummPrimeCost
          , Movement_Sale.UnitId
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalId
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindId
          , Movement_Sale.PaidKindName
          , Movement_Sale.Comment

          , COALESCE(Movement_Sale.OperDateSP, Movement_Sale.OperDate + interval '1 day' ) :: TDateTime AS OperDateSP
          , Movement_Sale.PartnerMedicalId
          , Movement_Sale.PartnerMedicalName
          , Movement_Sale.InvNumberSP
          , Movement_Sale.MedicSPid
          , Movement_Sale.MedicSPName
          , Movement_Sale.MemberSPId
          , Movement_Sale.MemberSPName

          , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address_MemberSP
          , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN_MemberSP
          , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport_MemberSP

          , Movement_Sale.GroupMemberSPId
          , Movement_Sale.GroupMemberSPName

          , Object_InsuranceCompanies.Id                                 AS InsuranceCompaniesId
          , Object_InsuranceCompanies.ValueData                          AS InsuranceCompaniesName
          , Object_MemberIC.Id                                           AS MemberICId
          , Object_MemberIC.ValueData                                    AS MemberICName
          , ObjectString_InsuranceCardNumber.ValueData                   AS InsuranceCardNumber

          , Movement_Sale.SPKindId
          , Movement_Sale.SPKindName 
          , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
          , COALESCE (MovementBoolean_NP.ValueData, FALSE) ::Boolean  AS isNP
          , CASE WHEN COALESCE(Movement_Sale.JuridicalId, 0) = 1152890 
                 THEN 'TMedicSP_ICForm' ELSE 'TMedicSP_ObjectForm' END ::TVarChar  AS MedicSPForm
                 
          , CASE WHEN COALESCE(Object_InsuranceCompanies.Id, 0) > 0 
                 THEN COALESCE(MovementFloat_ChangePercent.ValueData, 100)
                 ELSE NULL END :: TFloat                                 AS ChangePercent

          , Object_CashRegister.ValueData                    AS CashRegisterName
          , MovementFloat_ZReport.ValueData::Integer         AS ZReport
          , MovementString_FiscalCheckNumber.ValueData       AS FiscalCheckNumber
          , MovementFloat_TotalSummPayAdd.ValueData          AS TotalSummPayAdd
          
        FROM Movement_Sale_View AS Movement_Sale

         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Movement_Sale.MemberSPId
                               AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
         LEFT JOIN ObjectString AS ObjectString_INN
                                ON ObjectString_INN.ObjectId = Movement_Sale.MemberSPId
                               AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
         LEFT JOIN ObjectString AS ObjectString_Passport
                                ON ObjectString_Passport.ObjectId = Movement_Sale.MemberSPId
                               AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
         LEFT JOIN MovementBoolean AS MovementBoolean_NP
                                   ON MovementBoolean_NP.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_NP.DescId = zc_MovementBoolean_NP()
         LEFT JOIN MovementLinkObject AS MLO_InsuranceCompanies
                                      ON MLO_InsuranceCompanies.MovementId = Movement_Sale.Id
                                     AND MLO_InsuranceCompanies.DescId = zc_MovementLinkObject_InsuranceCompanies()
         LEFT JOIN Object AS Object_InsuranceCompanies ON Object_InsuranceCompanies.Id = MLO_InsuranceCompanies.ObjectId  

         LEFT JOIN MovementLinkObject AS MLO_MemberIC
                                      ON MLO_MemberIC.MovementId = Movement_Sale.Id
                                     AND MLO_MemberIC.DescId = zc_MovementLinkObject_MemberIC()
         LEFT JOIN Object AS Object_MemberIC ON Object_MemberIC.Id = MLO_MemberIC.ObjectId  
         LEFT JOIN ObjectString AS ObjectString_InsuranceCardNumber
                                ON ObjectString_InsuranceCardNumber.ObjectId = Object_MemberIC.Id
                               AND ObjectString_InsuranceCardNumber.DescId = zc_ObjectString_MemberIC_InsuranceCardNumber() 
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId = Movement_Sale.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                      ON MovementLinkObject_CashRegister.MovementId = Movement_Sale.Id
                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
         LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
 
         LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                 ON MovementFloat_ZReport.MovementId =  Movement_Sale.Id
                                AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()
         LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                  ON MovementString_FiscalCheckNumber.MovementId = Movement_Sale.ID
                                 AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                 ON MovementFloat_TotalSummPayAdd.MovementId =  Movement_Sale.Id
                                AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()
                                
        WHERE Movement_Sale.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 31.07.19                                                                                     *
 15.01.19         *
 05.06.18         *
 08.02.17         * add SP
 15.09.16         *
 13.10.15                                                                        *
*/

-- 
select * from gpGet_Movement_Sale(inMovementId := 30678777 , inOperDate := ('03.04.2023')::TDateTime ,  inSession := '3');