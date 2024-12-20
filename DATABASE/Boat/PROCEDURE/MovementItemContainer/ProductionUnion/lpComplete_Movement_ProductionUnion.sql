DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion(
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
  DECLARE vbParentId              Integer;
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
             AND Movement.DescId   = zc_Movement_ProductionUnion()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;

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



     -- ��������� ������� - �������� ���������
     INSERT INTO _tmpItem_pr (MovementItemId
                            , GoodsId, PartionId
                            , ContainerId_Summ, ContainerId_Goods
                            , Amount
                            , PartNumber
                            , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                            , MovementId_order
                             )
        -- ���������
        SELECT MovementItem.Id                  AS MovementItemId
             , MovementItem.ObjectId            AS GoodsId
               -- !!!������� ������!!!
             , MovementItem.Id                  AS PartionId
               -- ���������� �����
             , 0 AS ContainerId_Summ, 0 AS ContainerId_Goods
               --
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
            , COALESCE (MIFloat_MovementId.ValueData, 0) AS MovementId_order

        FROM MovementItem
             -- ValueData - MovementId ����� �������
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                             ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId   = zc_Object_Product()
                                                                                  -- ������� �����
                                                                                  THEN zc_Enum_InfoMoney_30101()
                                                                                  -- !!!��������!!! �������������
                                                                                  ELSE COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())
                                                                             END

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
       ;

     -- ��������� ������� - �������� ���������
     INSERT INTO _tmpItem_Child_mi (MovementItemId, ParentId
                                  , GoodsId
                                  , Amount
                                  , PartNumber
                                  , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                                   )
        -- ���������
        SELECT MovementItem.Id                  AS MovementItemId
             , MovementItem.ParentId            AS ParentId
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

        FROM MovementItem
             INNER JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = MovementItem.ParentId

             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
             -- !!!��������!!! �������������
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
       ;

     -- ��������� ������� - �������� ��������� - �� + ������
     INSERT INTO _tmpItem_Detail (MovementItemId, ParentId
                                , ReceiptServiceId, PersonalId, PartnerId
                                , Amount
                                , OperSumm_VAT, VATPercent
                                 )
        -- ���������
        SELECT MovementItem.Id                  AS MovementItemId
             , MovementItem.ParentId            AS ParentId
               -- ������
             , COALESCE (MovementItem.ObjectId, 0)            AS ReceiptServiceId
               -- ���������
             , COALESCE (MILinkObject_Personal.ObjectId, 0)   AS PersonalId
               -- ��������� �����
             , COALESCE (ObjectLink_Partner.ChildObjectId, 0) AS PartnerId
               -- ��������� ����� ��� ����� ��� ���
             , MovementItem.Amount              AS Amount
               -- ����� ���
             , zfCalc_SummVATDiscountTax (MovementItem.Amount, 0, ObjectFloat_TaxKind_Value.ValueData)
               -- % ���
             , COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) AS VATPercent
        FROM MovementItem
             INNER JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = MovementItem.ParentId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Personal
                                              ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Personal.DescId         = zc_MILinkObject_Personal()
             LEFT JOIN ObjectLink AS ObjectLink_Partner
                                  ON ObjectLink_Partner.ObjectId      = MovementItem.ObjectId
                                 AND ObjectLink_Partner.DescId        = zc_ObjectLink_ReceiptService_Partner()
             LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                  ON ObjectLink_TaxKind.ObjectId      = ObjectLink_Partner.ChildObjectId
                                 AND ObjectLink_TaxKind.DescId        = zc_ObjectLink_Partner_TaxKind()
             LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                   ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                  AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Detail()
          AND MovementItem.isErased   = FALSE
       ;

     -- ��������
     IF EXISTS (SELECT 1 FROM _tmpItem_Detail WHERE _tmpItem_Detail.ReceiptServiceId = 0)
     THEN
         RAISE EXCEPTION '������.����� ���� = <%>.%�� ����������� �������� ����������� �����.'
                        , (SELECT zfCalc_GoodsName_all (lfGet_Object_Article (_tmpItem_pr.GoodsId), lfGet_Object_ValueData_sh (_tmpItem_pr.GoodsId))
                           FROM _tmpItem_Detail
                                JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Detail.ParentId
                           WHERE _tmpItem_Detail.ReceiptServiceId = 0
                           ORDER BY _tmpItem_Detail.MovementItemId LIMIT 1
                          )
                        , CHR (13)
                         ;
     END IF;

     -- ��������
     IF EXISTS (SELECT 1 FROM _tmpItem_Detail WHERE _tmpItem_Detail.PersonalId = 0 AND _tmpItem_Detail.PartnerId = 0)
     THEN
         RAISE EXCEPTION '������.����� ���� = <%>.%��� ����������� ����� <%> %�� ����������� �������� <���������>.'
                        , (SELECT zfCalc_GoodsName_all (lfGet_Object_Article (_tmpItem_pr.GoodsId), lfGet_Object_ValueData_sh (_tmpItem_pr.GoodsId))
                           FROM _tmpItem_Detail
                                JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Detail.ParentId
                           WHERE _tmpItem_Detail.PersonalId = 0 AND _tmpItem_Detail.PartnerId = 0
                           ORDER BY _tmpItem_Detail.MovementItemId LIMIT 1
                          )
                        , CHR (13)
                        , (SELECT lfGet_Object_ValueData_sh (_tmpItem_Detail.ReceiptServiceId)
                           FROM _tmpItem_Detail
                           WHERE _tmpItem_Detail.PersonalId = 0 AND _tmpItem_Detail.PartnerId = 0
                           ORDER BY _tmpItem_Detail.MovementItemId LIMIT 1
                          )
                        , CHR (13)
                         ;
     END IF;



     -- 2.��������� ������� - �������� �� �������

     -- ������1 - �������� ���������
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.ParentId
                           , _tmpItem.GoodsId, _tmpItem.PartNumber
                             -- �� �������
                           , _tmpItem_pr.MovementId_order AS MovementId_order_to
                             --
                           , _tmpItem.Amount
                      FROM _tmpItem_Child_mi AS _tmpItem
                           INNER JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem.ParentId
                     ;
     -- ������ ����� �� �������1 - �������� ���������
     LOOP
     -- ������ �� �������
     FETCH curItem INTO vbMovementItemId, vbParentId, vbGoodsId, vbPartNumber, vbMovementId_order_to, vbAmount;
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
          --
          AND (-- ������ MovementId ������������, � ��� �� �������
               (CLO_PartionMovement.ObjectId = vbMovementId_order_to AND vbMovementId_order_to > 0)
               -- ������ MovementId � �������� �������
            OR COALESCE (CLO_PartionMovement.ObjectId, 0) = 0
              )


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
                                           , MovementId_order
                                           , isPartion_new
                                            )
                    SELECT vbMovementItemId        AS MovementItemId
                         , vbParentId              AS ParentId
                         , vbGoodsId               AS GoodsId
                         , vbPartionId             AS PartionId
                           -- ����� ������ ���-��
                         , vbAmount                AS Amount
                           --
                         , vbMovementId_order_from AS MovementId_order
                         , FALSE
                          ;
                 -- �������� ���-��, ������ �� ���� ������
                 vbAmount:= 0;
             ELSE
                 -- ��������� ������� - �������� zc_MI_Child ���������
                 INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , Amount
                                           , MovementId_order
                                           , isPartion_new
                                            )
                    SELECT vbMovementItemId        AS MovementItemId
                         , vbParentId              AS ParentId
                         , vbGoodsId               AS GoodsId
                         , vbPartionId             AS PartionId
                           -- ��������� ���� ������� �� ���� ������
                         , vbAmount_partion        AS Amount
                           --
                         , vbMovementId_order_from AS MovementId_order
                         , FALSE
                          ;

                 -- ��������� ������ ���-�� �� ������� � ���������� ������
                 vbAmount:= vbAmount - vbAmount_partion;

             END IF;


         END LOOP; -- ����� ����� �� �������2. - ������� �� �������
         CLOSE curPartion; -- ������� ������2. - ������� �� �������


     END LOOP; -- ����� ����� �� �������1 - �������� ���������
     CLOSE curItem; -- ������� ������1 - �������� ���������


     -- �������� ������ - !!!������!!!, ������� ���� �������, �.�. �������� �� ��� �� �����
     INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                               , GoodsId, PartionId
                               , Amount
                               , MovementId_order
                               , isPartion_new
                                )
        SELECT _tmpItem_Child_mi.MovementItemId AS MovementItemId -- ���������� �����
             , _tmpItem_Child_mi.ParentId       AS ParentId
             , _tmpItem_Child_mi.GoodsId
               -- !!!������ ��������� ?��������� ����������?
             , COALESCE (tmpItem_Child.PartionId, tmpItem_partion_new.MovementItemId) AS PartionId
               -- ������� � ���� ������ �������� �������
             , _tmpItem_Child_mi.Amount - COALESCE (tmp.Amount, 0)
               -- �� �������
             , _tmpItem_pr.MovementId_order
               -- ������� - ����� ���� ������� ������
             , CASE WHEN tmpItem_partion_new.MovementItemId > 0 THEN TRUE ELSE FALSE END AS isPartion_new

        FROM _tmpItem_Child_mi
             -- ������
             LEFT JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Child_mi.ParentId
             -- ������� ������ ���������, �� ���� �������
             LEFT JOIN (SELECT _tmpItem_Child.MovementItemId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.MovementItemId
                       ) AS tmp
                         ON tmp.MovementItemId = _tmpItem_Child_mi.MovementItemId
             -- ������ !!!������!!! ���� - ���� �� �����, �� ��� � ������� �����
             LEFT JOIN (SELECT MAX (_tmpItem_Child.PartionId) AS PartionId, _tmpItem_pr.MovementId_order, _tmpItem_Child.GoodsId
                        FROM _tmpItem_Child
                             LEFT JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Child.ParentId
                        GROUP BY _tmpItem_pr.MovementId_order, _tmpItem_Child.GoodsId
                       ) AS tmpItem_Child
                         ON tmpItem_Child.MovementId_order = _tmpItem_pr.MovementId_order
                        AND tmpItem_Child.GoodsId          = _tmpItem_Child_mi.GoodsId

             -- ������ !!!������!!! ���� (�.�. ������ �����������) - � ���� MovementItemId �� ��������
             LEFT JOIN (SELECT MAX (_tmpItem_Child_mi.MovementItemId) AS MovementItemId, _tmpItem_pr.MovementId_order, _tmpItem_Child_mi.GoodsId
                        FROM _tmpItem_Child_mi
                             LEFT JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Child_mi.ParentId
                        GROUP BY _tmpItem_pr.MovementId_order, _tmpItem_Child_mi.GoodsId
                       ) AS tmpItem_partion_new
                         ON tmpItem_partion_new.MovementId_order = _tmpItem_pr.MovementId_order
                        AND tmpItem_partion_new.GoodsId          = _tmpItem_Child_mi.GoodsId
                        -- ���� �� ����� ������������
                        AND tmpItem_Child.GoodsId IS NULL

        WHERE _tmpItem_Child_mi.Amount - COALESCE (tmp.Amount, 0) > 0
       ;

         /*RAISE EXCEPTION '������. %  <%>'
                       , (SELECT count(*) FROM _tmpItem_Child where MovementId_order > 0)
                       , (SELECT count(*) FROM _tmpItem_Child where coalesce (MovementId_order, 0) = 0)
                        ;*/


     -- �������� - ���� ������ ���������, ����� ��� ���� ��� GoodsId + MovementId_order
     IF EXISTS (SELECT _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                FROM _tmpItem_Child
                WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                GROUP BY _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                HAVING COUNT(*) > 1
               )
     THEN
         RAISE EXCEPTION '������.������ ���������, �� ��� �� ���� ��� GoodsId + MovementId_order.%<%>%<%>'
                       , CHR (13)
                       , (SELECT lfGet_Object_ValueData (tmp.GoodsId)
                          FROM (SELECT _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                                FROM _tmpItem_Child
                                WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                                GROUP BY _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                                HAVING COUNT(*) > 1
                               ) AS tmp
                          ORDER BY tmp.GoodsId, tmp.MovementId_order
                          LIMIT 1
                         )
                       , CHR (13)
                       , (SELECT tmp.MovementId_order
                          FROM (SELECT _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                                FROM _tmpItem_Child
                                WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                                GROUP BY _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                                HAVING COUNT(*) > 1
                               ) AS tmp
                          ORDER BY tmp.GoodsId, tmp.MovementId_order
                          LIMIT 1
                         )
                         ;
     END IF;


