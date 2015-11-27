--

DROP VIEW IF EXISTS Movement_PromoAdvertising_View;

CREATE OR REPLACE VIEW Movement_PromoAdvertising_View AS 
    SELECT       
        Movement_Promo.Id                                                 --Идентификатор
      , Movement_Promo.ParentId                                           --Ссылка на основной документ <Акции> (zc_Movement_Promo)
      , MovementLinkObject_Advertising.ObjectId    AS AdvertisingId       --Рекламная поддержка для акции
      , Object_Advertising.ObjectCode              AS AdvertisingCode     --Рекламная поддержка для акции
      , Object_Advertising.ValueData               AS AdvertisingName     --Рекламная поддержка для акции
      , MovementString_Comment.ValueData           AS Comment             --Примечание
      , CASE 
            WHEN Movement_Promo.StatusId = zc_Enum_Status_Erased()
                THEN TRUE
        ELSE FALSE
        END                                    AS isErased                --Удален
    FROM Movement AS Movement_Promo 

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Advertising
                                     ON MovementLinkObject_Advertising.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Advertising.DescId = zc_MovementLinkObject_Advertising()
        LEFT JOIN Object AS Object_Advertising 
                         ON Object_Advertising.Id = MovementLinkObject_Advertising.ObjectId
        LEFT OUTER JOIN MovementString AS MovementString_Comment
                                       ON MovementString_Comment.MovementId = Movement_Promo.Id
                                      AND MovementString_Comment.DescId = zc_MovementString_Comment()
        
    WHERE Movement_Promo.DescId = zc_Movement_PromoAdvertising()
   ;

ALTER TABLE Movement_PromoAdvertising_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 24.11.15                                                         * 
*/

-- тест
-- SELECT * FROM Movement_PromoAdvertising_View WHERE ParentId = 2641111
