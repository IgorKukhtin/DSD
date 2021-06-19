-- Function: gpSelect_Movement_Sale()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , TotalSummSale TFloat
             , TotalSummPrimeCost TFloat
             , UnitId Integer
             , UnitName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , PaidKindId Integer
             , PaidKindName TVarChar
             , Comment TVarChar
             , OperDateSP TDateTime
             , PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
             , MedicSPId   Integer
             , MedicSPName TVarChar
             , MemberSPId   Integer
             , MemberSPName TVarChar
             , GroupMemberSPName TVarChar
             , Address_MemberSP TVarChar
             , INN_MemberSP TVarChar
             , Passport_MemberSP TVarChar
             , SPKindId   Integer
             , SPKindName TVarChar
             , isSP Boolean
             , InvNumber_Invoice_Full TVarChar
             , isDeferred Boolean
             , isNP Boolean

             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitId Integer;   
BEGIN

     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     -- Ограничение - если роль Кассир аптеки
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 308121 AND UserId = vbUserId)
     THEN
         vbUnitId:= zfConvert_StringToNumber (lpGet_DefaultValue ('zc_Object_Unit', vbUserId));
     ELSE
         vbUnitId:= 0;
     END IF;


     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
    , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND (ObjectLink_Unit_Juridical.ObjectId = vbUnitId OR vbUnitId = 0)
                    )
        -- Результат
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.StatusCode
          , Movement_Sale.StatusName
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummSale
          , Movement_Sale.TotalSummPrimeCost
          , Movement_Sale.UnitId
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalId
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindId
          , Movement_Sale.PaidKindName
          , Movement_Sale.Comment

          , Movement_Sale.OperDateSP
          , Movement_Sale.PartnerMedicalName
          , Movement_Sale.InvNumberSP
          , Movement_Sale.MedicSPid
          , Movement_Sale.MedicSPName
          , Movement_Sale.MemberSPId
          , Movement_Sale.MemberSPName 
          , Movement_Sale.GroupMemberSPName

          , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address_MemberSP
          , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN_MemberSP
          , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport_MemberSP
          
          , Movement_Sale.SPKindId
          , Movement_Sale.SPKindName 

          , CASE WHEN COALESCE (Movement_Sale.PartnerMedicalName,'') <> '' OR
                      COALESCE (Movement_Sale.InvNumberSP,'') <> '' OR
                      COALESCE (Movement_Sale.MedicSPName,'') <> '' OR
                      COALESCE (Movement_Sale.MemberSPName,'') <> ''
                 THEN TRUE
                 ELSE FALSE
            END ::Boolean AS isSP

          , ('№ ' || Movement_Invoice.InvNumber || ' от ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full 
          , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
          , COALESCE (MovementBoolean_NP.ValueData, FALSE) ::Boolean  AS isNP

          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate
          , Object_Update.ValueData              AS UpdateName
          , MovementDate_Update.ValueData        AS UpdateDate
        FROM
            tmpUnit
            LEFT JOIN Movement_Sale_View AS Movement_Sale ON Movement_Sale.UnitId = tmpUnit.UnitId
                                        AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
            INNER JOIN tmpStatus ON Movement_Sale.StatusId = tmpStatus.StatusId
            
            LEFT JOIN MovementLinkMovement AS MLM_Child
                                           ON MLM_Child.MovementId = Movement_Sale.Id
                                          AND MLM_Child.descId = zc_MovementLinkMovement_Child()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Sale.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement_Sale.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_Sale.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement_Sale.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId 
            
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
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 31.07.19                                                                                      *
 05.06.18         *
 01.02.18         *
 22.03.17         *
 08.02.17         * add SP
 04.05.16         * 
 13.10.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());