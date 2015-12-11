-- Function:  gpReport_Upload_BaDM()

DROP FUNCTION IF EXISTS gpReport_Upload_BaDM (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_BaDM(
    IN inDate         TDateTime,  -- ������������ ����
    IN inObjectId         Integer,    -- ���������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
  OperDate      TDateTime, --���� - ���� ������������� ��� � ������� ��������� ������������� �������� 
  JuridicalCode TVarChar,  --���������� - ��� ��.���� � ������� ������� ����, � �������� ��������� ������, ��������������� ���� ��� ���������� �������
  UnitCode      TVarChar,  --��� ������ - ��� ������ � ������� ������� �������� �������
  UnitName      TVarChar,  --������������ ������ - ������������ ������ � ������� ������� �������� �������
  GoodsCode     TVarChar,  --��� ������ - ��� ������ � ������� ������� �������� ������. ����������� ����� ����� �������� ������ � ���� �������������� �� ������� �������� ����
  GoodsName     TVarChar,  --������������ ������ - ������������ ������ � ������� ������� �������� �������
  OperCode      Integer,   --��� �������� - ��� �������� �������� � ������������ � �������� ����� ��������, ������� ��������� �� ����� ���� ��������.
                           --��� ���� ��������  ������������ ��������           ������� ���������
                           --1                  ����� ������ (�� ����� ���)	    ��
                           --10	                ������� ������                  ��
  Amount        TFloat,    --�������� - �������� �������� ��� ���������� ��������. ��������, ��� ������� ��� ���-�� ��������� �������� - 3 ��.
  Segment1      TFloat,    --�������� 1-5 - ���� ��� �������� ���� �������������� ����������. ���� ��� �� ������������, �� �������� ������ ���� ����� 0.
  Segment2      TFloat,
  Segment3      TFloat,
  Segment4      TFloat,
  Segment5      TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectIdRetail Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbObjectIdRetail := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    --������� ������� �����������
    CREATE TEMP TABLE _Cross(
        JuridicalCode TVarChar,
        UnitId        Integer,
        UnitCode      TVarChar,
        GoodsId       Integer,
        GoodsCode     TVarChar,
        GoodsName     TVarChar,
        OperCode      Integer) ON COMMIT DROP;
    --������ �����������
    WITH Oper AS (
        Select 1::Integer as OperCode
        UNION
        SELECT 10::Integer AS OperCode
    ),
    Juridical AS(
        Select 
            Object_ImportExportLink.StringKey  AS JuridicalCode
           ,ObjectLink_Unit_Juridical.ObjectId AS UnitId
           ,Object_ImportExportLink_Unit.StringKey AS UnitCode
        FROM Object_ImportExportLink_View AS Object_ImportExportLink
            Inner Join Object ON Object_ImportExportLink.MainId = Object.ID
                             AND Object.DescId = zc_Object_Juridical()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                       ON ObjectLink_Unit_Juridical.ChildObjectId = Object.ID
                                      AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT OUTER JOIN Object_ImportExportLink_View AS Object_ImportExportLink_Unit
                                                         ON Object_ImportExportLink_Unit.MainId = ObjectLink_Unit_Juridical.ObjectId
                                                        AND Object_ImportExportLink_Unit.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
                                                        AND Object_ImportExportLink_Unit.ValueId = inObjectId
        WHERE
            Object_ImportExportLink.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
            AND
            Object_ImportExportLink.ValueId = inObjectId
            AND
            COALESCE(Object_ImportExportLink_Unit.StringKey,'') <> ''
    ),
    Goods AS(
        SELECT DISTINCT
            LinkGoods_Main_Retail.GoodsId AS GoodsId
           ,Object_Goods_View.GoodsCode   AS GoodsCode
           ,Object_Goods_View.GoodsName   AS GoodsName
        FROM Object_Goods_View
            LEFT JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                            ON LinkGoods_Partner_Main.GoodsId = Object_Goods_View.id -- ����� ������ ���������� � �����
            LEFT JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- ����� ������ ���� � ������� �������
                                            ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
                                           AND LinkGoods_Main_Retail.ObjectId = vbObjectIdRetail
        WHERE
            Object_Goods_View.ObjectId = inObjectId
            AND
            Object_Goods_View.IsUpload = TRUE
    )
    INSERT INTO _Cross (JuridicalCode, UnitId, UnitCode, GoodsId, GoodsCode, GoodsName, OperCode)
    SELECT
        Juridical.JuridicalCode
      , Juridical.UnitId
      , Juridical.UnitCode
      , Goods.GoodsId
      , Goods.GoodsCode
      , Goods.GoodsName
      , Oper.OperCode
    FROM 
      Oper
      Cross join Juridical
      Cross Join Goods
    ;
    
        
    -- ���������
    RETURN QUERY
        WITH SaleAndRemains AS(
            SELECT
                10                                       AS OperCode
               ,MovementLinkObject_Unit.ObjectId         AS UnitId
               ,MI_Check.ObjectId                        AS GoodsId
               ,SUM(-MIContainer.Amount)::TFloat         AS Amount
            FROM
                Movement AS Movement_Check
                INNER JOIN MovementItem AS MI_Check
                                        ON MI_Check.MovementId = Movement_Check.Id
                                       AND MI_Check.DescId = zc_MI_Master()
                                       AND MI_Check.isErased = FALSE
                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                INNER JOIN MovementItemContainer AS MIContainer
                                                 ON MIContainer.MovementItemId = MI_Check.Id
                                                AND MIContainer.DescId = zc_MIContainer_Count() 
                INNER JOIN containerlinkobject AS ContainerLinkObject_MovementItem 
                                               ON ContainerLinkObject_MovementItem.containerid = MIContainer.ContainerId
                                              AND ContainerLinkObject_MovementItem.descid = zc_ContainerLinkObject_PartionMovementItem()
                INNER JOIN OBJECT AS Object_PartionMovementItem 
                                  ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                INNER JOIN MovementItem AS MI_Income
                                        ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                INNER JOIN MovementLinkObject AS MovementLinkObject_Income_From
                                              ON MovementLinkObject_Income_From.MovementId = MI_Income.MovementId
                                             AND MovementLinkObject_Income_From.DescId = zc_MovementLinkObject_From()
                                             AND MovementLinkObject_Income_From.ObjectId = inObjectId
                                             
            WHERE
                Movement_Check.DescId in (zc_Movement_Check(),zc_Movement_Sale())
                AND
                date_trunc('day', Movement_Check.OperDate) = inDate
                AND
                Movement_Check.StatusId = zc_Enum_Status_Complete()
            GROUP BY
                MovementLinkObject_Unit.ObjectId 
               ,MI_Check.ObjectId
            HAVING
               SUM(MIContainer.Amount) <> 0
            UNION ALL   
            SELECT
                1::Integer             AS OperCode
               ,T0.UnitId
               ,T0.GoodsId
               ,SUM(T0.Amount)::TFloat AS Amount
            FROM (
                    SELECT
                        Container.Id
                       ,Container.WhereObjectId AS UnitId
                       ,Container.ObjectId     AS GoodsId
                       ,Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0.0)::TFloat as Amount
                    FROM
                        Container
                        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                             AND date_trunc('day', MovementItemContainer.OperDate) > inDate
                        INNER JOIN containerlinkobject AS ContainerLinkObject_MovementItem 
                                                       ON ContainerLinkObject_MovementItem.containerid = Container.Id
                                                      AND ContainerLinkObject_MovementItem.descid = zc_ContainerLinkObject_PartionMovementItem()
                        INNER JOIN OBJECT AS Object_PartionMovementItem 
                                          ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                        INNER JOIN MovementItem AS MI_Income
                                                ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Income_From
                                                      ON MovementLinkObject_Income_From.MovementId = MI_Income.MovementId
                                                     AND MovementLinkObject_Income_From.DescId = zc_MovementLinkObject_From()
                                                     AND MovementLinkObject_Income_From.ObjectId = inObjectId
                    WHERE
                        Container.DescId = zc_Container_Count()
                    GROUP BY
                        Container.Id
                       ,Container.WhereObjectId
                       ,Container.ObjectId
                    HAVING
                        (Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0.0)::TFloat) <> 0
                ) AS T0
            GROUP BY
                T0.UnitId
               ,T0.GoodsId
            HAVING
                COALESCE(SUM(T0.Amount),0) > 0
        )
        SELECT
            inDate                                    AS OperDate
           ,_Cross.JuridicalCode
           ,_Cross.UnitCode                           AS UnitCode
           ,Object_Unit.ValueData                     AS UnitName
           ,_Cross.GoodsCode                          AS GoodsCode
           ,_Cross.GoodsName                          AS GoodsName
           ,_Cross.OperCode
           ,SUM(COALESCE(SaleAndRemains.Amount,0))::TFloat AS Amount
           ,0::TFloat                                 AS Segment1
           ,0::TFloat                                 AS Segment2
           ,0::TFloat                                 AS Segment3
           ,0::TFloat                                 AS Segment4
           ,0::TFloat                                 AS Segment5
           
        FROM
            _Cross
            LEFT OUTER JOIN SaleAndRemains ON SaleAndRemains.UnitId = _Cross.UnitId
                                          AND SaleAndRemains.GoodsId = _Cross.GoodsId
                                          AND SaleAndRemains.OperCode = _Cross.OperCode
            LEFT OUTER JOIN Object AS Object_Unit
                                   ON Object_Unit.Id = _Cross.UnitId
        GROUP BY
            _Cross.JuridicalCode
           ,_Cross.UnitCode
           ,Object_Unit.ValueData
           ,_Cross.GoodsCode
           ,_Cross.GoodsName
           ,_Cross.OperCode;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION  gpReport_Upload_BaDM (TDateTime, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 23.11.15                                                                       *

*/

-- ����
-- SELECT * FROM gpReport_Upload_BaDM (inDate := '20151101'::TDateTime, inObjectId := 59610, inSession := '3')