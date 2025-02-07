-- Function: gpSelect_MovementItem_PromoPartner()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoPartner(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                  Integer --идентификатор
      , PartnerId           Integer --ИД объекта <партнер>
      , Code                Integer --код объекта  <Партнер>
      , Name                TVarChar --наименование объекта <Партнер>
      , JuridicalName       TVarChar --Наименование объекта <Юр. лицо>
      , RetailId            Integer  --
      , RetailName          TVarChar --Наименование объекта <Торговая сеть>
      , AreaName            TVarChar --Наименование объекта <Регион>
      , ContractId          Integer  --
      , ContractCode        TVarChar --№ контракта
      , ContractName        TVarChar --Названеи контракта
      , ContractTagName     TVarChar --признак контракта
      , IsErased            Boolean  --Признак <удален>
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoPartner());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        SELECT
            MI_PromoPartner.Id                     AS Id              --идентификатор
          , MI_PromoPartner.ObjectId               AS PartnerId       --ИД объекта <партнер>
          , Object_Partner.ObjectCode::Integer     AS Code            --код объекта  <Партнер>
          , Object_Partner.ValueData               AS Name            --наименование объекта <Партнер>
          , COALESCE (Object_Juridical.ValueData, CASE WHEN Object_Partner.DescId = zc_Object_Juridical() THEN Object_Partner.ValueData END) :: TVarChar AS JuridicalName   --Наименование объекта <Юр. лицо>
          , Object_Retail.Id                       AS RetailId      --Наименование объекта <Торговая сеть>
          , Object_Retail.ValueData                AS RetailName      --Наименование объекта <Торговая сеть>
          , Object_Area.ValueData                  AS AreaName        --Наименование объекта <Регион>
          , Object_Contract.ContractId             AS ContractId    --код контракта
          , Object_Contract.ContractCode::TVarChar AS ContractCode    --код контракта
          , Object_Contract.InvNumber              AS ContractName    --наименование контракта
          , Object_Contract.ContractTagName        AS ContractTagName --признак контракта
          , Object_Partner.IsErased                AS IsErased        -- признак <удален>
      
        FROM
            Movement AS Movement_PromoPartner
            INNER JOIN MovementItem AS MI_PromoPartner
                                    ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                   AND MI_PromoPartner.DescId = zc_MI_Master()
            INNER JOIN Object AS Object_Partner
                              ON Object_Partner.Id = MI_PromoPartner.ObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT OUTER JOIN Object AS Object_Juridical
                                   ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.ID
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT OUTER JOIN Object AS Object_Retail
                                   ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Area
                                       ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                      AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
            LEFT OUTER JOIN Object AS Object_Area
                                   ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MI_PromoPartner.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS Object_Contract 
                                                     ON Object_Contract.ContractId = MILinkObject_Contract.ObjectId
        WHERE
            Movement_PromoPartner.ParentId = inMovementId
            AND 
            Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
            AND
            MI_PromoPartner.IsErased = FALSE;
            
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoPartner (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 30.11.15                                                          *
*/