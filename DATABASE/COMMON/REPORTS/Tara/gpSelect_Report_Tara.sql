DROP FUNCTION IF EXISTS gpSelect_Report_Tara(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Boolean,   --�� ���� �����������
    Boolean,   --�� ���� �����������
    Boolean,   --�� ���� �������
    Boolean,   --�� ���� ��������
    Integer,   --�� ������(������) �� ��������
    Integer,   --������ ������ / �����
    TVarChar   --������ ������������
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Tara(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inWithSupplier   Boolean,   --�� ���� �����������
    IN inWithBayer      Boolean,   --�� ���� �����������
    IN inWithPlace      Boolean,   --�� ���� �������
    IN inWithBranch     Boolean,   --�� ���� ��������
    IN inWhereObjectId  Integer,   --�� ������(������) �� ��������
    IN inGoodsOrGroupId Integer,   --������ ������ / �����
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     GoodsId           Integer   --�� ������
    ,GoodsCode         Integer   --��� ������
    ,GoodsName         TVarChar  --�����
    ,GoodsGroupId      Integer   --�� ������ ������
    ,GoodsGroupCode    Integer   --��� ������ ������
    ,GoodsGroupName    TVarChar  --������������ ������ ������
    ,ObjectId          Integer   --�� ������� �������
    ,ObjectCode        Integer   --��� ������� �������
    ,ObjectName        TVarChar  --������������ ������� �������
    ,ObjectDescId      Integer   --�� ���� �������
    ,ObjectDescName    TVarChar  --������������ ���� �������
    ,ObjectType        TVarChar  --��� ������� �������
    ,BranchName        TVarChar  --������ (��� �������)
    ,JuridicalName     TVarChar  --������ (��� ���������)
    ,RetailName        TVarChar  --�������� ���� (��� ���������)
    
    ,RemainsInActive   TFloat    --������� �� ������ �����
    ,RemainsInPassive  TFloat    --������� �� ������ ������
    ,RemainsIn         TFloat    --������� �� ������
    ,AmountIn          TFloat    --������
    ,AmountOut         TFloat    --������
    ,AmountInventory   TFloat    --��������������
    ,RemainsOutActive  TFloat    --������� �� ����� �����
    ,RemainsOutPassive TFloat    --������� �� ����� ������
    ,RemainsOut        TFloat    --������� �� �����
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectDescId Integer;
    DECLARE vbGoodsDescId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    --������� �������, � ������� ����� ������ ��� ������� �������
    CREATE TEMP TABLE _Objects(Id Integer, ContainerDesc Integer, ContainerLinkDesc Integer, ObjectType TVarChar) ON COMMIT DROP;
    --������� �������, � ������� ����� ������ ��� ������ ��� �������
    CREATE TEMP TABLE _Goods(Id Integer) ON COMMIT DROP;
    
    --���������� ������� �������
    --���� ������ ��������� ���������
    IF COALESCE(inWhereObjectId,0) <> 0 
    THEN
        --���������� ���� ������� �������
        SELECT
            Object.DescId
        INTO
            vbObjectDescId
        FROM
            Object
        WHERE
            Object.Id = inWhereObjectId;
        
        IF vbObjectDescId = zc_Object_Partner()
        THEN
            IF EXISTS(SELECT 1 
                      FROM lfSelect_Object_Juridical_byGroup(8357) as Juridical 
                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ChildObjectId = Juridical.JuridicalId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                      Where
                          ObjectLink_Partner_Juridical.ObjectId = inWhereObjectId)
            THEN
                INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
                Values(inWhereObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(),'���������');
            ELSE
                INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
                Values(inWhereObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(),'����������');
            END IF;
        ELSEIF vbObjectDescId = zc_Object_Juridical()
        THEN
            INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
            SELECT ObjectLink_Partner_Juridical.ObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(),
              CASE WHEN Juridical.JuridicalId IS NOT NULL THEN '���������' ELSE '����������' END
            FROM ObjectLink AS ObjectLink_Partner_Juridical
                LEFT OUTER JOIN lfSelect_Object_Juridical_byGroup(8357) AS Juridical
                                                                        ON Juridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
            WHERE ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
              AND ObjectLink_Partner_Juridical.ChildObjectId = inWhereObjectId;
        ELSEIF vbObjectDescId = zc_Object_Retail()
        THEN
            INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
            SELECT ObjectLink_Partner_Juridical.ObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(),
              CASE WHEN Juridical.JuridicalId IS NOT NULL THEN '���������' ELSE '����������' END
            FROM
                ObjectLink AS ObjectLink_Juridical_Retail
                INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                      ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     AND ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                LEFT OUTER JOIN lfSelect_Object_Juridical_byGroup(8357) AS Juridical
                                                                        ON Juridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
            WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
              AND ObjectLink_Juridical_Retail.ChildObjectId = inWhereObjectId;
        ELSEIF vbObjectDescId = zc_Object_Unit()
        THEN
            IF EXISTS(SELECT 1
                      FROM
                          Object AS Object_Unit
                          INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.ID
                                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch() 
                      WHERE 
                          Object_Unit.Id = inWhereObjectId
                          AND 
                          COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) <> 0
                          AND
                          COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) <> zc_Branch_Basis())
            THEN
                INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
                Values(inWhereObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(),'������');
            ELSE
                INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
                Values(inWhereObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(),'�����');
            END IF;
        ELSEIF vbObjectDescId = zc_Object_Branch()
        THEN
            IF inWhereObjectId <> zc_Branch_Basis()
            THEN
                INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
                SELECT ObjectLink_Unit_Branch.ObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '������'
                FROM
                    ObjectLink AS ObjectLink_Unit_Branch
                WHERE ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                  AND ObjectLink_Unit_Branch.ChildObjectId = inWhereObjectId;
            ELSE
                INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
                SELECT ObjectLink_Unit_Branch.ObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '�����'
                FROM
                    ObjectLink AS ObjectLink_Unit_Branch
                WHERE ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                  AND ObjectLink_Unit_Branch.ChildObjectId = inWhereObjectId;
            END IF;
        END IF;
        
        
    ELSE --
        IF inWithSupplier = TRUE
        THEN
            INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
            SELECT ObjectLink_Partner_Juridical.ObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(), '���������'
            FROM 
                lfSelect_Object_Juridical_byGroup(8357) as Juridical
                INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                      ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     AND ObjectLink_Partner_Juridical.ChildObjectId = Juridical.JuridicalId;
        END IF;
        IF inWithBayer = TRUE
        THEN
            INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
            SELECT ObjectLink_Partner_Juridical.ObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(), '����������'
            FROM 
                Object AS Object_Partner
                LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.ID
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                LEFT OUTER JOIN lfSelect_Object_Juridical_byGroup(8357) as Juridical
                                                                        ON Juridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
            WHERE
                Object_Partner.DescId = zc_Object_Partner()
                AND 
                Juridical.JuridicalId is null;
        END IF;
        IF inWithPlace 
        THEN
            INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
            SELECT Object_Unit.Id, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '�����'
            FROM
                Object AS Object_Unit
                LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                           ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.ID
                                          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch() 
            WHERE 
                Object_Unit.DescId = zc_Object_Unit()
                AND 
                (
                    COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) = 0
                    OR
                    COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) = zc_Branch_Basis()
                );
        END IF;
        IF inWithBranch
        THEN
            INSERT INTO _Objects(Id, ContainerDesc, ContainerLinkDesc, ObjectType)
            SELECT Object_Unit.Id, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '������'
            FROM
                Object AS Object_Unit
                INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                      ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.ID
                                     AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch() 
            WHERE 
                Object_Unit.DescId = zc_Object_Unit()
                AND 
                COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) > 0
                AND
                COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) <> zc_Branch_Basis();
        END IF;
    END IF;
    
    --���������� ������ �������
    IF COALESCE(inGoodsOrGroupId,0) <> 0
    THEN
        --���������� ���� ����� ��� ������ �������
        SELECT
            Object.DescId
        INTO
            vbGoodsDescId
        FROM
            Object
        WHERE
            Object.Id = inGoodsOrGroupId;
        --���� �����
        IF vbGoodsDescId = zc_Object_Goods()
        THEN
            Insert Into _Goods(Id) Values (inGoodsOrGroupId);
        ELSEIF vbGoodsDescId = zc_Object_GoodsGroup() --���� ������ �������
        THEN
            Insert Into _Goods(Id)
            Select Goods.GoodsId
            FROM lfselect_object_goods_bygoodsgroup(inGoodsOrGroupId) AS Goods;
        END IF;
    END IF;
    
    -- ���������
    RETURN QUERY
        WITH DDD
        AS(
            SELECT
                DD.Id
               ,DD.GoodsId
               ,DD.ObjectId
               ,DD.ObjectType
               ,COALESCE(SUM(DD.ContainerAmount),0)::TFloat AS ContainerAmount
               ,COALESCE(SUM(MIC_Amount_Start),0)::TFloat   AS MIC_Amount_Start
               ,COALESCE(SUM(MIC_Amount_End),0)::TFloat     AS MIC_Amount_End
               ,COALESCE(SUM(MIC_Amount_IN),0)::TFloat      AS MIC_Amount_IN
               ,COALESCE(SUM(MIC_Amount_OUT),0)::TFloat     AS MIC_Amount_OUT
               ,COALESCE(SUM(MIC_Amount_Inventory),0)::TFloat     AS MIC_Amount_Inventory
            FROM(
                    SELECT
                        Container.Id
                       ,Container.ObjectId AS GoodsId --�����
                       ,_Objects.Id         AS ObjectId --������ �������
                       ,_Objects.ObjectType AS ObjectType --��� ������� �������
                       ,Container.Amount                                        AS ContainerAmount --������� �������
                       ,SUM(MovementItemContainer.Amount)                        AS MIC_Amount_Start--��� �������� ����� ������ 
                       ,SUM(CASE WHEN MovementItemContainer.OperDate > inEndDate 
                                 THEN MovementItemContainer.Amount 
                            ELSE 0 END)                                          AS MIC_Amount_End --��� �������� ����� ���������
                       ,SUM(CASE WHEN MovementItemContainer.OperDate <= inEndDate
                                  AND MovementItemContainer.IsActive = TRUE
                                  AND MovementItemContainer.MovementDescId <> zc_Movement_Inventory()
                                 THEN MovementItemContainer.Amount 
                            ELSE 0 END)                                          AS MIC_Amount_IN -- ������ �� ������
                       ,SUM(CASE WHEN MovementItemContainer.OperDate <= inEndDate
                                  AND MovementItemContainer.IsActive = FALSE
                                  AND MovementItemContainer.MovementDescId <> zc_Movement_Inventory()
                                 THEN MovementItemContainer.Amount 
                            ELSE 0 END)                                          AS MIC_Amount_OUT --������ �� ������
                       ,SUM(CASE WHEN MovementItemContainer.OperDate <= inEndDate
                                  AND MovementItemContainer.MovementDescId = zc_Movement_Inventory()
                                 THEN MovementItemContainer.Amount 
                            ELSE 0 END)                                          AS MIC_Amount_Inventory --�������������� �� ������
                    FROM
                        _Goods
                        INNER JOIN Container ON _Goods.Id = Container.ObjectId 
                                            AND Container.DescId in (zc_Container_Count(),zc_Container_CountSupplier())
                        INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                      AND ContainerLinkObject.DescId in (zc_ContainerLinkObject_Partner(),zc_ContainerLinkObject_Unit())
                        INNER JOIN _Objects ON Container.DescId = _Objects.ContainerDesc
                                           AND ContainerLinkObject.DescId = _Objects.ContainerLinkDesc
                                           AND ContainerLinkObject.ObjectId = _Objects.Id
                        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                             AND MovementItemContainer.OperDate >= inStartDate
                    GROUP BY
                        Container.Id
                       ,Container.ObjectId --�����
                       ,_Objects.Id
                       ,_Objects.ObjectType
                       ,Container.Amount
                ) AS DD
            GROUP BY
                DD.Id
               ,DD.GoodsId 
               ,DD.ObjectId
               ,DD.ObjectType
            HAVING
                (COALESCE(SUM(DD.ContainerAmount),0)-COALESCE(SUM(MIC_Amount_Start),0)) <> 0 OR
                (COALESCE(SUM(DD.ContainerAmount),0)-COALESCE(SUM(MIC_Amount_End),0)) <> 0 OR
                COALESCE(SUM(MIC_Amount_IN),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_OUT),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_Inventory),0) <> 0
        )
        SELECT
            Object_Goods.Id                                    AS GoodsId         --�� ������
           ,Object_Goods.ObjectCode                            AS GoodsCode       --��� ������
           ,Object_Goods.ValueData                             AS GoodsName       --�����
           ,Object_GoodsGroup.Id                               AS GoodsGroupId    --�� ������ ������
           ,Object_GoodsGroup.ObjectCode                       AS GoodsGroupCode  --��� ������ ������
           ,Object_GoodsGroup.ValueData                        AS GoodsGroupName  --������������ ������ ������
           ,DDD.ObjectId                                       AS ObjectId        --�� ������� �������
           ,Object_UnitOrPartner.ObjectCode                    AS ObjectCode      --��� ������� �������
           ,Object_UnitOrPartner.ValueData                     AS ObjectName      --������������ ������� �������
           ,Object_UnitOrPartner.DescId                        AS ObjectDescId    --�� ���� �������
           ,ObjectDesc.ItemName                                AS ObjectDescName  --������������ ���� �������
           ,DDD.ObjectType                                     AS ObjectType      --��� ������� �������
           ,Object_Branch.ValueData                            AS BranchName      --������ (��� �������)
           ,Object_Juridical.ValueData                         AS JuridicalName   --������ (��� ���������)
           ,Object_Retail.ValueData                            AS RetailName      --�������� ���� (��� ���������)
           ,CASE WHEN (DDD.ContainerAmount-DDD.MIC_Amount_Start)>0
                 THEN (DDD.ContainerAmount-DDD.MIC_Amount_Start)
            END::TFloat                                        AS RemainsInActive --������� �� ������ �����
           ,CASE WHEN (DDD.ContainerAmount-DDD.MIC_Amount_Start)<0
                 THEN -(DDD.ContainerAmount-DDD.MIC_Amount_Start)
            END::TFloat                                        AS RemainsInPassive--������� �� ������ ������
           ,(DDD.ContainerAmount-DDD.MIC_Amount_Start)::TFloat AS RemainsIn       --������� �� ������
           ,DDD.MIC_Amount_IN                                  AS AmountIn        --������
           ,(-DDD.MIC_Amount_OUT)::TFloat                        AS AmountOut       --������
           ,DDD.MIC_Amount_Inventory                           AS AmountInventory --��������������
           ,CASE WHEN (DDD.ContainerAmount-DDD.MIC_Amount_End)>0
                 THEN (DDD.ContainerAmount-DDD.MIC_Amount_End)
            END::TFloat                                        AS RemainsOutActive --������� �� ����� �����
           ,CASE WHEN (DDD.ContainerAmount-DDD.MIC_Amount_End)<0
                 THEN -(DDD.ContainerAmount-DDD.MIC_Amount_End)
            END::TFloat                                        AS RemainsOutPassive--������� �� ����� ������
           ,(DDD.ContainerAmount-DDD.MIC_Amount_End)::TFloat   AS RemainsOut       --������� �� �����
        FROM DDD
            LEFT OUTER JOIN Object AS Object_Goods ON Object_Goods.Id = DDD.GoodsId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup() 
            LEFT OUTER JOIN Object AS Object_GoodsGroup
                                   ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            LEFT OUTER JOIN Object AS Object_UnitOrPartner
                                   ON Object_UnitOrPartner.Id = DDD.ObjectId
            LEFT OUTER JOIN ObjectDesc ON Object_UnitOrPartner.DescId = ObjectDesc.Id
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                       ON ObjectLink_Unit_Branch.ObjectId = Object_UnitOrPartner.ID
                                      AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                      AND Object_UnitOrPartner.DescId = zc_Object_Unit()
            Left Outer Join Object AS Object_Branch
                                   ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId 
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_UnitOrPartner.ID
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      AND Object_UnitOrPartner.DescId = zc_Object_Partner()
            Left Outer Join Object AS Object_Juridical
                                   ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.ID
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                      AND Object_UnitOrPartner.DescId = zc_Object_Partner()
            Left Outer Join Object AS Object_Retail
                                   ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Tara (TDateTime,TDateTime,Boolean,Boolean,Boolean,Boolean,Integer,Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 17.12.15                                                          *
*/
--Select * from gpSelect_Report_Tara(inStartDate := '20150101'::TDateTime,inEndDate:='20150131'::TDateTime,inWithSupplier:=TRUE,inWithBayer:=FALSE,inWithPlace:=FALSE,inWithBranch:=FALSE,inWhereObjectId:=0,inGoodsOrGroupId:=1865,inSession:='5'::TVarChar);
