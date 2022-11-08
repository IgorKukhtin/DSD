-- Function: gpUpdate_Movement_IncomeFuel_ChangePrice()

DROP FUNCTION IF EXISTS gpUpdate_Movement_IncomeFuel_ChangePrice (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_IncomeFuel_ChangePrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_IncomeFuel_ChangePrice(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbStatusId    Integer;
   DECLARE vbChangePrice TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());


     -- ������
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_ChangePriceUser() AND MB.ValueData = TRUE)
     THEN

         -- ��������� �� ���������
         SELECT Movement.StatusId, MAX (View_ContractCondition_Value.ChangePrice) AS ChangePrice
                INTO vbStatusId, vbChangePrice
         FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                   AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
             LEFT JOIN Object_ContractCondition_ValueView AS View_ContractCondition_Value
                                                          ON View_ContractCondition_Value.ContractId = MovementLinkObject_Contract.ObjectId
                                                         AND MovementDate_OperDatePartner.ValueData BETWEEN View_ContractCondition_Value.StartDate AND View_ContractCondition_Value.EndDate
         WHERE Movement.Id = inId
         GROUP BY Movement.StatusId
        ;


         -- ��������� �������� <������ � ����>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePrice(), inId, vbChangePrice);

         -- ����������� �������� ����� �� ���������
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

         -- ������������ ���.
         IF vbStatusId = zc_Enum_Status_Complete()
         THEN
            PERFORM gpReComplete_Movement_Income (inMovementId := inId, inislastcomplete := 'True',  inSession := inSession);
         END IF;

     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.07.16         *
 */

-- ����
-- select * from gpUpdate_Movement_IncomeFuel_ChangePrice(inId := 3946512 , inContractId := 416053 ,  inSession := '5');
