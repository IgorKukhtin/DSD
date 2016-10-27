DROP FUNCTION IF EXISTS gpSelect_Report_Tara_Print(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Integer,   --�� ������(������) �� ��������
    Integer,   --������ ������ / �����
    Integer,   --������ ������
    TVarChar   --������ ������������
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Tara_Print(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inWhereObjectId  Integer,   --�� ������(������) �� ��������
    IN inGoodsOrGroupId Integer,   --������ ������ / �����
    IN inAccountGroupId Integer,   --������ ������
    IN inSession        TVarChar   --������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbDescId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������� �������, � ������� ����� ������ ��� ������� �������
    CREATE TEMP TABLE _tmpWhereOject (Id Integer, ContainerDescId Integer, CLODescId Integer, ObjectType TVarChar) ON COMMIT DROP;
    -- ������� �������, � ������� ����� ������ ��� ������ ��� �������
    CREATE TEMP TABLE _tmpObject (Id Integer) ON COMMIT DROP;
    -- ������� ������� ���� �����������
    CREATE TEMP TABLE _tmpContainer (Id Integer, GoodsId Integer, WhereObjectId Integer, BranchId Integer, PaidKindId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    

    --���������� ������� �������
    --���� ������ ��������� ���������
    IF COALESCE (inWhereObjectId,0) <> 0 
    THEN
        -- ���������� ���� ������� �������
        SELECT Object.DescId INTO vbDescId FROM Object WHERE Object.Id = inWhereObjectId;
                
        IF vbDescId = zc_Object_Partner()
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
        END IF;
      END IF;   
        
    -- ����������� ������ �������
    IF COALESCE (inGoodsOrGroupId, 0) <> 0
    THEN
        -- ���������� ���� ����� ��� ������ �������
        IF zc_Object_Goods() = (SELECT Object.DescId FROM Object WHERE Object.Id = inGoodsOrGroupId)
        THEN
            -- ���� �����
            INSERT INTO _tmpObject (Id) VALUES (inGoodsOrGroupId);
        ELSE
            -- ���� ������ �������
            INSERT INTO _tmpObject (Id)
               SELECT lfSelect.GoodsId
               FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsOrGroupId) AS lfSelect;
        END IF;

    END IF;

    INSERT INTO _tmpContainer (Id , GoodsId , WhereObjectId , BranchId , PaidKindId , AccountGroupId , Amount )
                              SELECT Container.Id
                                   , Container.ObjectId        AS GoodsId       -- �����
                                   , _tmpWhereOject.Id         AS WhereObjectId -- ������ �������
                                   , CLO_Branch.ObjectId       AS BranchId      -- ������ ��� zc_ContainerLinkObject_Partner
                                   , CLO_PaidKind.ObjectId     AS PaidKindId    -- ������ ��� zc_ContainerLinkObject_Partner
                                   , COALESCE (ObjectLink_Account_AccountGroup.ChildObjectId, zc_Enum_AccountGroup_20000()) AS AccountGroupId -- ������ ������
                                   , Container.Amount          AS Amount        -- ������� �������
                              FROM _tmpObject
                                   INNER JOIN Container ON Container.ObjectId = _tmpObject.Id
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
                              WHERE inAccountGroupId = 0
                                  OR COALESCE (ObjectLink_Account_AccountGroup.ChildObjectId, zc_Enum_AccountGroup_20000()) = inAccountGroupId;
                
    OPEN Cursor1 FOR
        SELECT inStartDate   AS StartDate
             , inEndDate     AS EndDate
             , Object_UnitOrPartner.ValueData                        AS ObjectName      --������������ ������� �������
             , Object_GoodsOrGroup.ValueData                         AS GoodsOrGroupName      --������������ ������/��.������

             , SUM (tmp.Amount - COALESCE (tmp.MIC_Amount_Start, 0)) AS RemainsStart
             , SUM (tmp.Amount - COALESCE (tmp.MIC_Amount_End, 0))   AS RemainsEnd
        FROM (SELECT tmpContainer.Amount
                   , tmpContainer.Id
                   , SUM (MIContainer.Amount)                        AS MIC_Amount_Start  --��� �������� ����� ������ 
                   , SUM (CASE WHEN MIContainer.OperDate > inEndDate 
                               THEN MIContainer.Amount 
                               ELSE 0 END)                           AS MIC_Amount_End    --��� �������� ����� ���������
              FROM _tmpContainer AS tmpContainer
                  LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.ContainerId = tmpContainer.Id
                                                       AND MIContainer.OperDate >= inStartDate
              GROUP BY tmpContainer.Amount, tmpContainer.Id
              ) AS tmp
               LEFT JOIN Object AS Object_UnitOrPartner ON Object_UnitOrPartner.Id = inWhereObjectId
               LEFT JOIN Object AS Object_GoodsOrGroup ON Object_GoodsOrGroup.Id = inGoodsOrGroupId
        GROUP BY Object_UnitOrPartner.ValueData 
               , Object_GoodsOrGroup.ValueData 

        HAVING
              SUM (tmp.Amount - COALESCE (tmp.MIC_Amount_Start, 0)) <> 0 OR
              SUM (tmp.Amount - COALESCE (tmp.MIC_Amount_End, 0))  <> 0 
        ;

    RETURN NEXT Cursor1;
             
    
    -- ���������
    OPEN Cursor2 FOR
        WITH  DDD
        AS(
            SELECT
                DD.Id
               ,DD.MovementId
               ,DD.MovementDescId 
/*               ,DD.GoodsId
               ,DD.WhereObjectId
               ,DD.AccountGroupId
*/               ,DD.BranchId
               ,DD.PaidKindId

               , COALESCE (SUM (MIC_Amount_IN), 0)  :: TFloat       AS MIC_Amount_IN
               , COALESCE (SUM (MIC_Amount_OUT), 0) :: TFloat       AS MIC_Amount_OUT

            FROM(
                    SELECT
                         tmpContainer.Id
                       , MIContainer.MovementId
                       , MIContainer.MovementDescId 
                      /* , tmpContainer.GoodsId
                       , tmpContainer.WhereObjectId
                       , tmpContainer.AccountGroupId
                     */, tmpContainer.BranchId
                       , tmpContainer.PaidKindId
                                            
                       , SUM (CASE WHEN  MIContainer.OperDate <= inEndDate AND MIContainer.IsActive = TRUE 
                                   THEN MIContainer.Amount
                                   ELSE 0
                              END )::TFloat                                       AS MIC_Amount_IN     --���-�� ������
                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.IsActive = FALSE
                                   THEN (-1)* MIContainer.Amount
                                   ELSE 0
                              END) ::TFloat                                       AS MIC_Amount_OUT    --���-�� ������

                    FROM _tmpContainer AS tmpContainer
                        LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer.Id
                                                             AND MIContainer.OperDate >= inStartDate
                    GROUP BY
                         tmpContainer.Id
                       , MIContainer.MovementId
                       , MIContainer.MovementDescId 
                       , tmpContainer.BranchId
                       , tmpContainer.PaidKindId
                ) AS DD
            GROUP BY
                DD.Id
               ,DD.MovementId
               ,DD.MovementDescId 
               ,DD.BranchId
               ,DD.PaidKindId
            HAVING
                COALESCE(SUM(MIC_Amount_IN),0) <> 0 OR
                COALESCE(SUM(MIC_Amount_OUT),0) <> 0 
        )

        SELECT
            Movement.OperDate                                                     --���� ���������
           ,Movement.InvNumber                                                    --� ���������
           ,MovementDesc.ItemName                              AS MovementDescName--��� ���������
           ,Object_Branch.ValueData                            AS BranchName      --������ (��� �������)
           ,Object_PaidKind.ValueData                          AS PaidKindName
           ,DDD.MIC_Amount_IN   ::TFloat                       AS AmountIn        --������
           ,DDD.MIC_Amount_OUT  ::TFloat                       AS AmountOut       --������
            FROM DDD
            LEFT OUTER JOIN Movement ON Movement.Id = DDD.MovementId
            LEFT OUTER JOIN MovementDesc ON MovementDesc.Id = DDD.MovementDescId

            LEFT OUTER JOIN OBJECT AS Object_Branch
                                   ON Object_Branch.Id = DDD.BranchId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = DDD.PaidKindId

    ;
    RETURN NEXT Cursor2;

 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 26.10.16         *
*/

-- ����
--select * from gpSelect_Report_Tara_Print (inStartDate := ('30.08.2016')::TDateTime , inEndDate := ('31.08.2016')::TDateTime , inWhereObjectId := 630169 , inGoodsOrGroupId := 1865 , inAccountGroup := 0 ,  inSession := '5' ::TVarChar);