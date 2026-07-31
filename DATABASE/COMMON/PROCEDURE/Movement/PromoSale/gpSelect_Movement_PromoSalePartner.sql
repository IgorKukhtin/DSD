-- Function: gpSelect_Movement_PromoSalePartner()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoSalePartner (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoSalePartner(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , ParentId         Integer
             , PartnerId        Integer     --Покупатель для акции
             , PartnerCode      Integer     --Покупатель для акции
             , PartnerName      TVarChar    --Покупатель для акции
             , PartnerDescId    Integer     --Тип Покупатель для акции
             , PartnerDescName  TVarChar    --Тип Покупатель для акции
             , Juridical_Name   TVarChar    --Юрлицо
             , Retail_Name      TVarChar    --Сеть
             , RetailName_inf   TVarChar    --торг. сеть доп.
             , ContractId       Integer     --ИД контракта
             , ContractCode     Integer     --Код контракта
             , ContractName     TVarChar    --Название контракта
             , ContractTagName  TVarChar    --Признак договора
             , Comment          TVarChar    --Примечание
             , AreaName         TVarChar    --Регион
             , isErased         Boolean     --Удален
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
         SELECT       
           Movement_PromoSale.Id                                                 --Идентификатор
         , Movement_PromoSale.ParentId                                           --Ссылка на основной документ <Акции> (zc_Movement_PromoSale)
         , MovementLinkObject_Partner.ObjectId    AS PartnerId               --Покупатель для акции
         , Object_Partner.ObjectCode              AS PartnerCode             --Покупатель для акции
         , Object_Partner.ValueData               AS PartnerName             --Покупатель для акции
         , Object_Partner.DescId                  AS PartnerDescId           --Тип Покупатель для акции
         , ObjectDesc_partner.ItemName            AS PartnerDescName         --Тип Покупатель для акции
         , COALESCE (Object_Juridical.ValueData, CASE WHEN Object_Partner.DescId = zc_Object_Juridical() THEN Object_Partner.ValueData END) :: TVarChar AS Juridical_Name
         , Object_Retail.ValueData                AS Retail_Name
         , MovementString_Retail.ValueData        AS RetailName_inf
         , Object_Contract.ContractId                                        -- ИД контракта
         , Object_Contract.ContractCode                                      -- код контракта
         , Object_Contract.InvNumber              AS ContractName            --наименование контракта
         , Object_Contract.ContractTagName                                   --признак контракта
         , MovementString_Comment.ValueData       AS Comment                 --Примечание
         , Object_Area.ValueData                  AS AreaName
         , CASE WHEN Movement_PromoSale.StatusId = zc_Enum_Status_Erased()
                     THEN TRUE
                ELSE FALSE
           END                                    AS isErased                --Удален
       FROM Movement AS Movement_PromoSale 
           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoSale.StatusId
       
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                        ON MovementLinkObject_Partner.MovementId = Movement_PromoSale.Id
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
                                        ON MovementLinkObject_Contract.MovementId = Movement_PromoSale.Id
                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
           LEFT JOIN Object_Contract_InvNumber_View AS Object_Contract ON Object_Contract.ContractId = MovementLinkObject_Contract.ObjectId
   
           LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Area
                                      ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                                     AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
           LEFT OUTER JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
   
           LEFT OUTER JOIN MovementString AS MovementString_Comment
                                          ON MovementString_Comment.MovementId = Movement_PromoSale.Id
                                         AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                         
           LEFT OUTER JOIN MovementString AS MovementString_Retail
                                          ON MovementString_Retail.MovementId = Movement_PromoSale.Id
                                         AND MovementString_Retail.DescId = zc_MovementString_Retail()
   
       WHERE Movement_PromoSale.DescId = zc_Movement_PromoSalePartner()
         AND Movement_PromoSale.ParentId = inMovementId
         AND (Movement_PromoSale.StatusId <> zc_Enum_Status_Erased()
           OR inIsErased = TRUE
             );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.26         *
*/