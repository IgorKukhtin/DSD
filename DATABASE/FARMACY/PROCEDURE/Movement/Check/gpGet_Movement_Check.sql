-- Function: gpGet_Movement_Check()

DROP FUNCTION IF EXISTS gpGet_Movement_Check (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Check(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , UnitId Integer, UnitName TVarChar
             , CashRegisterName TVarChar, PaidKindName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar, NotMCS Boolean
             , DiscountCardName TVarChar
             , BayerPhone TVarChar
             , InvNumberOrder TVarChar
             , ConfirmedKindName TVarChar
             , ConfirmedKindClientName TVarChar

             , OperDateSP TDateTime
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
             , MedicSPName TVarChar
             , Ambulance TVarChar
             , SPKindId   Integer, SPKindName TVarChar
             
             , InvNumber_PromoCode_Full TVarChar
             , GUID_PromoCode TVarChar
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Check());
     vbUserId := inSession;

     RETURN QUERY
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.StatusName
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.UnitId
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
           , Movement_Check.PaidKindName
           , Movement_Check.PaidTypeName
           , CASE WHEN Movement_Check.InvNumberOrder <> '' AND COALESCE (Movement_Check.CashMember, '') = '' THEN zc_Member_Site() ELSE Movement_Check.CashMember END :: TVarChar AS CashMember
           , Movement_Check.Bayer
           , Movement_Check.FiscalCheckNumber
           , Movement_Check.NotMCS
           , (Movement_Check.DiscountCardName || ' ' || COALESCE (Object_DiscountExternal.ValueData, '')) :: TVarChar AS DiscountCardName
           , Movement_Check.BayerPhone
           , Movement_Check.InvNumberOrder
           , Movement_Check.ConfirmedKindName
           , Movement_Check.ConfirmedKindClientName

           , Movement_Check.OperDateSP
           , Movement_Check.PartnerMedicalId
           , Movement_Check.PartnerMedicalName
           , Movement_Check.InvNumberSP
           , Movement_Check.MedicSPName
           , Movement_Check.Ambulance
           , Movement_Check.SPKindId
           , Movement_Check.SPKindName 

           , ('№ ' || Movement_PromoCode.InvNumber || ' от ' || Movement_PromoCode.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_PromoCode_Full
           , MIString_GUID.ValueData                 ::TVarChar AS GUID_PromoCode
           
        FROM Movement_Check_View AS Movement_Check
             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Movement_Check.DiscountCardId
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

             -- инфа из документа промо код
             LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                     ON MovementFloat_MovementItemId.MovementId = Movement_Check.Id
                                    AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
             LEFT JOIN MovementItem AS MI_PromoCode 
                                    ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                   AND MI_PromoCode.isErased = FALSE
             LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId
  
             LEFT JOIN MovementItemString AS MIString_GUID
                                          ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                         AND MIString_GUID.DescId = zc_MIString_GUID()
                                         
       WHERE Movement_Check.Id = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.12.17         * add PromoCode
 26.04.17         * add PartnerMedicalId
 07.04.17         *
 21.07.16         *
 23.05.15                         *                 
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check (inMovementId:= 1, inSession:= '9818')