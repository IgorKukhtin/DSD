-- Function: gpInsertUpdateMobile_MovementItem_ReturnIn()

--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_ReturnIn (TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_ReturnIn (TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_ReturnIn(
    IN inGUID          TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inMovementGUID  TVarChar  , -- ���������� ���������� ������������� ���������
    IN inGoodsId       Integer   , -- ������
    IN inGoodsKindId   Integer   , -- ���� �������
    IN inAmount        TFloat    , -- ����������
    IN inPrice         TFloat    , -- ����
    IN inChangePercent TFloat    , -- (-)% ������ (+)% �������
    IN inSubjectDocId  Integer   , -- ��������� ��� �����������
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
      vbPrice_find:= (SELECT DISTINCT tmp.ReturnPrice FROM gpSelectMobile_Object_PriceListItems_test (inPriceListId:= vbPriceListId, inGoodsId:= inGoodsId, inGoodsKindId:= inGoodsKindId, inSession := inSession) AS tmp);

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
                                                         , inCount              := 0.0 
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
                                                          
                -- ��������� <������� ��������� ������ ���� ����>
                IF EXISTS(SELECT MovementItem.Id
                          FROM MovementItem
                         
                               LEFT JOIN MovementItem AS MI_Detail ON MI_Detail.MovementId = vbMovementId
                                                                  AND MI_Detail.DescId     = zc_MI_Detail()
                                                                  AND MI_Detail.ParentId   = MovementItem.Id

                               LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                                                ON MILO_SubjectDoc.MovementItemId = MI_Detail.Id
                                                               AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
                                                                 
                          WHERE MovementItem.MovementId = vbMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.Id         = vbId
                            AND (COALESCE(inSubjectDocId, 0) <> COALESCE (MILO_SubjectDoc.ObjectId, 0)))
                THEN
                   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_SubjectDoc()    
                         , lpInsertUpdate_MovementItem (MI_Detail.Id, zc_MI_Detail(), MovementItem.ObjectId, vbMovementId, MovementItem.Amount, MovementItem.Id)
                         , COALESCE(inSubjectDocId, 0))
                   FROM MovementItem
                   
                        LEFT JOIN MovementItem AS MI_Detail ON MI_Detail.MovementId = vbMovementId
                                                           AND MI_Detail.DescId     = zc_MI_Detail()
                                                           AND MI_Detail.ParentId   = MovementItem.Id

                        LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                                         ON MILO_SubjectDoc.MovementItemId = MI_Detail.Id
                                                        AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
                                                           
                   WHERE MovementItem.MovementId = vbMovementId
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.Id   = vbId
                     AND (COALESCE(inSubjectDocId, 0) <> COALESCE (MILO_SubjectDoc.ObjectId, 0));
                     
                   -- ��������� ��������
                   PERFORM lpInsert_MovementItemProtocol (MI_Detail.Id, vbUserId, TRUE)
                   FROM MovementItem
                           
                         LEFT JOIN MovementItem AS MI_Detail ON MI_Detail.MovementId = vbMovementId
                                                            AND MI_Detail.DescId     = zc_MI_Detail()
                                                            AND MI_Detail.ParentId   = MovementItem.Id

                   WHERE MovementItem.MovementId = vbMovementId
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.Id         = vbId;
                     
                END IF;
     
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
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.   ������ �.�.
 22.11.23                                                                       *
 22.03.17                                                        *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_MovementItem_ReturnIn (inGUID:= '{A2F91EC1-9A34-4A77-A145-5A3290DFDD71}'
                                                        , inMovementGUID:= '{5842A59B-C8B8-4C27-B02B-CA51EE449C91}'
                                                        , inGoodsId:= 8213
                                                        , inGoodsKindId:= 8348
                                                        , inAmount:= 3
                                                        , inPrice:= 45.89 
                                                        , inChangePercent:= -5.0  
                                                        , inSubjectDocId:= 11
                                                        , inSession:= zfCalc_UserAdmin()
                                                         );*/