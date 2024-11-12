-- Function: gpSelect_Report_Tara()

DROP FUNCTION IF EXISTS gpSelect_Report_Tara (TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Tara(
    IN inStartDate      TDateTime, -- ���� ������ �������
    IN inEndDate        TDateTime, -- ���� ��������� �������
    IN inWithSupplier   Boolean,   -- �� ���� �����������
    IN inWithBayer      Boolean,   -- �� ���� �����������
    IN inWithPlace      Boolean,   -- �� ���� �������
    IN inWithBranch     Boolean,   -- �� ���� ��������
    IN inWithMember     Boolean,   -- �� ���� ���
    IN inWhereObjectId  Integer,   -- �� ������(������) �� ��������
    IN inGoodsOrGroupId Integer,   -- ������ ������ / �����
    IN inAccountGroupId Integer,   -- ������ ������
    IN inSession        TVarChar   -- ������ ������������
)
RETURNS TABLE(
      GoodsId               Integer   -- �� ������
    , GoodsCode             Integer   -- ��� ������
    , GoodsName             TVarChar  -- �����
    , GoodsGroupId          Integer   -- �� ������ ������
    , GoodsGroupCode        Integer   -- ��� ������ ������
    , GoodsGroupName        TVarChar  -- ������������ ������ ������
    , ObjectId              Integer   -- �� ������� �������
    , ObjectCode            Integer   -- ��� ������� �������
    , ObjectName            TVarChar  -- ������������ ������� �������
    , ObjectDescId          Integer   -- �� ���� �������
    , ObjectDescName        TVarChar  -- ������������ ���� �������
    , ObjectType            TVarChar  -- ��� ������� �������
    , BranchName            TVarChar  -- ������ (��� �������)
    , JuridicalId           Integer   -- �� ������ (��� ���������)
    , JuridicalName         TVarChar  -- ������ (��� ���������)
    , RetailName            TVarChar  -- �������� ���� (��� ���������)
    , AccountGroupId        Integer   -- �� ������ ������
    , AccountGroupCode      Integer   -- ��� ������ ������
    , AccountGroupName      TVarChar  -- ������������ ������ ������
    , PaidKindName          TVarChar

    , RemainsInActive       TFloat    -- ������� �� ������ �����
    , RemainsInPassive      TFloat    -- ������� �� ������ ������
    , RemainsIn             TFloat    -- ������� �� ������
    , AmountIn              TFloat    -- ������
    , AmountInBay           TFloat    -- �������
    , AmountOut             TFloat    -- ������
    , AmountOutSale         TFloat    -- �������
    , AmountInventory       TFloat    -- ��������������
    , AmountLoss            TFloat    -- ��������
    , RemainsOutActive      TFloat    -- ������� �� ����� �����
    , RemainsOutPassive     TFloat    -- ������� �� ����� ������
    , RemainsOut            TFloat    -- ������� �� �����
    , AmountPartner_out     TFloat    --
    , AmountPartner_in      TFloat    --
    )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- ������� �������, � ������� ����� ������ ��� ������� �������
    CREATE TEMP TABLE _tmpWhereOject (Id Integer, ContainerDescId Integer, CLODescId Integer, ObjectType TVarChar) ON COMMIT DROP;
    -- ������� �������, � ������� ����� ������ ��� ������ ��� �������
    CREATE TEMP TABLE _tmpOject (Id Integer) ON COMMIT DROP;

    --���������� ������� �������
    --���� ������ ��������� ���������
    IF COALESCE (inWhereObjectId,0) <> 0
    THEN
        -- ���������� ���� ������� �������
        SELECT Object.DescId INTO vbDescId FROM Object WHERE Object.Id = inWhereObjectId;

        IF vbDescId = zc_Object_Member()
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
                                VALUES (inWhereObjectId, zc_Container_Count(), zc_ContainerLinkObject_Member(),'���');


        ELSEIF vbDescId = zc_Object_Partner()
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
            SELECT inWhereObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(), '���������'
           UNION
            SELECT inWhereObjectId, zc_Container_Count(), zc_ContainerLinkObject_Partner(), '����������'
           ;

        ELSEIF vbDescId = zc_Object_Juridical()
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
            WITH tmp AS (SELECT ObjectLink_Partner_Juridical.ObjectId
                         FROM ObjectLink AS ObjectLink_Partner_Juridical
                         WHERE ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           AND ObjectLink_Partner_Juridical.ChildObjectId = inWhereObjectId
                        )
            SELECT tmp.ObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(), '���������' FROM tmp
           UNION
            SELECT tmp.ObjectId, zc_Container_Count(), zc_ContainerLinkObject_Partner(), '����������' FROM tmp
           ;

        ELSEIF vbDescId = zc_Object_Retail()
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
            WITH tmp AS (SELECT ObjectLink_Partner_Juridical.ObjectId
                         FROM ObjectLink AS ObjectLink_Juridical_Retail
                              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                   AND ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                         WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                           AND ObjectLink_Juridical_Retail.ChildObjectId = inWhereObjectId
                        )
            SELECT tmp.ObjectId, zc_Container_CountSupplier(), zc_ContainerLinkObject_Partner(), '���������' FROM tmp
           UNION
            SELECT tmp.ObjectId, zc_Container_Count(), zc_ContainerLinkObject_Partner(), '����������' FROM tmp
           ;


        ELSEIF vbDescId = zc_Object_Unit()
        THEN
            IF EXISTS(SELECT 1
                      FROM
                          Object AS Object_Unit
                          INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                      WHERE
                          Object_Unit.Id = inWhereObjectId
                          AND
                          COALESCE (ObjectLink_Unit_Branch.ChildObjectId,0) <> 0
                          AND
                          COALESCE (ObjectLink_Unit_Branch.ChildObjectId,0) <> zc_Branch_Basis())
            THEN
                INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
                Values(inWhereObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(),'������');
            ELSE
                INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
                Values(inWhereObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(),'�����');
            END IF;
        ELSEIF vbDescId = zc_Object_Branch()
        THEN
            IF inWhereObjectId <> zc_Branch_Basis()
            THEN
                INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
                SELECT ObjectLink_Unit_Branch.ObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '������'
                FROM
                    ObjectLink AS ObjectLink_Unit_Branch
                WHERE ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                  AND ObjectLink_Unit_Branch.ChildObjectId = inWhereObjectId;
            ELSE
                INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
                SELECT ObjectLink_Unit_Branch.ObjectId, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '�����'
                FROM
                    ObjectLink AS ObjectLink_Unit_Branch
                WHERE ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                  AND ObjectLink_Unit_Branch.ChildObjectId = inWhereObjectId;
            END IF;
        END IF;


    ELSE
        IF inWithSupplier = TRUE
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
               SELECT DISTINCT ContainerLinkObject.ObjectId, Container.DescId, ContainerLinkObject.DescId, '���������'
               FROM Container
                    INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Partner()
                                                  AND ContainerLinkObject.ObjectId > 0
               WHERE Container.DescId = zc_Container_CountSupplier();
        END IF;

        IF inWithBayer = TRUE
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
               SELECT DISTINCT ContainerLinkObject.ObjectId, Container.DescId, ContainerLinkObject.DescId, '����������'
               FROM Container
                    INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Partner()
                                                  AND ContainerLinkObject.ObjectId > 0
               WHERE Container.DescId = zc_Container_Count();
        END IF;

        IF inWithPlace = TRUE
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
            SELECT Object_Unit.Id, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '�����'
            FROM
                Object AS Object_Unit
                LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                           ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
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

        IF inWithBranch = TRUE
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
            SELECT Object_Unit.Id, zc_Container_Count(), zc_ContainerLinkObject_Unit(), '������'
            FROM
                Object AS Object_Unit
                INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                      ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                     AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            WHERE
                Object_Unit.DescId = zc_Object_Unit()
                AND
                COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) > 0
                AND
                COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) <> zc_Branch_Basis();
        END IF;

        IF inWithMember = TRUE
        THEN
            INSERT INTO _tmpWhereOject (Id, ContainerDescId, CLODescId, ObjectType)
            SELECT Object_Member.Id, zc_Container_Count(), zc_ContainerLinkObject_Member(), '���'
            FROM
                Object AS Object_Member
                INNER JOIN (SELECT DISTINCT CLO.ObjectId
                            FROM Container
                                INNER JOIN ContainerLinkObject AS CLO
                                                               ON CLO.ContainerId = Container.Id
                                                              AND CLO.DescId = zc_ContainerLinkObject_Member()
                            WHERE Container.DescId = zc_Container_Count()) AS CLO_Member
                                                                           ON CLO_Member.ObjectId = Object_Member.Id
            WHERE
                Object_Member.DescId = zc_Object_Member();
        END IF;
    END IF;

    -- ����������� ������ �������
    IF COALESCE (inGoodsOrGroupId, 0) <> 0
    THEN
        -- ���������� ���� ����� ��� ������ �������
        IF zc_Object_Goods() = (SELECT Object.DescId FROM Object WHERE Object.Id = inGoodsOrGroupId)
        THEN
            -- ���� �����
            INSERT INTO _tmpOject (Id) VALUES (inGoodsOrGroupId);
        ELSE
            -- ���� ������ �������
            INSERT INTO _tmpOject (Id)
               SELECT lfSelect.GoodsId
               FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsOrGroupId) AS lfSelect;
        END IF;

    END IF;
    
   CREATE TEMP TABLE tmpContainer ON COMMIT DROP
                          AS (SELECT Container.Id
                                   , Container.ObjectId        AS GoodsId       -- �����
                                   , _tmpWhereOject.Id         AS WhereObjectId -- ������ �������
                                   , _tmpWhereOject.ObjectType AS ObjectType    -- ��� ������� �������
                                   , CLO_Branch.ObjectId       AS BranchId      -- ������ ��� zc_ContainerLinkObject_Partner
                                   , CLO_PaidKind.ObjectId     AS PaidKindId    -- ������ ��� zc_ContainerLinkObject_Partner
                                   , COALESCE (ObjectLink_Account_AccountGroup.ChildObjectId, zc_Enum_AccountGroup_20000()) AS AccountGroupId -- ������ ������
                                   , Container.Amount          AS Amount        -- ������� �������
                              FROM _tmpOject
                                   INNER JOIN Container ON Container.ObjectId = _tmpOject.Id
                                                       -- AND Container.DescId IN (zc_Container_Count(), zc_Container_CountSupplier())
                                   INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                 -- AND ContainerLinkObject.DescId IN (zc_ContainerLinkObject_Partner(), zc_ContainerLinkObject_Unit(), zc_ContainerLinkObject_Member())
                                   INNER JOIN _tmpWhereOject ON _tmpWhereOject.Id              = ContainerLinkObject.ObjectId
                                                            AND _tmpWhereOject.ContainerDescId = Container.DescId
                                                            AND _tmpWhereOject.CLODescId       = ContainerLinkObject.DescId
                                   LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                                 ON CLO_Branch.ContainerId = Container.Id
                                                                AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                   LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                                 ON CLO_PaidKind.ContainerId = Container.Id
                                                                AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                   LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                 ON CLO_Account.ContainerId = Container.Id
                                                                AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                   LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                        ON ObjectLink_Account_AccountGroup.ObjectId = CLO_Account.ObjectId
                                                       AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
                              WHERE (inAccountGroupId = 0
                                  OR COALESCE (ObjectLink_Account_AccountGroup.ChildObjectId, zc_Enum_AccountGroup_20000()) = inAccountGroupId
                                    )
                             );


   CREATE TEMP TABLE tmpVirt ON COMMIT DROP
                     AS (SELECT MovementItem.ObjectId                 AS GoodsId
                              , MovementLinkObject_From.ObjectId      AS FromId
                              , MovementLinkObject_To.ObjectId        AS ToId
                              , SUM (MIFloat_AmountPartner.ValueData) AS AmountPartner
                         FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN _tmpWhereOject AS _tmpWhereOject_from ON _tmpWhereOject_from.Id = MovementLinkObject_From.ObjectId
                               LEFT JOIN _tmpWhereOject AS _tmpWhereOject_to   ON _tmpWhereOject_to.Id   = MovementLinkObject_To.ObjectId

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.Amount     = 0
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN _tmpOject ON _tmpOject.Id = MovementItem.ObjectId

                               INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                           AND MIFloat_AmountPartner.ValueData      > 0
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId   = zc_Movement_SendOnPrice()
                           AND (_tmpWhereOject_from.Id > 0 OR _tmpWhereOject_to.Id > 0)
                           AND vbDescId = zc_Object_Unit()
                         GROUP BY MovementItem.ObjectId
                                , MovementLinkObject_From.ObjectId
                                , MovementLinkObject_To.ObjectId
                        );

 RAISE EXCEPTION '������.<%>', (select count(*) from tmpVirt);
 RAISE EXCEPTION '������.<%>', (select count(*) from tmpContainer);


   CREATE TEMP TABLE DD ON COMMIT DROP
                AS (SELECT
                         tmpContainer.Id
                       , tmpContainer.GoodsId
                       , tmpContainer.WhereObjectId
                       , tmpContainer.ObjectType
                       , tmpContainer.Amount
                       , tmpContainer.BranchId
                       , tmpContainer.PaidKindId
                       , tmpContainer.AccountGroupId
                       , SUM (MIContainer.Amount) AS MIC_Amount_Start--��� �������� ����� ������
                       , SUM (CASE WHEN MIContainer.OperDate > inEndDate
                                  THEN MIContainer.Amount
                             ELSE 0 END)                                          AS MIC_Amount_End --��� �������� ����� ���������

                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                  AND MIContainer.IsActive = TRUE
                                  AND MIContainer.MovementDescId <> zc_Movement_Inventory()
                                  AND MIContainer.MovementDescId <> zc_Movement_Loss()
                                  AND NOT (MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnIn())
                                          AND
                                          COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_TareReturning())
                                 THEN MIContainer.Amount
                            ELSE 0 END)                                          AS MIC_Amount_IN -- ����������: ���������, ���������� �� ������
                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                  AND MIContainer.IsActive = TRUE
                                  AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnIn())
                                  AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_TareReturning()
                                 THEN MIContainer.Amount
                            ELSE 0 END)                                          AS MIC_Amount_INBay -- � �����: ���������, ���������� �� ������

                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                  AND MIContainer.IsActive = FALSE
                                  AND MIContainer.MovementDescId <> zc_Movement_Inventory()
                                  AND MIContainer.MovementDescId <> zc_Movement_Loss()
                                  AND NOT (MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                          AND
                                          COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_TareReturning())
                                 THEN MIContainer.Amount
                            ELSE 0 END)                                          AS MIC_Amount_OUT -- ����������: ���������, ���������� �� ������
                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                  AND MIContainer.IsActive = FALSE
                                  AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                  AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_TareReturning()
                                 THEN MIContainer.Amount
                            ELSE 0 END)                                          AS MIC_Amount_OUTSale -- � �����: ���������, ���������� �� ������

                       ,SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                  AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                 THEN MIContainer.Amount
                            ELSE 0 END)                                          AS MIC_Amount_Inventory -- �������������� �� ������
                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate
                                  AND MIContainer.MovementDescId = zc_Movement_Loss()
                                 THEN MIContainer.Amount
                            ELSE 0 END)                                          AS MIC_Amount_Loss -- �������� �� ������
                    FROM tmpContainer
                        LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer.Id
                                                             AND MIContainer.OperDate >= inStartDate
                    GROUP BY
                         tmpContainer.Id
                       , tmpContainer.GoodsId
                       , tmpContainer.WhereObjectId
                       , tmpContainer.ObjectType
                       , tmpContainer.Amount
                       , tmpContainer.BranchId
                       , tmpContainer.PaidKindId
                       , tmpContainer.AccountGroupId
                );

   CREATE TEMP TABLE DDD ON COMMIT DROP
        AS (SELECT
                DD.Id
               ,DD.GoodsId
               ,DD.WhereObjectId
               ,DD.ObjectType
               ,DD.AccountGroupId
               ,DD.BranchId
               ,DD.PaidKindId
               , COALESCE (SUM (DD.Amount), 0) :: TFloat            AS Amount
               , COALESCE (SUM (MIC_Amount_Start), 0) :: TFloat     AS MIC_Amount_Start
               , COALESCE (SUM (MIC_Amount_End), 0) :: TFloat       AS MIC_Amount_End
               , COALESCE (SUM (MIC_Amount_IN), 0) :: TFloat        AS MIC_Amount_IN
               , COALESCE (SUM (MIC_Amount_INBay), 0) :: TFloat     AS MIC_Amount_INBay
               , COALESCE (SUM (MIC_Amount_OUT), 0) :: TFloat       AS MIC_Amount_OUT
               , COALESCE (SUM (MIC_Amount_OUTSale), 0) :: TFloat   AS MIC_Amount_OUTSale
               , COALESCE (SUM (MIC_Amount_Inventory), 0) :: TFloat AS MIC_Amount_Inventory
               , COALESCE (SUM (MIC_Amount_Loss), 0) :: TFloat      AS MIC_Amount_Loss
            FROM DD
            GROUP BY
                DD.Id
               ,DD.GoodsId
               ,DD.WhereObjectId
               ,DD.ObjectType
               ,DD.AccountGroupId
               ,DD.BranchId
               ,DD.PaidKindId
               ,DD.Amount
            HAVING
                (COALESCE(SUM(DD.Amount),0)-COALESCE(SUM(MIC_Amount_Start),0)) <> 0 OR
                (COALESCE(SUM(DD.Amount),0)-COALESCE(SUM(MIC_Amount_End),0)) <> 0 OR
                COALESCE(SUM(MIC_Amount_IN),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_INBay),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_OUT),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_OUTSale),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_Inventory),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_Loss),0) <> 0
           );


    -- ���������
    RETURN QUERY
        SELECT
            Object_Goods.Id                                    AS GoodsId         --�� ������
           ,Object_Goods.ObjectCode                            AS GoodsCode       --��� ������
           ,Object_Goods.ValueData                             AS GoodsName       --�����
           ,Object_GoodsGroup.Id                               AS GoodsGroupId    --�� ������ ������
           ,Object_GoodsGroup.ObjectCode                       AS GoodsGroupCode  --��� ������ ������
           ,Object_GoodsGroup.ValueData                        AS GoodsGroupName  --������������ ������ ������
           ,DDD.WhereObjectId                                  AS ObjectId        --�� ������� �������
           ,Object_UnitOrPartner.ObjectCode                    AS ObjectCode      --��� ������� �������
           ,Object_UnitOrPartner.ValueData                     AS ObjectName      --������������ ������� �������
           ,Object_UnitOrPartner.DescId                        AS ObjectDescId    --�� ���� �������
           ,ObjectDesc.ItemName                                AS ObjectDescName  --������������ ���� �������
           ,DDD.ObjectType                                     AS ObjectType      --��� ������� �������
           ,Object_Branch.ValueData                            AS BranchName      --������ (��� �������)
           ,Object_Juridical.Id                                AS JuridicalId     --�� ������ (��� ���������)
           ,Object_Juridical.ValueData                         AS JuridicalName   --������ (��� ���������)
           ,Object_Retail.ValueData                            AS RetailName      --�������� ���� (��� ���������)
           ,Object_AccountGroup.Id                             AS AccountGroupId  --�� ������ ������
           ,Object_AccountGroup.ObjectCode                     AS AccountGroupCode--��� ������ ������
           ,Object_AccountGroup.ValueData                      AS AccountGroupName--������������ ������ ������
           ,Object_PaidKind.ValueData                          AS PaidKindName
           ,CASE WHEN (DDD.Amount-DDD.MIC_Amount_Start)>0
                 THEN (DDD.Amount-DDD.MIC_Amount_Start)
            END::TFloat                                        AS RemainsInActive --������� �� ������ �����
           ,CASE WHEN (DDD.Amount-DDD.MIC_Amount_Start)<0
                 THEN -(DDD.Amount-DDD.MIC_Amount_Start)
            END::TFloat                                        AS RemainsInPassive--������� �� ������ ������
           ,(DDD.Amount-DDD.MIC_Amount_Start)::TFloat AS RemainsIn       --������� �� ������
           ,DDD.MIC_Amount_IN                                  AS AmountIn        --������
           ,DDD.MIC_Amount_INBay                               AS AmountInBay     --�������
           ,(-DDD.MIC_Amount_OUT)::TFloat                      AS AmountOut       --������
           ,(-DDD.MIC_Amount_OUTSale)::TFloat                  AS AmountOutSale   --�������
           ,DDD.MIC_Amount_Inventory                           AS AmountInventory --��������������
           ,DDD.MIC_Amount_Loss                                AS AmountLoss      --��������
           ,CASE WHEN (DDD.Amount-DDD.MIC_Amount_End)>0
                 THEN (DDD.Amount-DDD.MIC_Amount_End)
            END::TFloat                                        AS RemainsOutActive --������� �� ����� �����
           ,CASE WHEN (DDD.Amount-DDD.MIC_Amount_End)<0
                 THEN -(DDD.Amount-DDD.MIC_Amount_End)
            END::TFloat                                        AS RemainsOutPassive--������� �� ����� ������
           , (DDD.Amount-DDD.MIC_Amount_End) :: TFloat         AS RemainsOut       --������� �� �����
           , tmpVirt_from.AmountPartner :: TFloat              AS AmountPartner_out
           , tmpVirt_to.AmountPartner   :: TFloat              AS AmountPartner_in
        FROM DDD
            LEFT JOIN (SELECT tmpVirt.GoodsId, tmpVirt.FromId, SUM (tmpVirt.AmountPartner) AS AmountPartner FROM tmpVirt GROUP BY tmpVirt.GoodsId, tmpVirt.FromId
                      ) AS tmpVirt_from ON tmpVirt_from.FromId  = DDD.WhereObjectId
                                       AND tmpVirt_from.GoodsId = DDD.GoodsId
                                       AND DDD.AccountGroupId   = zc_Enum_AccountGroup_20000()
            LEFT JOIN (SELECT tmpVirt.GoodsId, tmpVirt.ToId, SUM (tmpVirt.AmountPartner) AS AmountPartner FROM tmpVirt GROUP BY tmpVirt.GoodsId, tmpVirt.ToId
                      ) AS tmpVirt_to ON tmpVirt_to.ToId    = DDD.WhereObjectId
                                     AND tmpVirt_to.GoodsId = DDD.GoodsId
                                     AND DDD.AccountGroupId   = zc_Enum_AccountGroup_20000()

            LEFT OUTER JOIN Object AS Object_Goods ON Object_Goods.Id = DDD.GoodsId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT OUTER JOIN Object AS Object_GoodsGroup
                                   ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            LEFT OUTER JOIN Object AS Object_UnitOrPartner
                                   ON Object_UnitOrPartner.Id = DDD.WhereObjectId
            LEFT OUTER JOIN ObjectDesc ON Object_UnitOrPartner.DescId = ObjectDesc.Id
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                       ON ObjectLink_Unit_Branch.ObjectId = Object_UnitOrPartner.Id
                                      AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                      AND Object_UnitOrPartner.DescId = zc_Object_Unit()
            LEFT OUTER JOIN OBJECT AS Object_Branch
                                   ON Object_Branch.Id = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, DDD.BranchId)
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = DDD.PaidKindId

            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_UnitOrPartner.Id
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      AND Object_UnitOrPartner.DescId = zc_Object_Partner()
            LEFT OUTER JOIN OBJECT AS Object_Juridical
                                   ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                      AND Object_UnitOrPartner.DescId = zc_Object_Partner()
            LEFT OUTER JOIN OBJECT AS Object_Retail
                                   ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
            LEFT OUTER JOIN OBJECT AS Object_AccountGroup
                                   ON Object_AccountGroup.Id = DDD.AccountGroupId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 17.12.15                                                          *
*/

-- ����
-- SELECT * FROM gpSelect_Report_Tara (inStartDate := '20170101'::TDateTime, inEndDate:='20170131'::TDateTime, inWithSupplier:=FALSE, inWithBayer:=FALSE, inWithPlace:=FALSE, inWithBranch:=FALSE, inWithMember:=TRUE, inWhereObjectId:=0, inGoodsOrGroupId:=1865, inAccountGroupId:= 0, inSession:='5'::TVarChar);
