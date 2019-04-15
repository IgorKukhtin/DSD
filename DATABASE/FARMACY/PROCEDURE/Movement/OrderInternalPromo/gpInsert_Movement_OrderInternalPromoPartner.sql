-- Function: gpInsertUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpInsert_Movement_OrderInternalPromoPartner (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_Movement_OrderInternalPromoPartner(
    IN inParentId              Integer    , -- ������ ��������  ������ ����������(������-������)
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
       
    PERFORM gpInsertUpdate_Movement_OrderInternalPromoPartner (0, inParentId, tmp.JuridicalId, '', inSession)
    FROM 
        (SELECT Movement.Id                              AS Id
              , MovementLinkObject_Juridical.ObjectId    AS JuridicalId
         FROM Movement 
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                           ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
         WHERE Movement.ParentId = inParentId
           AND Movement.DescId = zc_Movement_OrderInternalPromoPartner()
           AND Movement.StatusId <> zc_Enum_Status_Erased()
         ) AS tmpMI
       ;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.19         *
*/