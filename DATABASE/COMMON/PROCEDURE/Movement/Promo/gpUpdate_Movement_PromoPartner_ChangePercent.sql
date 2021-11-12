-- Function: gpUpdate_Movement_PromoPartner_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PromoPartner_ChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_PromoPartner_ChangePercent(
    IN inMovementId            Integer   , -- ���� ������� <��������>
   OUT outChangePercent        TFloat    , --
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   --DECLARE vbChangePercent TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_ChangePercent());
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

     -- zc_MovementFloat_ChangePercent - ������  �� ��������� zc_Movement_PromoPartner, ���� ��� �� ������ - ����� 0, ���� ��������� ���, �� ������ ������ ���� ����������
     -- ����. �������
     CREATE TEMP TABLE _tmpChangePercent (ChangePercent TFloat, Count Integer) ON COMMIT DROP;

     -- ���������� ������ �� ���������. 
     INSERT INTO _tmpChangePercent (ChangePercent, Count)
     SELECT DISTINCT COALESCE (View_ContractCondition_Value.ChangePercent,0) AS ChangePercent
          , 1 AS Count
     FROM Movement AS Movement_Promo 
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object_ContractCondition_ValueView AS View_ContractCondition_Value ON View_ContractCondition_Value.ContractId = MovementLinkObject_Contract.ObjectId
     WHERE Movement_Promo.DescId = zc_Movement_PromoPartner()
       AND Movement_Promo.ParentId = inMovementId
       AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
       AND View_ContractCondition_Value.ChangePercent <> 0
    ;


     -- ���� ���� "��� ����� % ������", ����� zc_MovementFloat_ChangePercent = 0" 
     IF EXISTS (SELECT MI_Child.ObjectId 
                FROM MovementItem AS MI_Child 
                WHERE MI_Child.MovementId = inMovementId 
                  AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff()
                  AND MI_Child.isErased = FALSE LIMIT 1)
     THEN 
          outChangePercent:=0;
     ELSE
         -- ���� ��������� ���, � ������ ������ �� ������
         IF (SELECT SUM (tmp.Count) FROM _tmpChangePercent AS tmp) > 1
         THEN 
              -- ������
              RAISE EXCEPTION '������.� �������� ������� �������� � ������ �������.';
         ELSE
              outChangePercent := COALESCE ((SELECT tmp.ChangePercent FROM _tmpChangePercent AS tmp LIMIT 1), 0) ::TFloat;
         END IF;
        
     END IF;
      
    
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inMovementId, outChangePercent);


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.07.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_PromoPartner_ChangePercent (inMovementId:= 2641111, inSession:= zfCalc_UserAdmin())
