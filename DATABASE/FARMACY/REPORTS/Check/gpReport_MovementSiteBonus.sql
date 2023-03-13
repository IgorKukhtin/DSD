--  gpReport_MovementSiteBonus()

DROP FUNCTION IF EXISTS gpReport_MovementSiteBonus (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementSiteBonus(
    IN inShowAll       Boolean  , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (BuyerForSiteId         Integer
             , BuyerForSiteCode       Integer
             , BuyerForSiteName       TVarChar
             , Phone                  TVarChar
             , Bonus                  TFloat
             , Bonus_Used             TFloat
             , MobileDiscount         TFloat
             , MobileDiscount_Compl   TFloat
             , Bonus_Balance          TFloat
             , Bonus_Add              TFloat
             , Bonus_Added            TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF inShowAll = TRUE
   THEN
   
       -- Результат
     RETURN QUERY
     SELECT Object_BuyerForSite.Id
          , Object_BuyerForSite.ObjectCode
          , Object_BuyerForSite.ValueData
          , ObjectString_BuyerForSite_Phone.ValueData            AS Phone
          , SUM(MovementSiteBonus.Bonus)::TFloat                 AS Bonus
          , SUM(MovementSiteBonus.Bonus_Used)::TFloat            AS Bonus_Used
          , SUM(MovementFloat_MobileDiscount.ValueData)::TFloat  AS MobileDiscount
          , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN MovementFloat_MobileDiscount.ValueData END)::TFloat  AS MobileDiscount_Compl

          , ObjectString_BuyerForSite_Bonus.ValueData            AS Bonus_Balance
          , ObjectString_BuyerForSite_BonusAdd.ValueData         AS Bonus_Add
          , ObjectString_BuyerForSite_BonusAdded.ValueData       AS Bonus_Added
     FROM Object AS Object_BuyerForSite 
     
          LEFT JOIN MovementSiteBonus ON MovementSiteBonus.BuyerForSiteCode = Object_BuyerForSite.ObjectCode
                          
          LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                 ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

          LEFT JOIN Movement ON Movement.Id = MovementSiteBonus.MovementId
          
          LEFT JOIN MovementFloat AS MovementFloat_MobileDiscount
                                  ON MovementFloat_MobileDiscount.MovementId =  Movement.Id
                                 AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()
                           
          LEFT JOIN ObjectFloat AS ObjectString_BuyerForSite_Bonus
                                ON ObjectString_BuyerForSite_Bonus.ObjectId = Object_BuyerForSite.Id 
                               AND ObjectString_BuyerForSite_Bonus.DescId = zc_ObjectFloat_BuyerForSite_Bonus()
          LEFT JOIN ObjectFloat AS ObjectString_BuyerForSite_BonusAdd
                                ON ObjectString_BuyerForSite_BonusAdd.ObjectId = Object_BuyerForSite.Id 
                               AND ObjectString_BuyerForSite_BonusAdd.DescId = zc_ObjectFloat_BuyerForSite_BonusAdd()
          LEFT JOIN ObjectFloat AS ObjectString_BuyerForSite_BonusAdded
                                ON ObjectString_BuyerForSite_BonusAdded.ObjectId = Object_BuyerForSite.Id 
                               AND ObjectString_BuyerForSite_BonusAdded.DescId = zc_ObjectFloat_BuyerForSite_BonusAdded()
                               
     WHERE Object_BuyerForSite.DescId = zc_Object_BuyerForSite()

     GROUP BY Object_BuyerForSite.Id
            , Object_BuyerForSite.ObjectCode
            , Object_BuyerForSite.ValueData
            , ObjectString_BuyerForSite_Phone.ValueData 
            , ObjectString_BuyerForSite_Bonus.ValueData
            , ObjectString_BuyerForSite_BonusAdd.ValueData
            , ObjectString_BuyerForSite_BonusAdded.ValueData;
   
   ELSE

       -- Результат
     RETURN QUERY
     SELECT Object_BuyerForSite.Id
          , Object_BuyerForSite.ObjectCode
          , Object_BuyerForSite.ValueData
          , ObjectString_BuyerForSite_Phone.ValueData            AS Phone
          , SUM(MovementSiteBonus.Bonus)::TFloat                 AS Bonus
          , SUM(MovementSiteBonus.Bonus_Used)::TFloat            AS Bonus_Used
          , SUM(MovementFloat_MobileDiscount.ValueData)::TFloat  AS MobileDiscount
          , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN MovementFloat_MobileDiscount.ValueData END)::TFloat  AS MobileDiscount_Compl

          , ObjectString_BuyerForSite_Bonus.ValueData            AS Bonus_Balance
          , ObjectString_BuyerForSite_BonusAdd.ValueData         AS Bonus_Add
          , ObjectString_BuyerForSite_BonusAdded.ValueData       AS Bonus_Added
     FROM MovementSiteBonus

          LEFT JOIN Object AS Object_BuyerForSite 
                           ON Object_BuyerForSite.DescId = zc_Object_BuyerForSite()
                          AND Object_BuyerForSite.ObjectCode = MovementSiteBonus.BuyerForSiteCode
                          
          LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                 ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

          LEFT JOIN Movement ON Movement.Id = MovementSiteBonus.MovementId
          
          LEFT JOIN MovementFloat AS MovementFloat_MobileDiscount
                                  ON MovementFloat_MobileDiscount.MovementId =  Movement.Id
                                 AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()
                           
          LEFT JOIN ObjectFloat AS ObjectString_BuyerForSite_Bonus
                                ON ObjectString_BuyerForSite_Bonus.ObjectId = Object_BuyerForSite.Id 
                               AND ObjectString_BuyerForSite_Bonus.DescId = zc_ObjectFloat_BuyerForSite_Bonus()
          LEFT JOIN ObjectFloat AS ObjectString_BuyerForSite_BonusAdd
                                ON ObjectString_BuyerForSite_BonusAdd.ObjectId = Object_BuyerForSite.Id 
                               AND ObjectString_BuyerForSite_BonusAdd.DescId = zc_ObjectFloat_BuyerForSite_BonusAdd()
          LEFT JOIN ObjectFloat AS ObjectString_BuyerForSite_BonusAdded
                                ON ObjectString_BuyerForSite_BonusAdded.ObjectId = Object_BuyerForSite.Id 
                               AND ObjectString_BuyerForSite_BonusAdded.DescId = zc_ObjectFloat_BuyerForSite_BonusAdded()

     GROUP BY Object_BuyerForSite.Id
            , Object_BuyerForSite.ObjectCode
            , Object_BuyerForSite.ValueData
            , ObjectString_BuyerForSite_Phone.ValueData 
            , ObjectString_BuyerForSite_Bonus.ValueData
            , ObjectString_BuyerForSite_BonusAdd.ValueData
            , ObjectString_BuyerForSite_BonusAdded.ValueData
     HAVING SUM(MovementSiteBonus.Bonus) <> 0 OR SUM(MovementSiteBonus.Bonus_Used) <> 0;
     
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 29.07.21                                                                                    *
*/

-- тест
-- 


select * from gpReport_MovementSiteBonus(inShowAll := 'True' ,  inSession := '3')
