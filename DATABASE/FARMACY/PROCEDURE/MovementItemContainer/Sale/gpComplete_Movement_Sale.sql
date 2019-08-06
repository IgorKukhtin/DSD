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
  DECLARE vbOperDateSP  TDateTime;
  DECLARE vbPartnerMedicalId Integer;
  DECLARE vbMedicSPId   Integer;
  DECLARE vbMemberSPId  Integer;
  DECLARE vbCount       Integer;
  DECLARE vbIsDeferred  Boolean;
BEGIN
    vbUserId:= inSession;
    vbGoodsName := '';

    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    SELECT Movement_Sale.OperDate,
           Movement_Sale.UnitId,
           Movement_Sale.InvNumberSP,
           Movement_Sale.OperDateSP ,
           Movement_Sale.PartnerMedicalId,
           Movement_Sale.MedicSPId,
           Movement_Sale.MemberSPId,
           COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
           INTO vbOperDate,
                vbUnitId,
                vbInvNumberSP,
                vbOperDateSP,
                vbPartnerMedicalId,
                vbMedicSPId,
                vbMemberSPId,
                vbIsDeferred
    FROM Movement_Sale_View AS Movement_Sale
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement_Sale.Id = inMovementId;

    -- ���� ��������� ����������� ������ ��������� � ������� �����.
    -- ���� �������� �������� ���-� ������ ����� - ������ ��������������
    IF (vbOperDate > CURRENT_DATE)
    THEN
        RAISE EXCEPTION '������. ��������� ���� ��������� �� �������.';
    END IF;

    -- �������� ���� ������� ���.���. ����� ��������� ���������� ��������� ����������
    IF COALESCE (vbPartnerMedicalId, 0) <> 0
    THEN
        IF vbOperDateSP > vbOperDate
        THEN
            RAISE EXCEPTION '������. ���� ������� ����� ���� ���������.';
        END IF;
        IF COALESCE (vbInvNumberSP, '') = ''
        THEN
            RAISE EXCEPTION '������. �� �������� �������� ����� �������.';
        END IF;
        IF COALESCE (vbMedicSPId, 0) = 0
        THEN
            RAISE EXCEPTION '������. �� �������� �������� ��� �����.';
        END IF;
        IF COALESCE (vbMemberSPId, 0) = 0
        THEN
            RAISE EXCEPTION '������. �� �������� �������� ��� ��������.';
        END IF;

    END IF;

    IF COALESCE (vbInvNumberSP,'') <>''
       THEN
           IF EXISTS(SELECT Movement.Id
                     FROM Movement
                      INNER JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                              ON MovementLinkObject_MedicSP.MovementId = Movement.Id
                             AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
                             AND MovementLinkObject_MedicSP.ObjectId = vbMedicSPId

                      INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                              ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                             AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                             AND MovementLinkObject_PartnerMedical.ObjectId = vbPartnerMedicalId
                      INNER JOIN MovementString AS MovementString_InvNumberSP
                              ON MovementString_InvNumberSP.MovementId = Movement.Id
                             AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                             AND MovementString_InvNumberSP.ValueData = vbInvNumberSP
                      INNER JOIN MovementDate AS MovementDate_OperDateSP
                              ON MovementDate_OperDateSP.MovementId = Movement.Id
                             AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
                             AND MovementDate_OperDateSP.ValueData = vbOperDateSP
                 WHERE Movement.DescId = zc_Movement_Sale()
                   AND Movement.StatusId = zc_Enum_Status_Complete())
          THEN
              RAISE EXCEPTION '������. ����� ������� ����� <%> ��� ����������', vbInvNumberSP;
          END IF;
    END IF;

    --�������� �� ������ ���-�� ��������� � ���������. � ������������� ���. ����� ������
    SELECT MAX (case when  COALESCE (MI_Sale.Amount, 0) = 0 THEN MI_Sale.GoodsName else '' End) AS GoodsName
         , Count (*) AS Count_str
     INTO vbGoodsName, vbCount
    FROM MovementItem_Sale_View AS MI_Sale
    WHERE MI_Sale.MovementId = inMovementId
      AND MI_Sale.isErased = FALSE;

    IF (COALESCE (vbGoodsName, '') <> '')
    THEN
        RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ������� ����� 0.', vbGoodsName;
    END IF;
    IF (COALESCE (vbCount, 0) = 0)
    THEN
        RAISE EXCEPTION '������. �� ������� ������ ��� �������';
    END IF;
    -- ��������, ���� ��� SP ��������, �� ������ ���� 1 ������
    IF COALESCE (vbInvNumberSP,'') <>'' AND COALESCE (vbCount, 0) > 1
    THEN
        RAISE EXCEPTION '������.� ��������� ����� ���� ������ 1 ��������.';
    END IF;

    -- ��������� ����� ��������� ������ ��� ��������
    IF vbIsDeferred = TRUE
    THEN
      WITH HeldBy AS(SELECT MovementItemContainer.MovementItemId   AS MovementItemId
                          , SUM(- MovementItemContainer.Amount)      AS Amount
                     FROM MovementItemContainer
                     WHERE MovementItemContainer.MovementId = inMovementId
                     GROUP BY MovementItemContainer.MovementItemId)

      SELECT Object_Goods.ValueData
           , HeldBy.Amount
           , COALESCE(MovementItem.Amount,0)
      INTO
          vbGoodsName
        , vbAmount
        , vbSaldo
      FROM HeldBy AS HeldBy
          LEFT OUTER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                      AND MovementItem.IsErased = FALSE
                                      AND COALESCE(MovementItem.Amount,0) > 0
                                      AND MovementItem.ID = HeldBy.MovementItemId
          LEFT OUTER JOIN Object AS Object_Goods
                                 ON Object_Goods.Id = MovementItem.ObjectId
      WHERE HeldBy.Amount > COALESCE(MovementItem.Amount,0);

      IF (COALESCE(vbGoodsName,'') <> '')
      THEN
          RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ��������� <%> ������, ��� �������� <%>. ���������� �������� ������� ����� ����������� ���������.', vbGoodsName, vbAmount, vbSaldo;
      END IF;

    END IF;

    --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
    WITH HeldBy AS(SELECT MovementItemContainer.MovementItemId   AS MovementItemId
                        , SUM(- MovementItemContainer.Amount)      AS Amount
                   FROM MovementItemContainer
                   WHERE MovementItemContainer.MovementId = inMovementId
                   GROUP BY MovementItemContainer.MovementItemId)

    SELECT MI_Sale.GoodsName
         , COALESCE(MI_Sale.Amount,0)
         , COALESCE(SUM(Container.Amount),0) + COALESCE(HeldBy.Amount,0)
    INTO
        vbGoodsName
      , vbAmount
      , vbSaldo
    FROM MovementItem_Sale_View AS MI_Sale
        LEFT OUTER JOIN HeldBy AS HeldBy
                               ON MI_Sale.ID = HeldBy.MovementItemId
        LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE MI_Sale.MovementId = inMovementId
      AND MI_Sale.isErased = FALSE
    GROUP BY MI_Sale.GoodsId
           , MI_Sale.GoodsName
           , MI_Sale.Amount
           , HeldBy.Amount
    HAVING (COALESCE (MI_Sale.Amount, 0) - COALESCE(HeldBy.Amount,0)) > COALESCE (SUM (Container.Amount) ,0);

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

    IF vbIsDeferred = TRUE
    THEN
       -- ��������� �������
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, FALSE);
    END IF;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSaleExactly (inMovementId);
    -- ���������� ��������
    PERFORM lpComplete_Movement_Sale(inMovementId, -- ���� ���������
                                     0,            -- ���� ���������� ���������
                                     vbUserId);    -- ������������

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete()
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  ������ �.�.
 01.08.19                                                                       *
 05.06.18         *
 03.04.17         *
 13.10.15                                                         *
 */