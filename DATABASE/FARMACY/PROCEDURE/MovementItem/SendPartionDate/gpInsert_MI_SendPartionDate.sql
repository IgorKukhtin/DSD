-- Function: gpInsert_MI_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsert_MI_SendPartionDate (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_SendPartionDate(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , --
    IN inOperDate            TDateTime , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;
   DECLARE vbDate0    TDateTime;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMonth_0  TFloat;
   DECLARE vbMonth_1  TFloat;
   DECLARE vbMonth_6  TFloat;

   DECLARE vbId_err            Integer;
   DECLARE vbAmount_master_err TFloat;
   DECLARE vbAmount_child_err  TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;

    -- ���� ���������
    vbOperDate := (SELECT Movement.Operdate FROM Movement WHERE Movement.Id = inMovementId);

    -- �������� �������� �� �����������
    vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbMonth_1 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- ���� + 6 �������, + 1 �����
    vbDate180 := vbOperDate + (vbMonth_6||' MONTH' ) ::INTERVAL;
    vbDate30  := vbOperDate + (vbMonth_1||' MONTH' ) ::INTERVAL;
    vbDate0   := vbOperDate + (vbMonth_0||' MONTH' ) ::INTERVAL;


    -- !!!������� �������� �� ���� �����!!!
    UPDATE MovementItem SET isErased = FALSE WHERE MovementItem.MovementId = inMovementId;


    -- ������� �� �������������
    CREATE TEMP TABLE tmpRemains (ContainerId Integer, MovementId_Income Integer, GoodsId Integer, Amount TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO tmpRemains (ContainerId, MovementId_Income, GoodsId, Amount, ExpirationDate)
          WITH
          -- ���������
          tmpContainer_PartionDate AS (SELECT DISTINCT Container.ParentId AS ContainerId
                                       FROM Container
                                       WHERE Container.DescId        = zc_Container_CountPartionDate()
                                         AND Container.WhereObjectId = inUnitId
                                         AND Container.Amount <> 0
                                      )
          -- ������� �� ������
        , tmpContainer_all AS (SELECT Container.Id                                             AS ContainerId
                                    , Container.ObjectId                                       AS GoodsId
                                    , Container.Amount - SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                               FROM Container
                                    LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.ContainerId = Container.Id
                                                                         AND MIContainer.Operdate >= vbOperDate
                               WHERE Container.DescId        = zc_Container_Count()
                                 AND Container.WhereObjectId = inUnitId
                                 AND Container.Amount <> 0
                               GROUP BY Container.Id
                                      , Container.ObjectId
                               HAVING (Container.Amount - SUM (COALESCE (MIContainer.Amount,0))) <> 0
                              )
          -- ������� - ����� ���� ��������
        , tmpContainer_term AS (SELECT tmp.ContainerId
                                  -- , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS MovementId_Income
                                     , MI_Income.MovementId                                       AS MovementId_Income
                                     , tmp.GoodsId
                                     , tmp.Amount
                                     , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate        --
                                FROM tmpContainer_all AS tmp
                                   LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                 ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
                                                                AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                   LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                   -- ������� �������
                                   LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                   -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                               ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                   -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                   LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                        -- AND 1=0
     
                                   LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                     ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                    AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                -- WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
                               )
          -- ������� - ��� ������, ���� ���� ���� ���� <= vbDate180 + ��������� tmpContainer_PartionDate
        , tmpContainer AS (SELECT tmpContainer_term.ContainerId
                                , tmpContainer_term.MovementId_Income
                                , tmpContainer_term.GoodsId
                                , tmpContainer_term.Amount
                                , tmpContainer_term.ExpirationDate
                           FROM (SELECT DISTINCT tmpContainer_term.GoodsId
                                 FROM tmpContainer_term
                                 -- !!!����������!!!
                                 WHERE tmpContainer_term.ExpirationDate <= vbDate180
                                ) AS tmpContainer
                                LEFT JOIN tmpContainer_term        ON tmpContainer_term.GoodsId = tmpContainer.GoodsId
                                 -- !!!���������!!!
                                LEFT JOIN tmpContainer_PartionDate ON tmpContainer_PartionDate.ContainerId = tmpContainer_term.ContainerId
                           WHERE tmpContainer_PartionDate.ContainerId IS NULL
                          )
          SELECT tmpContainer.ContainerId
               , tmpContainer.MovementId_Income
               , tmpContainer.GoodsId
               , tmpContainer.Amount
               , tmpContainer.ExpirationDate
          FROM tmpContainer
         ;

    -- ������� ������
    CREATE TEMP TABLE tmpMaster (Id Integer, GoodsId Integer, Amount TFloat, AmountRemains TFloat, ChangePercent TFloat, ChangePercentMin TFloat, isErased Boolean) ON COMMIT DROP;
    INSERT INTO tmpMaster (Id, GoodsId, Amount, AmountRemains, ChangePercent, ChangePercentMin, isErased)
       WITH -- ������������
            MI_Master AS (SELECT MovementItem.Id                    AS Id
                               , MovementItem.ObjectId              AS GoodsId
                               , MIFloat_ChangePercent.ValueData    AS ChangePercent
                               , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin
                          FROM MovementItem
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                           ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                           ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercentMin.DescId         = zc_MIFloat_ChangePercentMin()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          )
           -- ���������
           SELECT COALESCE (MI_Master.Id, 0)                 AS Id
                 , tmpRemains.GoodsId                        AS GoodsId
                 , tmpRemains.Amount                         AS Amount
                 , tmpRemains.AmountRemains                  AS AmountRemains
                 , COALESCE (MI_Master.ChangePercent, 0)     AS ChangePercent
                 , COALESCE (MI_Master.ChangePercentMin, 0)  AS ChangePercentMin
                   -- ������ ���� ������
                 , CASE WHEN tmpRemains.GoodsId > 0 THEN FALSE ELSE TRUE END AS isErased
           FROM (SELECT tmpRemains.GoodsId
                        -- ��� �������
                      , SUM (tmpRemains.Amount) AS AmountRemains
                        -- ������ ���������
                      , SUM (CASE WHEN tmpRemains.ExpirationDate <= vbDate180
                                   AND tmpRemains.ExpirationDate > zc_DateStart()
                                -- AND tmpRemains.ExpirationDate > CURRENT_DATE - INTERVAL '3 YEAR'
                                       THEN tmpRemains.Amount
                                  ELSE 0
                             END) AS Amount
                 FROM tmpRemains
                 GROUP BY tmpRemains.GoodsId
                ) AS tmpRemains
                FULL JOIN MI_Master ON MI_Master.GoodsId = tmpRemains.GoodsId
               ;

    --- ��������� MI_Master
    PERFORM lpInsertUpdate_MI_SendPartionDate_Master(ioId            := tmpMaster.Id
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := tmpMaster.GoodsId
                                                   , inAmount        := COALESCE (tmpMaster.Amount,0)        :: TFloat     -- ����������
                                                   , inAmountRemains := COALESCE (tmpMaster.AmountRemains,0) :: TFloat     --
                                                   , inChangePercent    := COALESCE (tmpMaster.ChangePercent,0)         :: TFloat     -- % ������(���� �� 1 ��� �� 6 ���)
                                                   , inChangePercentMin := COALESCE (tmpMaster.ChangePercentMin,0)      :: TFloat     -- % ������(���� ������ ������)
                                                   , inUserId        := vbUserId)
    FROM tmpMaster
    WHERE tmpMaster.isErased = FALSE;


    -- ������� ������ MI_Master, ������� ��� �� �����
    UPDATE MovementItem SET isErased = TRUE
    WHERE MovementItem.Id IN (SELECT tmpMaster.Id FROM tmpMaster WHERE tmpMaster.isErased = TRUE);



    -- ������� �����
    CREATE TEMP TABLE tmpChild (Id Integer, ParentId Integer, GoodsId Integer, Amount TFloat, ContainerId Integer, MovementId_Income Integer, ExpirationDate TDateTime, isErased Boolean) ON COMMIT DROP;
          INSERT INTO tmpChild (Id, ParentId, GoodsId, Amount, ContainerId, MovementId_Income, ExpirationDate, isErased)
       WITH -- ������������ - Master
            MI_Master AS (SELECT MovementItem.Id       AS Id
                               , MovementItem.ObjectId AS GoodsId
                          FROM MovementItem
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
            -- ������������ - Child
          , MI_Child AS (SELECT MovementItem.Id                    AS Id
                              , MovementItem.ObjectId              AS GoodsId
                              , MIFloat_ContainerId.ValueData      AS ContainerId
                              , MIDate_ExpirationDate.ValueData    AS ExpirationDate
                              , MovementItem.Amount                AS Amount
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                          ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                        AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Child()
                           AND MovementItem.isErased   = FALSE
                        )

           -- ���������
           SELECT COALESCE (MI_Child.Id,0)                        AS Id
                , MI_Master.Id                                    AS ParentId
                , tmpRemains.GoodsId                              AS GoodsId
                  -- !!!��������� �� ���-��, ������� ��������������!!!
                , COALESCE (MI_Child.Amount, tmpRemains.Amount)   AS Amount
                , tmpRemains.ContainerId
                , tmpRemains.MovementId_Income
                  -- ��������� ��� ���� ��������, ������� ��������������
                , COALESCE (MI_Child.ExpirationDate, tmpRemains.ExpirationDate) AS ExpirationDate
                  -- ������ ���� ������
                , CASE WHEN tmpRemains.GoodsId > 0 THEN FALSE ELSE TRUE END AS isErased
           FROM tmpRemains
                LEFT JOIN MI_Master ON MI_Master.GoodsId = tmpRemains.GoodsId
                FULL JOIN MI_Child ON MI_Child.GoodsId     = tmpRemains.GoodsId
                                  AND MI_Child.ContainerId = tmpRemains.ContainerId
          ;


    --- ��������� MI_Child
    PERFORM lpInsertUpdate_MI_SendPartionDate_Child(ioId                 := tmpChild.Id
                                                  , inParentId           := tmpChild.ParentId
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmpChild.GoodsId
                                                  , inExpirationDate     := tmpChild.ExpirationDate
                                                  , inAmount             := COALESCE (tmpChild.Amount,0)        :: TFloat
                                                  , inContainerId        := COALESCE (tmpChild.ContainerId,0)   :: TFloat
                                                  , inMovementId_Income  := COALESCE (tmpChild.MovementId_Income,0):: TFloat
                                                  , inUserId             := vbUserId)
    FROM tmpChild
    WHERE tmpChild.isErased = FALSE;

    -- ������� ������ MI_Child, ������� ��� �� �����
    UPDATE MovementItem SET isErased = TRUE
    WHERE MovementItem.Id IN (SELECT tmpChild.Id FROM tmpChild WHERE tmpChild.isErased = TRUE);


    -- �������� - ������� ������ � ����� ������ ���������, ���� ��� - �� �������������� �� ��������� ��� ������ ������ ������ �������
    SELECT tmp.Id, tmp.Amount_master, tmp.Amount_child
           INTO vbId_err, vbAmount_master_err, vbAmount_child_err
    FROM (WITH -- ������������ - Master
               MI_Master AS (SELECT MovementItem.Id 
                                  , COALESCE (MIFloat_AmountRemains.ValueData, 0) AS Amount
                             FROM MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                              ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountRemains.DescId         = zc_MIFloat_AmountRemains()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                            )
               -- ������������ - Child
             , MI_Child AS (SELECT MovementItem.ParentId     AS ParentId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ParentId
                           )
          SELECT COALESCE (MI_Child.ParentId, MI_Master.Id) AS Id
               , COALESCE (MI_Master.Amount, 0)             AS Amount_master
               , COALESCE (MI_Child.Amount, 0)              AS Amount_child
          FROM MI_Master 
               FULL JOIN MI_Child ON MI_Child.ParentId = MI_Master.Id
          WHERE COALESCE (MI_Master.Amount, 0) <>  COALESCE (MI_Child.Amount, 0)
         ) AS tmp;


   IF vbId_err > 0
   THEN
       RAISE EXCEPTION '��� ������ <%> ��������� ������� = <%> �� ������������� �� ������� = <%>.'
                      , lfGet_Object_ValueData ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = vbId_err))
                      , zfConvert_FloatToString (vbAmount_master_err)
                      , zfConvert_FloatToString (vbAmount_child_err)
                      ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.05.19         *
 05.04.19         *
*/