--  RAISE EXCEPTION '������. <%>', (SELECT sum(Amount) FROM _tmpItem_Child where MovementItemId = 547014);

     -- �������� - ���������� ���-�� _tmpItem_Child_mi + _tmpItem_Child
     IF EXISTS (SELECT 1
                FROM _tmpItem_Child_mi AS _tmpItem
                     FULL JOIN (SELECT _tmpItem_Child.MovementItemId, SUM (_tmpItem_Child.Amount) AS Amount FROM _tmpItem_Child GROUP BY _tmpItem_Child.MovementItemId
                               ) AS tmpRes ON tmpRes.MovementItemId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
               )
     THEN
         RAISE EXCEPTION '������.���-�� � ��������� �� ����� ���������� �� ���-�� � �������.%<%> %MovementId_order = <%> %MovementItemId = <%> %Amount = <%> %Amount_partion = <%>'
                       , CHR (13)
                       , (SELECT lfGet_Object_ValueData (tmp.GoodsId)
                          FROM (SELECT COALESCE (_tmpItem.GoodsId, tmpRes.GoodsId) AS GoodsId, tmpRes.MovementId_order, COALESCE (_tmpItem.MovementItemId, tmpRes.MovementItemId) AS MovementItemId
                                     , _tmpItem.Amount, tmpRes.Amount AS Amount_partion
                                FROM _tmpItem_Child_mi AS _tmpItem
                                     FULL JOIN (SELECT _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId, SUM (_tmpItem_Child.Amount) AS Amount FROM _tmpItem_Child GROUP BY _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId
                                               ) AS tmpRes ON tmpRes.MovementItemId = _tmpItem.MovementItemId
                                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
                               ) AS tmp
                          ORDER BY tmp.MovementItemId, tmp.GoodsId, tmp.MovementId_order
                          LIMIT 1
                         )
                       , CHR (13)
                       , (SELECT tmp.MovementId_order
                          FROM (SELECT _tmpItem.GoodsId, tmpRes.MovementId_order, COALESCE (_tmpItem.MovementItemId, tmpRes.MovementItemId) AS MovementItemId
                                     , _tmpItem.Amount, tmpRes.Amount AS Amount_partion
                                FROM _tmpItem_Child_mi AS _tmpItem
                                     FULL JOIN (SELECT _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId, SUM (_tmpItem_Child.Amount) AS Amount FROM _tmpItem_Child GROUP BY _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId
                                               ) AS tmpRes ON tmpRes.MovementItemId = _tmpItem.MovementItemId
                                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
                               ) AS tmp
                          ORDER BY tmp.MovementItemId, tmp.GoodsId, tmp.MovementId_order
                          LIMIT 1
                         )
                       , CHR (13)
                       , (SELECT tmp.MovementItemId
                          FROM (SELECT _tmpItem.GoodsId, tmpRes.MovementId_order, COALESCE (_tmpItem.MovementItemId, tmpRes.MovementItemId) AS MovementItemId
                                     , _tmpItem.Amount, tmpRes.Amount AS Amount_partion
                                FROM _tmpItem_Child_mi AS _tmpItem
                                     FULL JOIN (SELECT _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId, SUM (_tmpItem_Child.Amount) AS Amount FROM _tmpItem_Child GROUP BY _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId
                                               ) AS tmpRes ON tmpRes.MovementItemId = _tmpItem.MovementItemId
                                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
                               ) AS tmp
                          ORDER BY tmp.MovementItemId, tmp.GoodsId, tmp.MovementId_order
                          LIMIT 1
                         )
                       , CHR (13)
                       , (SELECT tmp.Amount
                          FROM (SELECT _tmpItem.GoodsId, tmpRes.MovementId_order, COALESCE (_tmpItem.MovementItemId, tmpRes.MovementItemId) AS MovementItemId
                                     , _tmpItem.Amount, tmpRes.Amount AS Amount_partion
                                FROM _tmpItem_Child_mi AS _tmpItem
                                     FULL JOIN (SELECT _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId, SUM (_tmpItem_Child.Amount) AS Amount FROM _tmpItem_Child GROUP BY _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId
                                               ) AS tmpRes ON tmpRes.MovementItemId = _tmpItem.MovementItemId
                                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
                               ) AS tmp
                          ORDER BY tmp.MovementItemId, tmp.GoodsId, tmp.MovementId_order
                          LIMIT 1
                         )
                       , CHR (13)
                       , (SELECT tmp.Amount_partion
                          FROM (SELECT _tmpItem.GoodsId, tmpRes.MovementId_order, COALESCE (_tmpItem.MovementItemId, tmpRes.MovementItemId) AS MovementItemId
                                     , _tmpItem.Amount, tmpRes.Amount AS Amount_partion
                                FROM _tmpItem_Child_mi AS _tmpItem
                                     FULL JOIN (SELECT _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId, SUM (_tmpItem_Child.Amount) AS Amount FROM _tmpItem_Child GROUP BY _tmpItem_Child.MovementItemId, _tmpItem_Child.MovementId_order, _tmpItem_Child.GoodsId
                                               ) AS tmpRes ON tmpRes.MovementItemId = _tmpItem.MovementItemId
                                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
                               ) AS tmp
                          ORDER BY tmp.MovementItemId, tmp.GoodsId, tmp.MovementId_order
                          LIMIT 1
                         )
                        ;
     END IF;


     -- ������� ������ - !!!������!!!
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := _tmpItem_pr.PartionId
                                               , inMovementId        := inMovementId              -- ���� ���������
                                               , inFromId            := vbUnitId_From             -- ��������� ��� ������������� (����� ������)
                                               , inUnitId            := vbUnitId_To               -- �������������(�������)
                                               , inOperDate          := vbOperDate                -- ���� �������
                                               , inObjectId          := _tmpItem_pr.GoodsId       -- ������������� ��� �����
                                               , inAmount            := _tmpItem_pr.Amount        -- ���-�� ������
                                                 --
                                               , inEKPrice           := 0                         -- ���� ��. ��� ���, � ������ ���� ������ + ������� + �������: �������� + �������� + ��������� = inEKPrice_discount + inCostPrice
                                               , inEKPrice_orig      := 0                         -- ���� ��. ��� ���, � ������ ������ ������ �� ��������
                                               , inEKPrice_discount  := 0                         -- ���� ��. ��� ���, � ������ ���� ������ (������ ����� ���)
                                               , inCostPrice         := 0                         -- ���� ������ ��� ��� (������� + �������: �������� + �������� + ���������)
                                               , inCountForPrice     := 1                         -- ���� �� ����������
                                                 --
                                               , inEmpfPrice         := 0                         -- ���� ��������. ��� ���
                                               , inOperPriceList     := 0                         -- ���� �������
                                               , inOperPriceList_old := 0                         -- ���� �������, �� ��������� ������
                                                 -- ��� ��� (!������������!)
                                               , inTaxKindId         := zc_Enum_TaxKind_Basis()
                                                 -- �������� ��� (!������������!)
                                               , inTaxKindValue      := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis()  AND OFl.DescId = zc_ObjectFloat_TaxKind_Value())
                                                 --
                                               , inUserId            := inUserId
                                                )
     FROM _tmpItem_pr
    ;
    
     -- �������� ������
     UPDATE MovementItem SET PartionId = _tmpItem_pr.PartionId
     FROM _tmpItem_pr
     WHERE MovementItem.Id = _tmpItem_pr.MovementItemId
       AND MovementItem.PartionId IS NULL
    ;


