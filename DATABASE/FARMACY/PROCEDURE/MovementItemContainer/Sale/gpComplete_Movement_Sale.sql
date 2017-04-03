-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale  (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Sale  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
  DECLARE vbUnitId    Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbInvNumberSP TVarChar;
  DECLARE vbPartnerMedicalId Integer;
BEGIN
    vbUserId:= inSession;
    vbGoodsName := '';

    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    SELECT Movement_Sale.OperDate,
           Movement_Sale.UnitId,
           Movement_Sale.InvNumberSP,
           Movement_Sale.PartnerMedicalId
    INTO vbOperDate,
         vbUnitId,
         vbInvNumberSP,
         vbPartnerMedicalId
    FROM Movement_Sale_View AS Movement_Sale
    WHERE Movement_Sale.Id = inMovementId;

    -- ���� ��������� ����������� ������ ��������� � ������� �����.
    -- ���� �������� �������� ���-� ������ ����� - ������ ��������������
    IF (vbOperDate > CURRENT_DATE) 
    THEN
        RAISE EXCEPTION '������. ��������� ���� ��������� �� �������.';
    END IF;

    
    IF EXISTS(SELECT Movement.Id
              FROM Movement 
                   INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                           ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                          AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                          AND MovementLinkObject_PartnerMedical.ObjectId = vbPartnerMedicalId
                   INNER JOIN MovementString AS MovementString_InvNumberSP
                           ON MovementString_InvNumberSP.MovementId = Movement.Id
                          AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                          AND MovementString_InvNumberSP.ValueData = vbInvNumberSP
              WHERE Movement.DescId = zc_Movement_Sale()
                AND Movement.StatusId = zc_Enum_Status_Complete())
        THEN
            RAISE EXCEPTION '������. ����� ������� ����� <%> ��� ����������', vbInvNumberSP;
    END IF;



    --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
    SELECT 
        MI_Sale.GoodsName
      , COALESCE(MI_Sale.Amount,0)
      , COALESCE(SUM(Container.Amount),0) 
    INTO 
        vbGoodsName
      , vbAmount
      , vbSaldo 
    FROM
        Movement_Sale_View AS Movement_Sale
        INNER JOIN MovementItem_Sale_View AS MI_Sale
                                          ON MI_Sale.MovementId = Movement_Sale.Id
        LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                 AND Container.WhereObjectId = Movement_Sale.UnitId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE
        Movement_Sale.Id = inMovementId AND
        MI_Sale.isErased = FALSE
    GROUP BY 
        MI_Sale.GoodsId
      , MI_Sale.GoodsName
      , MI_Sale.Amount
    HAVING 
        COALESCE(MI_Sale.Amount,0) > COALESCE(SUM(Container.Amount),0);
    
    IF (COALESCE(vbGoodsName,'') <> '') 
    THEN
        RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;

    /*IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnitId
                  INNER JOIN MovementItem AS MI_Sale
                                          ON MI_Inventory.ObjectId = MI_Sale.ObjectId
                                         AND MI_Sale.DescId = zc_MI_Master()
                                         AND MI_Sale.IsErased = FALSE
                                         AND MI_Sale.Amount > 0
                                         AND MI_Sale.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION '������. �� ������ ��� ����� ������� ���� �������� ��������� ����� ���� ������� �������. ���������� ��������� ���������!';
    END IF;*/
  
    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSaleExactly (inMovementId);
    -- ���������� ��������
    PERFORM lpComplete_Movement_Sale(inMovementId, -- ���� ���������
                                     vbUserId);    -- ������������  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 03.04.17         *
 13.10.15                                                         *
 */