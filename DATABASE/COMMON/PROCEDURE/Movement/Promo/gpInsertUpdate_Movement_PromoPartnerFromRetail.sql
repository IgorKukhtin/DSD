-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartnerFromRetail (
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- ���� ������� <�������� ����>
    TVarChar     -- ������ ������������

);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoPartnerFromRetail(
    IN inParentId               Integer    , -- ���� ������������� ������� <�������� �����>
    IN inRetailId               Integer    , -- ���� ������� <�������� ����>
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS
VOID
AS
$BODY$
   DECLARE vbUserId Integer;
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

    -- ��������� �������� �� ��������
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION '������. �������� �� �������� ��� �� ��������� � ��������� <�� ��������>.';
    END IF;
    -- ������� ���� ��������� � ������
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
                ioId              := 0, -- ���� ������� <������� ��� ��������� �����>
                inParentId        := inParentId , -- ���� ������������� ������� <�������� �����>
                inPartnerId       := ObjectLink_Partner_Juridical.ObjectId, -- ���� ������� <���������� / �� ���� / �������� ����>
                inContractId      := 0, -- ���� ������� <��������>
                inComment         := '', -- ����������
                inRetailName_inf  := '', -- ����.���� ���.
                inSession         := inSession)  -- ������ ������������
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
            
    --������� ���������, ������� �� ������������ �������� ����
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
            gpMovement_PromoPartner_SetErased(inMovementId := Movement_PromoPartner.Id, -- ���� ������� <������� ���������>
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 04.12.15                                                                    *inContractId
*/
