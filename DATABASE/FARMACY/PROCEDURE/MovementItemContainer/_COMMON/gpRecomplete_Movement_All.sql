DROP FUNCTION IF EXISTS gpRecomplete_Movement_All (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpRecomplete_Movement_All(
    IN inStartDate          TDateTime,     -- Документы перепроводить с даты
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE(
    Id Integer,              --Ид документа
    OperDate TDateTime,      --Дата проведения
    DescId Integer,          --тип документа
    DescName TVarChar,       --Название типа документа
    DescOrder Integer,       --Порядок перепроведения
    RecompleteOk Boolean,    --Перепроведение прошло успешно
    RecompleteError TVarChar --Текст ошибки при перепроведении
)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;              --Ид документа
  DECLARE vbDescId Integer;          --тип документа
  DECLARE C_Movement refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    --создать временную таблицу, в которую поместить список документов, которые подлежат перепроведению
    CREATE TEMP TABLE _Movement(
        Id Integer,              --Ид документа
        OperDate TDateTime,      --Дата проведения
        DescId Integer,          --тип документа
        DescName TVarChar,       --Название типа документа
        DescOrder Integer,       --Порядок перепроведения
        RecompleteOk Boolean,    --Перепроведение прошло успешно
        RecompleteError TVarChar --Текст ошибки при перепроведении
        ) ON COMMIT DROP;
    --поместить список документов, которые подлежат перепроведению отсортировав по дате и типу документа
    INSERT INTO _Movement(
        Id,              --Ид документа
        OperDate,        --Дата проведения
        DescId,          --тип документа
        DescName,       --Название типа документа
        DescOrder,       --Порядок перепроведения
        RecompleteOk,    --Перепроведение прошло успешно
        RecompleteError) --Текст ошибки при перепроведении
    SELECT
        Movement.Id,              --Ид документа
        Movement.OperDate,        --Дата проведения
        Movement.DescId,          --тип документа
        Movement_Desc.DescName,   --Название типа документа
        Movement_Desc.DescOrder,  --Порядок перепроведения
        False,                    --Перепроведение прошло успешно
        NULL                      --Текст ошибки при перепроведении
    FROM
        Movement
        INNER JOIN (
                        SELECT 1 AS DescOrder, zc_Movement_Income() AS DescId, 'Приходы' AS DescName
                        UNION
                        SELECT 2 AS DescOrder, zc_Movement_Send() AS DescId, 'Пперемещения' AS DescName
                        UNION
                        SELECT 3 AS DescOrder, zc_Movement_Loss() AS DescId, 'Списания' AS DescName
                        UNION
                        SELECT 4 AS DescOrder, zc_Movement_ReturnOut() AS DescId, 'Возвраты поставщику' AS DescName
                        UNION
                        SELECT 5 AS DescOrder, zc_Movement_Check() AS DescId, 'Продажы на кассах' AS DescName
                        UNION
                        SELECT 6 AS DescOrder, zc_Movement_Inventory() AS DescId, 'Переучеты' AS DescName
                   ) AS Movement_Desc ON Movement.DescId = Movement_Desc.DescId
    WHERE
        Movement.OperDate >= inStartDate
        AND
        Movement.StatusId = zc_Enum_Status_Complete();

    OPEN C_Movement FOR
        SELECT _Movement.Id, _Movement.DescId
        FROM _Movement
        ORDER BY
            _Movement.OperDate,
            _Movement.DescOrder;
    LOOP
        FETCH C_Movement INTO vbId, vbDescId;
        IF NOT FOUND THEN EXIT; END IF;

        BEGIN
            IF vbDescId = zc_Movement_Income()
            THEN
                PERFORM gpReComplete_Movement_Income(inMovementId := vbId,
                                                     inSession := inSession);
            ELSEIF vbDescId = zc_Movement_Send()
            THEN
                PERFORM gpReComplete_Movement_Send(inMovementId := vbId,
                                                   inSession := inSession);
            ELSEIF vbDescId = zc_Movement_Loss()
            THEN
                PERFORM gpReComplete_Movement_Loss(inMovementId := vbId,
                                                   inSession := inSession);
            ELSEIF vbDescId = zc_Movement_ReturnOut()
            THEN
                PERFORM gpReComplete_Movement_ReturnOut(inMovementId := vbId,
                                                        inSession := inSession);
            ELSEIF vbDescId = zc_Movement_Check()
            THEN
                PERFORM gpReComplete_Movement_Check(inMovementId := vbId,
                                                    inSession := inSession);
            ELSEIF vbDescId = zc_Movement_Inventory()
            THEN
                PERFORM gpReComplete_Movement_Inventory(inMovementId := vbId,
                                                        inSession := inSession);
            END IF;

            UPDATE _Movement SET
                RecompleteOk = TRUE
            WHERE
                _Movement.Id = vbId;
            
            DROP TABLE IF EXISTS _tmpMIContainer_insert;
            DROP TABLE IF EXISTS _tmpMIReport_insert;
            DROP TABLE IF EXISTS _tmpItem;
            
        EXCEPTION
            WHEN OTHERS THEN
                UPDATE _Movement SET
                    RecompleteError = SQLERRM
                WHERE
                    _Movement.Id = vbId;
        END;
    END LOOP;
    CLOSE C_Movement;
    RETURN QUERY
    SELECT * FROM _Movement;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
Select * from gpRecomplete_Movement_All(inStartDate := '20150918',inSession := '3')
*/
