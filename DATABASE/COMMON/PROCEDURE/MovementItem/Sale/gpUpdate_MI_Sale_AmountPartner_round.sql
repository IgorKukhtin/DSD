-- Function: gpUpdate_MI_Sale_AmountPartner_round()

DROP FUNCTION IF EXISTS gpUpdate_MI_Sale_AmountPartner_round (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Sale_AmountPartner_round(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inAmount                  TFloat    , -- ���������� ������ ����� ���. ��� ����������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPriceListInId Integer;
   DECLARE vbPartnerId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_AmountPartner());

     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.Invnumber
            INTO vbStatusId, vbInvNumber 
     FROM Movement
     WHERE Movement.Id = inMovementId;
     
     --�������� ��� ������ ��������� �� 2 ��� 3 ������
     IF inAmount <> 2 AND inAmount <> 3
     THEN
         RAISE EXCEPTION '������.������� �� ������ �������� ��� ����������.';
     END IF;

     -- �������� - ���������� ������ � ����������� ����������
     IF vbStatusId <> zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������. ������ ��� ����������� ����������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


     --
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner()
                                            , MovementItem.Id
                                            , CASE WHEN inAmount = 2 THEN ROUND (MIFloat_AmountPartner.ValueData,2) 
                                                   WHEN inAmount = 3 THEN ROUND (MIFloat_AmountPartner.ValueData,3)
                                              END
                                              )
     FROM MovementItem
          INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.isErased = FALSE
       AND MovementItem.DescId = zc_MI_Master()
     ;

     -- �������� ��������
     PERFORM lpComplete_Movement_Sale (inMovementId := inId
                                     , inUserId     := vbUserId);


    --
    if vbUserId IN (5, 9457) AND 1=1
    then
        RAISE EXCEPTION '������.<%>', vbInvNumber;
    end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.03.22         *
*/
