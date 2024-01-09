-- Function: gpInsert_MI_Send_auto()

DROP FUNCTION IF EXISTS gpInsert_MI_Send (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_Send_Child(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_Send_auto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send_auto(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbUnitId_From  Integer;
  DECLARE vbUnitId_To    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderPartner());
     vbUserId:= lpGetUserBySession (inSession);


    --��������, ����  ���� ������ � ��� �� ������
  /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Child())
    THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ��������� ��� ���������' :: TVarChar
                                               , inProcedureName := 'gpInsert_MI_Send_auto'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;*/



    -- ��������� �� ���������
    SELECT MovementLinkObject_From.ObjectId
         , MovementLinkObject_To.ObjectId
           INTO vbUnitId_From, vbUnitId_To
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
    WHERE Movement.Id       = inMovementId
      AND Movement.DescId   = zc_Movement_Send()
      AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
   ;

    -- zc_MI_Master - ������� �����������
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Ord Integer, MovementId_order Integer, PartionCellId Integer) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId, Ord, MovementId_order, PartionCellId)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
                 -- � �/�
               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.Id ASC) AS Ord 
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MILO_PartionCell.ObjectId               AS PartionCellId
          FROM MovementItem
               -- ValueData - MovementId ����� �������
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

               LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                               AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

    -- zc_MI_Child - ������� �����������
    CREATE TEMP TABLE _tmpMI_Child (Id Integer, ParentId Integer, ObjectId Integer, PartionId Integer, MovementId_order Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Child (Id, ParentId, ObjectId, PartionId, MovementId_order, Amount)
          SELECT MovementItem.Id
               , MovementItem.ParentId
               , MovementItem.ObjectId
               , MovementItem.PartionId
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MovementItem.Amount
          FROM MovementItem
               -- zc_MI_Master �� ������
               INNER JOIN _tmpMI_Master ON _tmpMI_Master.Id = MovementItem.ParentId
               -- ValueData - MovementId ����� �������
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE;


    -- ������ ������ (����� + ������) - �� � ����� ����������
    CREATE TEMP TABLE _tmpReserve (MovementId_order Integer, ObjectId Integer, PartionId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReserve (MovementId_order, ObjectId, PartionId, Amount)
       WITH -- ��� �������
            tmpMI_Child AS (-- ������ ������� - zc_MI_Child - ����������� �� ��������
                            SELECT MovementItem.MovementId   AS MovementId_order
                                 , MovementItem.ObjectId
                                 , MovementItem.PartionId
                                   -- ���-�� - ������ � ������
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                                        -- �������� �������, ���� ��� ����� � ���
                                                        --AND MovementItem.ParentId > 0
                                 -- �� ������ ������ - zc_MI_Master �� ������
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Child() -- !!!�� ������!!!
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                                 -- ����������� - ������ ��� ����� ������
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                                  AND MILinkObject_Unit.ObjectId       = vbUnitId_From
                                 -- ValueData - MovementId ������ ����������
                                /* LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()*/
                            WHERE Movement.DescId   = zc_Movement_OrderClient()
                              -- ��� �� ���������
                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                              -- ���-�� - ������ � ������
                              AND MovementItem.Amount > 0
                            GROUP BY MovementItem.MovementId
                                   , MovementItem.ObjectId
                                   , MovementItem.PartionId

                           UNION ALL
                            -- ������� �� ���������� - zc_MI_Child - ����������� �� ��������
                            SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                                 , MovementItem.ObjectId
                                 , MovementItem.PartionId
                                   -- ���-�� - ������ � ������
                                 , MovementItem.Amount
                            FROM Movement
                                 -- ����������� - ������ ������ �� ���� �����
                                 INNER JOIN MovementLinkObject AS MLO_To
                                                               ON MLO_To.MovementId = Movement.Id
                                                              AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MLO_To.ObjectId   = vbUnitId_From
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                 -- zc_MI_Master �� ������
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                                 -- ValueData - MovementId ����� �������
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                            WHERE Movement.DescId   = zc_Movement_Income()
                              -- �����������
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                            )
             -- ����������� - ������� ��� ����������� �������� ��� ����� �������
           , tmpMI_Send AS (SELECT MovementItem.MovementId
                                 , MovementItem.ObjectId
                                 , MovementItem.PartionId
                                   -- ������� �����������
                                 , MovementItem.Amount
                                   -- ����� �������
                                 , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                            FROM MovementItemFloat AS MIFloat_MovementId
                                 INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                        AND MovementItem.DescId   = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                 -- ��� ����� �����������
                                 INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                    AND Movement.DescId   = zc_Movement_Send()
                                                    -- ��� �� ���������
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                  --AND Movement.StatusId = zc_Enum_Status_Complete()
                                 -- zc_MI_Master �� ������
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE

                            WHERE MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMI_Child.MovementId_order FROM tmpMI_Child)
                              AND MIFloat_MovementId.DescId   = zc_MIFloat_MovementId()
                           )
     -- ����� ������
     SELECT tmpMI_Child.MovementId_order
          , tmpMI_Child.ObjectId
          , tmpMI_Child.PartionId
            -- ������� ��������
          , tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) AS Amount

     FROM (SELECT tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId, SUM (tmpMI_Child.Amount) AS Amount
           FROM tmpMI_Child
           GROUP BY tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId
          ) AS tmpMI_Child
          -- ����� ������� �����������
          LEFT JOIN (SELECT tmpMI_Send.MovementId_order
                          , tmpMI_Send.ObjectId
                          , tmpMI_Send.PartionId
                          , SUM (tmpMI_Send.Amount) AS Amount
                     FROM tmpMI_Send
                     -- !!!��� �������� �����������
                     WHERE tmpMI_Send.MovementId <> inMovementId
                     GROUP BY tmpMI_Send.MovementId_order
                            , tmpMI_Send.ObjectId
                            , tmpMI_Send.PartionId
                    ) AS tmpMI_Send
                      ON tmpMI_Send.MovementId_order = tmpMI_Child.MovementId_order
                     AND tmpMI_Send.PartionId        = tmpMI_Child.PartionId
     -- !! �������� ��� ����������!!!
     WHERE tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) > 0
    ;

    -- test
    --RAISE EXCEPTION '%', (select count(*)  from _tmpReserve);


    -- ��������� - zc_MI_Master - ������� �����������
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                     := COALESCE (_tmpMI_Master.Id, 0)
                                            , inMovementId             := inMovementId
                                            , inMovementId_OrderClient := COALESCE (tmp.MovementId_order, _tmpMI_Master.MovementId_order) :: Integer
                                            , inGoodsId                := COALESCE (tmp.ObjectId, _tmpMI_Master.ObjectId)        
                                            , inPartionCellId          := _tmpMI_Master.PartionCellId ::Integer
                                              -- ���-�� ������
                                            , inAmount                 := CASE WHEN _tmpMI_Master.ORD = 1 OR COALESCE (_tmpMI_Master.Id, 0) = 0 THEN COALESCE (tmp.Amount, 0) ELSE 0 END
                                            , inOperPrice              := COALESCE (tmp.OperPrice, 0)
                                            , inCountForPrice          := COALESCE (tmp.CountForPrice, 1)
                                            , inComment                :='' ::TVarChar
                                            , inUserId                 := vbUserId
                                             )
    FROM _tmpMI_Master
         -- ����������� ������������ ������ � ������ �������
         FULL JOIN (--���������� ������ �������
                    SELECT _tmpReserve.ObjectId              
                           -- ������������ ����, � ������� ������
                         , ObjectFloat_EKPrice.ValueData AS OperPrice
                         , 1 :: TFloat AS CountForPrice
                         , SUM (COALESCE (_tmpReserve.Amount,0)) AS Amount
                         --����� ������� 
                         , _tmpReserve.MovementId_order
                    FROM _tmpReserve
                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                               ON ObjectFloat_EKPrice.ObjectId = _tmpReserve.ObjectId
                                              AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                    GROUP BY _tmpReserve.ObjectId
                           , ObjectFloat_EKPrice.ValueData 
                           , _tmpReserve.MovementId_order
                    ) AS tmp ON tmp.ObjectId = _tmpMI_Master.objectId
                            AND tmp.MovementId_order = _tmpMI_Master.MovementId_order
    ;   

