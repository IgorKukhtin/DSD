-- Function: gpSelect_Report_TaraMovement()

DROP FUNCTION IF EXISTS gpSelect_Report_TaraMovement (TDateTime, TDateTime, Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_TaraMovement(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inWhereObjectId  Integer,   --Объект анализа
    IN inGoodsId        Integer,   --Товар
    IN inDescSet        TVarChar,  --Типы документов
    IN inMLODesc        Integer,   --Тип связи для "От кого / кому"
    IN inAccountGroupId Integer,   --Группа счетов
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
      MovementId        Integer    --ИД документа
    , InvNumber         TVarChar   --Номер документа
    , OperDate          TDateTime  --Дата документа
    , MovementDescId    Integer    --ИД типа документа
    , MovementDescName  TVarChar   --Тип документа
    , LocationDescName  TVarChar   --Тип объекта анализа
    , LocationCode      Integer    --Код объекта анализа
    , LocationName      TVarChar   --Объект анализа
    , ObjectByDescName  TVarChar   --ИД "от кого / кому"
    , ObjectByCode      Integer    --Код "от кого / кому"
    , ObjectByName      TVarChar   --Наименование "от кого / кому"
    , PaidKindName      TVarChar   --Тип оплаты
    , GoodsCode         Integer    --Код товара
    , GoodsName         TVarChar   --Наименование товара
    , AccountGroupCode  Integer    --Код группы счетов
    , AccountGroupName  TVarChar   --Наименование группы счетов
    , AmountIn          TFloat     --Кол-во приход
    , AmountOut         TFloat     --Кол-во расход
    , AmountPartner_out     TFloat    --
    , AmountPartner_in      TFloat    --
    , AmountInf_out     TFloat    --
    , AmountInf_in      TFloat    --
    , Price             TFloat     --Цена
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
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
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
    -- таблица - MovementDesc - типы документов
    CREATE TEMP TABLE _tmpMovementDesc (DescId Integer) ON COMMIT DROP;
    -- парсим типы документов
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
            -- парсим
            EXECUTE 'SELECT ' || split_part (inDescSet, ';', vbIndex) INTO vbDescId;
            -- добавляем то что нашли
            INSERT INTO _tmpMovementDesc SELECT vbDescId;
        END IF;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;


    -- Результат
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
              -- Данные ИНФОРМАТИВНО
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
            Movement.Id                                       AS MovementId    --ИД документа
           ,Movement.InvNumber                                AS InvNumber   --Номер документа
           ,Movement.OperDate                                 AS OperDate  --Дата документа
           ,MovementDesc.Id                                   AS MovementDescId    --ИД типа документа
           ,MovementDesc.ItemName                             AS MovementDescName   --Тип документа
           ,ObjectDesc.ItemName                               AS LocationDescName   --Тип объекта анализа
           ,Object.ObjectCode                                 AS LocationCode    --Код объекта анализа
           ,Object.ValueData                                  AS LocationName   --Объект анализа
           ,ObjectByDesc.ItemName                             AS ObjectByDescName   --ИД "от кого / кому"
           ,ObjectBy.ObjectCode                               AS ObjectByCode    --Код "от кого / кому"
           ,ObjectBy.ValueData                                AS ObjectByName   --Наименование "от кого / кому"
           ,Object_PaidKind.ValueData                         AS PaidKindName   --Тип оплаты
           ,Object_Goods.ObjectCode                           AS GoodsCode    --Код товара
           ,Object_Goods.ValueData                            AS GoodsName    --Наименование товара
           ,Object_AccountGroup.ObjectCode                    AS AccountGroupCode --Код группы счетов
           ,Object_AccountGroup.ValueData                     AS AccountGroupName --Наименование группы счетов
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                THEN MovementItemContainer.Amount
            ELSE 0
            END::TFloat                                       AS AmountIn     --Кол-во приход
           ,CASE WHEN MovementItemContainer.IsActive = FALSE
                THEN -MovementItemContainer.Amount
            ELSE 0
            END::TFloat                                       AS AmountOut   --Кол-во расход
           , 0 :: TFloat                                      AS AmountPartner_out
           , 0 :: TFloat                                      AS AmountPartner_in
           , 0 :: TFloat                                      AS AmountInf_out
           , 0 :: TFloat                                      AS AmountInf_in

           , MIFloat_Price.ValueData                           AS Price     --Цена
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
                vbIOMovement = 0 --Внутренние и внешние операции
                OR
                (
                    vbIOMovement = 1 --Только внешние операции
                    AND
                    COALESCE (MIFloat_Price.ValueData, 0) > 0
                )
                OR
                (
                    vbIOMovement = 2 --Только внутренние операции
                    AND
                    COALESCE (MIFloat_Price.ValueData, 0) = 0
                )
            )
            AND
            (
                vbDirectMovement = 0 --Приход и расход
                OR
                (
                    vbDirectMovement = 1 -- Только приходы
                    AND
                    MovementItemContainer.IsActive = TRUE
                )
                OR
                (
                    vbDirectMovement = 2 --только расходы
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
            Movement.Id                                       AS MovementId    --ИД документа
           ,Movement.InvNumber                                AS InvNumber   --Номер документа
           ,Movement.OperDate                                 AS OperDate  --Дата документа
           ,MovementDesc.Id                                   AS MovementDescId    --ИД типа документа
           ,MovementDesc.ItemName                             AS MovementDescName   --Тип документа
           ,ObjectDesc.ItemName                               AS LocationDescName   --Тип объекта анализа
           ,Object.ObjectCode                                 AS LocationCode    --Код объекта анализа
           ,Object.ValueData                                  AS LocationName   --Объект анализа
           ,ObjectByDesc.ItemName                             AS ObjectByDescName   --ИД "от кого / кому"
           ,ObjectBy.ObjectCode                               AS ObjectByCode    --Код "от кого / кому"
           ,ObjectBy.ValueData                                AS ObjectByName   --Наименование "от кого / кому"
           ,Object_PaidKind.ValueData                         AS PaidKindName   --Тип оплаты
           ,Object_Goods.ObjectCode                           AS GoodsCode    --Код товара
           ,Object_Goods.ValueData                            AS GoodsName    --Наименование товара
           ,Object_AccountGroup.ObjectCode                    AS AccountGroupCode --Код группы счетов
           ,Object_AccountGroup.ValueData                     AS AccountGroupName --Наименование группы счетов
           , 0 :: TFloat                                      AS AmountIn     --Кол-во приход
           , 0 :: TFloat                                      AS AmountOut   --Кол-во расход
           , tmpVirt.AmountPartner_out :: TFloat              AS AmountPartner_out
           , tmpVirt.AmountPartner_in  :: TFloat              AS AmountPartner_in
           , 0 :: TFloat                                      AS AmountInf_out
           , 0 :: TFloat                                      AS AmountInf_in
           , 0 :: TFloat                                      AS Price     --Цена
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
                vbIOMovement = 0 --Внутренние и внешние операции
                OR
                (
                    vbIOMovement = 1 --Только внешние операции
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbIOMovement = 2 --Только внутренние операции
                    -- AND
                    -- COALESCE (MIFloat_Price.ValueData,0)=0
                )
            )
            AND
            (
                vbDirectMovement = 0 --Приход и расход
                OR
                (
                    vbDirectMovement = 1 -- Только приходы
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbDirectMovement = 2 --только расходы
                    -- AND
                    -- MovementItemContainer.IsActive = FALSE
                )
            )

       UNION ALL
        SELECT
            Movement.Id                                       AS MovementId    --ИД документа
           ,Movement.InvNumber                                AS InvNumber   --Номер документа
           ,Movement.OperDate                                 AS OperDate  --Дата документа
           ,MovementDesc.Id                                   AS MovementDescId    --ИД типа документа
           ,MovementDesc.ItemName                             AS MovementDescName   --Тип документа
           ,ObjectDesc.ItemName                               AS LocationDescName   --Тип объекта анализа
           ,Object.ObjectCode                                 AS LocationCode    --Код объекта анализа
           ,Object.ValueData                                  AS LocationName   --Объект анализа
           ,ObjectByDesc.ItemName                             AS ObjectByDescName   --ИД "от кого / кому"
           ,ObjectBy.ObjectCode                               AS ObjectByCode    --Код "от кого / кому"
           ,ObjectBy.ValueData                                AS ObjectByName   --Наименование "от кого / кому"
           ,Object_PaidKind.ValueData                         AS PaidKindName   --Тип оплаты
           ,Object_Goods.ObjectCode                           AS GoodsCode    --Код товара
           ,Object_Goods.ValueData                            AS GoodsName    --Наименование товара
           ,Object_AccountGroup.ObjectCode                    AS AccountGroupCode --Код группы счетов
           ,Object_AccountGroup.ValueData                     AS AccountGroupName --Наименование группы счетов
           , 0 :: TFloat                                      AS AmountIn     --Кол-во приход
           , 0 :: TFloat                                      AS AmountOut   --Кол-во расход
           , 0 :: TFloat                                      AS AmountPartner_out
           , 0 :: TFloat                                      AS AmountPartner_in
           , tmpInf.AmountPartner_out :: TFloat               AS AmountInf_out
           , tmpInf.AmountPartner_in  :: TFloat               AS AmountInf_in
           , 0 :: TFloat                                      AS Price     --Цена
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
                vbIOMovement = 0 --Внутренние и внешние операции
                OR
                (
                    vbIOMovement = 1 --Только внешние операции
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbIOMovement = 2 --Только внутренние операции
                    -- AND
                    -- COALESCE (MIFloat_Price.ValueData,0)=0
                )
            )
            AND
            (
                vbDirectMovement = 0 --Приход и расход
                OR
                (
                    vbDirectMovement = 1 -- Только приходы
                    -- AND
                    -- 1 = 0
                )
                OR
                (
                    vbDirectMovement = 2 --только расходы
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 17.12.15                                                          *
*/

-- SELECT * FROM gpSelect_Report_TaraMovement (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inWhereObjectId:=80604, inGoodsId:= 7946, inDescSet:= '1', inMLODesc:= 2, inAccountGroupId:= 0, inSession:= '5');
