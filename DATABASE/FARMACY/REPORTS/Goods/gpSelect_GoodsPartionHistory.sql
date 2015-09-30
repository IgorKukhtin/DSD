DROP FUNCTION IF EXISTS gpSelect_GoodsPartionHistory (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPartionHistory(
    IN inPartyId          Integer  ,  -- ������
    IN inGoodsId          Integer  ,  -- �����
    IN inUnitId           Integer  ,  -- �������������
    IN inStartDate        TDateTime,  -- ���� ������ �������
    IN inEndDate          TDateTime,  -- ���� ��������� �������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE ( 
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
    AmountIn         TFloat,    --���-�� ������
    AmountOut        TFloat,    --���-�� ������
    AmountInvent     TFloat,    --���-�� ��������
    Saldo            TFloat,    --������� ����� ��������
    MCSValue         TFloat     --���
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRemainsStart TFloat;
   DECLARE vbRemainsEnd TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    SELECT
      SUM(AmountStart)::TFloat,
      SUM(AmountEnd)::TFloat
    INTO
      vbRemainsStart,
      vbRemainsEnd
    FROM(
            SELECT
              Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0) AS AmountStart,
              Container.Amount - COALESCE(SUM(CASE WHEN date_trunc('day',MovementItemContainer.OperDate) > inEndDate THEN MovementItemContainer.Amount ELSE 0 END),0) AS AmountEnd
              
            FROM
                Container
                INNER JOIN ContainerLinkObject AS CLO_Unit
                                               ON CLO_Unit.ContainerId = Container.Id
                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                              AND CLO_Unit.ObjectId = inUnitId
                LEFT OUTER JOIN ContainerLinkObject AS CLO_Party
                                                    ON CLO_Party.containerid = container.id 
                                                   AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()
                LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                     AND date_trunc('day',MovementItemContainer.OperDate) >= inStartDate
            WHERE
                Container.DescId = zc_Container_Count()
                AND
                Container.ObjectId = inGoodsId
                AND
                (
                  CLO_Party.ObjectId = inPartyId
                  or 
                  COALESCE(inPartyId,0) = 0
                )
            GROUP BY
                Container.Amount,
                Container.Id
        ) AS Remains;
    -- ���������
    RETURN QUERY
        WITH RES AS
        (
            SELECT
                Movement.Id                                           AS MovementId,   --�� ����������
                MovementItemContainer.OperDate                        AS OperDate, --���� ���������
                Movement.InvNumber                                    AS InvNumber,  --� ���������
                MovementDesc.Id                                       AS MovementDescId,   --��� ���������
                MovementDesc.ItemName                                 AS MovementDescName,  --�������� ���� ���������
                COALESCE(Object_From.Id,Object_Unit.ID)               AS FromId,   --�� ����
                COALESCE(Object_From.ValueData,Object_Unit.ValueData) AS FromName,  --�� ���� (��������)
                COALESCE(Object_To.Id,Object_Unit.ID)                 AS ToId,   -- ����
                COALESCE(Object_To.ValueData,Object_Unit.ValueData)   AS ToName,  -- ���� (��������)
                NULL::TFloat                                          AS Price,    --���� � ���������
                CASE 
                  WHEN MovementItemContainer.Amount > 0 
                       AND 
                       Movement.DescId <> zc_Movement_Inventory() 
                    THEN MovementItemContainer.Amount 
                ELSE 0.0 END::TFloat                                  AS AmountIn,    --���-�� ������
                CASE 
                  WHEN MovementItemContainer.Amount < 0 
                       AND 
                       Movement.DescId <> zc_Movement_Inventory() 
                    THEN ABS(MovementItemContainer.Amount) 
                ELSE 0.0 
                END::TFloat                                           AS AmountOut,    --���-�� ������
                CASE 
                  WHEN Movement.DescId = zc_Movement_Inventory() 
                    THEN MovementItemContainer.Amount 
                ELSE 0.0 
                END::TFloat                                           AS AmountInvent,    --���-�� ��������
                Object_Price_View.MCSValue                            AS MCSValue,     --���
                ROW_NUMBER() OVER(ORDER BY MovementItemContainer.OperDate, 
                                           CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                           MovementItemContainer.MovementId,MovementItemContainer.MovementItemId) AS OrdNum,
                (SUM(MovementItemContainer.Amount)OVER(ORDER BY MovementItemContainer.OperDate, 
                                                                CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                                                MovementItemContainer.MovementId,MovementItemContainer.MovementItemId))+vbRemainsStart AS Saldo
            FROM
                MovementItemContainer
                INNER JOIN Movement ON MovementItemContainer.MovementId = Movement.Id
                INNER JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
                INNER JOIN Container ON MovementItemContainer.ContainerId = Container.Id
                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                              AND ContainerLinkObject.ObjectId = inUnitId
                LEFT OUTER JOIN ContainerLinkObject AS CLO_Party
                                                    ON CLO_Party.containerid = container.id 
                                                   AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()                              
                
                LEFT OUTER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT OUTER JOIN Object AS Object_From
                                       ON MovementLinkObject_From.ObjectId = Object_From.Id

                LEFT OUTER JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT OUTER JOIN Object AS Object_To
                                       ON MovementLinkObject_To.ObjectId = Object_To.Id
                
                LEFT OUTER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                LEFT OUTER JOIN Object AS Object_Unit
                                       ON MovementLinkObject_Unit.ObjectId = Object_Unit.Id
                
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.UnitId = inUnitId
                                                 AND Object_Price_View.GoodsId = inGoodsId 
            WHERE
                date_trunc('day', MovementItemContainer.OperDate) BETWEEN inStartDate AND inEndDate
                AND
                MovementItemContainer.DescId = zc_MIContainer_Count()
                AND
                Container.ObjectId = inGoodsId
                AND
                (
                  CLO_Party.ObjectID = inPartyId 
                  OR
                  inPartyId = 0
                )
            UNION ALL
            SELECT
                NULL                       AS MovementId,   --�� ����������
                inStartDate                AS OperDate, --���� ���������
                NULL                       AS InvNumber,  --� ���������
                NULL                       AS MovementDescId,   --��� ���������
                '������� �� ������'        AS MovementDescName,  --�������� ���� ���������
                NULL                       AS FromId,   --�� ����
                NULL                       AS FromName,  --�� ���� (��������)
                NULL                       AS ToId,   -- ����
                NULL                       AS ToName,  -- ���� (��������)
                NULL::TFloat               AS Price,    --���� � ���������
                NULL                       AS AmountIn,    --���-�� ������
                NULL                       AS AmountOut,    --���-�� ������
                NULL                       AS AmountInvent,    --���-�� ��������
                Object_Price_View.MCSValue AS MCSValue,     --���
                0                          AS OrdNum,
                vbRemainsStart             AS Saldo
            FROM
                Object AS Object_Goods
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.UnitId = inUnitId
                                                 AND Object_Price_View.GoodsId = Object_Goods.Id
            WHERE
                Object_Goods.Id = inGoodsId
            UNION ALL
            SELECT
                NULL                       AS MovementId,   --�� ����������
                inEndDate                  AS OperDate, --���� ���������
                NULL                       AS InvNumber,  --� ���������
                NULL                       AS MovementDescId,   --��� ���������
                '������� �� �����'         AS MovementDescName,  --�������� ���� ���������
                NULL                       AS FromId,   --�� ����
                NULL                       AS FromName,  --�� ���� (��������)
                NULL                       AS ToId,   -- ����
                NULL                       AS ToName,  -- ���� (��������)
                NULL::TFloat               AS Price,    --���� � ���������
                NULL                       AS AmountIn,    --���-�� ������
                NULL                       AS AmountOut,    --���-�� ������
                NULL                       AS AmountInvent,    --���-�� ��������
                Object_Price_View.MCSValue AS MCSValue,     --���
                999999999                  AS OrdNum,
                vbRemainsEnd               AS Saldo 
            FROM
                Object AS Object_Goods
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.UnitId = inUnitId
                                                 AND Object_Price_View.GoodsId = Object_Goods.Id
            WHERE
                Object_Goods.Id = inGoodsId
        )
        SELECT
            Res.MovementId::Integer,   --�� ����������
            Res.OperDate::TDateTime, --���� ���������
            Res.InvNumber::TVarChar,  --� ���������
            Res.MovementDescId::Integer,   --��� ���������
            Res.MovementDescName::TVarChar,  --�������� ���� ���������
            Res.FromId::Integer,   --�� ����
            Res.FromName::TVarChar,  --�� ���� (��������)
            Res.ToId::Integer,   -- ����
            Res.ToName::TVarChar,  -- ���� (��������)
            Res.Price::TFloat,    --���� � ���������
            NULLIF(Res.AmountIn,0)::TFloat,    --���-�� ������
            NULLIF(Res.AmountOut,0)::TFloat,    --���-�� ������
            NULLIF(Res.AmountInvent,0)::TFloat,    --���-�� ��������
            Res.Saldo::TFloat, --������� ����� ��������
            Res.MCSValue::TFloat     --���
        FROM Res 
        ORDER BY 
            Res.OrdNum;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsPartionHistory (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 26.08.15                                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_GoodsPartionHistory (inPartyId := 0,inGoodsId := 0,inUnitId := 0,inStartDate := '20150801',inEndDate := '20150830', inSession := '3')