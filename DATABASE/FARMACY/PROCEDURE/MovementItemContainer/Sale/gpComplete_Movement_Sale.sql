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
  DECLARE vbNDS         TVarChar;
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


    IF (SELECT MovementLinkObject_SPKind.ObjectId AS SPKindId
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                          ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                         AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
        WHERE Movement.Id = inMovementId) = zc_Enum_SPKind_1303()                    -- ������������� 1303
    THEN
        IF (vbOperDate < CURRENT_DATE) AND 
           NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) AND
           (vbUserId NOT IN (3, 235009, 183242 ))  -- ������ ������ �. �. (ID 235009) ����� ��������� ���. ������ ������
        THEN
            RAISE EXCEPTION '������. ��������� ���� ��������� �� �������.';
        END IF;
    END IF;

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
       , MI_Sale AS(SELECT MI_Sale.GoodsId
                         , MI_Sale.GoodsName
                         , MI_Sale.NDS
                         , MI_Sale.NDSKindId
                         , SUM(MI_Sale.Amount)                                                      AS Amount
                         , SUM(COALESCE(MI_Sale.Amount,0) + COALESCE(HeldBy.Amount, 0))             AS Saldo
                    FROM MovementItem_Sale_View AS MI_Sale
                         LEFT OUTER JOIN HeldBy AS HeldBy
                                                ON MI_Sale.ID = HeldBy.MovementItemId
                    WHERE MI_Sale.MovementId = inMovementId
                      AND MI_Sale.isErased = FALSE
                    GROUP BY MI_Sale.GoodsId
                           , MI_Sale.GoodsName
                           , MI_Sale.NDS
                           , MI_Sale.NDSKindId
                    HAVING SUM(COALESCE(MI_Sale.Amount,0) + COALESCE(HeldBy.Amount, 0)) > 0)
       , tmpContainer AS(SELECT MI_Sale.GoodsId
                              , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                       OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                     THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                              , SUM(Container.Amount)                                                          AS Amount

                         FROM MI_Sale AS MI_Sale

                              LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                                       AND Container.WhereObjectId = vbUnitId
                                                       AND Container.DescId = zc_Container_Count()
                                                       AND Container.Amount > 0
                              LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
                              LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                              -- ������
                              INNER JOIN ContainerLinkObject AS CLI_MI
                                                             ON CLI_MI.ContainerId = Container.Id
                                                            AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                              INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                              -- ������� �������
                              INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                              INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                              LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                              ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MovementItem.MovementId)
                                                             AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                           ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MovementItem.MovementId)
                                                          AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                          GROUP BY MI_Sale.GoodsId
                                 , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                          OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                        THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END
                          HAVING SUM(MI_Sale.Amount) >  0)

    SELECT MI_Sale.GoodsName
         , COALESCE(MI_Sale.Amount,0)
         , zfConvert_FloatToString (MI_Sale.NDS)||'%'
         , COALESCE(Container.Amount,0)
    INTO
        vbGoodsName
      , vbAmount
      , vbNDS
      , vbSaldo
    FROM MI_Sale AS MI_Sale

        LEFT OUTER JOIN tmpContainer AS Container
                                     ON Container.GoodsId = MI_Sale.GoodsId
                                    AND Container.NDSKindId =  MI_Sale.NDSKindId
    WHERE MI_Sale.Saldo > COALESCE(Container.Amount, 0);

    IF (COALESCE(vbGoodsName,'') <> '')
    THEN
        RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ������� <%> c ��� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbNDS, vbSaldo;
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
 11.05.20                                                                       *               
 01.08.19                                                                       *
 05.06.18         *
 03.04.17         *
 13.10.15                                                         *
 */
