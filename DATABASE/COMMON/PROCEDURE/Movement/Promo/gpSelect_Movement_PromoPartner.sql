-- Function: gpSelect_Movement_PromoPartner()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoPartner (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoPartner(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
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
            Movement_PromoPartner.Id                  --Идентификатор
          , Movement_PromoPartner.PartnerId           --Покупатель для акции
          , Movement_PromoPartner.PartnerCode::Integer--Покупатель для акции
          , Movement_PromoPartner.PartnerName         --Покупатель для акции
          , Movement_PromoPartner.PartnerDescId       --Тип Покупатель для акции
          , Movement_PromoPartner.PartnerDescName     --Тип Покупатель для акции
          , Movement_PromoPartner.Juridical_Name      --Юрлицо
          , Movement_PromoPartner.Retail_Name         --Сеть
          , Movement_PromoPartner.RetailName_inf      --торг. сеть доп.
          , Movement_PromoPartner.ContractId          --ИД контракта
          , Movement_PromoPartner.ContractCode        --Код контракта
          , Movement_PromoPartner.ContractName        --Название контракта
          , Movement_PromoPartner.ContractTagName     --признак договора 
          , Movement_PromoPartner.Comment             --Примечание
          , Movement_PromoPartner.AreaName            --Регион
          , Movement_PromoPartner.isErased            --Удален
        FROM
            Movement_PromoPartner_View AS Movement_PromoPartner
        WHERE
            Movement_PromoPartner.ParentId = inMovementId
            AND
            (
                Movement_PromoPartner.isErased = FALSE
                OR
                inIsErased = TRUE
            );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PromoPartner (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 01.08.17         * add RetailName_inf
 17.11.15                                                                        *Contract
 05.11.15                                                                        *
*/