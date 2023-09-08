-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartnerFromRetail (
    Integer    , -- Ключ родительского объекта <Документ акции>
    Integer    , -- Ключ объекта <Торговая Сеть>
    TVarChar     -- сессия пользователя

);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoPartnerFromRetail(
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
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := lpGetUserBySession (inSession);

    
    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inParentId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- проверили сохранен ли документ
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен или не находится в состоянии <Не проведен>.';
    END IF;
    -- собрать всех партнеров и залить
    IF EXISTS(  SELECT 1
                FROM
                    ObjectLink AS ObjectLink_Juridical_Retail
                    INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    LEFT OUTER JOIN Movement_PromoPartner_View AS Movement_PromoPartner
                                                               ON Movement_PromoPartner.ParentId = inParentId
                                                              AND Movement_PromoPartner.isErased = FALSE
                                                              AND Movement_PromoPartner.PartnerId = ObjectLink_Partner_Juridical.ObjectId
                WHERE
                    ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                    AND
                    ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND
                    Movement_PromoPartner.Id is null)
    THEN
        PERFORM
            gpInsertUpdate_Movement_PromoPartner(
                ioId              := 0, -- Ключ объекта <партнер для документа акции>
                inParentId        := inParentId , -- Ключ родительского объекта <Документ акции>
                inPartnerId       := ObjectLink_Partner_Juridical.ObjectId, -- Ключ объекта <Контрагент / Юр лицо / Торговая Сеть>
                inContractId      := 0, -- Ключ объекта <Контракт>
                inComment         := '', -- Примечание
                inRetailName_inf  := '', -- торг.сеть доп.
                inSession         := inSession)  -- сессия пользователя
        FROM
            ObjectLink AS ObjectLink_Juridical_Retail
            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT OUTER JOIN Movement_PromoPartner_View AS Movement_PromoPartner
                                                       ON Movement_PromoPartner.ParentId = inParentId
                                                      AND Movement_PromoPartner.isErased = FALSE
                                                      AND Movement_PromoPartner.PartnerId = ObjectLink_Partner_Juridical.ObjectId
        WHERE
            ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
            AND
            ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            AND
            Movement_PromoPartner.Id is null;
    END IF;
            
    --Удалить партнеров, которые не пренадлежать торговой сети
    IF EXISTS(  SELECT 1
                FROM
                    Movement_PromoPartner_View AS Movement_PromoPartner
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
                                    ) as Partner  ON Partner.Id = Movement_PromoPartner.PartnerId
                WHERE
                    Movement_PromoPartner.ParentId = inParentId
                    AND
                    Movement_PromoPartner.isErased = FALSE
                    AND
                    Partner.Id is null)
    THEN
        PERFORM
            gpMovement_PromoPartner_SetErased(inMovementId := Movement_PromoPartner.Id, -- ключ объекта <Элемент документа>
                                              inSession := inSession)
        FROM
            Movement_PromoPartner_View AS Movement_PromoPartner
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
                            ) as Partner  ON Partner.Id = Movement_PromoPartner.PartnerId
        WHERE
            Movement_PromoPartner.ParentId = inParentId
            AND
            Movement_PromoPartner.isErased = FALSE
            AND
            Partner.Id is null;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 04.12.15                                                                    *inContractId
*/
