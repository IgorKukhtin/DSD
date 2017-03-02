-- Function: gpInsertUpdate_MI_Over_List_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_List_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_List_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_List_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_List_Auto(
    IN inUnitFromId          Integer   , -- �� ����
    IN inUnitToId            Integer   , -- ����
    IN inOperDate            TDateTime , -- ����
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inRemainsFrom         TFloat    , -- �������
    IN inRemainsTo           TFloat    , -- �������
    IN inAmountSend          TFloat    , -- ��������������� ������
    IN inPriceFrom           TFloat    , -- ���� �� ����
    IN inPriceTo             TFloat    , -- ���� ����
    IN inMCSFrom             TFloat    , -- ������ ��� ������� ���
    IN inMCSTo               TFloat    , -- ������ ��� ������� ���
    IN inTerm                TFloat    , -- �� ������������ ����� ����� ��� �������
    IN inisTerm              Boolean   , --  ��� ������� (�� ������������ ����� ����� ��� �������)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;   
   DECLARE vbMovementItemChildId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbTerm TFloat;       
   DECLARE vbMinExpirationDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
    vbUserId := inSession;


      -- ���� �� ��������� (���� - ����, �������������) 
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        Inner Join MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitFromId
      WHERE Movement.DescId = zc_Movement_Over() 
        AND Movement.OperDate = inOperDate
        AND Movement.StatusId <> zc_Enum_Status_Erased();
    
      IF COALESCE (vbMovementId,0) = 0
      THEN
       -- ���������� ����� <��������>
       vbMovementId := lpInsertUpdate_Movement_Over (ioId               := 0
                                                   , inInvNumber        := CAST (NEXTVAL ('Movement_Over_seq') AS TVarChar) --inInvNumber
                                                   , inOperDate         := inOperDate
                                                   , inUnitId           := inUnitFromId
                                                   , inComment          := '' :: TVarChar
                                                   , inUserId           := vbUserId
                                                   );
       END IF;
      
   
       -- ��������
       IF EXISTS (SELECT ObjectId FROM MovementItem WHERE MovementId = vbMovementId AND ObjectId = inGoodsId AND isErased = FALSE AND DescId = zc_MI_Master())
       THEN
          RAISE EXCEPTION '������.����������� "�������" ����� = <%> ������ = <%> ���-�� = <%>  ������� = <%> ���� = <%>', lfGet_Object_ValueData (inGoodsId), DATE (vbMinExpirationDate), zfConvert_FloatToString (inAmount), zfConvert_FloatToString (inRemains), zfConvert_FloatToString (inPrice);
       END IF;


      -- ���������� ���� �������� �������
      SELECT MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- ���� ��������
   INTO vbMinExpirationDate
      FROM (
            SELECT Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                 , Container.Id  AS ContainerId
            FROM Container 
                 LEFT JOIN MovementItemContainer AS MIContainer
                                                 ON MIContainer.ContainerId = Container.Id
                                                AND MIContainer.OperDate >= inOperDate
            WHERE Container.DescId = zc_Container_Count()
              AND Container.WhereObjectId = inUnitFromId --3457773
              AND Container.Objectid = inGoodsId --19996
            GROUP BY Container.Id, Container.Amount
            HAVING  Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
           ) AS tmp
           -- ������� ������
           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                         ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
           -- ������� �������
           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
           -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
           -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                      
           LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
      HAVING  SUM (tmp.RemainsStart) <> 0;

      vbTerm:= (SELECT DATE_PART('day', vbMinExpirationDate - inOperDate) / 30);

      IF (inisTerm = TRUE AND vbTerm > inTerm) OR (inisTerm =FALSE)
      THEN
       -- ��������� ������ ���������
       vbMovementItemId := lpInsertUpdate_MI_Over_Master    (ioId                 := 0 -- COALESCE (vbMovementItemId, 0)
                                                           , inMovementId         := vbMovementId
                                                           , inGoodsId            := inGoodsId
                                                           , inAmount             := 0 -- inAmount !!!��������� = ����� � zc_MI_Child!!!
                                                           , inRemains            := inRemainsFrom
                                                           , inAmountSend         := inAmountSend
                                                           , inPrice              := inPriceFrom
                                                           , inMCS                := inMCSFrom
                                                           , inMinExpirationDate  := vbMinExpirationDate
                                                           , inComment            := Null :: TVarChar
                                                           , inUserId             := vbUserId
                                                            );
  
           -- ��������
           IF EXISTS (SELECT ObjectId FROM MovementItem WHERE MovementId = vbMovementId AND isErased = FALSE AND DescId = zc_MI_Master() GROUP BY ObjectId HAVING COUNT(*) > 1)
           THEN
              RAISE EXCEPTION '������.����������� "�������" ����� <%>', lfGet_Object_ValueData ((SELECT ObjectId FROM MovementItem WHERE MovementId = vbMovementId AND isErased = FALSE AND DescId = zc_MI_Master() GROUP BY ObjectId HAVING COUNT(*) > 1 LIMIT 1));
           END IF;
              
        ----------   
           
         IF vbMovementItemId <> 0
          THEN
            -- ��������
            IF EXISTS (SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId AND MovementId = vbMovementId AND ObjectId = inUnitToId AND isErased = FALSE AND DescId = zc_MI_Child())
            THEN
               RAISE EXCEPTION '������.����������� "�����������" ����� <%> ��� ������ <%>', lfGet_Object_ValueData ((SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId)), lfGet_Object_ValueData (inUnitToId);
            END IF;
  
            -- ���������� ���� �������� �������
            SELECT MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- ���� ��������
         INTO vbMinExpirationDate
            FROM (
                  SELECT Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                       , Container.Id  AS ContainerId
                  FROM Container 
                       LEFT JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.ContainerId = Container.Id
                                                      AND MIContainer.OperDate >= inOperDate
                  WHERE Container.DescId = zc_Container_Count()
                    AND Container.WhereObjectId = inUnitToId --inUnitId--3457773
                    AND Container.Objectid = inGoodsId --19996
                  GROUP BY Container.Id, Container.Amount
                  HAVING  Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                 ) AS tmp
                 -- ������� ������
                 LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                               ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
                                              AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                 LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                 -- ������� �������
                 LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                 -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                             ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                            AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                 -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                 LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                            
                 LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                   ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                  AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
            HAVING  SUM (tmp.RemainsStart) <> 0;


              -- ��������� ������ ���������
              vbMovementItemChildId := lpInsertUpdate_MI_Over_Child(ioId               := 0 --COALESCE (vbMovementItemChildId, 0)
                                                                  , inMovementId       := vbMovementId
                                                                  , inParentId         := vbMovementItemId                                
                                                                  , inUnitId           := inUnitToId
                                                                  , inAmount           := inAmount
                                                                  , inRemains          := inRemainsTo
                                                                  , inPrice            := inPriceTo
                                                                  , inMCS              := inMCSTo
                                                                  , inMinExpirationDate:= vbMinExpirationDate
                                                                  , inComment          := Null :: TVarChar
                                                                  , inUserId           := vbUserId
                                                                  );

              -- ��������� � Master - ����� �� Child
              PERFORM lpInsertUpdate_MovementItem (ioId           := MovementItem.Id
                                                 , inDescId       := MovementItem.DescId
                                                 , inObjectId     := MovementItem.ObjectId
                                                 , inMovementId   := MovementItem.MovementId
                                                 , inAmount       := COALESCE ((SELECT SUM (Amount) FROM MovementItem WHERE MovementId = vbMovementId AND ParentId = vbMovementItemId AND isErased = FALSE AND DescId = zc_MI_Child()), 0)
                                                 , inParentId     := MovementItem.ParentId
                                                 , inUserId       := vbUserId
                                                  )
              FROM MovementItem
              WHERE MovementItem.Id = vbMovementItemId
             ;
            
            END IF;
      ----------------------
           
           
                    
           
       END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.03.17         * 
*/

-- ����
--select * from gpInsertUpdate_MI_Over_List_Auto(inUnitId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');