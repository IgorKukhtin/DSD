-- Function:  gpSelect_Check_eSputnikSMSParams

DROP FUNCTION IF EXISTS gpSelect_Check_eSputnikSMSParams (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Check_eSputnikSMSParams (
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar
)
RETURNS TABLE (isSend        Boolean
             , UserName      TVarChar
             , Password      TVarChar
             , FromName      TVarChar
             , BayerPhone    TVarChar
             , SMSText       TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- для остальных...
   RETURN QUERY
   SELECT COALESCE(MovementString_InvNumberOrder.ValueData, '') <> '' AND 
          (CURRENT_TIME >= '18:00:00' OR date_part('isodow', CURRENT_DATE)::Integer in (6, 7))
        , Params.UserName
        , Params.Password
        , 'Neboley'::TVarChar AS FromName
        , REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
          COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
          MovementString_BayerPhone.ValueData), '+', ''), '(', ''), ')', ''), '-', ''), ' ', '')::TVarChar     AS BayerPhone
        , ('ВІДМОВА!'||Chr(13)||'Аптека не підтвердила замовлення №'||COALESCE(MovementString_InvNumberOrder.ValueData, ''))::TVarChar AS SMSText
   FROM gpSelect_eSputnikContactsMessages_Params(inSession) AS Params
   
        LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                 ON MovementString_InvNumberOrder.MovementId = inMovementId
                                AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

        LEFT JOIN MovementString AS MovementString_BayerPhone
                                 ON MovementString_BayerPhone.MovementId = inMovementId
                                AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                     ON MovementLinkObject_BuyerForSite.MovementId = inMovementId
                                    AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
        LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
        LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                               ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                              AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
                                
   ;
   

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.09.22                                                       *

*/

-- тест
-- 
select * from gpSelect_Check_eSputnikSMSParams (30771515, '3');