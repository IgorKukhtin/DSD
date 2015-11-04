DROP VIEW IF EXISTS Movement_Promo_View;

CREATE OR REPLACE VIEW Movement_Promo_View AS 
    SELECT       
        Movement_Promo.Id                                                 --Идентификатор
      , Movement_Promo.ParentId                                           --Ссылка на основной документ <Акции> (zc_Movement_Promo)
      , zc_MovementLinkObject_Partner.ObjectId AS PartnerId               --Покупатель для акции
      , Object_Partner.ValueData               AS PartnerName             --Покупатель для акции
      , Object_Partner.DescId                  AS PartnerDescId           --Тип Покупатель для акции
      , ObjectDesc_Partner.DescName            AS PartnerDescName         --Тип Покупатель для акции
    FROM Movement AS Movement_Promo 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementLinkObject AS zc_MovementLinkObject_Partner
                                     ON zc_MovementLinkObject_Partner.MovementId = Movement.Id
                                    AND zc_MovementLinkObject_Partner.DescId = zc_zc_MovementLinkObject_Partner()
        LEFT JOIN Object AS Object_Partner 
                         ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
        LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner
                                   ON ObjectDesc_Partner.Id = Object_Partner.DescId
    WHERE Movement.DescId = zc_Movement_Promo()
      AND Movement.ParentId is not null;

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
