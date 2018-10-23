-- Function: gpInsert_ProductionSeparate_Union()

DROP FUNCTION IF EXISTS gpInsert_ProductionSeparate_Union (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ProductionSeparate_Union(
   OUT outMovementId         Integer ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbmovementid_main Integer;
   DECLARE vbMemberId_user Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionSeparate());

    -- ������������ <���������� ����> - ��� ���������� ��������
    vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                      (SELECT ObjectLink_User_Member.ChildObjectId
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ObjectId = vbUserId)
                      END;

    -- ��������� ��� �����������
    CREATE TEMP TABLE tmpListDoc(MovementId Integer, OperDate TDateTime, FromId Integer, ToId Integer, PartionGoods TVarchar, num Integer) ON COMMIT DROP;
    INSERT INTO tmpListDoc(MovementId, OperDate, FromId, ToId, PartionGoods, num)
    WITH
       tmpMovement AS (SELECT Movement.Id 
                            , Movement.OperDate
                            , MovementLinkObject_From.ObjectId         AS FromId
                            , MovementLinkObject_To.ObjectId           AS ToId
                            , MovementString_PartionGoods.ValueData    AS PartionGoods
                            , CASE WHEN MovementLinkObject_From.ObjectId = MovementLinkObject_To.ObjectId THEN 1 ELSE 0 END AS num
                       FROM (SELECT DISTINCT LockUnique.KeyData ::Integer AS Id
                             FROM LockUnique 
                             WHERE LockUnique.UserId = vbUserId
                             ) AS tmp
                          LEFT JOIN Movement ON Movement.Id = tmp.Id
                                            AND Movement.DescId = zc_Movement_ProductionSeparate()
                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LEFT JOIN MovementString AS MovementString_PartionGoods
                                                   ON MovementString_PartionGoods.MovementId = Movement.Id
                                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                       )
       
       SELECT * 
       FROM tmpMovement;
       
    -- �������� ��� ���������� ������ � ��������� ����������
    IF (SELECT COUNT (DISTINCT tmpListDoc.PartionGoods) FROM tmpListDoc) > 1
    THEN
       -- ������
       RAISE EXCEPTION '������.������ ���������� ��������� � ������� ��������.';
    END IF;

    -- ���������� ��������, �� �������� ����� ����� ������ ����� (��� �� ���. ��� �� ���� = ����)
    vbMovementId_main := (SELECT MIN (tmpListDoc.MovementId) FROM tmpListDoc WHERE tmpListDoc.Num = 1);
     
    --�������� ������ ����������
    CREATE TEMP TABLE tmpListMI(MovementId Integer, DescId Integer, GoodsId Integer, GoodsKindId Integer, StorageLineId Integer, Amount TFloat, LiveWeight TFloat, HeadCount TFloat ) ON COMMIT DROP;
    INSERT INTO tmpListMI(MovementId, DescId, GoodsId, GoodsKindId, StorageLineId, Amount, LiveWeight, HeadCount)
      WITH
      tmpMI AS (SELECT MovementItem.MovementId            AS MovementId
                     , MovementItem.Id                    AS MI_Id
                     , MovementItem.DescId                AS DescId
                     , MovementItem.ObjectId    		AS GoodsId
                     , MovementItem.Amount		AS Amount
                FROM tmpListDoc
                     JOIN MovementItem ON MovementItem.MovementId = tmpListDoc.MovementId
                             --AND MovementItem.DescId     = zc_MI_Master()   -- zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
               )
    , tmpMIFloat AS (SELECT MovementItemFloat.*
                     FROM MovementItemFloat
                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                       AND MovementItemFloat.DescId IN (zc_MIFloat_LiveWeight(), zc_MIFloat_HeadCount())
                    )
    , tmpMILO AS (SELECT MovementItemLinkObject.*
                     FROM MovementItemLinkObject
                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                       AND MovementItemLinkObject.DescId IN (zc_MILinkObject_StorageLine(), zc_MILinkObject_GoodsKind())
                    )

      SELECT MovementItem.MovementId            AS MovementId
           , MovementItem.DescId                AS DescId
          
           , MovementItem.ObjectId    		AS GoodsId
           , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
           , MILinkObject_StorageLine.ObjectId  AS StorageLineId
           , MovementItem.Amount		AS Amount
           , MIFloat_LiveWeight.ValueData       AS LiveWeight
           , MIFloat_HeadCount.ValueData 	AS HeadCount

       FROM tmpListDoc
            JOIN MovementItem ON MovementItem.MovementId = tmpListDoc.MovementId
                             --AND MovementItem.DescId     = zc_MI_Master()   -- zc_MI_Child()
                             AND MovementItem.isErased   = FALSE
           
            LEFT JOIN tmpMIFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN tmpMIFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            
            LEFT JOIN tmpMILO AS MILinkObject_StorageLine
                                             ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                            AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            ;
    --        
   -- �������� ��� ���������� ����� � ������� � ��������� ����������
   IF (SELECT COUNT (DISTINCT tmpListMI.GoodsId) FROM tmpListMI WHERE tmpListMI.DescId = zc_MI_Master()) > 1
   THEN
      -- ������
      RAISE EXCEPTION '������.������ ���������� ��������� � ������� ��������.';
   END IF;

    
   -- ��� ��������� ������� 1 �������� 
   -- ��������� <��������>
   outMovementId := (SELECT lpInsertUpdate_Movement_ProductionSeparate (ioId          := 0
                                                                      , inInvNumber   := CAST (NEXTVAL ('movement_productionseparate_seq') AS TVarChar)
                                                                      , inOperDate    := tmpListDoc.OperDate
                                                                      , inFromId      := tmpListDoc.FromId
                                                                      , inToId        := tmpListDoc.ToId
                                                                      , inPartionGoods:= tmpListDoc.PartionGoods
                                                                      , inUserId      := vbUserId
                                                                       )
                     FROM tmpListDoc
                     WHERE tmpListDoc.MovementId = vbMovementId_main);

   -- ��������� ��������                  
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Union(), tmp.MovementId, CURRENT_TIMESTAMP)             -- ��������� �������� <����/�����>
         , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Union(), tmp.MovementId, vbMemberId_user)   -- ��������� ����� � <������������>
   FROM (SELECT tmpListDoc.MovementId FROM tmpListDoc
        UNION
         SELECT outMovementId AS MovementId
        ) AS tmp;
   
   -- �������� ������������ ���. �� ��������
   PERFORM gpSetErased_Movement_ProductionSeparate (tmpListDoc.MovementId, inSession)
   FROM tmpListDoc;
   
   -- ������
   -- ��������� <������� ��������� �������>
   PERFORM lpInsertUpdate_MI_ProductionSeparate_Master (ioId               := 0
                                                      , inMovementId       := outMovementId
                                                      , inGoodsId          := tmpListMI.GoodsId
                                                      , inGoodsKindId      := tmpListMI.GoodsKindId
                                                      , inStorageLineId    := tmpListMI.StorageLineId
                                                      , inAmount           := SUM (COALESCE (tmpListMI.Amount,0))     :: TFloat
                                                      , inLiveWeight       := SUM (COALESCE (tmpListMI.LiveWeight,0)) :: TFloat
                                                      , inHeadCount        := SUM (COALESCE (tmpListMI.HeadCount,0))  :: TFloat
                                                      , inUserId           := vbUserId
                                                       )
   FROM tmpListMI
   WHERE tmpListMI.DescId = zc_MI_Master()
   GROUP BY tmpListMI.GoodsId
          , tmpListMI.GoodsKindId
          , tmpListMI.StorageLineId;        

   -- ��������� <������� ��������� �����> 
   PERFORM lpInsertUpdate_MI_ProductionSeparate_Child (ioId               := 0
                                                     , inMovementId       := outMovementId
                                                     , inParentId         := Null :: integer
                                                     , inGoodsId          := tmpListMI.GoodsId
                                                     , inGoodsKindId      := tmpListMI.GoodsKindId
                                                     , inStorageLineId    := tmpListMI.StorageLineId
                                                      , inAmount           := SUM (COALESCE (tmpListMI.Amount,0))     :: TFloat
                                                      , inLiveWeight       := SUM (COALESCE (tmpListMI.LiveWeight,0)) :: TFloat
                                                      , inHeadCount        := SUM (COALESCE (tmpListMI.HeadCount,0))  :: TFloat
                                                     , inUserId           := vbUserId
                                                      )
   FROM tmpListMI
   WHERE tmpListMI.DescId = zc_MI_Child()
   GROUP BY tmpListMI.GoodsId
          , tmpListMI.GoodsKindId
          , tmpListMI.StorageLineId; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.18         *
*/

-- ����
-- SELECT * FROM gpInsert_ProductionSeparate_Union ( inSession:= '5')
