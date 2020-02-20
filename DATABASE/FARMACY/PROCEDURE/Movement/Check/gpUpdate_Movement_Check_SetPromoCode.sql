-- Function: gpUpdate_Movement_Check_SetPromoCode()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SetPromoCode (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SetPromoCode(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inPromoCodeId         Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbMovementID Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;

   SELECT MovementLinkObject_Unit.ObjectId
   INTO vbUnitId
   FROM Movement
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
   WHERE Id = inId;

    -- ���������� �����
   SELECT MovementItem.MovementId
   INTO vbMovementID
   FROM MovementItem
   WHERE MovementItem.Id = inPromoCodeId;

   IF NOT EXISTS(SELECT Movement_Promo.Id
        FROM Movement AS Movement_Promo

           INNER JOIN MovementDate AS MovementDate_StartPromo
                                  ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                 AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
           INNER JOIN MovementDate AS MovementDate_EndPromo
                                  ON MovementDate_EndPromo.MovementId = Movement_Promo.Id
                                 AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
        WHERE Movement_Promo.ID = vbMovementID
          AND Movement_Promo.DescId = zc_Movement_PromoCode()
          AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
          AND MovementDate_StartPromo.ValueData <= current_date
          AND MovementDate_EndPromo.ValueData >= current_date)
   THEN
     RAISE EXCEPTION '������. ����� ��������� ��� ���������.';
   END IF;
   
    -- ���� ���� ���� �� ���� ����, �� ��������� ������ �� ������� ���� � ���� ������
    IF EXISTS(SELECT * 
              FROM Movement AS Promo 
                  INNER JOIN MovementItem PromoUnit ON Promo.id = PromoUnit.movementid AND promounit.descid = zc_MI_Child()
              WHERE Promo.id = vbMovementID AND PromoUnit.objectid IS NOT NULL) THEN
        
        IF NOT EXISTS(SELECT * 
                      FROM Movement AS Promo
                          INNER JOIN MovementItem PromoUnit ON Promo.id = PromoUnit.movementid AND promounit.descid = zc_MI_Child()
                      WHERE Promo.id = vbMovementID AND promounit.amount > 0 AND PromoUnit.objectid = vbUnitId) THEN
            RAISE EXCEPTION '������ ������������� �� ������ � ������ ����������� � �����';      
        END IF;    
    END IF;
   

   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), inId, inPromoCodeId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.02.20                                                       *
*/
