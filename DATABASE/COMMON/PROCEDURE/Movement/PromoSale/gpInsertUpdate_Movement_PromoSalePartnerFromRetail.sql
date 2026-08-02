-- Function: gpInsertUpdate_Movement_PromoSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoSalePartnerFromRetail (
    Integer    , -- Ключ родительского объекта <Документ акции>
    Integer    , -- Ключ объекта <Торговая Сеть>
    TVarChar     -- сессия пользователя

);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoSalePartnerFromRetail(
    IN inParentId               Integer    , -- Ключ родительского объекта <Документ акции>
    IN inRetailId               Integer    , -- Ключ объекта <Торговая Сеть>
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS
VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoSale());
    vbUserId := lpGetUserBySession (inSession);

    -- проверили сохранен ли документ
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен или не находится в состоянии <Не проведен>.';
    END IF;
    -- собрать всех партнеров и залить
    IF EXISTS (WITH
               tmpPartner AS (SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                              FROM ObjectLink AS ObjectLink_Juridical_Retail
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              )
             , tmpPromoSalePartner AS (SELECT *
                                       FROM Movement_PromoSalePartner_View AS Movement_PromoSalePartner
                                       WHERE Movement_PromoSalePartner.ParentId = inParentId
                                         AND Movement_PromoSalePartner.isErased = FALSE
                                       )                
                             
                SELECT 1
                FROM tmpPartner
                    LEFT OUTER JOIN tmpPromoSalePartner ON tmpPromoSalePartner.PartnerId = tmpPartner.PartnerId
                WHERE  tmpPromoSalePartner.Id is null)
    THEN
        PERFORM
            gpInsertUpdate_Movement_PromoSalePartner(ioId              := 0, -- Ключ объекта <партнер для документа акции>
                                                     inParentId        := inParentId , -- Ключ родительского объекта <Документ акции>
                                                     inPartnerId       := tmp.PartnerId, -- Ключ объекта <Контрагент / Юр лицо / Торговая Сеть>
                                                     inContractId      := 0, -- Ключ объекта <Контракт>
                                                     inComment         := '', -- Примечание
                                                     inRetailName_inf  := '', -- торг.сеть доп.
                                                     inSession         := inSession)  -- сессия пользователя
        FROM (WITH
               tmpPartner AS (SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                              FROM ObjectLink AS ObjectLink_Juridical_Retail
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              )
             , tmpPromoSalePartner AS (SELECT *
                                       FROM Movement_PromoSalePartner_View AS Movement_PromoSalePartner
                                       WHERE Movement_PromoSalePartner.ParentId = inParentId
                                         AND Movement_PromoSalePartner.isErased = FALSE
                                       ) 
             SELECT tmpPartner.PartnerId
             FROM tmpPartner
                 LEFT OUTER JOIN tmpPromoSalePartner ON tmpPromoSalePartner.PartnerId = tmpPartner.PartnerId
             WHERE  tmpPromoSalePartner.Id is null
             ) AS tmp;

    END IF;
            
    --Удалить партнеров, которые не пренадлежат торговой сети
     IF EXISTS (SELECT 1
                FROM
                    Movement_PromoSalePartner_View AS Movement_PromoSalePartner
                    LEFT OUTER JOIN (
                                        SELECT
                                            ObjectLink_Partner_Juridical.ObjectId as Id
                                        FROM
                                            ObjectLink AS ObjectLink_Juridical_Retail
                                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                        WHERE
                                            ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                                            AND
                                            ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                    ) as Partner  ON Partner.Id = Movement_PromoSalePartner.PartnerId
                WHERE
                    Movement_PromoSalePartner.ParentId = inParentId
                    AND
                    Movement_PromoSalePartner.isErased = FALSE
                    AND
                    Partner.Id is null)
    THEN
        PERFORM
            gpMovement_PromoSalePartner_SetErased(inMovementId := Movement_PromoSalePartner.Id, -- ключ объекта <Элемент документа>
                                                  inSession := inSession)
        FROM
            Movement_PromoSalePartner_View AS Movement_PromoSalePartner
            LEFT OUTER JOIN (
                             SELECT
                                 ObjectLink_Partner_Juridical.ObjectId as Id
                             FROM
                                 ObjectLink AS ObjectLink_Juridical_Retail
                                 INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                             WHERE
                                 ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                                 AND
                                 ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            ) AS Partner  ON Partner.Id = Movement_PromoSalePartner.PartnerId
        WHERE
            Movement_PromoSalePartner.ParentId = inParentId
            AND
            Movement_PromoSalePartner.isErased = FALSE
            AND
            Partner.Id is null;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 30.07.26         *
*/