/*
    RAISE EXCEPTION '������.<%>   <%>   <%>   <%>', (select count(*) from _tmpItem_Child where _tmpItem_Child.PartionId = 17959)
, (select min (_tmpItem_Child.PartionId) from _tmpItem_Child where _tmpItem_Child.GoodsId = 14052)
, (select max (_tmpItem_Child.PartionId) from _tmpItem_Child where _tmpItem_Child.GoodsId = 14052)
, (select _tmpItem_Child.isId_order from _tmpItem_Child where _tmpItem_Child.GoodsId = 14052 limit 1)
;
*/
     -- ���� ������ �� ����� - !!!����������� ��������� ����� - ��� ������ ����� �������!!!
     /*UPDATE _tmpItem_Child SET PartionId = tmpItem_Child.PartionId_new
     FROM (WITH tmpPartion AS (SELECT _tmpItem_Child.GoodsId             AS GoodsId
                                    , _tmpItem_Child.PartionId           AS PartionId_old
                                      -- ����� ������
                                    , Object_PartionGoods.MovementItemId AS PartionId_new
                                      -- � �/�
                                    , ROW_NUMBER() OVER (PARTITION BY _tmpItem_Child.GoodsId
                                                         ORDER BY CASE WHEN MovementItem.Amount > 0 THEN 0 ELSE 1 END
                                                                , CASE WHEN Movement.Id > 0 THEN 0 ELSE 1 END
                                                                , COALESCE (Movement.OperDate, zc_DateStart()) DESC
                                                                , Object_PartionGoods.MovementItemId ASC
                                                        ) AS Ord
                               FROM _tmpItem_Child
                                    -- ���� ��� "�������" ������ - ��� ����� ����� ������������
                                    -- LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId

                                    -- ���� ��� "�����" ������
                                    INNER JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = _tmpItem_Child.GoodsId
                                    -- ��� ������ ����� �������
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = Object_PartionGoods.MovementItemId
                                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                               AND MIFloat_MovementId.ValueData      > 0
                                    -- ��� S/N
                                    LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                 ON MIString_PartNumber.MovementItemId = Object_PartionGoods.MovementItemId
                                                                AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                                                AND MIString_PartNumber.ValueData      <> ''
                                    -- ���� ��� ������ ������
                                    LEFT JOIN MovementItem ON MovementItem.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem.isErased = FALSE
                                                          AND MovementItem.Amount   > 0
                                    -- ���� ��� "�����" ������ �� ������ 0
                                    LEFT JOIN MovementItem AS MovementItem_two
                                                           ON MovementItem_two.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem_two.isErased = FALSE
                                                          AND MovementItem_two.Amount   <> 0
                                    -- �������� - ��������
                                    LEFT JOIN Movement ON Movement.Id       = COALESCE (MovementItem.MovementId, MovementItem_two.MovementId)
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                               -- ������� - ����� ��������� ������
                               WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                                 AND _tmpItem_Child.isId_order     = FALSE
                                 -- ��� ������ ����� �������
                                 AND MIFloat_MovementId.MovementItemId IS NULL
                                 -- ��� S/N
                                 AND MIString_PartNumber.MovementItemId IS NULL
                              )
           -- ���������
           SELECT tmpPartion.PartionId_old, tmpPartion.PartionId_new
           FROM tmpPartion
           -- ����� ������ ������
           WHERE tmpPartion.Ord = 1
          ) AS tmpItem_Child

     WHERE _tmpItem_Child.PartionId = tmpItem_Child.PartionId_old
    ;*/


     -- ���� ������ !!!�����!!!����������� ����� - � ������ ����� �������!!!
     /*UPDATE _tmpItem_Child SET PartionId = tmpItem_Child.PartionId_new
     FROM (WITH tmpPartion AS (SELECT _tmpItem_Child.MovementId_order    AS MovementId_order
                                    , _tmpItem_Child.PartionId           AS PartionId_old
                                      -- ����� ������
                                    , Object_PartionGoods.MovementItemId AS PartionId_new
                                      -- � �/�
                                    , ROW_NUMBER() OVER (PARTITION BY _tmpItem_Child.GoodsId
                                                         ORDER BY CASE WHEN MovementItem.Amount > 0 THEN 0 ELSE 1 END
                                                                , CASE WHEN Movement.Id > 0 THEN 0 ELSE 1 END
                                                                , COALESCE (Movement.OperDate, zc_DateStart()) DESC
                                                                , Object_PartionGoods.MovementItemId ASC
                                                        ) AS Ord
                               FROM _tmpItem_Child
                                    -- ���� ��� "�����" ������
                                    INNER JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = _tmpItem_Child.GoodsId
                                    -- ������ ����� �������
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = Object_PartionGoods.MovementItemId
                                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                    -- ���� ��� ������ ������
                                    LEFT JOIN MovementItem ON MovementItem.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem.isErased = FALSE
                                                          AND MovementItem.Amount   > 0
                                    -- ���� ��� "�����" ������ �� ������ 0
                                    LEFT JOIN MovementItem AS MovementItem_two
                                                           ON MovementItem_two.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem_two.isErased = FALSE
                                                          AND MovementItem_two.Amount   <> 0
                                    -- �������� - ��������
                                    LEFT JOIN Movement ON Movement.Id       = COALESCE (MovementItem.MovementId, MovementItem_two.MovementId)
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                               -- ������� - ����� ��������� ������
                               WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                                 AND _tmpItem_Child.isId_order     = TRUE
                                 -- ������ ����� �������
                                 AND COALESCE (MIFloat_MovementId.ValueData, 0) = COALESCE (_tmpItem_Child.MovementId_order, 0)
                              )
           -- ���������
           SELECT tmpPartion.MovementId_order, tmpPartion.PartionId_old, tmpPartion.PartionId_new
           FROM tmpPartion
           -- ����� ������ ������
           WHERE tmpPartion.Ord = 1
          ) AS tmpItem_Child

     WHERE _tmpItem_Child.PartionId        = tmpItem_Child.PartionId_old
       AND _tmpItem_Child.MovementId_order = tmpItem_Child.MovementId_order
    ;*/

     -- ������� ������ - !!!������!!!
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := tmpItem.PartionId
                                               , inMovementId        := inMovementId              -- ���� ���������
                                               , inFromId            := vbUnitId_From             -- ��������� ��� ������������� (����� ������)
                                               , inUnitId            := vbUnitId_From             -- �������������(�������)
                                               , inOperDate          := vbOperDate                -- ���� �������
                                               , inObjectId          := tmpItem.GoodsId           -- ������������� ��� �����
                                               , inAmount            := 0                         -- ���-�� ������
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
                                               , inTaxKindValue      := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value())
                                                 --
                                               , inUserId            := inUserId
                                                )
     FROM (WITH --
                tmpItem AS (SELECT _tmpItem_Child.*
                                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0)    AS EKPrice
                                 , COALESCE (ObjectFloat_EmpfPrice .ValueData, 0) AS EmpfPrice
                            FROM _tmpItem_Child
                                 -- 
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                       ON ObjectFloat_EKPrice.ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                       ON ObjectFloat_EmpfPrice .ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EmpfPrice .DescId   =  zc_ObjectFloat_Goods_EmpfPrice ()
                            -- ������� - ����� ���� ������� ������
                            WHERE _tmpItem_Child.isPartion_new = TRUE
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
           SELECT DISTINCT
                  tmpItem.PartionId
                , tmpItem.GoodsId
                , tmpItem.EmpfPrice
                , COALESCE (tmpItemPrice.EKPrice, tmpItem.EKPrice) AS EKPrice_find
           FROM tmpItem
                LEFT JOIN tmpItemPrice ON tmpItemPrice.GoodsId = tmpItem.GoodsId
                                      AND tmpItemPrice.Ord     = 1
          ) AS tmpItem
    ;

     -- ������� ��-�� � ������ - !!!������!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), _tmpItem_Child.MovementItemId, COALESCE (_tmpItem_Child.MovementId_order, 0))
     FROM _tmpItem_Child
     WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
    ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1. ������������ ContainerId_Goods ��� ��������������� ����� - ������
     UPDATE _tmpItem_pr SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                   , inUnitId                 := vbUnitId_To
                                                                                   , inMemberId               := NULL
                                                                                   , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                                                   , inGoodsId                := _tmpItem_pr.GoodsId
                                                                                   , inPartionId              := _tmpItem_pr.PartionId
                                                                                   , inMovementId_order       := _tmpItem_pr.MovementId_order
                                                                                   , inIsReserve              := FALSE
                                                                                   , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                    );

     -- 1.2. ������������ ContainerId_Goods ��� ��������������� ����� - ������
     UPDATE _tmpItem_Child SET ContainerId_Goods = tmpItem_Child_mi.ContainerId_Goods
     FROM (SELECT lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                     , inUnitId                 := vbUnitId_From
                                                     , inMemberId               := NULL
                                                     , inInfoMoneyDestinationId := tmpItem_Child_mi.InfoMoneyDestinationId
                                                     , inGoodsId                := tmpItem_Child_mi.GoodsId
                                                     , inPartionId              := tmpItem_Child_mi.PartionId
                                                     , inMovementId_order       := tmpItem_Child_mi.MovementId_order
                                                     , inIsReserve              := FALSE
                                                     , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                      ) AS ContainerId_Goods
                , tmpItem_Child_mi.PartionId
           FROM (SELECT DISTINCT
                        _tmpItem_Child_mi.InfoMoneyDestinationId
                      , _tmpItem_Child.GoodsId
                      , _tmpItem_Child.PartionId
                      , _tmpItem_Child.MovementId_order
                FROM _tmpItem_Child
                     JOIN _tmpItem_Child_mi ON _tmpItem_Child_mi.MovementItemId = _tmpItem_Child.MovementItemId
               ) AS tmpItem_Child_mi
          ) AS tmpItem_Child_mi
     WHERE _tmpItem_Child.PartionId = tmpItem_Child_mi.PartionId
    ;

     -- 2.1. ������������ AccountId ��� �������� �� ��������� ����� - ������
     UPDATE _tmpItem_pr SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_To
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_pr.InfoMoneyDestinationId FROM _tmpItem_pr) AS _tmpItem_group
          ) AS _tmpItem_byAccount
    ;
     -- 2.2. ������������ AccountId ��� �������� �� ��������� ����� - ������
     UPDATE _tmpItem_Child SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_Child_mi.InfoMoneyDestinationId FROM _tmpItem_Child_mi) AS _tmpItem_group
          ) AS _tmpItem_byAccount
          JOIN _tmpItem_Child_mi ON _tmpItem_Child_mi.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
     WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child_mi.MovementItemId
    ;

     -- 2.3. ������������ AccountId ��� �������� �� ��������� ����� - ���������
     UPDATE _tmpItem_Detail SET AccountId     = _tmpAccount.AccountId
                              , AccountId_VAT = _tmpAccount.AccountId_VAT
     FROM (SELECT -- ���������
                  lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_60000()                   -- ���������
                                             , inAccountDirectionId     := CASE WHEN tmpItem_Detail.PartnerId > 0
                                                                                THEN zc_Enum_AccountDirection_60300()     -- ��������� �� �������
                                                                                ELSE zc_Enum_AccountDirection_60200()     -- ����������
                                                                           END
                                             , inInfoMoneyDestinationId := CASE WHEN tmpItem_Detail.PartnerId > 0
                                                                                THEN zc_Enum_InfoMoneyDestination_20700() -- ������ ����������
                                                                                ELSE zc_Enum_InfoMoneyDestination_60100() -- ���������� �����
                                                                           END
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                  -- ���
                , CASE WHEN tmpItem_Detail.PartnerId > 0 AND tmpItem_Detail.OperSumm_VAT <> 0
                  THEN
                  lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_80000()     -- ������� ������
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_80500() -- ���
                                             , inInfoMoneyDestinationId := View_InfoMoney_VAT.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              )
                  END AS AccountId_VAT
                  --
                , tmpItem_Detail.PersonalId
                , tmpItem_Detail.PartnerId

           FROM (SELECT _tmpItem_Detail.PersonalId, _tmpItem_Detail.PartnerId, SUM (_tmpItem_Detail.OperSumm_VAT) AS OperSumm_VAT
                 FROM _tmpItem_Detail
                 GROUP BY _tmpItem_Detail.PersonalId, _tmpItem_Detail.PartnerId
                ) AS tmpItem_Detail
                -- ������� ������ + ���
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_VAT ON View_InfoMoney_VAT.InfoMoneyId = zc_Enum_InfoMoney_50501()
          ) AS _tmpAccount
     WHERE _tmpItem_Detail.PersonalId = _tmpAccount.PersonalId
       AND _tmpItem_Detail.PartnerId  = _tmpAccount.PartnerId
          ;


     -- 3.1. ������������ ContainerId_Summ ��� �������� �� ��������� ����� - ������
     UPDATE _tmpItem_pr SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                 , inUnitId                 := vbUnitId_To
                                                                                 , inMemberId               := NULL
                                                                                 , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                 , inBusinessId             := vbBusinessId
                                                                                 , inAccountId              := _tmpItem_pr.AccountId
                                                                                 , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                                                 , inInfoMoneyId            := _tmpItem_pr.InfoMoneyId
                                                                                 , inContainerId_Goods      := _tmpItem_pr.ContainerId_Goods
                                                                                 , inGoodsId                := _tmpItem_pr.GoodsId
                                                                                 , inPartionId              := _tmpItem_pr.PartionId
                                                                                 , inMovementId_order       := _tmpItem_pr.MovementId_order
                                                                                 , inIsReserve              := FALSE
                                                                                  );

     -- 3.2. ������������ ContainerId_Summ ��� �������� �� ��������� ����� - ������
     UPDATE _tmpItem_Child SET ContainerId_Summ = tmpItem_Child_mi.ContainerId_Summ
     FROM (SELECT lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                    , inUnitId                 := vbUnitId_From
                                                    , inMemberId               := NULL
                                                    , inJuridicalId_basis      := vbJuridicalId_Basis
                                                    , inBusinessId             := vbBusinessId
                                                    , inAccountId              := tmpItem_Child_mi.AccountId
                                                    , inInfoMoneyDestinationId := tmpItem_Child_mi.InfoMoneyDestinationId
                                                    , inInfoMoneyId            := tmpItem_Child_mi.InfoMoneyId
                                                    , inContainerId_Goods      := tmpItem_Child_mi.ContainerId_Goods
                                                    , inGoodsId                := tmpItem_Child_mi.GoodsId
                                                    , inPartionId              := tmpItem_Child_mi.PartionId
                                                    , inMovementId_order       := tmpItem_Child_mi.MovementId_order
                                                    , inIsReserve              := FALSE
                                                     ) AS ContainerId_Summ
                , tmpItem_Child_mi.ContainerId_Goods
           FROM (SELECT DISTINCT
                        _tmpItem_Child.AccountId
                      , _tmpItem_Child_mi.InfoMoneyDestinationId
                      , _tmpItem_Child_mi.InfoMoneyId
                      , _tmpItem_Child.ContainerId_Goods
                      , _tmpItem_Child.GoodsId
                      , _tmpItem_Child.PartionId
                      , _tmpItem_Child.MovementId_order
                FROM _tmpItem_Child
                     JOIN _tmpItem_Child_mi ON _tmpItem_Child_mi.MovementItemId = _tmpItem_Child.MovementItemId
               ) AS tmpItem_Child_mi
          ) AS tmpItem_Child_mi
     WHERE _tmpItem_Child.ContainerId_Goods = tmpItem_Child_mi.ContainerId_Goods
    ;

     -- 3.3. ������������ ContainerId_Summ ��� �������� �� ��������� ����� - ���������
     UPDATE _tmpItem_Detail SET ContainerId_Summ = CASE WHEN _tmpItem_Detail.PartnerId > 0
                                                        THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                   , inParentId          := NULL
                                                                                   , inObjectId          := _tmpItem_Detail.AccountId
                                                                                   , inPartionId         := NULL
                                                                                   , inIsReserve         := FALSE
                                                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                                                   , inBusinessId        := vbBusinessId
                                                                                   , inDescId_1          := zc_ContainerLinkObject_Partner()
                                                                                   , inObjectId_1        := _tmpItem_Detail.PartnerId
                                                                                   , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                                     -- ������������� + ������ ���������� + ������ ������, ������
                                                                                   , inObjectId_2        := zc_Enum_InfoMoney_20707()
                                                                                    )
                                                        ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                   , inParentId          := NULL
                                                                                   , inObjectId          := _tmpItem_Detail.AccountId
                                                                                   , inPartionId         := NULL
                                                                                   , inIsReserve         := FALSE
                                                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                                                   , inBusinessId        := vbBusinessId
                                                                                   , inDescId_1          := zc_ContainerLinkObject_Personal()
                                                                                   , inObjectId_1        := _tmpItem_Detail.PersonalId
                                                                                   , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                                   , inObjectId_2        := zc_Enum_InfoMoney_60101() -- ���������� �����
                                                                                   , inDescId_3          := zc_ContainerLinkObject_ServiceDate()
                                                                                   , inObjectId_3        := lpInsertFind_Object_ServiceDate (vbOperDate)
                                                                                    )
                                                        END
                               , ContainerId_VAT = CASE WHEN _tmpItem_Detail.AccountId_VAT > 0
                                                        THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                   , inParentId          := NULL
                                                                                   , inObjectId          := _tmpItem_Detail.AccountId_VAT
                                                                                   , inPartionId         := NULL
                                                                                   , inIsReserve         := FALSE
                                                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                                                   , inBusinessId        := vbBusinessId
                                                                                   , inDescId_1          := zc_ContainerLinkObject_Partner()
                                                                                     -- Partner Official Tax - ���� ���������� ���� �� ���
                                                                                   , inObjectId_1        := zc_Partner_VAT()
                                                                                     --
                                                                                   , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                                     -- ������� ������ + ���
                                                                                   , inObjectId_2        := zc_Enum_InfoMoney_50501()
                                                                                    )
                                                        END;


     -- 4.1. ����������� �������� - ������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������ ���-��
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId                AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbUnitId_From                           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_pr.AccountId                   AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_pr.ContainerId_Goods           AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ���� ��� ...
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� ���� - ������
            , -1 * _tmpItem_Child.Amount              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Child.ParentId

      UNION ALL
       -- �������� - ������ ���-��
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_pr.MovementItemId
            , _tmpItem_pr.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_pr.AccountId                   AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_pr.GoodsId                     AS ObjectId_Analyzer      -- �����
            , _tmpItem_pr.PartionId                   AS PartionId              -- ������
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- ����� �����
            , tmpItem_Child.AccountId                 AS AccountId_Analyzer     -- ���� - ������������� - ������ - ���� �������, �������� �� ����
            , 0                                       AS ContainerId_Analyzer   -- ��������� ������������� - ����
            , 0                                       AS ContainerExtId_Analyzer-- ��������� - ������������� - ������ - ������, �.�. �� ����� �����
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ���� ��� ...
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� �� ���� - ������
            , 1 * _tmpItem_pr.Amount                  AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_pr
            JOIN (SELECT _tmpItem_Child.ParentId, MAX (_tmpItem_Child.AccountId) AS AccountId
                  FROM _tmpItem_Child
                  GROUP BY _tmpItem_Child.ParentId
                 ) AS tmpItem_Child ON tmpItem_Child.ParentId = _tmpItem_pr.MovementItemId
      ;

     -- 4.2.1. ����������� �������� - ������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������ �/�
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId                AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbUnitId_From                           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_pr.AccountId                   AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_pr.ContainerId_Summ            AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� ���� - ������
            , -1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                             THEN Container_Summ.Amount
                        ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                   END                                AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_Goods
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_Summ
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Child.ParentId
           ;

     -- 4.2.2. ����������� �������� - ������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������ �/�
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_pr.MovementItemId
            , _tmpItem_pr.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_pr.AccountId                   AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_pr.GoodsId                     AS ObjectId_Analyzer      -- �����
            , _tmpItem_pr.PartionId                   AS PartionId              -- ������
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId                AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Child.ContainerId_Summ         AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ���� ��� ...
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ������������� �� ���� - ������
            , -1 * _tmpMIContainer_insert.Amount      AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpMIContainer_insert
            JOIN _tmpItem_Child ON _tmpItem_Child.MovementItemId = _tmpMIContainer_insert.MovementItemId
            JOIN _tmpItem_pr    ON _tmpItem_pr.MovementItemId    = _tmpItem_Child.ParentId
       WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_Summ()

      UNION ALL
       -- �������� - � �/� - ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_pr.MovementItemId
            , _tmpItem_pr.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_pr.AccountId                   AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_pr.GoodsId                     AS ObjectId_Analyzer      -- �����
            , _tmpItem_pr.PartionId                   AS PartionId              -- ������
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Detail.AccountId               AS AccountId_Analyzer     -- ���� - ������������� - ������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Detail.ContainerId_Summ        AS ContainerExtId_Analyzer-- ��������� - ������������� - ������
            , _tmpItem_Detail.ReceiptServiceId        AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ��� ������ ���� ��� ...
            , CASE WHEN _tmpItem_Detail.PartnerId > 0 THEN _tmpItem_Detail.PartnerId ELSE _tmpItem_Detail.PersonalId END AS ObjectExtId_Analyzer -- ������������� ���������� - ������������� - Personal
            , _tmpItem_Detail.Amount                  AS Amount                 -- !!!��� ���!!!
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Detail
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId  = _tmpItem_Detail.ParentId
      ;


     -- 4.2.3. ����������� �������� - ���� ���������
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
            , _tmpItem_Detail.MovementItemId
            , _tmpItem_Detail.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_Detail.AccountId               AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , CASE WHEN _tmpItem_Detail.PartnerId > 0 THEN _tmpItem_Detail.PartnerId ELSE _tmpItem_Detail.PersonalId END AS ObjectId_Analyzer -- ���������
            , 0                                       AS PartionId              -- ������
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_pr.AccountId                   AS AccountId_Analyzer     -- ���� - ������������� - �����
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_pr.ContainerId_Summ            AS ContainerExtId_Analyzer-- ��������� - ������������� - �����
            , _tmpItem_Detail.ReceiptServiceId        AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ��� ������ ���� ��� ...
            , _tmpItem_pr.GoodsId                     AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - �����
            , -1 * _tmpItem_Detail.Amount             AS Amount                 -- !!!��� ���!!!
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Detail
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId  = _tmpItem_Detail.ParentId

      UNION ALL
       -- �������� - ���������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Detail.MovementItemId
            , _tmpItem_Detail.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_Detail.AccountId               AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , CASE WHEN _tmpItem_Detail.PartnerId > 0 THEN _tmpItem_Detail.PartnerId ELSE _tmpItem_Detail.PersonalId END AS ObjectId_Analyzer -- ���������
            , 0                                       AS PartionId              -- ������
            , 0                                       AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Detail.AccountId_VAT           AS AccountId_Analyzer     -- ���� - ������������� - ���������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Detail.ContainerId_VAT         AS ContainerExtId_Analyzer-- ��������� - ������������� - ���������
            , _tmpItem_Detail.ReceiptServiceId        AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ��� ������ ���� ��� ...
            , zc_Partner_VAT()                        AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ���������
            , -1 * _tmpItem_Detail.OperSumm_VAT       AS Amount                 -- !!!���!!!
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Detail
       WHERE _tmpItem_Detail.ContainerId_VAT > 0

      UNION ALL
       -- �������� - ���
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Detail.MovementItemId
            , _tmpItem_Detail.ContainerId_VAT
            , 0                                       AS ParentId
            , _tmpItem_Detail.AccountId_VAT           AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , zc_Partner_VAT()                        AS ObjectId_Analyzer      -- Partner Official Tax - ���� ���������� ���� �� ���
            , 0                                       AS PartionId              -- ������
            , 0                                       AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Detail.AccountId               AS AccountId_Analyzer     -- ���� - ������������� - ���������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ������������� - ����
            , _tmpItem_Detail.ContainerId_Summ        AS ContainerExtId_Analyzer-- ��������� - ������������� - ���������
            , _tmpItem_Detail.ReceiptServiceId        AS ObjectIntId_Analyzer   -- ������������� ���������� - ������ ��� ������ ���� ��� ...
            , _tmpItem_Detail.PartnerId               AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� - ���������
            , _tmpItem_Detail.OperSumm_VAT       AS Amount                 -- !!!���!!!
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Detail
       WHERE _tmpItem_Detail.ContainerId_VAT > 0
      ;

     -- 5.0. �������� ���� ������ - !!!������!!!
     UPDATE Object_PartionGoods SET -- ���� ��. ��� ���, � ������ ���� ������ + ������� + �������: �������� + �������� + ��������� = inEKPrice_discount + inCostPrice
                                    EKPrice           = tmpMIContainer.EKPrice / COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = Object_PartionGoods.MovementItemId AND MovementItem.Amount > 0), 1)
                                    -- ���� ��. ��� ���, � ������ ������ ������ �� ��������
                                  , EKPrice_orig      = tmpMIContainer.EKPrice / COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = Object_PartionGoods.MovementItemId AND MovementItem.Amount > 0), 1)
                                    -- ���� ��. ��� ���, � ������ ���� ������ (������ ����� ���)
                                  , EKPrice_discount  = tmpMIContainer.EKPrice / COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = Object_PartionGoods.MovementItemId AND MovementItem.Amount > 0), 1)
                                  , CostPrice         = 0
     FROM (SELECT _tmpMIContainer_insert.MovementItemId
                , SUM (_tmpMIContainer_insert.Amount) AS EKPrice
           FROM _tmpMIContainer_insert
           WHERE _tmpMIContainer_insert.DescId   = zc_MIContainer_Summ()
             AND _tmpMIContainer_insert.isActive = TRUE
           GROUP BY _tmpMIContainer_insert.MovementItemId
          ) AS tmpMIContainer
     WHERE tmpMIContainer.MovementItemId = Object_PartionGoods.MovementItemId
    ;

     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ProductionUnion()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_ProductionUnion (inMovementId:= 676, inSession:= zfCalc_UserAdmin());
