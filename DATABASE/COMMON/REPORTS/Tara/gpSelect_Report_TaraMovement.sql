-- Function: gpSelect_Report_TaraMovement()

DROP FUNCTION IF EXISTS gpSelect_Report_TaraMovement (TDateTime, TDateTime, Integer, Integer, TVarChar, Integer, Integer, TVarChar);

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
    , InvNumber         TVarChar   --����� ���������
    , OperDate          TDateTime  --���� ���������
    , MovementDescId    Integer    --�� ���� ���������
    , MovementDescName  TVarChar   --��� ���������
    , LocationDescName  TVarChar   --��� ������� �������
    , LocationCode      Integer    --��� ������� �������
    , LocationName      TVarChar   --������ �������
    , ObjectByDescName  TVarChar   --�� "�� ���� / ����"
    , ObjectByCode      Integer    --��� "�� ���� / ����"
    , ObjectByName      TVarChar   --������������ "�� ���� / ����"
    , PaidKindName      TVarChar   --��� ������
    , GoodsCode         Integer    --��� ������
    , GoodsName         TVarChar   --������������ ������
    , AccountGroupCode  Integer    --��� ������ ������
    , AccountGroupName  TVarChar   --������������ ������ ������
    , AmountIn          TFloat     --���-�� ������
    , AmountOut         TFloat     --���-�� ������
    , AmountPartner_out     TFloat    --
    , AmountPartner_in      TFloat    --
    , AmountInf_out     TFloat    --
    , AmountInf_in      TFloat    --
    , Price             TFloat     --����
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

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

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
        WITH tmpVirt AS (SELECT MovementItem.MovementId               AS MovementId
                              , MovementItem.ObjectId                 AS GoodsId
                              , CASE WHEN MovementLinkObject_From.ObjectId = inWhereObjectId
                                          THEN MovementLinkObject_To.ObjectId
                                     ELSE MovementLinkObject_From.ObjectId
                                END AS ObjectExtId_Analyzer
                              , SUM (CASE WHEN MovementLinkObject_From.ObjectId = inWhereObjectId THEN MIFloat_AmountPartner.ValueData ELSE 0 END) AS AmountPartner_out
                              , SUM (CASE WHEN MovementLinkObject_To.ObjectId   = inWhereObjectId THEN MIFloat_AmountPartner.ValueData ELSE 0 END) AS AmountPartner_in
                         FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.Amount     = 0
                                                      AND MovementItem.isErased   = FALSE
                                                      AND MovementItem.ObjectId   = inGoodsId

                               INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                           AND MIFloat_AmountPartner.ValueData      > 0
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId   = zc_Movement_SendOnPrice()
                           AND ((MovementLinkObject_From.ObjectId = inWhereObjectId AND vbDirectMovement = 2)
                             OR (MovementLinkObject_To.ObjectId   = inWhereObjectId AND vbDirectMovement = 1)
                               )
                         GROUP BY MovementItem.MovementId
                                , MovementItem.ObjectId
                                , MovementLinkObject_From.ObjectId
                                , MovementLinkObject_To.ObjectId
                        )
              -- ������ ������������
            , tmpInf AS (SELECT MovementItem.MovementId               AS MovementId
                              , MovementItem.ObjectId                 AS GoodsId
                              , CASE WHEN MovementLinkObject_From.ObjectId = inWhereObjectId
                                          THEN MovementLinkObject_To.ObjectId
                                     ELSE MovementLinkObject_From.ObjectId
                                END AS ObjectExtId_Analyzer
                              , SUM (CASE WHEN MovementLinkObject_From.ObjectId = inWhereObjectId THEN MIFloat_AmountPartner.ValueData ELSE 0 END) AS AmountPartner_in
                              , SUM (CASE WHEN MovementLinkObject_To.ObjectId   = inWhereObjectId THEN MovementItem.Amount             ELSE 0 END) AS AmountPartner_out
                         FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND MovementItem.ObjectId   = inGoodsId
                                                      AND MovementItem.Amount     <> 0

                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                          -- AND MIFloat_AmountPartner.ValueData      > 0
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId   = zc_Movement_SendOnPrice()
                           AND ((MovementLinkObject_From.ObjectId = inWhereObjectId AND vbDirectMovement = 2)
                             OR (MovementLinkObject_To.ObjectId   = inWhereObjectId AND vbDirectMovement = 1)
                               )
                         GROUP BY MovementItem.MovementId
                                , MovementItem.ObjectId
                                , MovementLinkObject_From.ObjectId
                                , MovementLinkObject_To.ObjectId
                        )
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
           , 0 :: TFloat                                      AS AmountPartner_out
           , 0 :: TFloat                                      AS AmountPartner_in
           , 0 :: TFloat                                      AS AmountInf_out
           , 0 :: TFloat                                      AS AmountInf_in

           , MIFloat_Price.ValueData                           AS Price     --����
        FROM
            _tmpMovementDesc
            INNER JOIN MovementItemContainer ON MovementItemContainer.MovementDescId         = _tmpMovementDesc.DescId
                                            AND MovementItemContainer.Operdate BETWEEN inStartDate AND inEndDate
                                            AND MovementItemContainer.ObjectId_Analyzer      = inGoodsId
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
                                             AND Movement.DescId      <> zc_Movement_SendOnPrice()

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
                    COALESCE (MIFloat_Price.ValueData, 0) > 0
                )
                OR
                (
                    vbIOMovement = 2 --������ ���������� ��������
                    AND
                    COALESCE (MIFloat_Price.ValueData, 0) = 0
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
            )
       UNION ALL
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
           , 0 :: TFloat                                      AS AmountIn     --���-�� ������
           , 0 :: TFloat                                      AS AmountOut   --���-�� ������
           , tmpVirt.AmountPartner_out :: TFloat              AS AmountPartner_out
           , tmpVirt.AmountPartner_in  :: TFloat              AS AmountPartner_in
           , 0 :: TFloat                                      AS AmountInf_out
           , 0 :: TFloat                                      AS AmountInf_in
           , 0 :: TFloat                                      AS Price     --����
        FROM
            tmpVirt
            INNER JOIN Movement ON Movement.Id         = tmpVirt.MovementId
            LEFT JOIN Object AS Object_Goods
                              ON Object_Goods.Id = tmpVirt.GoodsId

            LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
            LEFT JOIN Object ON Object.Id = inWhereObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
            LEFT OUTER JOIN Object AS ObjectBy
                                   ON ObjectBy.Id = tmpVirt.ObjectExtId_Analyzer -- MovementLinkObject.ObjectId
            LEFT OUTER JOIN ObjectDesc AS ObjectByDesc
                                       ON ObjectByDesc.Id = ObjectBy.DescId
            LEFT OUTER JOIN Object AS Object_PaidKind
                                   ON Object_PaidKind.Id = NULL
            LEFT OUTER JOIN Object AS Object_AccountGroup
                                   ON Object_AccountGroup.Id = zc_Enum_AccountGroup_20000()
        WHERE
            (
                vbIOMovement = 0 --���������� � ������� ��������
                OR
                (
                    vbIOMovement = 1 --������ ������� ��������
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbIOMovement = 2 --������ ���������� ��������
                    -- AND
                    -- COALESCE (MIFloat_Price.ValueData,0)=0
                )
            )
            AND
            (
                vbDirectMovement = 0 --������ � ������
                OR
                (
                    vbDirectMovement = 1 -- ������ �������
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbDirectMovement = 2 --������ �������
                    -- AND
                    -- MovementItemContainer.IsActive = FALSE
                )
            )

       UNION ALL
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
           , 0 :: TFloat                                      AS AmountIn     --���-�� ������
           , 0 :: TFloat                                      AS AmountOut   --���-�� ������
           , 0 :: TFloat                                      AS AmountPartner_out
           , 0 :: TFloat                                      AS AmountPartner_in
           , tmpInf.AmountPartner_out :: TFloat               AS AmountInf_out
           , tmpInf.AmountPartner_in  :: TFloat               AS AmountInf_in
           , 0 :: TFloat                                      AS Price     --����
        FROM
            tmpInf
            INNER JOIN Movement ON Movement.Id         = tmpInf.MovementId
            LEFT JOIN Object AS Object_Goods
                              ON Object_Goods.Id = tmpInf.GoodsId

            LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
            LEFT JOIN Object ON Object.Id = inWhereObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
            LEFT OUTER JOIN Object AS ObjectBy
                                   ON ObjectBy.Id = tmpInf.ObjectExtId_Analyzer -- MovementLinkObject.ObjectId
            LEFT OUTER JOIN ObjectDesc AS ObjectByDesc
                                       ON ObjectByDesc.Id = ObjectBy.DescId
            LEFT OUTER JOIN Object AS Object_PaidKind
                                   ON Object_PaidKind.Id = NULL
            LEFT OUTER JOIN Object AS Object_AccountGroup
                                   ON Object_AccountGroup.Id = zc_Enum_AccountGroup_20000()
        WHERE
            (
                vbIOMovement = 0 --���������� � ������� ��������
                OR
                (
                    vbIOMovement = 1 --������ ������� ��������
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbIOMovement = 2 --������ ���������� ��������
                    -- AND
                    -- COALESCE (MIFloat_Price.ValueData,0)=0
                )
            )
            AND
            (
                vbDirectMovement = 0 --������ � ������
                OR
                (
                    vbDirectMovement = 1 -- ������ �������
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbDirectMovement = 2 --������ �������
                    -- AND
                    -- MovementItemContainer.IsActive = FALSE
                )
            )
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_TaraMovement (TDateTime,TDateTime,Integer,Integer,TVarChar,Integer,Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 17.12.15                                                          *
*/

-- SELECT * FROM gpSelect_Report_TaraMovement (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inWhereObjectId:=80604, inGoodsId:= 7946, inDescSet:= '1', inMLODesc:= 2, inAccountGroupId:= 0, inSession:= '5');
