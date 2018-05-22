-- Function: gpSelect_GoodsPartionHistory()

DROP FUNCTION IF EXISTS gpSelect_GoodsPartionHistory (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPartionHistory(
    IN inPartyId          Integer  ,  -- ������
    IN inGoodsId          Integer  ,  -- �����
    IN inUnitId           Integer  ,  -- �������������
    IN inStartDate        TDateTime,  -- ���� ������ �������
    IN inEndDate          TDateTime,  -- ���� ��������� �������
    IN inIsPartion        Boolean  ,  -- ������� ������ ��/���
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE ( 
    ContainerId      Integer,   --�� 
    MovementId       Integer,   --�� ����������
    OperDate         TDateTime, --���� ���������
    InvNumber        TVarChar,  --� ���������
    MovementDescId   Integer,   --��� ���������
    MovementDescName TVarChar,  --�������� ���� ���������
    FromId           Integer,   --�� ����
    FromName         TVarChar,  --�� ���� (��������)
    ToId             Integer,   -- ����
    ToName           TVarChar,  -- ���� (��������)
    Price            TFloat,    --���� � ���������
    Summa            TFloat,    --����� � ���������
    AmountIn         TFloat,    --���-�� ������
    AmountOut        TFloat,    --���-�� ������
    AmountInvent     TFloat,    --���-�� ��������
    Saldo            TFloat,    --������� ����� ��������
    MCSValue         TFloat,     --���
    CheckMember      TVarChar,  --��������
    Bayer            TVarChar,  --����������
    PartyId          Integer,
    PartionInvNumber TVarChar,  --� ��������� ������
    PartionOperDate  TDateTime, --���� ��������� ������
    PartionDescName  TVarChar,  --��� ��������� ������
    PartionPrice     TFloat,    --���� ������
    InsertName       TVarChar,  --������������(����.) 
    InsertDate       TDateTime  --����(����.)
  )
AS
$BODY$
   DECLARE vbUserId Integer;
--   DECLARE vbRemainsStart TFloat;
--   DECLARE vbRemainsEnd TFloat;
   DECLARE vbObjectId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- ������������ <�������� ����>
    IF vbUserId = 3 THEN vbObjectId:= 0;
    ELSE vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    END IF;


    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    INSERT INTO _tmpGoods (GoodsId)
       -- !!!�������� �����������, ����� ��� ����!!!!
       SELECT ObjectLink_Child_ALL.ChildObjectId AS GoodsId
       FROM ObjectLink AS ObjectLink_Child
                         INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                  AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Main_ALL ON ObjectLink_Main_ALL.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                     AND ObjectLink_Main_ALL.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Child_ALL ON ObjectLink_Child_ALL.ObjectId = ObjectLink_Main_ALL.ObjectId
                                                                      AND ObjectLink_Child_ALL.DescId   = zc_ObjectLink_LinkGoods_Goods()
                         INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                               ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                              AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                              AND (ObjectLink_Goods_Object.ChildObjectId = vbObjectId OR vbObjectId = 0)
                         INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                           AND Object_Retail.DescId = zc_Object_Retail()
       WHERE ObjectLink_Child.ChildObjectId = inGoodsId
         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods();


    CREATE TEMP TABLE _tmpRem (ContainerId Integer, RemainsStart TFloat, RemainsEnd TFloat) ON COMMIT DROP;

    INSERT INTO _tmpRem (ContainerId, RemainsStart, RemainsEnd)
         WITH
         tmpRemains_All AS (SELECT Container.Id       AS ContainerId
                                 , Container.ObjectId AS GoodsId
                                 , Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0) AS AmountStart
                                 , Container.Amount - COALESCE(SUM(CASE WHEN DATE_TRUNC ('DAY', MovementItemContainer.OperDate) > inEndDate THEN MovementItemContainer.Amount ELSE 0 END),0) AS AmountEnd
                            FROM _tmpGoods AS tmp
                                INNER JOIN Container ON Container.DescId   = zc_Container_Count()
                                                    AND Container.ObjectId = tmp.GoodsId
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId = inUnitId
                                LEFT OUTER JOIN ContainerLinkObject AS CLO_Party
                                                                    ON CLO_Party.containerid = container.id 
                                                                   AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()
                                LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                     -- AND DATE_TRUNC ('DAY', MovementItemContainer.OperDate) >= inStartDate
                                                                     AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                            WHERE (CLO_Party.ObjectId = inPartyId
                                OR COALESCE (inPartyId, 0) = 0
                                   )
                            GROUP BY Container.Amount
                                   , Container.Id
                                   , Container.ObjectId
                            )

       , tmpRemains AS (SELECT CASE WHEN inIsPartion = TRUE THEN Remains.ContainerId ELSE 0 END AS ContainerId
                             , SUM (Remains.AmountStart) AS RemainsStart
                             , SUM (Remains.AmountEnd)   AS RemainsEnd
                        FROM tmpRemains_All AS Remains
                        GROUP BY CASE WHEN inIsPartion = TRUE THEN Remains.ContainerId ELSE 0 END
                        )

       , tmpRemains_ord AS (SELECT *
                                 , ROW_NUMBER() OVER(ORDER BY ABS (tmp.RemainsStart) DESC, tmp.ContainerId DESC) AS num 
                            FROM tmpRemains AS tmp
                            )
    --
    SELECT tmp.ContainerId
         , tmp.RemainsStart
         , tmp.RemainsEnd
    FROM tmpRemains_ord AS tmp
    WHERE tmp.RemainsStart <> 0 OR tmp.RemainsEnd <> 0 OR tmp.num = 1
    ;

    -- ���������
    RETURN QUERY
        WITH 
        
        tmpPrice (SELECT ObjectLink_Price_Unit.ChildObjectId    AS UnitId
                     , Price_Goods.ChildObjectId                AS GoodsId     
                     , MCS_Value.ValueData                      AS MCSValue
                  FROM ObjectLink AS ObjectLink_Price_Unit
                     LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                     INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Price_Goods.ChildObjectId

                     LEFT JOIN ObjectFloat AS MCS_Value
                                           ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                          AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()                                          

                 WHERE ObjectLink_Price_Unit.ChildObjectId = inUnitId
                   AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()   
                  )

      , tmpContainer_Rem AS (SELECT Container.*
                             FROM Container
                             WHERE Container.Id IN (SELECT DISTINCT _tmpRem.ContainerId FROM _tmpRem)
                             )
      , tmpCLO_Party_Rem AS (SELECT CLO_Party.*
                         FROM ContainerLinkObject AS CLO_Party
                         WHERE CLO_Party.ContainerId IN (SELECT DISTINCT tmpContainer_Rem.Id FROM tmpContainer_Rem)
                           AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem() 
                         )
      , tmpRem_All AS (SELECT _tmpRem.ContainerId
                            , tmpPrice.MCSValue
                            , CLO_Party.ObjectID   AS PartyId
                            , _tmpRem.RemainsStart
                            , _tmpRem.RemainsEnd
                       FROM _tmpRem
                           LEFT JOIN tmpContainer_Rem ON tmpContainer_Rem.Id = _tmpRem.ContainerId
                           LEFT OUTER JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (tmpContainer_Rem.ObjectId, inGoodsId)
                           LEFT OUTER JOIN tmpCLO_Party_Rem AS CLO_Party ON CLO_Party.containerid = tmpContainer_Rem.Id 
                       )

      ----
      , tmpContainer AS (SELECT Container.Id
                         FROM _tmpGoods AS tmp
                               INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                                   AND Container.DescId = zc_Container_Count()
                               INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                             AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                             AND ContainerLinkObject.ObjectId = inUnitId
                        )

      , tmpCLO_Party AS (SELECT CLO_Party.*
                         FROM ContainerLinkObject AS CLO_Party
                         WHERE CLO_Party.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                           AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem() 
                         )

      , tmpMIContainer AS (SELECT tmpContainer.Id                AS ContainerId
                                , MovementItemContainer.OperDate
                                , MovementItemContainer.MovementId
                                , MovementItemContainer.MovementItemId
                                , MovementItemContainer.Amount
                           FROM tmpContainer
                                INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = tmpContainer.Id
                                                                AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
                                                                AND MovementItemContainer.OperDate <  DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                           )

      , tmpMovement AS (SELECT Movement.*
                        FROM Movement
                        WHERE Movement.Id IN (SELECT DISTINCT tmpMIContainer.MovementId FROM tmpMIContainer)
                        )

      , tmpMLO AS (SELECT MovementLinkObject.*
                   FROM MovementLinkObject
                   WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                     AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                     , zc_MovementLinkObject_To()
                                                     , zc_MovementLinkObject_Unit()
                                                     , zc_MovementLinkObject_CheckMember()
                                                     , zc_MovementLinkObject_Insert() )
                   )

      , tmpObject AS (SELECT Object.*
                      FROM Object
                      WHERE Object.Id IN (SELECT DISTINCT tmpMLO.ObjectId FROM tmpMLO)
                       )

      , tmpMovementDate AS (SELECT MovementDate_Insert.*
                            FROM MovementDate AS MovementDate_Insert
                            WHERE MovementDate_Insert.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                           )

      , tmpMovementString AS (SELECT MovementString_Bayer.*
                              FROM  MovementString AS MovementString_Bayer
                              WHERE MovementString_Bayer.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                              )

      , tmpMIFloat AS (SELECT MIFloat_Price.*
                       FROM MovementItemFloat AS MIFloat_Price 
                       WHERE MIFloat_Price.MovementItemId IN (SELECT DISTINCT tmpMIContainer.MovementItemId FROM tmpMIContainer)
                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       )

      , tmpData AS (SELECT MovementItemContainer.ContainerId                     AS ContainerId
                         , Movement.Id                                           AS MovementId        --�� ����������
                         , MovementItemContainer.OperDate                        AS OperDate          --���� ���������
                         , Movement.InvNumber                                    AS InvNumber         --� ���������
                         , MovementDesc.Id                                       AS MovementDescId    --��� ���������
                         , MovementDesc.ItemName                                 AS MovementDescName  --�������� ���� ���������
                         , COALESCE(Object_From.Id,Object_Unit.ID)               AS FromId            --�� ����
                         , COALESCE(Object_From.ValueData,Object_Unit.ValueData) AS FromName          --�� ���� (��������)
                         , COALESCE(Object_To.Id,Object_Unit.ID)                 AS ToId              -- ����
                         , COALESCE(Object_To.ValueData,Object_Unit.ValueData)   AS ToName            -- ���� (��������)
                         , MIFloat_Price.ValueData                               AS Price             --���� � ���������
                         , ABS(MIFloat_Price.ValueData * MovementItemContainer.Amount) AS Summa       --����� � ���������
                         , CASE WHEN MovementItemContainer.Amount > 0 
                                     AND 
                                     Movement.DescId <> zc_Movement_Inventory() 
                                  THEN MovementItemContainer.Amount 
                              ELSE 0.0 END  ::TFloat                             AS AmountIn    --���-�� ������
                         , CASE WHEN MovementItemContainer.Amount < 0 
                                  AND 
                                  Movement.DescId <> zc_Movement_Inventory() 
                                THEN ABS(MovementItemContainer.Amount) 
                           ELSE 0.0 
                           END::TFloat                                           AS AmountOut    --���-�� ������
                         , CASE WHEN Movement.DescId = zc_Movement_Inventory()
                               THEN MovementItemContainer.Amount 
                           ELSE 0.0 
                           END::TFloat                                           AS AmountInvent --���-�� ��������
                         , tmpPrice.MCSValue                                     AS MCSValue     --���
                         , Object_CheckMember.ValueData                          AS CheckMember  --��������
                         , MovementString_Bayer.ValueData                        AS Bayer        --����������
                         , CLO_Party.ObjectID                                    AS PartyId      --# ������
                        
                         , ROW_NUMBER() OVER(ORDER BY MovementItemContainer.OperDate, 
                                                      CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                                      CASE WHEN MovementItemContainer.Amount > 0 THEN 0 ELSE 0 END,
                                                      MovementItemContainer.MovementId,MovementItemContainer.MovementItemId,CLO_Party.ObjectID) AS OrdNum
                                                   
                         , (SUM(MovementItemContainer.Amount)OVER(ORDER BY MovementItemContainer.OperDate, 
                                                                        CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                                                        CASE WHEN MovementItemContainer.Amount > 0 THEN 0 ELSE 0 END,
                                                                        MovementItemContainer.MovementId,MovementItemContainer.MovementItemId,CLO_Party.ObjectID)) + _tmpRem.RemainsStart AS Saldo
                         , Object_Insert.ValueData              AS InsertName
                         , MovementDate_Insert.ValueData        AS InsertDate
                       
                    FROM tmpMIContainer AS MovementItemContainer
                         LEFT JOIN _tmpRem ON _tmpRem.ContainerId = MovementItemContainer.ContainerId OR _tmpRem.ContainerId = 0
                         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = inGoodsId
                         INNER JOIN tmpMovement AS Movement ON Movement.Id = MovementItemContainer.MovementId
                         INNER JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
     
                         INNER OUTER JOIN tmpCLO_Party AS CLO_Party
                                                       ON CLO_Party.ContainerId = MovementItemContainer.ContainerId
                                                      AND (CLO_Party.ObjectID = inPartyId OR inPartyId = 0)
                                                       -- AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()                              
                     
                         LEFT OUTER JOIN tmpMLO AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT OUTER JOIN tmpObject AS Object_From ON MovementLinkObject_From.ObjectId = Object_From.Id
         
                         LEFT OUTER JOIN tmpMLO AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         LEFT OUTER JOIN tmpObject AS Object_To ON MovementLinkObject_To.ObjectId = Object_To.Id
                         
                         LEFT OUTER JOIN tmpMLO AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         LEFT OUTER JOIN tmpObject AS Object_Unit ON MovementLinkObject_Unit.ObjectId = Object_Unit.Id
         
                         LEFT JOIN tmpMLO AS MovementLinkObject_CheckMember
                                          ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                         AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                         LEFT JOIN tmpObject AS Object_CheckMember ON Object_CheckMember.Id = MovementLinkObject_CheckMember.ObjectId
         
                         LEFT JOIN tmpMovementString AS MovementString_Bayer
                                                     ON MovementString_Bayer.MovementId = Movement.Id
         
                         -- ������������(����.) + ����(����.)  
                         LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                                   ON MovementDate_Insert.MovementId = Movement.Id
         
                         LEFT JOIN tmpMLO AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                         LEFT JOIN tmpObject AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  
         
                         LEFT OUTER JOIN tmpMIFloat AS MIFloat_Price 
                                                    ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                    )
      , RES AS (SELECT tmpData.ContainerId
                     , tmpData.MovementId
                     , tmpData.OperDate
                     , tmpData.InvNumber
                     , tmpData.MovementDescId
                     , tmpData.MovementDescName
                     , tmpData.FromId
                     , tmpData.FromName
                     , tmpData.ToId
                     , tmpData.ToName
                     , tmpData.Price
                     , tmpData.Summa
                     , tmpData.AmountIn
                     , tmpData.AmountOut
                     , tmpData.AmountInvent
                     , tmpData.MCSValue
                     , tmpData.CheckMember
                     , tmpData.Bayer
                     , tmpData.PartyId
                     , tmpData.OrdNum
                     , tmpData.Saldo
                     , tmpData.InsertName
                     , tmpData.InsertDate
                FROM tmpData
                UNION ALL
                SELECT
                    tmpRem_All.ContainerId     AS ContainerId,
                    NULL                       AS MovementId,    --�� ����������
                    inStartDate                AS OperDate,      --���� ���������
                    NULL                       AS InvNumber,     --� ���������
                    NULL                       AS MovementDescId,    --��� ���������
                    '������� �� ������'        AS MovementDescName,  --�������� ���� ���������
                    NULL                       AS FromId,        --�� ����
                    NULL                       AS FromName,      --�� ���� (��������)
                    NULL                       AS ToId,          -- ����
                    NULL                       AS ToName,        -- ���� (��������)
                    NULL::TFloat               AS Price,         --���� � ���������
                    NULL::TFloat               AS Summa,         --���� � ���������
                    NULL                       AS AmountIn,      --���-�� ������
                    NULL                       AS AmountOut,     --���-�� ������
                    NULL                       AS AmountInvent,  --���-�� ��������
                    tmpRem_All.MCSValue        AS MCSValue,      --���
                    NULL                       AS CheckMember,   --��������
                    NULL                       AS Bayer,         --����������
                    tmpRem_All.PartyId         AS PartyId,       --# ������
                    0                          AS OrdNum,
                    tmpRem_All.RemainsStart    AS Saldo,
                    NULL                       AS InsertName,
                    NULL                       AS InsertDate
                FROM tmpRem_All
               UNION ALL
                SELECT
                    tmpRem_All.ContainerId     AS ContainerId,
                    NULL                       AS MovementId,   --�� ����������
                    inEndDate                  AS OperDate,     --���� ���������
                    NULL                       AS InvNumber,    --� ���������
                    NULL                       AS MovementDescId,    --��� ���������
                    '������� �� �����'         AS MovementDescName,  --�������� ���� ���������
                    NULL                       AS FromId,       --�� ����
                    NULL                       AS FromName,     --�� ���� (��������)
                    NULL                       AS ToId,         -- ����
                    NULL                       AS ToName,       -- ���� (��������)
                    NULL::TFloat               AS Price,        --���� � ���������
                    NULL::TFloat               AS Summa,        --���� � ���������
                    NULL                       AS AmountIn,     --���-�� ������
                    NULL                       AS AmountOut,    --���-�� ������
                    NULL                       AS AmountInvent, --���-�� ��������
                    tmpRem_All.MCSValue        AS MCSValue,     --���
                    NULL                       AS CheckMember,  --��������
                    NULL                       AS Bayer,        --����������
                    tmpRem_All.PartyId         AS PartyId,      --# ������
                    999999999                  AS OrdNum,
                    tmpRem_All.RemainsEnd      AS Saldo,
                    NULL                       AS InsertName,
                    NULL                       AS InsertDate 
                FROM tmpRem_All
                )
      ---
      , tmpObject_Party AS (SELECT Object_PartionMovementItem.ObjectCode :: Integer AS ObjectCode
                            FROM Object AS Object_PartionMovementItem
                            WHERE Object_PartionMovementItem.Id IN (SELECT DISTINCT Res.PartyId FROM Res)
                              AND inIsPartion = True
                           )
      , tmpMI_Party AS (SELECT MovementItem.*
                        FROM MovementItem
                        WHERE MovementItem.Id IN (SELECT DISTINCT tmpObject_Party.ObjectCode FROM tmpObject_Party)
                        )
      , tmpMovement_Party AS (SELECT 
                              FROM Movement
                              WHERE Movement.Id IN (SELECT DISTINCT tmpMI_Party.MovementId FROM tmpMI_Party)
                              )
      , tmpMIFloat_Party AS (SELECT MIFloat_Price.*
                             FROM MovementItemFloat AS MIFloat_Price
                             WHERE MIFloat_Price.MovementItemId IN  (SELECT DISTINCT tmpMI_Party.Id FROM tmpMI_Party)
                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             )
        -- ���������
        SELECT
            Res.ContainerId,
            Res.MovementId::Integer,            --�� ����������
            Res.OperDate::TDateTime,            --���� ���������
            Res.InvNumber::TVarChar,            --� ���������
            Res.MovementDescId::Integer,        --��� ���������
            Res.MovementDescName::TVarChar,     --�������� ���� ���������
            Res.FromId::Integer,                --�� ����
            Res.FromName::TVarChar,             --�� ���� (��������)
            Res.ToId::Integer,                  -- ����
            Res.ToName::TVarChar,               -- ���� (��������)
            Res.Price::TFloat,                  --���� � ���������
            Res.Summa::TFloat,                  --����� � ���������
            NULLIF(Res.AmountIn,0)::TFloat,     --���-�� ������
            NULLIF(Res.AmountOut,0)::TFloat,    --���-�� ������
            NULLIF(Res.AmountInvent,0)::TFloat, --���-�� ��������
            Res.Saldo::TFloat,                  --������� ����� ��������
            Res.MCSValue::TFloat,               --���
            Res.CheckMember::TVarChar,          --��������
            Res.Bayer::TVarChar,                --����������
            Res.PartyId ,                       --# ������
            COALESCE(Movement_Party.InvNumber, NULL) ::TVarChar  AS PartionInvNumber,  -- � ���.������
            COALESCE(Movement_Party.OperDate, NULL)  ::TDateTime AS PartionOperDate,   -- ���� ���.������
            COALESCE(MovementDesc.ItemName, NULL)    ::TVarChar  AS PartionDescName,
            COALESCE(MIFloat_Price.ValueData, NULL)  ::TFloat    AS PartionPrice,
            Res.InsertName  ::TVarChar,         --������������(����.) 
            Res.InsertDate  ::TDateTime         --����(����.)
        FROM Res
           LEFT JOIN tmpObject_Party AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = Res.PartyId

           LEFT JOIN tmpMI_Party ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

           LEFT JOIN tmpMovement_Party AS Movement_Party ON Movement_Party.Id = MovementItem.MovementId 

           LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Party.DescId

           LEFT OUTER JOIN tmpMIFloat_Party AS MIFloat_Price ON MIFloat_Price.MovementItemId = MovementItem.Id
          
        ORDER BY Res.OrdNum;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 21.05.18         *
 07.01.17         *
 01.07.16         * add inIsPartion
 26.08.15                                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_GoodsPartionHistory (inPartyId := 0,inGoodsId := 0,inUnitId := 0,inStartDate := '20150801',inEndDate := '20150830', inIsPartion = true, inSession := '3')
--select * from gpSelect_GoodsPartionHistory(inPartyId := 0 , inGoodsId := 18253 , inUnitId := 183292 , inStartDate := ('01.10.2015')::TDateTime , inEndDate := ('26.11.2016')::TDateTime , inIsPartion := 'False' ,  inSession := '3');