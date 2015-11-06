DROP VIEW IF EXISTS Movement_PromoPartner_View;

CREATE OR REPLACE VIEW Movement_PromoPartner_View AS 
    SELECT       
        Movement_Promo.Id                                                 --Идентификатор
      , Movement_Promo.ParentId                                           --Ссылка на основной документ <Акции> (zc_Movement_Promo)
      , MovementLinkObject_Partner.ObjectId    AS PartnerId               --Покупатель для акции
      , Object_Partner.ObjectCode              AS PartnerCode             --Покупатель для акции
      , Object_Partner.ValueData               AS PartnerName             --Покупатель для акции
      , Object_Partner.DescId                  AS PartnerDescId           --Тип Покупатель для акции
      , ObjectDesc_Partner.ItemName            AS PartnerDescName         --Тип Покупатель для акции
      , CASE 
            WHEN Movement_Promo.StatusId = zc_Enum_Status_Erased()
                THEN TRUE
        ELSE FALSE
        END                                    AS isErased                --Удален
            
    FROM Movement AS Movement_Promo 

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                     ON MovementLinkObject_Partner.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
        LEFT JOIN Object AS Object_Partner 
                         ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
        LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner
                                   ON ObjectDesc_Partner.Id = Object_Partner.DescId
    WHERE Movement_Promo.DescId = zc_Movement_Promo()
      AND Movement_Promo.ParentId is not null;

ALTER TABLE Movement_Promo_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 31.10.15                                                         * 
*/

-- тест
-- SELECT * FROM Movement_Promo_View  where id = 805
