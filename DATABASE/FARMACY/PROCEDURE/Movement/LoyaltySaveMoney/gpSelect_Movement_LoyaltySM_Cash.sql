-- Function: gpSelect_Movement_LoyaltySM_Cash()

DROP FUNCTION IF EXISTS gpSelect_Movement_LoyaltySM_Cash(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LoyaltySM_Cash(
    IN inBuyerID      Integer,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , OperDate       TDateTime
             , StartPromo     TDateTime
             , EndPromo       TDateTime
             , StartSale      TDateTime
             , EndSale        TDateTime
             , Coment         TVarChar
             , LoyaltySMID    Integer
             , SummaRemainder TFloat
             , BuyerID        Integer
             , BuyerName      TVarChar
             , BuyerPhone     TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

   RETURN QUERY
   SELECT Movement.Id
        , Movement.OperDate
        , MovementDate_StartPromo.ValueData                              AS StartPromo
        , MovementDate_EndPromo.ValueData                                AS EndPromo
        , MovementDate_StartSale.ValueData                               AS StartSale
        , MovementDate_EndSale.ValueData                                 AS EndSale
        , CASE WHEN COALESCE(MovementItem.Id, 0) = 0
               THEN 'Подключить к акции'
               ELSE 'Использовать акцию'  END::TVarChar AS Coment
        , MovementItem.Id
        , (MovementItem.Amount -
                          COALESCE(MIFloat_Summ.ValueData, 0))::TFloat   AS SummaRemainder
        , inBuyerID                                                      AS BuyerID
        , ObjectString_Buyer_Name.ValueData
        , Object_Buyer.ValueData 

   FROM Movement

        INNER JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement.Id
                               AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        INNER JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId = Movement.Id
                               AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
        INNER JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        INNER JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

        INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                      ON MovementLinkObject_Retail.MovementId = Movement.Id
                                     AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                     AND MovementLinkObject_Retail.ObjectId = vbRetailId

        LEFT JOIN MovementItem AS MovementItem
                               ON MovementItem.MovementId = Movement.Id
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                              AND MovementItem.ObjectId = inBuyerID

        LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                    ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                   AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                   
        LEFT JOIN Object AS Object_Buyer
                         ON Object_Buyer.ID = inBuyerID
        
        LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                               ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()

   WHERE Movement.DescId = zc_Movement_LoyaltySaveMoney()
     AND Movement.StatusId = zc_Enum_Status_Complete()
     AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
     AND (COALESCE(MovementDate_EndPromo.ValueData, zc_DateEnd()) >= CURRENT_DATE OR
          COALESCE(MovementDate_EndSale.ValueData, zc_DateEnd()) >= CURRENT_DATE
          AND ((MovementItem.Amount - COALESCE(MIFloat_Summ.ValueData, 0)) > 0))
   ORDER BY Movement.OperDate
   ;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_LoyaltySM_Cash(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.01.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_LoyaltySM_Cash(13093968 , '3')