-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- ���� ������� <������� ��� ��������� �����>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- �������
    TVarChar     -- ������ ������������

);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- ���� ������� <������� ��� ��������� �����>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- �������
    Integer    , -- ��������
    TVarChar     -- ������ ������������
);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- ���� ������� <������� ��� ��������� �����>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- �������
    Integer    , -- ��������
    TVarChar   , -- ����������
    TVarChar     -- ������ ������������
);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- ���� ������� <������� ��� ��������� �����>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- �������
    Integer    , -- ��������
    TVarChar   , -- ����������
    TVarChar   , -- ����.���� ���.
    TVarChar     -- ������ ������������
);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoPartner(
 INOUT ioId                     Integer    , -- ���� ������� <������� ��� ��������� �����>
    IN inParentId               Integer    , -- ���� ������������� ������� <�������� �����>
    IN inPartnerId              Integer    , -- ���� ������� <���������� / �� ���� / �������� ����>
    IN inContractId             Integer    , -- ���� ������� <��������>
    IN inComment                TVarChar   , -- ����������
    IN inRetailName_inf         TVarChar   , -- ����.���� ���.
   OUT outPriceListId           Integer    , -- �� ���������� � ���������
   OUT outPriceListName         TVarChar   , -- �������� ���������� � ���������
   OUT outPersonalMarketingId   Integer    , -- �� ���������� �������������� ������
   OUT outPersonalMarketingName TVarChar   , -- ��� ���������� �������������� ������
   OUT outPersonalTradeId       Integer    , -- �� ���������� ������������� ������
   OUT outPersonalTradeName     TVarChar   , -- ��� ���������� ������������� ������
    IN inSession                TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartnerDescId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := lpGetUserBySession (inSession);


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inParentId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --��������� �������� �� ��������
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION '������. �������� �� �������� ��� �� ��������� � ��������� <�� ��������>.';
    END IF;
    
    -- ��������� <��������>
    SELECT
        lpInsertUpdate_Movement (ioId, zc_Movement_PromoPartner(), Movement_Promo.InvNumber, Movement_Promo.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    --��������� ������������ ��������� �������
    IF COALESCE(inContractId,0) <> 0
    THEN
        vbPartnerDescId = (Select DescId from Object Where Id = inPartnerId);
        IF vbPartnerDescId = zc_Object_Juridical()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View 
                          Where Object_Contract_View.ContractId = inContractId 
                            AND Object_Contract_View.JuridicalId = inPartnerId)
            THEN
                RAISE EXCEPTION '������. <�������> ��������������� <��������>.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Partner()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ChildObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                          Where Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION '������. �������������� ��������� � ��������.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Retail()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Juridical_Retail()
                          Where Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ChildObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION '������. �������������� ��������� � ��������.';
            END IF;
        END IF;
    END IF;
    
    -- ��������� ����� � <���������� / �� ���� / �������� ����>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
    
    --���� ��������� �������
    SELECT
        Movement_PromoPriceList.PriceListId
    INTO
        outPriceListId
    FROM
        lpGet_Movement_PromoPriceList(inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoPriceList
    WHERE
        Movement_PromoPriceList.PartnerId = inPartnerId
    LIMIT 1;
    -- ���� � ���� �� ������� ����� ���� - �� ��������� ��������� � �����
    IF outPriceListId <> zc_PriceList_Basis()
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PriceList(), inParentId, outPriceListId);
    END IF;
    --��������� ���������� �������������� ������
    IF (SELECT DescId FROM OBJECT WHERE Id = inPartnerId) = zc_Object_Retail()
    THEN
        outPersonalMarketingId := (SELECT ObjectLink_Retail_PersonalMarketing.ChildObjectId 
                                   FROM ObjectLink AS ObjectLink_Retail_PersonalMarketing
                                   WHERE ObjectLink_Retail_PersonalMarketing.ObjectId = inPartnerId 
                                     AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing());
    ELSIF (SELECT DescId FROM OBJECT WHERE Id = inPartnerId) = zc_Object_Juridical()
    THEN
        outPersonalMarketingId := (SELECT ObjectLink_Retail_PersonalMarketing.ChildObjectId 
                                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                                      INNER JOIN ObjectLink AS ObjectLink_Retail_PersonalMarketing 
                                                            ON ObjectLink_Retail_PersonalMarketing.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                           AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing() 
                                   Where ObjectLink_Juridical_Retail.ObjectId = inPartnerId 
                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail());
    ELSIF (SELECT DescId FROM OBJECT WHERE Id = inPartnerId) = zc_Object_Partner()
    THEN
        outPersonalMarketingId := (SELECT ObjectLink_Retail_PersonalMarketing.ChildObjectId 
                                  FROM ObjectLink AS ObjectLink_Partner_Juridical
                                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                      INNER JOIN ObjectLink AS ObjectLink_Retail_PersonalMarketing 
                                                            ON ObjectLink_Retail_PersonalMarketing.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                           AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing() 
                                   Where ObjectLink_Partner_Juridical.ObjectId = inPartnerId 
                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical());
    END IF;
    if COALESCE(outPersonalMarketingId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Personal(), inParentId, outPersonalMarketingId);
    END IF;
    
    --��������� ���������� ������������� ������
    IF (SELECT DescId FROM OBJECT WHERE Id = inPartnerId) = zc_Object_Partner()
    THEN
        outPersonalTradeId := (SELECT ObjectLink_Partner_Personal.ChildObjectId 
                              FROM ObjectLink AS ObjectLink_Partner_Personal
                              WHERE ObjectLink_Partner_Personal.ObjectId = inPartnerId 
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal());
    ELSIF (SELECT DescId FROM OBJECT WHERE Id = inPartnerId) = zc_Object_Juridical()
    THEN
        outPersonalTradeId := (SELECT ObjectLink_Partner_Personal.ChildObjectId 
                              FROM ObjectLink AS ObjectLink_Partner_Juridical
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                        ON ObjectLink_Partner_Personal.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                                       AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal() 
                              WHERE ObjectLink_Partner_Juridical.ChildObjectId = inPartnerId 
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              LIMIT 1);
    ELSIF (SELECT DescId FROM OBJECT WHERE Id = inPartnerId) = zc_Object_retail()
    THEN
        outPersonalTradeId := (SELECT ObjectLink_Partner_Personal.ChildObjectId 
                              FROM ObjectLink AS ObjectLink_Juridical_Retail
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                        ON ObjectLink_Partner_Personal.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                                       AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                              WHERE ObjectLink_Juridical_Retail.ChildObjectId = inPartnerId 
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              LIMIT 1);
    END IF;
    if COALESCE(outPersonalTradeId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PersonalTrade(), inParentId, outPersonalTradeId);
    END IF;
    
    --� ������ ������������, ��� �� ��������, � �������� ��������� �� ������� � �� ����� ���������� � ���������
    SELECT
        Movement_Promo.PriceListId
       ,Movement_Promo.PriceListName
       ,Movement_Promo.PersonalId
       ,Movement_Promo.PersonalName
       ,Movement_Promo.PersonalTradeId
       ,Movement_Promo.PersonaltradeName
    INTO
        outPriceListId
       ,outPriceListName
       ,outPersonalMarketingId
       ,outPersonalMarketingName
       ,outPersonalTradeId
       ,outPersonalTradeName
    FROM
        Movement_Promo_View AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    IF EXISTS(SELECT 1 
              FROM
                  Movement_PromoPartner_View AS Movement_PromoPartner
                  LEFT OUTER JOIN (SELECT Movement_PromoPriceList.PartnerId
                                   FROM lpGet_Movement_PromoPriceList (inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoPriceList
                                   WHERE Movement_PromoPriceList.PriceListId IN (zc_PriceList_Basis(), outPriceListId)
                                 ) AS Movement_PromoPriceList
                                   ON Movement_PromoPriceList.PartnerId = Movement_PromoPartner.PartnerId
              WHERE Movement_PromoPartner.ParentId    = inParentId
                AND Movement_PromoPartner.isErased    = FALSE
                AND Movement_PromoPriceList.PartnerId IS NULL
             )
    THEN
        RAISE EXCEPTION '������. � ��������� ���� ������� � �����-������ �� ������ �������������� � ����� <%> <%> <%>.'
                      , (SELECT lfGet_Object_ValueData_sh (Movement_PromoPriceList.PartnerId)
                         FROM lpGet_Movement_PromoPriceList(inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoPriceList
                         WHERE COALESCE (Movement_PromoPriceList.PriceListId, 0) NOT IN (zc_PriceList_Basis(), outPriceListId)
                           AND Movement_PromoPriceList.PartnerId IN (SELECT Movement_PromoPartner.PartnerId
                                                                     FROM Movement_PromoPartner_View AS Movement_PromoPartner
                                                                     WHERE Movement_PromoPartner.ParentId = inParentId
                                                                       AND Movement_PromoPartner.isErased = FALSE)
                         ORDER BY Movement_PromoPriceList.PartnerId
                         LIMIT 1
                        )
                      , (SELECT lfGet_Object_ValueData_sh (Movement_PromoPriceList.PriceListId)
                         FROM lpGet_Movement_PromoPriceList(inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoPriceList
                         WHERE COALESCE (Movement_PromoPriceList.PriceListId, 0) NOT IN (zc_PriceList_Basis(), outPriceListId)
                           AND Movement_PromoPriceList.PartnerId IN (SELECT Movement_PromoPartner.PartnerId
                                                                     FROM Movement_PromoPartner_View AS Movement_PromoPartner
                                                                     WHERE Movement_PromoPartner.ParentId = inParentId
                                                                       AND Movement_PromoPartner.isErased = FALSE)
                         ORDER BY Movement_PromoPriceList.PartnerId
                         LIMIT 1
                        )
                      , (SELECT COUNT(*)
                         FROM
                             Movement_PromoPartner_View AS Movement_PromoPartner
                             LEFT OUTER JOIN (SELECT Movement_PromoPriceList.PartnerId
                                              FROM lpGet_Movement_PromoPriceList (inMovementId := inParentId, inUserId := vbUserId) AS Movement_PromoPriceList
                                              WHERE Movement_PromoPriceList.PriceListId IN (zc_PriceList_Basis(), outPriceListId)
                                            ) AS Movement_PromoPriceList
                                              ON Movement_PromoPriceList.PartnerId = Movement_PromoPartner.PartnerId
                         WHERE Movement_PromoPartner.ParentId    = inParentId
                           AND Movement_PromoPartner.isErased    = FALSE
                           AND Movement_PromoPriceList.PartnerId IS NULL
                        )
             ;
    END IF;
    
    -- ��������� ����� � <��������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    -- ��������� <�������� ���� ���.>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Retail(), ioId, TRIM (inRetailName_inf));
    
    --������� ������������� ����� 
    SELECT
        Movement_Promo.PriceListId
       ,Movement_Promo.PriceListName
    INTO
        outPriceListId
       ,outPriceListName
    FROM
        Movement_Promo_View AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 01.08.17         * add inRetailName_inf
 17.11.15                                                                    *inContractId
 31.10.15                                                                    *
*/
