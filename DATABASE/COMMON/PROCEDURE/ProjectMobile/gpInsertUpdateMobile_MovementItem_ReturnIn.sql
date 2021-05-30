-- Function: gpInsertUpdateMobile_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_ReturnIn (TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_ReturnIn(
    IN inGUID          TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inMovementGUID  TVarChar  , -- ���������� ���������� ������������� ���������
    IN inGoodsId       Integer   , -- ������
    IN inGoodsKindId   Integer   , -- ���� �������
    IN inAmount        TFloat    , -- ����������
    IN inPrice         TFloat    , -- ����
    IN inChangePercent TFloat    , -- (-)% ������ (+)% �������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbPrice_find  TFloat;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);


      -- ����� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
           , Movement_ReturnIn.StatusId
      INTO vbMovementId
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_ReturnIn
                         ON Movement_ReturnIn.Id = MovementString_GUID.MovementId
                        AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;
      -- ��������
      IF COALESCE (vbMovementId, 0) = 0 THEN
         RAISE EXCEPTION '������. �� ��������� ����� ���������.';
      END IF; 

      vbPriceListId:= (SELECT tmp.PriceListId
                       FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                           , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                           , inMovementDescId := zc_Movement_ReturnIn()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                           , inDayPrior_PriceReturn:= 0
                                                           , inIsPrior        := FALSE -- !!!���������� �� ������ ���!!!
                                                           , inOperDatePartner_order:= NULL :: TDateTime
                                                           ) AS tmp);
      -- ��������� ������
       vbPrice_find:= (SELECT tmp.ReturnPrice FROM gpSelectMobile_Object_PriceListItems_test (inPriceListId:= vbPriceListId, ingoodsId:= ingoodsId, inSession := inSession) AS tmp);
      IF vbPrice_find > 0
      THEN 
           inPrice:= vbPrice_find;
      END IF;
      

      -- ����� Id ������ ��������� �� GUID
      vbId:= (SELECT MIString_GUID.MovementItemId 
              FROM MovementItemString AS MIString_GUID
                   JOIN MovementItem AS MovementItem_ReturnIn
                                     ON MovementItem_ReturnIn.Id         = MIString_GUID.MovementItemId
                                    AND MovementItem_ReturnIn.DescId     = zc_MI_Master()
                                    AND MovementItem_ReturnIn.MovementId = vbMovementId
              WHERE MIString_GUID.DescId    = zc_MIString_GUID() 
                AND MIString_GUID.ValueData = inGUID
             );


      -- !!! �������� - 04.07.17 !!!
      IF vbStatusId = zc_Enum_Status_Complete() AND vbId <> 0
      THEN
           -- !!! �������� !!!
           RETURN (vbId);
      END IF;
      -- !!! �������� - 04.07.17 !!!


      IF vbStatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
      THEN
           IF vbStatusId = zc_Enum_Status_Erased()
           THEN
                -- ����������� ��������
                PERFORM lpUnComplete_Movement (inMovementId:= vbMovementId, inUserId:= vbUserId);
           END IF;

           -- ���� ���� ���-��
           IF inAmount <> 0
           THEN
                -- !!! �������� ��� �����
                IF vbUserId = 5 AND inAmount = 2.0
                THEN
                     RAISE EXCEPTION '������ ������ ��������� ���������� ������ ������ ����. :)';
                END IF; 
                -- !!! �������� ��� �����

                -- ��������� ������� ��������
                SELECT ioId INTO vbId
                FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := vbId
                                                         , inMovementId         := vbMovementId
                                                         , inGoodsId            := inGoodsId
                                                         , inAmount             := inAmount
                                                         , inAmountPartner      := inAmount
                                                         , ioPrice              := inPrice
                                                         , ioCountForPrice      := 0.0
                                                         , inHeadCount          := 0.0
                                                         , inMovementId_Partion := 0
                                                         , inPartionGoods       := ''
                                                         , inGoodsKindId        := inGoodsKindId
                                                         , inAssetId            := 0
                                                         , ioMovementId_Promo   := NULL
                                                         , ioChangePercent      := NULL
                                                         , inIsCheckPrice       := TRUE
                                                         , inUserId             := vbUserId
                                                          );
     
                -- ��������� �������� <���������� ���������� �������������>
                PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, inGUID);
           END IF;

      END IF;

      -- ��������� �������� <����/����� ���������� � ���������� ����������>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, CURRENT_TIMESTAMP);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 22.03.17                                                        *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_MovementItem_ReturnIn (inGUID:= '{A2F91EC1-9A34-4A77-A145-5A3290DFDD70}'
                                                        , inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}'
                                                        , inGoodsId:= 8213
                                                        , inGoodsKindId:= 8348
                                                        , inAmount:= 3
                                                        , inPrice:= 45.89 
                                                        , inChangePercent:= -5.0  
                                                        , inSession:= zfCalc_UserAdmin()
                                                         );
*/