/*zc_MI_Child - ����� ������������� ��� ���������� ���

    -- ��������� - zc_MI_Child - ������� �����������
    PERFORM lpInsertUpdate_MI_Send_Child (ioId                     := COALESCE (_tmpMI_Child.Id, 0)
                                        , inParentId               := COALESCE (tmpMI_new.ParentId, _tmpMI_Child.ParentId)
                                        , inMovementId             := inMovementId
                                        , inMovementId_OrderClient := COALESCE (tmpMI_new.MovementId_order, _tmpMI_Child.MovementId_order) :: Integer
                                        , inObjectId               := COALESCE (tmpMI_new.ObjectId, _tmpMI_Child.ObjectId)    :: Integer
                                        , inPartionId              := COALESCE (tmpMI_new.PartionId, _tmpMI_Child.PartionId)  :: Integer
                                          -- ���-�� ������
                                        , inAmount                 := COALESCE (tmpMI_new.Amount, 0)
                                        , inUserId                 := vbUserId
                                         )
    FROM _tmpMI_Child
         -- ����� ��������
         FULL JOIN (-- ����� ������
                    WITH tmpMI_Master AS (SELECT MovementItem.Id
                                               , MovementItem.ObjectId
                                                 -- � �/�
                                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                                          FROM MovementItem
                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                         )
                    -- ���������� ������
                    SELECT tmpMI_Master.Id           AS ParentId
                         , tmpMI_Master.ObjectId     AS ObjectId
                            --
                         , _tmpReserve.PartionId
                         , _tmpReserve.MovementId_order
                         , CASE WHEN tmpMI_Master.Ord = 1 THEN _tmpReserve.Amount ELSE 0 END AS Amount
                    FROM tmpMI_Master
                         LEFT JOIN _tmpReserve ON _tmpReserve.ObjectId      = tmpMI_Master.ObjectId
                    ) AS tmpMI_new ON tmpMI_new.PartionId        = _tmpMI_Child.PartionId
                                  AND tmpMI_new.ParentId         = _tmpMI_Child.ParentId
                                  AND tmpMI_new.MovementId_order = _tmpMI_Child.MovementId_order
    ;

*/


    -- �������� zc_MI_Master ���-�� = 0
    PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
      AND MovementItem.Amount     = 0
   ;
    -- test!!!
/*
    PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Child()
      AND MovementItem.isErased   = FALSE
   ;
   */

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.09.21         *
*/

-- ����
-- SELECT * FROM gpInsert_MI_Send_auto (inMovementId:= 589, inSession:= '5');
