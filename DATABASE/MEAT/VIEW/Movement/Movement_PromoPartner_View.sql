--

DROP VIEW IF EXISTS Movement_PromoPartner_View;

CREATE OR REPLACE VIEW Movement_PromoPartner_View AS 
    SELECT       
        Movement_Promo.Id                                                 --Идентификатор
      , Movement_Promo.ParentId                                           --Ссылка на основной документ <Акции> (zc_Movement_Promo)
      , MovementLinkObject_Partner.ObjectId    AS PartnerId               --Покупатель для акции
      , Object_Partner.ObjectCode              AS PartnerCode             --Покупатель для акции
      , Object_Partner.ValueData               AS PartnerName             --Покупатель для акции
      , Object_Partner.DescId                  AS PartnerDescId           --Тип Покупатель для акции
      , ObjectDesc_partner.ItemName            AS PartnerDescName         --Тип Покупатель для акции
      , COALESCE (Object_Juridical.ValueData, CASE WHEN Object_Partner.DescId = zc_Object_Juridical() THEN Object_Partner.ValueData END) :: TVarChar AS Juridical_Name
      , Object_Retail.ValueData                AS Retail_Name
      , CASE WHEN Movement_Promo.StatusId = zc_Enum_Status_Erased()
                  THEN TRUE
             ELSE FALSE
        END                                    AS isErased                --Удален
      , Movement_Promo.StatusId                AS StatusId           --ид статуса
      , Object_Status.ObjectCode               AS StatusCode         --код статуса
      , Object_Status.ValueData                AS StatusName         --Статус
      , Object_Contract.ContractId                                        -- ИД контракта
      , Object_Contract.ContractCode                                      -- код контракта
      , Object_Contract.InvNumber              AS ContractName            --наименование контракта
      , Object_Contract.ContractTagName                                   --признак контракта
      , MovementString_Comment.ValueData       AS Comment                 --Примечание
      , Object_Area.ValueData                  AS AreaName
      , MovementString_Retail.ValueData        AS RetailName_inf
    FROM Movement AS Movement_Promo 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Promo.StatusId
    
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                     ON MovementLinkObject_Partner.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
        LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
        LEFT JOIN ObjectDesc ObjectDesc_partner ON ObjectDesc_partner.id = object_partner.descid

        LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  AND Object_Partner.DescId = zc_Object_Partner()
        LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

        LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                   ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id)
                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT OUTER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object_Contract_InvNumber_View AS Object_Contract ON Object_Contract.ContractId = MovementLinkObject_Contract.ObjectId

        LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Area
                                   ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                                  AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
        LEFT OUTER JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

        LEFT OUTER JOIN MovementString AS MovementString_Comment
                                       ON MovementString_Comment.MovementId = Movement_Promo.Id
                                      AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                      
        LEFT OUTER JOIN MovementString AS MovementString_Retail
                                       ON MovementString_Retail.MovementId = Movement_Promo.Id
                                      AND MovementString_Retail.DescId = zc_MovementString_Retail()

    WHERE Movement_Promo.DescId = zc_Movement_PromoPartner()
   ;

ALTER TABLE Movement_Promo_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 31.10.15                                                         * 
*/

-- тест
-- SELECT * FROM Movement_PromoPartner_View WHERE ParentId = 2641111
