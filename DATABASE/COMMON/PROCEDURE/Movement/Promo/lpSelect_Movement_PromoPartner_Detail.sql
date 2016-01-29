-- расчет всех Контрагентов для документа Акции
-- Function: lpSelect_Movement_PromoPartner_Detail()

DROP FUNCTION IF EXISTS lpSelect_Movement_PromoPartner_Detail (Integer);

CREATE OR REPLACE FUNCTION lpSelect_Movement_PromoPartner_Detail(
    IN inMovementId    Integer  -- Ключ документа <Акция>
)
RETURNS TABLE (MovementId       Integer     -- Документ
             , PartnerId        Integer     -- Контрагент
             , ContractId       Integer     -- Договор
              )
AS
$BODY$
BEGIN
     RETURN QUERY
        WITH tmpPartner_all AS 
                      (SELECT Movement_PromoPartner.Id                           AS MovementId
                            , COALESCE (MovementLinkObject_Partner.ObjectId, 0)  AS ObjectId
                            , Object_by.DescId                                   AS ObjectDescId
                            , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                       FROM Movement AS Movement_PromoPartner
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                         ON MovementLinkObject_Partner.MovementId = Movement_PromoPartner.Id
                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                            LEFT JOIN Object AS Object_by ON Object_by.Id = MovementLinkObject_Partner.ObjectId
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                         ON MovementLinkObject_Contract.MovementId = Movement_PromoPartner.Id
                                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                       WHERE Movement_PromoPartner.ParentId = inMovementId
                         AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                      )
      , tmpPartner AS (-- Контрагенты
                       SELECT tmpPartner_all.MovementId AS MovementId
                            , tmpPartner_all.ObjectId   AS PartnerId
                            , tmpPartner_all.ContractId AS ContractId
                       FROM tmpPartner_all
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Partner()
                      UNION
                       -- из Юр. лиц
                       SELECT tmpPartner_all.MovementId             AS MovementId
                            , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                            , tmpPartner_all.ContractId             AS ContractId
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = tmpPartner_all.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Juridical()
                      UNION
                       -- из Торговой сети
                       SELECT tmpPartner_all.MovementId             AS MovementId
                            , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                            , tmpPartner_all.ContractId             AS ContractId
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ChildObjectId = tmpPartner_all.ObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Retail()
                      )
        SELECT tmpPartner.MovementId
             , tmpPartner.PartnerId
             , tmpPartner.ContractId
        FROM tmpPartner
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 29.11.15                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Movement_PromoPartner_Detail (inMovementId:= 2641111) AS tmp LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmp.PartnerId LEFT JOIN Object_Contract_InvNumber_View AS Object_Contract ON Object_Contract.ContractId = tmp.ContractId
