-- Function: gpInsert_Movement_CurrencyAll_Load()

DROP FUNCTION IF EXISTS gpInsert_Movement_CurrencyAll_Load (TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_CurrencyAll_Load(
    IN inOperDate              TDateTime ,
    IN inAmount                TFloat    , -- ���-��
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbCurrencyId     Integer;
   DECLARE vbCurrencyEURId  Integer;
   DECLARE vbMovementId     Integer;
   DECLARE vbCurrencyValue  TFloat;
   DECLARE vbParValue       TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- ������ ����� ������ ��� ���� ���� <> 0
     IF COALESCE (inAmount, 0) = 0
     THEN
         -- !!!�����!!!
         RETURN;
     END IF;

     -- �� ������
     vbCurrencyId := zc_Currency_Basis();
     vbCurrencyEURId := zc_Currency_EUR();

/*     IF COALESCE (vbCurrencyId,0) = 0
     THEN 
         RAISE EXCEPTION '������.�� ������� <������> <%>.', inCurrencyName;
     END IF;
           */
           

     -- ���������� ���� �� ���� 
      SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
             INTO vbCurrencyValue, vbParValue
      FROM lfSelect_Movement_Currency_byDate (inOperDate      := inOperDate
                                            , inCurrencyFromId:= zc_Currency_Basis()
                                            , inCurrencyToId  := vbCurrencyEURId
                                             ) AS tmp;

     -- ���� ���� �������� ���� ��. ��������
     IF COALESCE (vbCurrencyValue,0) = inAmount AND COALESCE (vbParValue,1) = 1
     THEN 
          RETURN;
     END IF;
                    
     -- ������� ����� �������� �� ����� ����, ������, ���� ������
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.ObjectId = vbCurrencyId  --���
                                                  AND MovementItem.Amount = inAmount        -- ����
                           INNER JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
                                                       AND MIFloat_ParValue.ValueData = 1
                           INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                             ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                                                            AND MILinkObject_CurrencyTo.ObjectId = vbCurrencyEURId 
                      WHERE Movement.DescId = zc_Movement_Currency()
                        AND Movement.OperDate = inOperDate
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                      LIMIT 1);

     -- ���� �� ����� ������ ���. �������
     IF COALESCE (vbMovementId, 0) = 0
     THEN
         -- ��������� <��������>
         PERFORM gpInsertUpdate_Movement_Currency (ioId                := 0 :: Integer
                                                 , ioInvNumber         := CAST (NEXTVAL ('Movement_Currency_seq') AS TVarChar) ::TVarChar
                                                 , inOperDate          := inOperDate :: TDateTime
                                                 , inAmount            := inAmount   :: TFloat
                                                 , inParValue          := 1          :: TFloat
                                                 , inComment           := '��������' :: TVarChar
                                                 , inCurrencyFromId    := vbCurrencyId
                                                 , inCurrencyToId      := vbCurrencyEURId
                                                 , inSession           := inSession  :: TVarChar
                                                  );
                                      
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.20         *
*/

-- ����
