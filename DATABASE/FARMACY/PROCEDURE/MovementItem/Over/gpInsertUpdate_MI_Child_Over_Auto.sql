-- Function: gpInsertUpdate_MI_Child_Over_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Child_Over_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Child_Over_Auto(
    IN inUnitFromId          Integer   , -- �� ����
    IN inUnitToId            Integer   , -- ����
    IN inOperDate            TDateTime , -- ����
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inRemains	     TFloat    , -- 
    IN inPrice               TFloat    , -- ���� �� ����
    IN inMCS                 TFloat    , -- ������ ��� ������� ���
    IN inMinExpirationDate   TDateTime , -- 
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
   DECLARE vbGoodsMainId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
    vbUserId := inSession;

    IF COALESCE (inAmount, 0) <> 0
    THEN
      -- ����� ��������� (���� - ����, �������������)
      vbMovementId:= (SELECT Movement.Id  
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.ID
                                                        AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                        AND MovementLinkObject_Unit.ObjectId   = inUnitFromId
                      WHERE Movement.OperDate = inOperDate
                        AND Movement.DescId = zc_Movement_Over()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     );
      -- ��������
      IF COALESCE (vbMovementId, 0) = 0 THEN
          RAISE EXCEPTION '������.�������� �� ���������.';
      END IF;

      -- �������� GoodsMainId �������� ������� �� ������ �����
      vbGoodsMainId := (SELECT ObjectLink_Main.ChildObjectId AS GoodsMainId
                        FROM ObjectLink AS ObjectLink_Child
                             LEFT JOIN ObjectLink AS ObjectLink_Main 
                                    ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                        WHERE ObjectLink_Child.ChildObjectId = inGoodsId
                          AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                        );
                        
                        
      -- ����� ������ Master (���� - �� ���������, �����)
      vbMovementItemId:= (SELECT MovementItem.Id
                          FROM MovementItem
                            /*   INNER JOIN (SELECT DISTINCT ObjectLink_Child_NB.ChildObjectId AS GoodsId
                                           FROM ObjectLink AS ObjectLink_Child
                                                LEFT JOIN ObjectLink AS ObjectLink_Main 
                                                       ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                      AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                   
                                                INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                                  AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                                INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                                                                                   AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                         
                                                     AND COALESCE (ObjectLink_Child_NB.ChildObjectId, 0) <> 0
                                           WHERE ObjectLink_Child.ChildObjectId = inGoodsId
                                             AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           ) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId 
                          */
                               -- �������� GoodsMainId
                               LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                                     ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                               INNER JOIN  ObjectLink AS ObjectLink_Main 
                                                      ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                     AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                     AND ObjectLink_Main.ChildObjectId = vbGoodsMainId
                          WHERE MovementItem.MovementId = vbMovementId 
                            AND MovementItem.DescId     = zc_MI_Master()
--                            AND MovementItem.ObjectId   = inGoodsId
                            AND MovementItem.isErased   = FALSE
                         );
      /*-- ��������
      IF COALESCE (vbMovementItemId, 0) = 0
      THEN
          RAISE EXCEPTION '������.������ ������� �� ����������.';
      END IF;*/


     IF vbMovementItemId <> 0
     THEN
        -- ��������
        IF EXISTS (SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId AND MovementId = vbMovementId AND ObjectId = inUnitToId AND isErased = FALSE AND DescId = zc_MI_Child())
        THEN
           RAISE EXCEPTION '������.����������� "�����������" ����� <%> ��� ������ <%>', lfGet_Object_ValueData ((SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId)), lfGet_Object_ValueData (inUnitToId);
        END IF;



      -- ���������� ���� �������� �������
      SELECT MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- ���� ��������
   INTO inMinExpirationDate
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
                                                            , inRemains          := inRemains
                                                            , inPrice            := inPrice
                                                            , inMCS              := inMCS
                                                            , inMinExpirationDate:= inMinExpirationDate
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
  
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.07.16         *
*/

-- ����
--select * from gpInsertUpdate_MI_Child_Over_Auto(inUnitId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
