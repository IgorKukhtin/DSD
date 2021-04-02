-- Function: gpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP(
    IN inOperDate              TDateTime   , -- Месяц расчета
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
    vbUserId:= lpGetUserBySession (inSession);
    vbStartDate := date_trunc('month', inOperDate);
    vbEndDate := vbStartDate + INTERVAL '1 MONTH';

    SELECT Movement.ID
    INTO vbMovementId  
    FROM Movement 
    WHERE Movement.OperDate = vbStartDate
      AND Movement.DescId = zc_Movement_Wages();
      
    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
   
    PERFORM lpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP (ioId         := tmp.Id
                                                                  , inMovementId := vbMovementId
                                                                  , inUnitID     := tmp.UnitId
                                                                  , inSummaSP    := tmp.SummaSP
                                                                  , inUserId     := vbUserId)
    FROM (
    WITH
         -- список подразделений
          tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                      FROM ObjectLink AS ObjectLink_Unit_Juridical
                         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                              AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                      WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     )

        -- данные из проводок
        , tmpData_Container AS (SELECT MIContainer.MovementItemId AS MI_Id
                                     , COALESCE (MIContainer.AnalyzerId,0) :: Integer  AS MovementItemId
                                     , MIContainer.MovementId                          AS MovementId
                                     , MIContainer.WhereObjectId_analyzer              AS UnitId
                                     , SUM (COALESCE (-1 * MIContainer.Amount, 0))     AS Amount
                                     , COALESCE (MIContainer.ObjectIntId_analyzer,0)   AS ObjectIntId_analyzer
                                FROM MovementItemContainer AS MIContainer
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                WHERE MIContainer.DescId = zc_MIContainer_Count()
                                  AND MIContainer.MovementDescId = zc_Movement_Check()
                                  AND MIContainer.OperDate >= vbStartDate AND MIContainer.OperDate < vbEndDate
                                GROUP BY MIContainer.WhereObjectId_analyzer
                                       , COALESCE (MIContainer.AnalyzerId,0)
                                       , MIContainer.MovementItemId
                                       , MIContainer.MovementId
                                       , COALESCE (MIContainer.ObjectIntId_analyzer,0)
                               )

        -- док. соц проекта, если заполнен № рецепта
        , tmpMS_InvNumberSP AS (SELECT DISTINCT MovementString_InvNumberSP.MovementId
                                     , CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN TRUE ELSE FALSE END AS isSP_1303
                                FROM MovementString AS MovementString_InvNumberSP
                                --- разделить соц. про и пост 1303
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                                  ON MovementLinkObject_SPKind.MovementId = MovementString_InvNumberSP.MovementId
                                                                 AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()

                                WHERE MovementString_InvNumberSP.MovementId IN (SELECT DISTINCT tmpData_Container.MovementId FROM tmpData_Container)
                                  AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                  AND COALESCE (MovementString_InvNumberSP.ValueData, '') <> ''
                                )
                                           
        , tmpMIF_SummChangePercent AS (SELECT MIFloat_SummChangePercent.*
                                       FROM MovementItemFloat AS MIFloat_SummChangePercent
                                       WHERE MIFloat_SummChangePercent.DescId =  zc_MIFloat_SummChangePercent()
                                         AND MIFloat_SummChangePercent.MovementItemId IN (SELECT DISTINCT tmpData_Container.MI_Id FROM tmpData_Container)
                                      )
        , tmpSP AS (SELECT tmpData_Container.UnitId
                         , SUM (CASE WHEN tmpData_Container.isSP_1303 = TRUE  THEN COALESCE (MovementFloat_SummChangePercent.ValueData, 0) ELSE 0 END) AS SummChangePercent_SP1303
                         , SUM (CASE WHEN tmpData_Container.isSP_1303 = FALSE THEN COALESCE (MovementFloat_SummChangePercent.ValueData, 0) ELSE 0 END) AS SummChangePercent_SP
                    FROM (SELECT DISTINCT tmpData_Container.MI_Id
                               , tmpData_Container.UnitId
                               , tmpMS_InvNumberSP.isSP_1303
                          FROM tmpData_Container
                               INNER JOIN tmpMS_InvNumberSP ON tmpMS_InvNumberSP.MovementId = tmpData_Container.MovementId
                          ) AS tmpData_Container
                            -- сумма скидки SP
                            LEFT JOIN tmpMIF_SummChangePercent AS MovementFloat_SummChangePercent
                                                               ON MovementFloat_SummChangePercent.MovementItemId = tmpData_Container.MI_Id
                    GROUP BY tmpData_Container.UnitId
                    )
                    
        -- выбираем продажи по товарам соц.проекта 1303
        , tmpMovement_Sale AS (SELECT MovementLinkObject_Unit.ObjectId             AS UnitId
                                    , Movement_Sale.Id                             AS Id
                               FROM Movement AS Movement_Sale
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                    
                                    INNER JOIN MovementString AS MovementString_InvNumberSP
                                                              ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                                             AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                                             AND COALESCE (MovementString_InvNumberSP.ValueData,'') <> ''

                               WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                 AND Movement_Sale.OperDate >= vbStartDate AND Movement_Sale.OperDate < vbEndDate
                                 AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                               )
 
        , tmpSale_1303 AS (SELECT Movement_Sale.UnitId                    AS UnitId
                                , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                           FROM tmpMovement_Sale AS Movement_Sale
                                INNER JOIN MovementItem AS MI_Sale
                                                        ON MI_Sale.MovementId = Movement_Sale.Id
                                                       AND MI_Sale.DescId = zc_MI_Master()
                                                       AND MI_Sale.isErased = FALSE
                           
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                            ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                                           AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
  
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.MovementItemId = MI_Sale.Id
                                                               AND MIContainer.DescId = zc_MIContainer_Count() 
                           GROUP BY Movement_Sale.UnitId
                           ) 

    , tmpData_All AS (SELECT tmpSP.UnitId
                                     , COALESCE (tmpSP.SummChangePercent_SP, 0)               AS SummSale_SP
                                     , (COALESCE (tmpSale_1303.SummSale_1303, 0)
                                      + COALESCE (tmpSP.SummChangePercent_SP1303, 0))         AS SummSale_1303
                                FROM tmpSP 
                                     LEFT JOIN tmpSale_1303 ON tmpSale_1303.UnitId = tmpSP.UnitId
                      )
    , tmpMI AS ( SELECT MovementItem.Id                       AS Id
                      , MovementItem.ObjectId                 AS UnitID
                      , MIFloat_SummaSP.ValueData             AS SummaSP
            FROM  MovementItem

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaSP
                                              ON MIFloat_SummaSP.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaSP.DescId = zc_MIFloat_SummaSP()

            WHERE MovementItem.MovementId = vbMovementId
              AND MovementItem.DescId = zc_MI_Sign())
                         
     -- результат  
     SELECT tmpMI.ID
          , tmp.UnitId
          , ROUND((COALESCE (tmp.SummSale_SP,0) + COALESCE (tmp.SummSale_1303,0)) * 0.03, 2) AS SummaSP
     FROM tmpData_All AS tmp
          LEFT JOIN tmpMI ON tmpMI.UnitID = tmp.UnitId
     WHERE ROUND((COALESCE (tmp.SummSale_SP,0) + COALESCE (tmp.SummSale_1303,0)) * 0.03, 2) <> ROUND(COALESCE(tmpMI.SummaSP, 0), 2)) AS tmp;
              

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.21                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP (inOperDate := '31.03.2021', inSession:= '3')
