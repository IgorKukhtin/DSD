-- Function: gpInsertUpdate_Movement_PromoSalePartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoSalePartner (
    Integer    , -- Ключ объекта <партнер для документа акции>
    Integer    , -- Ключ родительского объекта <Документ акции>
    Integer    , -- партнер
    Integer    , -- Контракт
    TVarChar   , -- Примечание
    TVarChar   , -- торг.сеть доп.
    TVarChar     -- сессия пользователя
);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoSalePartner(
 INOUT ioId                     Integer    , -- Ключ объекта <партнер для документа акции>
    IN inParentId               Integer    , -- Ключ родительского объекта <Документ акции>
    IN inPartnerId              Integer    , -- Ключ объекта <Контрагент / Юр лицо / Торговая Сеть>
    IN inContractId             Integer    , -- Ключ объекта <Контракт>
    IN inComment                TVarChar   , -- Примечание
    IN inRetailName_inf         TVarChar   , -- торг.сеть доп.
   OUT outPriceListId           Integer    , -- ИД прайслиста в документе
   OUT outPriceListName         TVarChar   , -- Название прайслиста в документе
   OUT outPersonalMarketingId   Integer    , -- ИД сотрудника маркетингового отдела
   OUT outPersonalMarketingName TVarChar   , -- Имя сотрудника маркетингового отдела
   OUT outPersonalTradeId       Integer    , -- ИД сотрудника коммерческого отдела
   OUT outPersonalTradeName     TVarChar   , -- Имя сотрудника коммерческого отдела
    IN inSession                TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartnerDescId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoSale());
    vbUserId := lpGetUserBySession (inSession);


    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --проверили сохранен ли документ
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен или не находится в состоянии <Не проведен>.';
    END IF;
    
    -- сохранили <Документ>
    SELECT
        lpInsertUpdate_Movement (ioId, zc_Movement_PromoSalePartner(), Movement_PromoSale.InvNumber, Movement_PromoSale.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_PromoSale
    WHERE
        Movement_PromoSale.Id = inParentId;
    
    --проверить соответствие контракта клиенту
    IF COALESCE(inContractId,0) <> 0
    THEN
        vbPartnerDescId = (Select DescId from Object WHERE Id = inPartnerId);
        IF vbPartnerDescId = zc_Object_Juridical()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View 
                          WHERE Object_Contract_View.ContractId = inContractId 
                            AND Object_Contract_View.JuridicalId = inPartnerId)
            THEN
                RAISE EXCEPTION 'Ошибка. <Договор> несоответствует <Партнеру>.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Partner()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ChildObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                          WHERE Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION 'Ошибка. Несоответствие контракта и партнера.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Retail()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Juridical_Retail()
                          WHERE Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ChildObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION 'Ошибка. Несоответствие контракта и партнера.';
            END IF;
        END IF;
    END IF;
    
    -- сохранили связь с <Контрагент / Юр лицо / Торговая Сеть>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
    
    --Ищем прайслист клиента
    SELECT
        Movement_PromoSalePriceList.PriceListId
    INTO
        outPriceListId
    FROM
        lpGet_Movement_PromoSalePriceList(inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoSalePriceList
    WHERE
        Movement_PromoSalePriceList.PartnerId = inPartnerId
    LIMIT 1;
    -- если у него не базовый прайс лист - то обновляем прайслист у акции
    IF outPriceListId <> zc_PriceList_Basis()
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PriceList(), inParentId, outPriceListId);
    END IF;

    --Обновляем сотрудника маркетингового отдела
    IF (SELECT DescId FROM Object WHERE Id = inPartnerId) = zc_Object_Retail()
    THEN
        outPersonalMarketingId := (SELECT ObjectLink_Retail_PersonalMarketing.ChildObjectId 
                                   FROM ObjectLink AS ObjectLink_Retail_PersonalMarketing
                                   WHERE ObjectLink_Retail_PersonalMarketing.ObjectId = inPartnerId 
                                     AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing());
    ELSIF (SELECT DescId FROM Object WHERE Id = inPartnerId) = zc_Object_Juridical()
    THEN
        outPersonalMarketingId := (SELECT ObjectLink_Retail_PersonalMarketing.ChildObjectId 
                                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                                      INNER JOIN ObjectLink AS ObjectLink_Retail_PersonalMarketing 
                                                            ON ObjectLink_Retail_PersonalMarketing.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                           AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing() 
                                   WHERE ObjectLink_Juridical_Retail.ObjectId = inPartnerId 
                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail());

    ELSIF (SELECT DescId FROM Object WHERE Id = inPartnerId) = zc_Object_Partner()
    THEN
        outPersonalMarketingId := (SELECT ObjectLink_Retail_PersonalMarketing.ChildObjectId 
                                  FROM ObjectLink AS ObjectLink_Partner_Juridical
                                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                      INNER JOIN ObjectLink AS ObjectLink_Retail_PersonalMarketing 
                                                            ON ObjectLink_Retail_PersonalMarketing.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                           AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing() 
                                   WHERE ObjectLink_Partner_Juridical.ObjectId = inPartnerId 
                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  );
    END IF;
    if COALESCE(outPersonalMarketingId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Personal(), inParentId, outPersonalMarketingId);
    END IF;
    
    --Обновляем сотрудника Коммерческого отдела
    IF (SELECT DescId FROM Object WHERE Id = inPartnerId) = zc_Object_Partner()
    THEN
        outPersonalTradeId := (SELECT ObjectLink_Retail_PersonalTrade.ChildObjectId 
                               FROM ObjectLink AS ObjectLink_Partner_Juridical
                                   INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                 INNER JOIN ObjectLink AS ObjectLink_Retail_PersonalTrade
                                                       ON ObjectLink_Retail_PersonalTrade.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                      AND ObjectLink_Retail_PersonalTrade.DescId = zc_ObjectLink_Retail_PersonalTrade() 
                                WHERE ObjectLink_Partner_Juridical.ObjectId = inPartnerId 
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                               );

    ELSIF (SELECT DescId FROM Object WHERE Id = inPartnerId) = zc_Object_Juridical()
    THEN
        outPersonalTradeId := (SELECT ObjectLink_Retail_PersonalTrade.ChildObjectId 
                               FROM ObjectLink AS ObjectLink_Juridical_Retail
                                    INNER JOIN ObjectLink AS ObjectLink_Retail_PersonalTrade
                                                          ON ObjectLink_Retail_PersonalTrade.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                         AND ObjectLink_Retail_PersonalTrade.DescId = zc_ObjectLink_Retail_PersonalTrade() 
                               WHERE ObjectLink_Juridical_Retail.ObjectId = inPartnerId 
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              );

    ELSIF (SELECT DescId FROM Object WHERE Id = inPartnerId) = zc_Object_Retail()
    THEN
        outPersonalTradeId := (SELECT ObjectLink_Retail_PersonalTrade.ChildObjectId 
                               FROM ObjectLink AS ObjectLink_Retail_PersonalTrade
                               WHERE ObjectLink_Retail_PersonalTrade.ObjectId = inPartnerId 
                                 AND ObjectLink_Retail_PersonalTrade.DescId = zc_ObjectLink_Retail_PersonalTrade() 
                              );
    END IF;

    IF COALESCE(outPersonalTradeId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PersonalTrade(), inParentId, outPersonalTradeId);
    END IF;
    
    --а теперь контролируем, нет ли партнера, у которого прайслист не базовый и не равен прайслисту в документе
    SELECT MovementLinkObject_PriceList.ObjectId       AS PriceListId       
         , Object_PriceList.ValueData                  AS PriceListName 
         , MovementLinkObject_Personal.ObjectId        AS PersonalId       
         , Object_Personal.ValueData                   AS PersonalName    
         , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId  
         , Object_PersonalTrade.ValueData              AS PersonalTradeName
    INTO
        outPriceListId
       ,outPriceListName
       ,outPersonalMarketingId
       ,outPersonalMarketingName
       ,outPersonalTradeId
       ,outPersonalTradeName

        FROM Movement AS Movement_PromoSale
             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                          ON MovementLinkObject_PriceList.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
             LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
             LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                          ON MovementLinkObject_Personal.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
         WHERE Movement_PromoSale.DescId = zc_Movement_PromoSale()
           AND Movement_PromoSale.Id = inParentId;   
   
    
    IF EXISTS(SELECT 1 
              FROM
                  Movement_PromoSalePartner_View AS Movement_PromoSalePartner
                  LEFT OUTER JOIN (SELECT Movement_PromoSalePriceList.PartnerId
                                   FROM lpGet_Movement_PromoSalePriceList (inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoSalePriceList
                                   WHERE Movement_PromoSalePriceList.PriceListId IN (zc_PriceList_Basis(), outPriceListId)
                                 ) AS Movement_PromoSalePriceList
                                   ON Movement_PromoSalePriceList.PartnerId = Movement_PromoSalePartner.PartnerId
              WHERE Movement_PromoSalePartner.ParentId    = inParentId
                AND Movement_PromoSalePartner.isErased    = FALSE
                AND Movement_PromoSalePriceList.PartnerId IS NULL
             )
    THEN
        RAISE EXCEPTION 'Ошибка. В документе есть партнер с прайс-листом не равным установленному в акции <%> <%> <%>.'
                      , (SELECT lfGet_Object_ValueData_sh (Movement_PromoSalePriceList.PartnerId)
                         FROM lpGet_Movement_PromoSalePriceList(inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoSalePriceList
                         WHERE COALESCE (Movement_PromoSalePriceList.PriceListId, 0) NOT IN (zc_PriceList_Basis(), outPriceListId)
                           AND Movement_PromoSalePriceList.PartnerId IN (SELECT Movement_PromoSalePartner.PartnerId
                                                                     FROM Movement_PromoSalePartner_View AS Movement_PromoSalePartner
                                                                     WHERE Movement_PromoSalePartner.ParentId = inParentId
                                                                       AND Movement_PromoSalePartner.isErased = FALSE)
                         ORDER BY Movement_PromoSalePriceList.PartnerId
                         LIMIT 1
                        )
                      , (SELECT lfGet_Object_ValueData_sh (Movement_PromoSalePriceList.PriceListId)
                         FROM lpGet_Movement_PromoSalePriceList(inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoSalePriceList
                         WHERE COALESCE (Movement_PromoSalePriceList.PriceListId, 0) NOT IN (zc_PriceList_Basis(), outPriceListId)
                           AND Movement_PromoSalePriceList.PartnerId IN (SELECT Movement_PromoSalePartner.PartnerId
                                                                     FROM Movement_PromoSalePartner_View AS Movement_PromoSalePartner
                                                                     WHERE Movement_PromoSalePartner.ParentId = inParentId
                                                                       AND Movement_PromoSalePartner.isErased = FALSE)
                         ORDER BY Movement_PromoSalePriceList.PartnerId
                         LIMIT 1
                        )
                      , (SELECT COUNT(*)
                         FROM
                             Movement_PromoSalePartner_View AS Movement_PromoSalePartner
                             LEFT OUTER JOIN (SELECT Movement_PromoSalePriceList.PartnerId
                                              FROM lpGet_Movement_PromoSalePriceList (inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoSalePriceList
                                              WHERE Movement_PromoSalePriceList.PriceListId IN (zc_PriceList_Basis(), outPriceListId)
                                            ) AS Movement_PromoSalePriceList
                                              ON Movement_PromoSalePriceList.PartnerId = Movement_PromoSalePartner.PartnerId
                         WHERE Movement_PromoSalePartner.ParentId    = inParentId
                           AND Movement_PromoSalePartner.isErased    = FALSE
                           AND Movement_PromoSalePriceList.PartnerId IS NULL
                        )
             ;
    END IF;
    
    -- сохранили связь с <Контракт>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    -- сохранили <Торговая сеть доп.>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Retail(), ioId, TRIM (inRetailName_inf));
    
    --Вернули установленный прайс 
    SELECT
        Movement_PromoSale.PriceListId
       ,Movement_PromoSale.PriceListName
    INTO
        outPriceListId
       ,outPriceListName
    FROM
        Movement_PromoSale_View AS Movement_PromoSale
    WHERE
        Movement_PromoSale.Id = inParentId;    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.27         *
*/
