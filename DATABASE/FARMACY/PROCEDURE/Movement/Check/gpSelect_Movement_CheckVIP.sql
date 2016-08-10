DROP FUNCTION IF EXISTS gpSelect_Movement_CheckVIP(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckVIP(
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Id Integer, 
  InvNumber TVarChar, 
  OperDate TDateTime, 
  StatusId Integer,
  StatusCode Integer, 
  TotalCount TFloat, 
  TotalSumm TFloat, 
  UnitName TVarChar, 
  CashRegisterName TVarChar,
  CashMemberId Integer,
  CashMember TVarCHar,
  Bayer TVarChar,
  DiscountExternalId Integer,
  DiscountExternalName TVarChar,
  DiscountCardNumber TVarChar
 )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY
       WITH tmpMov AS(SELECT Movement.Id
                      FROM 
                        Movement
                        INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                   ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE Movement.DescId = zc_Movement_Check()
                         AND (Movement.StatusId = zc_Enum_Status_UnComplete()
                             OR
                             (Movement.StatusId = zc_Enum_Status_Erased() AND inIsErased = TRUE)) 
                         AND MovementBoolean_Deferred.ValueData = True 
                         AND (MovementLinkObject_Unit.ObjectId = vbUnitId 
                              OR 
                              vbUnitId = 0))
       --tmpStatus AS (SELECT zc_Enum_Status_UnComplete() AS StatusId
       --                   UNION
       --                   SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE)
         
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , Movement.StatusId
            , Object_Status.ObjectCode                   AS StatusCode
            , MovementFloat_TotalCount.ValueData         AS TotalCount
            , MovementFloat_TotalSumm.ValueData          AS TotalSumm
            , Object_Unit.ValueData                      AS UnitName
            , Object_CashRegister.ValueData              AS CashRegisterName
            , MovementLinkObject_CheckMember.ObjectId    AS CashMemberId
            , Object_CashMember.ValueData                AS CashMember
	    , MovementString_Bayer.ValueData             AS Bayer
	    , Object_DiscountExternal.Id                 AS DiscountExternalId
	    , Object_DiscountExternal.ValueData          AS DiscountExternalName
	    , Object_DiscountCard.ValueData              AS DiscountCardNumber

       FROM tmpMov
            LEFT JOIN Movement ON Movement.Id = tmpMov.Id 
                               
                              
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

   	    INNER JOIN MovementBoolean AS MovementBoolean_Deferred
		                       ON MovementBoolean_Deferred.MovementId = Movement.Id
		                      AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
				      
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
  	    LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId
  	    
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
            LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                 ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

	    LEFT JOIN MovementString AS MovementString_Bayer
                                     ON MovementString_Bayer.MovementId = Movement.Id
                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckVIP (Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.08.16                                                                     * оптимизация
 07.04.16         * ушли от вьюхи
 12.09.2015                                                                   *[17:23] Кухтин Игорь: вторую кнопку закрыть и перекинуть их в запрос ВИП
 04.07.15                                                                     * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_CheckVIP (inIsErased := FALSE, inSession:= '3')
