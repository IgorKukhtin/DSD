-- Function: gpSelect_Cash_Buyer()

DROP FUNCTION IF EXISTS gpSelect_Cash_Buyer(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_Buyer(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Phone TVarChar
             , Name TVarChar
             , DateBirth TVarChar, Sex TVarChar
             , Comment TVarChar 
             , LoyaltySMID Integer
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbLoyaltySaveMoneyId Integer;
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
   WITH tmpBuyer AS (SELECT Object_Buyer.Id                      AS Id
                          , Object_Buyer.ObjectCode              AS Code
                          , Object_Buyer.ValueData               AS Phone
                          , ObjectString_Buyer_Name.ValueData    AS Name
                          , Object_Buyer.isErased                AS isErased
                     FROM Object AS Object_Buyer
                          LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                                                 ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id
                                                AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()
                     WHERE Object_Buyer.DescId = zc_Object_Buyer())
   
   
      , tmpLoyaltySM AS (SELECT tmpBuyer.Id         AS BuyerID
                              , MovementItem.Id
                              , ROW_NUMBER()OVER(PARTITION BY tmpBuyer.Id ORDER BY tmpBuyer.Id, Movement.OperDate DESC) as ORD
                         FROM Movement

                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                            ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                           AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                                           AND MovementLinkObject_Retail.ObjectId = vbRetailId

                              INNER JOIN MovementItem AS MovementItem
                                                      ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE 
                                                             
                              INNER JOIN tmpBuyer ON tmpBuyer.Id = MovementItem.ObjectId

                                    
                         WHERE Movement.DescId = zc_Movement_LoyaltySaveMoney()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
                           AND COALESCE(MovementDate_EndPromo.ValueData, zc_DateEnd()) >= CURRENT_DATE
                         )   
   
   SELECT Object_Buyer.Id           
        , Object_Buyer.Code
        , Object_Buyer.Phone
        , Object_Buyer.Name
        , ObjectString_Buyer_DateBirth.ValueData AS DateBirth
        , ObjectString_Buyer_Sex.ValueData       AS Sex
        , ObjectString_Buyer_Comment.ValueData   AS Comment
        , tmpLoyaltySM.ID                      AS LoyaltySMID
        , Object_Buyer.isErased 
   FROM tmpBuyer AS Object_Buyer
        LEFT JOIN ObjectString AS ObjectString_Buyer_Comment
                               ON ObjectString_Buyer_Comment.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Comment.DescId = zc_ObjectString_Buyer_Comment()

        LEFT JOIN ObjectString AS ObjectString_Buyer_DateBirth
                               ON ObjectString_Buyer_DateBirth.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_DateBirth.DescId = zc_ObjectString_Buyer_DateBirth()
        LEFT JOIN ObjectString AS ObjectString_Buyer_Sex
                               ON ObjectString_Buyer_Sex.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Sex.DescId = zc_ObjectString_Buyer_Sex()
        LEFT JOIN tmpLoyaltySM ON tmpLoyaltySM.BuyerID = Object_Buyer.ID
                              AND tmpLoyaltySM.Ord = 1 
   ;

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Cash_Buyer(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.01.20                                                       *
 30.12.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Cash_Buyer('3')