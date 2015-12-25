DROP FUNCTION IF EXISTS gpSelect_Report_TaraMovement(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Integer,   --������ �������
    Integer,   --�����
    TVarChar,  --���� ����������
    Integer,   --��� ����� ��� "�� ���� / ����"
    TVarChar   --������ ������������
);
DROP FUNCTION IF EXISTS gpSelect_Report_TaraMovement(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Integer,   --������ �������
    Integer,   --�����
    TVarChar,  --���� ����������
    Integer,   --��� ����� ��� "�� ���� / ����"
    Integer,   --������ ������
    TVarChar   --������ ������������
);

CREATE OR REPLACE FUNCTION gpSelect_Report_TaraMovement(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inWhereObjectId  Integer,   --������ �������
    IN inGoodsId        Integer,   --�����
    IN inDescSet        TVarChar,  --���� ����������
    IN inMLODesc        Integer,   --��� ����� ��� "�� ���� / ����"
    IN inAccountGroupId Integer,   --������ ������
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     MovementId        Integer    --�� ���������
    ,InvNumber         TVarChar   --����� ���������
    ,OperDate          TDateTime  --���� ���������
    ,MovementDescId    Integer    --�� ���� ���������
    ,MovementDescName  TVarChar   --��� ���������
    ,LocationDescName  TVarChar   --��� ������� �������
    ,LocationCode      Integer    --��� ������� �������
    ,LocationName      TVarChar   --������ �������
    ,ObjectByDescName  TVarChar   --�� "�� ���� / ����"
    ,ObjectByCode      Integer    --��� "�� ���� / ����"
    ,ObjectByName      TVarChar   --������������ "�� ���� / ����"
    ,PaidKindName      TVarChar   --��� ������
    ,GoodsCode         Integer    --��� ������
    ,GoodsName         TVarChar   --������������ ������
    ,AccountGroupCode  Integer    --��� ������ ������
    ,AccountGroupName  TVarChar   --������������ ������ ������
    ,AmountIn          TFloat     --���-�� ������
    ,AmountOut         TFloat     --���-�� ������
    ,Price             TFloat     --����
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbIndex Integer;
    DECLARE vbDescId Integer;
    DECLARE vbContainerLinkObjectDesc Integer;
    DECLARE vbObjectDescId Integer;
    DECLARE vbMovementLinkObjectDesc Integer;
    DECLARE vbDirectMovement Integer;
    DECLARE vbIOMovement Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


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
        vbContainerLinkObjectDesc := zc_ContainerLinkObject_Partner();
    ELSEIF vbObjectDescId = zc_Object_Unit()
    THEN
        vbContainerLinkObjectDesc := zc_ContainerLinkObject_Unit();
    ELSEIF vbObjectDescId = zc_Object_Member()
    THEN
        vbContainerLinkObjectDesc := zc_ContainerLinkObject_Member();
    END IF;
    
    vbDirectMovement := 0;
    vbIOMovement := 0;
    -- ������� - MovementDesc - ���� ����������
    CREATE TEMP TABLE _tmpMovementDesc (DescId Integer) ON COMMIT DROP;
    -- ������ ���� ����������
    vbIndex := 1;
    WHILE split_part (inDescSet, ';', vbIndex) <> '' LOOP
        IF split_part (inDescSet, ';', vbIndex) = 'ExternalMovement'
        THEN 
            vbIOMovement := 1;
        ELSEIF split_part (inDescSet, ';', vbIndex) = 'InternalMovement'
        THEN
            vbIOMovement := 2;
        ELSEIF split_part (inDescSet, ';', vbIndex) = 'IN'
        THEN
            vbDirectMovement := 1;
        ELSEIF split_part (inDescSet, ';', vbIndex) = 'OUT'
        THEN
            vbDirectMovement := 2;
        ELSE
            -- ������
            EXECUTE 'SELECT ' || split_part (inDescSet, ';', vbIndex) INTO vbDescId;
            -- ��������� �� ��� �����
            INSERT INTO _tmpMovementDesc SELECT vbDescId;
        END IF;
        -- ������ ����������
        vbIndex := vbIndex + 1;
    END LOOP;

    
    -- ���������
    RETURN QUERY
        SELECT
            Movement.Id                                       AS MovementId    --�� ���������
           ,Movement.InvNumber                                AS InvNumber   --����� ���������
           ,Movement.OperDate                                 AS OperDate  --���� ���������
           ,MovementDesc.Id                                   AS MovementDescId    --�� ���� ���������
           ,MovementDesc.ItemName                             AS MovementDescName   --��� ���������
           ,ObjectDesc.ItemName                               AS LocationDescName   --��� ������� �������
           ,Object.ObjectCode                                 AS LocationCode    --��� ������� �������
           ,Object.ValueData                                  AS LocationName   --������ �������
           ,ObjectByDesc.ItemName                             AS ObjectByDescName   --�� "�� ���� / ����"
           ,ObjectBy.ObjectCode                               AS ObjectByCode    --��� "�� ���� / ����"
           ,ObjectBy.ValueData                                AS ObjectByName   --������������ "�� ���� / ����"
           ,Object_PaidKind.ValueData                         AS PaidKindName   --��� ������
           ,Object_Goods.ObjectCode                           AS GoodsCode    --��� ������
           ,Object_Goods.ValueData                            AS GoodsName    --������������ ������
           ,Object_AccountGroup.ObjectCode                    AS AccountGroupCode --��� ������ ������
           ,Object_AccountGroup.ValueData                     AS AccountGroupName --������������ ������ ������
           ,CASE WHEN MovementItemContainer.IsActive = TRUE 
                THEN MovementItemContainer.Amount
            ELSE 0
            END::TFloat                                       AS AmountIn     --���-�� ������
           ,CASE WHEN MovementItemContainer.IsActive = FALSE
                THEN -MovementItemContainer.Amount
            ELSE 0
            END::TFloat                                       AS AmountOut   --���-�� ������
           ,MIFloat_Price.ValueData                           AS Price     --����
        FROM
            _tmpMovementDesc
            INNER JOIN MovementItemContainer ON MovementItemContainer.MovementDescId = _tmpMovementDesc.DescId
                                            AND MovementItemContainer.Operdate between inStartDate AND inEndDate
                                            AND MovementItemContainer.ObjectId_Analyzer = inGoodsId
                                            AND MovementItemContainer.WhereObjectId_Analyzer = inWhereObjectId
            /*INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.ObjectId = inGoodsId*/
            LEFT JOIN Object AS Object_Goods
                              ON Object_Goods.Id = MovementItemContainer.ObjectId_Analyzer -- MovementItem.ObjectId
            LEFT JOIN Movement ON MovementItemContainer.MovementId = Movement.Id
            LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
            /*INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MovementItemContainer.ContainerId
                                          AND ContainerLinkObject.Descid = vbContainerLinkObjectDesc
                                          AND ContainerLinkObject.ObjectId = inWhereObjectId*/
            LEFT JOIN Object ON Object.Id = MovementItemContainer.WhereObjectId_Analyzer -- ContainerLinkObject.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
            /*LEFT OUTER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                              AND MovementLinkObject.DescId = inMLODesc*/
            LEFT OUTER JOIN Object AS ObjectBy
                                   ON ObjectBy.Id = MovementItemContainer.ObjectExtId_Analyzer -- MovementLinkObject.ObjectId
            LEFT OUTER JOIN ObjectDesc AS ObjectByDesc
                                       ON ObjectByDesc.Id = ObjectBy.DescId
            LEFT OUTER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                               ON MovementLinkObject_PaidKind.MovementId = Movement.ID
                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT OUTER JOIN Object AS Object_PaidKind
                                   ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT OUTER JOIN ContainerLinkObject AS CLO_Account
                                                ON CLO_Account.ContainerId = MovementItemContainer.ContainerId
                                               AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                       ON ObjectLink_Account_AccountGroup.ObjectId = CLO_Account.ObjectId
                                      AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
            LEFT OUTER JOIN Object AS Object_AccountGroup
                                   ON Object_AccountGroup.Id = COALESCE(ObjectLink_Account_AccountGroup.ChildObjectId,zc_Enum_AccountGroup_20000())
        WHERE
            (
                vbIOMovement = 0 --���������� � ������� ��������
                OR
                (
                    vbIOMovement = 1 --������ ������� ��������
                    AND
                    COALESCE(MIFloat_Price.ValueData,0)>0
                )
                OR
                (
                    vbIOMovement = 2 --������ ���������� ��������
                    AND
                    COALESCE(MIFloat_Price.ValueData,0)=0
                )
            )
            AND
            (
                vbDirectMovement = 0 --������ � ������
                OR
                (
                    vbDirectMovement = 1 -- ������ �������
                    AND
                    MovementItemContainer.IsActive = TRUE
                )
                OR
                (
                    vbDirectMovement = 2 --������ �������
                    AND
                    MovementItemContainer.IsActive = FALSE
                )
            )
            AND
            (
                inAccountGroupId = 0
                OR
                COALESCE(ObjectLink_Account_AccountGroup.ChildObjectId,zc_Enum_AccountGroup_20000()) = inAccountGroupId
            );
                                              
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_TaraMovement (TDateTime,TDateTime,Integer,Integer,TVarChar,Integer,Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 17.12.15                                                          *
*/
--Select * from gpSelect_Report_TaraMovement (inStartDate := '20150801'::TDateTime,inEndDate:='20150831'::TDateTime,inWhereObjectId:=80604::Integer,inGoodsId:=7946::Integer,inDescSet:='1'::TVarChar,inMLODesc:=2::Integer,inSession:= '5'::TVarChar);
