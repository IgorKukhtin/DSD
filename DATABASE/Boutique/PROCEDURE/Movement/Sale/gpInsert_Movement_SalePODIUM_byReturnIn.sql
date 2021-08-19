-- Function: gpInsert_Movement_Sale_byReturnIn()

DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_byReturnIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_byReturnIn(
    IN inMovementId_ReturnIn       Integer  ,  -- ���� ��������� �������
   OUT outMovementId               Integer  ,
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);


     -- �������� ����� �� �������� ����� �������, ��� ������ ����
     --PERFORM lpCheckUnit_byUser (inUnitId_by:= inFromId, inUserId:= vbUserId);


     -- ������������ ���������� � ���.
     vbInvNumber:= CAST (NEXTVAL ('Movement_Sale_seq') AS TVarChar);

     -- ��������� <��������>
     outMovementId := lpInsertUpdate_Movement_Sale (ioId                := 0
                                                  , inInvNumber         := vbInvNumber
                                                  , inOperDate          := CURRENT_DATE
                                                  , inFromId            := MovementLinkObject_To.ObjectId
                                                  , inToId              := MovementLinkObject_From.ObjectId
                                                  , inComment           := ''    ::TVarChar
                                                  , inisOffer           := FALSE ::Boolean
                                                  , inUserId            := vbUserId
                                                   )
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

     WHERE Movement.Id = inMovementId_ReturnIn
       AND Movement.DescId = zc_Movement_ReturnIn();
     
     
     -- ������ ���.
     PERFORM gpInsertUpdate_MovementItem_SalePodium(ioId                 := 0               :: Integer  -- ���� ������� <������� ���������>
                                                  , inMovementId         := outMovementId   :: Integer  -- ���� ������� <��������>
                                                  , ioGoodsId            := MI_Master.ObjectId  :: Integer  -- *** - �����
                                                  , inPartionId          := MI_Master.PartionId :: Integer  -- ������
                                                  , ioDiscountSaleKindId := 0                   :: Integer  -- *** - ��� ������ ��� �������
                                                  , inIsPay              := FALSE               :: Boolean  -- �������� � �������
                                                  , ioAmount             := MIFloat_AmountPartner.ValueData :: TFloat   -- ����������
                                                  , ioChangePercent      := 0                   :: TFloat    -- *** - % ������
                                                  , ioChangePercentNext  := 0                   :: TFloat    -- *** - % ������
                                                  , ioSummChangePercent  := 0                   :: TFloat    -- *** - �������������� ������ � ������� ���
                                                  , ioSummChangePercent_curr := 0               :: TFloat    -- *** - �������������� ������ � ������� � ������***
                                                  , ioOperPriceList      := MIFloat_OperPriceList.ValueData :: TFloat  -- *** - ���� ���� ���
                                                  , inBarCode_partner    := ''                  :: TVarChar   -- �����-��� ����������
                                                  , inBarCode_old        := ''                  :: TVarChar   -- �����-��� �� �������� ����� - old
                                                  , inComment            := ''                  :: TVarChar   -- ����������
                                                  , inSession            := inSession       :: TVarChar
                                                  )
     FROM MovementItem AS MI_Master
          INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                       ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                      AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
     WHERE MI_Master.MovementId = inMovementId_ReturnIn
       AND MI_Master.DescId = zc_MI_Master()
       AND MI_Master.isErased = FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.05.17         *
 */

-- ����
-- SELECT * FROM gpInsert_Movement_Sale_byReturnIn 