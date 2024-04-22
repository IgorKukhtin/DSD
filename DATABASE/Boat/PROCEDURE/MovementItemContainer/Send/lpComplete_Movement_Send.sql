DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbUnitId_From              Integer;
  DECLARE vbUnitId_To                Integer;
  DECLARE vbAccountDirectionId_From  Integer;
  DECLARE vbAccountDirectionId_To    Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId               Integer; -- �������� ���� �� ������������

  DECLARE vbMovementItemId        Integer;
  DECLARE vbMovementId_order_from Integer;
  DECLARE vbMovementId_order_to   Integer;
  DECLARE vbGoodsId               Integer;
  DECLARE vbPartionId             Integer;
  DECLARE vbPartNumber            TVarChar;
  DECLARE vbAmount                TFloat;
  DECLARE vbAmount_partion        TFloat;

  DECLARE curItem                 RefCursor;
  DECLARE curPartion              RefCursor;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;
     DELETE FROM _tmpItem_Child;
     -- !!!�����������!!! �������� ������� - ������� �������� ��������������� ��� ������� �������
     --DELETE FROM _tmpReserveDiff;
     -- !!!�����������!!! �������� ������ ��� ������� �������
     --DELETE FROM _tmpReserveRes;


     -- ��������� �� ���������
     SELECT tmp.MovementDescId, tmp.OperDate, tmp.UnitId_From, tmp.UnitId_To
          , tmp.AccountDirectionId_From, tmp.AccountDirectionId_To
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId_From
               , vbUnitId_To
               , vbAccountDirectionId_From
               , vbAccountDirectionId_To
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit() THEN Object_To.Id   ELSE 0 END, 0) AS UnitId_To

                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ������
                , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From
                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ������
                , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100())   AS AccountDirectionId_To

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                     ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- �������� - �������������
     IF COALESCE (vbUnitId_From, 0) = COALESCE (vbUnitId_To, 0)
     THEN
         RAISE EXCEPTION '������. �������� <������������� (�� ����)> ������ ���������� �� <������������� (����)>.';
     END IF;
     -- �������� - �������������
     IF COALESCE (vbUnitId_From, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������������� (�� ����)>.';
     END IF;
     -- �������� - �������������
     IF COALESCE (vbUnitId_To, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������������� (����)>.';
     END IF;

     -- �������� �������� 
     IF EXISTS (SELECT MovementItem.Id
                FROM MovementItem 
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Scan())
     THEN
     
     
       -- ���� ��������� ������ �������� 
       IF NOT EXISTS (SELECT MovementItem.ObjectId AS GoodsId
                           , SUM(MovementItem.Amount)::TFloat             AS Amount
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                      FROM MovementItem 

                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                           
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Scan()
                        AND MovementItem.isErased   = False
                      GROUP BY MovementItem.ObjectId
                             , COALESCE (MIString_PartNumber.ValueData, '')
                      HAVING SUM(MovementItem.Amount) <> 0)
       THEN
         RAISE EXCEPTION '������.�� ��������� � <%> ��� ���������������� ������ � �����������. �������� �������� �� ��������.', vbInvNumber;
       END IF;

       -- �������� ����� ����� �� ������� �������
       IF EXISTS (SELECT MovementItem.ObjectId AS GoodsId
                       , SUM(MovementItem.Amount)::TFloat             AS Amount
                       , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                  FROM MovementItem 

                       LEFT JOIN MovementItemString AS MIString_PartNumber
                                                    ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                       
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Scan()
                    AND MovementItem.isErased   = False
                  GROUP BY MovementItem.ObjectId
                         , COALESCE (MIString_PartNumber.ValueData, '')
                  HAVING SUM(MovementItem.Amount) < 0)
       THEN
         RAISE EXCEPTION '������.�� ��������� � <%> ��� ������� �� ������ ������ <%> ���������� �� ������ �������������. �������� �������� �� ��������.', vbInvNumber, 
                         lfGet_Object_ValueData ((SELECT MovementItem.ObjectId AS GoodsId
                                                  FROM MovementItem 

                                                       LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                                    ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                                                       
                                                  WHERE MovementItem.MovementId = inMovementId
                                                    AND MovementItem.DescId     = zc_MI_Scan()
                                                    AND MovementItem.isErased   = False
                                                  GROUP BY MovementItem.ObjectId
                                                         , COALESCE (MIString_PartNumber.ValueData, '')
                                                  HAVING SUM(MovementItem.Amount) < 0
                                                  LIMIT 1));
       END IF;
              
       -- ���������� ��������� ������ � �������
       UPDATE MovementItem SET isErased = False
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = True;       
     
       -- ������� �������� �� zc_MI_Scan
       PERFORM lpInsertUpdate_MovementItem_Send (ioId                     := tmp.Id
                                               , inMovementId             := inMovementId
                                               , inMovementId_OrderClient := 0
                                               , inGoodsId                := tmp.GoodsId 
                                               , inPartionCellId          := tmp.PartionCellId
                                               , inAmount                 := tmp.Amount
                                               , inOperPrice              := 0
                                               , inCountForPrice          := 0
                                               , inPartNumber             := tmp.PartNumber
                                               , inComment                := ''
                                               , inUserId                 := inUserId
                                               )

       FROM (WITH tmpMIScan AS (SELECT MovementItem.ObjectId AS GoodsId
                                       , SUM(MovementItem.Amount)::TFloat             AS Amount
                                       , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                                       , MAX(MovementItem.Id)                         AS MaxID  
                                  FROM MovementItem 

                                       LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                    ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                       
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Scan()
                                    AND MovementItem.isErased   = False
                                  GROUP BY MovementItem.ObjectId
                                         , COALESCE (MIString_PartNumber.ValueData, '')
                                 )
                , tmpMIMaster AS (SELECT MovementItem.Id
                                       , MovementItem.ObjectId AS GoodsId
                                       , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                                  FROM MovementItem 
                                  
                                       LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                    ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                      
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = False
                                 )
                                 
              SELECT COALESCE(tmpMIMaster.Id, 0)                  AS ID
                   , tmpMIScan.GoodsId                            AS GoodsId
                   , tmpMIScan.Amount                             AS Amount
                   , tmpMIScan.PartNumber                         AS PartNumber
                   , COALESCE(MILO_PartionCell.ObjectId, 0)         AS PartionCellId
              FROM tmpMIScan
                            
                   FULL JOIN tmpMIMaster ON tmpMIScan.GoodsId = tmpMIMaster.GoodsId
                                        AND tmpMIScan.PartNumber = tmpMIMaster.PartNumber

                   LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                    ON MILO_PartionCell.MovementItemId = tmpMIScan.MaxId
                                                   AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()                                                   
            ) AS tmp;
            
       -- ������ ������ � ������� � ������� �����������
       UPDATE MovementItem SET isErased = True
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = False
         AND MovementItem.Amount     = 0;       
            
     END IF;

     -- ��������� ������� - �������� ���������
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId
                         , Amount
                         , PartNumber
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , MovementId_order_to
                          )
        -- ���������
        SELECT MovementItem.Id                  AS MovementItemId
             , MovementItem.ObjectId            AS GoodsId
             , MovementItem.Amount              AS Amount
               --
             , MIString_PartNumber.ValueData    AS PartNumber
               -- �������������� ������
             , View_InfoMoney.InfoMoneyGroupId
               -- �������������� ����������
             , View_InfoMoney.InfoMoneyDestinationId
               -- ������ ����������
             , View_InfoMoney.InfoMoneyId

              -- MovementId ����� �������
            , COALESCE (MIFloat_MovementId.ValueData, 0) AS MovementId_order_to

        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
             -- ValueData - MovementId ����� �������
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
             -- !!!��������!!! �������������
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

        WHERE Movement.Id       = inMovementId
          AND Movement.DescId   = zc_Movement_Send()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;




     -- 2.��������� ������� - �������� �� �������

     -- ������1 - �������� ���������
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartNumber, _tmpItem.MovementId_order_to
                           , _tmpItem.Amount
                      FROM _tmpItem
                     ;
     -- ������ ����� �� �������1 - �������� ���������
     LOOP
     -- ������ �� �������
     FETCH curItem INTO vbMovementItemId, vbGoodsId, vbPartNumber, vbMovementId_order_to, vbAmount;
     -- ���� ������ �����������, ����� �����
     IF NOT FOUND THEN EXIT; END IF;


     -- ������2 - ������ �������� �� �������
     OPEN curPartion FOR
        SELECT Container.PartionId, COALESCE (CLO_PartionMovement.ObjectId, 0) AS MovementId_order_from, Container.Amount - COALESCE (tmp.Amount, 0) AS Amount
        FROM Container
             -- ��-�� Container
             LEFT JOIN ContainerLinkObject AS CLO_PartionMovement
                                           ON CLO_PartionMovement.ContainerId = Container.Id
                                          AND CLO_PartionMovement.DescId      = zc_ContainerLinkObject_PartionMovement()
             LEFT JOIN Object AS Object_PartionMovement ON Object_PartionMovement.Id = CLO_PartionMovement.ObjectId
             -- ��-�� ������
             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = Container.PartionId
                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
             -- ��� �������������� ����������� ������, �� ���� �������
             LEFT JOIN (SELECT _tmpItem_Child.GoodsId, _tmpItem_Child.PartionId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.GoodsId, _tmpItem_Child.PartionId
                       ) AS tmp ON tmp.GoodsId   = Container.ObjectId
                               AND tmp.PartionId = Container.PartionId

        WHERE Container.ObjectId      = vbGoodsId
          AND Container.WhereObjectId = vbUnitId_From
          AND Container.Amount  - COALESCE (tmp.Amount, 0) > 0
        ORDER BY -- ���� MovementId_order ���������
                 CASE WHEN Object_PartionMovement.ObjectCode = vbMovementId_order_to AND vbMovementId_order_to <> 0 THEN 0 ELSE 1 END
                 -- ���� MovementId_order ����, ��������� ������� ������ � ������ MovementId_order
               , CASE WHEN COALESCE (Object_PartionMovement.ObjectCode, 0) = 0 AND vbMovementId_order_to <> 0 THEN 0 ELSE 1 END

                 -- ���� PartNumber ���������
               , CASE WHEN MIString_PartNumber.ValueData = vbPartNumber AND vbPartNumber <> '' THEN 0 ELSE 1 END
                 -- ���� PartNumber ����, ��������� ������� ������ � ������ PartNumber
               , CASE WHEN COALESCE (MIString_PartNumber.ValueData, '') = '' AND vbPartNumber <> '' THEN 0 ELSE 1 END

                 -- ���� MovementId_order �� ����������, ��������� ������� ������ � ������ MovementId_order
               , CASE WHEN COALESCE (Object_PartionMovement.ObjectCode, 0) = 0 AND vbMovementId_order_to = 0 THEN 0 ELSE 1 END
                 -- ���� PartNumber �� ����������, ��������� ������� ������ � ������ PartNumber
               , CASE WHEN COALESCE (MIString_PartNumber.ValueData, '') = '' AND vbPartNumber = '' THEN 0 ELSE 1 END

               , Container.PartionId ASC
              ;

         -- ������ ����� �� �������2. - ������� �� �������
         LOOP
             -- ������ - ������� ���� � ��������
             FETCH curPartion INTO vbPartionId, vbMovementId_order_from, vbAmount_partion;
             -- ���� ������� �����������, ��� ��� ���-�� ��� ����������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             -- ���� �� �������� ������ ��� ����
             IF vbAmount_partion > vbAmount
             THEN
                 -- ��������� ������� - �������� zc_MI_Child ���������
                 INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , Amount
                                           , MovementId_order_from, MovementId_order_to
                                            )
                    SELECT 0                       AS MovementItemId -- ���������� �����
                         , vbMovementItemId        AS ParentId
                         , vbGoodsId               AS GoodsId
                         , vbPartionId             AS PartionId
                           -- ����� ������ ���-��
                         , vbAmount                AS Amount
                           --
                         , vbMovementId_order_from AS MovementId_order_from
                         , vbMovementId_order_to   AS MovementId_order_to
                          ;
                 -- �������� ���-��, ������ �� ���� ������
                 vbAmount:= 0;
             ELSE
                 -- ��������� ������� - �������� zc_MI_Child ���������
                 INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , Amount
                                           , MovementId_order_from, MovementId_order_to
                                            )
                    SELECT 0                       AS MovementItemId -- ���������� �����
                         , vbMovementItemId        AS ParentId
                         , vbGoodsId               AS GoodsId
                         , vbPartionId             AS PartionId
                           -- ��������� ���� ������� �� ���� ������
                         , vbAmount_partion        AS Amount
                           --
                         , vbMovementId_order_from AS MovementId_orderfrom
                         , vbMovementId_order_to   AS MovementId_order_to
                          ;

                 -- ��������� ������ ���-�� �� ������� � ���������� ������
                 vbAmount:= vbAmount - vbAmount_partion;

             END IF;


         END LOOP; -- ����� ����� �� �������2. - ������� �� �������
         CLOSE curPartion; -- ������� ������2. - ������� �� �������


     END LOOP; -- ����� ����� �� �������1 - �������� ���������
     CLOSE curItem; -- ������� ������1 - �������� ���������



     -- �������� ������, ������� ���� �������, �.�. �������� �� ��� �� �����
     INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                               , GoodsId, PartionId
                               , Amount
                               , MovementId_order_from, MovementId_order_to
                                )
        SELECT 0                       AS MovementItemId -- ���������� �����
             , _tmpItem.MovementItemId AS ParentId
             , _tmpItem.GoodsId
               -- !!!������ ��������� ?��������� ����������?
             , _tmpItem_partion.MovementItemId AS PartionId
               -- ������� � ���� ������ �������� �������
             , _tmpItem.Amount - COALESCE (tmp.Amount, 0)
               --
             , 0 AS MovementId_order_from
             , _tmpItem.MovementId_order_to
        FROM _tmpItem
             -- ������� ������ ���������, �� ���� �������
             LEFT JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.ParentId
                       ) AS tmp
                         ON tmp.ParentId = _tmpItem.MovementItemId
             -- ������ !!!������!!! ����
             LEFT JOIN (SELECT MAX (_tmpItem.MovementItemId) AS MovementItemId, _tmpItem.GoodsId, _tmpItem.MovementId_order_to
                        FROM _tmpItem
                        GROUP BY _tmpItem.GoodsId, _tmpItem.MovementId_order_to
                       ) AS _tmpItem_partion
                         ON _tmpItem_partion.GoodsId = _tmpItem.GoodsId
                        -- ����� ��� ������� Id_order
                        AND _tmpItem_partion.MovementId_order_to = _tmpItem.MovementId_order_to
        WHERE _tmpItem.Amount - COALESCE (tmp.Amount, 0) > 0
       ;

     -- �������� - ���������� ���-�� _tmpItem + _tmpItem_Child
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     FULL JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.Amount) AS Amount
                                FROM _tmpItem_Child GROUP BY _tmpItem_Child.ParentId
                               ) AS tmpRes ON tmpRes.ParentId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
               )
     THEN
         RAISE EXCEPTION '������.���-�� � ��������� = <%> �� ����� ���������� �� ���-�� � ������� = <%> <%>.'
                     , (SELECT _tmpItem.Amount
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
                     , COALESCE ((SELECT tmpReserveRes.Amount
                                  FROM _tmpItem
                                       FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                                  FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                                 ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                                  WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                                  ORDER BY _tmpItem.MovementItemId
                                  LIMIT 1
                                 ), 0)
                     , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
               ;
     END IF;


     -- RAISE EXCEPTION 'test.<%> <%>', (SELECT SUM (_tmpItem.Amount) FROM _tmpItem), (SELECT SUM (_tmpReserveRes.Amount) FROM _tmpReserveRes);


     -- ������� ������
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := tmpItem.PartionId
                                               , inMovementId        := inMovementId              -- ���� ���������
                                               , inFromId            := vbUnitId_From             -- ��������� ��� ������������� (����� ������)
                                               , inUnitId            := vbUnitId_From             -- �������������(�������)
                                               , inOperDate          := vbOperDate                -- ���� �������
                                               , inObjectId          := tmpItem.GoodsId           -- ������������� ��� �����
                                               , inAmount            := tmpItem.Amount            -- ���-�� ������
                                                 --
                                               , inEKPrice           := tmpItem.EKPrice_find      -- ���� ��. ��� ���, � ������ ���� ������ + ������� + �������: �������� + �������� + ��������� = inEKPrice_discount + inCostPrice
                                               , inEKPrice_orig      := tmpItem.EKPrice_find      -- ���� ��. ��� ���, � ������ ������ ������ �� ��������
                                               , inEKPrice_discount  := tmpItem.EKPrice_find      -- ���� ��. ��� ���, � ������ ���� ������ (������ ����� ���)
                                               , inCostPrice         := 0                         -- ���� ������ ��� ��� (������� + �������: �������� + �������� + ���������)
                                               , inCountForPrice     := 1                         -- ���� �� ����������
                                                 --
                                               , inEmpfPrice         := tmpItem.EmpfPrice         -- ���� ��������. ��� ���
                                               , inOperPriceList     := 0                         -- ���� �������
                                               , inOperPriceList_old := 0                         -- ���� �������, �� ��������� ������
                                                 -- ��� ��� (!������������!)
                                               , inTaxKindId         := zc_Enum_TaxKind_Basis()
                                                 -- �������� ��� (!������������!)
                                               , inTaxKindValue      := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis()  AND OFl.DescId = zc_ObjectFloat_TaxKind_Value())
                                                 --
                                               , inUserId            := inUserId
                                                )
     FROM (WITH --
                tmpItem AS (SELECT _tmpItem_Child.*
                                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0)    AS EKPrice
                                 , COALESCE (ObjectFloat_EmpfPrice .ValueData, 0) AS EmpfPrice
                            FROM _tmpItem_Child
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                       ON ObjectFloat_EKPrice.ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                       ON ObjectFloat_EmpfPrice .ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EmpfPrice .DescId   =  zc_ObjectFloat_Goods_EmpfPrice ()
                            -- ������� - ����� ���� ������� ������
                            WHERE _tmpItem_Child.ParentId = _tmpItem_Child.PartionId
                           )
                -- ����������� ���� ����������
              , tmpItemPrice AS (SELECT tmpItem.GoodsId
                                        -- Dealer_Price ��� Price per Base U.M. ��� Trade Unit Price
                                      , MovementItem.Amount AS EKPrice
                                        -- � �/�
                                      , ROW_NUMBER() OVER (PARTITION BY tmpItem.GoodsId ORDER BY Movement.OperDate DESC) AS Ord
                                 FROM tmpItem
                                      INNER JOIN MovementItem ON MovementItem.ObjectId = tmpItem.GoodsId
                                                             AND MovementItem.DescId   = zc_MI_Master()
                                                             AND MovementItem.isErased = FALSE
                                      INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                         AND Movement.DescId   = zc_Movement_PriceList()
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                 WHERE tmpItem.EKPrice = 0
                                )
           -- ���������
           SELECT tmpItem.*
                , COALESCE (tmpItemPrice.EKPrice, tmpItem.EKPrice) AS EKPrice_find
           FROM tmpItem
                LEFT JOIN tmpItemPrice ON tmpItemPrice.GoodsId = tmpItem.GoodsId
                                      AND tmpItemPrice.Ord     = 1
          ) AS tmpItem
    ;


     -- ������� - ��� - zc_MI_Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE;


     -- ��������� - zc_MI_Child - ������� �����������
     UPDATE _tmpItem_Child SET MovementItemId = lpInsertUpdate_MI_Send_Child (ioId                     := _tmpItem_Child.MovementItemId
                                                                            , inParentId               := _tmpItem_Child.ParentId
                                                                            , inMovementId             := inMovementId
                                                                            , inMovementId_OrderClient := _tmpItem_Child.MovementId_order_from
                                                                            , inObjectId               := _tmpItem_Child.GoodsId
                                                                            , inPartionId              := _tmpItem_Child.PartionId
                                                                              -- ���-�� ������
                                                                            , inAmount                 := _tmpItem_Child.Amount
                                                                            , inUserId                 := inUserId
                                                                             )
     -- !!!��� ��������
     --WHERE _tmpItem_Child.MovementItemId = 0
    ;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem_Child SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_From
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                          , inPartionId              := _tmpItem_Child.PartionId
                                                                                          , inMovementId_order       := _tmpItem_Child.MovementId_order_from
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
                             , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_To
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                          , inPartionId              := _tmpItem_Child.PartionId
                                                                                          , inMovementId_order       := _tmpItem_Child.MovementId_order_to
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
     FROM _tmpItem
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
    ;

     -- 2. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem_Child SET AccountId_From = _tmpItem_byAccount.AccountId_From
                             , AccountId_To   = _tmpItem_byAccount.AccountId_To
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_From
                , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_To
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_To
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
          JOIN _tmpItem ON _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
    ;


     -- 3. ������������ ContainerId_Summ ��� �������� �� ��������� �����
     UPDATE _tmpItem_Child SET ContainerId_SummFrom = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_From
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpItem_Child.AccountId_From
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpItem_Child.ContainerId_GoodsFrom
                                                                                        , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                        , inPartionId              := _tmpItem_Child.PartionId
                                                                                        , inMovementId_order       := _tmpItem_Child.MovementId_order_from
                                                                                        , inIsReserve              := FALSE
                                                                                         )
                             , ContainerId_SummTo   = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_To
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpItem_Child.AccountId_To
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpItem_Child.ContainerId_GoodsTo
                                                                                        , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                        , inPartionId              := _tmpItem_Child.PartionId
                                                                                        , inMovementId_order       := _tmpItem_Child.MovementId_order_to
                                                                                        , inIsReserve              := FALSE
                                                                                         )
     FROM _tmpItem
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
    ;


     -- 4.1. ����������� �������� - ������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_GoodsFrom
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_From           AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbUnitId_From                           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_To             AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Child.ContainerId_GoodsTo      AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ���� ��� ...
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� ���� - ������
            , -1 * _tmpItem_Child.Amount              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
      UNION ALL
       -- �������� - ������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_GoodsTo
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_To             AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_From           AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Child.ContainerId_GoodsFrom    AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ���� ��� ...
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� �� ���� - ������
            , 1 * _tmpItem_Child.Amount               AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Child;


     -- 4.2. ����������� �������� - ������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_SummFrom
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_From           AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbUnitId_From                           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_To             AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Child.ContainerId_SummTo       AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ���� ��� ...
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� ���� - ������
            , -1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                             THEN Container_Summ.Amount
                        ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                   END                                AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_SummFrom

      UNION ALL
       -- �������� - ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_SummTo
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_To             AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_From           AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Child.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ���� ��� ...
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� �� ���� - ������
            , 1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                            THEN Container_Summ.Amount
                       ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                  END                                 AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_SummFrom
      ;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Send()
                                , inUserId     := inUserId
                                 );

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 3190 , inSession:= zfCalc_UserAdmin())